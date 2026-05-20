-- ============================================================
-- Quality Check: bronze_crm_sales_details
-- Database:      DataWarehouse
-- Run BEFORE loading into silver_crm_sales_details to catch issues
-- ============================================================

USE DataWarehouse;

-- CHECK 1: Duplicates & NULL on order number (sls_ord_num)
-- Expect: 0 rows returned
SELECT sls_ord_num, COUNT(*) AS cnt
FROM bronze_crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL;

-- -------------------------------------------------------

-- CHECK 2: NULL values across all columns
-- Expect: all counts = 0
SELECT
    SUM(CASE WHEN sls_ord_num  IS NULL OR TRIM(sls_ord_num)  = '' THEN 1 ELSE 0 END) AS null_sls_ord_num,
    SUM(CASE WHEN sls_prd_key  IS NULL OR TRIM(sls_prd_key)  = '' THEN 1 ELSE 0 END) AS null_sls_prd_key,
    SUM(CASE WHEN sls_cust_id  IS NULL                            THEN 1 ELSE 0 END) AS null_sls_cust_id,
    SUM(CASE WHEN sls_order_dt IS NULL                            THEN 1 ELSE 0 END) AS null_sls_order_dt,
    SUM(CASE WHEN sls_ship_dt  IS NULL                            THEN 1 ELSE 0 END) AS null_sls_ship_dt,
    SUM(CASE WHEN sls_due_dt   IS NULL                            THEN 1 ELSE 0 END) AS null_sls_due_dt,
    SUM(CASE WHEN sls_sales    IS NULL                            THEN 1 ELSE 0 END) AS null_sls_sales,
    SUM(CASE WHEN sls_quantity IS NULL                            THEN 1 ELSE 0 END) AS null_sls_quantity,
    SUM(CASE WHEN sls_price    IS NULL                            THEN 1 ELSE 0 END) AS null_sls_price
FROM bronze_crm_sales_details;

-- -------------------------------------------------------

-- CHECK 3: Unwanted whitespace in text fields
-- Expect: 0 rows returned for each
SELECT sls_ord_num FROM bronze_crm_sales_details WHERE sls_ord_num != TRIM(sls_ord_num);
SELECT sls_prd_key FROM bronze_crm_sales_details WHERE sls_prd_key != TRIM(sls_prd_key);

-- -------------------------------------------------------

-- CHECK 4: Invalid date values (dates stored as INT — check for nonsensical values)
-- Valid range example: 20000101 to 20991231
-- Expect: 0 rows returned
SELECT sls_ord_num, sls_order_dt, sls_ship_dt, sls_due_dt
FROM bronze_crm_sales_details
WHERE sls_order_dt < 20000101 OR sls_order_dt > 20991231
   OR sls_ship_dt  < 20000101 OR sls_ship_dt  > 20991231
   OR sls_due_dt   < 20000101 OR sls_due_dt   > 20991231;

-- -------------------------------------------------------

-- CHECK 5: Invalid date logic (ship or due date before order date)
-- Expect: 0 rows returned
SELECT sls_ord_num, sls_order_dt, sls_ship_dt, sls_due_dt
FROM bronze_crm_sales_details
WHERE sls_ship_dt < sls_order_dt
   OR sls_due_dt  < sls_order_dt;

-- -------------------------------------------------------

-- CHECK 6: Invalid financial values (negative or zero sales/price/quantity)
-- Expect: 0 rows returned
SELECT sls_ord_num, sls_sales, sls_quantity, sls_price
FROM bronze_crm_sales_details
WHERE sls_sales    <= 0
   OR sls_quantity <= 0
   OR sls_price    <= 0;

-- -------------------------------------------------------

-- CHECK 7: Sales consistency (sales should equal quantity * price)
-- Expect: 0 rows returned
SELECT sls_ord_num, sls_sales, sls_quantity, sls_price,
       sls_quantity * sls_price AS expected_sales
FROM bronze_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price;

-- -------------------------------------------------------

-- CHECK 8: Overall row count (baseline reference)
SELECT COUNT(*) AS total_rows FROM bronze_crm_sales_details;