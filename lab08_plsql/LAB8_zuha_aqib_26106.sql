-- Date: 24th October 2024

-- Q1: 1. Write a PL/SQL code to print multiples of 2 (e.g 2,4,6…12) using for 
-- loop.
Set serveroutput ON;

BEGIN
    FOR i IN 1..6 LOOP
        dbms_output.put_line(i * 2);
    END LOOP;
END;

-- Q2: 2. Write a PL/SQL code to print 20 to 10 in decreasing order 
-- (e.g 20,19,18…10).
--Set serveroutput ON;
BEGIN
    FOR i IN REVERSE 10..20 LOOP
        dbms_output.put_line(i);
    END LOOP;
END;

-- Q3. 3. Write a PL/SQL program to check if a user entered number is a 
-- multiple of 2 then output ‘Even’ else ‘Odd’. Hint: Lookup MOD function.
DECLARE
    numberinput INT := &numberinput;
    divisor     INT := 2;
BEGIN
    IF MOD(numberinput, divisor) = 0 THEN
        dbms_output.put_line('Even');
    ELSE
        dbms_output.put_line('Odd');
    END IF;
END;

-- Q4. 4. Write a PL/SQL program using a while loop which takes input from the 
-- user and returns the multiplication table.
DECLARE
    divisor       INT := &divisor;
    stopcondition INT := &stopcondition;
    i             INT := 1;
BEGIN
    WHILE i <= stopcondition LOOP
        dbms_output.put_line(i
                             || ' x '
                             || divisor
                             || ' = '
                             ||(i * divisor));

        i := i + 1;
    END LOOP;
END;

-- Q5: 5. Write a program to print the first_name of employee with ID = 100. 
-- Your output should be in the format “The first name of the employee with 
-- ID=100 is (name)”
-- change connection to hr_schema
Set serveroutput ON;

DECLARE
    variable_first_name VARCHAR2(255);
BEGIN
    -- get the first name of that employee
    SELECT
        first_name
    INTO variable_first_name
    FROM
        employees
    WHERE
        employee_id = 100;
        
    -- display it
    dbms_output.put_line('The first name of the employee with ID=100 is ' 
    || variable_first_name);
END;

-- Q6: 6. Write a procedure named get_email which takes empID as input
-- parameter and prints the email in a suitable format. Example: “EmpID 101: 
-- [emailaddress]”. Execute the procedure to test. 
Set serveroutput ON;

CREATE OR REPLACE PROCEDURE get_email (
    variable_id IN INT
) IS
    variable_email VARCHAR2(255);
BEGIN
    -- get the email of the emp_id passed as a parameter
    SELECT
        email
    INTO variable_email
    FROM
        employees
    WHERE
        employee_id = variable_id;
        
    -- display the email extracted
    dbms_output.put_line('EmpID '
                         || variable_id
                         || ': '
                         || variable_email);
END;
    
-- call the function/procedure we just made
exec get_email(100);

-- Q7: 7. Write a procedure named get_emp_city which takes empID as input 
-- paramter and prints the city where the employee is working. If there is no 
--data for empID, then print a suitable error. Execute the procedure to test. 
-- Try out an employee ID which does not exist.
CREATE OR REPLACE PROCEDURE get_emp_city (
    variable_id IN INT
) IS
    variable_city locations.city%TYPE;
BEGIN
    BEGIN
        SELECT
            city
        INTO variable_city
        FROM
                 employees
            INNER JOIN departments ON employees.department_id 
            = departments.department_id
            INNER JOIN locations ON departments.location_id 
            = locations.location_id
        WHERE
            variable_id = employees.employee_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee_ID '
                                 || variable_id
                                 || ' does not exist to find its location. ');
            RETURN;
    END;

    dbms_output.put_line('EmpID '
                         || variable_id
                         || ': '
                         || variable_city);
END get_emp_city;

exec get_emp_city(1);

-- Q8: 8. Write a procedure using cursors to print Job Title and Name of the
-- Employee working in the IT department using open-fetch-close.
Set serveroutput ON;

