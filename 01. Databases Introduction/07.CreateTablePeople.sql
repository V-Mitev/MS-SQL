CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)

INSERT INTO [People]([Name], [Height], [Weight], [Gender], [Birthdate])
VALUES
('Pesho', 1.77, 75.2, 'm', '1998-05-25'),
('Gosho', NULL, NULL, 'm', '1977-07-20'),
('Maria', 1.65, 49.5, 'f', '1987-07-29'),
('Geri', 1.80, 55, 'f', '1990-05-13'),
('Lili', 1.70, 61, 'f', '1999-01-31')
