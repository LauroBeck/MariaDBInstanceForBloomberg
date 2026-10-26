# MariaDB and IBM Db2 Infrastructure Instance for Bloomberg Analytics

<p align="left">
  <img src="https://shields.io" alt="MariaDB Badge">
  <img src="https://shields.io" alt="IBM Db2 Badge">
  <img src="https://shields.io" alt="Docker Badge">
  <img src="https://shields.io" alt="Bloomberg Badge">
</p>

Esta suíte de infraestrutura relacional robusta foi projetada para unificar e processar dados macroeconômicos e preditivos complexos. O ecossistema simula e armazena tendências de frotas mercantes (**MSC, Maersk, Hapag-Lloyd**), projeções de bens de capital (**CapEx em escala de Trilhões**) e cenários de estocagem de commodities para o horizonte estratégico de **2026-2027**.

---

## 🗺️ Índice de Navegação
* [Architecture Overview](#-architecture-overview)
* [Repository Layout](#-repository-layout)
* [Database Schemas DDL](#-database-schemas-ddl)
* [Multi-Variable Simulation Engine](#-multi-variable-simulation-engine)
* [Geopolitical & Maritime Analysis](#-geopolitical--maritime-analysis)
* [Deployment Instructions](#-deployment-instructions)

---

## 🏗️ Architecture Overview

O ecossistema divide-se em duas camadas principais de processamento contêinerizado para garantir integridade analítica corporativa:
1. **MariaDB Core Layer:** Responsável pelas operações dinâmicas em tempo real, auditoria de frotas marítimas e logs históricos mutáveis de simulação paramétrica (`SimulatePortfolioScenarios`).
2. **IBM Db2 Enterprise Layer:** Camada estável e relacional pura dedicada à alta disponibilidade de dados corporativos (FINDB) e processamento atômico em lotes analíticos fechados.

---

## 📁 Repository Layout

| Arquivo Principal | Escopo Técnico | Linguagem/Engine |
| :--- | :--- | :--- |
| 🚀 [`compile_workspace.sh`](./compile_workspace.sh) | Orquestrador mestre automatizado para provisionamento simultâneo e cruzado. | Bash Shell / SQL |
| 🐬 [`deploy_mariadb_analytics.sh`](./deploy_mariadb_analytics.sh) | Camada transacional de portfólios energéticos, visões virtuais e procedimentos de risco. | MariaDB Dialect |
| 🏢 [`deploy_db2_analytics.sh`](./deploy_db2_analytics.sh) | Instanciação de esquemas de identidade (`IDENTITY`) e tabelas de consolidação corporativa. | IBM Db2 SQL |

---

## 💾 Database Schemas DDL

### 1. Modelagem do Diretório de Ativos (`companies`)
Estrutura central que sincroniza os indicadores reais extraídos dos registros de mercado (JPM, PBR, BP):
* `ticker`: Identificador VARCHAR único indexado.
* `current_price` / `price_change`: Campos decimais precisos para proteção contra truncamento matemático.

### 2. Fluxos Financeiros Históricos e Corredores Marítimos
As tabelas relacionais de demonstrativos (`income_statements`), balanços patrimoniais (`balance_sheets`) e histórico de frotas (`global_energy_capex`) conectam-se por chaves estrangeiras estruturadas sob restrições `ON DELETE CASCADE`.

---

## ⚙️ Multi-Variable Simulation Engine

A engenharia preditiva implementada baseia-se na aplicação de juros compostos contínuos sobre guias orçamentárias brutas através de funções procedurais nativas:

$$\text{Simulated CapEx} = \text{Base CapEx} \times \left(1 + \frac{\text{Growth Rate} + \text{Modifier}}{100}\right)^{\text{Elapsed Years}} \times \left(1 + \frac{\text{Risk Premium}}{100}\right)$$

### Exemplo de Chamada de Stress-Testing (MariaDB):
```sql
-- Executa modelo de 55 meses com incremento de crescimento de 2.50%
CALL SimulatePortfolioScenarios(55, 2.50, 0.00);
```

---

## 🚢 Geopolitical & Maritime Analysis (2026-2027 Horizon)

O ecossistema virtualiza os principais chokepoints de escoamento e as atribuições de frota logística:
* **Suez Canal / Bab el-Mandeb Trade Corridor:** Mapeado para mitigar os gargalos de transporte do Oriente Médio, associado estrategicamente à **Gemini Cooperation** (Maersk & Hapag-Lloyd).
* **Transatlantic Route:** Focada na expansão de extração do pré-sal na América Latina após os desfechos eleitorais de 2026, associada à capacidade consolidada da **MSC Standalone**.
* **Jurong Rock Caverns (2027 Target):** Log de modelagem dedicado ao plano de infraestrutura de armazenamento estratégico asiático da Saudi Aramco (9 milhões de barris).

---

## 🚀 Deployment Instructions

### Pré-requisitos
Certifique-se de possuir o daemon do Docker ativo e os contêineres inicializados com os respectivos nomes de rede:
* `mariadb-server`
* `db2-finance-server`

### Execução em Lote
Para reconstruir e calibrar as tabelas, índices, procedures e logs analíticos automaticamente em sua máquina local, basta rodar o comando:
```bash
chmod +x compile_workspace.sh
./compile_workspace.sh
```

---
💡 *Bloomberg Terminal Data Model Integration Portfolio - Designed for Academic & Professional Financial Risk Evaluation Platforms.*
