-- Date: 5th September 2024

--------------------------------- PART A ---------------------------------

-- Q1: 1. Create a table my_first_table with the following.
-- Variable Data type
-- Name     Varchar2(255)
-- Email    Varchar2(255)
-- Age      Int
-- Marks    Number (3,1)
-- Execute DESC my_first_table to confirm the structure of the table.
CREATE TABLE my_first_table (
    name  VARCHAR2(255),
    email VARCHAR2(255),
    age   INT,
    marks NUMBER(3, 1)
);
/* created successfully */

DESC my_first_table;
/* name, email, age [ number(38) ], marks - rest are same as above */

-- Q2: 2. Create a table for Products containing product_id, product_name, 4
-- price, supplier_id, category_id. An example of product price is 10.50.
CREATE TABLE products (
    product_id   INT,
    product_name VARCHAR2(255),
    price        NUMBER(6, 2),
    supplier_id  INT,
    category_id  INT
);
/* created successfully - we used 6,2 for price as what if the price cost is of 
4 digits (1000-9999) and it has 2 decimal places */

DESC products;
/* id, name, price, supplier id [ number(38) ], category id [ number(38) ] */

-- Q3: 3. Consider the situation where we only need to create the Products table 
-- if it doesn’t already exist. The attributes will remain the same as in 1.
CREATE TABLE IF NOT EXISTS products (
    product_id   INT,
    product_name VARCHAR2(255),
    price        NUMBER(6, 2),
    supplier_id  INT,
    category_id  INT
);
/* doesnt run, not supported by oracle */ 

-- Q4: 4. Create a table named duplicate_Products which is similar to the 
-- products table. Only the copy of table structure and not the data. 
CREATE TABLE duplicate_products LIKE PRODUCTS ;
/* doesnt run, not supported by oracle */ 

--Q5: 5. Create a table named dup_data_Products which is a duplicate copy of 
-- Products table including structure and data. Execute the DESC command for 
-- products and this new table to compare the components. 
CREATE TABLE dup_data_products
    AS
        SELECT
            product_id,
            product_name,
            price,
            supplier_id,
            category_id
        FROM
            products;
/* created successfully */

DESC dup_data_products;
/* product_id [ number(38) ], product_name, price, supplier_id [ number(38) ], 
category_id [ number(38) ] */

-- Q6: 6. Create a table for Suppliers containing supplier_id (starts from 1,2,
-- 3...), supplier_name, address, city (3 characters e.g KHI). Make sure none of 
-- the attributes are allowed to have null values. 
CREATE TABLE suppliers (
    supplier_id   INT
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    supplier_name VARCHAR2(255) NOT NULL,
    address       VARCHAR2(255) NOT NULL,
    city          CHAR(3)
);
/* created successfully */

DESC suppliers;
/* id, name, address, city: all are not null except city */

-- Q7: 7. Create a table named Order_Details including order_id, product_id, 
-- quantity. Assume orders with quantity greater than 50 are not allowed. 
-- Execute the command “INSERT INTO Order_Details VALUES (1,1,100);”. Then 
-- execute “SELECT * FROM Order_Details” to see the data being inserted.
CREATE TABLE order_details (
    order_id   INT,
    product_id INT,
    quantity   INT CHECK ( quantity <= 50 )
);
/* created successfully */

DESC order_details;
/* id, product id, quantity, all are int */

INSERT INTO order_details (
    order_id,
    product_id,
    quantity
) VALUES (
    1,
    1,
    100
);
/* ERROR as quantity is greater than 50, check condition not met therefore 
not inserted [ constraint violated ] */

SELECT
    *
FROM
    order_details;
/* displays an empty table as nothing has been inserted yet */

-- Q8: 8. Create another suppliers table and name it as Supplier_2 with the same 
-- attributes and datatypes. Assume that the suppliers from Karachi (KHI), 
-- Islamabad (ISB) or Lahore (LHR) can be entered. Execute the following to test:
CREATE TABLE supplier_2 (
    supplier_id   INT
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    supplier_name VARCHAR2(255) NOT NULL,
    address       VARCHAR2(255) NOT NULL,
    city          CHAR(3)       CHECK ( city = 'KHI'
                         OR city = 'ISL'
                         OR city = 'LHR' )
);
/* created successfully */

