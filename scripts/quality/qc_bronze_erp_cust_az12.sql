-- ============================================================
-- Quality Check: bronze_erp_cust_az12
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_erp_cust_az12 to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on primary key (id)
-- Expect: 0 rows returned
SELECT id, COUNT(*) AS cnt
FROM bronze_erp_cust_az12
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL or empty values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN id    IS NULL OR TRIM(id)  = '' THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN bdate IS NULL               THEN 1 ELSE 0 END) AS null_bdate,
    SUM(CASE WHEN gen   IS NULL OR TRIM(gen) = '' THEN 1 ELSE 0 END) AS null_gen
FROM bronze_erp_cust_az12;

-- -------------------------------------------------------

-- CHECK 3: Unwanted whitespace in text fields
-- Expect: 0 rows returned for each
SELECT id  FROM bronze_erp_cust_az12 WHERE id  != TRIM(id);
SELECT gen FROM bronze_erp_cust_az12 WHERE gen != TRIM(gen);

-- -------------------------------------------------------

-- CHECK 4: Future or unrealistic birth dates
-- Expect: 0 rows returned
SELECT id, bdate
FROM bronze_erp_cust_az12
WHERE bdate > CURDATE()          -- future date
   OR bdate < '1900-01-01';      -- unrealistically old

-- -------------------------------------------------------

-- CHECK 5: Distinct gender values (standardization check)
-- Review: confirm all values are expected codes/labels
SELECT gen, COUNT(*) AS cnt
FROM bronze_erp_cust_az12
GROUP BY gen
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 6: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_erp_cust_az12;