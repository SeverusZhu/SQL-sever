/* this is the 1st SQL file to be created */
-- @author: severus

-- CREATE TABLE

-- SELECT value1, value2 into Table2 FROM Table1

--  索引的作用：用来加速SELECT和WHERE的速度，但是同时降低了UPDATE和INSERT数据的速度。

-- 设置一列为索引
-- CREATE INDEX index_name ON Tabel_name(col_name)
-- 创建唯一索引
-- CREATE UNIQUE INDEX index_name ON table_name (column_name)


-- 求百分比的问题

-- SELECT Request_at as Day,
-- round(sum(case when t.Status like 'cancelled_%' then 1 else 0 end) / count(*),2) 'cancellation Rate'
-- from Trips t join Users u On t.Client_Id = u.Users_Id
-- where t.Request_at between '2013-10-01' and '2013-10-03' and u.Banned='No'
-- group by t.Request_at

-- 创建col_name为主键

-- ALTER TABLE Person ADD PRIMARY KEY (col_name)

-- 创建外键

-- ALTER TABLE Person ADD FOREIGN KEY (col_name1) REFERENCES Persons(col_name2)

--手动添加数据
-- INSERT INTO Customes(value1, value2.....) VALUES(v1, v2 ......) 

-- 从其他表中添加数据
-- INSERT INTO table2 SELECT * FROM table1

-- 增加列
-- ALTER TABLE table_name ADD column_name datatype

-- 删除行
-- DELETE FROM Person WHERE LastName = 'Wilson'

-- 删除所有行
-- DELETE FROM table_name

-- 删除数据库
-- DROP DATEBASE db1

-- 删除表
-- DROP TABLE tb1

-- 删除索引
-- DROP INDEX table_name.index_name

-- 删除列
-- 注意：删除列之前该列所有的索引和约束必须首先删除
-- ALTER TABLE table1 DROP COLUMN col1

-- 删除各种约束
-- ALTER TABLE Persons DROP CONSTRAINT uc_PersonID

-- 修改表中的数据
-- UPDATE Table1 SET Address = 'Zhongshan 23', City = 'Nanjing'
-- WHERE LastName = 'Wilson'




CREATE TABLE Customers
(
  cust_id      char(10)  NOT NULL ,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL 
);

CREATE TABLE OrderItems
(
  order_num  int          NOT NULL ,
  order_item int          NOT NULL ,
  prod_id    char(10)     NOT NULL ,
  quantity   int          NOT NULL ,
  item_price decimal(8,2) NOT NULL 
);

CREATE TABLE Orders
(
  order_num  int      NOT NULL ,
  order_date datetime NOT NULL ,
  cust_id    char(10) NOT NULL 
);

CREATE TABLE Products
(
  prod_id    char(10)      NOT NULL ,
  vend_id    char(10)      NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  varchar(1000) NULL 
);

CREATE TABLE Vendors
(
  vend_id      char(10) NOT NULL ,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL ,
  vend_city    char(50) NULL ,
  vend_state   char(5)  NULL ,
  vend_zip     char(10) NULL ,
  vend_country char(50) NULL 
);

CREATE TABLE OrderItems
(
    order_num INTEGER NOT NULL,
    order_item INTEGER NOT NULL,
    prod_id CHAR(10) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    item_price DECIMAL(8,2) NOT NULL
);

ALTER TABLE Vendors
ADD vend_phone CHAR(20);

ALTER TABLE Vendors
DROP COLUMN vend_phone;

DROP TABLE CustCopy;

ALTER TABLE Customers WITH NOCHECK ADD CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (cust_id);
ALTER TABLE OrderItems WITH NOCHECK ADD CONSTRAINT PK_OrderItems PRIMARY KEY CLUSTERED (order_num, order_item);
ALTER TABLE Orders WITH NOCHECK ADD CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (order_num);
ALTER TABLE Products WITH NOCHECK ADD CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (prod_id);
ALTER TABLE Vendors WITH NOCHECK ADD CONSTRAINT PK_Vendors PRIMARY KEY CLUSTERED (vend_id);

