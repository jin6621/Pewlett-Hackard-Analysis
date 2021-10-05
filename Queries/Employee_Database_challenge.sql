-- Challenge: Deliverable 1 --------------------------------------------------------------------
SELECT * 
FROM employees

-- DROP TABLE employees_pull
-- 1
SELECT emp_no, first_name, last_name, birth_date
INTO employees_pull
FROM employees;

-- 2 
SELECT emp_no, title, from_date, to_date
INTO titles_pull
FROM titles;

-- 3: Table created for above.

-- DROP TABLE emp_title
-- 4: 
SELECT ep.emp_no, ep.first_name, ep.last_name, tp.title, tp.from_date, tp.to_date, ep.birth_date
INTO emp_title
FROM employees_pull as ep
INNER JOIN titles_pull as tp
ON (ep.emp_no = tp.emp_no);

-- Check table
SELECT *
FROM emp_title

--DROP TABLE retirement_titles
-- 5
SELECT *
INTO retirement_titles
FROM emp_title
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no, to_date DESC;

-- 6: save as retiremeent_titles.csv

-- 7: Chceck table
SELECT emp_no, first_name, last_name, title
FROM retirement_titles
ORDER BY title

-- 8 ~ 12: Use Dictinct with Orderby to remove duplicate rows
-- Reference: https://www.postgresql.org/docs/9.5/sql-select.html
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no;

-- 13 ~ 14: Export to unique_titles.csv

-- 15 ~ 17: retrieve the number of employees by their most recent job title who are about to retire. 
SELECT DISTINCT ON (title) title
FROM unique_titles
ORDER BY title


-- 18: 
SELECT COUNT(title) AS "Count", title AS "Title"
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "Count" desc;


-- Challenge: Deliverable 2 --------------------------------------------------------------------

-- 1: Retrieve columns from Employees table
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date
FROM employees;

-- 2: Retrieve columns from Department Employee table
SELECT DISTINCT ON (emp_no) emp_no, from_date, to_date
--INTO dept_emp2
FROM dept_emp
ORDER BY emp_no, from_date DESC;

-- 3: Retrieve columns from Titles table
SELECT DISTINCT ON (emp_no) emp_no, title, to_date
--INTO titles2
FROM titles
ORDER BY emp_no, to_date DESC;

-- 4 ~ 7: 
SELECT e.emp_no, e.first_name, e.last_name, e.birth_date, de2.from_date, de2.to_date, t2.title
INTO mentorship
FROM employees as e
INNER JOIN dept_emp2 as de2 ON (e.emp_no = de2.emp_no) 
INNER JOIN titles2 as t2 ON (e.emp_no = t2.emp_no)

-- 8:
SELECT *
INTO mentorship_eligibilty
FROM mentorship
WHERE (to_date = '9999-01-01') AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no

SELECT COUNT(emp_no) AS "employee Count"
FROM unique_titles

SELECT COUNT(emp_no) AS "mentors Count"
FROM mentorship