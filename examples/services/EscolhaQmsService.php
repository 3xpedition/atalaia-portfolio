<?php

declare(strict_types=1);

namespace Portfolio\Services;

/**
 * Distribui as vagas de QMS (Qualificação Militar de Sargentos) ao fim do 1º ano.
 *
 * A regra é de mérito: os alunos são atendidos em ordem decrescente de
 * classificação, e cada um recebe a sua prioridade mais alta que ainda tem
 * vaga. Quem vem antes na classificação nunca perde a vaga para quem vem
 * depois, e o resultado não depende da ordem em que os dados chegaram.
 *
 * Nomes de QMS, notas e o critério de desempate deste exemplo são fictícios.
 */
final class EscolhaQmsService
{
    /**
     * @param array<int, array{id: int, nota: float, prioridades: string[]}> $alunos
     * @param array<string, int> $vagas Vagas por QMS.
     * @return array{distribuicao: array<int, string|null>, vagas_restantes: array<string, int>}
     *         distribuicao: id do aluno => QMS recebida (null se nenhuma prioridade tinha vaga).
     */
    public function distribuir(array $alunos, array $vagas): array
    {
        usort($alunos, function (array $a, array $b): int {
            // Nota maior primeiro; no empate, o menor número (desempate demonstrativo).
            return [$b['nota'], $a['id']] <=> [$a['nota'], $b['id']];
        });

        $distribuicao = [];
        foreach ($alunos as $aluno) {
            $distribuicao[$aluno['id']] = null;

            foreach ($aluno['prioridades'] as $qms) {
                if (($vagas[$qms] ?? 0) > 0) {
                    $vagas[$qms]--;
                    $distribuicao[$aluno['id']] = $qms;
                    break;
                }
            }
        }

        return ['distribuicao' => $distribuicao, 'vagas_restantes' => $vagas];
    }
}
