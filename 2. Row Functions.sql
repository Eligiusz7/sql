--1
SELECT last_name, LEFT(position, 2) + CAST(id AS VARCHAR) AS code
FROM dbo.Employees;

--2
SELECT last_name, 
	REPLACE(REPLACE(REPLACE(last_name, 'K', 'X'), 'L', 'X'), 'M', 'X') AS replaced_name
FROM dbo.Employees;

--3 Find names of employees who have an 'L' in the first half of their last name
SELECT last_name
FROM dbo.Employees
WHERE SUBSTRING(last_name, 0, LEN(last_name)/2) LIKE '%L%';

--4
SELECT last_name, CAST(ROUND(salary_base*1.15, 0) AS INT) AS increase
FROM dbo.Employees;

--5
SELECT last_name, salary_base, salary_base*0.2 AS investment,
	(salary_base*0.2)*(POWER(1+0.1, 10.0)) AS capital,
	(salary_base*0.2)*(POWER(1+0.1, 10.0)) - (salary_base*0.2) AS profit
FROM dbo.Employees;

--6
SELECT last_name, hired, DATEDIFF(yy, hired, GETDATE()) AS years
FROM dbo.Employees
ORDER BY years DESC;

--7
SELECT last_name, hired, DATENAME(month, hired) + ' ' + DATENAME(day, hired) + ' ' + DATENAME(year, hired) AS hired_date
FROM dbo.Employees;

--8
SELECT DATENAME(dw, GETDATE()) AS today;

--9
SELECT last_name, id_bra, 
	CASE
		WHEN id_bra IN (10, 20) THEN 'central'
		WHEN id_bra = 30 THEN 'north'
		WHEN id_bra = 40 THEN 'south'
	END AS location
FROM dbo.Employees;

--10
SELECT last_name, salary_base,
	CASE
		WHEN salary_base < 1400 THEN 'lower than 1400'
		WHEN salary_base > 1400 THEN 'higher than 1400'
		ELSE 'equal to 1400'
	END AS treshold
FROM dbo.Employees;
