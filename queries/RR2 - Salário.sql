WITH base AS (
  SELECT
    -- Definir a faixa salarial
    CASE
      WHEN is_zero_salary = 1 THEN 'Não informado'
      WHEN salary_imputed <= 500 THEN 'Até 500'
      WHEN salary_imputed BETWEEN 501 AND 1500 THEN '501 a 1500'
      WHEN salary_imputed BETWEEN 1501 AND 3000 THEN '1501 a 3000'
      WHEN salary_imputed BETWEEN 3001 AND 5000 THEN '3001 a 5000'
      WHEN salary_imputed BETWEEN 5001 AND 10000 THEN '5001 a 10000'
      WHEN salary_imputed > 10000 THEN 'Acima de 10000'
      ELSE 'Não informado'
    END AS faixa_salarial,
    default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

inadimplencia_por_faixa AS (
  SELECT
    faixa_salarial,
    COUNTIF(default_flag = 1) AS inadimplentes_faixa,
    COUNT(*) AS total_faixa,
    SAFE_DIVIDE(COUNTIF(default_flag = 1), COUNT(*)) AS taxa_inadimplencia_faixa
  FROM base
  GROUP BY faixa_salarial
),

inadimplencia_complemento AS (
  SELECT
    a.faixa_salarial,
    -- Somar inadimplentes e totais de todas as outras faixas (complemento)
    SUM(b.inadimplentes_faixa) AS inadimplentes_complemento,
    SUM(b.total_faixa) AS total_complemento,
    SAFE_DIVIDE(SUM(b.inadimplentes_faixa), SUM(b.total_faixa)) AS taxa_inadimplencia_complemento
  FROM inadimplencia_por_faixa a
  JOIN inadimplencia_por_faixa b ON a.faixa_salarial != b.faixa_salarial
  GROUP BY a.faixa_salarial
)

SELECT
  a.faixa_salarial,
  a.taxa_inadimplencia_faixa,
  c.taxa_inadimplencia_complemento,
  ROUND(SAFE_DIVIDE(a.taxa_inadimplencia_faixa, c.taxa_inadimplencia_complemento), 2) AS risco_relativo
FROM inadimplencia_por_faixa a
JOIN inadimplencia_complemento c ON a.faixa_salarial = c.faixa_salarial
ORDER BY risco_relativo DESC;