ALTER TABLE OrderItems ADD
CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_num) REFERENCES Orders (order_num),
CONSTRAINT FK_OrderItems_Products FOREIGN KEY (prod_id) REFERENCES Products (prod_id);
ALTER TABLE Orders ADD 
CONSTRAINT FK_Orders_Customers FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);
ALTER TABLE Products ADD
CONSTRAINT FK_Products_Vendors FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id);


-- sort
SELECT prod_name
FROM  Products
ORDER BY prod_name;

-- sort for more than one col    |    for the position of the col
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price, prod_name;     -- | ORDER BY 2, 3;

-- figure the sort order
SELECT pro_id, prod_price, prod_name       
FROM Products 
ORDER BY prod_price DESC;  -- | prod_price DESC, prod_name;

-- where for data selection
SELECT prod_name, prod_price
FROM Products
WHERE prod_price = 3.49;   -- if ORDER BY is needed, it should placed behind WHERE
--  <> is queal to != and we could use sth like WHERE vend_id <> 'DLL01';
-- but not all the DBMS support both of them
-- WHERE prod_price BETWEEN 5 AND 10;
-- WHERE prod_price IS NULL; 
-- WHERE vend_id = 'DLL01' AND prod_price <= 4;     | OR

-- IN 
SELECT prod_name, prod_price
FROM Products
WHERE vend_id IN ('DLL01', 'BRS01')  -- the same as the function of OR
ORDER BY prod_name;

-- WHERE NOT vend_id = 'DLL01'       -- the same as <>

-- filter 
-- %  NULL will never be included
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'Fish%';        -- select any word or scentence start from Fish(not include fish or sth different like the word you write), if it's Microsoft Access , use * instead of %
--                   '%bean bag%';   -- select any value include bean bag, no matter how many symbols in front or behind
--                   'F%y';          -- select any word start from F and ends with y


--  _ almost lisk % , but only with one symbol
-- in Microsoft Access , use ? instead and cannot be used in DB2

-- []
SELECT cust_contact
FROM Customers
WHERE cust_contact LIKE '[JM]%'      --  LIKE '[^JM]%' for the selsction of two characters not included
ORDER BY cust_contact;

-- concatenate +
-- Acess and SQL Sever use +, others use || instead, in MySQL or MariaDB could also use Concat
SELECT vend_name + '(' + vend_contry + ')'   -- but the ouput will include some blank, so mostly, the following one will be used
FROM Vendors
ORDER BY  vend_name;

SELECT RTRIM(vend_name) + '(' + RTRIM(vend_contry) + ')'   
FROM Vendors
ORDER BY  vend_name;

-- put a name for the above concatenate ouput 
SELECT RTRIM(vend_name) + '(' + RTRIM(vend_contry) + ')' 
    AS vend_title                             -- col name
FROM Vendors
ORDER BY  vend_name;

--------------------------------------------------------------------------------------------------------------------------------------
--NUMERIC calculation
SELECT prod_id,
    quantity,
    item_price,
    quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;

--------------------------------------------------------------------------------------------------------------------------------------

-- function 

-- UPPER, trandfer a to A
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;

-- SOUNDEX
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');   -- sound like , maybe like Michelle Green

-- DATE and TIME 
SELECT order_num
FROM Orders
WHERE DATEPART(yy, order_data) = 2012;                    -- in Access,use yyyy instead

-- other common functions
-- ABS()
-- COS()
-- EXP()
-- PI()
-- SIN()
-- SQRT()
-- TAN()

------------------------------------------------------------------------------------------------------------------------------------

-- AGGREGATE
-- common aggregate function
-- AVG()
-- COUNT()                                                -- output the row numbers of the selected col
-- MAX()
-- MIN()
-- SUM()

SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

-- DO NOT USE DISTINCT IN ACCESS                         

SELECT COUNT(*) AS num_items,
    MIN(prod_price) AS price_min,
    MAX(prod_price) AS prince_max,
    AVG(prod_price) AS price_avg
