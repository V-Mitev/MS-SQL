CREATE DATABASE [CarRental]

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(30) NOT NULL,
	[DailyRate] DECIMAL(5, 2),
	[WeeklyRate] DECIMAL(5, 2),
	[MonthlyRate] DECIMAL(7, 2),
	[WeekendRate] DECIMAL(6, 2)
)

INSERT INTO [Categories]([CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate])
	 VALUES
	 ('Economy', 10.00, 50.00, 149.90, 25.90),
	 ('Compact', 12.00, 58.00, 179.90, 29.90),
	 ('Standard', 15.00, 60.00, 199.90, 34.90)


CREATE TABLE [Cars](
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] NVARCHAR(20) NOT NULL,
	[Manufacturer] NVARCHAR(20) NOT NULL,
	[Model] NVARCHAR(20) NOT NULL,
	[CarYear] INT NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[Doors] INT NOT NULL,
	[Picture] VARBINARY(MAX),
	[Condition] NVARCHAR(200),
	[Available] BIT NOT NULL
)

INSERT INTO [Cars]([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Available])
	 VALUES
	 ('CB1111TX', 'Mercedes', 'A-Class', 2019, 2, 5, 0),
	 ('CB1112TX', 'BMW', 'i3', 2021, 3, 5, 1),
	 ('CB1113TX', 'Honda', 'Jazz', 2015, 1, 5, 1)


CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(20) NOT NULL,
	[LastName] NVARCHAR(20) NOT NULL,
	[Title] NVARCHAR(30) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Employees]([FirstName], [LastName], [Title])
	 VALUES
	 ('Dimitar', 'Dimitrov', 'Consultant'),
	 ('Petar', 'Marinov', 'Consultant'),
	 ('Deyan', 'Petrov', 'Manager')


CREATE TABLE [Customers](
	[Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] NVARCHAR(20) NOT NULL,
	[FullName] NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(90) NOT NULL,
	[City] NVARCHAR(30) NOT NULL,
	[ZIPCode] NVARCHAR(20) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Customers]([DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode])
	 VALUES
	 ('123555666', 'Petar Petrov Ivanov','Chaika 1', 'Varna', '9000'),
	 ('999238756', 'Dimitar Ivanov Nikolov','Chaika 2', 'Varna', '9000'),
	 ('559735469', 'Diana Dimitrova Ivanova','Chaika 3', 'Varna', '9000')


CREATE TABLE [RentalOrders](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]) NOT NULL,
	[CustomerId] INT FOREIGN KEY REFERENCES [Customers]([Id]) NOT NULL,
	[CarId] INT FOREIGN KEY REFERENCES [Cars]([Id]) NOT NULL,
	[TankLevel] NVARCHAR(20) NOT NULL,
	[KilometrageStart] INT NOT NULL,
	[KilometrageEnd] INT NOT NULL,
	[TotalKilometrage] INT NOT NULL,
	[StartDate] DATE NOT NULL,
	[EndDate] DATE NOT NULL,
	[TotalDays] INT NOT NULL,
	[RateApplied] NVARCHAR(30) NOT NULL,
	[TaxRate] DECIMAL(7, 2) NOT NULL,
	[OrderStatus] BIT NOT NULL,
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [RentalOrders]([EmployeeId], [CustomerId], [CarId], [TankLevel], [KilometrageStart], [KilometrageEnd], [TotalKilometrage], [StartDate], [EndDate], [TotalDays], [RateApplied], [TaxRate], [OrderStatus])
	 VALUES
	 (1, 1, 1, 'MAX', 50000, 55000, 5000, '2023-01-13', '2023-01-15', 3, 'WeekendRate', 25.90, 0),
	 (2, 2, 2, 'MIDDLE', 90000, 95000, 5000, '2023-01-18', '2023-01-19', 1, 'DailyRate', 10.00, 0),
	 (3, 3, 3, 'MIN', 40000, 44000, 4000, '2022-12-13', '2023-01-13', 30, 'MonthlyRate', 149.90, 0)