-- Qual valor médio de pontos positivos por dia?

SELECT sum(QtdePontos) AS totalpontos,

       count(DISTINCT substr(DtCriacao,1,10)) AS qtddeDiasUnicos,

       sum(QtdePontos) / count(DISTINCT substr(DtCriacao,1,10)) AS avgPontosDia       

FROM transacoes

WHERE QtdePontos > 0

