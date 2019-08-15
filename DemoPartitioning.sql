--This example creates new filegroups, a partition function, and a partition scheme. 
--A new table is created with the partition scheme specified as the storage location.
USE AdventureWorks2012;  
GO  
-- Adds four new filegroups to the AdventureWorks2012 database  
ALTER DATABASE AdventureWorks2012  
ADD FILEGROUP test1fg;  
GO  
ALTER DATABASE AdventureWorks2012  
ADD FILEGROUP test2fg;  
GO  
ALTER DATABASE AdventureWorks2012  
ADD FILEGROUP test3fg;  
GO  
ALTER DATABASE AdventureWorks2012  
ADD FILEGROUP test4fg;   

-- Adds one file for each filegroup.  
ALTER DATABASE AdventureWorks2012   
ADD FILE   
(  
    NAME = test1dat1,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\t1dat1.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test1fg;  
ALTER DATABASE AdventureWorks2012   
ADD FILE   
(  
    NAME = test2dat2,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\t2dat2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test2fg;  
GO  
ALTER DATABASE AdventureWorks2012   
ADD FILE   
(  
    NAME = test3dat3,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\t3dat3.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test3fg;  
GO  
ALTER DATABASE AdventureWorks2012   
ADD FILE   
(  
    NAME = test4dat4,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\t4dat4.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP test4fg;  
GO  
-- Creates a partition function called myRangePF1 that will partition a table into four partitions  
CREATE PARTITION FUNCTION myRangePF1 (int)  
    AS RANGE LEFT FOR VALUES (1, 100, 1000) ;  
GO  
-- Creates a partition scheme called myRangePS1 that applies myRangePF1 to the four filegroups created above  
CREATE PARTITION SCHEME myRangePS1  
    AS PARTITION myRangePF1  
    TO (test1fg, test2fg, test3fg, test4fg) ;  
GO  
-- Creates a partitioned table called PartitionTable that uses myRangePS1 to partition col1  
CREATE TABLE PartitionTable (col1 int PRIMARY KEY, col2 char(10))  
    ON myRangePS1 (col1) ;  
GO

--determine if a table is partitioned
SELECT *   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
    AND i.[type] IN (0,1)   
JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id   
WHERE t.name = 'PartitionTable';   
GO

--To determine the boundary values for a partitioned table
SELECT t.name AS TableName, i.name AS IndexName, p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE t.name = 'PartitionTable' AND i.type <= 1  
ORDER BY p.partition_number;

--determine the partition column for a partitioned table
SELECT   
    t.[object_id] AS ObjectID   
    , t.name AS TableName   
    , ic.column_id AS PartitioningColumnID   
    , c.name AS PartitioningColumnName   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
    AND i.[type] <= 1 -- clustered index or a heap   
JOIN sys.partition_schemes AS ps   
    ON ps.data_space_id = i.data_space_id   
JOIN sys.index_columns AS ic   
    ON ic.[object_id] = i.[object_id]   
    AND ic.index_id = i.index_id   
    AND ic.partition_ordinal >= 1 -- because 0 = non-partitioning column   
JOIN sys.columns AS c   
    ON t.[object_id] = c.[object_id]   
    AND ic.column_id = c.column_id   
WHERE t.name = 'PartitionTable' ;   
GO