DESC supplier_2;
/* id, name, address city: all are not null except city */

-- a. INSERT INTO Supplier_2 (supplier_name, address, city)
-- Values ('MySupplier1','MyAddress','LHR');
INSERT INTO supplier_2 (
    supplier_name,
    address,
    city
) VALUES (
    'MySupplier1',
    'MyAddress',
    'LHR'
);
/* 1 row inserted successfully */

SELECT
    *
FROM
    supplier_2;
/* 1 row exists */

-- b. INSERT INTO Supplier_2 (supplier_name, address, city)
-- Values ('MySupplier2','MyAddress','RWP');
INSERT INTO supplier_2 (
    supplier_name,
    address,
    city
) VALUES (
    'MySupplier2',
    'MyAddress',
    'RWP'
);
/* constraint violated: it wont run as we wont accept suppliers from rawalpinidi */

-- c. SELECT * FROM Supplier_2
SELECT
    *
FROM
    supplier_2;
/* only one netry of lahore */

-- Q9: 9. Create a table named Orders including order_id, order_date and 
-- ship_address. We need to ensure that the date entered follows the specific 
-- format like '--/--/----'. Hint: Use like operator with wildcards to specify 
-- the pattern for date as a string. Execute the following to test:
CREATE TABLE orders (
    order_id     INT,
    order_date   VARCHAR2(255) CHECK ( order_date LIKE '__/__/____' ),
    ship_address VARCHAR2(255)
);
/* created successfully */

DESC Orders;
/* id, date, address */

-- a. INSERT INTO Orders VALUES (1,'23/05/2023','Address');
INSERT INTO orders VALUES (
    1,
    '23/05/2023',
    'Address'
);
/* row inserted successfully */

-- b. INSERT INTO Orders VALUES (2, '2-5-2023','Address2');
INSERT INTO orders VALUES (
    2,
    '2-5-2023',
    'Address2'
);
/* error: constraints violated, used dashes instead of slashes */

-- Modify the datatype for order date to DATE and record your observations after you
-- insert another row. What do we need to ensure on insertion? Hint: To_Date
ALTER TABLE orders MODIFY
    order_date DATE;
/* it doesnt run due to invalid check. when converting to dates, the check constraint
along with the date format violate each other. therefore we must
 -> delete that constraint = this is not possible as we have not named the 
                            constraint therefore we cannot delete it 
 -> delete that column = first we must delete the exisitng rows and then add a new 
                        column, this time with data type of DATE
*/

/* to update a datatype i must delete the entire data */
TRUNCATE TABLE orders;
/* table rows are deleted and table is empty */

/* now check, is it empty? */
SELECT
    *
FROM
    orders;
/* yes, empty table */

/* now delete the entire column. we cannot do drop constraint as this CHECK constraint 
has no name so we cannot call and drop it */
ALTER TABLE orders DROP COLUMN order_date;
/* altered successfully */

/* now check if it has been dropped */
SELECT
    *
FROM
    orders;
/* empty table and only 2 columns, id and address */

/* add the column again with correct data type */
ALTER TABLE orders ADD order_date DATE;
/* altered successfully */

/* now check if it has been added */
DESC orders;
/* id, address, date */

SELECT
    *
FROM
    orders;
/* id, address, date */

/* add an insertion, make sure to add it in the form ID ADDRESS DATE */
INSERT INTO orders VALUES (
    3,
    'Address3',
    TO_DATE('2024/05/05', 'YYYY/MM/DD')
);
/* 1 row inserted successfully */

/* check if its been added */
SELECT
    *
FROM
    orders;
/* added successfully */

-- Q10: 10. Alter the table Products and apply primary key constraint on product_id.
/* first lets see again what was the products table*/
DESC products;
/* id, name, price, supplier id, categoy id */

/* now lets alter the product_id column constraint */
ALTER TABLE products MODIFY
    product_id INT PRIMARY KEY;
/* altered successfully */

/* now lets check if it has been altered */
DESC products;
/* now product_id is NOT NULL */

-- Q11: 11. Drop the Suppliers table. 
DROP TABLE suppliers;
/* dropped successfully. you can see the tables list on the left (refresh) and see 
it is no longer visible */

