# Data Dictionary for Gold Layer

## 1. gold.dim_customers

**Purpose:** Stores customer demographic and profile details for analytics and reporting.

| Column Name      | Data Type      | Description |
|------------------|---------------|-------------|
| customer_key     | int           | Surrogate primary key used to uniquely identify each customer record in the dimension table. |
| customer_id      | int           | Business key representing the original customer ID from the source system. |
| customer_number  | nvarchar(50)  | External or business-facing customer identifier, often used in reporting or CRM systems. |
| first_name       | nvarchar(50)  | Customer’s given (first) name. |
| last_name        | nvarchar(50)  | Customer’s family (last) name. |
| country          | nvarchar(50)  | Country of residence for the customer. |
| marital_status   | nvarchar(50)  | Customer’s marital status (e.g., Single, Married, N/A). |
| gender           | nvarchar(50)  | Customer’s self-reported gender (e.g., Male, Female, N/A). |
| birthdate        | date          | Customer’s date of birth, used for age-based analytics. |
| create_date      | date          | Date the customer record was created in the system or data warehouse. |

## gold.dim_products

**Purpose:** Provides product master data, classification details, and core attributes to support analytics, reporting, and business insights.

| Column Name      | Data Type      | Description |
|------------------|---------------|-------------|
| product_key      | int           | Surrogate primary key uniquely identifying each product record in the dimension table. |
| product_id       | int           | Business key representing the original product ID from the source system. |
| product_number   | int           | Unique product reference number used for internal tracking and reporting. |
| category_id      | nvarchar(50)  | Identifier linking the product to its primary category. |
| category         | nvarchar(50)  | High-level product category classification (e.g., Electronics, Apparel). |
| sub_category     | nvarchar(50)  | More granular product classification within the main category. |
| maintenance      | nvarchar(50)  | Indicates whether the product requires maintenance as part of its lifecycle or usage (Yes/No). |
| cost             | int           | Base cost of the product, typically representing manufacturing or procurement cost. |
| product_line     | nvarchar(50)  | Product line or brand grouping used for portfolio segmentation. |
| start_date       | date          | Date the product became active or available for sale in the system. |

## gold.fact_sales

**Purpose:** Stores transactional sales data to support revenue analysis, customer behavior insights, and business performance reporting.

| Column Name     | Data Type      | Description |
|-----------------|---------------|-------------|
| order_number    | nvarchar(50)  | Unique identifier for each customer order or sales transaction. |
| product_key     | int           | Foreign key linking to `gold.dim_products`, identifying the product sold. |
| customer_id     | int           | Business key identifying the customer who placed the order. |
| order_date      | date          | Date the order was placed by the customer. |
| shipping_date   | date          | Date the order was shipped to the customer. |
| due_date        | date          | Expected or contractual delivery or payment due date. |
| sales           | int           | Total sales amount for the transaction line, typically representing revenue. |
| quantity        | int           | Number of product units sold in the transaction. |
| price           | int           | Unit price of the product at the time of sale. |
 
  
