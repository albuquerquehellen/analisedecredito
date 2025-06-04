SELECT 
  d.default_flag,
  COUNT(*) AS total_clientes,
  COUNTIF(l.number_dependents IS NULL) AS nulos_dependentes,
  ROUND(COUNTIF(l.number_dependents IS NULL) / COUNT(*) * 100, 2) AS percentual_nulos
FROM `laboratoria-risco-relativo-h.banco_dataset.users` AS l
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.default` AS d
ON l.user_id = d.user_id
GROUP BY d.default_flag