-- Create the Suppliers table again. This time make sure to set the supplier_id 
-- as primary key. Also remember that it cannot be Null.
CREATE TABLE suppliers (
    supplier_id   INT
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    supplier_name VARCHAR2(255) NOT NULL,
    address       VARCHAR2(255) NOT NULL,
    city          CHAR(3)
);
/* created successfully */

DESC suppliers;
/* id, name, address, city - all are NOT NULL except city */

-- Q12: 12. Create a table for Categories containing category_id (as Primary Key), 
-- category_name, description.
CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(255),
    description   VARCHAR(255)
);
/* created successfully */

DESC categories;
/* id, name, description - id is NOT NULL */

-- Date: 8th September 2024

-- Q13: 13. Drop the products table.
DROP TABLE products;
/* dropped successfully */

-- Create the Products table again containing product_id (PK), product_name, price, 
-- supplier_id (foreign key referencing to suppliers table), category_id (foreign 
-- key referencing to categories table). Restrict duplicate records. Hint: use 
-- unique constraint for essential attributes. Make sure to give names for all
-- constraints.
CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR2(255),
    price        NUMBER(6, 2),
    supplier_id  INT,
    category_id  INT,
    CONSTRAINT uc_name UNIQUE ( product_name ),
    FOREIGN KEY ( supplier_id )
        REFERENCES suppliers ( supplier_id ),
    FOREIGN KEY ( category_id )
        REFERENCES categories ( category_id )
);
/* created successfully - the product name and ID should be unquie, the price, 
supplier and category can be same. */

DESC products;
/* id, name, price, supplier_id, category_id - only product_id is NOT NULL */

-- Q14: 14. Drop the orders table. 
DROP TABLE orders;
/* dropped successfully */

-- Create the Orders table again containing order_id, order_date and ship_address. 
-- Set the order_id as primary key which is unique and auto incremented. The 
-- default value for order_date is sysdate. 
CREATE TABLE orders (
    order_id     INT
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    order_date   DATE DEFAULT sysdate,
    ship_address VARCHAR2(255)
);
/* created successfully */

DESC orders;
/* id, date, address = id is NOT NULL */

-- Execute to verify default date:
-- a. INSERT INTO Orders (ship_address) VALUES ('Address');
INSERT INTO orders ( ship_address ) VALUES ( 'Address' );
/* 1 row inserted successfully */

-- b. SELECT * FROM Orders;
SELECT
    *
FROM
    orders;
/* YES: the order_date is todays date, 8-sep-24 */

-- Q15: 15. Drop the Order_Details table. 
DROP TABLE order_details;
/* dropped successfully */

-- Create the Order_Details table containing order_id, product_id, quantity. The 
-- product_id and order_id forms the composite primary key and are related to 
-- the Orders table and Products table respectively. 
CREATE TABLE order_details (
    order_id   INT,
    product_id INT,
    quantity   INT,
    CONSTRAINT pk_prorder PRIMARY KEY ( product_id,
                                        order_id ),
    FOREIGN KEY ( order_id )
        REFERENCES orders ( order_id ),
    FOREIGN KEY ( product_id )
        REFERENCES products ( product_id )
);
/* created successfully */

DESC order_details;
/* order_id, product_id, quantity = all are NOT NULL except quantity */

--------------------------------- PART B ---------------------------------

-- Q16: 16. Insert into Categories the following data
-- Category_id Category_Name Description
-- 1            Beverages       Soft drinks, coffees, teas
-- 2            Dairy Products  Cheese
-- 3            Condiments      Sweet and savory sauces, spreads and seasonings
-- 4            Confections     Desserts and candies
INSERT INTO categories (
    category_id,
    category_name,
    description
) VALUES (
    1,
    'Beverages',
    'Soft drinks, coffees, teas'
);
/* 1 row inserted */

INSERT INTO categories (
    category_id,
    category_name,
    description
) VALUES (
    2,
    'Dairy Products',
    'Cheese'
);
/* 1 row inserted */

INSERT INTO categories (
    category_id,
    category_name,
    description
) VALUES (
    3,
    'Condiments',
    'Sweet and savory sauces, spreads and seasonings'
);
/* 1 row inserted */

INSERT INTO categories (
    category_id,
    category_name,
    description
) VALUES (
    4,
    'Confections',
    'Desserts and candies'
);
/* 1 row inserted */

/* verify that all four have inserted correctly */
SELECT
    *
FROM
    categories;
