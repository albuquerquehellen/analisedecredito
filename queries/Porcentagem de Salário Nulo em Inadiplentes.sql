SELECT 
  d.default_flag,   -- Seleciona a variável de inadimplência: 0 (bom pagador) ou 1 (mau pagador)
  
  COUNT(*) AS total_clientes,   -- Conta o total de clientes de cada grupo (por default_flag)
  
  SUM(CASE WHEN l.last_month_salary IS NULL THEN 1 ELSE 0 END) AS nulos_lastmonthsalary,  
  -- Soma 1 quando o salário do mês passado está nulo, ou 0 quando não está, para contar a quantidade de nulos em cada grupo
  
  ROUND(SUM(CASE WHEN l.last_month_salary IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percentual_nulos
  -- Calcula a porcentagem de nulos no salário, dividindo o número de nulos pelo total de clientes daquele grupo e multiplicando por 100
  
FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS l
-- Usa a tabela de usuários com apelido l (de "loans_outstanding")

LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
-- Faz um LEFT JOIN para unir com a tabela de inadimplência (flag de default), mantendo todos os registros da tabela de usuários

ON l.user_id = d.user_id
-- Relaciona as tabelas pelo user_id

GROUP BY d.default_flag
-- Agrupa os resultados pela flag de inadimplência (0 ou 1)

ORDER BY d.default_flag
-- Organiza o resultado na ordem de 0 para 1