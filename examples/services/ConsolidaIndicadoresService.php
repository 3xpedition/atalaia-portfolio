<?php

declare(strict_types=1);

namespace Portfolio\Services;

use Portfolio\Models\IndicadorAcademico;

final class ConsolidaIndicadoresService
{
    public function executar(array $filters): array
    {
        $query = IndicadorAcademico::query()
            ->noPeriodo($filters['inicio'], $filters['fim']);

        if (!empty($filters['turma'])) {
            $query->where('turma_referencia', $filters['turma']);
        }

        return $query
            ->orderBy('data_referencia')
            ->get()
            ->map(function (IndicadorAcademico $item): array {
                $previstas = max(0, $item->avaliacoes_previstas);
                $realizadas = min(max(0, $item->avaliacoes_realizadas), $previstas);

                return [
                    'turma' => $item->turma_referencia,
                    'data' => $item->data_referencia->format('Y-m-d'),
                    'progresso' => $previstas === 0
                        ? 0.0
                        : round(($realizadas / $previstas) * 100, 1),
                ];
            })
            ->values()
            ->all();
    }
}
