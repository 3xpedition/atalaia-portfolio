<?php

declare(strict_types=1);

namespace Portfolio\Services;

use InvalidArgumentException;

/**
 * Classifica as notas de um grupo nas faixas de cor do Painel Oficial.
 *
 * Regras demonstradas, as mesmas do painel real (a régua aqui é fictícia):
 * - o número de destaque é a MEDIANA: um aluno com nota muito baixa não
 *   arrasta o retrato da turma inteira, como aconteceria com a média;
 * - nota não lançada é "não avaliado", nunca zero. Zero é nota; ausência
 *   de lançamento é outra coisa e ganha fatia própria;
 * - cada faixa sai em quantidade E em percentual do efetivo, para comparar
 *   cursos de tamanhos diferentes sem distorção;
 * - cada faixa carrega os ids dos alunos, porque no painel todo número
 *   abre a lista de quem está por trás dele.
 */
final class FaixaDesempenhoService
{
    /** Ordem de exibição do colorímetro: do melhor para o pior. */
    public const FAIXAS = ['alto', 'adequado', 'atencao', 'critico'];

    public const NAO_AVALIADO = 'nao_avaliado';

    /** @var array<string, float> Limite inferior (inclusivo) de cada faixa. */
    private $regua;

    /**
     * @param array<string, float> $regua Limites de 'alto', 'adequado' e 'atencao';
     *                                    abaixo de 'atencao' é 'critico'.
     */
    public function __construct(array $regua = ['alto' => 8.0, 'adequado' => 6.0, 'atencao' => 5.0])
    {
        if (!($regua['alto'] > $regua['adequado'] && $regua['adequado'] > $regua['atencao'])) {
            throw new InvalidArgumentException('A régua precisa ser decrescente: alto > adequado > atencao.');
        }

        $this->regua = $regua;
    }

    /**
     * Resume um grupo de alunos.
     *
     * @param array<int, float|null> $notas Nota de cada aluno, indexada pelo id; null = não lançada.
     * @return array{efetivo: int, avaliados: int, mediana: float|null, faixas: array<string, array>}
     */
    public function resumir(array $notas): array
    {
        $grupos = array_fill_keys(array_merge(self::FAIXAS, [self::NAO_AVALIADO]), []);

        foreach ($notas as $idAluno => $nota) {
            $faixa = $nota === null ? self::NAO_AVALIADO : $this->faixaDe((float) $nota);
            $grupos[$faixa][] = $idAluno;
        }

        $efetivo = count($notas);
        $lancadas = array_values(array_filter($notas, function ($nota) {
            return $nota !== null;
        }));

        $faixas = [];
        foreach ($grupos as $faixa => $alunos) {
            $faixas[$faixa] = [
                'total' => count($alunos),
                'percentual' => $efetivo === 0 ? 0.0 : round(100 * count($alunos) / $efetivo, 1),
                'alunos' => $alunos,
            ];
        }

        return [
            'efetivo' => $efetivo,
            'avaliados' => count($lancadas),
            'mediana' => self::mediana($lancadas),
            'faixas' => $faixas,
        ];
    }

    /**
     * Devolve a faixa de uma nota lançada.
     *
     * @param float $nota Nota de 0 a 10.
     * @return string Uma das chaves de self::FAIXAS.
     */
    public function faixaDe(float $nota): string
    {
        if ($nota >= $this->regua['alto']) {
            return 'alto';
        }
        if ($nota >= $this->regua['adequado']) {
            return 'adequado';
        }

        return $nota >= $this->regua['atencao'] ? 'atencao' : 'critico';
    }

    /**
     * Mediana com três casas decimais, a precisão usada nas notas do sistema.
     *
     * @param float[] $valores
     * @return float|null Null quando ninguém foi avaliado; o painel mostra "sem lançamento".
     */
    public static function mediana(array $valores): ?float
    {
        $n = count($valores);
        if ($n === 0) {
            return null;
        }

        sort($valores);
        $meio = intdiv($n, 2);
        $mediana = $n % 2 === 1 ? $valores[$meio] : ($valores[$meio - 1] + $valores[$meio]) / 2;

        return round((float) $mediana, 3);
    }
}
