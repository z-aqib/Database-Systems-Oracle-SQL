-- Date: 31st October 2024

-- Q1: 1. Create tables Customer and Sales as follows.
CREATE TABLE customer (
    cid            VARCHAR2(3) PRIMARY KEY,
    cname          VARCHAR2(25),
    credit_limit   NUMBER,
    credit_balance NUMBER
);

INSERT INTO customer VALUES (
    'C81',
    'Alpha',
    99,
    0
);

INSERT INTO customer VALUES (
    'C82',
    'Bravo',
    700,
    0
);

INSERT INTO customer VALUES (
    'C83',
    'Charlie',
    5000,
    0
);

COMMIT;

SELECT
    *
FROM
    customer;

CREATE TABLE sales (
    sid    NUMBER PRIMARY KEY,
    sdate  DATE DEFAULT sysdate,
    pcode  VARCHAR2(3),
    cid    VARCHAR2(3),
    qty    NUMBER,
    rate   NUMBER,
    amount NUMBER,
    FOREIGN KEY ( cid )
        REFERENCES customer ( cid )
);

-- Create the following Triggers:
-- a. SALES_Before_insert which updates customer credit balance (in 
-- customer table) to credit balance + :new.Amount before inserting 
-- amount in the sales table. Test your trigger by inserting a 
-- record in the sales table and checking the values in customers
-- table. 
CREATE OR REPLACE TRIGGER sales_before_insert BEFORE
    INSERT ON sales
    FOR EACH ROW
BEGIN
 -- update the credit balance in the customers table
    UPDATE customer
    SET
        credit_balance = credit_balance + :new.amount
    WHERE
        cid = :new.cid;

END;

-- Test the trigger by inserting a record into the sales table
INSERT INTO sales (
    sid,
    sdate,
    pcode,
    cid,
    qty,
    rate,
    amount
) VALUES (
    1,
    sysdate,
    'P01',
    'C81',
    2,
    50,
    100
);

-- Test the trigger by inserting a record into the sales table
INSERT INTO sales (
    sid,
    sdate,
    pcode,
    cid,
    qty,
    rate,
    amount
) VALUES (
    2,
    sysdate,
    'P02',
    'C81',
    2,
    50,
    100
);

-- Verify the customer table's credit balance for 'C81'
SELECT
    *
FROM
    customer
WHERE
    cid = 'C81';

-- see all sales
SELECT
    *
FROM
    sales;

-- b: b. SALES_Before_Del which reduces customers credit balance by 
-- the amount before deleting each row of the sales table. Delete 
-- the record inserted in a to test the trigger. 
CREATE OR REPLACE TRIGGER sales_before_del BEFORE
    DELETE ON sales
    FOR EACH ROW
BEGIN
 -- update the credit balance in the customers table
    UPDATE customer
    SET
        credit_balance = credit_balance - :old.amount
    WHERE
        cid = :old.cid;

END;

DELETE FROM sales
WHERE
    sid = 1;

SELECT
    *
FROM
    sales;

SELECT
    *
FROM
    customer;

-- c. Drop the 2 triggers created in (a) and (b). Create a trigger, 
-- SALES_Insert_Del which combines the functionality of the above 
-- 2 triggers into one. Repeat the tests in (a) and (b) to validate 
-- your trigger. 
DROP TRIGGER sales_before_insert;

DROP TRIGGER sales_before_del;

CREATE OR REPLACE TRIGGER sales_insert_del BEFORE
    INSERT OR DELETE ON sales
    FOR EACH ROW
BEGIN
    IF inserting THEN 
 -- update the credit balance in the customers table
        UPDATE customer
        SET
            credit_balance = credit_balance + :new.amount
        WHERE
            cid = :new.cid;

    END IF;

    IF deleting THEN
        UPDATE customer
        SET
            credit_balance = credit_balance - :old.amount
        WHERE
            cid = :old.cid;

    END IF;

END;

-- Test by inserting a record into the sales table
INSERT INTO sales (
    sid,
    sdate,
    pcode,
    cid,
    qty,
    rate,
    amount
) VALUES (
    3,
    sysdate,
    'P03',
    'C81',
    1,
    200,
    200
);

-- Verify the customer table's credit balance for 'C81'
SELECT
    *
FROM
    customer
WHERE
    cid = 'C81';

-- Delete the record to check if credit balance is adjusted 
-- accordingly
DELETE FROM sales
WHERE
    sid = 3;

