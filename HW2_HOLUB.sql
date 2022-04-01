-- 1. For the current maximum annual wage in the company SHOW the full name of the employee, 
-- department, current position, for how long the current position is held, andtotal years of service in the company.

SELECT 
    e.first_name,
    e.last_name,
    t.title,
    de.dept_no,
    TIMESTAMPDIFF(YEAR,
        t.from_date,
        CURRENT_DATE()) AS duration,
    TIMESTAMPDIFF(YEAR,
        e.hire_date,
        CURRENT_DATE()) AS services_length
FROM
    employees AS e
        JOIN
    salaries AS s ON e.emp_no = s.emp_no
        JOIN
    titles AS t ON e.emp_no = t.emp_no
    JOIN
    dept_emp AS de ON e.emp_no = de.emp_no
WHERE
    CURRENT_DATE() BETWEEN t.from_date AND t.to_date
        AND s.salary = (SELECT 
            MAX(s.salary)
        FROM
            salaries AS s where CURRENT_DATE() BETWEEN s.from_date AND s.to_date)
;

-- 2.For each department, show its name and current manager’s name, last name, and current salary
SELECT 
    d.dept_name, e.first_name, e.last_name, s.salary
FROM
    departments AS d
        JOIN
    dept_manager AS dm ON d.dept_no = dm.dept_no
        JOIN
    employees AS e ON dm.emp_no = e.emp_no 
        JOIN
    salaries AS s ON e.emp_no = s.emp_no 
WHERE	
    CURRENT_DATE() between dm.from_date and dm.to_date
        AND CURRENT_DATE() between s.from_date and s.to_date
;

-- 3.Show for each employee, their current salary and their current manager’s current salary.
SELECT 
    de.emp_no,
    s.salary,
    dm.emp_no AS manager_no,
    sm.salary AS manag_sal
FROM
    dept_emp AS de
        JOIN
    salaries AS s ON de.emp_no = s.emp_no
        LEFT JOIN
    dept_manager AS dm ON de.dept_no = dm.dept_no
        LEFT JOIN
    salaries AS sm ON dm.emp_no = sm.emp_no
WHERE
    CURRENT_DATE() BETWEEN dm.from_date AND dm.to_date
        AND CURRENT_DATE() BETWEEN sm.from_date AND sm.to_date
        AND CURRENT_DATE() BETWEEN s.from_date AND s.to_date
        AND CURRENT_DATE() BETWEEN de.from_date AND de.to_date  
ORDER BY dm.emp_no , de.emp_no;

-- 4.Show all employees that currently earn more than their managers.
SELECT 
    de.emp_no,
    s.salary,
    dm.emp_no AS manager_no,
    sm.salary AS manag_sal
FROM
    dept_emp AS de
        JOIN
    salaries AS s ON de.emp_no = s.emp_no
        LEFT JOIN
    dept_manager AS dm ON de.dept_no = dm.dept_no
        LEFT JOIN
    salaries AS sm ON dm.emp_no = sm.emp_no
WHERE
       CURRENT_DATE() BETWEEN de.from_date AND de.to_date AND
       CURRENT_DATE() BETWEEN dm.from_date AND dm.to_date
        AND CURRENT_DATE() BETWEEN sm.from_date AND sm.to_date
        AND CURRENT_DATE() BETWEEN s.from_date AND s.to_date
        AND s.salary > sm.salary
ORDER BY dm.emp_no , de.emp_no
;

-- 5.Show how many employees currently hold each title,sorted in descending order by the number of employees.
SELECT 
    t.title, COUNT(t.emp_no) AS count_emp
FROM
    titles AS t
WHERE
    CURRENT_DATE() BETWEEN from_date AND to_date
GROUP BY t.title
ORDER BY count_emp DESC
;


-- 6.Show full name of the all employees who were employed in more than one department.
SELECT 
    CONCAT(e.first_name, '  ', e.last_name) AS full_name,
    COUNT(dept_no) AS count_dept
FROM
    employees AS e
        JOIN
    dept_emp AS de USING (emp_no)
GROUP BY e.emp_no
HAVING COUNT(dept_no) > 1;

-- 7.Show the average salary and maximum salary in thousands of dollars for every year.
SELECT 
    YEAR(from_date) as year_,
    MAX(salary) AS max_per_year,
    ROUND(AVG(salary), -3)/1000 AS avg_per_year
FROM
    salaries
GROUP BY YEAR(from_date)
ORDER BY YEAR(from_date);


-- 8.Show how many employees were hired on weekends (Saturday + Sunday), split bygender
-- 8.1
SELECT 
    gender, COUNT(hire_date) AS count_emp
FROM
    employees
WHERE
    DATE_FORMAT(hire_date, '%W') LIKE 'Sunday'
        OR DATE_FORMAT(hire_date, '%W') LIKE 'Saturday'
GROUP BY gender
;

-- 8.2
SELECT 
    gender, COUNT(gender) as count_emp
FROM
    employees
WHERE
    DAYOFWEEK(hire_date) = 7
        OR DAYOFWEEK(hire_date) = 1
GROUP BY gender
;


-- №9
-- Fulfill the script below to achieve the following data:
-- Group all employees according to their age at January 1st, 
-- 1995 into four groups:32 or younger, 33-36, 37-40 and older. 
-- Show average salary for each group and gender(8 categories in total)  
-- Also add subtotals and grand total.

SELECT 
    CASE
        WHEN YEAR(FROM_DAYS(DATEDIFF('1995-01-01', birth_date))) <= 32 THEN '32 and below'
        WHEN YEAR(FROM_DAYS(DATEDIFF('1995-01-01', birth_date))) BETWEEN 33 AND 36 THEN 'between 33 and 36'
        WHEN YEAR(FROM_DAYS(DATEDIFF('1995-01-01', birth_date))) BETWEEN 37 AND 40 THEN 'between 37 and 40'
        ELSE '41 + '
    END AS category,
    gender,
    COUNT(gender) AS count_category,
    ROUND(AVG(s.salary), 0) AS avg_sal_cat,
    (SELECT 
            ROUND(AVG(salary), 0)
        FROM
            salaries
        WHERE
            s.from_date > '1995-01-01') AS avg_sal_emp
FROM
    employees AS e
        INNER JOIN
    salaries AS s USING (emp_no)
WHERE
    s.from_date > '1995-01-01'  -- не  "більше-дорівнює" а "більше"
        AND (SELECT 
            MAX(to_date)
        FROM
            dept_emp de
        WHERE
            de.emp_no = e.emp_no
        GROUP BY de.emp_no) > '1995-01-01'
GROUP BY category , gender
ORDER BY gender , category;  