-- ============================================================
-- PROJET 02 — MOBILE MONEY ANALYTICS CAMEROON
-- SQLite
-- ============================================================

-- 1. Nombre total de transactions
SELECT COUNT(*) AS nombre_transactions
FROM fact_transactions;

-- 2. Valeur totale des transactions réussies
SELECT ROUND(SUM(amount_fcfa), 0) AS valeur_transactions_fcfa
FROM fact_transactions
WHERE status = 'Success';

-- 3. KPI financiers
SELECT
    COUNT(*) AS transactions,
    SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END) AS transactions_reussies,
    ROUND(100.0 * SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS taux_succes_pct,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    ROUND(AVG(CASE WHEN status='Success' THEN amount_fcfa END),0) AS montant_moyen_fcfa,
    SUM(fee_fcfa) AS frais_fcfa,
    SUM(agent_commission_fcfa) AS commissions_agents_fcfa,
    SUM(net_revenue_fcfa) AS revenu_net_fcfa
FROM fact_transactions;

-- 4. Performance par opérateur
SELECT
    operator,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    SUM(fee_fcfa) AS frais_fcfa,
    SUM(net_revenue_fcfa) AS revenu_net_fcfa,
    ROUND(100.0 * SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END) / COUNT(*),2) AS taux_succes_pct
FROM fact_transactions
GROUP BY operator
ORDER BY valeur_fcfa DESC;

-- 5. Performance par type de transaction
SELECT
    transaction_type,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    ROUND(AVG(CASE WHEN status='Success' THEN amount_fcfa END),0) AS montant_moyen_fcfa,
    SUM(net_revenue_fcfa) AS revenu_net_fcfa
FROM fact_transactions
GROUP BY transaction_type
ORDER BY valeur_fcfa DESC;

-- 6. Villes les plus actives
SELECT
    city,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    SUM(net_revenue_fcfa) AS revenu_net_fcfa
FROM fact_transactions
GROUP BY city
ORDER BY valeur_fcfa DESC;

-- 7. Analyse des canaux
SELECT
    channel,
    COUNT(*) AS transactions,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM fact_transactions),2) AS part_transactions_pct,
    ROUND(100.0 * SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END) / COUNT(*),2) AS taux_succes_pct
FROM fact_transactions
GROUP BY channel
ORDER BY transactions DESC;

-- 8. Segments clients
SELECT
    c.client_segment,
    COUNT(*) AS transactions,
    COUNT(DISTINCT f.client_id) AS clients_actifs,
    ROUND(SUM(CASE WHEN f.status='Success' THEN f.amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    ROUND(AVG(CASE WHEN f.status='Success' THEN f.amount_fcfa END),0) AS montant_moyen_fcfa
FROM fact_transactions f
JOIN dim_client c ON f.client_id = c.client_id
GROUP BY c.client_segment
ORDER BY valeur_fcfa DESC;

-- 9. Top 15 clients par valeur
SELECT
    f.client_id,
    c.client_segment,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN f.status='Success' THEN f.amount_fcfa ELSE 0 END),0) AS valeur_fcfa
FROM fact_transactions f
JOIN dim_client c ON f.client_id = c.client_id
GROUP BY f.client_id, c.client_segment
ORDER BY valeur_fcfa DESC
LIMIT 15;

-- 10. Top 15 agents par activité
SELECT
    f.agent_id,
    a.operator,
    a.agent_type,
    a.city,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN f.status='Success' THEN f.amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    SUM(f.agent_commission_fcfa) AS commissions_fcfa
FROM fact_transactions f
JOIN dim_agent a ON f.agent_id = a.agent_id
GROUP BY f.agent_id, a.operator, a.agent_type, a.city
ORDER BY transactions DESC
LIMIT 15;

-- 11. Raisons d'échec
SELECT
    failure_reason,
    COUNT(*) AS echecs,
    ROUND(100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM fact_transactions WHERE status='Failed'),2) AS part_echecs_pct
FROM fact_transactions
WHERE status='Failed'
GROUP BY failure_reason
ORDER BY echecs DESC;

-- 12. Heures de forte activité
SELECT
    hour,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa
FROM fact_transactions
GROUP BY hour
ORDER BY transactions DESC;

-- 13. Evolution mensuelle
SELECT
    year_month,
    COUNT(*) AS transactions,
    ROUND(SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END),0) AS valeur_fcfa,
    SUM(net_revenue_fcfa) AS revenu_net_fcfa
FROM fact_transactions
GROUP BY year_month
ORDER BY year_month;

-- 14. Croissance MoM de la valeur
WITH mensuel AS (
    SELECT
        year_month,
        SUM(CASE WHEN status='Success' THEN amount_fcfa ELSE 0 END) AS valeur
    FROM fact_transactions
    GROUP BY year_month
),
evolution AS (
    SELECT
        year_month,
        valeur,
        LAG(valeur) OVER (ORDER BY year_month) AS valeur_prec
    FROM mensuel
)
SELECT
    year_month,
    ROUND(valeur,0) AS valeur_fcfa,
    ROUND(100.0 * (valeur - valeur_prec) / valeur_prec,2) AS croissance_mom_pct
FROM evolution
ORDER BY year_month;

-- 15. Taux d'échec par canal
SELECT
    channel,
    COUNT(*) AS total,
    SUM(CASE WHEN status='Failed' THEN 1 ELSE 0 END) AS echecs,
    ROUND(100.0 * SUM(CASE WHEN status='Failed' THEN 1 ELSE 0 END) / COUNT(*),2) AS taux_echec_pct
FROM fact_transactions
GROUP BY channel
ORDER BY taux_echec_pct DESC;

-- 16. Vue analytique pour Python / BI
SELECT * FROM vw_mobile_money_analysis LIMIT 20;