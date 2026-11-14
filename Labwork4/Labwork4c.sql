-- 1. Who have the same name as the managers of the "Finance" department?

CREATE VIEW v_finance_managers AS
SELECT e.emp_no, e.first_name 
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON dm.dept_no = d.dept_no
WHERE d.dept_name = 'Finance';

-- Query using the view
SELECT e.emp_no, e.first_name, e.last_name 
FROM employees e
JOIN v_finance_managers vfm ON e.first_name = vfm.first_name
WHERE e.emp_no != vfm.emp_no;


-- 2. Who in the "Production" department were hired after the promotion of the last manager in that department?
-- Create a view for the last promotion date of a Production manager
CREATE VIEW v_last_production_manager_promotion AS
SELECT MAX(dm.from_date) AS last_promotion_date
FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
WHERE d.dept_name = 'Production';

-- Query using the view
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
CROSS JOIN v_last_production_manager_promotion vp
WHERE d.dept_name = 'Production' 
AND e.hire_date > vp.last_promotion_date;


-- 3. Find the average salary of each department, from highest to lowest.
-- Create a view for the average salary of each department
CREATE VIEW v_dept_avg_salary AS
SELECT d.dept_name, AVG(s.salary) AS avg_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_name;

-- Query using the view
SELECT dept_name, avg_salary
FROM v_dept_avg_salary
ORDER BY avg_salary DESC;


-- 4. Find the average salary for each type of Engineer, from highest to lowest.
-- Create a view for the average salary of each engineer title
CREATE VIEW v_engineer_avg_salary AS
SELECT t.title, AVG(s.salary) AS avg_salary
FROM titles t
JOIN salaries s ON t.emp_no = s.emp_no
WHERE t.title LIKE '%Engineer%'
GROUP BY t.title;

-- Query using the view
SELECT title, avg_salary
FROM v_engineer_avg_salary
ORDER BY avg_salary DESC;