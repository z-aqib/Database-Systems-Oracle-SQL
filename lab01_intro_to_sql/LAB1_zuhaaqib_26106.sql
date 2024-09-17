--practice
SELECT
    *
FROM
    employees;

--Q1
SELECT
    *
FROM
    employees
WHERE
    department_id = 40;
/* only one employee, Susan */

--Q2
SELECT
    last_name,
    salary
FROM
    employees
WHERE
    job_id = 'IT_PROG';
/* 5 employees */

--Q3
SELECT
    last_name,
    email
FROM
    employees
WHERE
    hire_date = '07-JUN-02';
/* 4 employees */

--Q4
SELECT
    *
FROM
    employees
WHERE
        department_id > 60
    AND hire_date > '01-JUN-06';
/* 15 employees */

--Q5
SELECT
    *
FROM
    employees
WHERE
    hire_date BETWEEN '01-JUN-07' AND '01-DEC-07';
/* 6 employees */

--Q6
SELECT
    *
FROM
    employees
WHERE
    salary < 5000;
/* 49 employees */

--Q7
SELECT
    COUNT(*)
FROM
    employees
WHERE
    salary < 5000;
/* 49 value */

--Q8
SELECT
    *
FROM
    employees
WHERE
        salary > 10000
    AND salary < 15000;
/* 12 employees */

--Q9
SELECT
    *
FROM
    employees
WHERE
    manager_id = 100
    OR manager_id = 101
    OR manager_id = 201;
/* 20 employees */

--Q10
SELECT
    *
FROM
    employees
WHERE
    manager_id IN ( 100, 101, 201 );
/* 20 employees */

--Q11
SELECT
    *
FROM
    employees
WHERE
    NOT job_id IN ( 'IT_PROG', 'SA_REP', 'FI_ACCOUNT' );
/* 67 employees */

--Q12
SELECT
    *
FROM
    employees
WHERE
    last_name LIKE 'A%';
/* 4 employees */

--Q13
SELECT
    *
FROM
    employees
WHERE
    first_name LIKE '%r';
/* 11 employees */

--Q14
SELECT
    last_name,
    email,
    phone_number
FROM
    employees
WHERE
    first_name LIKE 'S%'
    OR first_name LIKE 'J%';
/* 29 employees */

--Q15
SELECT
    *
FROM
    employees
WHERE
    first_name LIKE '_o%';
/* 10 employees */

--Q16
SELECT
    *
FROM
    employees
WHERE
    department_id IS NULL;
/* 1 employee, kimberly */

--Q17
SELECT
    COUNT(*)
FROM
    employees
WHERE
    manager_id IS NULL;
/* 1 count */

--Q18
SELECT
    *
FROM
    employees
WHERE
    commission_pct IS NULL
    OR commission_pct = 0;
/* 72 employees */

--Q19
SELECT
    *
FROM
    employees
WHERE
        job_id = 'SA_REP'
    AND salary > 10000;
/* 3 employees */

--Q20
SELECT
    *
FROM
    employees
WHERE
    job_id = 'SA_REP'
    OR salary < 11000;
/* 96 employees */

--Q21 
SELECT
    *
FROM
    employees
WHERE
    job_id = 'SA_REP'
    OR ( job_id = 'AD_PRES'
         AND salary > 15000 );
/* 31 employees */

--Q22
SELECT
    *
FROM
    employees
WHERE
    ( job_id = 'SA_REP'
      OR job_id = 'AD_PRES' )
    AND salary > 15000;
/* 1 employee, steven */

--Q23
SELECT
    *
FROM
    employees
ORDER BY
    email DESC;
/* 107 employees */

--Q24
SELECT
    *
FROM
    employees
ORDER BY
    employee_id ASC;
/* 107 employees */

--Q25
SELECT
    *
FROM
    employees
ORDER BY
    employee_id DESC;
/* 107 employees */ 

--Q26
SELECT
    job_id,
    first_name,
    hire_date
FROM
    employees
ORDER BY
    job_id DESC,
    first_name ASC;
/* 107 employees */

--Q27
SELECT
    *
FROM
    employees
ORDER BY
    6;
/* 6TH column is hire_date, 107 employees */