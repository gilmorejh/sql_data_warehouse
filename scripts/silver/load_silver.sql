/*
+++++++++++++++++++++++++++++++++++++++++++
Stored Procedure: silver.load_silver
+++++++++++++++++++++++++++++++++++++++++++
Purpose:
	This procedure transforms and loads cleaned data from the Bronze layer into the Silver layer
	of the data warehouse. It performs full refreshes by truncating Silver tables, standardizes
	and validates fields, corrects data quality issues, derives business-ready attributes, and
	logs load durations for monitoring performance. Error handling is included to capture and
	report failures during execution.

Usage:
	Execute this procedure to refresh the Silver layer as part of the data
	cleansing and transformation pipeline before downstream analytics.
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @start_full DATETIME, @end_full DATETIME

		SET @start_full = GETDATE()
			PRINT '===========================';
			PRINT 'Loading Silver Layer';
			PRINT '===========================';

			PRINT '----------------------------';
			PRINT 'Loading CRM Tables';
			PRINT '----------------------------';

		-- Clear silver.crm_cust_info if info exsists
		SET @start_time = GETDATE();
		PRINT('Truncating silver.crm_cust_info')
		TRUNCATE TABLE silver.crm_cust_info;

		-- Insert data into sivler.crm_cust_info
		PRINT('Inserting cleaned data into silver.crm_cust_info')
		INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)

		-- Clean data from bronze.crm_cust_info for silver
		SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			 ELSE 'N/A'
		END cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 ELSE 'N/A'
		END cst_gndr,
		cst_create_date
		FROM(
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE flag_last = 1 

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'

		--------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT('Truncating silver.crm_prd_info')
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT('Inserting cleaned data into silver.crm_prd_info')
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start,
			prd_end_dt
		)

		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
			prd_nm,
			ISNULL(prd_cost,0) as prd_cost,
			CASE UPPER(TRIM(prd_line))
				 WHEN 'M' THEN 'Mountain'
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Other Sales'
				 WHEN 'T' THEN 'Touring'
				 ELSE 'N/A'
			END as prd_line,
			CAST (prd_start_dt as DATE) as prd_start_dt,
			CAST (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
		FROM bronze.crm_prd_info

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'
		-------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT('Truncating silver.crm_sales_details')
		TRUNCATE TABLE silver.crm_sales_details

		PRINT('Inserting cleaned data into silver.crm_sales_details')
		INSERT INTO silver.crm_sales_details(
			sls_order_num,
			sls_product_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT
			sls_order_num,
			sls_product_key,
			sls_cust_id,
			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
			 THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <=0
				 THEN sls_price / NULLIF(sls_quantity, 0)
				 ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'

		-------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT('Truncating silver.erp_cust_az12')
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT('Inserting cleaned data into silver.erp_cust_az12')
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)

		SELECT
		CASE WHEN cid LIKE 'NAS%' THEN substring(cid, 4, LEN(cid))
			 ELSE cid
		END AS cid,
		CASE WHEN bdate > GETDATE() THEN NULL
			 ELSE bdate
		END AS bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			 ELSE 'N/A'
		END as gen
		FROM bronze.erp_cust_az12

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'

		-------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT('Truncating silver.erp_loc_a101')
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT('Inserting cleaned data into silver.erp_loc_a101')
		INSERT INTO silver.erp_loc_a101
		(cid, cntry)

		SELECT
			REPLACE(cid, '-', ''),
			CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				 WHEN TRIM(cntry) = '' or cntry IS NULL THEN 'N/A'
				 ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'
		-------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT('Truncating silver.erp_px_cat_g1v2')
		TRUNCATE TABLE silver.erp_px_cat_g1v2

		PRINT('Inserting cleaned data into silver.erp_px_cat_g1v2')
		INSERT INTO silver.erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenance
		)

		SELECT
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE()
			PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
			PRINT'-------------------------'
		-------------------------------------------------------------------------------
		SET @end_full = GETDATE()
		PRINT 'Total Load Curation for Silver Layer: ' + CAST(DATEDIFF(second, @start_full, @end_full) as NVARCHAR) + ' seconds.'
	END TRY
		BEGIN CATCH
			PRINT '==================================================';
			PRINT 'Error Occured During Loading Silver Layer';
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Mesage' + CAST (ERROR_NUMBER() as NVARCHAR);
			PRINT '=================================================='
		END CATCH
END;

EXEC silver.load_silver