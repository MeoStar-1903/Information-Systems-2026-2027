
-- LABWORK 3: EMPLOYEES DATABASE (POSTGRESQL)


-- 1. All info of all employees
SELECT * FROM employees;

-- 2. All info of all departments
SELECT * FROM departments;

-- 3. Full names of all employees
SELECT concat(first_name, ' ', last_name) AS full_name FROM employees;

-- 4. Names of all departments
SELECT dept_name FROM departments;

-- 5. Full names of employees working in “Sales” department
SELECT concat(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- 6. Full names of male employees working in “Finance” department
SELECT concat(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Finance' AND e.gender = 'M';

-- 7. Salaries of female employees working in “Marketing” department
SELECT e.emp_no, concat(e.first_name, ' ', e.last_name) AS full_name, s.salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE d.dept_name = 'Marketing' AND e.gender = 'F';

-- 8. Full names of employees who have the same last name as their manager
SELECT DISTINCT concat(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN dept_manager dm ON de.dept_no = dm.dept_no
JOIN employees m ON dm.emp_no = m.emp_no
WHERE e.last_name = m.last_name AND e.emp_no <> m.emp_no;

-- 9. Full names of managers who have been doing the job at least twice
SELECT concat(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
HAVING COUNT(dm.dept_no) >= 2;

-- 10. Full names of employees who was paid more than $100000
SELECT DISTINCT concat(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 100000;

-- 11. Names of all departments that have employees paid more than $100000
SELECT DISTINCT d.dept_name
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
WHERE s.salary > 100000;

-- 12. Merge Development (d005) and Research (d008) -> Research and Development (d010)
INSERT INTO departments (dept_no, dept_name) 
VALUES ('d010', 'Research and Development');

UPDATE dept_emp SET dept_no = 'd010' WHERE dept_no IN ('d005', 'd008');
UPDATE dept_manager SET dept_no = 'd010' WHERE dept_no IN ('d005', 'd008');

DELETE FROM departments WHERE dept_no IN ('d005', 'd008');

-- 13. Merge Marketing (d001) and Sales (d007) -> Marketing and Sales (d011)
INSERT INTO departments (dept_no, dept_name) 
VALUES ('d011', 'Marketing and Sales');

UPDATE dept_emp SET dept_no = 'd011' WHERE dept_no IN ('d001', 'd007');
UPDATE dept_manager SET dept_no = 'd011' WHERE dept_no IN ('d001', 'd007');

DELETE FROM departments WHERE dept_no IN ('d001', 'd007');