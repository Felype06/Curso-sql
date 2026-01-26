-- Quantidade de transações acumulados ao longo do tempo (diário)?
WITH tb_diario AS (

    SELECT substr(DtCriacao,1,10) AS dtDia,
        count(DISTINCT IdTransacao) AS qtdTransacao

    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (

    SELECT *,
        sum(qtdTransacao) OVER (ORDER BY dtDia) AS qtdTransacaoAcum

    FROM tb_diario
)

SELECT * 
FROM tb_acum
WHERE  qtdTransacaoAcum > 100000
ORDER BY  qtdTransacaoAcum 
LIMIT 1