FROM Products;

-- CREATE A GROUP
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;

-- FILTER GROUP
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;                                  -- filter those groups with COUNT(*) >= 2


SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;

--  see the difference between order by and group by 
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

-- select from the sub-group
SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num                  -- as the select of the sub-group, only one col could be selected, dislike the first one could use many 
            FROM OrderItems
            WHERE prod_id = 'RGAN01');


-- for every customer use COUNT(*), it should be put into a sub-group
SELECT cust_name,
    cust_state,
    (SELECT COUNT(*)
    FROM Orders
    WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;

-- create coupling                                         JION
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;


-- cartesian product
SELECT vend_name, prod_name, prod_price               -- from this output, one can be seen is that WHERE is needed for coupling
FROM Vendors, Products;


-- inner join
SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
ON Vendors.vend_id = Products.vend_id;

-------------------------------------------------------------------------------------------------------------------------------------

-- set a sub-name for tht TABLE
SELECT cust_name, cust_contact
FROM Customers AS C, Orders AS O, OrderItems AS OI    -- AS could be used in Oracle
WHERE C.cust_id = O.cust_id
AND OI.order_num = O.order_num
AND prod_id = 'RGAN01';

-- self-join , natural join , outer join

-- self-join
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
            FROM Customers
            WHERE cust_contact = 'Jim Jones');

-- change the one above, use self-jion
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2                  -- remove AS in Oracle
WHERE c1.cust_name = c2.cust_name
AND c2.cust_contact = 'Jim Jones';

-- natural join
SELECT C.*, O.order_num, O.order_date,
    OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O, OrderItems AS OI     -- remove AS in Oracle
WHERE C.cust_id = O.cust_id
AND OI.order_num = O.order_num
AND prod_id = 'RGAN01';

-- outer join
SELECT Customers.cust_id, Orders.order_num               -- this is the example of inner one
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id;

SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id;

SELECT Customers.cust_id, Orders.order_num
FROM Orders FULL OUTER JOIN Customers                    -- not supposed in Access, MariaDB, MySQL, Open Office Base SQLite
ON Orders.cust_id = Customers.cust_id;




SELECT Customers.cust_id,
COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;


SELECT Customers.cust_id,
COUNT(Orders.order_num) AS num_ord
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;



-------------------------------------------------------------------------------------------------------------------------------------


-- UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI');

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

-- UNION INTO THE FOLLOWING FORM
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')                -- 4 SELECT, 3 UNION should be used
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

-- include all or not the repeat row
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION ALL                                           -- include all, and in this part it must be UNION ALL instead of WHERE
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

-------------------------------------------------------------------------------------------------------------------------------------
-- INSERT DATA

-- insert the whole row
INSERT INTO Customers
VALUES('10000006',
    'Toy Land',
    '123 Any Street',
    'New York',
    'NY',
    '11111',
    'USA',
    NULL,
    NULL);

INSERT INTO Customers(cust_id,    -- SAFER THAN THE 1ST ONE
            cust_name,
            cust_address,
            cust_city,
            cust_state,
            cust_zip,
            cust_country,
            cust_contact,
            cust_email)
VALUES('1000000006',
    'Toy Land',
    '123 Any Street',
    'New York',
    'NY',
    '11111',
    'USA',
    NULL,
    NULL);

INSERT INTO Customers(cust_id,     -- SAME AS THE FOREMENTIONED
            cust_contact,
            cust_email,
            cust_name,
            cust_address,
            cust_city,
            cust_state,
            cust_zip)
VALUES('1000000006',
    NULL,
    NULL,
    'Toy Land',
    '123 Any Street',
    'New York',
    'NY',
    '11111');

-- INSERT PART OF THE ROW
INSERT INTO Customers(cust_id,    -- THE ONE NOT INCLUDED SHOULD BE NULL OR DEFAULT
            cust_name,
            cust_address,                     -- IF THE DEFAULT WAS NOT GIVEN OR NULL WAS NOT ALLOWED, IT WILL LEAD TO FAILURE
            cust_city,
            cust_state,
            cust_zip,
            cust_country)
