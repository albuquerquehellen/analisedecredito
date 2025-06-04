SELECT 
  user_id,
  COALESCE(number_dependents, 0) AS number_dependents_tratado
FROM `laboratoria-risco-relativo-h.banco_dataset.users`
