-- Schéma simplifié
-- dim_client 1 ---- * fact_transactions * ---- 1 dim_agent

PRAGMA foreign_keys = ON;

CREATE TABLE dim_client (
    client_id TEXT PRIMARY KEY,
    client_segment TEXT NOT NULL,
    home_city TEXT NOT NULL,
    home_region TEXT NOT NULL,
    preferred_operator TEXT NOT NULL
);

CREATE TABLE dim_agent (
    agent_id TEXT PRIMARY KEY,
    operator TEXT NOT NULL,
    agent_type TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE fact_transactions (
    transaction_id TEXT PRIMARY KEY,
    datetime_tx TEXT NOT NULL,
    date_tx TEXT NOT NULL,
    year INTEGER NOT NULL,
    year_month TEXT NOT NULL,
    hour INTEGER NOT NULL,
    day_of_week TEXT NOT NULL,
    operator TEXT NOT NULL,
    transaction_type TEXT NOT NULL,
    channel TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    client_id TEXT NOT NULL,
    agent_id TEXT NOT NULL,
    amount_fcfa INTEGER NOT NULL,
    fee_fcfa INTEGER NOT NULL,
    agent_commission_fcfa INTEGER NOT NULL,
    net_revenue_fcfa INTEGER NOT NULL,
    status TEXT NOT NULL,
    failure_reason TEXT
);
-- Indexes utiles pour les analyses
CREATE INDEX IF NOT EXISTS idx_fact_transactions_date ON fact_transactions(date_tx);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_operator ON fact_transactions(operator);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_city ON fact_transactions(city);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_client ON fact_transactions(client_id);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_agent ON fact_transactions(agent_id);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_status ON fact_transactions(status);

-- Vue analytique utilisée par le notebook
CREATE VIEW IF NOT EXISTS vw_mobile_money_analysis AS
SELECT
    f.transaction_id,
    f.datetime_tx,
    f.date_tx,
    f.year,
    f.year_month,
    f.hour,
    f.day_of_week,
    f.operator,
    f.transaction_type,
    f.channel,
    f.city,
    f.region,
    c.client_segment,
    a.agent_type,
    f.client_id,
    f.agent_id,
    f.amount_fcfa,
    f.fee_fcfa,
    f.agent_commission_fcfa,
    f.net_revenue_fcfa,
    f.status,
    f.failure_reason
FROM fact_transactions f
JOIN dim_client c ON f.client_id = c.client_id
JOIN dim_agent a ON f.agent_id = a.agent_id;
