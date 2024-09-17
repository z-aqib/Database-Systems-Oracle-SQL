-- Date: 29th August 2024

-- Q1: How many employees are working in department with ID = 50
SELECT
    COUNT(*) AS number_of_employees_in_dpt_50
FROM
    employees
WHERE
    department_id = 50;
/* 45 employees */

-- Q2: What is the total number of employees belonging to department 80 and have 
-- salary greater than 24000
SELECT
    COUNT(*) AS number_of_employees_in_dpt_80_with_salary_24000
FROM
    employees
WHERE
        department_id = 80
    AND salary > 24000;
/* 0 employees */

-- Q3: How many employees are receiving a commission
SELECT
    COUNT(*) AS number_of_non_comission_pct
FROM
    employees
WHERE
    NOT commission_pct IS NULL;
/* 35 employees */

-- Q4: What is average, minimum and maximum salary of employees having JOB_ID 
-- ending with CLERK? Use suitable alias for each new column.
SELECT
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM
    employees
WHERE
    job_id LIKE '%CLERK';
/* 2975.55, 2100, 4200 */

-- Q5: How many distinct departments are there in employees table?
SELECT DISTINCT
    COUNT(department_id) AS number_of_department_ids
FROM
    employees;
/* 106 count */

-- Q6: How many distinct job_ids are there in employees table?
SELECT DISTINCT
    COUNT(job_id) AS number_of_job_ids
FROM
    employees;
/* 107 count */

-- Q7: Compute average COMMISSION_PCT rounded up to two decimal places 
SELECT
    round(AVG(commission_pct),
          2) AS average_commission_pct
FROM
    employees;
/* 0.22 */

-- Q8: Compute average COMMISSION_PCT ignoring NULL values rounded up to two decimal places 
SELECT
    round(AVG(commission_pct),
          2) AS average_commission_pct
FROM
    employees;
/* 0.22 */

-- Q9: Compute average COMISSON_PCT considering NULL values truncated upto two decimal
-- places.
SELECT
    trnuc(SUM(commission_pct) / COUNT(*),
          2) AS average_commission_pct
FROM
    employees;
/* 0.07 */

-- Q10:  Compute AVG_SALARY for each department in employees table rounded up to 
-- two decimal places 
SELECT
    department_id,
    round(AVG(salary),
          2) AS avg_salary
FROM
    employees
GROUP BY
    department_id;
/* 12 departments id's with various salaries */

-- Q11: Compute AVG_SALARY for each JOB_ID in employees table 
SELECT
    job_id,
    round(AVG(salary),
          2) AS average_salary
FROM
    employees
GROUP BY
    job_id;
/* 19 job ids with various salaries */

-- Q12: Compute department-wise total salary of all employees sorted by department_id
SELECT
    department_id,
    SUM(salary) AS total_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id ASC;
/* 12 departments in order with last one null */

-- Q13: Which department has the lowest average salary and what is the value. 
-- Hint: fetch first row only
SELECT
    department_id,
    AVG(salary) AS lowest_average_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    AVG(salary) ASC
FETCH FIRST ROW ONLY;
/* department id 50, 3475.55 */

-- Q14
SELECT
    job_id,
    MAX(salary) AS maximum_salary
FROM
    employees
GROUP BY
    job_id
ORDER BY
    MAX(salary) DESC
FETCH FIRST 5 ROW ONLY;
/* 24000, 17000, 14000, 13000, 12008 */

-- Q15 
SELECT
    department_id,
    job_id,
    COUNT(last_name)
FROM
    employees
GROUP BY
    department_id;
/* select has many select but only one group by, only department_id should be there */
SELECT
    department_id,
    COUNT(last_name) AS number_of_employees
FROM
    employees
GROUP BY
    department_id;

-- Q16
SELECT
    department_id,
    AVG(salary)
FROM
    employees
WHERE
    AVG(salary) > 8000
GROUP BY
    department_id;
/* instead of where, we should apply HAVING after group by */
SELECT
    department_id,
    AVG(salary) AS average_salary
FROM
    employees
GROUP BY
    department_id
HAVING
    AVG(salary) > 8000;

-- Q17
SELECT
    department_id,
    job_id,
    SUM(salary) AS total_salary
FROM
    employees
GROUP BY
    department_id,
    job_id
HAVING
    SUM(salary) > 10000
ORDER BY
    department_id ASC;
/* 14 rows */

-- Q18
SELECT
    department_id,
    round(AVG(months_between(end_date, start_date)),
          2) AS average_job_duration_in_months
FROM
    job_history
GROUP BY
    department_id
ORDER BY
    department_id ASC;
/* 6 departments: 20, 50, 60, 80, 90, 110 */

-- Q19
SELECT
    job_id,
    round(MAX(months_between(end_date, start_date)),
          2) AS maximum_job_id_in_months
FROM
    job_history
GROUP BY
    job_id
ORDER BY
    job_id ASC;
/* 8 departments */

-- Q20
SELECT
    country_id,
    COUNT(location_id) AS number_of_locations
FROM
    locations
GROUP BY
    country_id
ORDER BY
    country_id ASC;
/* 14 rows */