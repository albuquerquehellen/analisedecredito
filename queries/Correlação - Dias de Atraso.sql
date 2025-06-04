SELECT 
  CORR(more_90_days_overdue, number_times_delayed_payment_loan_30_59_days) AS corr_90_30_59,
  CORR(more_90_days_overdue, number_times_delayed_payment_loan_60_89_days) AS corr_90_60_89,
  CORR(number_times_delayed_payment_loan_30_59_days, number_times_delayed_payment_loan_60_89_days) AS corr_30_59_60_89
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail`
WHERE more_90_days_overdue IS NOT NULL
  AND number_times_delayed_payment_loan_30_59_days IS NOT NULL
  AND number_times_delayed_payment_loan_60_89_days IS NOT NULL;
