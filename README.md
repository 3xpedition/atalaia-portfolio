# Atalaia / COP Educação — Portfólio técnico

Portfólio público e independente sobre a experiência de desenvolvimento do **Atalaia / COP Educação**, um ecossistema web e mobile voltado à gestão do ciclo de formação, acompanhamento acadêmico e operação segura em campo.

> Este repositório contém apenas documentação e exemplos autorais, genéricos e sanitizados. O código-fonte completo, o histórico do projeto institucional, as configurações de ambiente e os dados de produção permanecem privados.

[Acessar o site do portfólio](https://3xpedition.github.io/atalaia-portfolio/) · [Ver os exemplos](examples/) · [Conhecer a arquitetura](docs/arquitetura/README.md)

## Visão geral

O Atalaia conecta dois contextos complementares de formação, regras acadêmicas, processos disciplinares, inteligência educacional e uma experiência Android offline-first. A solução combina cadastro, planejamento, lançamento, acompanhamento e relatórios com autorização no servidor e trilhas operacionais adequadas a diferentes perfis.

O material deste portfólio destaca decisões de engenharia, organização de código e experiência profissional sem revelar informações institucionais sensíveis.

## Tecnologias

- **Backend:** PHP, Laravel e API REST autenticada
- **Dados:** MySQL e Redis
- **Frontend:** Blade, JavaScript e Bootstrap
- **Mobile:** Kotlin, Jetpack Compose, WorkManager e Retrofit
- **Segurança mobile:** SQLCipher, Android Keystore e biometria
- **Infraestrutura:** Nginx e Git
- **Business intelligence:** MicroStrategy

## Seis frentes de produto

Os nomes abaixo organizam o portfólio por capacidades de negócio — não reproduzem menus internos nem substituem a nomenclatura institucional.

| Frente | Finalidade |
| --- | --- |
| Ciclo de Formação | Visão contínua de alunos, turmas, cursos, anos e situações acadêmicas. |
| Avaliação & Desempenho | Planejamento, aplicação, lançamento e consolidação de resultados acadêmicos e físicos. |
| Inteligência Educacional | Indicadores, painéis, relatórios e integrações analíticas para apoio à decisão. |
| Jornada Disciplinar | Registro e acompanhamento rastreável de fatos e seus desdobramentos. |
| Escolha de QMS | Distribuição assistida de vagas a partir de mérito e preferências. |
| Operação Móvel Offline | Aplicativo Android seguro para registrar informações em campo e sincronizar depois. |

## Android offline-first

O aplicativo Android foi pensado para cenários em que a conectividade pode oscilar. Ele permite trabalhar com dados previamente sincronizados, manter registros pendentes no dispositivo e reenviá-los automaticamente quando a rede volta.

Destaques técnicos da solução móvel:

- interface nativa em Kotlin, Jetpack Compose e Material 3;
- comunicação autenticada com a API por Retrofit e OkHttp;
- sincronização periódica e sob demanda com WorkManager;
- banco local criptografado com SQLCipher;
- chaves e tokens protegidos pelo Android Keystore com AES-GCM;
- acesso offline protegido por biometria forte;
- identificadores únicos para rastrear registros pendentes e evitar ambiguidades;
- política de backup restrita e configuração explícita de segurança de rede.

Veja a [visão técnica do aplicativo](docs/mobile/README.md).

## Atuação profissional

As responsabilidades apresentadas neste portfólio incluem:

- evolução e manutenção de aplicações Laravel com regras de negócio complexas;
- análise de requisitos e tradução de fluxos operacionais em funcionalidades;
- modelagem de consultas, indicadores e relatórios em MySQL;
- construção e manutenção de interfaces responsivas com Blade e Bootstrap;
- integração entre aplicação, cache, serviços web e ferramentas analíticas;
- desenvolvimento de aplicativo Android com experiência offline e sincronização resiliente;
- investigação de falhas, testes de regressão e melhoria contínua da qualidade;
- uso de Git para rastreabilidade, revisão e entrega segura de mudanças;
- cuidado com segurança, privacidade, autorização e consistência de dados.

## Destaques técnicos

- Separação entre controllers, serviços de domínio, modelos e apresentação.
- Regras de autorização aplicadas no backend, além dos controles de interface.
- Consultas e agregações voltadas à leitura eficiente de indicadores.
- Relatórios com regras centralizadas para reduzir divergências entre telas e exportações.
- Cache com Redis para fluxos de leitura e dados temporários.
- Arquitetura offline-first com fila local criptografada e sincronização em segundo plano.
- Proteção de sessão móvel com Keystore, AES-GCM e autenticação biométrica.
- Componentes de interface reutilizáveis e layouts responsivos.
- Validações automatizadas e revisão de segurança antes da publicação.

## Estrutura do repositório

```text
.
├── docs/
│   ├── index.html               # Site compatível com GitHub Pages
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
├── tests/                       # Validação estrutural e de segurança
├── LICENSE
└── README.md
```

## Exemplos demonstrativos

Os arquivos em [`examples/`](examples/) foram escritos exclusivamente para este portfólio. Nomes, estruturas e regras são fictícios e servem para demonstrar práticas como injeção de dependência, consultas agregadas, validação, transformação de dados e apresentação acessível.

Eles **não são cópias** de arquivos do repositório privado e não representam esquemas, credenciais, endpoints ou dados reais.

## Privacidade e escopo

Não são publicados neste repositório:

- código-fonte integral ou histórico Git do sistema institucional;
- credenciais, tokens, endereços internos ou nomes de bancos de produção;
- dados pessoais, acadêmicos ou operacionais reais;
- documentos, marcas ou configurações institucionais restritas;
- capturas de tela que identifiquem pessoas ou ambientes internos.

## Validação local

No PowerShell:

```powershell
pwsh -NoProfile -File tests/validate-portfolio.ps1
```

Os exemplos PHP também podem ser verificados individualmente com `php -l`.

## Licença

O conteúdo original e demonstrativo deste repositório é disponibilizado sob a [Licença MIT](LICENSE). Essa licença não se estende ao sistema institucional, a dados, marcas ou materiais que não estejam presentes aqui.
