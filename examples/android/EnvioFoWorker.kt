package portfolio.fo.sync

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
 * Envia ao servidor os Fatos Observados registrados sem rede.
 *
 * Cada FO nasce no aparelho com um identificador único (UUID) e fica na fila
 * local, num banco cifrado com SQLCipher. O worker manda a fila quando há
 * conexão. Se a resposta se perder no caminho e o envio for repetido, o
 * servidor reconhece o mesmo identificador e responde 409: o registro já
 * existe, então sai da fila sem duplicar o FO.
 *
 * Interfaces e nomes deste arquivo são fictícios.
 */
class EnvioFoWorker(
    context: Context,
    params: WorkerParameters,
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result {
        val fila = FilaFoLocal.abrir(applicationContext)
        val api = ApiFo.criar(applicationContext)

        for (fo in fila.pendentes()) {
            val status = try {
                api.enviar(fo.idUnico, fo.paraEnvio())
            } catch (erro: IOException) {
                // Sem rede no meio do lote: o que já foi continua enviado,
                // o resto espera a próxima tentativa.
                return Result.retry()
            }

            when {
                status in 200..299 || status == 409 -> fila.marcarEnviado(fo.idUnico)
                status >= 500 -> return Result.retry()
                // 4xx: dado recusado. Fica marcado para o observador corrigir,
                // em vez de ser reenviado para sempre ou apagado em silêncio.
                else -> fila.marcarRecusado(fo.idUnico, status)
            }
        }

        return Result.success()
    }

    companion object {
        private const val NOME_UNICO = "envio-fo"

        /** Agenda o envio periódico; chamar de novo não cria um segundo agendamento. */
        fun agendar(context: Context) {
            val pedido = PeriodicWorkRequestBuilder<EnvioFoWorker>(15, TimeUnit.MINUTES)
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

/** Registro pendente na fila local. */
data class FoPendente(val idUnico: String, val alunoId: Long, val tipo: String, val relato: String) {
    fun paraEnvio(): Map<String, Any> = mapOf("aluno_id" to alunoId, "tipo" to tipo, "relato" to relato)
}

/** Fila local cifrada (implementação com SQLCipher omitida). */
interface FilaFoLocal {
    fun pendentes(): List<FoPendente>
    fun marcarEnviado(idUnico: String)
    fun marcarRecusado(idUnico: String, status: Int)

    companion object {
        fun abrir(context: Context): FilaFoLocal = TODO("Banco SQLCipher com chave guardada no Android Keystore")
    }
}

/** Cliente da API móvel (implementação com Retrofit omitida). */
interface ApiFo {
    /** Devolve o status HTTP da resposta. */
    suspend fun enviar(idUnico: String, corpo: Map<String, Any>): Int

    companion object {
        fun criar(context: Context): ApiFo = TODO("Retrofit + OkHttp com o token da sessão")
    }
}
