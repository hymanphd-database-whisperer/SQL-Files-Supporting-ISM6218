Create proc Demo_Exist_IN_ANY
as
begin

-- Exists  
SELECT a.FirstName, a.LastName  
FROM Person.Person AS a  
WHERE EXISTS  
    (SELECT *   
    FROM HumanResources.Employee AS b  
    WHERE a.BusinessEntityID = b.BusinessEntityID  --compare to a join
    AND a.LastName = 'Johnson'
	);  

--Compare to IN
SELECT a.FirstName, a.LastName  
FROM Person.Person AS a  
WHERE a.LastName IN
    (SELECT a.LastName  
    FROM HumanResources.Employee AS b  
    WHERE a.BusinessEntityID = b.BusinessEntityID  
    AND a.LastName = 'Johnson'
	);  

--Compare to ANY
SELECT a.FirstName, a.LastName  
FROM Person.Person AS a  
WHERE a.LastName = ANY
    (SELECT a.LastName  
    FROM HumanResources.Employee AS b  
    WHERE a.BusinessEntityID = b.BusinessEntityID  
    AND a.LastName = 'Johnson'
	);  

--NOT Exists
SELECT p.FirstName, p.LastName, e.JobTitle
FROM Person.Person AS p   
JOIN HumanResources.Employee AS e  
ON e.BusinessEntityID = p.BusinessEntityID   
WHERE NOT EXISTS  
  (SELECT *  
   FROM HumanResources.Department AS d  
   JOIN HumanResources.EmployeeDepartmentHistory AS edh  
   ON d.DepartmentID = edh.DepartmentID  
   WHERE e.BusinessEntityID = edh.BusinessEntityID  
   AND d.Name LIKE 'P%'
   )  
ORDER BY LastName, FirstName  

end
