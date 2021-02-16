--1
IF OBJECT_ID('dbo.Employed', 'U') IS NOT NULL
DROP TABLE dbo.Employed
GO

SELECT * INTO dbo.Employed
FROM dbo.Employees
GO

--2
IF OBJECT_ID('pay_rise', 'P') IS NOT NULL
DROP PROCEDURE pay_rise
GO

CREATE PROCEDURE pay_rise 
	@branch SMALLINT, 
	@percent REAL = 15
AS
	UPDATE dbo.Employed
	SET salary_base = salary_base * (1 + @percent/100)
	WHERE id_bra = @branch
GO

-- Test
BEGIN TRAN
SELECT TOP 5 salary_base, * FROM dbo.Employed
EXEC pay_rise 10, 20
SELECT TOP 5 salary_base, * FROM dbo.Employed
ROLLBACK

--3
IF OBJECT_ID('pay_rise', 'P') IS NOT NULL
DROP PROCEDURE pay_rise
GO

CREATE PROCEDURE pay_rise 
	@branch SMALLINT, 
	@percent REAL = 15
AS
	IF (SELECT COUNT(*) FROM dbo.Employed WHERE id_bra = @branch) = 0
		RAISERROR(N'Invalid branch ID: %d', 16, 1, @branch)

	UPDATE dbo.Employed
	SET salary_base = salary_base * (1 + @percent/100)
	WHERE id_bra = @branch
GO

-- Test
BEGIN TRAN
SELECT TOP 5 salary_base, * FROM dbo.Employed

BEGIN TRY
	EXEC pay_rise 11, 25
	SELECT TOP 5 salary_base, * FROM dbo.Employed
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS errornumber,
		ERROR_MESSAGE() AS errormessage;
END CATCH
ROLLBACK

--4
IF OBJECT_ID('num_of_emp', 'P') IS NOT NULL
DROP PROCEDURE num_of_emp
GO

CREATE PROCEDURE num_of_emp
	@branch SMALLINT,
	@num SMALLINT OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT id FROM dbo.Branches WHERE id = @branch)
		RAISERROR(N'Invalid branch ID: %d', 16, 1, @branch)
	BEGIN TRY
		SET @num = (SELECT COUNT(*) FROM dbo.Employed WHERE id_bra = @branch)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS errornumber,
			ERROR_MESSAGE() AS errormessage
	END CATCH
END
GO

-- Test
DECLARE @branch INT
DECLARE @num INT

SET @branch=20

BEGIN TRY
	EXEC num_of_emp @branch, @num OUTPUT
	PRINT 'Number of employees in branch ' + CAST(@branch AS VARCHAR(2)) + ' is ' + CAST(@num AS VARCHAR(10))
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS errornumber,
		ERROR_MESSAGE() AS errormessage
END CATCH

--5
IF OBJECT_ID('new_employee', 'P') IS NOT NULL
DROP PROCEDURE new_employee
GO

CREATE PROCEDURE new_employee
	@last_name VARCHAR(15),
	@position VARCHAR(20),
	@manager_name VARCHAR(15),
	@hired DATE,
	@salary_base MONEY,
	@branch INT
AS
DECLARE @manager_id INT
DECLARE @new_id INT

	SET @manager_id = (SELECT id FROM dbo.Employed WHERE last_name = @manager_name)
	SET @new_id = (SELECT ISNULL(MAX(id), 0)+10 FROM dbo.Employed)

	IF EXISTS (SELECT id FROM dbo.Employed WHERE last_name = @last_name)
	BEGIN
		RAISERROR(N'Employee of name %s exists.', 16, 1, @last_name)
		GOTO ProcEnd
	END

	IF NOT EXISTS (SELECT id FROM dbo.Employed WHERE manager = @manager_id)
	BEGIN
		RAISERROR(N'Invalid manager name: %s', 16, 1, @manager_name)
		GOTO ProcEnd
	END

	IF NOT EXISTS (SELECT id FROM dbo.Branches WHERE id = @branch)
	BEGIN
		RAISERROR(N'Invalid branch ID: %d', 16, 1, @branch)
		GOTO ProcEnd
	END

	INSERT INTO dbo.Employed (id, last_name, id_bra, position, manager, hired, salary_base)
	VALUES (@new_id, @last_name, @branch, @position, @manager_id, @hired, @salary_base)

ProcEnd:
GO

-- Test
BEGIN TRAN
SELECT TOP 5 * FROM dbo.Employed WHERE last_name LIKE 'B%'

