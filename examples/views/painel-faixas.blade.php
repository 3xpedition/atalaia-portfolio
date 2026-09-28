{{--
    Faixas de um tópico do Painel Oficial. Recebe $resumo pronto do
    FaixaDesempenhoService: a view só apresenta, não calcula nada.

    As cores são fixas por faixa (azul, verde, amarelo, vermelho, e cinza para
    "não avaliado") e não variam com o tema do curso: a mesma cor significa a
    mesma coisa em todas as telas.
--}}
@php
    $rotulos = [
        'alto' => 'Alto desempenho',
        'adequado' => 'Adequado',
        'atencao' => 'Atenção',
        'critico' => 'Crítico',
        'nao_avaliado' => 'Não avaliado',
    ];
@endphp

<section class="painel-faixas" aria-labelledby="titulo-faixas">
    <header class="painel-faixas__topo">
        <h2 id="titulo-faixas">Desempenho cognitivo</h2>
        <p>
            Mediana
            <strong>{{ $resumo['mediana'] === null ? 'sem lançamento' : number_format($resumo['mediana'], 3, ',', '.') }}</strong>
            · {{ $resumo['avaliados'] }} avaliados de {{ $resumo['efetivo'] }}
        </p>
    </header>

    <div class="painel-faixas__cartoes">
        @foreach ($rotulos as $faixa => $rotulo)
            @php $dados = $resumo['faixas'][$faixa]; @endphp

            {{-- Todo número abre a lista de alunos que ele representa. --}}
            <button type="button"
                    class="painel-faixa painel-faixa--{{ $faixa }}"
                    data-alunos='@json($dados['alunos'])'
                    @if ($dados['total'] === 0) disabled @endif
                    aria-label="{{ $rotulo }}: {{ $dados['total'] }} alunos, {{ $dados['percentual'] }}% do efetivo. Ver lista.">
                <span class="painel-faixa__rotulo">{{ $rotulo }}</span>
                <strong class="painel-faixa__total">{{ $dados['total'] }}</strong>
                <span class="painel-faixa__pct">{{ number_format($dados['percentual'], 1, ',', '.') }}% do efetivo</span>
            </button>
        @endforeach
    </div>
</section>
