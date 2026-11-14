
-- 1. What is the average salary of each employee?
SELECT 
    e.emp_no, 
    concat(e.first_name, ' ', e.last_name) AS full_name, 
    ROUND(AVG(s.salary), 2) AS avg_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name;

-- 2. How much was each employee paid in total?
SELECT 
    e.emp_no, 
    concat(e.first_name, ' ', e.last_name) AS full_name, 
    SUM(s.salary) AS total_paid
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name;

-- 3. Minimum, maximum and total salaries of each department?
SELECT 
    d.dept_name,
    MIN(s.salary) AS min_salary,
    MAX(s.salary) AS max_salary,
    SUM(s.salary) AS total_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name;

-- 4. Which departments have paid more than 20 billion dollars for their employees?
SELECT 
    d.dept_name,
    SUM(s.salary) AS total_paid
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name
HAVING SUM(s.salary) > 20000000000;

-- 5. Total salaries of male employees in each department?
SELECT 
    d.dept_name,
    SUM(s.salary) AS total_male_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN employees e ON de.emp_no = e.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.gender = 'M'
GROUP BY d.dept_no, d.dept_name;

-- 6. Total salaries of department managers for each department, from highest to lowest?
SELECT 
    d.dept_name,
    SUM(s.salary) AS total_manager_salary
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN salaries s ON dm.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name
ORDER BY total_manager_salary DESC;