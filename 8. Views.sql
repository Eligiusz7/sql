--1
IF OBJECT_ID('dbo.Employed', 'U') IS NOT NULL
DROP TABLE dbo.Employed
GO

SELECT * INTO dbo.Employed FROM dbo.Employees;

--2
IF OBJECT_ID('Foreman', 'V') IS NOT NULL
DROP VIEW Foreman
GO
CREATE VIEW Foreman AS
	SELECT id, last_name, salary_base, DATEDIFF(year, hired, GETDATE()) AS years_of_work
	FROM dbo.Employed
GO

--3
IF OBJECT_ID('Salaries', 'V') IS NOT NULL
DROP VIEW Salaries
GO
CREATE VIEW Salaries AS
	SELECT  id_bra, 
			ROUND(AVG(salary_base + ISNULL(salary_additional, 0)), 2) AS avg_salary,
			MIN(salary_base + ISNULL(salary_additional, 0)) AS min_salary,
			MAX(salary_base + ISNULL(salary_additional, 0)) AS max_salary,
			SUM(salary_base + ISNULL(salary_additional, 0)) AS salary_total,
			COUNT(salary_base) AS amount_of_salary,
			COUNT(salary_additional) AS amount_of_add_salary
	FROM dbo.Employed
	GROUP BY id_bra
GO

--4
SELECT e.last_name, e.salary_base + ISNULL(e.salary_additional, 0) AS salary, s.avg_salary
FROM dbo.Employed AS e
INNER JOIN Salaries AS s ON e.id_bra = s.id_bra
WHERE (e.salary_base + ISNULL(e.salary_additional, 0)) < s.avg_salary;

--5
IF OBJECT_ID('Best_base_salary', 'V') IS NOT NULL
DROP VIEW Best_base_salary
GO
CREATE VIEW Best_base_salary AS
	SELECT  e1.id_bra, e1.last_name, e1.salary_base
	FROM dbo.Employed AS e1
	WHERE e1.salary_base = (SELECT MAX(salary_base)
							FROM dbo.Employed AS e2
							WHERE e2.id_bra = e1.id_bra
							)

GO

--6
IF OBJECT_ID('Worst_salary', 'V') IS NOT NULL
DROP VIEW Worst_salary
GO
CREATE VIEW Worst_salary AS
	SELECT  id_bra, last_name, salary_base
	FROM dbo.Employed
	WHERE salary_base < 1500
	WITH CHECK OPTION
GO

--7 failed because of 'with check option'
UPDATE Worst_salary
SET salary_base = 1700
WHERE last_name = 'URBANIAK'

--8
IF OBJECT_ID('Earnings', 'V') IS NOT NULL
DROP VIEW Earnings
GO
CREATE VIEW Earnings 
WITH ENCRYPTION 
AS
	SELECT 
		e1.id, 
		e1.last_name, 
		e1.salary_base, 
		e1.manager, 
		e2.last_name AS manager_name, 
		e2.salary_base AS manager_salary
	FROM dbo.Employed AS e1
	INNER JOIN dbo.Employed AS e2
	ON e1.manager = e2.id
	WHERE e1.salary_base < e2.salary_base
	WITH CHECK OPTION
GO