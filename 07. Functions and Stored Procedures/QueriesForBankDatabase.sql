USE [Bank]

-- Problem 09. Find Full Name
GO

CREATE PROCEDURE [usp_GetHoldersFullName]
              AS
           BEGIN
				  SELECT CONCAT([FirstName], ' ', [LastName]) AS [Full Name] 
					FROM [AccountHolders]
             END

-- Problem 10. People with Balance Higher Than

GO
CREATE PROCEDURE [usp_GetHoldersWithBalanceHigherThan] @number MONEY
			  AS
           BEGIN
						SELECT [ah].[FirstName],
		     				   [ah].[LastName]
						  FROM [AccountHolders] AS [ah]
					INNER JOIN [Accounts] AS [a]
							ON [ah].[Id] = [a].[AccountHolderId]
					  GROUP BY [ah].[FirstName], [ah].[LastName]
						HAVING SUM([a].Balance) > @number
					  ORDER BY [ah].[FirstName], [ah].[LastName]
			 END

-- Problem 11. Future Value Function
GO

CREATE FUNCTION [ufn_CalculateFutureValue]
                (@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @years INT)
RETURNS DECIMAL (18,4)
		   	 AS
	      BEGIN
					DECLARE @fv DECIMAL(18,4) = @sum * (POWER((1 + @yearlyInterestRate), @years))

					 RETURN @fv
			END

-- Problem 12. Calculating Interest
GO

CREATE PROCEDURE [usp_CalculateFutureValueForAccount] @accountId INT, @yearlyInterestRate FLOAT
AS
	BEGIN
		SELECT [ah].[Id] AS [Account Id],
		       [ah].[FirstName] AS [First Name],
		       [ah].[LastName] AS [Last Name],
		       [a].[Balance] AS [Current Balance],
		       [dbo].[ufn_CalculateFutureValue]([a].[Balance], @yearlyInterestRate, 5) AS [Balance in 5 years]
		  FROM [AccountHolders] AS [ah]
		  JOIN [Accounts] AS [a]
		    ON [ah].[Id] = [a].[AccountHolderId]
		 WHERE [a].[Id] = @accountId
	END

GO

EXEC [dbo].[usp_CalculateFutureValueForAccount] 1, 0.1

GO