-- Efetivo e evasão de um ciclo de formação. Esquema e nomes fictícios.
--
-- A lição que esta consulta carrega: o aluno REINTEGRADO entra na turma do
-- ciclo em que voltou, mas a saída dele pertence ao ciclo em que se
-- matriculou. Contar a saída pelo ciclo de reintegração faz o mesmo aluno
-- aparecer como evasão de uma turma em que ele está cursando, e o total
-- deixa de bater com o efetivo oficial.
--
-- Por isso cada lado da conta usa o seu critério:
--   * cursando  -> matriculado no ciclo OU reintegrado nele;
--   * evasão    -> só quem se matriculou no ciclo e saiu.
-- ativos + reintegrados + desligados = matriculados, sem sobra nem falta.
--
-- O ciclo entra por um único parâmetro (:ciclo), lido de uma CTE (MySQL 8):
-- com PDO em prepare nativo, repetir o mesmo nome de parâmetro não funciona.

WITH parametro AS (SELECT :ciclo AS id)
SELECT
    SUM(turma.situacao = 'ATIVO')       AS ativos,
    SUM(turma.situacao = 'REINTEGRADO') AS reintegrados,
    SUM(turma.situacao = 'DESLIGADO')   AS desligados,
    COUNT(*)                            AS matriculados,
    ROUND(100 * SUM(turma.situacao = 'DESLIGADO') / NULLIF(COUNT(*), 0), 1) AS taxa_evasao_pct
FROM (
    SELECT
        a.id,
        CASE WHEN a.ciclo_matricula_id = c.id THEN 'ATIVO' ELSE 'REINTEGRADO' END AS situacao
    FROM alunos_demo AS a
    INNER JOIN parametro AS c
        ON a.ciclo_matricula_id = c.id
        OR a.ciclo_reintegracao_id = c.id

    UNION ALL

    SELECT s.aluno_id, 'DESLIGADO'
    FROM saidas_demo AS s
    INNER JOIN parametro AS c ON s.ciclo_matricula_id = c.id
    WHERE s.tipo = 'DESLIGAMENTO'
) AS turma;
