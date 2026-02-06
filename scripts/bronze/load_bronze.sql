/*
+++++++++++++++++++++++++++++++++++++++++++
Stored Procedure: bronze.load_bronze
+++++++++++++++++++++++++++++++++++++++++++
Purpose:
	This procedure loads raw source data into the Bronze layer of the data warehouse.
	It truncates existing Bronze tables and bulk loads data from CSV source files
	for both CRM and ERP systems. Load durations are logged for each table and for
	the full execution, with error handling to capture and report failures.

Usage:
	Execute this procedure to refresh the Bronze layer from source files
	as part of the ingestion pipeline.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_full DATETIME, @end_full DATETIME
	BEGIN TRY
		SET @start_full = GETDATE()
		PRINT '===========================';
		PRINT 'Loading Bronze Layer';
		PRINT '===========================';

		PRINT '----------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT 'Inserting Data Info: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT 'Inserting Data Info: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT 'Inserting Data Info: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'

		PRINT '----------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '----------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT 'Inserting Data Info: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_erp/CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT 'Inserting Data Info: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_erp/LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT 'Inserting Data Info:bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\john_\OneDrive\Desktop\Data Analysis Portfolio\Data with Baraa\sql_warehouse\sql-data-warehouse-project\datasets\source_erp/PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'-------------------------'
		SET @end_full = GETDATE()
		PRINT 'Total Load Curation for Bronze Layer: ' + CAST(DATEDIFF(second, @start_full, @end_full) as NVARCHAR) + ' seconds.'
		END TRY
		BEGIN CATCH
			PRINT '==================================================';
			PRINT 'Error Occured During Loading Bronze Layer';
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Mesage' + CAST (ERROR_NUMBER() as NVARCHAR);
			PRINT '=================================================='
		END CATCH
END;

EXEC bronze.load_bronze
