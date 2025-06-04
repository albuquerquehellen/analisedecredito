SELECT
  loan_id,
  user_id,
  CASE
    WHEN LOWER(loan_type) IN ('other', 'others') THEN 'OTHER'
    WHEN LOWER(loan_type) = 'real estate' THEN 'REAL ESTATE'
    ELSE UPPER(loan_type)
  END AS loan_type_standardized
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_outstanding`
