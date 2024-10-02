-- Date: 26th September 2024

-- Q1: 1. Find the full name and salary of the employees having higher salary as 
-- compared to the employee whose name is Alexis Bull. Use WITH clause to 
-- temporarily name the query that retrieves salary of Alexis Bull as Alexis_Salary.
WITH alexis_salary AS (
    SELECT
        salary
    FROM
        employees
    WHERE
        concat(first_name,
               concat(' ', last_name)) = 'Alexis Bull'
)
SELECT
    (
        SELECT
            *
        FROM
            alexis_salary
    )                              AS alexis_salary,
    concat(first_name,
           concat(' ', last_name)) AS employee_name,
    salary,
    salary - (
        SELECT
            *
        FROM
            alexis_salary
    )                              AS difference
FROM
    employees
WHERE
    salary > (
        SELECT
            *
        FROM
            alexis_salary
    )
ORDER BY
    salary ASC,
    first_name ASC;
/* 63 employees */
    
-- Q2: 2. Find all information of all employees who work in the IT department.
SELECT
    *
FROM
    (
        SELECT
            department_name AS dep_name,
            e.*
        FROM
                 employees e
            JOIN departments d ON e.department_id = d.department_id
    )
WHERE
    dep_name = 'IT'
ORDER BY
    first_name ASC,
    last_name ASC;
/* 5 employees are of IT department */   

-- without join
SELECT
    *
FROM
    employees
WHERE
    department_id = (
        SELECT
            department_id
        FROM
            departments
        WHERE
            department_name = 'IT'
    )
ORDER BY
    first_name ASC,
    last_name ASC;
/* 5 employees */

-- Q3: 3. Find the full name of the employees who have a manager and worked in 
-- a department based in US. Hint: nested subqueries, use of IN
SELECT
    concat(first_name,
           concat(' ', last_name)) AS full_name
FROM
    employees
WHERE
    manager_id IS NOT NULL
    AND department_id IN (
        SELECT
            department_id
        FROM
            departments
        WHERE
            location_id IN (
                SELECT
                    location_id
                FROM
                    locations
                WHERE
                    country_id = 'US'
            )
    )
ORDER BY
    first_name ASC,
    last_name ASC;
/* 67 employees */

-- Q4: 4. Retrieve all information of employees whose salary is greater than the 
-- average salary.
SELECT
    (
        SELECT
            round(AVG(salary),
                  2)
        FROM
            employees
    )        average_salary,
    round(salary -(
        SELECT
            AVG(salary)
        FROM
            employees
    ),
          0) AS difference,
    employees.*
FROM
    employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
    )
ORDER BY
    salary ASC,
    first_name ASC,
    last_name ASC;
/* 51 employees */

-- Q5: 5. Output the first_name, last_name and salary of the employees who earn 
-- a salary that is higher than the salary of all the Sales Representatives 
-- (JOB_ID = 'SA_REP'). Sort the results in ascending order of salary.
SELECT
    (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            job_id = 'SA_REP'
    ) AS max_salary,
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary > ALL (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            job_id = 'SA_REP'
    )
ORDER BY
    salary ASC,
    first_name ASC,
    last_name ASC;
/* 9 employees */

-- Q6: 6. Output all information of the employees who are managers.
-- Hint: check for existence of records where manager_id is the same as 
-- employee_id in the outer query
SELECT
    *
FROM
    employees e1
WHERE
    EXISTS (
        SELECT
            1
        FROM
            employees e2
        WHERE
            manager_id IS NOT NULL
            AND e2.manager_id = e1.employee_id
    )
ORDER BY
    first_name ASC,
    last_name ASC;
/* 18 employees */

-- Q7: 7. Write a query to display the employee ID, first name, last name, salary 
-- of all employees whose salary is above average for their departments.
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM
    employees e
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
        WHERE
            department_id = e.department_id
    )
ORDER BY
    salary ASC,
    first_name ASC,
    last_name ASC;
/* 38 rows */

-- Q8: 8. Write a query to list the department ID and name of all the departments 
-- where no employee is working. Hint: not exists
SELECT
    department_id,
    department_name
FROM
    departments d
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            employees
        WHERE
            department_id = d.department_id
    )
ORDER BY
    department_id ASC,
    department_name ASC;
/* 16 departments */

