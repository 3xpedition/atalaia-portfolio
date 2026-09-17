# Aplicativo Android — visão técnica

O aplicativo móvel integra o ecossistema Atalaia e foi projetado para apoiar registros em campo mesmo quando a conexão com a rede não está disponível.

Esta documentação é conceitual e sanitizada: não publica código institucional, endereços de API, certificados, chaves, estruturas reais de banco ou dados de usuários.

## Experiência offline-first

1. Uma sessão autorizada prepara no dispositivo o conjunto mínimo de dados necessário à operação.
2. O usuário pode consultar informações e criar registros durante uma indisponibilidade de rede.
3. Cada registro pendente recebe uma identidade única e permanece em armazenamento local criptografado.
4. Quando a conectividade retorna, uma tarefa em segundo plano envia a fila e atualiza o snapshot local.
5. O aplicativo mantém o usuário informado sobre itens pendentes, tentativas e conclusão da sincronização.

## Stack móvel

- Kotlin e Jetpack Compose para a interface nativa;
- Material 3 para componentes e consistência visual;
- Retrofit e OkHttp para integração autenticada;
- WorkManager para sincronização condicionada à conectividade;
- SQLite protegido por SQLCipher;
- Android Keystore e AES-GCM para proteção de chaves e sessão;
- biometria forte para reentrada segura no modo offline.

## Decisões de segurança

- backup e extração de dados do aplicativo são restringidos;
- segredos não ficam gravados em texto aberto;
- a chave do banco é gerada no dispositivo e protegida pelo Keystore;
- a sessão offline pode exigir biometria vinculada a uma chave criptográfica;
- trocas de ambiente e encerramento de sessão respeitam registros ainda pendentes;
- comunicação e certificados seguem configuração explícita por ambiente.

O resultado é uma experiência móvel que mantém continuidade operacional sem tratar o modo offline como uma exceção improvisada.
