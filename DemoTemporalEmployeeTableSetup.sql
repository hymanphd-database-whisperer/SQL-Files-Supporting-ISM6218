
--create table with system versioning on
CREATE TABLE dbo.Employee   
(    
  EmployeeID int NOT NULL PRIMARY KEY CLUSTERED, Name nvarchar(100) NOT NULL, Position varchar(100) NOT NULL,   
  Department varchar(100) NOT NULL, Address nvarchar(1024) NOT NULL, AnnualSalary decimal (10,2) NOT NULL,  
  ValidFrom datetime2 (2) GENERATED ALWAYS AS ROW START,  
  ValidTo datetime2 (2) GENERATED ALWAYS AS ROW END, 
  PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)  
 )    
 WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory)); 

--insert value
INSERT INTO dbo.employee (employeeID, Name, Position, Department, Address, AnnualSalary) 
VALUES ( '1000', 'Billy Holiday', 'President', 'Sales', '123 Main Street', '100.00') 


--test query
 SELECT * FROM Employee
  FOR SYSTEM_TIME BETWEEN '2019-01-01 00:00:00.0000000' AND '2019-07-07 00:00:00.0000000' 
  WHERE EmployeeID = 1000 ORDER BY ValidFrom;