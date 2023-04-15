CREATE DATABASE [Minions]

USE [Minions]

CREATE TABLE [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT NOT NULL
) 

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(30) NOT NULL
)

ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

INSERT INTO [Towns]([Id], [Name])
	 VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

-- Change the column Age in table Minions to be NULL 
ALTER TABLE [Minions]
ALTER COLUMN [Age] INT

INSERT INTO [Minions]([Id], [Name], [Age], [TownId])
	 VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

TRUNCATE TABLE [Minions]

DROP TABLE [Minions]
DROP TABLE [Towns]

SELECT * FROM [Minions]
SELECT * FROM [Towns]

