SELECT 
  COUNTIF(user_id IS NULL) AS nulos_user_id,
  COUNTIF(default_flag IS NULL) AS nulos_default_flag
FROM `laboratoria-risco-relativo-h.banco_dataset.default` LIMIT 1000