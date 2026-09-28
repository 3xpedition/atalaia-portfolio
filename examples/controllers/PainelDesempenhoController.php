<?php

declare(strict_types=1);

namespace Portfolio\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Portfolio\Repositories\NotasRepository;
use Portfolio\Services\FaixaDesempenhoService;

/**
 * Endpoint de um tópico do painel: devolve as faixas de um ciclo, já recortado.
 *
 * O controller só valida o recorte e coordena. Quem busca as notas é o
 * repositório; quem decide a faixa é o serviço. Assim a mesma regra serve
 * ao painel, ao PDF e à planilha sem ser reescrita em cada um.
 */
final class PainelDesempenhoController
{
    /** @var NotasRepository */
    private $notas;

    /** @var FaixaDesempenhoService */
    private $faixas;

    public function __construct(NotasRepository $notas, FaixaDesempenhoService $faixas)
    {
        $this->notas = $notas;
        $this->faixas = $faixas;
    }

    /**
     * Resumo de um ciclo, no todo ou recortado por curso.
     *
     * @param Request $request ciclo (obrigatório) e curso (opcional).
     * @return JsonResponse
     */
    public function resumo(Request $request): JsonResponse
    {
        $filtros = $request->validate([
            'ciclo' => ['required', 'integer', 'min:1'],
            'curso' => ['nullable', 'integer', 'min:1'],
        ]);

        // A permissão é checada aqui, no servidor: esconder o botão não basta.
        abort_unless($request->user()->podeVerCiclo((int) $filtros['ciclo']), 403);

        $notas = $this->notas->notaFinalPorAluno((int) $filtros['ciclo'], $filtros['curso'] ?? null);

        return response()->json($this->faixas->resumir($notas));
    }
}
