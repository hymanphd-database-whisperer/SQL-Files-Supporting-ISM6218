
--Start with Basic Join 
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
JOIN Book B
ON A.id = B.author_id

--Compare to Left Join
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
LEFT JOIN Book B
ON A.id = B.author_id

--Create Function to find books by author
CREATE FUNCTION fnGetBooksByAuthorId (@AuthorId int)
RETURNS TABLE
AS
RETURN
( 
SELECT * FROM Book
WHERE author_id = @AuthorId
)
--Call function in select
SELECT * FROM fnGetBooksByAuthorId(3) 

--Compare Basic Join with Cross Apply
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
CROSS APPLY fnGetBooksByAuthorId(A.Id) B

--Basic Full Join
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
Full JOIN Book B
ON A.id = B.author_id

--Compare Full Join with Outer Apply
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
OUTER APPLY fnGetBooksByAuthorId(A.Id) B
