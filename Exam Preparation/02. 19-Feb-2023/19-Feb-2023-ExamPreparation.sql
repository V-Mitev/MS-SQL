CREATE DATABASE [Boardgames]

USE [Boardgames]

-- Problem 01. DDL

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[StreetName] NVARCHAR(100) NOT NULL,
	[StreetNumber] INT NOT NULL,
	[Town] VARCHAR(30) NOT NULL,
	[Country] VARCHAR(50) NOT NULL,
	[ZIP] INT NOT NULL
)

CREATE TABLE [Publishers]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	[AddressId] INT FOREIGN KEY REfERENCES [Addresses]([Id]) NOT NULL,
	[Website] NVARCHAR(40),
	[Phone] NVARCHAR(20)
)

CREATE TABLE [PlayersRanges]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[PlayersMin] INT NOT NULL,
	[PlayersMax] INT NOT NULL
)

CREATE TABLE [Boardgames]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	[YearPublished] INT NOT NULL,
	[Rating] DECIMAL(4,2) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[PublisherId] INT FOREIGN KEY REFERENCES [Publishers]([Id]) NOT NULL,
	[PlayersRangeId] INT FOREIGN KEY REFERENCES [PlayersRanges]([Id]) NOT NULL
)

CREATE TABLE [Creators]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[Email] NVARCHAR(30) NOT NULL
)

CREATE TABLE [CreatorsBoardgames]
(
	[CreatorId] INT FOREIGN KEY REFERENCES [Creators](Id) NOT NULL,
	[BoardgameId] INT FOREIGN KEY REFERENCES [Boardgames](Id) NOT NULL
	PRIMARY KEY([CreatorId], [BoardgameId])
)

-- Problem 02. Insert

INSERT INTO [Boardgames]([Name], [YearPublished], [Rating], [CategoryId], [PublisherId], [PlayersRangeId])
	 VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7,	1, 5),
