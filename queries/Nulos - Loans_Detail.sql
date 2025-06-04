SELECT 
  COUNTIF(user_id IS NULL) AS nulos_user_id,
  COUNTIF(more_90_days_overdue IS NULL) AS nulos_more_90_days_overdue,
  COUNTIF(using_lines_not_secured_personal_assets IS NULL) AS nulos_using_lines_not_secured_personal_assets,
  COUNTIF(number_times_delayed_payment_loan_30_59_days IS NULL) AS nulos_number_times_delayed_payment_loan_30_59_days,
  COUNTIF(debt_ratio IS NULL) AS nulos_debt_ratio,
  COUNTIF(number_times_delayed_payment_loan_60_89_days IS NULL) AS nulos_number_times_delayed_payment_loan_60_89_days
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail`
