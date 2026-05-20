-- ============================================================
-- Quality Check: bronze_crm_cust_info
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_crm_cust_info to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on primary key (cst_id)
-- Expect: 0 rows returned
SELECT cst_id, COUNT(*) AS cnt
FROM bronze_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL or empty values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN cst_id             IS NULL                          THEN 1 ELSE 0 END) AS null_cst_id,
    SUM(CASE WHEN cst_key            IS NULL OR TRIM(cst_key)    = '' THEN 1 ELSE 0 END) AS null_cst_key,
    SUM(CASE WHEN cst_firstname      IS NULL OR TRIM(cst_firstname) = '' THEN 1 ELSE 0 END) AS null_cst_firstname,
    SUM(CASE WHEN cst_lastname       IS NULL OR TRIM(cst_lastname)  = '' THEN 1 ELSE 0 END) AS null_cst_lastname,
    SUM(CASE WHEN cst_marital_status IS NULL OR TRIM(cst_marital_status) = '' THEN 1 ELSE 0 END) AS null_cst_marital_status,
    SUM(CASE WHEN cst_gender         IS NULL OR TRIM(cst_gender)   = '' THEN 1 ELSE 0 END) AS null_cst_gender,
    SUM(CASE WHEN cst_create_date    IS NULL                          THEN 1 ELSE 0 END) AS null_cst_create_date
FROM bronze_crm_cust_info;

-- -------------------------------------------------------

-- CHECK 3: Unwanted leading/trailing whitespace in text fields
-- Expect: 0 rows returned for each
SELECT cst_key            FROM bronze_crm_cust_info WHERE cst_key            != TRIM(cst_key);
SELECT cst_firstname      FROM bronze_crm_cust_info WHERE cst_firstname      != TRIM(cst_firstname);
SELECT cst_lastname       FROM bronze_crm_cust_info WHERE cst_lastname       != TRIM(cst_lastname);
SELECT cst_marital_status FROM bronze_crm_cust_info WHERE cst_marital_status != TRIM(cst_marital_status);
SELECT cst_gender         FROM bronze_crm_cust_info WHERE cst_gender         != TRIM(cst_gender);

-- -------------------------------------------------------

-- CHECK 4: Distinct cst_marital_status values (standardization check)
-- Review: expect only 'S', 'M' (or already-expanded 'Single', 'Married')
SELECT cst_marital_status, COUNT(*) AS cnt
FROM bronze_crm_cust_info
GROUP BY cst_marital_status
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 5: Distinct cst_gender values (standardization check)
-- Review: expect only 'M', 'F' (or already-expanded 'Male', 'Female')
SELECT cst_gender, COUNT(*) AS cnt
FROM bronze_crm_cust_info
GROUP BY cst_gender
ORDER BY cnt DESC;

-- -------------------------------------------------------

-- CHECK 6: Invalid or zero dates (cst_create_date)
-- Expect: 0 rows returned
SELECT cst_id, cst_create_date
FROM bronze_crm_cust_info
WHERE cst_create_date = '0000-00-00' OR cst_create_date IS NULL;

-- -------------------------------------------------------

-- CHECK 7: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_crm_cust_info;