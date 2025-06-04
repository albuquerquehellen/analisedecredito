SELECT 
  COUNTIF(user_id IS NULL) AS nulos_user_id,
  COUNTIF(age IS NULL) AS nulos_age,
  COUNTIF(sex IS NULL) AS nulos_sex,
  COUNTIF(last_month_salary IS NULL) AS nulos_last_month_salary,
  COUNTIF(number_dependents IS NULL) AS nulos_number_dependents
FROM `laboratoria-risco-relativo-h.banco_dataset.users`