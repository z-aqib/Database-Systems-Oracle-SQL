-- Date: 21/dec/24

--Write a PL/SQL code to print multiples of 2 (e.g 2,4,6…12) using for loop.
SET serveroutput ON;

CREATE OR REPLACE PROCEDURE getdoubles (
    minnumber INT,
    maxnumber INT
) IS
BEGIN
    IF maxnumber <= minnumber THEN
        dbms_output.put_line('ERROR: the first value should be smaller than 
        the second');
        RETURN;
    END IF;
    FOR counter IN minnumber..maxnumber LOOP
        dbms_output.put_line(counter * 2);
    END LOOP;

END getdoubles;
/

BEGIN
    getDoubles(10, 15);
END;
/

--Write a PL/SQL code to print table of 2
--(e.g
--2x1=2,
--2x2=4,
--till 2x12=24)
--using for loop.'
CREATE OR REPLACE PROCEDURE print_tables (
    multiplier INT,
    max_value  INT
) IS
BEGIN
    FOR counter IN 1..max_value LOOP
        dbms_output.put_line(multiplier
                             || ' x '
                             || counter
                             || ' = '
                             || counter * multiplier);
    END LOOP;
END;
/

BEGIN
    print_tables(12, 12);
END;
/

--PRODUCTS (prod_id, prod_name and prod_price). Write a
--procedure that prints the name and price for product id=2.
--If the product with id=2 doesn’t exist, output a
--suitable message.
CREATE TABLE products (
    prod_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    prod_name VARCHAR2(255) NOT NULL,
    prod_price NUMBER(6, 2) NOT NULL
);

INSERT INTO products (prod_name, prod_price) VALUES ('Laptop', 799.99);
INSERT INTO products (prod_name, prod_price) VALUES ('Smartphone', 599.49);
INSERT INTO products (prod_name, prod_price) VALUES ('Headphones', 99.99);
INSERT INTO products (prod_name, prod_price) VALUES ('Tablet', 329.95);
INSERT INTO products (prod_name, prod_price) VALUES ('Smartwatch', 249.50);

select * from products;

CREATE OR REPLACE PROCEDURE getnameprice (
    productid INT
) IS
    v_name  products.prod_name%TYPE;
    v_price products.prod_price%TYPE;
BEGIN
    
    SELECT prod_name, prod_price
    INTO v_name, v_price
    FROM products
    WHERE prod_id = productid;
    
    IF SQL%notfound THEN
        dbms_output.put_line('ERROR: Product ID '
                             || productid
                             || ' does not exist');
        RETURN;
    END IF;
    
    dbms_output.put_line(productID || ': ' || v_name || ', Rs.' || v_price);
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('An error occured');
END;

BEGIN
    getnameprice(2);
END;

truncate table products;

DECLARE
    v_errorcode   NUMBER; -- Code for the error
    v_errormsg    VARCHAR2(512); -- Message text for the error
    v_currentuser VARCHAR2(512); -- Current database user
    v_information VARCHAR2(512); -- Information about the error
BEGIN
 /* Code which processes some data here */
    dbms_output.put_line(5/0);
EXCEPTION
    WHEN OTHERS THEN --- Construct similar to Select Case of VB
        v_errorcode := sqlcode;
        v_errormsg := sqlerrm;
        v_currentuser := user;
        v_information := 'Error encountered on '
                         || to_char(sysdate)
                         || ' by database user '
                         || v_currentuser;
        INSERT INTO log_table (
            code,
            message,
            info
        ) VALUES (
            v_errorcode,
            v_errormsg,
            v_information
        );
END;
/

CREATE TABLE log_table (
    code    NUMBER,
    message VARCHAR2(512),
    info    VARCHAR2(512)
);

SELECT
    *
FROM
    log_table;