-- Check final results
SELECT
    *
FROM
    customer
WHERE
    cid = 'C81';

SELECT
    *
FROM
    sales;

-- Q2
-- a) Run the DDL commands to create the table with appropriate data 
-- types
CREATE TABLE orders (
    order_id      NUMBER(5) PRIMARY KEY,
    quantity      NUMBER(4),
    cost_per_item NUMBER(6, 2),
    total_cost    NUMBER(8, 2),
    discount      NUMBER(2),
    final_charged NUMBER(8, 2)
);

-- b) Create a trigger that generates the total_cost by multiplying 
-- the cost per item and Quantity whenever a new record is added. 
-- Also calculate the final_charged which will be generated by 
-- applying the discount. 
CREATE OR REPLACE TRIGGER generate_total BEFORE
    INSERT ON orders
    FOR EACH ROW
BEGIN
    :new.total_cost := :new.cost_per_item * :new.quantity;
    :new.final_charged := :new.total_cost - ( :new.total_cost * ( :new.discount / 100 ) );

END;

-- Test the trigger by inserting a record into the sales table
INSERT INTO orders (
    order_id,
    quantity,
    cost_per_item,
    discount
) VALUES (
    10001,
    10,
    50.00,
    10
);

DELETE FROM orders
WHERE
    order_id = 10001;

SELECT
    *
FROM
    orders;

SELECT
    *
FROM
    sales;

-- QUESTION 2 PART C:
INSERT INTO orders (
    order_id,
    quantity,
    cost_per_item,
    discount
) VALUES (
    1,
    10,
    200,
    25
);

SELECT
    *
FROM
    orders;

-- QUESTION 2 PART D:
INSERT INTO orders (
    order_id,
    quantity,
    cost_per_item,
    discount
) VALUES (
    2,
    15,
    300,
    15
);

SELECT
    *
FROM
    orders;

-- QUESTION 3 PART A: 
CREATE TABLE currency_con (
    cid      VARCHAR2(3) PRIMARY KEY,
    currency VARCHAR2(50),
    rate     NUMBER(10, 2)
);

CREATE TABLE fluctuations (
    recdate    DATE,
    currency   VARCHAR2(50),
    difference NUMBER(10, 2)
);

-- QUESTION 3 PART B: 
INSERT INTO currency_con (
    cid,
    currency,
    rate
) VALUES (
    'USD',
    'US Dollar',
    278.50
);

INSERT INTO currency_con (
    cid,
    currency,
    rate
) VALUES (
    'GBP',
    'British Pound',
    346.75
);

-- check if it has been added
SELECT
    *
FROM
    currency_con;

-- QUESTION 3 PART C: 
set serveroutput on;

CREATE OR REPLACE TRIGGER currency_fluctuation_log AFTER
    INSERT OR UPDATE ON currency_con
    FOR EACH ROW
