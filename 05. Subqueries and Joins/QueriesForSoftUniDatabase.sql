USE [SoftUni]

-- Problem 01. Employee Address

	SELECT 
   TOP (5) [e].EmployeeID,
		   [e].JobTitle,
		   [e].AddressID,
		   [a].AddressText
	  FROM [Employees]
		AS [e]
INNER JOIN [Addresses]
		AS [a]
		ON [e].AddressID = [a].AddressID
  ORDER BY [a].AddressID  

-- Problem 02. Addresses with Towns

    SELECT 
   TOP(50) [e].FirstName,
		   [e].LastName,
		   [t].[Name]
		AS [Town],
           [a].AddressText
        AS [AddressText]
      FROM [Employees]
        AS [e]
INNER JOIN [Addresses]
		AS [a]
		ON [e].AddressID = [a].AddressID
INNER JOIN [Towns]
		AS [t]
		ON [a].TownID = [t].TownID
  ORDER BY [e].FirstName, [e].LastName

-- Problem 03. Sales Employees

    SELECT [e].EmployeeID,
		   [e].FirstName,
		   [e].LastName,
		   [d].[Name] AS [DepartmentName]
      FROM [Employees] AS [e]
INNER JOIN [Departments] AS [d]
        ON [e].DepartmentID = [d].DepartmentID
	 WHERE [d].[Name] = 'Sales'
  ORDER BY [e].EmployeeID      

-- Problem 04. Employee Departments

    SELECT 
	TOP(5) [e].EmployeeID,
           [e].FirstName,
		   [e].Salary,
		   [d].[Name]
      FROM [Employees] AS [e]
INNER JOIN [Departments] AS [d]
		ON [e].DepartmentID = [d].DepartmentID
	 WHERE [e].Salary > 15000
  ORDER BY [e].DepartmentID

-- Probelm 05. Employees Without Projects

    SELECT 
  TOP (3) [e].EmployeeID,
          [e].FirstName
     FROM [Employees] AS [e]
LEFT JOIN [EmployeesProjects] AS [ep]
	   ON [e].EmployeeID = [ep].EmployeeID
	WHERE [ep].ProjectID IS NULL
 ORDER BY [e].EmployeeID

-- Problem 06. Employees Hired After

    SELECT [e].FirstName,
		   [e].LastName,
		   [e].HireDate,
		   [d].[Name]
      FROM [Employees] AS [e]
INNER JOIN [Departments] AS [d]
		ON [e].DepartmentID = [d].DepartmentID
	 WHERE [e].HireDate > '1-1-1999' AND [d].[Name] IN ('Finance', 'Sales')
  ORDER BY [e].HireDate

-- Problem 07. Employees With Project

    SELECT 
	TOP(5) [e].EmployeeID,
	       [e].FirstName,
		   [p].[Name]
      FROM [Employees] AS [e]
INNER JOIN [EmployeesProjects] AS [ep]
		ON [e].EmployeeID = [ep].EmployeeID
INNER JOIN [Projects] AS [p]
		ON [ep].ProjectID = [p].ProjectID
	 WHERE [p].StartDate > '08-13-2002' AND [p].EndDate IS NULL
  ORDER BY [e].EmployeeID

-- Problem 08. Employee 24

   SELECT [e].EmployeeID,
		  [e].FirstName,
     CASE
		 	WHEN YEAR([p].StartDate) >= 2005 THEN NULL
		 	ELSE [p].[Name]
   END AS [ProjectName]
     FROM [Employees] AS [e]
LEFT JOIN [EmployeesProjects] AS [ep]
	   ON [e].EmployeeID = [ep].EmployeeID
LEFT JOIN [Projects] AS [p]
	   ON [ep].ProjectID = [p].ProjectID
	WHERE [ep].EmployeeID = 24

-- Problem 09. Employee Manager

    SELECT [e].[EmployeeID],
           [e].[FirstName], 
	       [e].[ManagerID], 
	       [m].[FirstName]
      FROM [Employees] AS [e]
INNER JOIN [Employees] AS [m]
		ON [e].ManagerID = [m].EmployeeID
	 WHERE [e].ManagerID IN (3, 7)
  ORDER BY [e].EmployeeID

-- Problem 10. Employees Summary

	SELECT 
   TOP(50) [e].EmployeeID,
		   CONCAT([e].FirstName, ' ', [e].LastName) AS [EmployeeName],
		   CONCAT([m].FirstName, ' ', [m].LastName) AS [ManagerName],
		   [d].[Name] AS [DepartmentName]
	  FROM [Employees] AS [e]
INNER JOIN [Employees] AS [m]
		ON [e].ManagerID = [m].EmployeeID
INNER JOIN [Departments] AS [d]
		ON [e].DepartmentID = [d].DepartmentID

-- Problem 11. Min Average Salary

SELECT MIN([AvgSalary]) AS [MinAverageSalary]
    FROM
   (
			SELECT AVG([Salary]) AS [AvgSalary] 
			  FROM [Employees]
		  GROUP BY [DepartmentID]
    ) AS [AverageSalaries]