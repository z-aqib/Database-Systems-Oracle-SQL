-- Date: 19th September 2024

-- Q1: 1. Find the first name, last name, department number, and department name 
-- for each employee.
-- a. Use cartesian product with WHERE clause
SELECT
    employee_id,
    first_name,
    last_name,
    employees.department_id   AS employee_dept_id,
    departments.department_id AS departments_dept_id,
    department_name
FROM
    employees,
    departments
WHERE
    employees.department_id = departments.department_id
ORDER BY
    department_name ASC,
    first_name ASC;
/* 106 employees */

-- b. Use JOIN with USING clause
SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    department_name
FROM
         employees
    JOIN departments USING ( department_id )
ORDER BY
    department_name ASC,
    first_name ASC;
/* 106 employees */

-- c. Use JOIN with ON clause
SELECT
    first_name,
    last_name,
    employees.department_id   AS employee_dpt_id,
    departments.department_id AS departments_dpt_id,
    department_name
FROM
         employees
    JOIN departments ON employees.department_id = departments.department_id
ORDER BY
    department_name ASC,
    first_name ASC;
/* 106 employees */

-- d. Use NATURAL JOIN clause
SELECT
    first_name,
    last_name,
    department_id,
    manager_id,
    department_name
FROM
         employees
    NATURAL JOIN departments
ORDER BY
    department_name ASC,
    first_name ASC;
/* 32 employees - it is different as natural join is happening for department_id 
and manager_id, this is showing those employees who whose department_id and manager_id
is same for that respective department. */

-- e. Is there a difference in the output of the 4 methods above?
/* yes, the first 3 are same as they do joining of employees table and department
table on the basis of department_id. but in the fourth one (d), it is a natural
join on the basis of both department_id AND manager_id therefore there are 106 
rows in the first 3 and 32 in the 4th */

-- f. What if the department ID was stored with different names in both tables, 
-- which of the methods will be more appropriate?
/* c will be more appropriate because its not natural (automatic) and we can specify 
on which attribute basis we would like to join */

-- Q2: 2. Find the first name, last name, department name, city, and state province 
-- for each employee.
SELECT
    first_name,
    last_name,
    employees.department_id   AS e_dpt_id,
    departments.department_id AS d_dpt_id,
    departments.location_id   AS d_loc_id,
    locations.location_id     AS l_loc_id,
    department_name,
    city,
    state_province
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
    INNER JOIN locations ON locations.location_id = departments.location_id
ORDER BY
    department_name ASC,
    first_name ASC;
/* 106 employees */

-- Q3: 3. Find the first name, last name, salary, and job title for all employees.
SELECT
    first_name,
    last_name,
    employees.job_id AS e_job_id,
    jobs.job_id      AS j_job_id,
    salary,
    job_title
FROM
         employees
    INNER JOIN jobs ON employees.job_id = jobs.job_id
ORDER BY
    job_title ASC,
    first_name ASC;
/* 107 employees */

-- Q4: 4. Output the full name, department number and department name of 
-- employees who work in Finance or Accounting department. 
SELECT
    concat(first_name,
           concat(' ', last_name)) AS full_name,
    employees.department_id        AS e_dpt_id,
    departments.department_id      AS d_dpt_id,
    department_name
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
WHERE
    department_name IN ( 'Finance', 'Accounting' )
ORDER BY
    department_name ASC,
    first_name ASC;
/* 8 employees are from either accounts or finance */

-- Q5: 5. Output the full name of employees with their department name, job ID 
-- and a new column with cityname, province as “Location”. Hint: recall string 
-- concatenation
SELECT
    concat(first_name,
           concat(' ', last_name))      AS full_name,
    department_name,
    employees.department_id             AS e_dpt_id,
    departments.department_id           AS d_dpt_id,
    departments.location_id             AS d_loc_id,
    locations.location_id               AS l_loc_id,
    concat(city,
           concat(' ', state_province)) AS location
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
    INNER JOIN locations ON locations.location_id = departments.location_id
ORDER BY
    department_name ASC,
    first_name ASC;
/* 106 employees */
    
