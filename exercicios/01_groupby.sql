-- Quantos clientes tem email cadastrados?
SELECT sum(flEmail)

FROM clientes;
 
 -- OU

SELECT count(*)
FROM clientes
WHERE flEmail = 1;



