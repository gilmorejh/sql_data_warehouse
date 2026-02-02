/*
+++++++++++++++++++++++++++++++++++++++++++
DDL Script: Bronze Schema Table Setup
+++++++++++++++++++++++++++++++++++++++++++
Purpose:
	This script creates tables in the 'bronze' schema. If the tables already exist,
	they will be dropped and recreated. Use this script to reset and rebuild
	the DDL structure for the Bronze layer.
*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') is not null
	DROP TABLE bronze.crm_cust_info;
create table bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
GO

IF OBJECT_ID('bronze.crm_prd_info', 'U') is not null
	DROP TABLE bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start DATE,
	prd_end_dt DATE
);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') is not null
	DROP TABLE bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_order_num NVARCHAR(50),
	sls_product_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') is not null
	DROP TABLE bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_loc_a101', 'U') is not null
	DROP TABLE bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') is not null
	DROP TABLE bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
