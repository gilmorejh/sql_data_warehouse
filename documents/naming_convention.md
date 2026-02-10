# Naming Conventions

This section defines standardized naming rules across all data warehouse layers to ensure consistency, readability, and maintainability.

---

## General Rules

- **Convention:** Snake case (all lowercase with underscores between words)
- **Language:** English
- **Avoid Reserved Words:** SQL reserved words must not be used as object names

---

## Table Naming Conventions

### Bronze Layer Rules

- All table names must start with the **source system name**
- Table names must **match the original source table name exactly**
- No renaming is allowed in the Bronze layer

**Pattern:**
`<sourcesystem>`_`<entity>`


**Definitions:**
- `<sourcesystem>` = Source system name (e.g., crm, erp)
- `<entity>` = Original table name from the source system

**Example:**
- crm_customer_info -- Customer information from CRM system

---

### Silver Layer Rules

- All table names must start with the **source system name**
- Table names must **match the original source table name exactly**
- No renaming is allowed in the Silver layer

**Pattern:**
`<sourcesystem>`_`<entity>`


**Definitions:**
- `<sourcesystem>` = Source system name (e.g., crm, erp)
- `<entity>` = Original table name from the source system

**Example:**
crm_customer_info -- Customer information from CRM system


---

### Gold Layer Rules

- Table names must use **business-friendly and meaningful names**
- Names must start with a **category prefix** indicating table type

**Pattern:**
`<category>`_`<entity>`


**Definitions:**
- `<category>` = Table role (e.g., dim, fact)
- `<entity>` = Descriptive business entity name

**Examples:**
- dim_customers
- fact_sales
---

## Column Naming Conventions

### Surrogate Keys

- All surrogate primary keys in **dimension tables** must end with `_key`

**Pattern:**
`<table_name>`_key


**Definitions:**
- `<table_name>` = Related table or entity name
- `_key` = Indicates a surrogate key

**Example:**
customer_key -- Surrogate key in dim_customers
---

### Technical Columns

- All technical/system-generated columns must start with the prefix `dwh_`
- Column names must clearly describe their purpose

**Pattern:**
dwh_`<column_name>`


**Definitions:**
- `dwh_` = Reserved prefix for warehouse metadata
- `<column_name>` = Describes the technical purpose

**Example:**
dwh_load_date -- Date when the record was loaded into the warehouse


---

## Stored Procedure Naming Conventions

- All stored procedures used for loading data must follow this pattern:

**Pattern:**
load_`<layer>`


**Definitions:**
- `<layer>` = Data warehouse layer (bronze, silver, gold)

**Examples:**
load_bronze -- Loads data into Bronze layer
load_silver -- Loads data into Silver layer
load_gold -- Loads data into Gold layer

