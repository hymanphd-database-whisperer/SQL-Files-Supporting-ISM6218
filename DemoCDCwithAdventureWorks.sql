use AdventureWorks2017

exec sys.sp_cdc_enable_db

EXECUTE sys.sp_cdc_enable_table  
   @source_schema = N'HumanResources'  ,
   @source_name = N'Employee'  ,
   @role_name = N'cdc_Admin';  

EXEC sys.sp_cdc_enable_table  
   @source_schema = N'HumanResources' , 
   @source_name = N'Department'  ,
   @role_name = N'cdc_admin'  ,
   @capture_instance = N'HR_Department'  , 
   @supports_net_changes = 1  ,
   @index_name = N'AK_Department_Name' ,  
   @captured_column_list = N'DepartmentID, Name, GroupName' ,  
   @filegroup_name = N'PRIMARY';  


exec sys.sp_cdc_add_job @job_type = N'capture';

EXEC sys.sp_cdc_start_job @job_type = N'capture';

EXEC sys.sp_cdc_start_job @job_type = N'cleanup';   



--Declare Scalar Variables
DECLARE @begin_time datetime, @end_time datetime, @from_lsn binary(10), @to_lsn binary(10);  
-- Obtain the beginning of the time interval.  
SET @begin_time = GETDATE() -1;  

-- DML statements to produce changes in the HumanResources.Department table.  
INSERT INTO HumanResources.Department (Name, GroupName)  
VALUES (N'MyDept', N'MyNewGroup');  
  
UPDATE HumanResources.Department  
SET GroupName = N'Resource Control'  
WHERE GroupName = N'Inventory Management';  
  
DELETE FROM HumanResources.Department  
WHERE Name = N'MyDept';  
  
-- Obtain the end of the time interval.  
DECLARE @begin_time datetime, @end_time datetime, @from_lsn binary(10), @to_lsn binary(10);  
-- Obtain the beginning of the time interval.  
SET @begin_time = GETDATE() -1;  
SET @end_time = GETDATE();  
-- Map the time interval to a change data capture query range.  
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @begin_time);  
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);  
  
-- Return the net changes occurring within the query window.  
SELECT * FROM cdc.fn_cdc_get_net_changes_HR_Department(@from_lsn, @to_lsn, 'all');


