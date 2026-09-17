# Arquitetura de referência

Esta visão descreve uma arquitetura pública e conceitual. Ela demonstra as camadas e responsabilidades trabalhadas no projeto sem reproduzir topologia, nomes de serviços, rotas ou configurações do ambiente institucional.

## Camadas

1. **Interface web** — páginas responsivas construídas com Blade, Bootstrap e JavaScript.
2. **Aplicativo Android** — experiência nativa em Kotlin e Compose, preparada para operação offline.
3. **Aplicação HTTP e API** — rotas, validação de entrada, autenticação, autorização e controllers Laravel.
4. **Serviços de domínio** — regras reutilizáveis para formação, avaliação, disciplina e relatórios.
5. **Persistência** — modelos e consultas no MySQL, Redis para cache e SQLCipher no dispositivo.
6. **Entrega e análise** — Nginx na camada web e integração controlada com MicroStrategy.

## Princípios

- controllers pequenos e orientados à coordenação;
- regras relevantes concentradas em serviços testáveis;
- validação e autorização no servidor;
- consultas explícitas e índices adequados aos fluxos de leitura;
- mesmas regras de cálculo para tela, relatório e exportação;
- sincronização móvel resiliente, rastreável e orientada à conectividade;
- proteção de dados locais com criptografia e chaves geridas pelo sistema operacional;
- logs sem dados sensíveis e mensagens de erro adequadas ao público;
- configuração por ambiente sem segredos versionados.

Veja também o [diagrama de componentes](../diagramas/componentes.md).