-- Q6: 6. Repeat #5 but output all cities starting with letter S.
SELECT
    concat(first_name,
           concat(' ', last_name))      AS full_name,
    department_name,
    employees.department_id             AS e_dpt_id,
    departments.department_id           AS d_dpt_id,
    departments.location_id             AS d_loc_id,
    locations.location_id               AS l_loc_id,
    concat(city,
           concat(' ', state_province)) AS location
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
    INNER JOIN locations ON locations.location_id = departments.location_id
WHERE
    upper(city) LIKE 'S%'
ORDER BY
    city ASC,
    department_name ASC,
    first_name ASC;
/* 68 employees */

-- Q7: 7. Output all information of employees with the full name of their 
-- respective managers
SELECT
    concat(e2.first_name,
           concat(' ', e2.last_name)) AS manager_name,
    e1.*
FROM
    employees e1
    LEFT JOIN employees e2 ON e2.employee_id = e1.manager_id
ORDER BY
    e2.first_name ASC,
    e2.last_name ASC,
    e1.first_name ASC,
    e1.last_name ASC;
/* 107 employees */
    
-- Q8: 8. Find the department name, city, state province for all departments that 
-- end with “ing”
SELECT
    department_id,
    department_name,
    city,
    state_province,
    departments.location_id AS d_loc_id,
    locations.location_id   AS l_loc_id
FROM
         departments
    INNER JOIN locations ON departments.location_id = locations.location_id
WHERE
    lower(department_name) LIKE '%ing'
ORDER BY
    city ASC,
    department_name ASC,
    department_id ASC;
/* 7 departments */

-- Q9: 9. Find the full name of each employee with their department ID and 
-- department name. Your results should show the employees who do not have a 
-- department.
SELECT
    concat(first_name,
           concat(' ', last_name)) AS full_name,
    employees.department_id        AS e_dpt_id,
    departments.department_id      AS d_dpt_id,
    department_name
FROM
    employees
    LEFT JOIN departments ON employees.department_id = departments.department_id
WHERE
    employees.department_id IS NULL;
/* 1 kimberly */

-- Q10: 10. Display names of departments with no employee working in it.
SELECT
    department_name,
    employees.department_id   AS e_dpt_id,
    departments.department_id AS d_dpt_id
FROM
    employees
    RIGHT OUTER JOIN departments ON employees.department_id = departments.department_id
WHERE
    employees.department_id IS NULL
ORDER BY
    department_name ASC,
    departments.department_id ASC;
/* 16 departments */
    
-- Q11: 11. Output the first name and last name of employee and manager. Those 
-- employees who do not have a manager should also be part of your results. 
SELECT
    concat(e1.first_name,
           concat(' ', e1.last_name)) AS employee_full_name,
    concat(e2.first_name,
           concat(' ', e2.last_name)) AS manager_full_name
FROM
    employees e1
    LEFT JOIN employees e2 ON e2.employee_id = e1.manager_id
ORDER BY
    e2.first_name ASC,
    e2.last_name ASC,
    e1.first_name ASC,
    e1.last_name ASC;
/* 107 employees */

-- Q12: 12. Output all information of the employee who is the top manager along 
-- with the department name.
SELECT
    department_name,
    employees.*
FROM
    employees
    LEFT JOIN departments ON employees.department_id = departments.department_id
WHERE
    employees.manager_id IS NULL
ORDER BY
    department_name ASC,
    first_name ASC;
/* 1 steven king */

-- Q13: 13. Output the complete address information for each department. Output 
-- department name, street address, postal code, city, state_province, country name, 
-- region name.
SELECT
    department_id,
    department_name,
    departments.location_id AS d_loc_id,
    locations.location_id   AS l_loc_id,
    street_address,
    postal_code,
    city,
    state_province,
    locations.country_id    AS l_cou_id,
    countries.country_id    AS c_cou_id,
    country_name,
    countries.region_id     AS c_reg_id,
    regions.region_id       AS r_reg_id,
    region_name
FROM
         departments
    INNER JOIN locations ON departments.location_id = locations.location_id
    INNER JOIN countries ON countries.country_id = locations.country_id
    INNER JOIN regions ON regions.region_id = countries.region_id
ORDER BY
    region_name ASC,
    country_name ASC,
    department_name ASC,
    department_id ASC;
