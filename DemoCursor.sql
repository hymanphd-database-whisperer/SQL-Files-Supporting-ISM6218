Use TSQLV4

DECLARE @Result AS TABLE
(
  custid     INT,
  ordermonth DATE,
  qty        INT, 
  runqty     INT,
  PRIMARY KEY(custid, ordermonth)
);

DECLARE
  @custid     AS INT,
  @prvcustid  AS INT,
  @ordermonth AS DATE,
  @qty        AS INT,
  @runqty     AS INT;

DECLARE C CURSOR FAST_FORWARD /* read only, forward only */ FOR
  SELECT custid, ordermonth, qty
  FROM Sales.CustOrders
  ORDER BY custid, ordermonth;

OPEN C;

FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;

SELECT @prvcustid = @custid, @runqty = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
  IF @custid <> @prvcustid
    SELECT @prvcustid = @custid, @runqty = 0;

  SET @runqty = @runqty + @qty;

  INSERT INTO @Result VALUES(@custid, @ordermonth, @qty, @runqty);
  
  FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;
END;

CLOSE C;

DEALLOCATE C;

SELECT 
  custid,
  CONVERT(VARCHAR(7), ordermonth, 121) AS ordermonth,
  qty,
  runqty
FROM @Result
ORDER BY custid, ordermonth;
GO
