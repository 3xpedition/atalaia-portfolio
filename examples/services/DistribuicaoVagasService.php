<?php

declare(strict_types=1);

namespace Portfolio\Services;

/**
 * Distribui vagas de trilhas formativas ao fim de um ciclo demonstrativo.
 *
 * Pessoas são atendidas em ordem decrescente de classificação, e cada uma
 * recebe a prioridade mais alta que ainda possui vaga. O resultado não
 * depende da ordem em que os dados chegaram.
 *
 * Nomes de trilhas, notas e critérios deste exemplo são fictícios.
 */
final class DistribuicaoVagasService
{
    /**
     * @param array<int, array{id: int, nota: float, prioridades: string[]}> $pessoas
     * @param array<string, int> $vagas Vagas por trilha.
     * @return array{distribuicao: array<int, string|null>, vagas_restantes: array<string, int>}
     */
    public function distribuir(array $pessoas, array $vagas): array
    {
        usort($pessoas, function (array $a, array $b): int {
            return [$b['nota'], $a['id']] <=> [$a['nota'], $b['id']];
        });

        $distribuicao = [];
        foreach ($pessoas as $pessoa) {
            $distribuicao[$pessoa['id']] = null;

            foreach ($pessoa['prioridades'] as $trilha) {
                if (($vagas[$trilha] ?? 0) > 0) {
                    $vagas[$trilha]--;
                    $distribuicao[$pessoa['id']] = $trilha;
                    break;
                }
            }
        }

        return ['distribuicao' => $distribuicao, 'vagas_restantes' => $vagas];
    }
}
