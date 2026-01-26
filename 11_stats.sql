SELECT round(avg(qtdePontos), 2) AS mediaCarteira,
       sum(qtdePontos) / count(idCliente) AS mediaCarteiraRoots,
       min(qtdePontos) AS minCarteira,
       max(qtdePontos) AS maxCarteira,
       sum(flTwitch) AS TotalTwitch,
       sum(flEmail) AS TotalEmail


FROM clientes