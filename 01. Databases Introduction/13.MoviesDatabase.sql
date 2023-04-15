CREATE DATABASE [Movies]

CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY IDENTITY,
	[DirectorName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Directors]([DirectorName], [Notes])
	 VALUES
	 ('Steven', NULL),
	 ('Peter', NULL),
	 ('Bob', NULL),
	 ('Frank', NULL),
	 ('Samuel', NULL)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Genres]([GenreName], [Notes])
	 VALUES
	 ('Thriller', NULL),
	 ('Comedy', NULL),
	 ('Romantic', NULL),
	 ('Fantasy', NULL),
	 ('Drama', NULL)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Categories]([CategoryName], [Notes])
	 VALUES
	 ('A', NULL),
	 ('B', NULL),
	 ('C', NULL),
	 ('D', NULL),
	 ('TBC', NULL)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] NVARCHAR(50) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]) NOT NULL,
	[CopyrightYear] INT NOT NULL,
	[Length] TIME,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]) NOT NULL,
	[Rating] DECIMAL(2, 1),
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Movies]([Title], [DirectorId], [CopyrightYear], [GenreId], [Rating])
	 VALUES
	 ('FilmA', 3, 1999, 2, 5.0),
	 ('FilmB', 1, 1977, 2, 4.0),
	 ('FilmC', 2, 2020, 2, 4.5),
	 ('FilmD', 5, 2015, 2, 3.3),
	 ('FilmE', 3, 1998, 2, 3.9)
