SELECT 
  user_id,
  COUNT(loan_id) AS total_loans,
  SUM(CASE WHEN loan_type_standardized = 'REAL ESTATE' THEN 1 ELSE 0 END) AS qtd_real_state,
  SUM(CASE WHEN loan_type_standardized = 'OTHER' THEN 1 ELSE 0 END) AS qtd_other,
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding_limpa`
GROUP BY user_id