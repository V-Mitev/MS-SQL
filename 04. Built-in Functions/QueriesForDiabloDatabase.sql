-- Problem 14.Games From 2011 and 2012 Year

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
          FROM [Games]
	     WHERE YEAR([Start]) BETWEEN 2011 AND 2012
	  ORDER BY [Start], [Name]

-- Problem 15.User Email Providers

  SELECT [Username], SUBSTRING([Email], CHARINDEX('@', [Email], 1) + 1, LEN([Email]))
      AS [EmailProvider]
    FROM [Users]
ORDER BY [EmailProvider], [Username]

-- Problem 16.Get Users with IP Address Like Pattern

  SELECT [Username], [IpAddress] AS [IP Address]
    FROM [Users]
   WHERE [IpAddress] LIKE '___.1_%._%.___'
ORDER BY [Username]

-- Problem 17.Show All Games with Duration & Part of the Day

   SELECT [Name] AS [Game],
     CASE
          WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
          WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
          ELSE 'Evening'
     END
      AS [Part of the Day],
    CASE 
          WHEN [Duration] <= 3 THEN 'Extra Short'
          WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
          WHEN [duration] > 6 THEN 'Long'
          ELSE 'Extra Long'
     END
      AS [Duration]
    FROM [Games]
ORDER BY [Game], [Duration], [Part of the Day]