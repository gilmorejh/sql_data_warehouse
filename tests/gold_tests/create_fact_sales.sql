IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_order_num as order_number,
pr.product_key,
cu.customer_id,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price
FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
		ON sd.sls_product_key = pr.product_number
	LEFT JOIN gold.dim_customers cu
		ON sd.sls_cust_id = cu.customer_id