BEGIN
    -- part i
    IF inserting THEN
        INSERT INTO fluctuations (
            recdate,
            currency,
            difference
        ) VALUES (
            sysdate,
            :new.currency,
            0
        );

        dbms_output.put_line('The new currency '
                             || :new.currency
                             || ' is added 
        to fluctuations table successfully');
    ELSIF updating THEN
        INSERT INTO fluctuations (
            recdate,
            currency,
            difference
        ) VALUES (
            sysdate,
            :new.currency,
            :new.rate - :old.rate
        );

    END IF;
END;

INSERT INTO currency_con (
    cid,
    currency,
    rate
) VALUES (
    'EUR',
    'Euro',
    300.00
);

SELECT
    *
FROM
    fluctuations;

UPDATE currency_con
SET
    rate = 285.00
WHERE
    cid = 'USD';

SELECT
    *
FROM
    fluctuations;
-- so we had inserted us dollar as 278.5 and updated to 285 so difference is 6.5

-- Q4: 4. Suppose we have a Worker table as follows:
-- worker(workerID, lname, gender, salary, commission, deptID)
-- a.  Write DDL commands to create the table with appropriate data types. 
CREATE TABLE worker (
    workerid   INT PRIMARY KEY,
    lname      VARCHAR2(255),
    gender     VARCHAR2(1),
    salary     NUMBER(9, 2),
    commission NUMBER(9, 2),
    deptid     INT
);

-- b. Declare a sequence for workerID that begins from 100 and increments by 5.
CREATE SEQUENCE workerid_seq START WITH 100 INCREMENT BY 5;

-- c. Write a trigger that automatically inserts the primary key with a sequential
--  number when inserting a record in the worker table.
CREATE OR REPLACE TRIGGER worker_before_insert BEFORE
    INSERT ON worker
    FOR EACH ROW
BEGIN
    SELECT
        workerid_seq.NEXTVAL
    INTO :new.workerid
    FROM
        dual;

END;

--d. Insert 2 records to test your trigger, each time providing all attributes except the
--primary key. 

INSERT INTO worker (
    lname,
    gender,
    salary,
    commission,
    deptid
) VALUES (
    'Zuha',
    'F',
    50000,
    5000.50,
    1
);

INSERT INTO worker (
    lname,
    gender,
    salary,
    commission,
    deptid
) VALUES (
    'Aqib',
    'M',
    60000,
    6000.02,
    2
);

SELECT
    *
FROM
    worker;

--5. Suppose we have the following two tables:
--OrderHeader(OrderID, Odate, CustID, Total)
--Order_Item(OrderID,ItemID, Qty, Subtotal)
--a. Write DDL commands to create the tables with suitable datatypes. 
CREATE TABLE orderheader (
    orderid INT PRIMARY KEY,
    odate   DATE,
    custid  INT,
    total   NUMBER(9, 2)
);

CREATE TABLE order_item (
    orderid  NUMBER,
    itemid   INT,
    qty      NUMBER,
    subtotal NUMBER(9, 2),
    FOREIGN KEY ( orderid )
        REFERENCES orderheader ( orderid ),
    CONSTRAINT pk PRIMARY KEY ( orderid,
                                itemid )
);

--PART B
CREATE OR REPLACE TRIGGER orderitem_after_iud AFTER
    INSERT OR UPDATE OR DELETE ON order_item
DECLARE
    CURSOR c_total IS
    SELECT
        orderid       AS orderid,
        SUM(subtotal) AS total_amount
    FROM
        order_item
    GROUP BY
        orderid;

BEGIN
    FOR v_total IN c_total LOOP
        UPDATE orderheader
        SET
            total = v_total.total_amount
        WHERE
            orderid = v_total.orderid;

    END LOOP;
END;

INSERT INTO orderheader (
    orderid,
    odate,
    custid
) VALUES (
    1,
    sysdate,
    1
);

INSERT INTO order_item VALUES (
    1,
    1,
    20,
    200
);

INSERT INTO order_item VALUES (
    1,
    2,
    5,
    100
);

SELECT
    *
FROM
    orderheader;

--QUESTION 6
CREATE OR REPLACE FUNCTION average_dept_salary (
    dep_name IN VARCHAR2
) RETURN NUMBER IS
    avg_sal NUMBER;
BEGIN
    SELECT
        round(AVG(salary),
              2)
    INTO avg_sal
    FROM
             employees e
        INNER JOIN departments d ON d.department_id = e.department_id
    WHERE
        d.department_name = dep_name;

    RETURN avg_sal;
END;

SELECT
    average_dept_salary('IT')
FROM
    dual;

--QUESTION 7
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE region_max_sal IS

    CURSOR c_region_max IS
    SELECT
        MAX(e.salary) AS max_sal,
        r.region_name AS region_name
    FROM
             employees e
        INNER JOIN departments d ON d.department_id = e.department_id
        INNER JOIN locations   l ON l.location_id = d.location_id
        INNER JOIN countries   c ON c.country_id = l.country_id
        INNER JOIN regions     r ON r.region_id = c.region_id
    GROUP BY
        r.region_name;

BEGIN
    FOR v_region_max IN c_region_max LOOP
        dbms_output.put_line(v_region_max.region_name
                             || ': '
                             || v_region_max.max_sal);
    END LOOP;
END;

BEGIN
    REGION_MAX_SAL
END;

--QUESTION 8
CREATE OR REPLACE FUNCTION COUNT_EMPLOYEES
RETURN COUNT
IS
    V_COUNT INTEGER
BEGIN
    SELECT
        COUNT(*)
    INTO v_count
    FROM
        (
            SELECT
                employee_id
            FROM
                job_history
            GROUP BY
                employee_id
            HAVING
                COUNT(*) > 1
        );

    RETURN v_count;
END;

SELECT
    count_employees
FROM
    dual;
