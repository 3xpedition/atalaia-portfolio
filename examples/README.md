# Exemplos técnicos públicos

Exemplos autorais escritos para demonstrar decisões de engenharia. Estruturas, classes e dados são fictícios; nenhum arquivo foi copiado de produto ou repositório privado.

## Fluxo de um indicador

1. [`controllers/PainelDesempenhoController.php`](controllers/PainelDesempenhoController.php) valida o recorte, aplica autorização e coordena.
2. [`services/FaixaDesempenhoService.php`](services/FaixaDesempenhoService.php) calcula mediana, faixas e percentuais.
3. [`views/painel-faixas.blade.php`](views/painel-faixas.blade.php) apresenta cada faixa como controle acessível.
4. [`sql/efetivo_evasao_ciclo.sql`](sql/efetivo_evasao_ciclo.sql) demonstra reconciliação de movimentações entre ciclos.

## Regras independentes

- [`services/DistribuicaoVagasService.php`](services/DistribuicaoVagasService.php): distribuição determinística por classificação, prioridades e disponibilidade.
- [`js/quebras-naturais.js`](js/quebras-naturais.js): algoritmo de Jenks para escalas visuais com valores extremos.
- [`android/EnvioRegistroWorker.kt`](android/EnvioRegistroWorker.kt): fila cifrada, identidade única, retentativa e tratamento de recusas.

## Limites

Os exemplos não dependem de banco, classes, endpoints ou dados privados. Eles comunicam padrões de projeto e preocupações técnicas, não a implementação integral de qualquer produto.
