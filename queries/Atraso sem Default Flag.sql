SELECT 
  COUNT(*) AS qtd_falso_positivo_com_atraso
FROM (
  SELECT
    user_id,
    (dep_risco + idade_risco + salario_risco + credito_risco + debt_ratio_risco) AS score_risco,
    default_flag,
    number_times_delayed_payment_loan_30_59_days
  FROM (
    SELECT
      user_id,
      CASE WHEN faixa_dependentes IN ('3 a 5', 'Mais de 6') THEN 1 ELSE 0 END AS dep_risco,
      CASE WHEN faixa_etaria = '25 a 40' THEN 1 ELSE 0 END AS idade_risco,
      CASE WHEN faixa_salario IN ('501 a 1500', '1501 a 3000') THEN 1 ELSE 0 END AS salario_risco,
      CASE WHEN faixa_credito_sem_garantia = '> 80%' THEN 1 ELSE 0 END AS credito_risco,
      CASE WHEN faixa_debt_ratio = '0.51–1' THEN 1 ELSE 0 END AS debt_ratio_risco,
      default_flag,
      number_times_delayed_payment_loan_30_59_days
    FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
  ) AS dummies_table
  WHERE default_flag = 0 -- Falso positivo: flag diz que não, mas score >= 3
    AND (dep_risco + idade_risco + salario_risco + credito_risco + debt_ratio_risco) >= 3
) AS falsos_positivos
WHERE number_times_delayed_payment_loan_30_59_days >= 1;