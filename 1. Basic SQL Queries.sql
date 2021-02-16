-- BASIC SQL QUERIES

--1
SELECT * FROM dbo.Branches;

--2
SELECT * FROM dbo.Employees;

--3
SELECT last_name, (salary_base + ISNULL(salary_additional, 0)) * 12 AS annual_salary
FROM dbo.Employees
ORDER BY annual_salary DESC;

--4
SELECT last_name, (salary_base + ISNULL(salary_additional, 0)) * 12 AS annual_salary
FROM dbo.Employees
ORDER BY annual_salary ASC;

--5
SELECT last_name, position, salary_base + ISNULL(salary_additional, 0) AS monthly_salary
FROM dbo.Employees
ORDER BY monthly_salary DESC;

--6
SELECT * 
FROM dbo.Branches
ORDER BY name;

--7
SELECT DISTINCT position
FROM dbo.Employees
ORDER BY 1 ASC;

--8
SELECT *
FROM dbo.Employees
WHERE position = 'MANAGER';

--9
SELECT id, last_name, position, salary_base, id_bra
FROM dbo.Employees
WHERE id_bra IN(30,40)
ORDER BY salary_base DESC;

--10
SELECT last_name, id_bra, salary_base
FROM dbo.Employees
WHERE salary_base BETWEEN 1300 AND 1800;

--11
SELECT last_name, position, id_bra
FROM dbo.Employees
WHERE last_name LIKE '%SKI';

--12
SELECT id, last_name, position, salary_base
FROM dbo.Employees
WHERE salary_base > 2000 AND manager IS NOT NULL;

--13
SELECT last_name, id_bra
FROM dbo.Employees
WHERE id_bra = 20 AND (last_name LIKE '%SKI' OR last_name LIKE 'M%');

--14
SELECT last_name, position, ROUND((salary_base / (20*8)), 2) AS hourly_rate
FROM dbo.Employees
WHERE position NOT IN('FOREMAN', 'FITTER', 'TRAINEE') AND salary_base NOT BETWEEN 1400 AND 1800
ORDER BY hourly_rate ASC;

--15
SELECT last_name, position, salary_base, salary_additional
FROM dbo.Employees
WHERE salary_base + salary_additional > 3000
ORDER BY position ASC, last_name ASC;

--16
SELECT last_name + ' has been working since ' + CAST(hired AS VARCHAR)  + ' and he earns ' + CAST(salary_base AS VARCHAR)
FROM dbo.Employees
WHERE position = 'MANAGER';