VALUES('1000000006',
    'Toy Land',
    '123 Any Street',
    'New York',
    'NY',
    '11111',
    'USA');

-- if you want insert the col of costomers from another TABLE, you could use
INSERT INTO Customers(cust_id,                  -- one insert one row, INSERT SELECT is an exception
            cust_contact,
            cust_email,
            cust_name,                          -- INSERT SELECT : in SELECT could include WHERE
            cust_address,
            cust_city,
            cust_state,
            cust_zip,
            cust_country)
SELECT cust_id,
    cust_contact,
    cust_email,
    cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country
FROM CustNew;

-- SELECT INTO     NOT FOR DB2
SELECT *
INTO CustCopy
FROM Customers;


-------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE AND DELETE
UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = '1000000005';                  --------------- MUST INCLUDE WHERE  ------------------

UPDATE Customers
SET cust_contact = 'Sam Roberts',
  cust_email = 'sam@toyland.com'
WHERE cust_id = '1000000006';


UPDATE Customers
SET cust_email = NULL
WHERE cust_id = '1000000005';


DELETE FROM Customers                          -- DELETE WILL NOT DELETE THE TABLE ITSELF
WHERE cust_id = '1000000006';                  -- IF WHERE IS OMITTED, IT WILL DELETE EVERY Customers

-- IF YOU WANT DELETE ALL THE ROWS IN THE TABLE, USE ----TURNCATE TABLE ----



-------------------------------------------------------------------------------------------------------------------------------------


SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
AND OrderItems.order_num = Orders.order_num
AND prod_id = 'RGAN01';

-- virtual table ProductCustomers,  then the same result could be get by 

SELECT cust_name, cust_contact
FROM ProductCustomers               -- CREATE VIEW
WHERE prod_id = 'RGAN01';           -- delete the old one before refresh it

/*
CREATE VIEW ProductCustomers AS
SELECT cust_name, cust_contact, prod_id
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
AND OrderItems.order_num = Orders.order_num;


SELECT cust_name, cust_contact
FROM ProductCustomers
WHERE prod_id = 'RGAN01';
*/


SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
AS vend_title
FROM Vendors
ORDER BY vend_name;

-- EQUAL TO 

/*
CREATE VIEW VendorLocations AS
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
AS vend_title
FROM Vendors;
*/

/*
CREATE VIEW CustomerEMailList AS
SELECT cust_id, cust_name, cust_email
FROM Customers
WHERE cust_email IS NOT NULL


SELECT *
FROM CustomerEMailList;


SELECT prod_id,
    quantity,
    item_price,
    quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;

-- equal to 

CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
    prod_id,
    quantity,
    item_price,
    quantity*item_price AS expanded_price
FROM OrderItems;

SELECT *
FROM OrderItemsExpanded
WHERE order_num = 20008;
*/


-------------------------------------------------------------------------------------------------------------------------------------

