DECLARE @str NVARCHAR(1000)
DECLARE @fName NVARCHAR(20)
DECLARE @ePromo INT
 
SET @fName = N'James'
SET @ePromo = 1
 
--// Using EXECUTE or EXEC
SET @str = N'SELECT FirstName, MiddleName, LastName, EmailPromotion
FROM Person.Person
WHERE FirstName = ''' + @fName + '''
AND EmailPromotion = ' + CAST(@ePromo as NVARCHAR(20))
 
EXEC (@str)
 
--// Using sp_executesql
DECLARE @str NVARCHAR(1000)
DECLARE @fName NVARCHAR(20)
DECLARE @ePromo INT
 
DECLARE @paramList NVARCHAR(500)
SET @paramList = N'@fNameParam NVARCHAR(20), @ePromoParam INT'
 
SET @str = N'
SELECT FirstName, MiddleName, LastName, EmailPromotion
FROM Person.Person
WHERE FirstName = @fNameParam
AND EmailPromotion = @ePromoParam'
 
SET @fName = N'James'
SET @ePromo = 1
EXECUTE sp_executesql @str, @paramList, @fNameParam=@fName, @ePromoParam=@ePromo
 