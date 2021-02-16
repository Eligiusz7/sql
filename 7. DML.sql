USE Work;

--0
IF OBJECT_ID('Employed') IS NOT NULL
DROP TABLE Employed
SELECT * INTO Employed FROM dbo.Employees;

--1
UPDATE dbo.Employed
SET salary_base = 1600
WHERE id = 170;

--2
UPDATE dbo.Employed
SET hired = DATEADD(month, 1, hired), 
	id_bra = 10
WHERE id IN (140, 160);

--3
INSERT INTO dbo.Employed
VALUES (240, 'SHELBY', 'MANAGER', 110, '2021-01-01', 4300.00, 400.00, 130);

--4
UPDATE dbo.Employed
SET salary_base = salary_base + (0.1 * avg_salary)
FROM dbo.Employed AS e1
INNER JOIN (SELECT id_bra, AVG(salary_base) AS avg_salary
			FROM dbo.Employed
			GROUP BY id_bra) AS e2
ON e1.id_bra = e2.id_bra;

--5
UPDATE dbo.Employed
SET salary_additional = (SELECT AVG(salary_additional) AS avg_salary
						 FROM dbo.Employed
						 WHERE manager = 130)
WHERE id_bra = 20;

--6
UPDATE dbo.Employed
SET salary_base = (SELECT AVG(salary_base) AS avg_salary
				   FROM dbo.Employed)
WHERE id IN (SELECT id
			 FROM dbo.Employed
			 WHERE salary_base = (SELECT MIN(salary_base) FROM dbo.Employed))

--7
UPDATE dbo.Employed
SET salary_base = salary_base * 1.15
WHERE id IN (SELECT id
			 FROM dbo.Employed
			 WHERE DATEDIFF(year, hired, GETDATE()) > 30)

--8
DELETE FROM dbo.Employed
WHERE id IN (SELECT id FROM dbo.Employed WHERE id_bra = 10);

--9
DELETE FROM dbo.Employed
WHERE id IN (SELECT id 
			FROM dbo.Employed 
			WHERE manager IN 
				(SELECT id
				FROM dbo.Employed
				WHERE last_name IN ('BRZEZINSKI', 'MALINOWSKI')));
