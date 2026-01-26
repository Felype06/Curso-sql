SELECT sum(QtdePontos) AS totalpontos,
       count(DISTINCT substr(DtCriacao,1,10)) AS qtdDiasUnicos, 
       sum(QtdePontos) / count(DISTINCT substr(DtCriacao,1,10)) AS avgPontosdia

FROM transacoes

WHERE QtdePontos > 0