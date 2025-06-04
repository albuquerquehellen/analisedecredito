WITH predictions AS (
  SELECT
    user_id,
    score_risco,
    default_flag,
    CASE 
      WHEN score_risco >= 3 THEN 1
      ELSE 0
    END AS predicted_default_flag
  FROM (
SELECT
  user_id,
  (dep_risco + idade_risco + salario_risco + credito_risco + debt_ratio_risco + delayed_payment_risco) AS score_risco,
  default_flag,
  faixa_dependentes,
  faixa_etaria,
  faixa_salario,
  faixa_credito_sem_garantia,
  faixa_debt_ratio,
  number_times_delayed_payment_loan_30_59_days
 
FROM (
  SELECT
    user_id,
    CASE WHEN faixa_dependentes IN ('3 a 5', 'Mais de 6') THEN 1 ELSE 0 END AS dep_risco,
    CASE WHEN faixa_etaria = '25 a 40' THEN 1 ELSE 0 END AS idade_risco,
    CASE WHEN faixa_salario IN ('501 a 1500', '1501 a 3000') THEN 1 ELSE 0 END AS salario_risco,
    CASE WHEN faixa_credito_sem_garantia = '> 80%' THEN 1 ELSE 0 END AS credito_risco,
    CASE WHEN faixa_debt_ratio = '0.51–1' THEN 1 ELSE 0 END AS debt_ratio_risco,
    CASE WHEN number_times_delayed_payment_loan_30_59_days >= 1 THEN 1 ELSE 0 END AS delayed_payment_risco,
    default_flag,
    faixa_dependentes,
    faixa_etaria,
    faixa_salario,
    faixa_credito_sem_garantia,
    faixa_debt_ratio,
    number_times_delayed_payment_loan_30_59_days

  FROM laboratoria-risco-relativo-h.banco_dataset.dados_atualizados
) AS dummies_table
  )
)
SELECT
  SUM(CASE WHEN default_flag = 1 AND predicted_default_flag = 1 THEN 1 ELSE 0 END) AS true_positives,
  SUM(CASE WHEN default_flag = 0 AND predicted_default_flag = 1 THEN 1 ELSE 0 END) AS false_positives,
  SUM(CASE WHEN default_flag = 0 AND predicted_default_flag = 0 THEN 1 ELSE 0 END) AS true_negatives,
  SUM(CASE WHEN default_flag = 1 AND predicted_default_flag = 0 THEN 1 ELSE 0 END) AS false_negatives
FROM predictions;
