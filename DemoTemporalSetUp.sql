-- Add memory optimized filegroup and a file 
ALTER DATABASE DemoTemporal ADD FILEGROUP [Optimized_FG] CONTAINS MEMORY_OPTIMIZED_DATA 

ALTER DATABASE DemoTemporal ADD FILE ( NAME = N'Optimized_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\Optimized_Data.ndf') TO FILEGROUP [Optimized_FG] 

-- Turn memory optimization feature on at the database level 
ALTER DATABASE DemoTemporal SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON 
  
-- Create a Customer temporal table without Memory optimization
CREATE TABLE Customer
            ( 
             CustomerId INT IDENTITY(1,1)  PRIMARY KEY, FirstName VARCHAR(30) NOT NULL, LastName VARCHAR(30) NOT NULL,
             AmountPurchased DECIMAL NOT NULL, StartDate datetime2 generated always as row START NOT NULL, 
             EndDate datetime2 generated always as row END NOT NULL, PERIOD FOR SYSTEM_TIME (StartDate, EndDate) 
            ) 
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory)) 

 --insert 3 rows 
INSERT INTO Customer(FirstName, LastName, AmountPurchased) 
VALUES ( 'Frank', 'Sinatra',20000.00),( 'Shawn', 'McGuire',30000.00),( 'Amy', 'Carlson',40000.00) 

  -- create a memory optimized temporal table Customer2  
CREATE TABLE Customer2 
            ( 
             CustomerId INT IDENTITY(1,1), FirstName VARCHAR(30) NOT NULL, LastName VARCHAR(30) NOT NULL, 
             AmountPurchased DECIMAL NOT NULL, StartDate datetime2 generated always as row START NOT NULL, 
             EndDate datetime2 generated always as row END NOT NULL, PERIOD FOR SYSTEM_TIME (StartDate, EndDate), 
             CONSTRAINT PK_CustomerID PRIMARY KEY NONCLUSTERED HASH (CustomerId) WITH (BUCKET_COUNT = 131072) 
            ) 
WITH(MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA, 

SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Customer2History))  

--insert the same 3 rows
INSERT INTO dbo.Customer2 (  FirstName,    LastName,    AmountPurchased) 
VALUES ( 'Frank', 'Sinatra',20000.00),( 'Shawn', 'McGuire',30000.00),( 'Amy', 'Carlson',40000.00) 
  
-- select data from both tables with Execution plan and Live Query Statistics on 
SELECT * FROM dbo.Customer 

SELECT * FROM dbo.Customer2
