-- Part I – Working with an existing database

-- Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.

-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.

SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee
	WHERE LastName = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee 
	WHERE FirstName = 'Andrew' AND REPORTSTO IS NULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album
	ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT FirstName FROM customer
	ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name) VALUES (26,'Progressive Rock');
INSERT INTO genre (genreid, name) VALUES (27,'Vapor-Wave');
-- Task – Insert two new records into Employee table
INSERT INTO employee (employeeid,lastname, firstname, title)
	VALUES (10,'Squarepants','Spongebob','Fry-Cook'),
		   (9,'Tentacles','Squidward','Cashier');
-- Task – Insert two new records into Customer table
INSERT INTO customer (customerid,firstname, lastname, email)
	VALUES (60,'Sandy','Cheeks','cheeks.sandy@txmail.com'),
		   (61,'Patrick','Star','starp@rockmail.com');
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Robert'
WHERE firstname = 'Aaron' and lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist
SET Name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice
WHERE BillingAddress LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice
	WHERE Total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee 
	WHERE hiredate BETWEEN '2003-06-01' AND '2004-03-1';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM CUSTOMER 
	WHERE FirstName = 'Robert' AND LastName = 'Walter';

-- SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION WhatIsTheTime()
RETURNS time AS $$
BEGIN 
 RETURN CURRENT_TIME;
END;
-- Task – create a function that returns the length of a mediatype from the mediatype table

CREATE OR REPLACE FUNCTION invoiceAverage()
RETURNS NUMERIC(10,2) AS $$
BEGIN 

 RETURN AVG(Total) FROM INVOICE;
END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION invoiceAverage()
RETURNS NUMERIC(10,2) AS $$
BEGIN 

 RETURN AVG(Total) FROM INVOICE;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION maxtrackprice()
RETURNS NUMERIC(10,2) AS $$
BEGIN 

 RETURN MAX(unitprice) FROM track;
END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION invoicelinepriceaverage()
RETURNS NUMERIC(10,2) AS $$
BEGIN 

 RETURN AVG(unitprice*quantity) FROM invoiceline;
END;
$$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.

CREATE OR REPLACE FUNCTION youngishEmployees()
RETURNS TABLE(
    EmployeeId INT,
    LastName VARCHAR(20),
    FirstName VARCHAR(20),
    Title VARCHAR(30),
    ReportsTo INT,
    BirthDate TIMESTAMP,
    HireDate TIMESTAMP,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60)
   ) AS $$
BEGIN 
RETURN QUERY
SELECT * FROM employee
	WHERE employee.birthdate >= '1968-01-01';
END;
$$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.

CREATE OR REPLACE FUNCTION EmployeeNameList()
RETURNS TABLE(
	FirstName VARCHAR(20),
    LastName VARCHAR(20)
   ) AS $$
BEGIN 
RETURN QUERY
SELECT employee.FirstName,employee.LastName FROM employee;
END;
$$ LANGUAGE plpgsql;
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION updateEmployee(Nemployeeid INT,
    nLastName VARCHAR(20),
    nFirstName VARCHAR(20),
    nTitle VARCHAR(30),
    nReportsTo INT,
    nBirthDate TIMESTAMP,
    nHireDate TIMESTAMP,
    nAddress VARCHAR(70),
    nCity VARCHAR(40),
    nState VARCHAR(40),
    nCountry VARCHAR(40),
    nPostalCode VARCHAR(10),
    nFax VARCHAR(24),
    nEmail VARCHAR(60))
RETURNS NULL AS $$
BEGIN
UPDATE employee SET
lastname = nLastName,
firstname = nFirstName,
title = nTitle,
reportsto = nReportsTo,
birthdate = nBirthDate,
hiredate = nHireDate,
address = nAddress,
city = ncity,
state = nState,
Country = nCountry,
PostalCode = nPostalCode,
Fax = nFax,
email = nEmail
WHERE employeeid = Nemployeeid;
END
$$ LANGUAGE plpgadmin;

-- Task – Create a stored procedure that returns the managers of an employee.

CREATE OR REPLACE FUNCTION employeeManager(underlingid int)
	RETURNS TABLE( EmployeeId INT,
    LastName VARCHAR(20),
    FirstName VARCHAR(20),
    Title VARCHAR(30),
    ReportsTo INT,
    BirthDate TIMESTAMP,
    HireDate TIMESTAMP,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60)) AS $$
BEGIN 
RETURN QUERY
	SELECT * FROM employee
		WHERE underlingid = employee.employeeid;
END;
$$ LANGUAGE plpgsql; 

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION customerNameAndCompany(custid INT)
RETURNS TABLE(firstname VARCHAR,lastname VARCHAR, company VARCHAR) AS $$ 
BEGIN
RETURN QUERY
SELECT customer.firstname,customer.lastname,customer.company FROM customer
	WHERE customer.customerid = custid;
END;
$$ LANGUAGE plpgsql;
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION deleteinvoice(invoice_id INT)
RETURNS BOOLEAN AS $$
BEGIN
DELETE FROM invoiceline
WHERE invoiceid = invoice_id;
DELETE FROM invoice
WHERE invoiceid = invoice_id;
RETURN TRUE;
END
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION logCustomer(INcustomerid INT, INfirstname VARCHAR(40), INlastname VARCHAR(20), INemail VARCHAR(60))
RETURNS void AS $$
BEGIN
	INSERT INTO customer (customerid,firstname,lastname,email) 
		VALUES(INCustomerId, INFirstName, INLastName, INEmail);
END
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TABLE employee_counter(counter INT);
INSERT INTO employee_counter (counter) VALUES (10);
CREATE OR REPLACE FUNCTION update_counter()
	RETURNS trigger AS $$
	BEGIN
	UPDATE employee_counter 
	SET counter = counter +1;
	RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

 CREATE TRIGGER update_counter
	AFTER INSERT ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE update_counter();
	END;
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE TABLE old_value_album(Albumid INT,title VARCHAR(160), Artistid INT);
CREATE OR REPLACE FUNCTION update_old_album()
	RETURNS trigger AS $$
	BEGIN
	INSERT INTO old_value_album
	(albumid, title, artistid) VALUES (old.albumid, old.title, old.artistid);
	RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

 CREATE TRIGGER update_old_album
	AFTER UPDATE ON album
	FOR EACH ROW
	EXECUTE PROCEDURE update_old_album();
	END;

CREATE TRIGGER check_phone
	BEFORE INSET ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE stop50();
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.

-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE OR REPLACE FUNCTION stop50()
RETURNS trigger AS $$
BEGIN 
	IF OLD.Total > 50.00 THEN
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stop50
	BEFORE DELETE ON invoice
	FOR EACH ROW
	EXECUTE PROCEDURE stop50();

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT firstname, lastname, invoiceid FROM
	customer INNER JOIN invoice
	ON customer.customerid = invoice.customerid;
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT CUSTOMER.customerid, firstname, lastname, invoiceid, total FROM
	customer FULL JOIN invoice
	ON customer.customerid = invoice.customerid;
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title FROM
	album RIGHT JOIN artist
	on album.artistid = artist.artistid;
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT artist.name, album.title FROM
	album CROSS JOIN artist
	ORDER BY artist.name ASC;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT underling.firstname, underling.lastname, employee.firstname, employee.lastname 
	FROM employee underling LEFT JOIN employee ON
	underling.reportsto = employee.employeeid;








