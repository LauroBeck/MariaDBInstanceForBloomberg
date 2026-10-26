#!/bin/bash
# Unified MariaDB Institutional Portfolio Deployment Script
# Targets: JPM, PBR, BP, ARAMCO Financial Records & Maritime Logic

docker exec -i mariadb-server mariadb -u root -p"your_secure_password" << 'INNER_EOF'
-- 1. Initialize Fresh Database Context
DROP DATABASE IF EXISTS corporate_finance_db;
CREATE DATABASE corporate_finance_db;
USE corporate_finance_db;

-- 2. Build Central Directory Entities
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

-- 3. Build Deep Income Statement Ledger
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

-- 4. Build Complete Corporate Balance Sheets
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

-- 5. Build Macro Energy CapEx Infrastructure Directory
CREATE TABLE global_energy_capex (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(15) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    domicile_region VARCHAR(50) NOT NULL,
    annual_capex_guidance_billion DECIMAL(18, 4) NOT NULL,
    projected_annual_growth_rate DECIMAL(5, 2) NOT NULL
);

-- 6. Build Permanent Maritime Historical Audit Log Table
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

-- 7. Seed Directory Registries
INSERT INTO companies (ticker, company_name, current_price, price_change, pct_change, volume, week_range_low, week_range_high) VALUES
('JPM', 'JP Morgan Chase & Co. Common Stock', 331.58, -4.96, -1.47, 4781132, 279.10, 366.50),
('PBR', 'Petroleo Brasileiro S.A. Petrobras ADS', 26.16, 0.54, 2.11, 25136507, 11.43, 26.12),
('BP', 'BP p.l.c. Common Stock', 51.32, 1.27, 2.54, 9156710, 33.22, 50.42);

