# Arquitetura de referência

Esta arquitetura é pública, conceitual e demonstrativa. Ela comunica responsabilidades sem reproduzir nomes de serviços, rotas, bancos, endereços, volumes ou configurações de qualquer ambiente real.

## Camadas

1. **Experiência web** — páginas responsivas com Blade e JavaScript.
2. **Aplicativo Android** — interface nativa em Kotlin e Compose, preparada para operação offline.
3. **Aplicação e API** — autenticação, autorização, validação e coordenação dos casos de uso.
4. **Serviços de domínio** — regras reutilizáveis por telas, painéis e relatórios.
5. **Persistência** — armazenamento relacional no servidor e base cifrada no dispositivo.
6. **Apresentação analítica** — indicadores e visualizações com caminho até o dado de origem.

## Princípios

- autorização aplicada no servidor;
- regras importantes isoladas e testáveis;
- uma mesma regra para tela, relatório e exportação;
- sincronização idempotente e orientada à conectividade;
- dados locais mínimos e protegidos;
- logs sem conteúdo sensível;
- configuração por ambiente sem segredos versionados;
- falhas apresentadas em linguagem adequada ao usuário.

Veja também o [diagrama conceitual](../diagramas/componentes.md).
