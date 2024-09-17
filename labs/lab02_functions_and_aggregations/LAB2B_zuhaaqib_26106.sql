-- Date: 31st Aug 2024

-- Q1: Display all the locations (cities) in US (country) using uppercase function.
SELECT
    location_id,
    upper(city) AS city,
    country_id  AS country_abbreviation
FROM
    locations
WHERE
    country_id = 'US';
/* 4 cities are shown with location ID 1400, 1500, 1600, 1700 */

-- Q2: Display STREET_ADDRESS in uppercase, CITY in lowercase, concatenate CITY 
-- and STATE_PROVINCE and display it as a new attribute called CITY_STATE_PROVINCE.
SELECT
    upper(street_address)  AS street_address,
    lower(city)            AS city,
    concat(concat(city, ', '),
           state_province) AS city_state_province
FROM
    locations;
/* 23 locations shown */

-- Q3: Display all the employees whose FIRST_NAME is ‘Michael’ . We suspect that 
-- first name can be in small letters due to typos , so we need to search the 
-- name irrespctive of the case. 
SELECT
    *
FROM
    employees
WHERE
    upper(first_name) = 'MICHAEL';
/* 2 employees, michael rogers & michael hartstein */

-- Q4: Display FIRST_NAME and LAST_NAME after converting the first letter of each 
-- name to upper case and the rest to lower case
SELECT
    employee_id,
    initcap(first_name) AS first_name,
    initcap(last_name)  AS last_name
FROM
    employees;
/* 107 employees */

-- Q5: Display the FULL_NAME , JOB_ID and MANAGER_ID of all employess. There 
-- should be a space first_name and last_name in FULL_NAME 
SELECT
    employee_id,
    concat(concat(first_name, ' '),
           last_name) AS full_name,
    job_id,
    manager_id
FROM
    employees
ORDER BY
    job_id ASC;
/* 107 employees */

-- Q6: Display the list of employees where the first part of JOB_ID is ‘FI’ or 
-- the last part is ‘CLERK’ . Use character function SUBSTR instead of ‘_%’ wild 
-- card characters. Hint: SUBSTR(string, starting position, total characters to extract)
SELECT
    *
FROM
    employees
WHERE
    substr(job_id, 1, 2) = 'FI'
    OR substr(job_id, - 5, 5) = 'CLERK';
/* 51 employees : the FI one is done using index 1 to index 3 searching and the 
CLERK one is done by searching 5 spaces from the end of the string i.e. index n 
and index n-5 */

-- Q7: Disply FIRST_NAME, LAST_NAME , length of PHONE_NUMBER as PHONE_FORMAT and
-- number of digits in salary as SALARY_DIGITS.
SELECT
    first_name,
    last_name,
    phone_number,
    length(phone_number) AS length_of_phone_number,
    salary,
    length(salary)       AS salary_digits
FROM
    employees;
/* 107 employees */

-- Q8: Display the position of space character in JOB_TITLE. Hint: use INSTR 
-- function to return the position of the character
SELECT
    job_title,
    instr(job_title, ' ') AS space_character_index
FROM
    jobs;
/* 19 job titles */

-- Q9: Display the first word in JOB_TITLE
SELECT
    job_title,
    substr(job_title,
           1,
           instr(concat(job_title, ' '),
                 ' ')) AS job_title
FROM
    jobs;
/* 19 titles : in this we first add a space to the end of the job title using CONCAT and 
then pass this string to INSTR to find the index of the first space and then using 
this index we SUBSTR from index 1 to the first space. the space is CONCATTED because 
some job titles are only one word and do not have a space so they are displayed 
as null which is wrong. */

-- Q10: Demonstrate LPAD on any random string. Hint: use DUAL when you only 
-- have one row and no known schema
SELECT
    lpad('Zuha', 10, '*') AS first_name
FROM
    dual;
/* ******Zuha */
    
-- Q11: Demonstrate RPAD on any random string
SELECT
    rpad('Aqib', 10, '*') AS last_name
FROM
    dual;
/* Aqib****** */

-- Q12: Demonstrate TRIM function on your name or any random string
SELECT
    TRIM('         Zuha Aqib               ') AS full_name
FROM
    dual;
/* Zuha Aqib */

-- Q13: Demonstrate LTRIM function to remove spaces
SELECT
    ltrim('                Zuha Aqib           ') AS full_name
FROM
    dual;
/* Zuha Aqib           */

-- Q14: Demonstrate RTRIM function to remove spaces
SELECT
    rtrim('         Zuha Aqib               ') AS full_name
