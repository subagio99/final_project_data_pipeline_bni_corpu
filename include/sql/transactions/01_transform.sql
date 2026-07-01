-- Transform: stg_bank_transactions → dim_bank_transactions / fact_bank_transactions
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE fact_transactions;

INSERT INTO fact_transactions (
    transaction_id,
    transaction_code,
    account_id,
    customer_id,
    branch_id,
    channel_id,
    transaction_date,
    transaction_at,
    transaction_type,
    amount,
    balance_before,
    balance_after,
    status,
    reference_no,
    -- derived columns
    transaction_hour,
    is_high_value_trx,
    is_balance_consistent
)
SELECT DISTINCT ON (transaction_id)
    transaction_id,
    transaction_code,
    account_id,
    customer_id,
    branch_id,
    channel_id,
    transaction_date::DATE,
    transaction_at::TIMESTAMP,
    UPPER(transaction_type) AS transaction_type,
    amount,
    balance_before,
    balance_after,
    UPPER(status) AS status,
    reference_no,
    -- 1. Derived Column: Mengambil komponen jam dari waktu transaksi
    EXTRACT(HOUR FROM transaction_at::TIMESTAMP)::SMALLINT AS transaction_hour,
    -- 2. Derived Column: Penanda transaksi bernilai besar (misal: di atas Rp 5.000.000)
    CASE 
        WHEN amount >= 5000000 THEN TRUE 
        ELSE FALSE 
    END AS is_high_value_trx,
    -- 3. Derived Column: Cek konsistensi kalkulasi saldo (tergantung tipe DEBIT/KREDIT jika ada)
    CASE 
        WHEN (balance_before - amount = balance_after) OR (balance_before + amount = balance_after) THEN TRUE
        ELSE FALSE
    END AS is_balance_consistent
FROM stg_bank_transactions
WHERE transaction_id IS NOT NULL
ORDER BY transaction_id;