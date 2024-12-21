-- Dated: 14th November 2024

-- Q22: 22. Refer to Lab08,
-- Create a package named emp_manager to group together the following procedures:
-- - Update_emp_commision (lab08, Q12)
-- - Delete_employee (lab08,Q13)
-- Run the update_emp_commission procedure through the package. 

--PACKAGES
-- Package Specification
CREATE OR REPLACE PACKAGE emp_manager AS
    PROCEDURE update_emp_commission (
        variable_emp_id employees.employee_id%TYPE
    );

    PROCEDURE delete_employee (
        variable_emp_id employees.employee_id%TYPE
    );

END emp_manager;
/

-- first we define the package and its methods. then we define its body

-- Package Body
CREATE OR REPLACE PACKAGE BODY emp_manager AS

    PROCEDURE update_emp_commission (
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

    PROCEDURE delete_employee (
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

END emp_manager;
/
-- Execution Block
SET SERVEROUTPUT ON;

BEGIN
    emp_manager.update_emp_commission(152);
    emp_manager.delete_employee(123);
END;
/

-- Q23: 23. Find department names whose total salary is greater than the 
-- average organization salary. Note that the average organization salary is 
-- the average of all department totals

WITH department_totals AS (
    SELECT
        e.department_id,
        SUM(e.salary) AS total_salary
    FROM
        employees e
    GROUP BY
        e.department_id
), average_salary AS (
    SELECT
        AVG(total_salary) AS average_salary
    FROM
        department_totals
)
SELECT
    d.department_name,
    dt.total_salary,
    avg.average_salary
FROM
         departments d
    JOIN department_totals dt ON d.department_id = dt.department_id,
    average_salary    avg
WHERE
    dt.total_salary > avg.average_salary;


-- 24. Find the employee who has the highest salary amongst all employees. 
WITH max_salary AS (
    SELECT
        MAX(salary) AS highest_salary
    FROM
        employees
)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary
FROM
         employees e
    JOIN max_salary ms ON e.salary = ms.highest_salary;


--1. TrainList table: This table consists of details about all the available 
-- trains. The information stored in this table includes train number, train 
-- name, source, destination, fare for AC ticket, fare for general ticket, and 
-- weekdays on which train is available.
--Constraints: The train number is the primary key.

CREATE TABLE trainlist (
    train_number     INT PRIMARY KEY,
    train_name       VARCHAR(100) UNIQUE NOT NULL,
    source_area      VARCHAR(50) NOT NULL,
    destination_area VARCHAR(50) NOT NULL,
    ac_fare          NUMBER(10, 2) NOT NULL,
    general_fare     NUMBER(10, 2) NOT NULL,
    weekdays         VARCHAR(20) NOT NULL
);

-- 2. Train_Statustable: This table consists of details about the dates on which 
-- ticket can be booked for a train and the status of the availability of tickets. 
-- The information stored in this table includes train number, train date, total
-- number of AC seats, total number of general seats, number of AC seats booked, 
-- and number of general seats booked.
-- Constraints:
-- a. Train number should exist in TrainList table i.e. ensure referential integrity.
-- b. Train number and train date forms the composite primary key.

CREATE TABLE train_status (
    train_number         INT,
    train_date           DATE,
    total_ac_seats       INT DEFAULT 10,
    total_general_seats  INT DEFAULT 10,
    ac_seats_booked      INT DEFAULT 0,
    general_seats_booked INT DEFAULT 0,
    PRIMARY KEY ( train_number,
                  train_date ),
    FOREIGN KEY ( train_number )
        REFERENCES trainlist ( train_number )
);

--3. Passengertable: This table consists of details about the booked tickets. The 
--information stored in this table includes ticket ID, train number, date for 
--which ticket is booked, name, age, sex and address of the passenger, status of 
--reservation (either confirmed or waiting), and category for which ticket is 
--booked (AC or General).
--Constraints:
--a. Ticket ID is the primary key
--b. Train number should exist in TrainList table

CREATE TABLE passenger (
    ticket_id          INT PRIMARY KEY,
    train_number       INT NOT NULL,
    train_date         DATE NOT NULL,
    passenger_name     VARCHAR(100) NOT NULL,
    age                INT NOT NULL,
    sex                CHAR(1) NOT NULL,
    address            VARCHAR(255) NOT NULL,
    reservation_status VARCHAR(10) NOT NULL,
    train_category     VARCHAR(10) NOT NULL,
    FOREIGN KEY ( train_number )
        REFERENCES trainlist ( train_number )
);

--4. Triggers: Create triggers for trainList and Passenger tables that would 
-- automatically increment the primary key.
--a. The train number begins with 500, 510, 520, 530 and so on

CREATE OR REPLACE TRIGGER trainnumber_autoincrement
-- this trigger will run each time something is inserted in trainList
 BEFORE
    INSERT ON trainlist
    FOR EACH ROW
DECLARE
    starting_train_number INT := 490;
    next_train_number     INT;
BEGIN
    -- Determine the next train number
    SELECT
        nvl(MAX(train_number),
            starting_train_number) + 10
    INTO next_train_number
    FROM
        trainlist;

    -- Assign the next train number to the new row
    :new.train_number := next_train_number;
END;
--testing

INSERT INTO trainlist (
    train_name,
    source_area,
    destination_area,
    ac_fare,
    general_fare,
    weekdays
) VALUES (
    'zuha',
    'pindi',
    'lahore',
    12,
    23,
    'MWF'
);

SELECT
    *
FROM
    trainlist;

INSERT INTO trainlist (
    train_name,
    source_area,
    destination_area,
    ac_fare,
    general_fare,
    weekdays
) VALUES (
    'AQIB',
    'KARACHI',
    'lahore',
    12,
    23,
    'MWF'
);

SELECT
    *
FROM
    trainlist;

-- b. The ticket ID starts with 10001 and is incremented by 1.

CREATE OR REPLACE TRIGGER ticketid_autoincrement
-- this trigger will run each time something is inserted in trainList
 BEFORE
    INSERT ON passenger
    FOR EACH ROW
DECLARE
    starting_train_number INT := 10001;
    next_train_number     INT;
BEGIN
    -- Determine the next train number
    SELECT
        nvl(MAX(ticket_id),
            starting_train_number) + 1
    INTO next_train_number
    FROM
        passenger;

    -- Assign the next train number to the new row
    :new.ticket_id := next_train_number;
END;

--5. Booking Procedure: In this procedure, the train number, train date, and 
--category is provided by the passenger. Based on the input, the corresponding 
--record is retrieved from the Train_Status table. If the desired category is 
--AC, then total number of AC seats and number of booked AC seats are compared 
--to find whether ticket can be booked or not. Similarly, it can be checked 
--for the general category. If a ticket can be booked, then passenger details 
--are read and stored in the Passenger table and consequently the booked seat 
--counts are modified. If the train is fully booked, 2 tickets can gain a 
--waiting status. Your procedure should check for the waiting seat count for the
--particular train number, train date and category. If it is less than 2, then 
--the ticket may get a waiting status. If booking or waiting status is not 
--possible, a suitable message is printed.

SET SERVEROUTPUT ON;
--CREATE OR REPLACE PROCEDURE booking_customer AS (
--var_train_num Train_Status.Train_number%TYPE,
--var_train_date Train_Status.train_date%TYPE,
--var_train_category varchar2(255)
--)
--IS
----define variables here
--BEGIN 
--    BEGIN
--        -- 
--    EXCEPTION
--        WHEN no_data_found THEN
--            -- this means the train does not exist
--            dbms_output.put_line('The train ' || var_train_num || ' does not exist. ');
--            RETURN;
--    END;
--
--END;

CREATE OR REPLACE PROCEDURE book_ticket (
    p_train_number IN NUMBER,
    p_train_date IN DATE,
    p_category IN VARCHAR2,
    p_passenger_name IN VARCHAR2,
    p_age IN NUMBER,
    p_sex IN CHAR,
    p_address IN VARCHAR2
) AS
    v_total_seats NUMBER;
    v_booked_seats NUMBER;
    v_waiting_count NUMBER;
    v_status VARCHAR2(10);
    v_ticket_id NUMBER;
BEGIN
    -- Fetch seat availability for the given category
    IF p_category = 'AC' THEN
        SELECT total_ac_seats, ac_seats_booked
        INTO v_total_seats, v_booked_seats
        FROM train_status
        WHERE train_number = p_train_number AND train_date = p_train_date;
    ELSIF p_category = 'General' THEN
        SELECT total_general_seats, general_seats_booked
        INTO v_total_seats, v_booked_seats
        FROM train_status
        WHERE train_number = p_train_number AND train_date = p_train_date;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid category. Use "AC" or "General".');
    END IF;
    
    SELECT count(*) into v_waiting_count
    from passenger
    where reservation_status='Waiting' AND train_number=p_train_number AND train_date = p_train_date;

    -- Determine booking status
    IF v_booked_seats < v_total_seats THEN
        -- Confirmed booking
        v_status := 'Confirmed';
        v_booked_seats := v_booked_seats + 1;
        IF p_category = 'AC' THEN
            UPDATE train_status
            SET ac_seats_booked = v_booked_seats
            WHERE train_number = p_train_number AND train_date = p_train_date;
        ELSE
            UPDATE train_status
            SET general_seats_booked = v_booked_seats
            WHERE train_number = p_train_number AND train_date = p_train_date;
        END IF;
    ELSIF v_waiting_count < 2 THEN
        -- Waiting list
        v_status := 'Waiting';
    ELSE
        -- Booking not possible
        DBMS_OUTPUT.PUT_LINE('No seats available. Booking failed.');
    END IF;

    -- Insert passenger details
    INSERT INTO passenger (train_number, train_date, passenger_name, age, sex, address, reservation_status, train_category)
    VALUES (p_train_number, p_train_date, p_passenger_name, p_age, p_sex, p_address, v_status, p_category);

    -- Output success message
    DBMS_OUTPUT.PUT_LINE('Ticket booked successfully with Ticket ID: ' || v_ticket_id || ' and Status: ' || v_status);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid train number or train date.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Example Train_Status Table
INSERT INTO train_status (train_number, train_date, total_ac_seats, 
total_general_seats, ac_seats_booked, general_seats_booked)
VALUES (500, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 10, 10, 0, 0);

select * from train_status;
select * from passenger;

BEGIN
    book_ticket(500, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'AC', 'John Doe', 30, 'M', '123 Main Street');
END;
/

BEGIN
    book_ticket(500, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'General', 'Jane Smith', 28, 'F', '456 Elm Street');
END;
/

-- Q6
CREATE OR REPLACE PROCEDURE cancel_ticket (
    p_ticket_id IN NUMBER
) AS
    v_train_number NUMBER;
    v_train_date   DATE;
    v_category     VARCHAR2(20);
BEGIN
    -- Retrieve details of the ticket being canceled
    SELECT
        train_number,
        train_date,
        train_category
    INTO
        v_train_number,
        v_train_date,
        v_category
    FROM
        passenger
    WHERE
        ticket_id = p_ticket_id;

    -- Delete the record from the Passenger table
    DELETE FROM passenger
    WHERE
        ticket_id = p_ticket_id;

    -- Update the first waiting passenger for the same train and category to Confirmed
UPDATE passenger
    SET reservation_status = 'Confirmed'
    WHERE ticket_id = (
        SELECT ticket_id
        FROM (
            SELECT ticket_id
            FROM passenger
            WHERE
                    train_number = v_train_number
                AND train_date = v_train_date
                AND train_category = v_category
                AND reservation_status = 'Waiting'
            ORDER BY ticket_id
        )
        WHERE ROWNUM = 1
    );

    -- Update the booked or waiting seat counts in the Train_Status table
    IF v_category = 'AC' THEN
        UPDATE train_status
        SET
            ac_seats_booked = ac_seats_booked - 1
        WHERE
                train_number = v_train_number
            AND train_date = v_train_date;

    ELSE
        UPDATE train_status
        SET
            general_seats_booked = general_seats_booked - 1
        WHERE
                train_number = v_train_number
            AND train_date = v_train_date;

    END IF;

    dbms_output.put_line('Ticket cancellation successful for Ticket ID: ' || p_ticket_id);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Error: Ticket ID '
                             || p_ticket_id
                             || ' does not exist.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || sqlerrm);
END;
/

DESCRIBE PASSENGER;

SELECT * FROM PASSENGER;

BEGIN
    cancel_ticket(10002); 
END;
/

SELECT * FROM PASSENGER;
SELECT * FROM TRAIN_STATUS;