# Atalaia / COP Educação — Portfólio técnico

Portfólio público e independente sobre a experiência de desenvolvimento do **Atalaia / COP Educação**, uma plataforma web voltada ao apoio de processos educacionais, acompanhamento acadêmico e consolidação de indicadores.

> Este repositório contém apenas documentação e exemplos autorais, genéricos e sanitizados. O código-fonte completo, o histórico do projeto institucional, as configurações de ambiente e os dados de produção permanecem privados.

[Acessar o site do portfólio](https://3xpedition.github.io/atalaia-portfolio/) · [Ver os exemplos](examples/) · [Conhecer a arquitetura](docs/arquitetura/README.md)

## Visão geral

O Atalaia centraliza fluxos acadêmicos que antes exigiam consultas e consolidações dispersas. A solução combina cadastro, planejamento, lançamento, acompanhamento e relatórios em uma interface única, com regras de negócio no servidor e trilhas operacionais adequadas a diferentes perfis.

O material deste portfólio destaca decisões de engenharia, organização de código e experiência profissional sem revelar informações institucionais sensíveis.

## Tecnologias

- **Backend:** PHP e Laravel
- **Dados:** MySQL e Redis
- **Frontend:** Blade, JavaScript e Bootstrap
- **Infraestrutura:** Nginx e Git
- **Business intelligence:** MicroStrategy

## Módulos em destaque

| Módulo | Finalidade |
| --- | --- |
| Calendário de Avaliações | Planejamento e visualização de atividades avaliativas por período. |
| Índice de Dificuldades | Registro e acompanhamento estruturado de dificuldades de aprendizagem. |
| Relatórios | Consolidação de indicadores para análise e apoio à decisão. |
| TFM | Apoio aos fluxos de avaliação e acompanhamento do treinamento físico. |
| Lança Local | Registro controlado de informações em cenários operacionais específicos. |
| Conteúdos Atitudinais | Acompanhamento de dimensões comportamentais e formativas. |

## Atuação profissional

As responsabilidades apresentadas neste portfólio incluem:

- evolução e manutenção de aplicações Laravel com regras de negócio complexas;
- análise de requisitos e tradução de fluxos operacionais em funcionalidades;
- modelagem de consultas, indicadores e relatórios em MySQL;
- construção e manutenção de interfaces responsivas com Blade e Bootstrap;
- integração entre aplicação, cache, serviços web e ferramentas analíticas;
- investigação de falhas, testes de regressão e melhoria contínua da qualidade;
- uso de Git para rastreabilidade, revisão e entrega segura de mudanças;
- cuidado com segurança, privacidade, autorização e consistência de dados.

## Destaques técnicos

- Separação entre controllers, serviços de domínio, modelos e apresentação.
- Regras de autorização aplicadas no backend, além dos controles de interface.
- Consultas e agregações voltadas à leitura eficiente de indicadores.
- Relatórios com regras centralizadas para reduzir divergências entre telas e exportações.
- Cache com Redis para fluxos de leitura e dados temporários.
- Componentes de interface reutilizáveis e layouts responsivos.
- Validações automatizadas e revisão de segurança antes da publicação.

## Estrutura do repositório

```text
.
├── docs/
│   ├── index.html               # Site compatível com GitHub Pages
│   ├── arquitetura/             # Visão arquitetural pública
│   ├── diagramas/               # Diagramas sanitizados
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
