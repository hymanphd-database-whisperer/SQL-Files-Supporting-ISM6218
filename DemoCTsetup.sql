--create table, PK constraint, insert values
CREATE TABLE Customer ( 
CustomerId INT IDENTITY (1,1) 
,FirstName VARCHAR(30) 
,LastName VARCHAR(30) NOT NULL 
,Amount_purchased DECIMAL 
) 
ALTER TABLE dbo.Customer ADD CONSTRAINT PK_Customer PRIMARY KEY (CustomerId, LastName) 

INSERT INTO dbo.Customer ( FirstName, LastName, Amount_Purchased)
VALUES ( 'Frank', 'Sinatra',20000.00),( 'Shawn', 'McGuire',30000.00),( 'Amy', 'Carlson',40000.00)

--Test Query
SELECT * FROM dbo.Customer

-- Enable change Tracking at Database Level
ALTER DATABASE DemoTrackChanges
SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)

-- Enable change Tracking at Table Level
ALTER TABLE dbo.Customer
ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

-- Verify the status of the change tracking with no version history
SELECT CHANGE_TRACKING_CURRENT_VERSION () AS CT_Version

SELECT * FROM CHANGETABLE (CHANGES Customer,0) as CT ORDER BY SYS_CHANGE_VERSION

SELECT c.CustomerId, c.LastName ,  ct.SYS_CHANGE_VERSION, ct.SYS_CHANGE_CONTEXT
FROM Customer AS c
CROSS APPLY CHANGETABLE (VERSION Customer, (customerId,Lastname), (c.CustomerId,c.LastName)) AS ct;

-- Make changes in table records
-- insert a row
INSERT INTO Customer(FirstName, LastName, Amount_purchased)
VALUES('Ameena', 'Lalani', 50000)

-- delete a row
DELETE FROM dbo.Customer 
WHERE CustomerId = 2

-- update a row
UPDATE Customer
SET  Lastname = 'Clarkson' WHERE CustomerId = 3

--Rerun change tracking with history