('Catan: Starfarers', 2021,	9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO [Publishers]([Name], [AddressId], [Website], [Phone])
	 VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7,	'www.amethystgames.com', '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

-- Problem 03. Update

UPDATE [PlayersRanges]
SET [PlayersMax] += 1
WHERE [Id] = 1

UPDATE [Boardgames]
SET [Name] = [Name] + 'V2'
WHERE [YearPublished] >= 2020

-- Problem 04. Delete

DELETE 
  FROM [CreatorsBoardgames]
 WHERE [BoardgameId] IN (
							SELECT [Id]
							  FROM [Boardgames]
							 WHERE [PublisherId] IN (1, 16)
					    )

DELETE
  FROM [Boardgames]
 WHERE [PublisherId] IN (1, 16)

DELETE
  FROM [Publishers]
 WHERE [AddressId] = (
						SELECT [Id] 
						  FROM [Addresses] 
						 WHERE [Town] LIKE ('L%')
					 )

DELETE 
  FROM [Addresses]
 WHERE [Town] LIKE ('L%')

-- Problem 05. Boardgames by Year of Publication

  SELECT [Name],
		 [Rating]
	FROM [Boardgames]
ORDER BY [YearPublished], [Name] DESC

-- Problem 06. Boardgames by Category

    SELECT [b].[Id],
		   [b].[Name],
		   [b].[YearPublished],
		   [c].[Name]
      FROM [Boardgames] [b]
INNER JOIN [Categories] AS [c]
		ON [b].[CategoryId] = [c].[Id]
     WHERE [c].[Name] IN ('Strategy Games', 'Wargames')
  ORDER BY [b].[YearPublished] DESC

-- Problem 07. Creators without Boardgames

   SELECT [c].[Id],
		  CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [CreatorName],
		  [c].[Email]
     FROM [Creators] AS [c]
LEFT JOIN [CreatorsBoardgames] AS [cb]
	   ON [c].[Id] = [cb].[CreatorId]
LEFT JOIN [Boardgames] AS [b]
	   ON [cb].[BoardgameId] = [b].[Id]
    WHERE [b].[Id] IS NULL
 ORDER BY [c].[FirstName]

-- Problem 08. First 5 Boardgames

    SELECT 
	TOP(5) [b].[Name],
		   [b].[Rating],
		   [c].[Name]
      FROM [Boardgames] AS [b]
INNER JOIN [PlayersRanges] AS [p]
		ON [b].[PlayersRangeId] = [p].[Id]
INNER JOIN [Categories] AS [c]
		ON [b].[CategoryId] = [c].[Id]
     WHERE [Rating] > 7.00 AND [b].[Name] LIKE('%a%') OR [Rating] > 7.50 AND 
	       [p].[PlayersMin] = 2 AND [p].[PlayersMax] = 5
  ORDER BY [b].[Name], [b].[Rating] DESC

-- Problem 09. Creators with Emails

    SELECT CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [FullName],
	       [c].[Email],
	       MAX([b].[Rating]) AS [Rating]
      FROM [Creators] AS [c]
INNER JOIN [CreatorsBoardgames] AS [cb]
		ON [c].[Id] = [cb].CreatorId
INNER JOIN [Boardgames] AS [b]
		ON [cb].[BoardgameId] = [b].[Id]
     WHERE [Email] LIKE('%.com')
  GROUP BY [c].[FirstName], [c].[LastName], [c].[Email]
  ORDER BY [FullName]

-- Problem 10. Creators by Rating

    SELECT [c].[LastName] ,
		   CEILING(AVG([b].[Rating])) AS [AverageRating],
		   [p].[Name] AS [PublisherName]
      FROM [Creators] AS [c]
INNER JOIN [CreatorsBoardgames] AS [cb]
		ON [c].[Id] = [cb].[CreatorId]
INNER JOIN [Boardgames] AS [b]
		ON [cb].[BoardgameId] = [b].[Id]
INNER JOIN [Publishers] AS [p]
		ON [b].[PublisherId] = [p].[Id]
	 WHERE [p].[Name] = 'Stonemaier Games'
  GROUP BY [c].[LastName], [p].[Name]
  ORDER BY AVG([b].[Rating]) DESC

-- Problem 11. Creator with Boardgames
GO

CREATE FUNCTION udf_CreatorWithBoardgames(@name VARCHAR(30))
RETURNS INT
AS
BEGIN 
		DECLARE @creatorsBoardgamesCount INT = (
													  SELECT COUNT([b].[Id]) AS [count]
														FROM [Creators] AS [c]
												  INNER JOIN [CreatorsBoardgames] AS [cb]
														  ON [c].[Id] = [cb].[CreatorId]
												  INNER JOIN [Boardgames] AS [b]
														  ON [cb].[BoardgameId] = [b].[Id]
													   WHERE [c].[FirstName] = @name
			                                   )

		RETURN @creatorsBoardgamesCount
END

GO

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

-- Problem 12. Search for Boardgame with Specific Category
GO

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(30))
AS
BEGIN
		SELECT [b].[Name],
		       [b].[YearPublished],
			   [b].[Rating],
			   [c].[Name] AS [CategoryName],
			   [p].[Name] AS [PublisherName],
			   CONCAT([pr].[PlayersMin], ' people') AS [MinPlayers],
			   CONCAT([pr].[PlayersMax], ' people') AS [MaxPlayers]
		  FROM [Boardgames] [b]
		  LEFT JOIN [Categories] AS [c]
				 ON [b].[CategoryId] = [c].[Id]
		  LEFT JOIN [Publishers] AS [p]
				 ON [b].[PublisherId] = [p].[Id]
		  LEFT JOIN [PlayersRanges] AS [pr]
				 ON [b].[PlayersRangeId] = [pr].[Id]
			  WHERE [c].[Name] = @category
		   ORDER BY [p].[Name], [b].[YearPublished] DESC

END

EXEC usp_SearchByCategory 'Wargames'