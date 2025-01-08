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
    
-- date: 22/dec/24
--3. Write a PL/SQL program to check if a user entered number is a multiple of 2 then output ‘Even’ else
--‘Odd’. Hint: Lookup MOD function.
SET serveroutput ON;

CREATE OR REPLACE PROCEDURE even_checker IS
    user_input INT;
BEGIN
    user_input := &user_input;
    IF MOD(user_input, 2) = 0 THEN
        dbms_output.put_line('The entered value '
                             || user_input
                             || ' is even. ');
    ELSE
        dbms_output.put_line('The entered value '
                             || user_input
                             || ' is odd. ');
    END IF;

END even_checker;
/

BEGIN
    even_checker;
END;

--4. Write a PL/SQL program using a while loop which takes input from the user and returns the
--multiplication table.
CREATE OR REPLACE PROCEDURE multiplication_table_maker IS
    user_multiplier INT;
    user_end        INT;
    counter         INT := 1;
    e_multiplier_small EXCEPTION;
    e_end_small EXCEPTION;
BEGIN
    user_multiplier := &user_multiplier;
    user_end := &user_end;
    IF user_multiplier <= 0 THEN
        RAISE e_multiplier_small;
    ELSIF user_end <= 1 THEN
        RAISE e_end_small;
    END IF;

    WHILE counter < user_end LOOP
        dbms_output.put_line(user_multiplier
                             || ' x '
                             || counter
                             || ' = '
                             || user_multiplier * counter);

        counter := counter + 1;
    END LOOP;

EXCEPTION
    WHEN e_multiplier_small THEN
        dbms_output.put_line('ERROR: Your multiplier should be greater than 0. ');
        RETURN;
    WHEN e_end_small THEN
        dbms_output.put_line('ERROR: Your end number should be greater than 1. ');
        RETURN;
END multiplication_table_maker;
/

BEGIN
    multiplication_table_maker;
END;

--5. Write a program to print the first_name of employee with ID = 100. Your output should be in the
--format “The first name of the employee with ID=100 is (name)”. 
CREATE OR REPLACE PROCEDURE getfirstemployee (
    employeeid employees.employee_id%TYPE
) IS
    var_first_name employees.first_name%TYPE;
BEGIN
    SELECT
        first_name
    INTO var_first_name
    FROM
        employees
    WHERE
        employee_id = employeeid;

    dbms_output.put_line('The first name of the employee with ID='
                         || employeeid
                         || ' is '
                         || var_first_name);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('ERROR: there is no employee with the ID ' || employeeid);
        RETURN;
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '
                             || sqlcode
                             || ' an unexpected error occured: '
                             || sqlerrm);
        RETURN;
END getfirstemployee;

begin
getfirstemployee(100);
end;

--6. Write a procedure named get_email which takes empID as input parameter and prints the email in
--a suitable format. Example: “EmpID 101: [emailaddress]”. Execute the procedure to test. 
CREATE OR REPLACE PROCEDURE getfirstemployee_email (
    employeeid employees.employee_id%TYPE
) IS
    var_email employees.email%TYPE;
BEGIN
    SELECT
        email
    INTO var_email
    FROM
        employees
    WHERE
        employee_id = employeeid;

    dbms_output.put_line('EmpID='
                         || employeeid
                         || ': '
                         || var_email);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('ERROR: there is no employee with the ID ' || employeeid);
        RETURN;
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '
                             || sqlcode
                             || ' an unexpected error occured: '
                             || sqlerrm);
        RETURN;
END getfirstemployee_email;

begin
getfirstemployee_email (101);
end;

--7. Write a procedure named get_emp_city which takes empID as input paramter and prints the city
--where the employee is working. If there is no data for empID, then print a suitable error. Execute
--the procedure to test. Try out an employee ID which does not exist. 
CREATE OR REPLACE PROCEDURE getfirstemployee_city (
    employeeid employees.employee_id%TYPE
) IS
    var_city locations.city%TYPE;
BEGIN
    SELECT
        city
    INTO var_city
    FROM
             employees
        INNER JOIN departments ON employees.department_id = departments.department_id
        INNER JOIN locations ON departments.location_id = locations.location_id
    WHERE
        employees.employee_id = employeeid;

    dbms_output.put_line('EmpID='
                         || employeeid
                         || ': '
                         || var_city);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('ERROR: there is no employee with the ID ' || employeeid);
        RETURN;
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '
                             || sqlcode
                             || ' an unexpected error occured: '
                             || sqlerrm);
        RETURN;
END getfirstemployee_city;

begin
getfirstemployee_city(500);
end;

