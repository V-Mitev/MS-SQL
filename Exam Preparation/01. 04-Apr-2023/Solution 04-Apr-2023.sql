CREATE DATABASE Accounting

USE Accounting

-- Problem 01. DDL

CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(10) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(20) NOT NULL,
	StreetNumber INT,
	PostCode INT NOT NULL,
	City NVARCHAR(25) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Vendors
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)


CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(10) NOT NULL
)

CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	Price DECIMAL(18, 2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	VendorId INT FOREIGN KEY REFERENCES Vendors(Id) NOT NULL
)

CREATE TABLE Invoices
(
	Id INT PRIMARY KEY IDENTITY,
	Number INT NOT NULL UNIQUE,
	IssueDate DATETIME2 NOT NULL,
	DueDate DATETIME2 NOT NULL,
	Amount DECIMAL(18, 2) NOT NULL,
	Currency NVARCHAR(5) NOT NULL,
	ClientId INT FOREIGN KEY REFERENCES Clients(Id) NOT NULL
)

CREATE TABLE ProductsClients
(
	ProductId INT FOREIGN KEY REFERENCES Products(Id) NOT NULL,
	ClientId INT FOREIGN KEY REFERENCES Clients(Id) NOT NULL,
	PRIMARY KEY(ProductId, ClientId)
)

-- Problem 02. Insert

INSERT INTO Products([Name], Price, [CategoryId], [VendorId])
	 VALUES
('SCANIA Oil Filter XD01' ,78.69, 1, 1),
('MAN Air Filter XD01', 97.38, 1, 5),
('DAF Light Bulb 05FG87', 55.00, 2, 13),
('ADR Shoes 47-47.5', 49.85, 3,	5),
('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO Invoices(Number, IssueDate, DueDate, Amount, Currency, ClientId)
	 VALUES
(1219992181, '2023-03-01', '2023-04-30', 180.96 , 'BGN', 3),
(1729252340, '2022-11-06', '2023-01-04' ,158.18, 'EUR',13),
(1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD',19)

-- 03. Update

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE Year(IssueDate) = 2022 AND Month(IssueDate) = 11

UPDATE Clients
SET AddressId = 3
WHERE [Name] LIKE '%CO%'

-- 04. Delete

DELETE 
  FROM ProductsClients 
  WHERE ClientId =
					(
						SELECT Id FROM Clients WHERE NumberVAT LIKE('IT%')
					) 

DELETE 
  FROM Invoices 
 WHERE ClientId = 
					(
						SELECT Id FROM Clients WHERE NumberVAT LIKE('IT%')
					)

DELETE
  FROM Clients 
  WHERE NumberVAT LIKE('IT%')