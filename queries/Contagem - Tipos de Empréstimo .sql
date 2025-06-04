SELECT 
  COUNTIF(loan_type_standardized IS NULL OR loan_type_standardized = '') AS qtd_total_sem_tipo,
  COUNTIF(loan_type_standardized = 'REAL ESTATE') AS qtd_real_estate,
  COUNTIF(loan_type_standardized = 'OTHER') AS qtd_other
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding_limpa`

