-- Consulta demonstrativa sobre nomes e dados inteiramente fictícios.
SELECT
    t.codigo_publico AS turma,
    DATE_FORMAT(a.data_prevista, '%Y-%m') AS periodo,
    COUNT(*) AS avaliacoes_previstas,
    SUM(CASE WHEN a.status = 'realizada' THEN 1 ELSE 0 END) AS avaliacoes_realizadas,
    ROUND(
        100 * SUM(CASE WHEN a.status = 'realizada' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0),
        1
    ) AS percentual_execucao
FROM turmas_demo AS t
INNER JOIN avaliacoes_demo AS a ON a.turma_id = t.id
WHERE a.data_prevista BETWEEN :data_inicio AND :data_fim
GROUP BY t.codigo_publico, DATE_FORMAT(a.data_prevista, '%Y-%m')
ORDER BY periodo, turma;
