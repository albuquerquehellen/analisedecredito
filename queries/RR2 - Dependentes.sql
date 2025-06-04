WITH base AS (
  SELECT
    -- Definir a faixa de dependentes
    CASE
      WHEN dependents_flag = 'vazio' THEN 'Não informado'
      WHEN dependents_imputed = 0 THEN 'Sem dependentes'
      WHEN dependents_imputed BETWEEN 1 AND 2 THEN '1 a 2'
      WHEN dependents_imputed BETWEEN 3 AND 5 THEN '3 a 5'
      WHEN dependents_imputed >= 6 THEN 'Mais de 6'
      ELSE 'Não informado'
    END AS faixa_dependentes,
    default_flag
  FROM `laboratoria-risco-relativo-h.banco_dataset.dados_atualizados`
),

inadimplencia_por_faixa AS (
  SELECT
    faixa_dependentes,
    COUNTIF(default_flag = 1) AS inadimplentes_faixa,
    COUNT(*) AS total_faixa,
    SAFE_DIVIDE(COUNTIF(default_flag = 1), COUNT(*)) AS taxa_inadimplencia_faixa
  FROM base
  GROUP BY faixa_dependentes
),

inadimplencia_complemento AS (
  SELECT
    a.faixa_dependentes,
    -- Somar inadimplentes e totais de todas as outras faixas (complemento)
    SUM(b.inadimplentes_faixa) AS inadimplentes_complemento,
    SUM(b.total_faixa) AS total_complemento,
    SAFE_DIVIDE(SUM(b.inadimplentes_faixa), SUM(b.total_faixa)) AS taxa_inadimplencia_complemento
  FROM inadimplencia_por_faixa a
  JOIN inadimplencia_por_faixa b ON a.faixa_dependentes != b.faixa_dependentes
  GROUP BY a.faixa_dependentes
)

SELECT
  a.faixa_dependentes,
  a.taxa_inadimplencia_faixa,
  c.taxa_inadimplencia_complemento,
  ROUND(SAFE_DIVIDE(a.taxa_inadimplencia_faixa, c.taxa_inadimplencia_complemento), 2) AS risco_relativo
FROM inadimplencia_por_faixa a
JOIN inadimplencia_complemento c ON a.faixa_dependentes = c.faixa_dependentes
ORDER BY risco_relativo DESC;