CREATE OR REPLACE PROCEDURE get_job_title_employee_name (
    variable_job_title jobs.job_title%TYPE
) IS
    -- make cursor as we are dealing with multiple employees (multivalue)
    CURSOR emp_job_title_finder IS
    
    -- get the name and job title of each employee from that department
    SELECT
        first_name,
        last_name,
        jobs.job_title
    FROM
             employees
        JOIN departments ON employees.department_id = departments.department_id
        JOIN jobs ON jobs.job_id = employees.job_id
    WHERE
        departments.department_name = variable_job_title;

    v_firstname employees.first_name%TYPE;
    v_lastname  employees.last_name%TYPE;
    v_job_title jobs.job_title%TYPE;
BEGIN
    -- start that cursor
    OPEN emp_job_title_finder;
    
    -- for every value in that cursor, fetch its value and display it
    LOOP
        FETCH emp_job_title_finder INTO
            v_firstname,
            v_lastname,
            v_job_title;
        EXIT WHEN emp_job_title_finder%notfound;
        dbms_output.put_line(v_firstname
                             || ' '
                             || v_lastname
                             || ': '
                             || v_job_title);

    END LOOP;

    CLOSE emp_job_title_finder;
END get_job_title_employee_name;

-- run the procedure we just created
BEGIN
    get_job_title_employee_name('IT');
END;

-- Date: 28th October 2024

-- q9: 9. Write a procedure named get_job_history using cursorsto print 
-- employeeName, Job_id, start_date for all employees in department ID =50 
-- using cursors and for loop.
CREATE OR REPLACE PROCEDURE get_job_history (
    variable_department_id departments.department_id%TYPE
) IS
    -- start a cursor as dealing with multi valued variables
    CURSOR get_job_information IS
    
    -- get the name, job_id, start_date, dpt_id of each employee
    SELECT
        concat(first_name,
               concat(' ', last_name)) AS employeename,
        employees.job_id,
        start_date,
        employees.department_id
    FROM
             employees
        JOIN departments ON employees.department_id = departments.department_id
        JOIN job_history ON job_history.job_id = employees.job_id
    WHERE
        employees.department_id = variable_department_id;

    -- define variables to display each value
    v_employee_name employees.first_name%TYPE;
    v_job_id        employees.job_id%TYPE;
    v_start_date    job_history.start_date%TYPE;
    v_department_id employees.department_id%TYPE;
BEGIN
    -- start the cursor
    OPEN get_job_information;
    
    -- for every value in the cursor, display the information of each emp
    LOOP
        FETCH get_job_information INTO
            v_employee_name,
            v_job_id,
            v_start_date,
            v_department_id;
        EXIT WHEN get_job_information%notfound;
        dbms_output.put_line(v_job_id
                             || ', '
                             || v_employee_name
                             || ': department='
                             || v_department_id
                             || ' since '
                             || v_start_date);

    END LOOP;

    -- close the cursor
    CLOSE get_job_information;
END get_job_history;

-- run the procedure we just made
EXEC get_job_history(50);

-- q10: 10. Write a program to interchange the salaries of employee 120 and 122
CREATE OR REPLACE PROCEDURE interchange_salaries (
    employee_id_1 employees.employee_id%TYPE,
    employee_id_2 employees.employee_id%TYPE
) IS
    
    -- get two employee ids from parameters, define salary variables for each
    salary_1 employees.salary%TYPE;
    salary_2 employees.salary%TYPE;
BEGIN
    -- get the salary of the first employee in an exception block as what if 
    -- the employee doesnt exist? we want it to end gracefully
    BEGIN
        SELECT
            salary
        INTO salary_1
        FROM
            employees
        WHERE
            employee_id = employee_id_1;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee ID '
                                 || employee_id_1
                                 || ' not found');
            RETURN;
    END;

    -- get the salary of the second employee in an exception block
    BEGIN
        SELECT
            salary
        INTO salary_2
        FROM
            employees
        WHERE
            employee_id = employee_id_2;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee ID '
                                 || employee_id_2
                                 || ' not found');
            RETURN;
    END;

    -- display the salaries retrieved
    dbms_output.put_line('original salaries');
    dbms_output.put_line(employee_id_1
                         || ': $'
                         || salary_1);
    dbms_output.put_line(employee_id_2
                         || ': $'
                         || salary_2);
    
    -- update employee1's salary to employee2's salary
    UPDATE employees
    SET
        salary = salary_2
    WHERE
        employee_id = employee_id_1;

    -- update employee2's salary to employee1's salary
    UPDATE employees
    SET
        salary = salary_1
    WHERE
        employee_id = employee_id_2;

    -- retrieve the first employees salary
    SELECT
        salary
    INTO salary_1
    FROM
        employees
    WHERE
        employee_id = employee_id_1;

    -- retreive the second employees salary
    SELECT
        salary
    INTO salary_2
    FROM
        employees
    WHERE
        employee_id = employee_id_2;

    -- display the new salaries of both
    dbms_output.put_line('after swap salaries');
    dbms_output.put_line(employee_id_1
                         || ': $'
                         || salary_1);
    dbms_output.put_line(employee_id_2
                         || ': $'
                         || salary_2);
