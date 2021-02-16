--1
IF DB_ID('School') IS NOT NULL
DROP DATABASE School
GO

IF DB_ID('School') IS NULL
CREATE DATABASE School
GO

USE School;

IF OBJECT_ID('Subjects', 'U') IS NOT NULL
DROP TABLE Subjects

IF OBJECT_ID('Teachers', 'U') IS NOT NULL
DROP TABLE Teachers

IF OBJECT_ID('Schools', 'U') IS NOT NULL
DROP TABLE Schools

IF OBJECT_ID('Staff', 'U') IS NOT NULL
DROP TABLE Staff

IF OBJECT_ID('Jobs', 'U') IS NOT NULL
DROP TABLE Jobs

IF OBJECT_ID('Branches', 'U') IS NOT NULL
DROP TABLE Branches

GO

--2
IF OBJECT_ID('Schools', 'U') IS NULL
CREATE TABLE Schools
(
	id_school		INT IDENTITY(1,1) PRIMARY KEY,
	name			VARCHAR(30) NOT NULL,
	city			VARCHAR(30) NOT NULL,
);

--3
IF OBJECT_ID('Teachers', 'U') IS NULL
CREATE TABLE Teachers
(
	id_teacher		INT IDENTITY(1,1) PRIMARY KEY,
	first_name		VARCHAR(30) NOT NULL,
	last_name		VARCHAR(30) NOT NULL,
	birth_date		DATE NOT NULL,
	salary			SMALLMONEY NOT NULL
);

--4
IF OBJECT_ID('Subjects', 'U') IS NULL
CREATE TABLE Subjects
(
	id_subject		INT IDENTITY(1,1) PRIMARY KEY,
	name			VARCHAR(30) NOT NULL,
	id_school		INT NOT NULL,
	id_teacher		INT NOT NULL,
	FOREIGN KEY (id_school) REFERENCES Schools(id_school),
	FOREIGN KEY (id_teacher) REFERENCES Teachers(id_teacher)
);

--5
IF OBJECT_ID('Branches', 'U') IS NULL
CREATE TABLE Branches
(
	id_branch		INT PRIMARY KEY,
	name			VARCHAR(30) NOT NULL,
	address			VARCHAR(100) NOT NULL
);

--6
IF OBJECT_ID('Jobs', 'U') IS NULL
CREATE TABLE Jobs
(
	id_job			INT PRIMARY KEY,
	salary_min		MONEY NOT NULL,
	salary_max		MONEY NOT NULL, 
	CHECK (salary_max > salary_min)
);

--7
IF OBJECT_ID('Staff', 'U') IS NULL
CREATE TABLE Staff
(
	id_staff		INT PRIMARY KEY,
	first_name		VARCHAR(30) NOT NULL,
	last_name		VARCHAR(30) NOT NULL,
	id_job			INT NOT NULL,
	manager			INT NOT NULL,
	hired			DATE NOT NULL,
	id_branch		INT NOT NULL,
	FOREIGN KEY (id_job) REFERENCES Jobs(id_job),
	FOREIGN KEY (id_branch) REFERENCES Branches(id_branch)
);

--8
IF OBJECT_ID('Jobs', 'U') IS NOT NULL
IF COL_LENGTH('Jobs', 'requirements') IS NULL
	ALTER TABLE Jobs
	ADD requirements VARCHAR(255);

--9
IF OBJECT_ID('Staff', 'U') IS NOT NULL
IF COL_LENGTH('Staff', 'ssn') IS NULL
	ALTER TABLE Staff
	ADD ssn VARCHAR(11);

--10 only numbers
IF OBJECT_ID('Staff', 'U') IS NOT NULL
IF COL_LENGTH('Staff', 'ssn') IS NOT NULL
IF OBJECT_ID('ct_ssn', 'C') IS NULL
	ALTER TABLE Staff
	ADD CONSTRAINT ct_ssn CHECK(ssn NOT LIKE '%[^0-9]%');

--11
IF OBJECT_ID('Jobs', 'U') IS NOT NULL
IF COL_LENGTH('Jobs', 'requirements') IS NOT NULL
	ALTER TABLE Jobs
	DROP COLUMN requirements;