-- Transform: stg_fraud_labels → dim_fraud_labels
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE dim_fraud_labels;

INSERT INTO dim_fraud_labels (
    transaction_id,
    transaction_code,
    is_fraud,
    fraud_type,
    fraud_score,
    flagged_at,
    -- derived columns
    fraud_risk_level
)
SELECT DISTINCT ON (transaction_id)
    transaction_id,
    transaction_code,
    CASE WHEN LOWER(is_fraud) = 'true' THEN TRUE ELSE FALSE END AS is_fraud,
    -- Menangani jika data kosong (bukan fraud) diberi label 'NOT FRAUD'
    CASE 
        WHEN fraud_type = '' OR fraud_type IS NULL THEN 'NOT FRAUD' 
        ELSE UPPER(fraud_type) 
    END AS fraud_type,
    COALESCE(fraud_score::NUMERIC(5,4), 0.0000) AS fraud_score,
    flagged_at::TIMESTAMP,
    -- 1. Derived Column: Segmentasi tingkat risiko berdasarkan fraud_score
    CASE 
        WHEN COALESCE(fraud_score::NUMERIC(5,4), 0.0000) >= 0.8000 THEN 'CRITICAL'
        WHEN COALESCE(fraud_score::NUMERIC(5,4), 0.0000) >= 0.5000 THEN 'HIGH RISK'
        WHEN COALESCE(fraud_score::NUMERIC(5,4), 0.0000) >= 0.2500 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS fraud_risk_level
FROM stg_fraud_labels
WHERE transaction_id IS NOT NULL
ORDER BY transaction_id;