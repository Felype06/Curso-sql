WITH tb_cliente_dia AS (

    SELECT IdCliente,
        substr(DtCriacao,1,10) AS dtDia,
        count(DISTINCT IdTransacao) AS qtdTransacao

    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    GROUP BY idCliente, dtDia

),
tb_lag AS (

SELECT *,
       SUM(qtdTransacao) OVER ( PARTITION BY idCliente ORDER BY dtDia) AS acum, 
       lag(qtdTransacao) OVER ( PARTITION BY idCliente ORDER BY dtDia) AS lagTransacao

FROM tb_cliente_dia
)

SELECT *,
1.* qtdTransacao / lagTransacao
FROM tb_lag
