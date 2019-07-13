--Create Database
   IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CTEDB' )    
DROP DATABASE CTEDB    
 
CREATE DATABASE CTEDB    

--Create Table
IF EXISTS ( SELECT name FROM sys.tables WHERE name = 'ItemDetails' )    
DROP TABLE ItemDetails    
   
CREATE TABLE ItemDetails    
(    
Item_ID int identity(1,1),    
Item_Name VARCHAR(100) NOT NULL,    
Item_Price int NOT NULL,    
Date VARCHAR(100) NOT NULL ,
CONSTRAINT PK_ItemDetails PRIMARY KEY CLUSTERED     
(     
Item_ID ASC     
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]     
) ON PRIMARY
 
--Insert Rows
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Access Point',950,'2017-02-10')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('CD',350,'2017-02-13')     
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Desktop Computer',1400,'2017-02-16')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('DVD',1390,'2017-03-05')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('DVD Player',450,'2017-05-07')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Floppy',1250,'2017-05-07')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('HDD',950,'2017-07-10')       
Insert into ItemDetails(Item_Name,Item_Price,Date) values('MobilePhone',1150,'2017-07-10')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Mouse',399,'2017-08-12')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('MP3 Player ',897,'2017-08-14')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Notebook',750,'2017-08-16')     
Insert into ItemDetails(Item_Name,Item_Price, Date) values('Printer',675,'2017-07-18')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('RAM',1950,'2017-09-23')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('Smart Phone',679,'2017-09-10')    
Insert into ItemDetails(Item_Name,Item_Price,Date) values('USB',950,'2017-02-26') 

--Simple CTE passing values to select query
WITH itemCTE (Item_ID, Item_Name, Item_Price,SalesYear)
AS
(
  SELECT Item_ID, Item_Name, Item_Price ,YEAR(Date) SalesYear
  FROM ItemDetails   
)
 Select * from itemCTE

 --CTE 'Present Price' with nested 'Future price'
 WITH itemCTE (Item_ID, Item_Name, Item_Price, MarketRate, SalesYear)
AS
(
    SELECT Item_ID, Item_Name, Item_Price ,'Present Price' as MarketRate, YEAR(Date) as 'SalesYear' 
    FROM ItemDetails  
	
	UNION ALL
	 
	 SELECT Item_ID as Item_ID, Item_Name, (Item_Price + (Item_Price *10 )/100) as Item_Price,
			'Future Price' as MarketRate, YEAR(dateadd(YEAR, 1, Date))  as SalesYear
     FROM ItemDetails
 ) 
SELECT * from itemCTE Order by Item_Name,SalesYear

--Create View of CTE
CREATE VIEW vCTE
AS
WITH  itemCTE1 AS
    (
    SELECT Item_ID, Item_Name, Item_Price ,'Present Price' as MarketRate,Date as IDate
    FROM ItemDetails  
	UNION ALL
	 SELECT Item_ID as Item_ID, Item_Name,(Item_Price + (Item_Price *10 )/100) as Item_Price,
	 'Future Price' as MarketRate,  dateadd(YEAR, 1, Date) as IDate
     FROM ItemDetails
      )
      SELECT Item_ID, Item_Name, Item_Price,MarketRate,year(IDate) as IDate from itemCTE1 
 
 -- test view
SELECT * FROM vCTE Order by Item_Name,IDate