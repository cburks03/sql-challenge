CREATE TABLE "Employees" (
    "emp_no" int   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "gender" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_employee" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_dept_employee" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "Departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar(200)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     ),
    CONSTRAINT "uc_Departments_dept_name" UNIQUE (
        "dept_name"
    )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "emp_no" int   NOT NULL,
    "title" varchar(200)   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "emp_no","from_date"
     )
);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

-- salary by employee
select emp.emp_no,
	emp.last_name,
	emp.first_name,
	emp.gender,
	sal.salary
from "Employees" as emp
	left join salaries as sal
	on (emp.emp_no = sal.emp_no)
order by emp.emp_no;

-- List employees who were hired in 1986.

select first_name, last_name
from "Employees"
where hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name, and start and end employment dates.

select dm.dept_no,
	d.dept_name,
	dm.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date,
	dm.to_date
from dept_manager as dm
	inner join "Departments" as d
		on (dm.dept_no = d.dept_no)
	inner join "Employees" as e
		on (dm.emp_no = e.emp_no);

-- List the department of each employee with the following information:
--employee number, last name, first name, and department name

select e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
from "Employees" as e
	inner join dept_employee as de
		on (e.emp_no = de.emp_no)
	inner join "Departments" as d
		on (de.dept_no = d.dept_no)
order by e.emp_no;
	
--List all employees whose first name is "Hercules"
--and last names begin with "B."	

select *
from "Employees"
	where first_name = 'Hercules'
	and last_name like 'B%';

--List all employees in the Sales department, 
--including their employee number, last name, 
--first name, and department name.

select e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
from "Employees" as e
	inner join dept_employee as de
		on (e.emp_no = de.emp_no)
	inner join "Departments" as d
		on (de.dept_no = d.dept_no)
where d.dept_name = 'Sales'
order by e.emp_no;

--List all employees in the Sales and Development departments,
--including their employee number, last name, first name, 
--and department name.

select e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
from "Employees" as e
	inner join dept_employee as de
		on (e.emp_no = de.emp_no)
	inner join "Departments" as d
		on (de.dept_no = d.dept_no)
where d.dept_name = 'Sales'
	or d.dept_name = 'Development'
order by e.emp_no;

--In descending order, list the frequency count of employee
--last names, i.e., how many employees share each last name.

select last_name, count(last_name)
from "Employees"
group by last_name
order by count(last_name) desc;