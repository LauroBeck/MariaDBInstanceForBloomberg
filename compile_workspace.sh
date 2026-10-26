#!/bin/bash
# ==============================================================================
# SCRIPT UNIFICADO DE AUTOMAÇÃO DE BANCOS DE DADOS FINANCEIROS & MARÍTIMOS
# Alvos: MariaDB (Portfólio Operacional Completo) & IBM Db2 (Camada Corporativa)
# Geopolítica: Projeções 2027 (Aramco / Lula Election Impact / Storage Caverns)
# ==============================================================================

set -e

echo "=================================================================="
echo "⚡ INICIANDO COMPILAÇÃO DO WORKSPACE ANALÍTICO DE DADOS"
echo "=================================================================="

# ------------------------------------------------------------------------------
# PARTE 1: IMPLEMENTAÇÃO DO AMBIENTE MARIADB (Módulo de Operações e Frotas)
# ------------------------------------------------------------------------------
echo "⏳ [1/2] Provisionando e Carregando Instância do MariaDB..."

docker exec -i mariadb-server mariadb -u root -p"your_secure_password" << 'MARIADB_EOF'
DROP DATABASE IF EXISTS corporate_finance_db;
CREATE DATABASE corporate_finance_db;
USE corporate_finance_db;

CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    current_price DECIMAL(10, 2) NOT NULL,
    price_change DECIMAL(10, 2) NOT NULL,
    pct_change DECIMAL(5, 2) NOT NULL,
    volume BIGINT NOT NULL,
    week_range_low DECIMAL(10, 2) NOT NULL,
    week_range_high DECIMAL(10, 2) NOT NULL
);

CREATE TABLE income_statements (
    statement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    fiscal_year INT NOT NULL,
    total_revenue BIGINT DEFAULT 0,
    cost_of_revenue BIGINT DEFAULT 0,
    gross_profit BIGINT DEFAULT 0,
    research_development BIGINT DEFAULT 0,
    sales_general_admin BIGINT DEFAULT 0,
    non_recurring_items BIGINT DEFAULT 0,
    other_operating_items BIGINT DEFAULT 0,
    operating_income BIGINT DEFAULT 0,
    additional_items BIGINT DEFAULT 0,
    ebit BIGINT DEFAULT 0,
    interest_expense BIGINT DEFAULT 0,
    earnings_before_tax BIGINT DEFAULT 0,
    income_tax BIGINT DEFAULT 0,
    minority_interest BIGINT DEFAULT 0,
    equity_earnings BIGINT DEFAULT 0,
    net_income_continuous BIGINT DEFAULT 0,
    net_income BIGINT DEFAULT 0,
    net_income_common BIGINT DEFAULT 0,
    CONSTRAINT fk_company_statements FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    UNIQUE KEY uq_company_year (company_id, fiscal_year)
);

CREATE TABLE balance_sheets (
    balance_sheet_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    fiscal_year INT NOT NULL,
    cash_cash_equivalents BIGINT DEFAULT 0,
    short_term_investments BIGINT DEFAULT 0,
    net_receivables BIGINT DEFAULT 0,
    inventory BIGINT DEFAULT 0,
    other_current_assets BIGINT DEFAULT 0,
    total_current_assets BIGINT DEFAULT 0,
    long_term_investments BIGINT DEFAULT 0,
    fixed_assets BIGINT DEFAULT 0,
    goodwill BIGINT DEFAULT 0,
    intangible_assets BIGINT DEFAULT 0,
    other_assets BIGINT DEFAULT 0,
    deferred_asset_charges BIGINT DEFAULT 0,
    total_assets BIGINT DEFAULT 0,
    accounts_payable BIGINT DEFAULT 0,
    short_term_debt BIGINT DEFAULT 0,
    other_current_liabilities BIGINT DEFAULT 0,
    total_current_liabilities BIGINT DEFAULT 0,
    long_term_debt BIGINT DEFAULT 0,
    other_liabilities BIGINT DEFAULT 0,
    deferred_liability_charges BIGINT DEFAULT 0,
    misc_stocks BIGINT DEFAULT 0,
    total_liabilities BIGINT DEFAULT 0,
    common_stocks BIGINT DEFAULT 0,
    capital_surplus BIGINT DEFAULT 0,
    other_equity BIGINT DEFAULT 0,
    total_equity BIGINT DEFAULT 0,
    CONSTRAINT fk_company_balances FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE,
    UNIQUE KEY uq_company_balance_year (company_id, fiscal_year)
);

