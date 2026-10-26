#!/bin/bash
# Script de Implantação Automatizada no IBM Db2 Community Edition
# Alvos: Tabelas de Portfólio, Matrizes Corporativas e Loop de Previsão de 55 Meses

echo "Iniciando a criação das tabelas e carga de dados no IBM Db2..."

docker exec -i db2-finance-server su - db2inst1 -c "/home/db2inst1/sqllib/bin/db2" << 'INNER_EOF'
-- Conectar ao banco de dados FINDB inicializado
CONNECT TO FINDB

-- 1. Criar Tabela Base de Diretório Corporativo
CREATE TABLE companies (
    company_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    ticker VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    current_price DECIMAL(10, 2) NOT NULL,
    price_change DECIMAL(10, 2) NOT NULL,
    pct_change DECIMAL(5, 2) NOT NULL,
    volume BIGINT NOT NULL,
    week_range_low DECIMAL(10, 2) NOT NULL,
    week_range_high DECIMAL(10, 2) NOT NULL
)

-- 2. Criar Tabela de Demonstrativos de Resultados Financeiros
CREATE TABLE income_statements (
    statement_id BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    company_id INT NOT NULL,
    fiscal_year INT NOT NULL,
    total_revenue BIGINT DEFAULT 0,
    cost_of_revenue BIGINT DEFAULT 0,
    gross_profit BIGINT DEFAULT 0,
    sales_general_admin BIGINT DEFAULT 0,
    operating_income BIGINT DEFAULT 0,
    ebit BIGINT DEFAULT 0,
    interest_expense BIGINT DEFAULT 0,
    earnings_before_tax BIGINT DEFAULT 0,
    income_tax BIGINT DEFAULT 0,
    net_income_common BIGINT DEFAULT 0,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    CONSTRAINT uq_company_year UNIQUE (company_id, fiscal_year)
)

-- 3. Criar Tabela de Patrocinadores da Fundação MariaDB
CREATE TABLE sponsor_tiers (
    sponsor_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL UNIQUE,
    funding_tier VARCHAR(20) NOT NULL CONSTRAINT check_tier CHECK (funding_tier IN ('Diamond', 'Platinum', 'Gold', 'Silver')),
    primary_sector VARCHAR(50) NOT NULL,
    base_annual_capex_billion DECIMAL(18, 4) NOT NULL,
    historical_growth_rate DECIMAL(5, 2) NOT NULL
)

-- 4. Criar Tabela de Destino para Histórico de Projeções de CapEx
CREATE TABLE project_capex_forecasts (
    forecast_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    funding_tier VARCHAR(20) NOT NULL,
    horizon_months INT NOT NULL,
    compounded_run_rate_billion DECIMAL(18, 4) NOT NULL,
    cumulative_capex_trillions DECIMAL(18, 4) NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

-- 5. Carga de Dados Inicial: Empresas do Portfólio
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('JPM', 'JP Morgan Chase & Co. Common Stock', 331.58, -4.96, -1.47, 4781132, 279.10, 366.50)
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('PBR', 'Petroleo Brasileiro S.A. Petrobras ADS', 26.16, 0.54, 2.11, 25136507, 11.43, 26.12)
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('BP', 'BP p.l.c. Common Stock', 51.32, 1.27, 2.54, 9156710, 33.22, 50.42)

-- 6. Carga de Dados Inicial: Demonstrativos Históricos (2025)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='JPM'), 2025, 168235000, 0, 168235000, 95640000, 72595000, 170493000, 97898000, 72595000, 15547000, 55681000)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 89195000, 46736000, 42459000, 12746000, 26113000, 31109000, 4314000, 26795000, 7075000, 19634000)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 189335000, 136286000, 53049000, 19192000, 9428000, 12852000, 5106000, 7746000, 6451000, 1295000)

-- 7. Carga de Dados Inicial: Matriz de Patrocinadores da Fundação
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Amazon Web Services (AWS)', 'Diamond', 'Cloud Infrastructure', 52.5000, 14.20)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('IBM', 'Platinum', 'Enterprise Compute / AI', 6.2000, 4.80)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Hetzner', 'Gold', 'Data Center Hosting', 1.4000, 12.50)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Automattic', 'Silver', 'Digital Web Platforms', 0.4500, 9.50)

-- 8. Execução do Motor de Cálculo e Projeção Linear Composta (55 meses)
BEGIN ATOMIC
    DECLARE num_years DECIMAL(10, 4);
    SET num_years = 55.0000 / 12.0000;
    
    INSERT INTO project_capex_forecasts (company_name, funding_tier, horizon_months, compounded_run_rate_billion, cumulative_capex_trillions)
    SELECT 
        company_name,
        funding_tier,
        55,
        base_annual_capex_billion * EXP(num_years * LN(1 + (historical_growth_rate / 100.00))),
        ((base_annual_capex_billion * num_years) * EXP((num_years / 2.00) * LN(1 + (historical_growth_rate / 100.00)))) / 1000.00
    FROM sponsor_tiers;
END

-- 9. Consultar Resultados Consolidados para Validação
SELECT funding_tier AS "Tier", COUNT(*) AS "Sponsors Mapped", CAST(SUM(compounded_run_rate_billion) AS DECIMAL(14,2)) || ' B' AS "55-Mo Run-Rate" FROM project_capex_forecasts GROUP BY funding_tier

INNER_EOF
