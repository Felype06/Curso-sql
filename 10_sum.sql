SELECT 
       sum(QtdePontos),

       sum(CASE
            WHEN QtdePontos > 0 THEN QtdePontos
       END) AS qtdePontosPositivos,

       sum(CASE WHEN QtdePontos < 0 THEN QtdePontos
       END) AS qtdPontosNegativos

FROM transacoes

WHERE DtCriacao LIKE '%2025-07%'

ORDER BY QtdePontos




