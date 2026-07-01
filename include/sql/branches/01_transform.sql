-- Transform: stg_branches → dim_branches
-- Cast tipe data, tambah derived columns, deduplikasi

TRUNCATE TABLE dim_branches;

INSERT INTO dim_branches (
    branch_id,
    branch_code,
    branch_name,
    city,
    province,
    region,
    branch_type,
    open_date,
    is_active,
    -- derived columns
    branch_age_years,
    branch_type_name
)
SELECT DISTINCT ON (branch_id)
    branch_id,
    branch_code,
    branch_name,
    city,
    province,
    region,
    branch_type,
    open_date::DATE,
    CASE WHEN LOWER(is_active) = 'true' THEN TRUE ELSE FALSE END AS is_active,
    -- 1. Derived Column: Menghitung umur operasional cabang (tahun) sejak tanggal buka
    DATE_PART('year', AGE(CURRENT_DATE, open_date::DATE))::SMALLINT AS branch_age_years,
    -- 2. Derived Column: Mengubah kode tipe cabang menjadi deskripsi lengkapnya
    CASE
        WHEN UPPER(branch_type) = 'KCU' THEN 'Kantor Cabang Utama'
        WHEN UPPER(branch_type) = 'KCP' THEN 'Kantor Cabang Pembantu'
        WHEN UPPER(branch_type) = 'KK'  THEN 'Kantor Kas'
        ELSE 'Lainnya'
    END AS branch_type_name
FROM stg_branches
WHERE branch_id IS NOT NULL
ORDER BY branch_id;