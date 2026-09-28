# Exemplos de código

Exemplos autorais escritos para este portfólio a partir das regras reais do Atalaia e do Gavião. A lógica é a mesma do sistema; nomes de tabelas, classes e dados são fictícios, e nenhum arquivo foi copiado do repositório institucional.

## Fluxo de um tópico do Painel Oficial

1. [`controllers/PainelDesempenhoController.php`](controllers/PainelDesempenhoController.php): valida o recorte (ciclo e curso), confere a permissão no servidor e delega.
2. [`services/FaixaDesempenhoService.php`](services/FaixaDesempenhoService.php): classifica as notas nas faixas de cor. Mostra a mediana no lugar da média, separa "não avaliado" de zero e expressa cada faixa em % do efetivo.
3. [`views/painel-faixas.blade.php`](views/painel-faixas.blade.php): apresenta as faixas com cor fixa; cada uma é um botão que abre a lista de alunos.

## Regras isoladas

- [`sql/efetivo_evasao_ciclo.sql`](sql/efetivo_evasao_ciclo.sql): efetivo e evasão de um ciclo. O reintegrado entra na turma em que voltou, mas a saída dele pertence ao ciclo de origem; sem isso o total diverge do efetivo oficial.
- [`services/EscolhaQmsService.php`](services/EscolhaQmsService.php): distribuição das vagas de QMS por classificação decrescente e prioridades de cada aluno.
- [`js/quebras-naturais.js`](js/quebras-naturais.js): quebras naturais de Jenks, usadas nas faixas de cor do mapa do concurso.
- [`android/EnvioFoWorker.kt`](android/EnvioFoWorker.kt): envio da fila offline de Fatos Observados com WorkManager e identificador único contra duplicação.

## Como foram verificados

- As regras dos dois serviços PHP rodaram em PHP 7.3, a versão do sistema: faixas com limites inclusivos, mediana par e ímpar, grupo vazio, empate na classificação e independência da ordem de entrada.
- O Jenks rodou em Node contra grupos óbvios, valor isolado no topo, valores repetidos e entradas não numéricas.
- A consulta SQL rodou em MySQL 8 sobre tabelas temporárias com um reintegrado, desligados e um trancamento.
- O controller, a view e o arquivo Kotlin dependem de classes do Laravel e do Android que não fazem parte deste repositório, então só servem para leitura.

Nenhum exemplo depende do banco, das classes ou dos dados do sistema institucional.
