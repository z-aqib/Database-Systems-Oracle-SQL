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

-- Q3. 3. Write a PL/SQL program to check if a user entered number is a multiple 
-- of 2 then output ‘Even’ else ‘Odd’. Hint: Lookup MOD function.
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
    SELECT
        first_name
    INTO variable_first_name
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line('The first name of the employee with ID=100 is ' 
    || variable_first_name);
END;

-- Q6: 6. Write a procedure named get_email which takes empID as input parameter 
-- and prints the email in a suitable format. Example: “EmpID 101: [emailaddress]”
-- . Execute the procedure to test. 
Set serveroutput ON;

CREATE OR REPLACE PROCEDURE get_email (
    variable_id IN INT
) IS
    variable_email VARCHAR2(255);
BEGIN
    SELECT
        email
    INTO variable_email
    FROM
        employees
    WHERE
        employee_id = variable_id;

    dbms_output.put_line('EmpID '
                         || variable_id
                         || ': '
                         || variable_email);
END;
    
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
    SELECT
        city
    INTO variable_city
    FROM
             employees
        INNER JOIN departments ON employees.department_id = departments.department_id
        INNER JOIN locations ON departments.location_id = locations.location_id
    WHERE
        variable_id = employees.employee_id;

    dbms_output.put_line('EmpID '
                         || variable_id
                         || ': '
                         || variable_city);
END;

exec get_emp_city(100);

-- Q8: 8. Write a procedure using cursors to print Job Title and Name of the
-- Employee working in the IT department using open-fetch-close.
CREATE OR REPLACE PROCEDURE print_IT_dept_emp IS
   CURSOR cur_IT_dept IS
      SELECT e.first_name || ' ' || e.last_name AS employee_name, j.job_title
      FROM employees e
      JOIN jobs j ON e.job_id = j.job_id
      JOIN departments d ON e.department_id = d.department_id
      WHERE d.department_name = 'IT';
   v_employee_name employees.first_name%TYPE;
   v_job_title jobs.job_title%TYPE;
   
BEGIN
   OPEN cur_IT_dept;
   
   LOOP

      FETCH cur_IT_dept INTO v_employee_name, v_job_title;
  
      EXIT WHEN cur_IT_dept%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_job_title || ', Employee Name: ' || v_employee_name);
   END LOOP;

   CLOSE cur_IT_dept;
END print_IT_dept_emp;

BEGIN
   print_IT_dept_emp;
END;