BEGIN TRY
	--1. Error - name exists
	--EXEC new_employee 'BARTCZAK', 'FOREMAN', 'NOWAK', '2021-02-01', 1200.00, 99
	--2. Error - invalid manager
	--EXEC new_employee 'BANAS', 'FOREMAN', 'NOWAK', '2021-02-01', 1200.00, 99
	--3. Error - invalid branch
	--EXEC new_employee 'BANAS', 'FOREMAN', 'BRZEZINSKI', '2021-02-01', 1200.00, 99
	--4. Valid parameters
	EXEC new_employee 'BANAS', 'FOREMAN', 'BRZEZINSKI', '2021-02-01', 1200.00, 10

	SELECT TOP 5 * FROM dbo.Employed WHERE last_name LIKE 'B%'
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS errornumber,
		ERROR_MESSAGE() AS errormessage
END CATCH
ROLLBACK

--6
IF OBJECT_ID('net_salary', 'FN') IS NOT NULL
DROP FUNCTION net_salary
GO

CREATE FUNCTION net_salary (
	@gross_salary DECIMAL(19,4),
	@tax DECIMAL(19,4)
)
RETURNS DECIMAL(19,4)
AS
BEGIN
	DECLARE @net DECIMAL(19,4)
			SET @net = @gross_salary/(1+@tax/100)
	RETURN @net
END;
GO

-- Test
SELECT dbo.net_salary(1230, 23);

--7
IF OBJECT_ID('factorial', 'FN') IS NOT NULL
DROP FUNCTION factorial
GO

CREATE FUNCTION factorial (
	@n INT
)
RETURNS INT
AS
BEGIN
	DECLARE @result INT
	DECLARE @i INT
	SET @i=1
	WHILE @i <= @n
	BEGIN
		IF @i = 1
			SET @result = 1
		ELSE
			SET @result = @result * @i
		SET @i = @i + 1
	END
	RETURN @result
END;
GO

-- Test
SELECT dbo.factorial(1), dbo.factorial(2), dbo.factorial(3), 
	dbo.factorial(4), dbo.factorial(5), dbo.factorial(6);

--8
IF OBJECT_ID('years_of_work', 'FN') IS NOT NULL
DROP FUNCTION years_of_work
GO

CREATE FUNCTION years_of_work (
	@date DATETIME
)
RETURNS INT
AS
BEGIN
	DECLARE @years INT
		SET @years = DATEDIFF(year, @date, GETDATE())
	RETURN @years
END;
GO

-- Test
SELECT last_name, hired, dbo.years_of_work(hired) AS years
FROM dbo.Employed;

--9
IF OBJECT_ID('manager_tr', 'TR') IS NOT NULL
DROP TRIGGER manager_tr
GO

CREATE TRIGGER manager_tr 
	ON dbo.Employed
	FOR DELETE
AS
BEGIN
	UPDATE dbo.Employed
	SET manager = NULL
	WHERE manager IN (SELECT id FROM deleted)
END;
GO

-- Test
BEGIN TRAN
	SELECT * FROM dbo.Employed
	WHERE manager IS NULL OR manager IN ('110', '120');

	DELETE FROM dbo.Employed WHERE ID='120';

	SELECT * FROM dbo.Employed
	WHERE manager IS NULL OR manager IN ('110', '120');
ROLLBACK

--10
IF OBJECT_ID('dbo.History', 'U') IS NOT NULL
DROP TABLE dbo.History
GO

CREATE TABLE dbo.History (
	id_his INT IDENTITY(1,1),
	[type] VARCHAR(3),
	id INT,
	last_name VARCHAR(15),
	salary_base DECIMAL(10,2),
	position VARCHAR(20),
	id_branch INT,
	sysdate DATETIME DEFAULT GETDATE(),
	[user] VARCHAR(30) DEFAULT SUSER_SNAME()
);
GO

IF OBJECT_ID('trace', 'TR') IS NOT NULL
DROP TRIGGER trace
GO

CREATE TRIGGER trace 
	ON dbo.Employees
	FOR INSERT, UPDATE, DELETE
AS
BEGIN
	IF EXISTS (SELECT id FROM inserted)
	BEGIN
		-- old value
		IF EXISTS (SELECT id FROM deleted)
		BEGIN
			INSERT INTO dbo.History ([type], id, last_name, salary_base, position, id_branch)
			SELECT 'Old', id, last_name, salary_base, position, id_bra
			FROM deleted
		END

		--new value
		INSERT INTO dbo.History ([type], id, last_name, salary_base, position, id_branch)
		SELECT 'New', id, last_name, salary_base, position, id_bra
		FROM inserted
	END 
	ELSE BEGIN
		--deleted value
		IF EXISTS (SELECT id FROM deleted)
		BEGIN
			INSERT INTO dbo.History ([type], id, last_name, salary_base, position, id_branch)
			SELECT 'Del', id, last_name, salary_base, position, id_bra
			FROM deleted
		END
	END
END
GO

-- Test
BEGIN TRAN
	SELECT * FROM dbo.History;

	UPDATE dbo.Employees
	SET salary_base = 3800
	WHERE last_name = 'KOWAL';
	
	DELETE FROM dbo.Employees
	WHERE last_name = 'BOGULA';

	SELECT * FROM dbo.History;
ROLLBACK