/* Verified! */

-- Q17: 17. Insert into Suppliers
-- Supplier_id  Supplier_name   Address                             City
-- 1            Alpha           205 A, Street 11, Gulshan-e-Iqbal   KHI
-- 2            Bravo           100 B, Street 2, F-6/3              ISB
INSERT INTO suppliers (
    supplier_name,
    address,
    city
) VALUES (
    'Alpha',
    '205 A, Street 11, Gulshan-e-Iqbal',
    'KHI'
);
/* 1 row inserted - id is generated by itself so no need to enter it */

INSERT INTO suppliers (
    supplier_name,
    address,
    city
) VALUES (
    'Bravo',
    '100 B, Street 2, F-6/3',
    'ISB'
);
/* 1 row inserted successfully */

/* to check if all have been inserted correctly */
SELECT
    *
FROM
    suppliers;
/* verified! */

-- Q18: 18. Insert into Products
-- Product_id   Product_name        Price   Supplier_id Category_id
-- 1            Chai                100.00  1           1
-- 2            Cheddar Cheese      950.00  2           2
-- 3            BBQ sauce           500.00  2           3
-- 4            Coffee              200.00  1           1
-- 5            Sprite              80.00   1           1
-- 6            Mayo Garlic Sauce   450.00  2           3
INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    1,
    'Chai',
    100.00,
    1,
    1
);
/* 1 row inserted successfully */

INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    2,
    'Cheddar Cheese',
    950.00,
    2,
    2
);
/* 1 row inserted successfully */

INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    3,
    'BBQ Sauce',
    500.00,
    2,
    3
);
/* 1 row inserted successfully */

INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    4,
    'Coffee',
    200.00,
    1,
    1
);
/* 1 row inserted successfully */

INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    5,
    'Sprite',
    80.00,
    1,
    1
);
/* 1 row inserted successfully */

INSERT INTO products (
    product_id,
    product_name,
    price,
    supplier_id,
    category_id
) VALUES (
    6,
    'Mayo Garlic Sauce',
    450.00,
    2,
    3
);
/* 1 row inserted successfully */

/* now check if all have inserted properly */
SELECT
    *
FROM
    products;
/* verified */

-- Q19: 19. Display all products belonging to category_id =1 and supplier _id=1
SELECT
    *
FROM
    products
WHERE
        category_id = 1
    AND supplier_id = 1;
/* 3 products listed, chai, coffee, sprite */

-- Q20: 20. Display the average price of products for each category_id. 
SELECT
    category_id,
    round(AVG(price),
          2) AS average_price_of_category
FROM
    products
GROUP BY
    category_id;
/* 3 categories for 1, 2, 3 - each has their average prices */

-- Q21: 21. Display all category names sorted in the alphabetical order. 
SELECT
    category_id,
    category_name
FROM
    categories
ORDER BY
    category_name ASC;
/* 4 categories 1, 2, 3, 4 - listed in alphabetical order 1, 3, 4, 2 */

------------------------------ SELF PRACTICE ------------------------------

-- Self Practice: Enrollment Database
-- You may attempt this for your own learning – no need to submit
-- Consider the ER Model for the enrollment database.
-- Write the necessary DDL commands to create student table and course table. 
-- You may ignore the Foreign key constraints in this case. 
CREATE TABLE student (
    student_erp        INT PRIMARY KEY,
    student_name       VARCHAR2(255) NOT NULL,
    student_email      VARCHAR2(255) UNIQUE,
    student_program    CHAR(2) NOT NULL,
    student_admit_term INT NOT NULL,
    CONSTRAINT student_erp_name UNIQUE ( student_erp,
                                         student_name )
);
/* created successfully */

DESC sTUDENT;
/* only email can be null as it is not directly required in enrollment */

CREATE TABLE course (
    course_id         INT PRIMARY KEY,
    course_name       VARCHAR2(255) NOT NULL,
    course_instructor VARCHAR2(255) NOT NULL,
    course_program    CHAR(2) NOT NULL,
    course_type       CHAR(4) NOT NULL,
    course_capacity   INT NOT NULL,
    CONSTRAINT course_name_instructor UNIQUE ( course_name,
                                               course_instructor )
);
/* created successfully */

DESC COURSE;
/* all details should be entered as all are required for enrollment */