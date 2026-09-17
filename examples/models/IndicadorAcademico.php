<?php

declare(strict_types=1);

namespace Portfolio\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

final class IndicadorAcademico extends Model
{
    protected $table = 'indicadores_academicos_demo';

    protected $fillable = [
        'turma_referencia',
        'data_referencia',
        'avaliacoes_previstas',
        'avaliacoes_realizadas',
    ];

    protected $casts = [
        'data_referencia' => 'date',
        'avaliacoes_previstas' => 'integer',
        'avaliacoes_realizadas' => 'integer',
    ];

    public function scopeNoPeriodo(Builder $query, string $inicio, string $fim): Builder
    {
        return $query->whereBetween('data_referencia', [$inicio, $fim]);
    }
}
