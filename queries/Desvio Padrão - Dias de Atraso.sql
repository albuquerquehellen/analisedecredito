SELECT 
  STDDEV(more_90_days_overdue) AS std_more_90,
  STDDEV(number_times_delayed_payment_loan_30_59_days) AS std_30_59,
  STDDEV(number_times_delayed_payment_loan_60_89_days) AS std_60_89
FROM `laboratoria-risco-relativo-h.banco_dataset.loans_detail`
WHERE more_90_days_overdue IS NOT NULL
  AND number_times_delayed_payment_loan_30_59_days IS NOT NULL
  AND number_times_delayed_payment_loan_60_89_days IS NOT NULL;
