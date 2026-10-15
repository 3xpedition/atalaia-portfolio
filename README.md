# Atalaia & Gavião — portfólio técnico independente

Estudo de caso público de uma plataforma web e móvel para gestão educacional, acompanhamento de desempenho e operação offline.

[Acessar o portfólio](https://3xpedition.github.io/atalaia-portfolio/) · [Explorar exemplos](https://3xpedition.github.io/atalaia-portfolio/examples/) · [Arquitetura conceitual](docs/arquitetura/README.md)

## O que o portfólio apresenta

- gestão de ciclos, grupos, participantes e avaliações;
- painéis gerenciais com caminho do indicador até o registro de origem;
- relatórios e exportações derivados das mesmas regras de domínio;
- aplicativo Android offline-first, com fila idempotente e sincronização resiliente;
- autorização no servidor, rastreabilidade e proteção do armazenamento local;
- exemplos autorais em PHP, SQL, JavaScript, Blade e Kotlin.

## Uma publicação deliberadamente demonstrativa

O site foi construído sem screenshots, vídeos, fotografias, logotipos ou documentos de ambientes reais. Todas as interfaces são mockups em HTML e CSS criados exclusivamente para esta apresentação. Nomes, números, grupos, métricas e situações são fictícios.

Este portfólio:

- não é canal oficial e não representa ou endossa qualquer organização;
- não reproduz identidade visual, menus ou topologia de ambientes privados;
- não publica dados pessoais, documentos, credenciais, endereços ou configurações;
- não contém cópia do código-fonte privado;
- não depende de imagens de terceiros ou conteúdo apenas borrado.

## Arquitetura conceitual

```text
Web responsiva ─┐
                ├─> API e aplicação ─> serviços de domínio ─> persistência
Android offline ┘         │                       │
                          └─ autorização          └─ painéis e relatórios
```

Stack apresentada: Laravel, PHP, MySQL, Blade, JavaScript, D3.js, Kotlin, Jetpack Compose, WorkManager, SQLCipher e Git.

## Laboratório público

Os arquivos em [`examples/`](examples/) são exemplos pequenos, independentes e escritos para o portfólio:

- [`PainelDesempenhoController.php`](examples/controllers/PainelDesempenhoController.php) — validação e autorização;
- [`FaixaDesempenhoService.php`](examples/services/FaixaDesempenhoService.php) — classificação consistente;
- [`painel-faixas.blade.php`](examples/views/painel-faixas.blade.php) — apresentação acessível;
- [`efetivo_evasao_ciclo.sql`](examples/sql/efetivo_evasao_ciclo.sql) — reconciliação de ciclos;
- [`DistribuicaoVagasService.php`](examples/services/DistribuicaoVagasService.php) — prioridade e disponibilidade;
- [`quebras-naturais.js`](examples/js/quebras-naturais.js) — escala visual por Jenks;
- [`EnvioRegistroWorker.kt`](examples/android/EnvioRegistroWorker.kt) — fila offline idempotente.

## Validação

```powershell
pwsh -NoProfile -File tests/validate-portfolio.ps1
```

O validador confere arquivos, links locais, ausência de binários e extensões proibidas, termos institucionais, possíveis segredos, endereços privados e o aviso de escopo público seguro.

## Licença

O conteúdo demonstrativo original deste repositório é disponibilizado sob a [Licença MIT](LICENSE). A licença não se estende a produtos, dados, marcas ou materiais privados que não estejam presentes aqui.
