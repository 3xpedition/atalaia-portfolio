<?php

declare(strict_types=1);

namespace Portfolio\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Portfolio\Services\ConsolidaIndicadoresService;

final class IndicadorController
{
    private $service;

    public function __construct(ConsolidaIndicadoresService $service)
    {
        $this->service = $service;
    }

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'inicio' => ['required', 'date'],
            'fim' => ['required', 'date', 'after_or_equal:inicio'],
            'turma' => ['nullable', 'string', 'max:80'],
        ]);

        return response()->json([
            'data' => $this->service->executar($filters),
            'meta' => ['gerado_em' => now()->toIso8601String()],
        ]);
    }
}
