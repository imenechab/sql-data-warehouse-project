/*
=============================
CREATE DATABASE AND SCHEMAS
=============================
Script purspose:
  This script create a new database called 'DataWarehouse' after checking if it already exits.
  If the databse exists, it is dropped and recreated. Additionaly, thescript sets up three schemas within the databse : 'bronze', 'silver', 'gold'.
WARNING:
  Runnig this script will drop the entire 'DataWarehouse' databse if it exists.
  All the data in the database will be permanently deleted. Proceed with caution and ensure you have proper bauckups before running this script.
*/

USE master;

-- Drop and recreate the 'DataWarehouse' database 

IF EXISTS ( SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database

CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

-- Create schemas : bronze, silver, gold

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
