
-- 1. Who have the same name as the managers of the "Finance" department?
SELECT 
    emp_no, 
    first_name, 
    last_name 
FROM employees 
WHERE first_name IN (
    -- Subquery to get the first names of Finance managers
    SELECT e.first_name 
    FROM employees e
    JOIN dept_manager dm ON e.emp_no = dm.emp_no
    JOIN departments d ON dm.dept_no = d.dept_no
    WHERE d.dept_name = 'Finance'
)
AND emp_no NOT IN (
    -- Exclude the managers themselves
    SELECT dm.emp_no 
    FROM dept_manager dm
    JOIN departments d ON dm.dept_no = d.dept_no
    WHERE d.dept_name = 'Finance'
);


-- 2. Who in the "Production" department were hired after the promotion of the last manager in that department?
SELECT 
    e.emp_no, 
    e.first_name, 
    e.last_name, 
    e.hire_date
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Production' 
AND e.hire_date > (
    -- Subquery to find the latest from_date (promotion date) of a Production manager
    SELECT MAX(dm.from_date) 
    FROM dept_manager dm
    JOIN departments d2 ON dm.dept_no = d2.dept_no
    WHERE d2.dept_name = 'Production'
);


-- 3. Find the average salary of each department, from highest to lowest.
SELECT 
    d.dept_name,
    (
        SELECT AVG(s.salary)
        FROM salaries s
        JOIN dept_emp de ON s.emp_no = de.emp_no
        WHERE de.dept_no = d.dept_no
    ) AS avg_salary
FROM departments d
ORDER BY avg_salary DESC;


-- 4. Find the average salary for each type of Engineer, from highest to lowest.
SELECT 
    eng.title, 
    eng.avg_salary 
FROM (
    SELECT t.title, AVG(s.salary) AS avg_salary
    FROM titles t
    JOIN salaries s ON t.emp_no = s.emp_no
    WHERE t.title LIKE '%Engineer%'
    GROUP BY t.title
) AS eng
ORDER BY eng.avg_salary DESC;