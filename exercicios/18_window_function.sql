WITH tb_sumario_dias AS (

SELECT substr(DtCriacao,1,10) AS dtDia,
       count(DISTINCT idTransacao) AS qtdTransacao

FROM transacoes

WHERE DtCriacao >= '2025-08-25'
AND DtCriacao < '2025-08-30'

GROUP BY dtDia

)

SELECT *,
       sum(qtdTransacao) OVER (ORDER BY dtDia) AS qtdTransacaoAcum

FROM tb_sumario_dias 
