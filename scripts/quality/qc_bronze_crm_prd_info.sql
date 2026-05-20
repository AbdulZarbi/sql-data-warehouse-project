-- ============================================================
-- Quality Check: bronze_crm_prd_info
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_crm_prd_info to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on primary key (prd_id)
-- Expect: 0 rows returned
SELECT prd_id, COUNT(*) AS cnt
FROM bronze_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL or empty values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN prd_id       IS NULL                      THEN 1 ELSE 0 END) AS null_prd_id,
    SUM(CASE WHEN prd_key      IS NULL OR TRIM(prd_key) = '' THEN 1 ELSE 0 END) AS null_prd_key,
    SUM(CASE WHEN prd_nm       IS NULL OR TRIM(prd_nm)  = '' THEN 1 ELSE 0 END) AS null_prd_nm,
    SUM(CASE WHEN prd_cost     IS NULL                      THEN 1 ELSE 0 END) AS null_prd_cost,
    SUM(CASE WHEN prd_line     IS NULL OR TRIM(prd_line)= '' THEN 1 ELSE 0 END) AS null_prd_line,
    SUM(CASE WHEN prd_start_dt IS NULL                      THEN 1 ELSE 0 END) AS null_prd_start_dt,
    SUM(CASE WHEN prd_end_dt   IS NULL                      THEN 1 ELSE 0 END) AS null_prd_end_dt
FROM bronze_crm_prd_info;

-- -------------------------------------------------------

-- CHECK 3: Unwanted leading/trailing whitespace in text fields
-- Expect: 0 rows returned for each
SELECT prd_key  FROM bronze_crm_prd_info WHERE prd_key  != TRIM(prd_key);
SELECT prd_nm   FROM bronze_crm_prd_info WHERE prd_nm   != TRIM(prd_nm);
SELECT prd_line FROM bronze_crm_prd_info WHERE prd_line != TRIM(prd_line);

-- -------------------------------------------------------

-- CHECK 4: Invalid cost values (negative or zero)
-- Expect: 0 rows returned
SELECT prd_id, prd_nm, prd_cost
FROM bronze_crm_prd_info
WHERE prd_cost <= 0;

-- -------------------------------------------------------

-- CHECK 5: Invalid date logic (end date before start date)
-- Expect: 0 rows returned
SELECT prd_id, prd_nm, prd_start_dt, prd_end_dt
FROM bronze_crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;

-- -------------------------------------------------------

-- CHECK 6: Distinct prd_line values (standardization check)
-- Review: confirm all values are expected codes/labels
SELECT prd_line, COUNT(*) AS cnt
FROM bronze_crm_prd_info
GROUP BY prd_line
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 7: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_crm_prd_info;