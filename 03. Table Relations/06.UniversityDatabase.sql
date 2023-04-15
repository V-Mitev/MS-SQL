CREATE DATABASE [University]

USE [University]

CREATE TABLE [Majors](
	[MajorID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] INT NOT NULL,
	[StudentName] NVARCHAR(50) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors]([MajorID]) NOT NULL
)

CREATE TABLE [Subjects](
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[SubjectName] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Payments](
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATE,
	[PaymentAmount] DECIMAL(6, 2),
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL
)

CREATE TABLE [Agenda](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects]([SubjectID])
	PRIMARY KEY ([StudentID], [SubjectID])
)