CREATE TABLE global_energy_capex (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(15) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    domicile_region VARCHAR(50) NOT NULL,
    annual_capex_guidance_billion DECIMAL(18, 4) NOT NULL,
    projected_annual_growth_rate DECIMAL(5, 2) NOT NULL
);

CREATE TABLE simula_maritima_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    horizonte_meses INT,
    modificador_crescimento DECIMAL(5,2),
    premio_risco_regional DECIMAL(5,2),
    ticker VARCHAR(15),
    empresa VARCHAR(150),
    rota_maritima VARCHAR(100),
    frota_designada VARCHAR(100),
    capex_base_bilhao DECIMAL(18,4),
    capex_simulado_bilhao DECIMAL(18,4),
    executado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES
('JPM', 'JP Morgan Chase & Co. Common Stock', 331.58, -4.96, -1.47, 4781132, 279.10, 366.50),
('PBR', 'Petroleo Brasileiro S.A. Petrobras ADS', 26.16, 0.54, 2.11, 25136507, 11.43, 26.12),
('BP', 'BP p.l.c. Common Stock', 51.32, 1.27, 2.54, 9156710, 33.22, 50.42);

INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income, net_income_common) VALUES
((SELECT company_id FROM companies WHERE ticker='JPM'), 2025, 168235000, 0, 168235000, 95640000, 72595000, 170493000, 97898000, 72595000, 15547000, 57048000, 55681000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 89195000, 46736000, 42459000, 12746000, 26113000, 31109000, 4314000, 26795000, 7075000, 19634000, 19634000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 189335000, 136286000, 53049000, 19192000, 9428000, 12852000, 5106000, 7746000, 6451000, 1295000, 1295000);

