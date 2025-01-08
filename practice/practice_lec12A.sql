-- Date: 23/dec/24

--Retrieve employees who are
--located in location # 1700
SELECT
    employees.*,
    departments.location_id
FROM
         employees
    INNER JOIN departments ON employees.department_id = departments.department_id
WHERE
    departments.department_id IN (
        SELECT
            department_id
        FROM
            departments
        WHERE
            location_id = 1700
    );
    
--    Find the employee(s) who
--have the highest salary\
SELECT
    *
FROM
    employees
WHERE
    salary = (
        SELECT
            MAX(salary)
        FROM
            employees
    );
    
-- top 3 salaries
SELECT
    *
FROM
    (
        SELECT
            employee_id,
            first_name,
            last_name,
            salary,
            RANK()
            OVER(
                ORDER BY
                    salary DESC
            ) AS salary_rank
        FROM
            employees
    ) ranked_salaries
WHERE
    salary_rank <= 5;

-- find the employees with higher salary then their department average
SELECT
    e1.*,
    (
        SELECT
            round(AVG(salary),
                  2)
        FROM
            employees
        WHERE
            department_id = e1.department_id
    ) AS average_salary
FROM
    employees e1
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees e2
        WHERE
            e2.department_id = e1.department_id
    );
    
    
-- all employss using window
SELECT
    e.*,
    round(SUM(salary)
          OVER(PARTITION BY department_id
               ORDER BY
                   salary ASC
          ),
          2) AS window
FROM
    employees e;
    
-- filter using CTE
WITH salaries AS (
    SELECT
        e.*,
        round(SUM(salary)
              OVER(PARTITION BY department_id
                   ORDER BY
                       salary ASC
              ),
              2) AS window
    FROM
        employees e
)
SELECT
    *
FROM
    salaries
WHERE
    window < 10000
ORDER BY
    department_id ASC;
    
-- ranking
SELECT
    e.*,
    round(dense_RANK()
          OVER(
        ORDER BY
            salary ASC, department_id ASC
          ),
          2) AS window
FROM
    employees e
where department_id = 50;

--1. Write a query to display if the salary of an employee is
--higher, lower or equal to the previous employee in the
--same department. 
SELECT
    e.*,
    LAG(salary)
    OVER(PARTITION BY department_id
         ORDER BY
             salary DESC
    )   AS previous_salary,
    CASE
        WHEN e.salary > LAG(salary)
                        OVER(PARTITION BY department_id
                             ORDER BY
                                 salary DESC
        ) THEN
            'Lower'
        WHEN e.salary < LAG(salary)
                        OVER(PARTITION BY department_id
                             ORDER BY
                                 salary DESC
        ) THEN
            'Higher'
        WHEN e.salary = LAG(salary)
                        OVER(PARTITION BY department_id
                             ORDER BY
                                 salary DESC
        ) THEN
            'Equal'
        ELSE
            'Missing'
    END AS previous_comparision
FROM
    employees e;

--2. Get the Top 3 employees with highest salaries in each Job
--title.
WITH ranked_salaries AS (
    SELECT
        e.*,
        job_title,
        RANK()
        OVER(PARTITION BY job_title
             ORDER BY
                 salary DESC
        ) AS ranking
    FROM
             employees e
        INNER JOIN jobs ON e.job_id = jobs.job_id
)
SELECT
    *
FROM
    ranked_salaries
WHERE
    ranking <= 3;

--3. Assign row number to the employees table based on the
--increasing value of commission. Ignore the employees
--having a null valued commission. Output employee_id,
--department_id, commission and row number.
SELECT
    employee_id,
    department_id,
    commission_pct,
    ROW_NUMBER()
    OVER(
        ORDER BY
            commission_pct DESC
    ) AS row_number
FROM
    employees
WHERE
    commission_pct IS NOT NULL;