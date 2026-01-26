-- Qual dia semana quem mais pedidos em 2025

SELECT 
       strftime('%w', substr(DtCriacao,1,10)) AS DiaSemana,
       count(IdTransacao) AS qtdTransacao

FROM transacoes

WHERE substr(DtCriacao,1,4) = '2025'

GROUP BY 1

ORDER BY qtdTransacao DESC

LIMIT 1