END interchange_salaries;

-- run the procedure we just made
exec interchange_Salaries(120, 122);

-- Q11: 11. Write a program to increase the salary of employee id 115 based on 
-- the following conditions using case expression:
-- Experience    Increase salary by
-- > 10 years       20%
-- > 5 years        10%
-- Otherwise        5%
-- Use the rowcount attribute to print the number of rows modified.
-- Test your program by executing it.
CREATE OR REPLACE PROCEDURE increment_salary (
    variable_emp_id employees.employee_id%TYPE
) IS
    -- define variables to save start date, compute their years at the company
    variable_start_date job_history.start_date%TYPE;
    variable_years      NUMBER;
    variable_salary     employees.salary%TYPE;
BEGIN
    -- get their salary and save it. make sure to do exception handling.
    BEGIN
        SELECT
            salary
        INTO variable_salary
        FROM
            employees
        WHERE
            employee_id = variable_emp_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee ID '
                                 || variable_emp_id
                                 || ' is not found
    to increment the salary. ');
            RETURN;
    END;

    -- display the old salary before incrmenetation
    dbms_output.put_line(variable_emp_id
                         || ': Old Salary $'
                         || variable_salary);
    
    -- get the date when the employee FIRST STARTED at the company, as there 
    -- could be multiple start dates
    SELECT
        MIN(start_date)
    INTO variable_start_date
    FROM
             employees
        JOIN job_history ON employees.employee_id = job_history.employee_id;

    -- compute the number of years of the employee
    variable_years := months_between(sysdate, variable_start_date) / 12;
    
    -- display how many years they have worked
    dbms_output.put_line('Years Worked = ' || variable_years);
    
    -- update the salary depending on the number of years they have worked
    UPDATE employees
    SET
        salary =
            CASE
                WHEN variable_years > 10 THEN
                    salary + ( 20 / 100 ) * salary
                WHEN variable_years > 5  THEN
                    salary + ( 20 / 100 ) * salary
                ELSE
                    salary + ( 5 / 100 ) * salary
            END
    WHERE
        employee_id = variable_emp_id;

    -- display how many rows were updated
    dbms_output.put_line('Number of rows modified: ' || SQL%rowcount);
    
    -- retreive the new salary from the database
    SELECT
        salary
    INTO variable_salary
    FROM
        employees
    WHERE
        employee_id = variable_emp_id;

    -- display the new incremented salary
    dbms_output.put_line(variable_emp_id
                         || ': New Salary $'
                         || variable_salary);
END increment_salary;

-- run this function
exec increment_salary(115);

-- Q12: 12. Write a procedure named update_emp_commission using IF statements, 
-- to change commission percentage as follows for employee with ID = 152. 
-- If salary is more than 10000 then commission is 40%, if Salary is less than 
-- 10000 but experience is more than 10 years then 35%, if salary is less than
-- 3000 then commission is 25%. In the remaining cases commission is 15%.
CREATE OR REPLACE PROCEDURE update_emp_commission (
    variable_emp_id employees.employee_id%TYPE
) IS
    -- define variables to save start date, compute their years, get their 
    -- salary and commision at the company
    variable_start_date job_history.start_date%TYPE;
    variable_years      NUMBER;
    variable_salary     employees.salary%TYPE;
    variable_commission employees.commission_pct%TYPE;
