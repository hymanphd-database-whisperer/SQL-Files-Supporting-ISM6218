 
CREATE TABLE Author
(
    id INT PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL,
 )
 
CREATE TABLE Book
(
    id INT PRIMARY KEY,
    book_name VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    author_id INT NOT NULL
 )
 
INSERT INTO Author 
 
VALUES
(1, 'Author1'),
(2, 'Author2'),
(3, 'Author3'),
(4, 'Author4'),
(5, 'Author5'),
(6, 'Author6'),
(7, 'Author7')
 
INSERT INTO Book 
 
VALUES
(1, 'Book1',500, 1),
(2, 'Book2', 300 ,2),
(3, 'Book3',700, 1),
(4, 'Book4',400, 3),
(5, 'Book5',650, 5),
(6, 'Book6',400, 3)