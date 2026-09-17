<section class="container py-4" aria-labelledby="titulo-indicadores">
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-3">
        <div>
            <p class="text-uppercase text-muted small mb-1">Acompanhamento demonstrativo</p>
            <h2 id="titulo-indicadores" class="h4 mb-0">Indicadores por turma</h2>
        </div>
        <span class="badge badge-light">Dados fictícios</span>
    </div>

    <div class="row">
        @forelse ($indicadores as $indicador)
            <div class="col-md-6 col-xl-4 mb-3">
                <article class="card h-100 shadow-sm">
                    <div class="card-body">
                        <h3 class="h6">{{ $indicador['turma'] }}</h3>
                        <p class="display-4 mb-1">{{ number_format($indicador['progresso'], 1, ',', '.') }}%</p>
                        <p class="text-muted mb-0">Execução no período selecionado</p>
                    </div>
                </article>
            </div>
        @empty
            <div class="col-12">
                <div class="alert alert-info" role="status">
                    Não há indicadores para os filtros selecionados.
                </div>
            </div>
        @endforelse
    </div>
</section>
