<h1 align="center">💳 Análise e Classificação de Risco de Crédito - Super Caja</h1>

<p align="center">
  <img src="https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white" />
  <img src="https://img.shields.io/badge/Looker%20Studio-3165D3?style=for-the-badge&logo=googleanalytics&logoColor=white" />
</p>

---

## 🎯 Objetivo

Automatizar a análise de risco de crédito do banco **Super Caja**, identificando perfis de maior probabilidade de inadimplência e classificando clientes como bons ou maus pagadores.  
O projeto visa melhorar a gestão do risco, reduzir inadimplência e antecipar comportamentos críticos por meio de dados históricos e variáveis preditivas validadas.

---

## 🛠️ Ferramentas e Tecnologias

- **Google BigQuery**
- **Looker Studio**

---

## ⚙️ Processamento de Dados

### 🔹 Limpeza e Tratamento:
- Substituição de valores nulos:
  - `0` para variáveis numéricas.
  - `"Desconhecido"` para variáveis categóricas.
- Tratamento de outliers e inconsistências categóricas.
- Conversão de variáveis categóricas em dummies para o modelo.

### 🔹 Análises Exploratórias:
- Estudo de inadimplência por:
  - Faixa etária.
  - Número de dependentes.
  - Faixa salarial.
  - Proporção de crédito sem garantia.
  - Razão dívida/renda (debt ratio).

### 🔹 Criação de Variáveis Derivadas:
- Classificação de variáveis em faixas e categorias de risco.
- Cálculo do **Risco Relativo (RR)** por faixa.

---

## 📊 Principais Descobertas

### 📌 Fatores de Maior Risco (RR > 1)
- **3 a 5 dependentes** → RR = 1,66  
- **Mais de 6 dependentes** → RR = 2,44  
- **25 a 40 anos** → RR = 2,47  
- **R$501 a R$1500** → RR = 1,66  
- **R$1501 a R$3000** → RR = 1,94  
- **Crédito sem garantia > 80%** → RR = 27,68  
- **Debt Ratio de 0,51 a 1** → RR = 1,69  

---

## 📝 Classificação de Risco

Foi estruturado um **score de risco** automático para clientes, atribuindo pontos para cada fator de risco relevante.  
Para clientes já ativos, o histórico de atrasos também é considerado na pontuação.

**Regra de Classificação:**
- **Score ≥ 2** → Possível mau pagador  
- **Score < 2** → Bom pagador

Essa classificação foi validada via modelo preditivo, priorizando **recall** e **F1 score**, garantindo a captura de potenciais inadimplentes e identificando riscos latentes, mesmo em clientes sem registro formal de inadimplência.

---

## 📈 Resultados de Validação

- **625** verdadeiros positivos identificados com corte ≥ 2.  
- **16,76%** dos falsos positivos já haviam apresentado atrasos de 30 a 59 dias.  
- **Acurácia geral robusta** com alta taxa de verdadeiros negativos (27.060).  
- **F1 score equilibrado**, ajustado para o cenário de risco preventivo.

---

📂 Projeto desenvolvido para fins de estudo e melhoria contínua na gestão de risco de crédito.
