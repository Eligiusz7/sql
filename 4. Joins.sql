--1
SELECT e.last_name, e.position, b.id, b.name
FROM dbo.Employees AS e
INNER JOIN dbo.Branches AS b ON e.id_bra = b.id
ORDER BY e.last_name ASC;

--2
SELECT e.last_name, e.position, b.id, b.name
FROM dbo.Employees AS e
INNER JOIN dbo.Branches AS b ON e.id_bra = b.id
WHERE b.name = 'WARSAW'
ORDER BY e.last_name ASC;

--3
SELECT e.last_name, b.name, b.address, e.position, e.salary_base
FROM dbo.Employees AS e
INNER JOIN dbo.Branches AS b ON e.id_bra = b.id
WHERE e.salary_base > 2500
ORDER BY e.salary_base ASC;

--4
SELECT e.last_name, p.position, e.salary_base, p.salary_min, p.salary_max
FROM dbo.Employees AS e
INNER JOIN dbo.Positions AS p ON e.position = p.position
ORDER BY last_name ASC;

--5
SELECT e.last_name, p.position, e.salary_base, p.salary_min, p.salary_max
FROM dbo.Employees AS e
INNER JOIN dbo.Positions AS p ON e.position = p.position
WHERE p.position = 'FOREMAN' AND (e.salary_base < p.salary_min OR e.salary_base > p.salary_max)
ORDER BY last_name ASC;

--6
SELECT e.last_name, e.position, b.name, e.salary_base
FROM dbo.Employees AS e
INNER JOIN dbo.Branches AS b ON e.id_bra = b.id
WHERE e.position != 'TRAINEE'
ORDER BY e.salary_base DESC;

--7
SELECT e.last_name, e.position, b.name, e.salary_base*12 AS annual_base_salary
FROM dbo.Employees AS e
INNER JOIN dbo.Branches AS b ON e.id_bra = b.id
WHERE (e.salary_base*12) > 15000
ORDER BY e.last_name ASC;

--8
SELECT e1.id, e1.last_name, e1.manager, e2.last_name AS manager_last_name
FROM dbo.Employees AS e1
INNER JOIN dbo.Employees AS e2 ON e1.manager = e2.id

--9
SELECT e1.id, e1.last_name, ISNULL(e1.manager, '') AS manager, ISNULL(e2.last_name, '') AS manager_last_name
FROM dbo.Employees AS e1
LEFT JOIN dbo.Employees AS e2 ON e1.manager = e2.id

--10
SELECT e.id_bra, b.name, COUNT(*) AS num_of_emp, ROUND(AVG(e.salary_base), 2) AS avg_sal_base
FROM dbo.Branches AS b
INNER JOIN dbo.Employees AS e ON b.id = e.id_bra
GROUP BY e.id_bra, b.name
ORDER BY e.id_bra;

--11
SELECT e2.last_name, COUNT(*) AS subordinates
FROM dbo.Employees AS e1
INNER JOIN dbo.Employees AS e2 ON e1.manager = e2.id
GROUP BY e2.last_name
ORDER BY subordinates DESC;

--12
SELECT e1.last_name, e1.hired, e2.last_name AS manager, e2.hired, DATEDIFF(month, e2.hired, e1.hired) AS diff
FROM dbo.Employees AS e1
INNER JOIN dbo.Employees AS e2 ON e1.manager = e2.id
WHERE DATEDIFF(day, e2.hired, e1.hired) < 3650;

--13
SELECT last_name, hired
FROM dbo.Employees
WHERE YEAR(hired) = 1992
UNION ALL
SELECT last_name, hired
FROM dbo.Employees
WHERE YEAR(hired) = 1993;

--14
SELECT last_name, hired
FROM dbo.Employees
WHERE YEAR(hired) = 1992 OR YEAR(hired) = 1993;

--15 branch without an employee
SELECT id
FROM dbo.Branches
EXCEPT
SELECT id_bra
FROM dbo.Employees;

--16 branch without an employee - left join
SELECT b.id
FROM dbo.Branches AS b
LEFT JOIN dbo.Employees AS e ON b.id = e.id_bra
WHERE e.id IS NULL;