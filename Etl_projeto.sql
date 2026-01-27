WITH tb_transacoes AS (
    SELECT IdTransacao,
           IdCliente,
           QtdePontos,
           datetime(substr(DtCriacao,1,19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao,1,10)) AS diffDate 
    
    FROM transacoes
)


SELECT idCliente,
        count(IdTransacao) AS qtdTransacoesVida,
        count(CASE WHEN diffDate <= 56 THEN idTransacao END) AS qtdeTransacoes56,
        count(CASE WHEN diffDate <= 28 THEN idTransacao END) AS qtdeTransacoes28,
        count(CASE WHEN diffDate <= 14 THEN idTransacao END) AS qtdeTransacoes14,
        count(CASE WHEN diffDate <= 7 THEN idTransacao END) AS qtdeTransacoes7


FROM tb_transacoes
GROUP BY idCliente
