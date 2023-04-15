CREATE DATABASE [Hotel]

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(20) NOT NULL,
	[LastName] NVARCHAR(20) NOT NULL,
	[Title] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Employees]([FirstName], [LastName], [Title])
	 VALUES
	 ('Maria', 'Ivanova', 'Manager'),
	 ('Ivan', 'Ivanov', 'Receptionist'),
	 ('Petar', 'Popov', 'Piccolo')


CREATE TABLE [Customers](
	[AccountNumber] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(20) NOT NULL,
	[LastName] NVARCHAR(20) NOT NULL,
	[PhoneNumber] INT NOT NULL,
	[EmergencyName] NVARCHAR(50),
	[EmergencyNumber] INT,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Customers]([FirstName], [LastName], [PhoneNumber])
	 VALUES
	 ('Lili', 'Marinova', 0888844566),
	 ('Anton', 'Dimov', 0888567345),
	 ('Poli', 'Vladova', 0898234567)


CREATE TABLE [RoomStatus](
	[RoomStatus] NVARCHAR(20) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [RoomStatus]([RoomStatus])
	 VALUES
	 ('Occupied'),
	 ('Available'),
	 ('Under repair')


CREATE TABLE [RoomTypes](
	[RoomType] NVARCHAR(20) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [RoomTypes]([RoomType])
	 VALUES
	 ('Standard'),
	 ('Luxury'),
	 ('Apartment')

	 
CREATE TABLE [BedTypes](
	[BedType] NVARCHAR(20) PRIMARY KEY NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [BedTypes]([BedType])
	 VALUES
	 ('Single bed'),
	 ('Double bed'),
	 ('KingSize bed')


CREATE TABLE [Rooms](
	[RoomNumber] NVARCHAR(10) PRIMARY KEY NOT NULL,
	[RoomType] NVARCHAR(20) FOREIGN KEY REFERENCES [RoomTypes]([RoomType]) NOT NULL,
	[BedType] NVARCHAR(20) FOREIGN KEY REFERENCES [BedTypes]([BedType]) NOT NULL,
	[Rate] DECIMAL(5, 2) NOT NULL,
	[RoomStatus] NVARCHAR(20) FOREIGN KEY REFERENCES [RoomStatus]([RoomStatus]),
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Rooms]([RoomNumber], [RoomType], [BedType], [Rate], [RoomStatus])
	 VALUES
	 (101, 'Standard', 'Single bed', 100.00, 'Available'),
	 (102, 'Luxury', 'KingSize bed', 200.00, 'Occupied'),
	 (103, 'Apartment', 'Double bed', 200.00, 'Under repair')
	 
	
CREATE TABLE [Payments](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[PaymentDate] DATE NOT NULL,
	[AccountNumber] INT FOREIGN KEY REFERENCES [Customers]([AccountNumber]) NOT NULL,
	[FirstDateOccupied] DATE NOT NULL,
	[LastDateOccupied] DATE NOT NULL,
	[TotalDays] INT NOT NULL,
	[AmountCharged] DECIMAL(7, 2) NOT NULL,
	[TaxRate] DECIMAL(5, 2) NOT NULL,
	[TaxAmount] DECIMAL(6, 2) NOT NULL,
	[PaymentTotal] DECIMAL(7, 2) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Payments]([EmployeeId], [PaymentDate], [AccountNumber], [FirstDateOccupied], [LastDateOccupied], [TotalDays], [AmountCharged], [TaxRate], [TaxAmount], [PaymentTotal])
	 VALUES
	 (1, '2023-01-18', 3, '2023-01-18', '2023-01-23', 5, 1000, 20, 200, 1200),
	 (2, '2023-01-15', 2, '2023-01-15', '2023-01-16', 1, 200, 20, 20, 220),
	 (3, '2023-01-10', 1, '2023-01-10', '2023-01-12', 2, 400, 20, 40, 440)


CREATE TABLE [Occupancies](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[DateOccupied] DATE NOT NULL,
	[AccountNumber] INT FOREIGN KEY REFERENCES [Customers]([AccountNumber]) NOT NULL,
	[RoomNumber] NVARCHAR(10) FOREIGN KEY REFERENCES [Rooms]([RoomNumber]) NOT NULL,
	[RateApplied] DECIMAL(5, 2) NOT NULL,
	[PhoneCharge] DECIMAL(5, 2),
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Occupancies]([EmployeeId], [DateOccupied], [AccountNumber], [RoomNumber], [RateApplied])
	 VALUES
	 (1, '2023-01-15', 2, 101, 100),
	 (2, '2023-01-10', 1, 102, 200),
	 (3, '2023-01-12', 3, 103, 300)