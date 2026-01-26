DELETE FROM relatorio_diario;

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

INSERT INTO relatorio_diario

SELECT * 
FROM tb_acum;

SELECT * FROM relatorio_diario;