-- 8. Seed Comprehensive 4-Year Income Statements
INSERT INTO income_statements (company_id, fiscal_year, total_revenue, cost_of_revenue, gross_profit, research_development, sales_general_admin, non_recurring_items, other_operating_items, operating_income, additional_items, ebit, interest_expense, earnings_before_tax, income_tax, net_income, net_income_common) VALUES
-- JPM
((SELECT company_id FROM companies WHERE ticker='JPM'), 2025, 168235000, 0, 168235000, 0, 95640000, 0, 14212000, 72595000, 0, 170493000, 97898000, 72595000, 15547000, 57048000, 55681000),
((SELECT company_id FROM companies WHERE ticker='JPM'), 2024, 166878000, 0, 166878000, 0, 91797000, 0, 10678000, 75081000, 0, 176431000, 101350000, 75081000, 16610000, 58471000, 56868000),
((SELECT company_id FROM companies WHERE ticker='JPM'), 2023, 148784000, 0, 148784000, 0, 87172000, 0, 9320000, 61612000, 0, 142933000, 81321000, 61612000, 12060000, 49552000, 47760000),
((SELECT company_id FROM companies WHERE ticker='JPM'), 2022, 122306000, 0, 122306000, 0, 78140000, 0, 6389000, 46166000, 0, 72263000, 26097000, 46166000, 8490000, 37676000, 35892000),
-- PBR
((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 89195000, 46736000, 42459000, 864000, 12746000, 2736000, 0, 26113000, 5048000, 31109000, 4314000, 26795000, 7075000, 19634000, 19634000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2024, 91416000, 45444000, 45972000, 789000, 15863000, 24446000, 0, 26876000, -9150000, 17099000, 5957000, 11142000, 3537000, 7528000, 7528000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2023, 102409000, 48435000, 53974000, 726000, 11553000, 3662000, 0, 38033000, 1589000, 39318000, 3922000, 35396000, 10401000, 24884000, 24884000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2022, 124474000, 59486000, 64988000, 792000, 4880000, 2202000, 0, 57114000, -340000, 57025000, 3500000, 53525000, 16770000, 36623000, 36623000),
-- BP
((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 189335000, 136286000, 53049000, 0, 19192000, 6607000, 17822000, 9428000, 2806000, 12852000, 5106000, 7746000, 6451000, 1295000, 1295000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2024, 189185000, 140525000, 48660000, 0, 18216000, 7969000, 16622000, 5853000, 3619000, 11465000, 4683000, 6782000, 5553000, 1229000, 1229000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2023, 210130000, 144351000, 65779000, 0, 18551000, 6854000, 15928000, 24446000, 2245000, 27589000, 3840000, 23749000, 7869000, 1588000, 1588000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2022, 241392000, 169653000, 71739000, 0, 15774000, 31107000, 14318000, 10540000, 5038000, 18108000, 2703000, 15405000, 16762000, -1357000, -1357000);

-- 9. Seed Full Operational Balance Sheets (BP and PBR)
INSERT INTO balance_sheets (company_id, fiscal_year, cash_cash_equivalents, short_term_investments, net_receivables, inventory, other_current_assets, total_current_assets, long_term_investments, fixed_assets, goodwill, intangible_assets, other_assets, deferred_asset_charges, total_assets, accounts_payable, short_term_debt, other_current_liabilities, total_current_liabilities, long_term_debt, other_liabilities, deferred_liability_charges, misc_stocks, total_liabilities, common_stocks, capital_surplus, other_equity, total_equity) VALUES
-- PBR
((SELECT company_id FROM companies WHERE ticker='PBR'), 2025, 6471000, 2726000, 6653000, 8210000, 1388000, 25448000, 5946000, 168040000, 0, 2523000, 19365000, 1015000, 222337000, 18444000, 2186000, 15421000, 36051000, 24831000, 79210000, 6354000, 326000, 146446000, 107101000, 72600000, -104136000, 75565000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2024, 3271000, 4263000, 5532000, 6710000, 2060000, 21836000, 6098000, 136285000, 0, 2255000, 14249000, 922000, 181645000, 15738000, 2566000, 13156000, 31460000, 21126000, 68239000, 1470000, 244000, 122295000, 107101000, 61446000, -109441000, 59106000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2023, 12727000, 2819000, 7313000, 7681000, 1905000, 32445000, 12445000, 153424000, 0, 3042000, 14746000, 965000, 217067000, 16750000, 4322000, 12788000, 33860000, 24778000, 68544000, 10910000, 392000, 138092000, 107101000, 72641000, -101159000, 78583000),
((SELECT company_id FROM companies WHERE ticker='PBR'), 2022, 7996000, 2773000, 6317000, 8779000, 5385000, 31250000, 10901000, 130169000, 0, 2986000, 11053000, 832000, 187191000, 17781000, 3576000, 10023000, 31380000, 26680000, 52545000, 6750000, 344000, 117355000, 107101000, 66434000, -104043000, 69492000),
-- BP
((SELECT company_id FROM companies WHERE ticker='BP'), 2025, 36556000, 158000, 27167000, 22499000, 15406000, 101786000, 52686000, 98633000, 10300000, 8197000, 2599000, 4325000, 278526000, 63677000, 7769000, 9135000, 80581000, 62577000, 34059000, 27309000, 20948000, 204526000, 0, 0, 0, 53052000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2024, 39204000, 165000, 28223000, 23232000, 12010000, 102834000, 46710000, 100238000, 14888000, 9646000, 2509000, 5403000, 282228000, 66055000, 8821000, 7365000, 82241000, 64482000, 30227000, 26960000, 19072000, 20391000, 0, 0, 0, 59246000),

((SELECT company_id FROM companies WHERE ticker='BP'), 2023, 33030000, 843000, 3196000, 22819000, 15494000, 104146000, 42133000, 104719000, 12472000, 9991000, 2565000, 4268000, 280294000, 70414000, 8534000, 7130000, 86078000, 58746000, 29958000, 20019000, 15210000, 19480010, 0, 0, 0, 70283000),
((SELECT company_id FROM companies WHERE ticker='BP'), 2022, 29195000, 578000, 34631000, 28081000, 15203000, 107688000, 46473000, 106044000, 11960000, 1020000, 1847000, 3908000, 288120000, 74447000, 15816000, 8755000, 99018000, 54133000, 27916000, 24063000, 15437000, 205130000, 0, 0, 0, 67553000);
-- 10. Seed Macro Energy Outlay Parameters
INSERT INTO global_energy_capex (ticker, company_name, domicile_region, annual_capex_guidance_billion, projected_annual_growth_rate) VALUES
('ARAMCO', 'Saudi Arabian Oil Company (Saudi Aramco)', 'Middle East', 55.0000, 8.50),
('PBR', 'Petroleo Brasileiro S.A. (Petrobras)', 'Latin America', 31.8000, 11.20),
('BP', 'BP p.l.c.', 'Europe', 16.5000, -3.50);
-- 11. Deploy Virtual Shipping Corridors View Layer
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
WHEN e.domicile_region = 'Middle East' THEN 'Gemini Cooperation (Maersk & Hapag-Lloyd - Suez Transits)'
WHEN e.domicile_region = 'Latin America' THEN 'MSC Standalone / Fleet Consolidation Fleet'
ELSE 'Premier Alliance Network Slots'
END AS dominant_container_carriers
FROM global_energy_capex e;
-- 12. Deploy Stored Multi-Variable Analytical Simulator Engine
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
-- 13. Run Immediate Engine Calibration Tests
CALL SimulatePortfolioScenarios(55, 2.50, 0.00);
CALL SimulatePortfolioScenarios(24, 0.00, 4.10);
-- 14. Final Validation Check
SELECT log_id, ticker, horizonte_meses, capex_simulado_bilhao AS 'Simulated CapEx ($B)' FROM simula_maritima_log;
INNER_EOF
