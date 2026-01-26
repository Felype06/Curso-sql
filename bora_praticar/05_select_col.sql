SELECT IdCliente,
      --  qtdePontos,
      --  qtdePontos + 10 AS qtdePontos10,
      --  qtdePontos * 2 AS qtdePontosDobrados
      DtCriacao,
      substr(DtCriacao, 1, 19) AS dtSubString,
      datetime(substr(DtCriacao, 1, 19)) AS dtCriacaoNova,
      strftime('%w', datetime(substr(DtCriacao, 1, 19))) AS diaSemana
 
FROM clientes