# Aplicativo Android — visão técnica

O aplicativo demonstrado no portfólio apoia registros em campo e preserva a continuidade quando a conexão fica indisponível.

## Experiência offline-first

1. Uma sessão autorizada prepara o conjunto mínimo de dados necessário.
2. O usuário consulta informações e cria registros sem conexão.
3. Cada item recebe uma identidade única e permanece em armazenamento cifrado.
4. Quando a rede retorna, uma tarefa em segundo plano envia a fila.
5. O servidor reaplica autorização e evita registros duplicados.
6. O aplicativo informa claramente itens pendentes, recusados e concluídos.

## Tecnologias apresentadas

- Kotlin e Jetpack Compose;
- Retrofit e OkHttp;
- WorkManager com backoff exponencial;
- SQLite protegido por SQLCipher;
- Android Keystore e AES-GCM;
- biometria vinculada à proteção da sessão local.

Esta documentação não apresenta endpoints, certificados, estruturas reais, configurações ou dados de usuários.
