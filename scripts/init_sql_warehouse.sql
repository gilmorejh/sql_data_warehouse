/*
Database and Schema Initialization Script

Overview:
	This script creates a database named 'DataWarehouse'. If the database already exists,
	it will be removed and rebuilt. After creation, three schemas, 'bronze', 'silver', and 'gold',
	are added to organize data across processing stages.

IMPORTANT:
	Executing this script will permanently delete the existing 'DataWarehouse' database, including
	all stored data. Only run this if you are certain no critical data will be lost, or after
	confirming backups are in place.
*/


USE master;
GO
-- Drop and Recreate 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO
-- Create the 'DataWarehouse' database
create database DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
