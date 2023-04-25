CREATE DATABASE [Accounting]

USE [Accounting]

-- Problem 01. DDL

CREATE TABLE [Countries]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE [Addresses]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(20) NOT NULL,
	[StreetNumber] INT,
	[PostCode] INT NOT NULL,
	[City] VARCHAR(25) NOT NULL,
	[CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) NOT NULL
)

CREATE TABLE [Vendors]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
)

CREATE TABLE [Clients]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	[NumberVAT] NVARCHAR(15) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
)

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL,
)

CREATE TABLE [Products]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	[Price] DECIMAL(18, 2) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[VendorId] INT FOREIGN KEY REFERENCES [Vendors]([Id]) NOT NULL
)

CREATE TABLE [Invoices]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Number] INT UNIQUE NOT NULL,
	[IssueDate] DATETIME2 NOT NULL,
	[DueDate] DATETIME2 NOT NULL,
	[Amount] DECIMAL(18, 2) NOT NULL,
	[Currency] VARCHAR(5) NOT NULL,
	[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
)

CREATE TABLE [ProductsClients]
(
	[ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]) NOT NULL,
	[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
	PRIMARY KEY([ProductId], [ClientId])
)

-- Problem 02. Insert

INSERT INTO [Products]([Name], [Price], [CategoryId], [VendorId])
	 VALUES
('SCANIA Oil Filter XD01', 78.69, 1, 1),
('MAN Air Filter XD01', 97.38, 1, 5),
('DAF Light Bulb 05FG87', 55.00, 2, 13),
('ADR Shoes 47-47.5', 49.85, 3, 5),
('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO [Invoices]([Number], [IssueDate], [DueDate], [Amount], [Currency], [ClientId])
	 VALUES
(1219992181, '2023-03-01', '2023-04-30', 180.96, 'BGN', 3),
(1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
(1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD', 19)

-- Problem 03. Update

UPDATE [Invoices]
   SET [DueDate] = '2023-04-01'
 WHERE DATEPART(MONTH, [IssueDate]) = 11 AND DATEPART(YEAR, [IssueDate]) = 2022

UPDATE [Clients]
   SET [AddressId] = 3
 WHERE [Name] LIKE('%CO%')

-- Probelm 04. Delete

DELETE 
  FROM [ProductsClients]
 WHERE [ClientId] = (
						SELECT [Id]
						  FROM [Clients]
						 WHERE [NumberVAT] LIKE('IT%')
					)

DELETE 
  FROM [Invoices]
 WHERE [ClientId] = (
						SELECT [Id]
						  FROM [Clients]
						 WHERE [NumberVAT] LIKE('IT%')
					)

DELETE 
  FROM [Clients]
 WHERE [NumberVAT] LIKE('IT%')

-- Problem 05. Invoices by Amount and Date

  SELECT [Number],
		 [Currency]
    FROM [Invoices]
ORDER BY [Amount] DESC, [DueDate]

-- Problem 06. Products by Category

    SELECT [p].[Id],
		   [p].[Name],
	       [p].[Price],
		   [c].[Name]
      FROM [Products] AS [p]
INNER JOIN [Categories] AS [c]
		ON [p].[CategoryId] = [c].[Id]
	 WHERE [c].[Name] IN ('ADR', 'Others')
  ORDER BY [p].[Price] DESC

-- Probelm 07. Clients without Products

   SELECT [c].[Id],
		  [c].[Name],
		  CONCAT([a].[StreetName], ' ', [a].[StreetNumber], ', ', [a].[City],', ', 
		  [a].[PostCode], ', ', [cou].[Name])
	   AS [Address]
     FROM [Clients] AS [c]
LEFT JOIN [ProductsClients] AS [pc]
	   ON [c].[Id] = [pc].ClientId
INNER JOIN [Addresses] AS [a]
		ON [c].[AddressId] = [a].[Id]
INNER JOIN [Countries] AS [cou]
		ON [a].CountryId = [cou].[Id]
    WHERE [pc].ProductId IS NULL
 ORDER BY [c].[Name]

-- Problem 08. First 7 Invoices

	SELECT 
	TOP(7) [Number],
		   [Amount],
		   [c].[Name]
	  FROM [Invoices] AS [i]
INNER JOIN [Clients] AS [c]
		ON [i].[ClientId] = [c].[Id]
	 WHERE YEAR([IssueDate]) < 2023 AND 
		   [Currency] = 'EUR' OR [Amount] > 500 AND
		   [c].NumberVAT LIKE('DE%')

-- Problem 09. Clients with VAT

	SELECT [c].[Name] AS [Client],
		   MAX([p].[Price]) AS [Price],
		   [c].[NumberVAT] AS [VAT Number]
	  FROM [Clients] AS [c]
INNER JOIN [ProductsClients] AS [pc]
		ON [c].[Id] = [pc].[ClientId]
INNER JOIN [Products] AS [p]
		ON [pc].ProductId = [p].[Id]
     WHERE [c].[Name] NOT LIKE('%KG')
  GROUP BY [c].[Name], [c].[NumberVAT]
  ORDER BY MAX([p].[Price]) DESC

-- Problem 10. Clients by Price

    SELECT [c].[Name] AS [Client],
		   CAST(ROUND(AVG(FLOOR([p].[Price])), 0) AS INT) AS [Average Price]
      FROM [Clients] AS [c]
INNER JOIN [ProductsClients] AS [pc]
	    ON [c].[Id] = [pc].ClientId
INNER JOIN [Products] AS [p]
	    ON [pc].[ProductId] = [p].[Id]
INNER JOIN [Vendors] AS [v]
		ON [p].[VendorId]= [v].[Id]
	 WHERE [v].[NumberVAT] LIKE('%FR%')
  GROUP BY [c].[Name]
  ORDER BY [Average Price], [c].[Name] DESC

-- Problem 11. Product with Clients
GO

CREATE FUNCTION udf_ProductWithClients(@name VARCHAR(50))
RETURNS INT
AS
BEGIN
		DECLARE @countOfProducts INT = (
											    SELECT COUNT([pc].ClientId) AS [a]
											      FROM [Clients] AS [c]
											INNER JOIN [ProductsClients] AS [pc]
													ON [c].Id = [pc].[ClientId]
											INNER JOIN [Products] AS [p]
													ON [pc].[ProductId] = [p].[Id]
												 WHERE [p].[Name] = @name
										)
		RETURN @countOfProducts
END

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

-- Problem 12. Search for Vendors from a Specific Country
GO

CREATE PROCEDURE usp_SearchByCountry @country NVARCHAR(50)
AS
BEGIN
			SELECT [v].[Name] AS [Vendor],
				   [v].[NumberVAT] AS [VAT],
				   CONCAT([a].[StreetName], ' ', [a].[StreetNumber]) AS [Street Info],
				   CONCAT([a].[City], ' ', [a].[PostCode]) AS [City Info]
			  FROM [Vendors] AS [v]
		INNER JOIN [Addresses] AS [a]
				ON [v].[AddressId] = [a].Id
		INNER JOIN [Countries] AS [c]
				ON [a].[CountryId] = [c].[Id]
			 WHERE [c].[Name] = @country
END

EXEC usp_SearchByCountry 'France'