-- Q9: 9. Create a View named JonathonTaylor_JobHistory to summarize the job_history 
-- for Jonathon Taylor. Output start_date, End_date, Job_title, Department name 
-- and order the results by end date with the recent most date at the top. (You 
-- may use joins.)
CREATE VIEW jonathontaylor_jobhistory AS
    SELECT
        jh.start_date,
        jh.end_date,
        j.job_title,
        d.department_name
    FROM
             job_history jh
        INNER JOIN departments d ON jh.department_id = d.department_id
        INNER JOIN employees   e ON e.employee_id = jh.employee_id
        INNER JOIN jobs        j ON j.job_id = e.job_id
    WHERE
            e.first_name = 'Jonathon'
        AND e.last_name = 'Taylor';
/* created successfully */

SELECT
    *
FROM
    jonathontaylor_jobhistory;
/* 2 entries displayed */

-- Q10: 10. Find all employee ids that do not have a job history. 
SELECT
    employee_id
FROM
    employees
MINUS
SELECT
    employee_id
FROM
    job_history;
/* 100 employees */

-- Q11: 11. Ouput a single list of full names of employees followed by names of 
-- departments.
SELECT
    concat(first_name,
           concat(' ', last_name)) AS full_name
FROM
    employees
UNION
SELECT
    department_name
FROM
    departments;
/* 134 rows */

-- Q12: 12. Find list of employees who are managers of a department and also 
-- have some employees working under them. Output the full name.
SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    employee_id IN (
        SELECT
            manager_id
        FROM
            departments
        WHERE
            manager_id IS NOT NULL
    )
INTERSECT
SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    employee_id IN (
        SELECT
            manager_id
        FROM
            employees
        WHERE
            manager_id IS NOT NULL
    )
ORDER BY
    first_name ASC,
    last_name ASC;
/* 8 rows */

-- Q13: 13. Retrieve the average salary (rounded to 2 decimal places) for each 
-- department name. Use the case clause to add a new column that shows the salary 
-- categories for each department. Greater than 10,000 classify as High, between 
-- 5000-10000 as Medium, and less than 5000 as Low. This new column should be 
-- called salary_category.
SELECT ROUND(AVG(SALARY), 2) AS average_salary, DEPARTMENT_ID, DEPARTMENTS.DEPARTMENT_NAME,
CASE WHEN AVG(SALARY) > 10000 THEN 'HIGH'
WHEN AVG(SALARY) > 5000 THEN 'MEDIUM'
WHEN AVG(SALARY)  <= 5000 THEN 'LOW'
END SALARY_CATEGORY
FROM EMPLOYEES INNER JOIN DEPARTMENTS USING (DEPARTMENT_ID)
GROUP BY DEPARTMENT_ID, DEPARTMENTS.DEPARTMENT_NAME
order by avg(salary) ASC, department_name ASC;
/* 11 departments */

-- Q14: 14. Modify employee information: (LiveSQL does not allow alteration of tables)
-- a. Update the record of Steven King in the employees table. Set the commission to 0.5
UPDATE EMPLOYEES
SET COMMISSION_PCT = 0.5
WHERE FIRST_NAME = 'Steven' AND last_name = 'King';
/* 1 row updated successfully */

SELECT * FROM EMPLOYEES;
/* updated successfully */

-- b. Assume Alexandar Hunold has been fired. The employees or departments he was
-- managing will now be managed by Alexandar’s manager. Update the records to reflect
-- this change.
UPDATE employees
SET
    manager_id = (
        SELECT
            manager_id
        FROM
            employees
        WHERE
                first_name = 'Alexander'
            AND last_name = 'Hunold'
    )
WHERE
    manager_id = (
        SELECT
            employee_id
        FROM
            employees
        WHERE
                first_name = 'Alexander'
            AND last_name = 'Hunold'
    );
/* 4 rows updated */

-- c. Delete Alexandar Hunold’s information from the system.
DELETE FROM EMPLOYEES
WHERE FIRST_NAME = 'Alexander' AND last_name = 'Hunold';

-- Q15: For this part, you may use any of the SQL methods studied so far i.e. 
-- subqueries, joins, group by, etc.
-- 15. The company intends to send out an appreciation email to all employees who have
-- served for more than 10 years. There is a special poster for each department that will be
-- designed by the marketing team and the email will be sent out from the department
-- manager’s email address. Write a query to retrieve the required information to
-- complete this task. Write clearly in comments justifying your choice of attributes to
-- project in the output