-- EXECUTE
--EXECUTE AddNewProduct('JTS01',
--            'Stuffed Eiffel Tower',
--            6.49,
--            'Plush stuffed toy with the text La
--➥Tour Eiffel in red white and blue' );

/*
-- Oracle
CREATE PROCEDURE MailingListCount (
    ListCount OUT INTEGER
) I
S
v_rows INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM Customers
    WHERE NOT cust_email IS NULL;
    ListCount := v_rows;
END;

var ReturnValue NUMBER
EXEC MailingListCount(:ReturnValue);
SELECT ReturnValue;


-- SQL sever
CREATE PROCEDURE MailingListCount
AS
DECLARE @cnt INTEGER
SELECT @cnt = COUNT(*)
FROM Customers
WHERE NOT cust_email IS NULL;
RETURN @cnt;

DECLARE @ReturnValue INT
EXECUTE @ReturnValue=MailingListCount;
SELECT @ReturnValue;


CREATE PROCEDURE NewOrder @cust_id CHAR(10)
AS
-- Declare variable for order number
DECLARE @order_num INTEGER
-- Get current highest order number
SELECT @order_num=MAX(order_num)
FROM Orders
-- Determine next order number
SELECT @order_num=@order_num+1
-- Insert new order
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(@order_num, GETDATE(), @cust_id)
-- Return order number
RETURN @order_num;
*/


-------------------------------------------------------------------------------------------------------------------------------------

--transaction processing
/*
BEGIN TRANSACTION
...
COMMIT TRANSACTION
*/

DELETE FROM Orders;
ROLLBACK;


-- COMMIT
BEGIN TRANSACTION
DELETE OrderItems WHERE order_num = 12345
DELETE Orders WHERE order_num = 12345
COMMIT TRANSACTION

SAVE TRANSACTION delete1;

ROLLBACK TRANSACTION delete1;

BEGIN TRANSACTION
INSERT INTO Customers(cust_id, cust_name)
VALUES('1000000010', 'Toys Emporium');
SAVE TRANSACTION StartOrder;
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20100,'2001/12/1','1000000010');
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20100, 1, 'BR01', 100, 5.49);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity, item_price)
VALUES(20100, 2, 'BR03', 100, 10.99);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
COMMIT TRANSACTION

-------------------------------------------------------------------------------------------------------------------------------------

-- create CURSOR
DECLARE CustCursor CURSOR
FOR
SELECT * FROM Customers
WHERE cust_email IS NULL

--OPEN CURSOR CustCursor

DECLARE @cust_id CHAR(10),
    @cust_name CHAR(50),
    @cust_address CHAR(50),
    @cust_city CHAR(50),
    @cust_state CHAR(5),
    @cust_zip CHAR(10),
    @cust_country CHAR(50),
    @cust_contact CHAR(50),
    @cust_email CHAR(255)
OPEN CustCursor
FETCH NEXT FROM CustCursor
INTO @cust_id, @cust_name, @cust_address,
    @cust_city, @cust_state, @cust_zip,
    @cust_country, @cust_contact, @cust_email
WHILE @@FETCH_STATUS = 0
BEGIN

FETCH NEXT FROM CustCursor
    INTO @cust_id, @cust_name, @cust_address,
        @cust_city, @cust_state, @cust_zip,
        @cust_country, @cust_contact, @cust_email
END
CLOSE CustCursor


-- in SQL sever
CLOSE CustCursor
--DEALLOCATE CURSOR CustCursor


-- constraint

CREATE TABLE Vendors
( 
vend_id CHAR(10) NOT NULL PRIMARY KEY,
vend_name CHAR(50) NOT NULL,
vend_address CHAR(50) NULL,
vend_city CHAR(50) NULL,
vend_state CHAR(5) NULL,
vend_zip CHAR(10) NULL,
vend_country CHAR(50) NULL
);

-- ALTER TABLE Vendors
--ADD CONSTRAINT PRIMARY KEY (vend_id);


-- CREATE TABLE Orders
-- (
--     order_num INTEGER NOT NULL PRIMARY KEY,
--     order_date DATETIME NOT NULL,
--     cust_id CHAR(10) NOT NULL REFERENCES Customers(cust_id)
-- );

-- CREATE TABLE OrderItems
-- (
--     order_num INTEGER NOT NULL,
--     order_item INTEGER NOT NULL,
--     prod_id CHAR(10) NOT NULL,
--     quantity INTEGER NOT NULL CHECK (quantity > 0),
--     item_price MONEY NOT NULL
-- );

-- --index 
-- CREATE INDEX prod_name_ind
-- ON PRODUCTS (prod_name);

--trigger

-- CREATE TRIGGER customer_state
-- ON Customers
-- FOR INSERT, UPDATE
-- AS
-- UPDATE Customers
-- SET cust_state = Upper(cust_state)
-- WHERE Customers.cust_id = inserted.cust_id;