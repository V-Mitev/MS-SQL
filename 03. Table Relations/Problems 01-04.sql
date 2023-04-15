CREATE DATABASE [EntityRelations]

-- Problem 01

CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
	[PassportNumber] VARCHAR(10)
)

CREATE TABLE [Persons](
	[PersonID] INT IDENTITY,
	[FirstName] NVARCHAR(30),
	[Salary] DECIMAL(8, 2),
	[PassportID] INT
)

INSERT [Passports](PassportNumber)
	VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO [Persons]([FirstName], [Salary], [PassportID])
		VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)

ALTER TABLE [Persons]
ADD PRIMARY KEY ([PersonID])

ALTER TABLE [Persons]
ADD FOREIGN KEY ([PassportID]) REFERENCES [Passports]([PassportID])

-- Problem 02

CREATE TABLE [Manufacturers](
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models](
	[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR (30) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID])
)

INSERT INTO [Manufacturers]([Name], [EstablishedOn])
	VALUES
('BMW', '1916-03-07'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01')

INSERT INTO [Models]([Name], [ManufacturerID])
	VALUES
('X6', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

-- Problem 03

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE [Exams](
	[ExamID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE [StudentsExams](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID])
	PRIMARY KEY ([StudentID], [ExamID])
)

INSERT INTO [Students]([Name])
		VALUES
('Mila'),
('Toni'),
('Ron')

INSERT INTO [Exams]([Name])
		VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO [StudentsExams]([StudentID], [ExamID])
     VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

-- Problem 04

CREATE TABLE [Teachers](
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(30) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

INSERT INTO [Teachers]([Name], [ManagerID])
	 VALUES
('John', NULL),
('Maya', 106),
('Silivia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

-- Problem 05

CREATE DATABASE [Store]

USE [Store]

CREATE TABLE [Cities](
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Customers](
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	[Birthday] DATE,
	[CityID] INT FOREIGN KEY REFERENCES [Cities]([CityId])
)

CREATE TABLE [Orders](
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers]([CustomerID]) NOT NULL
)

CREATE TABLE [ItemTypes](
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Items](
	[ItemID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [OrderItems](
	[OrderID] INT FOREIGN KEY REFERENCES [Orders]([OrderID]),
	[ItemID] INT FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID])
	PRIMARY KEY ([OrderID], [ItemID])
)