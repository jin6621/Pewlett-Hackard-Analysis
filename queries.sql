-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL, 
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

DROP TABLE titles
CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);


SELECT * from titles;

-- Retirement eligibility -----------------------------------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-1' AND '1988-12-31');

-- retirement for 1952
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1952-12-31') 


-- retirement for 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31;'

-- retirement for 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31;'

-- retirement for 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31;'

-- Number of employees retiring (only need to select one column)---------------------------------------------------
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-1' AND '1988-12-31');

-- Retirement eligibility -----------------------------------------------------------------------------
SELECT first_name, last_name
INTO retirement_info         -- This indicate new table is generated, and saved as retirement_info. 
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-1' AND '1988-12-31');

SELECt * from retirement_info

DROP TABLE retirement_info

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info         
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-1' AND '1988-12-31');

-- Check the table
SELECT * from retirement_info

-- Join departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and tables
SELECT retirement_info.emp_no, retirement_info.first_name, retirement_info.last_name, dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement info and dept_emp tables
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- THIS HAS NO DATA?
SELECT * FROM dept_emp

SELECT * FROM employees;

SELECT ri.emp_no, 
	ri.first_name,
	ri.last_name, 
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp

DROP TABLE current_emp

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_employee_retirement
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee Information
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info 
FROM employees as e
INNER JOIN salaries as s ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-1' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

DROP TABLE emp_info
SELECT * FROM current_emp

-- Management
SELECT d.dept_no, d.dept_name, ce.emp_no, ce.last_name, ce.first_name, dm.from_date, dm.to_date
-- INTO
FROM departments as d
INNER JOIN dept_manager as dm ON (d.dept_no = dm.dept_no)
INNER JOIN current_emp as ce ON (ce.emp_no = dm.emp_no)


-- Department Retirees
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
--INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d ON (de.dept_no = d.dept_no)


-- 7.3.6
SELECT ri.emp_no, ri.first_name, ri.last_name, d.dept_name
INTO retirement_info_sales_development
FROM retirement_info as ri
INNER JOIN dept_emp as de ON (ri.emp_no =  de.emp_no)
INNER JOIN departments as d ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales','Development');
