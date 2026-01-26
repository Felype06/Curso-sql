-- Commo foi a curva de churn no curso de sql?

--SELECT 
 --     substr(DtCriacao,1,10) AS dtDia,
--      count(DISTINCT idCliente) AS qtdeCliente
--FROM transacoes
--WHERE DtCriacao >= '2025-08-25'
--AND DtCriacao < '2025-08-30'
--GROUP BY dtDia

WITH tb_cliente_d1 AS (
     SELECT DISTINCT idCliente

     FROM transacoes

     WHERE DtCriacao >= '2025-08-25'
     AND DtCriacao < '2025-08-26'
),

tb_join AS (

    SELECT 
        substr(t2.DtCriacao,1,10) AS dtDia,
        count(DISTINCT t1.idCliente) AS qtdCliente,
        1.* count(DISTINCT t1.idCliente) / (select count(*) from tb_cliente_d1)AS pctRetencao,
        1- 1.* count(DISTINCT t1.idCliente) / (select count(*) from tb_cliente_d1)AS pctChurn

    FROM tb_cliente_d1 AS t1

    LEFT JOIN transacoes AS t2
    ON t1.idCliente = t2.idCliente

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao <'2025-08-30'

    GROUP BY dtDia
)

SELECT * FROM tb_join




