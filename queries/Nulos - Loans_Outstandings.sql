SELECT 
  COUNTIF(loan_id IS NULL) AS nulos_loan_id,
  COUNTIF(user_id IS NULL) AS nulos_user_id,
  COUNTIF(loan_type IS NULL) AS nulos_loan_type
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding`