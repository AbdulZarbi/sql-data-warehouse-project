 
 -- Inserting dataset into the bronze_crm_cust_info table
 -- Note: Make sure to adjust the file path in the LOAD DATA INFILE statement to match the location of your dataset.        
 -- Also, ensure that the MySQL server has the necessary permissions to read the file and that the local_infile variable is enabled.  
SET GLOBAL local_infile = 1;

TRUNCATE TABLE bronze_crm_cust_info;
 LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    INTO TABLE bronze_crm_cust_info
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_crm_cust_info;
    SELECT COUNT(*) FROM bronze_crm_cust_info;

    TRUNCATE TABLE bronze_crm_prd_info;
    LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    INTO TABLE bronze_crm_prd_info
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_crm_prd_info;
    SELECT COUNT(*) FROM bronze_crm_prd_info;

    TRUNCATE TABLE bronze_crm_sales_details;
    LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    INTO TABLE bronze_crm_sales_details
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_crm_sales_details;
    SELECT COUNT(*) FROM bronze_crm_sales_details;

    TRUNCATE TABLE bronze_erp_cust_a101;
    LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    INTO TABLE bronze_erp_cust_a101
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_erp_cust_a101;
    SELECT COUNT(*) FROM bronze_erp_cust_a101;

    TRUNCATE TABLE bronze_erp_cust_az12;
    LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
    INTO TABLE bronze_erp_cust_az12
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_erp_cust_az12;
    SELECT gen, COUNT(*) AS total 
    FROM bronze_erp_cust_az12
    GROUP BY gen;

    TRUNCATE TABLE bronze_erp_px_cat_g1v2;
    LOAD DATA LOCAL INFILE '/Users/zarbi/Documents/Data_Warehouse_project/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    INTO TABLE bronze_erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    IGNORE 1 ROWS;

    SELECT * FROM bronze_erp_px_cat_g1v2;
    SELECT COUNT(*) FROM bronze_erp_px_cat_g1v2;