FROM
    dual;
/*          Zuha Aqib */

-- Q15: Demonstrate REPLACE function
SELECT
    replace('She is ugly', 'ugly', 'beautiful') AS adjective_replacement
FROM
    dual;
/* She is beautiful */

-- Q16: Demonstrate ROUND function to round a number to 3 decimal places
SELECT
    3.141592653589793238462643383279502884197           AS pi_value,
    round(3.141592653589793238462643383279502884197, 3) AS rounded_pi_value
FROM
    dual;
/* rounded value is 3.142, you can see how 3.1415 was rounded to 3.142 (up) */

-- Q17: Demonstrate ROUND function to round a number to an integer
SELECT
    3.141592653589793238462643383279502884197        AS pi_value,
    round(3.141592653589793238462643383279502884197) AS rounded_pi_value
FROM
    dual;
/* rounded value is 3, i.e. it was rounded down to the nearest integer */

-- Q18: Demonstrate number function TRUNC to extract 4 decimal places without rounding off
SELECT
    3.141592653589793238462643383279502884197           AS pi_value,
    trunc(3.141592653589793238462643383279502884197, 4) AS truncated_pi_value
FROM
    dual;
/* truncated value is 3.1415, i.e. the 3.14159 should be ROUNDED to 3.1416 but since
it was truncated, the last value is taken */

-- Q19: Demonstrate number function MOD to find the remainder
SELECT
    65          AS number1,
    10          AS number2,
    mod(65, 10) AS remainder_n1_divided_n2
FROM
    dual;
/* 5 as 6*10 = 60, so remainder is 5 */

-- Q20: Display your age in months. Hint: use the sysdate and the months between function
SELECT
    DATE '2003-10-18' AS date_of_birth,
    SYSDATE      AS todays_date,
    round(months_between(current_date, DATE '2003-10-18'),
          2)          AS age_in_months
FROM
    dual;
/* 250.45 months means 20 years and 10 months which is correct */

-- Q21: Display FIRST_NAME, LAST_NAME , JOB_ID and EXPERIENCE_IN_YEARS of all the employees
SELECT
    first_name,
    last_name,
    job_id,
    round(months_between(current_date, hire_date) / 12,
          2) AS experience_in_years
FROM
    employees;
/* 107 employees */

-- Q22: Demonstrate ADD_MONTHS function
SELECT
    current_date                AS todays_date,
    add_months(current_date, 2) AS date_after_2_months
FROM
    employees;
/* 31-oct-24 is the date after 2 months */

-- Q23: What will be the date on the first Sunday of 22nd century. 
SELECT
    next_day(DATE '2101-01-01', 'sunday') AS first_sunday_in_22nd_century
FROM
    dual;
/* the 22nd century is from 2101 to 2200. the first sunday is on January 02 2101 */
    
-- Date: 1st September 2024

-- Q24: Demonstarte ROUND on SYSDATE by rounding the months
SELECT
    round(current_date, 'MM') AS todays_date_rounded_to_month
FROM
    dual;
/* 1st sep 24 : month wise rounding down, as we are < 15th date */
SELECT
    round(current_date) AS todays_date_rounded_to_days
FROM
    dual;
/* 2nd sep 24 : day wise rounding, we round up to the next day */

-- Q25: Demonstarte ROUND on SYSDATE by rounding the years
SELECT
    round(current_date, 'YY') AS todays_date_rounded_to_years
FROM
    dual;
/* 1st jan 25 : it rounded the year as we are in the 9th month so round up */
SELECT
    round(TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'YYYY') AS rounded_date
FROM
    dual;
/* 1st jan 24 : it rounded down as may is the 5th month */

-- Q26: Demonstrate TRUNC on SYSDATE by truncating the ‘MONTH’
SELECT
    trunc(current_date, 'MM') AS todays_date_truncated_months
FROM
    dual;
/* 1 sep 24 : it cut off the 9th month and displayed that */

-- Q27: Demonstrate TRUNC on SYSDATE by truncating the ‘YEAR’
SELECT
    trunc(current_date, 'YY') AS todays_date_truncated_years
FROM
    dual;
/* 1 jan 24 : it cut off the 2024 and displayed that */

-- Q28: How many employees have been hired in the month of June? Hint: use the TO_CHAR
-- function.
SELECT
    COUNT(*) AS employees_hired_in_june
FROM
    employees
WHERE
    to_char(hire_date, 'MM') = '06';
/* 11 employees : it converts all the hireddates to just months, and then checks 
which of them are in june (06) month */