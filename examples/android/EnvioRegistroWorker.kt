package portfolio.registros.sync

import android.content.Context
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import java.io.IOException
import java.util.concurrent.TimeUnit

/**
 * Envia ao servidor registros de acompanhamento criados sem rede.
 *
 * Cada registro nasce no aparelho com um UUID e permanece numa fila cifrada.
 * Se uma resposta se perder e o envio for repetido, o servidor reconhece a
 * mesma identidade e evita a duplicação.
 *
 * Interfaces, estruturas e nomes deste arquivo são fictícios.
 */
class EnvioRegistroWorker(
    context: Context,
    params: WorkerParameters,
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result {
        val fila = FilaRegistroLocal.abrir(applicationContext)
        val api = ApiRegistro.criar(applicationContext)

        for (registro in fila.pendentes()) {
            val status = try {
                api.enviar(registro.idUnico, registro.paraEnvio())
            } catch (erro: IOException) {
                return Result.retry()
            }

            when {
                status in 200..299 || status == 409 -> fila.marcarEnviado(registro.idUnico)
                status >= 500 -> return Result.retry()
                else -> fila.marcarRecusado(registro.idUnico, status)
            }
        }

        return Result.success()
    }

    companion object {
        private const val NOME_UNICO = "envio-registros"

        /** Agenda o envio periódico sem criar agendamentos duplicados. */
        fun agendar(context: Context) {
            val pedido = PeriodicWorkRequestBuilder<EnvioRegistroWorker>(15, TimeUnit.MINUTES)
                .setConstraints(
                    Constraints.Builder()
                        .setRequiredNetworkType(NetworkType.CONNECTED)
                        .build(),
                )
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 30, TimeUnit.SECONDS)
                .build()

            WorkManager.getInstance(context)
                .enqueueUniquePeriodicWork(NOME_UNICO, ExistingPeriodicWorkPolicy.KEEP, pedido)
        }
    }
}

data class RegistroPendente(
    val idUnico: String,
    val pessoaId: Long,
    val categoria: String,
    val relato: String,
) {
    fun paraEnvio(): Map<String, Any> = mapOf(
        "pessoa_id" to pessoaId,
        "categoria" to categoria,
        "relato" to relato,
    )
}

interface FilaRegistroLocal {
    fun pendentes(): List<RegistroPendente>
    fun marcarEnviado(idUnico: String)
    fun marcarRecusado(idUnico: String, status: Int)

    companion object {
        fun abrir(context: Context): FilaRegistroLocal =
            TODO("Banco SQLCipher com chave protegida pelo Android Keystore")
    }
}

interface ApiRegistro {
    suspend fun enviar(idUnico: String, corpo: Map<String, Any>): Int

    companion object {
        fun criar(context: Context): ApiRegistro = TODO("Retrofit + OkHttp com sessão autenticada")
    }
}
