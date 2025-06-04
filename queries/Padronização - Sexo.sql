SELECT
  user_id,
  age,
  last_month_salary,
  number_dependents,
  UPPER(TRIM(sex)) AS sex_standardized
FROM `laboratoria-risco-relativo-h.banco_dataset.users`;
