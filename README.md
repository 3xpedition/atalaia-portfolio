# Atalaia / COP Educação — Portfólio técnico

Portfólio público e independente sobre a evolução do **Atalaia / COP Educação**, um ecossistema web e mobile criado para apoiar a gestão do ciclo de formação, o acompanhamento acadêmico, processos disciplinares e a tomada de decisão orientada por dados.

> Este repositório reúne documentação e exemplos autorais, genéricos e sanitizados. O código-fonte completo, o histórico institucional, as configurações internas e os dados de produção permanecem privados.

[Acessar o site](https://3xpedition.github.io/atalaia-portfolio/) · [Explorar exemplos no site](https://3xpedition.github.io/atalaia-portfolio/examples/) · [Ver o código demonstrativo](examples/) · [Conhecer a arquitetura](docs/arquitetura/README.md)

## O desafio

Uma jornada de formação produz informações em momentos, formatos e contextos diferentes: cadastro, planejamento, avaliações, desempenho físico, acompanhamento disciplinar, classificação, escolha de especialidade e relatórios gerenciais. O Atalaia nasceu para conectar esses fluxos e reduzir a distância entre o registro operacional e a decisão.

A plataforma atende dois contextos complementares — formação básica e qualificação — por meio de regras compartilhadas, perfis de acesso e visões adequadas a cada etapa. Em 2026, esse ecossistema passou a incluir também uma experiência Android offline-first para trabalho em campo.

## Ecossistema em quatro camadas

| Camada | Papel no produto |
| --- | --- |
| Experiência web | Operações administrativas, acadêmicas e gerenciais em interfaces responsivas. |
| Experiência móvel | Registro protegido em Android, inclusive sem conectividade, com sincronização posterior. |
| Domínio e integração | Regras de negócio, autorização no servidor, APIs e processos assíncronos. |
| Dados e decisão | Persistência, cache, relatórios, indicadores e integração com business intelligence. |

## Seis frentes de produto

Os nomes abaixo foram criados para comunicar as capacidades do produto no portfólio. Eles não reproduzem menus internos nem substituem a nomenclatura institucional.

### 1. Ciclo de Formação

Organiza a jornada de alunos, turmas, cursos, anos, situações acadêmicas e transições entre etapas. Conecta o cadastro inicial às rotinas de acompanhamento e encerramento do ciclo.

### 2. Avaliação & Desempenho

Reúne planejamento, aplicação, lançamento e consolidação de avaliações acadêmicas e físicas. As regras são centralizadas para manter coerência entre telas, relatórios e exportações.

### 3. Inteligência Educacional

Transforma registros operacionais em indicadores, análises de resultados, painéis e relatórios. A camada analítica apoia a leitura de tendências sem duplicar as regras que definem os dados.

### 4. Jornada Disciplinar

Estrutura o registro, a tramitação e o acompanhamento de fatos com rastreabilidade. Perfis e autorizações limitam cada ação ao contexto e à responsabilidade do usuário.

### 5. Escolha de QMS

Apoia a distribuição de vagas a partir de classificação, mérito e preferências, preservando a associação entre cada participante e suas escolhas ao longo do processo.

### 6. Operação Móvel Offline

Leva fluxos selecionados ao Android para uso em campo. O aplicativo mantém um conjunto autorizado de dados no dispositivo, registra ações pendentes e sincroniza com o servidor quando a conectividade retorna.

## Como a solução funciona

```text
Web responsiva ─┐
                ├─> API e aplicação Laravel ─> serviços de domínio ─> MySQL / Redis
Android nativo ─┘              │                                      │
       │                       └─> autorização e auditoria             └─> relatórios e BI
       └─> SQLCipher + fila local + sincronização em segundo plano
```

- **Backend:** PHP, Laravel e API REST autenticada
- **Dados:** MySQL, Redis e persistência local criptografada
- **Frontend:** Blade, JavaScript e Bootstrap
- **Mobile:** Kotlin, Jetpack Compose, WorkManager, Retrofit e OkHttp
- **Segurança mobile:** SQLCipher, Android Keystore, AES-GCM e biometria
- **Infraestrutura:** Nginx, contêineres e Git
- **Business intelligence:** MicroStrategy

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
- integração entre aplicação, cache, serviços web e ferramentas analíticas;
- desenvolvimento Android com experiência offline e sincronização resiliente;
- investigação de falhas, testes de regressão e melhoria contínua da qualidade;
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
│   ├── controllers/             # Exemplo autoral de camada HTTP
│   ├── models/                  # Modelo fictício e genérico
│   ├── services/                # Regra de negócio demonstrativa
│   ├── sql/                     # Consulta sobre dados fictícios
│   └── views/                   # Componente Blade demonstrativo
├── tests/                       # Validação estrutural, de links e segurança
├── LICENSE
└── README.md
```

## Exemplos demonstrativos

Os arquivos em [`examples/`](examples/) foram escritos exclusivamente para este portfólio. Nomes, estruturas e regras são fictícios e demonstram injeção de dependência, consultas agregadas, validação, transformação de dados e apresentação acessível.

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
