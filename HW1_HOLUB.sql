-- 1. List all female employees who joined at 01/01/1990 or at 01/01/2000
-- select * from employees;
-- 1.1 
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date IN ('1990-01-01' , '2000-01-01');  

-- 1.2  
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F' and (hire_date ='1990-01-01' or hire_date ='2000-01-01');  
    

-- 2. Show the name of all employees who have an equal first and last name
SELECT 
    first_name
FROM
    employees
WHERE
    first_name = last_name;

-- 3. Show employees numbers 10001,10002,10003 and 10004, select columns first_name, last_name, gender, hire_date.
-- 3.1
SELECT 
    first_name, last_name, gender, hire_date
FROM
    employees
WHERE
    emp_no in (10001, 10002, 10003, 10004);

-- 3.2    
SELECT 
    first_name, last_name, gender, hire_date
FROM
    employees
WHERE
    emp_no BETWEEN 10001 AND 10004;
    
-- 4. Select the names of all departments whose names have ‘a’ character on any position or ‘e’ on the second place.
SELECT 
    dept_name
FROM
    departments
WHERE
    dept_name LIKE '%a%'
        OR dept_name LIKE '_e%';
        
-- 5. Show employees who satisfy the following description: He(!) was 45 when hired, born in October and was hired on Sunday.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'M'
        AND TIMESTAMPDIFF(YEAR, birth_date, hire_date) = 45
        AND MONTH(birth_date) = 10
        AND DAYOFWEEK(hire_date) = 1;

-- 6. Show the maximum annual salary in the company after 01/06/1995.
SELECT 
    MAX(salary) AS max_salary
FROM
    salaries
WHERE
    from_date > '1995-06-01';
    
-- 7. In the dept_emp table, show the quantity of employees by department (dept_no). 
-- To_date must be greater than current_date. Show departmentswith more than 13,000 employees. Sort by quantity of employees.
SELECT 
    dept_no, COUNT(dept_no) AS quant
FROM
    dept_emp
WHERE
    to_date > CURDATE()
GROUP BY dept_no
HAVING quant > 13000
ORDER BY quant
;

-- 8 Show the minimum and maximum salaries by employee
 SELECT 
    emp_no, MAX(salary) AS max_salary, MIN(salary) AS min_salary
FROM
    salaries
GROUP BY emp_no
ORDER BY emp_no;