/* 27 departments */
    
-- Q14: 14. Display full names of employees who are earning more than their own 
-- managers
SELECT
    concat(e1.first_name,
           concat(' ', e1.last_name)) AS employee_full_name,
    e1.salary                         AS employee_salary,
    concat(e2.first_name,
           concat(' ', e2.last_name)) AS manager_full_name,
    e2.salary                         AS manager_salary
FROM
         employees e1
    INNER JOIN employees e2 ON e2.employee_id = e1.manager_id
WHERE
    e1.salary > e2.salary
ORDER BY
    e1.first_name ASC,
    e1.last_name ASC;
/* 2 employees - ellen and lisa */

-- Q15: 15. Find all employees who started a job between January 1993 and December 
-- 1995. Display the employee_name, job_title, department name and start_date.
SELECT
    concat(employees.first_name,
           concat(' ', employees.last_name)) AS employee_full_name,
    job_title,
    department_name,
    start_date,
    employees.department_id                  AS e_dpt_id,
    departments.department_id                AS d_dpt_id,
    job_history.employee_id                  AS j_e_id,
    employees.employee_id                    AS e_e_id,
    jobs.job_id                              AS j_j_id,
    employees.job_id                         AS e_j_id
FROM
         employees
    JOIN departments ON employees.department_id = departments.department_id
    JOIN job_history ON job_history.employee_id = employees.employee_id
    JOIN jobs ON jobs.job_id = employees.job_id
WHERE
    start_date BETWEEN TO_DATE('01/01/1993', 'DD/MM/YYYY') 
    AND TO_DATE('31/12/1995', 'DD/MM/YYYY')
ORDER BY
    start_date ASC,
    first_name ASC;
/* 1 employee, jennifer whalen */

-- Date: 20th September 2024

-- Q16: 16. Find all information of employees and their departments. Your results 
-- should also show employees that do not have a department or new departments 
-- where no employee is working yet. 
SELECT
    DISTINCT *
FROM
         employees
    FULL OUTER JOIN departments USING ( department_id )
ORDER BY
    department_id ASC,
    department_name ASC,
    job_id ASC,
    first_name ASC;
/* 123 rows - department_ids 120 to 270 have no employees and employee_id 178 
kimberely has no department assigned. */

-- Q17: 17. Find the average salary for employees in different departments. Make 
-- sure to output the department name and the average salary
SELECT
    departments.department_id AS d_dpt_id,
    department_name,
    round(AVG(salary),
          2)                  AS average_salary
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
GROUP BY
    departments.department_id,
    department_name
ORDER BY
    department_name ASC,
    AVG(salary) DESC;
/* 11 departments */

-- Q18: 18. Calculate the difference between maximum salary of a job_title and 
-- salary of each employee. Display the employee_name, job_title, salary_difference. 
-- Order your results by the salary difference in increasing order.
SELECT
    concat(employees.first_name,
           concat(' ', employees.last_name)) AS employee_full_name,
    job_title,
    max_salary,
    salary                                   AS e_salary,
    salary - max_salary                      AS salary_difference,
    jobs.job_id                              AS j_j_id,
    employees.job_id                         AS e_j_id
FROM
         employees
    INNER JOIN jobs ON employees.job_id = jobs.job_id
ORDER BY
    job_title ASC,
    salary - max_salary DESC,
    first_name ASC;
/* 107 employees displayed */

-- Q19: 19. Find the number of employees for each job_title. 
SELECT
    job_title,
    COUNT(employee_id)
FROM
         employees
    INNER JOIN jobs ON jobs.job_id = employees.job_id
GROUP BY
    job_title
ORDER BY
    COUNT(employee_id) DESC,
    job_title ASC;
/* 19 job titles */

-- Date: 21st September 2024

-- Q20: 20. Find the number of departments in each city.
SELECT
    city,
    COUNT(department_id) AS no_of_departments
FROM
         departments
    INNER JOIN locations ON departments.location_id = locations.location_id
GROUP BY
    city
ORDER BY
    COUNT(department_id) DESC,
    city ASC;
/* 7 cities, seattle is the only one with more than 1 department */