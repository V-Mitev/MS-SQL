CREATE TABLE [Users](
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX)
	CHECK (DATALENGTH([ProfilePicture]) <= 900000),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT NOT NULL
)

INSERT INTO [Users]([Username], [Password], [IsDeleted])
	 VALUES
('Pesho', 123456, 0),
('Gosho', 987654, 1),
('Maria', 555, 0),
('Geri', 999, 0),
('Lili', 333, 0)
