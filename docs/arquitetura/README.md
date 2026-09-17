# Arquitetura de referência

Esta visão descreve uma arquitetura pública e conceitual. Ela demonstra as camadas e responsabilidades trabalhadas no projeto sem reproduzir topologia, nomes de serviços, rotas ou configurações do ambiente institucional.

## Camadas

1. **Interface web** — páginas responsivas construídas com Blade, Bootstrap e JavaScript.
2. **Aplicação HTTP** — rotas, validação de entrada, autorização e controllers Laravel.
3. **Serviços de domínio** — regras reutilizáveis para avaliações, indicadores e relatórios.
4. **Persistência** — modelos e consultas no MySQL, com Redis para cache e dados temporários.
5. **Entrega e análise** — Nginx na camada web e integração controlada com MicroStrategy.

## Princípios

- controllers pequenos e orientados à coordenação;
- regras relevantes concentradas em serviços testáveis;
- validação e autorização no servidor;
- consultas explícitas e índices adequados aos fluxos de leitura;
- mesmas regras de cálculo para tela, relatório e exportação;
- logs sem dados sensíveis e mensagens de erro adequadas ao público;
- configuração por ambiente sem segredos versionados.

Veja também o [diagrama de componentes](../diagramas/componentes.md).
