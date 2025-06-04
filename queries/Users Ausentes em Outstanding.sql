SELECT 
  u.user_id
FROM `laboratoria-risco-relativo-h.banco_dataset.users_limpo` u
LEFT JOIN `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding_limpa` l
  ON u.user_id = l.user_id
WHERE l.user_id IS NULL

