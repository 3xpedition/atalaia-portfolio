# Atalaia & Gavião — Portfólio técnico

Portfólio público do **Atalaia** e do **Gavião**, os sistemas de gestão acadêmica da Escola de Sargentos das Armas (ESA), mantidos pelo COP Educação. O Atalaia acompanha o 1º ano do Curso de Formação e Graduação de Sargentos (Período Básico, nas UETEs); o Gavião, o 2º ano (Período de Qualificação, na ESA). Em produção desde 2020.

> Este repositório reúne documentação e exemplos autorais, genéricos e sanitizados. O código-fonte completo, o histórico institucional, as configurações internas e os dados de produção permanecem privados.

[Acessar o site](https://3xpedition.github.io/atalaia-portfolio/) · [Explorar exemplos no site](https://3xpedition.github.io/atalaia-portfolio/examples/) · [Ver o código demonstrativo](examples/) · [Conhecer a arquitetura](docs/arquitetura/README.md)

## O desafio

Uma jornada de formação produz informações em momentos, formatos e contextos diferentes: cadastro, planejamento, avaliações, desempenho físico, acompanhamento disciplinar, classificação, escolha de especialidade e relatórios gerenciais. O Atalaia nasceu para conectar esses fluxos e reduzir a distância entre o registro operacional e a decisão.

A plataforma atende dois contextos complementares — o Período Básico (Atalaia) e o Período de Qualificação (Gavião) — sobre a mesma base de código, com regras compartilhadas, perfis de acesso e dois bancos MySQL: um administrativo e o SSAA, das avaliações da qualificação. Em 2026, ganhou o Painel Oficial do Diretor e o app Android Gavião FO, para registro de Fato Observado em campo, sem rede.

## Ecossistema em quatro camadas

| Camada | Papel no produto |
| --- | --- |
| Experiência web | Operações administrativas, acadêmicas e gerenciais em interfaces responsivas. |
| Experiência móvel | Registro protegido em Android, inclusive sem conectividade, com sincronização posterior. |
| Domínio e integração | Regras de negócio, autorização no servidor, APIs e processos assíncronos. |
| Dados e decisão | Persistência em MySQL, relatórios em PDF e Excel e painéis de comando em D3.js. |

## Seis frentes de produto

Os nomes abaixo foram criados para comunicar as capacidades do produto no portfólio. Eles não reproduzem menus internos nem substituem a nomenclatura institucional.

### 1. Ciclo de Formação

Importação dos aprovados no concurso, matrícula por ano de formação, passagem do Básico para a Qualificação, reintegração e situações diversas (trancamento e desligamento, a pedido ou ex officio).

### 2. Avaliação & Desempenho

Calendário de provas, lançamento de graus (GBO) com 2ª chamada, índice de dificuldade por questão, recuperação e demonstrativo de notas com três casas decimais. O Treinamento Físico Militar (TFM) entra na média, com bônus para atletas.

### 3. Inteligência Educacional

Painel Oficial do Diretor: efetivo e evasão, desempenho cognitivo, físico e atitudinal, saúde, função de comando e concurso por região, com a série dos últimos cinco ciclos. Mediana no lugar da média, comparação em % do efetivo, escala de cor fixa e todo número clicável até a lista de alunos.

### 4. Jornada Disciplinar

Fato Observado (FO) positivo, neutro ou negativo, convertido em FATD quando cabe e arquivado na FRAD e na ROD. Encaminhamento em lote, aviso ao sargenteante por mensagem interna, e-mail e Telegram, e estatística por aluno e por observador.

### 5. Escolha de QMS

Distribuição das vagas de cada Qualificação Militar de Sargentos pela classificação decrescente dos alunos e pelas prioridades indicadas por cada um, com relatório final em planilha.

### 6. Operação Móvel Offline

App Android Gavião FO: mantém no aparelho os alunos que o observador pode ver, registra o Fato Observado sem conexão e sincroniza com o Gavião por uma API móvel dedicada quando a rede volta.

## Como a solução funciona

```text
Web responsiva ─┐
                ├─> API e aplicação Laravel ─> serviços de domínio ─> MySQL (administrativo + SSAA)
Android nativo ─┘              │                                      │
       │                       └─> autorização e auditoria             └─> PDF, Excel e painéis D3.js
       └─> SQLCipher + fila local + sincronização em segundo plano
```

- **Backend:** PHP 7.3, Laravel 5.8 e API móvel autenticada
- **Dados:** MySQL (dois bancos) e persistência local criptografada
- **Frontend:** Blade, JavaScript, jQuery, Bootstrap 5 e D3.js, tudo servido localmente (a Intranet bloqueia CDN)
- **Mobile:** Kotlin, Jetpack Compose, WorkManager, Retrofit e OkHttp
- **Segurança mobile:** SQLCipher, Android Keystore, AES-GCM e biometria
- **Infraestrutura:** Docker, Nginx e Git; deploy por pacote de PR com manifesto SHA-256
- **Integrações:** MQTT, e-mail e Telegram Bot API

## Android offline-first

O aplicativo foi desenhado para cenários em que a rede pode oscilar. A experiência separa claramente o que já foi sincronizado do que ainda depende de envio, evitando que conectividade instável interrompa o trabalho ou faça um registro desaparecer.

- interface nativa e reativa com Kotlin, Jetpack Compose e Material 3;
- comunicação autenticada com Retrofit e OkHttp;
- sincronização periódica e sob demanda com WorkManager;
- banco local criptografado com SQLCipher;
- chaves e sessão protegidas pelo Android Keystore e AES-GCM;
- acesso offline protegido por biometria forte;
- identificadores únicos para rastrear registros pendentes;
- política restritiva de backup e segurança de rede explícita.

Veja a [visão técnica do aplicativo](docs/mobile/README.md).

## Histórico e evolução

A linha do tempo sintetiza marcos observáveis no histórico do projeto principal. Ela descreve capacidades em alto nível e omite detalhes operacionais ou institucionais.

| Período | Evolução do produto |
| --- | --- |
| **2020 — Fundação** | Início do projeto e entrada em produção. Formação do núcleo acadêmico, relatórios, acompanhamento disciplinar, classificação e escolha de QMS. |
| **2021 — Expansão** | Ampliação para o contexto de qualificação, novos relatórios, importação de alunos e integração do desempenho físico aos demonstrativos. |
| **2022 — Integração** | Consolidação dos fluxos entre contextos, conteúdos atitudinais, gestão de disciplinas e evolução das integrações e exportações. |
| **2023–2024 — Maturidade operacional** | Evolução do calendário, índices de dificuldade, segunda chamada, análises de resultados, ciência do aluno e refinamento contínuo de regras e relatórios. |
| **2025 — Confiabilidade e recuperação** | Fortalecimento de rotinas de recuperação, situações acadêmicas diversas, segurança de consultas, backups e consistência dos demonstrativos. |
| **2026 — Mobilidade e inteligência** | Incorporação do aplicativo Android e de sua API, operação offline segura, automação de infraestrutura, novos painéis e avanço da cobertura de testes. |

Essa trajetória mostra a transformação de um sistema acadêmico central em um ecossistema multiplataforma, mantido por evolução incremental e adaptação contínua às regras de negócio.

## Atuação profissional

- evolução e manutenção de aplicações Laravel com regras de negócio complexas;
- análise de requisitos e tradução de fluxos operacionais em funcionalidades;
- modelagem de consultas, indicadores e relatórios em MySQL;
- construção de interfaces responsivas com Blade, JavaScript e Bootstrap;
- visualização de dados sob medida em SVG e D3.js, conferida contra os números oficiais;
- desenvolvimento Android com experiência offline e sincronização resiliente;
- investigação de falhas e testes com PHPUnit, Jest, PHPStan e PHPCS no pre-commit e no CI;
- uso de Git para rastreabilidade, revisão e entrega segura de mudanças;
- cuidado com segurança, privacidade, autorização e consistência de dados.

## Decisões e desafios de engenharia

- **Uma regra, várias saídas:** cálculos compartilhados evitam divergências entre tela, PDF, planilha e painel.
- **Autorização no backend:** a permissão é validada no servidor, não apenas escondida na interface.
- **Operação intermitente:** a fila móvel preserva a intenção do usuário até a confirmação do servidor.
- **Evolução compatível:** mudanças respeitam fluxos existentes e são acompanhadas por validação focada.
- **Privacidade por desenho:** o portfólio demonstra arquitetura e raciocínio sem replicar artefatos sensíveis.

## Estrutura do repositório

```text
.
├── docs/
│   ├── index.html               # Site publicado pelo GitHub Pages
│   ├── examples/index.html      # Navegação dos exemplos demonstrativos
│   ├── arquitetura/             # Visão arquitetural pública
│   ├── diagramas/               # Diagramas sanitizados
│   ├── mobile/                  # Arquitetura Android offline-first
│   └── screenshots/             # Política para imagens demonstrativas
├── examples/
│   ├── android/                 # Fila offline de FO com WorkManager
│   ├── controllers/             # Endpoint de um tópico do painel
│   ├── js/                      # Quebras naturais (Jenks) do mapa
│   ├── services/                # Faixas do painel e escolha de QMS
│   ├── sql/                     # Efetivo e evasão com reintegrado
│   └── views/                   # Faixas com cor fixa e número clicável
├── tests/                       # Validação estrutural, de links e segurança
├── LICENSE
└── README.md
```

## Exemplos demonstrativos

Os arquivos em [`examples/`](examples/) foram escritos exclusivamente para este portfólio, a partir das regras reais do sistema: as faixas do Painel Oficial (mediana, "não avaliado" separado de zero, % do efetivo), a evasão que conta o reintegrado no ciclo certo, a escolha de QMS por mérito, as quebras naturais de Jenks do mapa do concurso e a fila offline de FO do app. Nomes, tabelas e dados são fictícios.

Eles **não são cópias** do repositório privado e não representam esquemas, credenciais, endpoints ou dados reais.

## Privacidade e escopo

Não são publicados código integral ou histórico Git institucional, credenciais, tokens, endereços internos, nomes de bancos de produção, dados pessoais, documentos restritos ou capturas que identifiquem pessoas e ambientes internos.

## Validação local

```powershell
pwsh -NoProfile -File tests/validate-portfolio.ps1
```

Os exemplos PHP também podem ser verificados individualmente com `php -l`.

## Licença

O conteúdo original e demonstrativo deste repositório é disponibilizado sob a [Licença MIT](LICENSE). Essa licença não se estende ao sistema institucional, a dados, marcas ou materiais que não estejam presentes aqui.