--Write a procedure using cursors to print Job Title and Name of the Employee working in the IT
--department using open-fetch-close
CREATE OR REPLACE PROCEDURE get_job_title (
    p_department_name departments.department_name%TYPE
) IS

    v_name      employees.first_name%TYPE;
    v_job_title jobs.job_title%TYPE;
    CURSOR c_department IS
    SELECT
        job_title,
        concat(first_name,
               concat(' ', last_name)) AS name
    FROM
             employees
        INNER JOIN departments ON employees.department_id = departments.department_id
        INNER JOIN jobs ON employees.job_id = jobs.job_id
    WHERE
        departments.department_name = p_department_name;

BEGIN
    OPEN c_department;
    LOOP
        FETCH c_department INTO
            v_job_title,
            v_name;
        EXIT WHEN c_department%notfound;
        dbms_output.put_line(v_name
                             || ': '
                             || v_job_title);
    END LOOP;

    CLOSE c_department;
END;

begin
get_job_title('IT');
end;

--Write a procedure named get_job_history using cursorsto print employeeName, Job_id, start_date
--for all employees in department ID =50 using cursors and for loop.
CREATE OR REPLACE PROCEDURE get_job_history (
    p_department_id departments.department_id%TYPE
) IS
    CURSOR c_employees IS
    SELECT
        concat(first_name,
               concat(' ', last_name)) AS name,
        job_id,
        hire_date,
        department_id
    FROM
        employees
    WHERE
        department_id = p_department_id;
BEGIN
    FOR employee IN c_employees LOOP
        dbms_output.put_line(employee.name
                             || ', '
                             || employee.job_id
                             || ', '
                             || employee.hire_date
                             || ', '
                             || employee.department_id);
    END LOOP;
END;

BEGIN
    get_job_history(50);
END;

--10. Write a program to interchange the salaries of employee 120 and 122
CREATE OR REPLACE PROCEDURE swap_salaries (
    p_emp_1 employees.employee_id%TYPE,
    p_emp_2 employees.employee_id%TYPE
) IS
    v_salary_1 employees.salary%TYPE;
    v_salary_2 employees.salary%TYPE;
BEGIN
    SELECT
        salary
    INTO v_salary_1
    FROM
        employees
    WHERE
        employee_id = p_emp_1;

    SELECT
        salary
    INTO v_salary_2
    FROM
        employees
    WHERE
        employee_id = p_emp_2;

    dbms_output.put_line(p_emp_1
                         || ': $'
                         || v_salary_1);
    dbms_output.put_line(p_emp_2
                         || ': $'
                         || v_salary_2);
    UPDATE employees
    SET
        salary = v_salary_2
    WHERE
        employee_id = p_emp_1;

    UPDATE employees
    SET
        salary = v_salary_1
    WHERE
        employee_id = p_emp_2;

    SELECT
        salary
    INTO v_salary_1
    FROM
        employees
    WHERE
        employee_id = p_emp_1;

    SELECT
        salary
    INTO v_salary_2
    FROM
        employees
    WHERE
        employee_id = p_emp_2;

    dbms_output.put_line(p_emp_1
                         || ': $'
                         || v_salary_1);
    dbms_output.put_line(p_emp_2
                         || ': $'
                         || v_salary_2);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('error: one of the employees do not exist');
        RETURN;
END;

BEGIN
    swap_salaries(120, 122);
END;

--11. Write a program to increase the salary of employee id 115 based on the following conditions using
--case expression:
--Experience Increase salary by
--> 10 years 20%
--> 5 years 10%
--Otherwise 5%
--Use the rowcount attribute to print the number of rows modified.
--Test your program by executing it.

CREATE OR REPLACE PROCEDURE update_salary (
    p_emp_id employees.employee_id%TYPE
) IS
    v_hire_date  employees.hire_date%TYPE;
    v_salary     employees.salary%TYPE;
    v_experience INT;
BEGIN
    SELECT
        salary,
        hire_date
    INTO
        v_salary,
        v_hire_date
    FROM
        employees
    WHERE
        employee_id = p_emp_id;

    dbms_output.put_line('salary: ' || v_salary);
    v_experience := floor(months_between(sysdate, v_hire_date) / 12);
    dbms_output.put_line('experience: ' || v_experience);
    UPDATE employees
    SET
        salary =
            CASE
                WHEN v_experience > 10 THEN
                    salary * 1.2
                WHEN v_experience > 5  THEN
                    salary * 1.1
                ELSE
                    salary * 1.05
            END
    WHERE
        employee_id = p_emp_id;

    dbms_output.put_line('rows updated: ' || SQL%rowcount);
    SELECT
        salary
    INTO v_salary
    FROM
        employees
    WHERE
        employee_id = p_emp_id;

    dbms_output.put_line('salary: ' || v_salary);
END;

begin
update_salary(115);
end;

--12. Write a procedure named update_emp_commission using IF statements, to change commission
--percentage as follows for employee with ID = 152. If salary is more than 10000 then commission is
--40%, if Salary is less than 10000 but experience is more than 10 years then 35%, if salary is less than
--3000 then commission is 25%. In the remaining cases commission is 15%. 
