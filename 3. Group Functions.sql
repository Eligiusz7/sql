--1
SELECT MIN(salary_base) AS min_salary, MAX(salary_base) AS max_salary,
	MAX(salary_base) - MIN(salary_base) AS difference
FROM dbo.Employees;

--2
SELECT position, ROUND(AVG(salary_Base), 2) AS avg_salary
FROM dbo.Employees
GROUP BY position
ORDER BY avg_salary DESC;

--3
SELECT COUNT(*) AS managers
FROM dbo.Employees
WHERE position = 'MANAGER';

--4
SELECT id_bra, SUM(salary_base + ISNULL(salary_additional, 0)) AS sum_salary
FROM dbo.Employees
GROUP BY id_bra;

--5
SELECT TOP 1 id_bra, SUM(salary_base + ISNULL(salary_additional, 0)) AS sum_salary
FROM dbo.Employees
GROUP BY id_bra
ORDER BY sum_salary DESC;

--6
SELECT manager, MIN(salary_base+ISNULL(salary_additional, 0)) AS min_salary_per_manager
FROM dbo.Employees
WHERE manager IS NOT NULL
GROUP BY manager
ORDER BY min_salary_per_manager DESC;

--7
SELECT id_bra AS branch_no, COUNT(*) AS employees
FROM dbo.Employees
GROUP BY id_bra
ORDER BY employees DESC;

--8
SELECT id_bra AS branch_no, COUNT(*) AS employees
FROM dbo.Employees
GROUP BY id_bra
HAVING COUNT(*) > 3
ORDER BY employees DESC;

--9 check that employee IDs are unique
SELECT id, COUNT(*)
FROM dbo.Employees
GROUP BY id
HAVING COUNT(*) > 1;

--10
SELECT position, ROUND(AVG(salary_base + ISNULL(salary_additional, 0)), 2) AS avg_salary, COUNT(*) AS num_of_emp
FROM dbo.Employees
WHERE YEAR(hired) < 1990
GROUP BY position
ORDER BY avg_salary DESC;

--11
SELECT id_bra AS branch_no, position, ROUND(AVG(salary_base + ISNULL(salary_additional, 0)), 2) AS avg_salary, 
	MAX(salary_base + ISNULL(salary_additional, 0)) AS maximum
FROM dbo.Employees
WHERE position IN ('MANAGER', 'FOREMAN')
GROUP BY id_bra, position
ORDER BY branch_no, position;

--12
SELECT YEAR(hired) AS year_emp, COUNT(*) AS num_of_emp
FROM dbo.Employees
GROUP BY YEAR(hired)
ORDER BY year_emp ASC;

--13
SELECT LEN(last_name) AS letters, COUNT(*) AS num_of_names
FROM dbo.Employees
GROUP BY LEN(last_name)
ORDER BY letters;

--14
SELECT 
SUM( 
	CASE
		WHEN CHARINDEX('A', last_name) > 0 THEN 1
	END
	) AS names_with_a,
SUM( 
	CASE
		WHEN CHARINDEX('E', last_name) > 0 THEN 1
	END
	) AS names_with_e
FROM dbo.Employees;
