--1
SELECT last_name, position, id_bra
FROM dbo.Employees
WHERE id_bra = (
	SELECT id_bra
	FROM dbo.Employees
	WHERE last_name = 'Kowal');

--2
SELECT last_name, position, hired
FROM dbo.Employees
WHERE position = 'MANAGER' AND hired = (
	SELECT MIN(hired)
	FROM dbo.Employees
	WHERE position = 'MANAGER');

--3
SELECT e.last_name, e.hired, e.id_bra
FROM dbo.Employees AS e
INNER JOIN (SELECT id_bra, MAX(hired) AS hired
			FROM dbo.Employees
			GROUP BY id_bra) AS m
ON e.hired = m.hired AND e.id_bra = m.id_bra
ORDER BY e.hired ASC;

--4 branch without an employee
SELECT b.id, b.name
FROM dbo.Branches AS b
LEFT JOIN (SELECT DISTINCT id_bra
		   FROM dbo.Employees) AS e
ON b.id = e.id_bra
WHERE e.id_bra IS NULL;

--5
SELECT e1.last_name, e1.position, e1.salary_base, ROUND(e2.avg_salary, 2)
FROM dbo.Employees AS e1
INNER JOIN (SELECT AVG(salary_base) AS avg_salary, position
			FROM dbo.Employees
			GROUP BY position) AS e2
ON e1.position = e2.position
WHERE e1.salary_base > e2.avg_salary;

--6 employees who earn at least 75% of their manager's salary
SELECT e1.last_name, e1.position, e1.salary_base, e1.manager, e2.salary_base AS manager_salary
FROM dbo.Employees AS e1
INNER JOIN (SELECT id, last_name, salary_base
			FROM dbo.Employees) AS e2
ON e1.manager = e2.id
WHERE e1.salary_base >= (0.75 * e2.salary_base);

--7
SELECT last_name, position
FROM dbo.Employees 
WHERE id NOT IN (SELECT manager
				 FROM dbo.Employees
				 WHERE position = 'TRAINEE') 
AND position = 'MANAGER';

--8 branch without an employee (using correlated subquery)
SELECT b.id, b.name
FROM dbo.Branches AS b
WHERE NOT EXISTS (SELECT id_bra
	   FROM dbo.Employees
	   WHERE id_bra = b.id
	   GROUP BY id_bra);

--9
SELECT TOP 1 b.id, b.name, e.salary
FROM dbo.Branches AS b
INNER JOIN (SELECT id_bra, SUM(salary_base + ISNULL(salary_additional, 0)) AS salary
			FROM dbo.Employees
			GROUP BY id_bra) AS e
ON b.id = e.id_bra
ORDER BY e.salary DESC;

--10
SELECT YEAR(hired) AS 'year', COUNT(*) AS num_of_emp
FROM dbo.Employees
GROUP BY YEAR(hired)
ORDER BY 'year';

--11
SELECT TOP 1 YEAR(hired) AS 'year', COUNT(*) AS num_of_emp
FROM dbo.Employees
GROUP BY YEAR(hired)
ORDER BY num_of_emp DESC;

--12
SELECT e1.last_name, e1.position, e1.salary_base, e2.avg_salary
FROM dbo.Employees AS e1
INNER JOIN (SELECT position, ROUND(AVG(salary_base), 2) AS avg_salary
			FROM dbo.Employees
			GROUP BY position) AS e2
ON e1.position = e2.position
WHERE e1.salary_base < e2.avg_salary
ORDER BY e1.last_name;

--13
SELECT e1.last_name, e2.subordinates, b.name AS branch
FROM dbo.Employees AS e1
LEFT JOIN (SELECT manager, COUNT(*) AS subordinates
		   FROM dbo.Employees
		   GROUP BY manager) AS e2
ON e1.id = e2.manager
INNER JOIN dbo.Branches AS b
ON e1.id_bra = b.id
WHERE b.name = 'WARSAW'
AND e1.position = 'MANAGER';

--14
SELECT e1.last_name, e1.id_bra, b.name AS branch, e2.avg_salary, e2.max_salary
FROM dbo.Employees AS e1
INNER JOIN (SELECT id_bra, ROUND(AVG(salary_base), 2) AS avg_salary, MAX(salary_base) AS max_salary
		   FROM dbo.Employees
		   GROUP BY id_bra) AS e2
ON e1.id_bra = e2.id_bra
INNER JOIN dbo.Branches AS b
ON e1.id_bra = b.id
WHERE e1.position = 'MANAGER'
ORDER BY e1.last_name;

--15 direct and indirect subordinates of manager Brzezinski (version 1 - subqueries)
SELECT e1.id, e1.last_name, e1.manager AS direct_manager, '1' AS level
FROM dbo.Employees AS e1
INNER JOIN (SELECT id
			FROM dbo.Employees
			WHERE last_name = 'BRZEZINSKI') AS e2
ON e1.manager = e2.id
UNION ALL
SELECT e1.id, e1.last_name, e1.manager AS direct_manager, '2' AS level
FROM dbo.Employees AS e1
INNER JOIN (SELECT e2.id, e2.last_name, e2.manager
			FROM dbo.Employees AS e2
			INNER JOIN 
				(SELECT id
				FROM dbo.Employees
				WHERE last_name = 'BRZEZINSKI') AS e3
			ON e2.manager = e3.id) AS e4
ON e1.manager = e4.id;

--direct and indirect subordinates of manager Brzezinski (version 2 - recursive CTE)
WITH cte_emp AS (
	SELECT id, last_name, manager AS direct_manager, 1 AS level
	FROM dbo.Employees
	WHERE manager = (SELECT id
					FROM dbo.Employees
					WHERE last_name = 'BRZEZINSKI')
	UNION ALL
	SELECT e.id, e.last_name, e.manager, c.level+1
	FROM dbo.Employees AS e
	INNER JOIN cte_emp AS c
	ON c.id = e.manager
)
SELECT * FROM cte_emp
ORDER BY level;