BEGIN
    -- get their salary anf commisiomn and save it in variables. make sure to 
    -- do exception handling.
    BEGIN
        SELECT
            salary,
            commission_pct
        INTO
            variable_salary,
            variable_commission
        FROM
            employees
        WHERE
            employee_id = variable_emp_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee ID '
                                 || variable_emp_id
                                 || ' is not found
    to increment the commission. ');
            RETURN;
    END;

    -- display the old commission before incrmenetation
    dbms_output.put_line(variable_emp_id
                         || ': Old Commission $'
                         || variable_commission);
    
    -- get the date when the employee FIRST STARTED at the company, as there 
    -- could be multiple start dates
    SELECT
        MIN(start_date)
    INTO variable_start_date
    FROM
             employees
        JOIN job_history ON employees.employee_id = job_history.employee_id;

    -- compute the number of years of the employee
    variable_years := months_between(sysdate, variable_start_date) / 12;
    
    -- display how many years they have worked
    dbms_output.put_line('Years Worked = ' || variable_years);
    
    -- display how much salary they have
    dbms_output.put_line('Salary = ' || variable_salary);
    
    -- Update the commission based on salary and years of experience using 
    -- IF statements
    IF variable_salary > 10000 THEN
        variable_commission := 0.4;
    ELSIF
        variable_salary < 10000
        AND variable_years > 10
    THEN
        variable_commission := 0.35;
    ELSIF variable_salary < 3000 THEN
        variable_commission := 0.25;
    ELSE
        variable_commission := 0.15;
    END IF;

    -- Apply the updated commission to the database
    UPDATE employees
    SET
        commission_pct = variable_commission
    WHERE
        employee_id = variable_emp_id;

    -- display how many rows were updated
    dbms_output.put_line('Number of rows modified: ' || SQL%rowcount);
    
    -- retreive the new commission_pct from the database
    SELECT
        commission_pct
    INTO variable_commission
    FROM
        employees
    WHERE
        employee_id = variable_emp_id;

    -- display the new commission
    dbms_output.put_line(variable_emp_id
                         || ': New Commission $'
                         || variable_commission);
END update_emp_commission;

-- call the procedure
EXEC update_emp_commission(152);

-- Q13: 13. Create a procedure named delete_employee to perform the delete 
-- operation for any employee id taken as an input to the procedure. The 
-- employees or departments the employee was managing will now be managed by 
-- their manager. Remember to modify all the referenced tables before deleting 
-- from the employees table. Finally, test out your procedure. 
CREATE OR REPLACE PROCEDURE delete_employee (
    variable_emp_id employees.employee_id%TYPE
) IS
-- three tables will be modified, departments in case of manager, job_history
-- and employees table. first get and save its manager
    variable_manager_id employees.manager_id%TYPE;
BEGIN
    -- get the manager of the employee used to work for
    BEGIN
        SELECT
            manager_id
        INTO variable_manager_id
        FROM
            employees
        WHERE
            employee_id = variable_emp_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('ERROR: Employee ID '
                                 || variable_emp_id
                                 || ' is not found ');
            RETURN;
    END;

    -- change all the employees underneath this employee to the manager
    UPDATE employees
    SET
        manager_id = variable_manager_id
    WHERE
        manager_id = variable_emp_id;
    
    -- change the department the employee was managing to be now managed by 
    -- their manager
    UPDATE departments
    SET
        manager_id = variable_manager_id
    WHERE
        manager_id = variable_emp_id;
    
    -- now delete the employee from job_history
    DELETE FROM job_history
    WHERE
        employee_id = variable_emp_id;
    
    -- now delete from employees table
    DELETE FROM employees
    WHERE
        employee_id = variable_emp_id;
    
    -- now display if it has been deleted or not
    IF SQL%rowcount > 0 THEN
        dbms_output.put_line('Employee ID '
                             || variable_emp_id
                             || ' has been deleted.');
    ELSE
        dbms_output.put_line('No employee was deleted.');
    END IF;

END delete_employee;

INSERT INTO employees (employee_id, first_name, last_name, email, 
phone_number, hire_date, job_id, salary, commission_pct, manager_id, 
department_id)  VALUES (
    123,
    'zuha',
    'aqib',
    'email',
    '030',
    sysdate,
    'MK_REP',
    123,
    0, 
    200,
    10
);

exec delete_employee(123);

select * from departments;