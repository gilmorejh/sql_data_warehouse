/*
+++++++++++++++++++++++++++++++++++++++++++
DDL Script: Silver Schema Table Setup
+++++++++++++++++++++++++++++++++++++++++++
Purpose:
	This script creates tables in the 'silver' schema. If the tables already exist,
	they will be dropped and recreated. Use this script to reset and rebuild
	the DDL structure for the Silver layer.
*/



IF OBJECT_ID('silver.crm_cust_info', 'U') is not null
	DROP TABLE silver.crm_cust_info;
create table silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') is not null
	DROP TABLE silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') is not null
	DROP TABLE silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_order_num NVARCHAR(50),
	sls_product_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') is not null
	DROP TABLE silver.erp_cust_az12;
create table silver.erp_cust_az12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') is not null
	DROP TABLE silver.erp_loc_a101;
create table silver.erp_loc_a101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') is not null
	DROP TABLE silver.erp_px_cat_g1v2;
create table silver.erp_px_cat_g1v2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