INSERT INTO balance_sheets (company_id, fiscal_year, cash_cash_equivalents, short_term_investments, net_receivables, inventory, other_current_assets, total_current_assets, fixed_assets, goodwill, intangible_assets, total_assets, total_liabilities, total_equity) VALUES
((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 6471000, 2726000, 6653000, 8210000, 1388000, 25448000, 168040000, 0, 2523000, 222337000, 146446000, 75565000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 36556000, 158000, 27167000, 22499000, 15406000, 101786000, 98633000, 10300000, 8197000, 278526000, 204526000, 53052000);

INSERT INTO global_energy_capex (ticker, company_name, domicile_region, annual_capex_guidance_billion, projected_annual_growth_rate) VALUES
('ARAMCO', 'Saudi Arabian Oil Company (Saudi Aramco)', 'Middle East', 55.0000, 8.50),
('PBR', 'Petroleo Brasileiro S.A. (Petrobras)', 'Latin America', 31.8000, 11.20),
('BP', 'BP p.l.c.', 'Europe', 16.5000, -3.50);

CREATE OR REPLACE VIEW global_trade_lanes_view AS
SELECT 
    e.ticker AS asset_ticker,
    e.company_name AS energy_enterprise,
    e.annual_capex_guidance_billion AS base_capex_gvar,
    CASE 
        WHEN e.domicile_region = 'Middle East' THEN 'Suez Canal / Bab el-Mandeb Trade Corridor'
        WHEN e.domicile_region = 'Latin America' THEN 'Transatlantic / Inter-American Cape Route'
        ELSE 'North Sea / Northern Europe Trade Lane'
    END AS maritime_trade_route,
    CASE 
        WHEN e.domicile_region = 'Middle East' THEN 'Gemini Cooperation (Maersk & Hapag-Lloyd)'
        WHEN e.domicile_region = 'Latin America' THEN 'MSC Standalone / Fleet Consolidation'
        ELSE 'Premier Alliance Network Slots'
    END AS dominant_container_carriers
FROM global_energy_capex e;

DELIMITER //
CREATE PROCEDURE SimulatePortfolioScenarios(
    IN input_time_horizon_months INT,
    IN energy_growth_modifier DECIMAL(5,2),
    IN regional_risk_premium DECIMAL(5,2)
)
BEGIN
    DECLARE elapsed_years DECIMAL(10,4);
    SET elapsed_years = input_time_horizon_months / 12.0000;
    
    INSERT INTO simula_maritima_log (
        horizonte_meses, modificador_crescimento, premio_risco_regional,
        ticker, empresa, rota_maritima, frota_designada, capex_base_bilhao, capex_simulado_bilhao
    )
    SELECT 
        input_time_horizon_months, energy_growth_modifier, regional_risk_premium,
        v.asset_ticker, v.energy_enterprise, v.maritime_trade_route, v.dominant_container_carriers, v.base_capex_gvar,
        ROUND(v.base_capex_gvar * POWER(1 + ((e.projected_annual_growth_rate + energy_growth_modifier) / 100), elapsed_years) * (1 + (regional_risk_premium / 100)), 4)
    FROM global_trade_lanes_view v
    JOIN global_energy_capex e ON v.asset_ticker = e.ticker;
END //
DELIMITER ;

CALL SimulatePortfolioScenarios(55, 2.50, 0.00);
CALL SimulatePortfolioScenarios(24, 0.00, 4.10);
MARIADB_EOF

# ------------------------------------------------------------------------------
# PARTE 2: IMPLEMENTAÇÃO DO AMBIENTE IBM DB2 (Camada Corporativa e Analítica)
# ------------------------------------------------------------------------------
echo "⏳ [2/2] Provisionando e Carregando Instância do IBM Db2 (FINDB)..."

docker exec -i db2-finance-server su - db2inst1 -c "/home/db2inst1/sqllib/bin/db2" << 'DB2_EOF'
CONNECT TO FINDB

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
CREATE TABLE sponsor_tiers (
sponsor_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
company_name VARCHAR(100) NOT NULL UNIQUE,
funding_tier VARCHAR(20) NOT NULL CONSTRAINT check_tier CHECK (funding_tier IN ('Diamond', 'Platinum', 'Gold', 'Silver')),
primary_sector VARCHAR(50) NOT NULL,
base_annual_capex_billion DECIMAL(18, 4) NOT NULL,
historical_growth_rate DECIMAL(5, 2) NOT NULL
)
CREATE TABLE project_capex_forecasts (
forecast_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
company_name VARCHAR(100) NOT NULL,
funding_tier VARCHAR(20) NOT NULL,
horizon_months INT NOT NULL,
compounded_run_rate_billion DECIMAL(18, 4) NOT NULL,
cumulative_capex_trillions DECIMAL(18, 4) NOT NULL,
calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('JPM', 'JP Morgan Chase & Co. Common Stock', 331.58, -4.96, -1.47, 4781132, 279.10, 366.50)
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('PBR', 'Petroleo Brasileiro S.A. Petrobras ADS', 26.16, 0.54, 2.11, 25136507, 11.43, 26.12)
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES ('BP', 'BP p.l.c. Common Stock', 51.32, 1.27, 2.54, 9156710, 33.22, 50.42)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='JPM'), 2025, 168235000, 0, 168235000, 95640000, 72595000, 170493000, 97898000, 72595000, 15547000, 55681000)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 89195000, 46736000, 42459000, 12746000, 26113000, 31109000, 4314000, 26795000, 7075000, 19634000)
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, sales_general_admin, operating_income, ebit, interest_expense, earnings_before_tax, income_tax, net_income_common) VALUES ((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 189335000, 136286000, 53049000, 19192000, 9428000, 12852000, 5106000, 7746000, 6451000, 1295000)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Amazon Web Services (AWS)', 'Diamond', 'Cloud Infrastructure', 52.5000, 14.20)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('IBM', 'Platinum', 'Enterprise Compute / AI', 6.2000, 4.80)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Hetzner', 'Gold', 'Data Center Hosting', 1.4000, 12.50)
INSERT INTO sponsor_tiers (company_name, funding_tier, primary_sector, base_annual_capex_billion, historical_growth_rate) VALUES ('Automattic', 'Silver', 'Digital Web Platforms', 0.4500, 9.50)
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
DB2_EOF
echo "=================================================================="
echo "🎯 SUCESSO: Workspace totalmente compilado e persistido!"
echo "=================================================================="
