-- Cria tabela física a partir da view, com nome diferente
CREATE OR REPLACE TABLE laboratoria-risco-relativo-h.banco_dataset.dados_atualizados AS
SELECT
  *
FROM
  `laboratoria-risco-relativo-h.banco_dataset.consolidacao_users`;