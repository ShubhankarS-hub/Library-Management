--SQL LIBRARY MANAGEMENT SYSTEM PROJECT
DROP TABLE IF EXISTS BRANCH,

CREATE TABLE BRANCH
(
branch_id	VARCHAR(10) PRIMARY KEY,
manager_id	VARCHAR(10),
branch_address	VARCHAR(50),
contact_no VARCHAR(15)

);

DROP TABLE IF EXISTS EMPLOYEES
CREATE TABLE EMPLOYEES
(
emp_id	VARCHAR(15) PRIMARY KEY,
emp_name	VARCHAR(25),
position	VARCHAR(25),
salary	INT,
branch_id VARCHAR(10)

);
DROP TABLE IF EXISTS BOOKS
CREATE TABLE BOOKS
(
isbn	VARCHAR(20) PRIMARY KEY,
book_title	VARCHAR(85),
category	VARCHAR(10),
rental_price	FLOAT,
status	VARCHAR(10),
author	VARCHAR(35),
publisher VARCHAR(65)

);

ALTER TABLE BOOKS
ALTER COLUMN category
TYPE VARCHAR(25);

CREATE TABLE MEMBERS
(
member_id	VARCHAR(25) PRIMARY KEY,
member_name	VARCHAR(45),
member_address	VARCHAR(75),
reg_date DATE

);

CREATE TABLE ISSUE_STATUS
(
issued_id	VARCHAR(15) PRIMARY KEY,
issued_member_id	VARCHAR(15),
issued_book_name	VARCHAR(25),
issued_date	DATE,
issued_book_isbn VARCHAR(25),	
issued_emp_id VARCHAR(15)


);
ALTER TABLE ISSUE_STATUS
ALTER COLUMN issued_book_name TYPE VARCHAR(55)
CREATE TABLE RETURN_STATUS
(
return_id	VARCHAR(15) PRIMARY KEY,
issued_id	VARCHAR(15),
return_book_name	VARCHAR(75),
return_date	DATE,
return_book_isbn VARCHAR(25)

);

-- FORIEGN KEY CONSTRAINTS
ALTER TABLE ISSUE_STATUS
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id); 

ALTER TABLE ISSUE_STATUS
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn); 

ALTER TABLE ISSUE_STATUS
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id); 

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT fk_return
FOREIGN KEY (issued_id)
REFERENCES issue_status(issued_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

SELECT * FROM RETURN_STATUS

--Project Tasks
-- 1.Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

SELECT * FROM BOOKS

INSERT INTO BOOKS(isbn,book_title,category,rental_price,status,author,publisher)
VALUES
(
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
);

--2.Update an Existing Member's Address
SELECT * FROM members

UPDATE MEMBERS 
SET member_address ='125 Main St'
WHERE member_id = 'C101';
SELECT * FROM MEMBERS

--3. Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issue_status
WHERE issued_id = 'IS121'

SELECT * FROM issue_status

--4.Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM BOOKS
SELECT * FROM ISSUE_STATUS
WHERE issued_emp_id = 'E101'

--5.List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
members.member_name,
COUNT (issue_status.issued_member_id) as tot_books_issued
FROM   members, issue_status
WHERE issue_status.issued_member_id = members.member_id
GROUP BY members.member_name
HAVING COUNT(issue_status.issued_member_id)>1

--6.reate Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issued_counts
AS
SELECT 
b.book_title,
b.isbn,
COUNT(issued_id) AS total_books_issued
FROM BOOKS AS b
JOIN 
ISSUE_STATUS AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 2,1


--7.Retrieve All Books in a Specific Category:

SELECT
*
FROM BOOKS
WHERE category ='Classic'

--8. Find Total Rental Income by Category:
SELECT
b.category,
SUM(b.rental_price) as total_income,
COUNT(*)
FROM BOOKS as b
JOIN ISSUE_STATUS as ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
ORDER BY SUM(b.rental_price) DESC

--9.List Members Who Registered in the Last 180 Days:
INSERT INTO members(member_id,member_name,member_address,reg_date)
VALUES
('C132','Alpha', 'Madras', '2025-01-23'),
('C069','Beta','Nawab', '2025-02-14')
SELECT * 
FROM MEMBERS
WHERE reg_date>= CURRENT_DATE  - INTERVAL'180 days'

--10. List Employees with Their Branch Manager's Name and their branch details:

SELECT 
e1.*,
b.manager_id,
e2.emp_name as Manager
FROM BRANCH as b
JOIN EMPLOYEES as e1
ON b.branch_id = e1.branch_id
JOIN EMPLOYEES as e2
ON e2.emp_id = b.manager_id

--11.Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE BOOKS_ABOVE
AS
SELECT
*
FROM BOOKS
WHERE rental_price >'7'

SELECT * FROM BOOKS_ABOVE

--12. Retrieve the List of Books Not Yet Returned
SELECT 
*
FROM ISSUE_STATUS as i
LEFT JOIN RETURN_STATUS as r
ON   r.issued_id = i.issued_id
WHERE r.issued_id IS NULL


 