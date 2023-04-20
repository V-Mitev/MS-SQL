USE [Geography]

-- Problem 12. Highest Peaks in Bulgaria

	SELECT [c].CountryCode,
		   [m].MountainRange,
		   [p].PeakName,
		   [p].Elevation
      FROM [Countries] AS [c]
INNER JOIN [MountainsCountries] AS [mc]
		ON [c].CountryCode = [mc].CountryCode
INNER JOIN [Mountains] AS [m]
		ON [mc].MountainId = [m].Id
INNER JOIN [Peaks] AS [p]
		ON [m].Id = [p].MountainId
	 WHERE [mc].CountryCode = 'BG' AND [p].Elevation > 2835
  ORDER BY [p].Elevation DESC

-- Problem 13. Count Mountain Ranges

  SELECT [CountryCode],
         COUNT([MountainId]) AS [MountainRanges]
    FROM [MountainsCountries]
   WHERE [CountryCode] IN (
         SELECT [CountryCode]
           FROM [Countries]
          WHERE [CountryName] IN ('United States', 'Russia', 'Bulgaria')
                          )
GROUP BY [CountryCode]

-- Problem 14. Countries With or Without Rivers

   SELECT 
   TOP(5) [c].CountryName,
		  [r].RiverName
	 FROM [Countries] AS [c]
LEFT JOIN [CountriesRivers] AS [cr]
	   ON [c].CountryCode = [cr].CountryCode
LEFT JOIN [Rivers] AS [r]
	   ON [cr].RiverId = [r].Id
	WHERE [c].[ContinentCode] IN
           (
           SELECT [ContinentCode] FROM [Continents]
           WHERE [ContinentName] = 'Africa'
           )
ORDER BY  [c].CountryName

-- Problem 15. Continents and Currencies

SELECT [ContinentCode], 
       [CurrencyCode], 
       [CurrencyUsage]
  FROM 
	(
	SELECT *, 
	DENSE_RANK() OVER(PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC)
	AS [CurrencyRank]
	FROM (
		  SELECT [ContinentCode], [CurrencyCode], COUNT(*)
		      AS [CurrencyUsage]
		    FROM [Countries]
		GROUP BY [ContinentCode], [CurrencyCode]
		  HAVING COUNT(*) > 1
		 )
	AS [CurrencyUsageSubquery]
	)
    AS [CurrencyRankingSubquery]
 WHERE [CurrencyRank] = 1

 -- Problem 16. Countries Without any Mountains

   SELECT COUNT(*) AS [Count]
     FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc] 
       ON [c].[CountryCode] = [mc].[CountryCode]
    WHERE [mc].[MountainId] IS NULL


-- Problem 17. Highest Peak and Longest River by Country

   SELECT TOP(5)
          [c].[CountryName],
          MAX([p].[Elevation]) AS [HighestPeakElevation],
          MAX([r].[Length]) AS [LongestRiverLength]
     FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc]
       ON [c].[CountryCode] = [mc].[CountryCode]
LEFT JOIN [Peaks] AS [p]
       ON [p].[MountainId] = [mc].[MountainId]
LEFT JOIN [CountriesRivers] AS [cr]
       ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS [r]
       ON [cr].[RiverId] = [r].[Id]
 GROUP BY [c].[CountryName]
 ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [c].[CountryName]


-- Problem 18. Highest Peak Name and Elevation by Country

SELECT 
    TOP(5)
	[CountryName] AS [Country],
	CASE 
		WHEN [PeakName] IS NULL THEN '(no highest peak)'
		ELSE [PeakName]
	END
	AS [Highest Peak Name],
	CASE 
		WHEN [Elevation] IS NULL THEN 0
		ELSE [Elevation]
	END
	AS [Highest Peak Elevation],
	CASE
		WHEN [MountainRange] IS NULL THEN '(no mountain)'
		ELSE [MountainRange]
	END
	AS [Mountain]
	FROM 
		(
			SELECT 
			       [c].[CountryName], 
			       [p].[PeakName], 
			       [p].[Elevation], 
			       [m].[MountainRange],
			       DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC) AS [PeakRank]
		      FROM [Countries] AS [c]
         LEFT JOIN [MountainsCountries] AS [mc]
                ON [mc].[CountryCode] = [c].[CountryCode]
         LEFT JOIN [Mountains] AS [m]
                ON [mc].[MountainId] = [m].[Id]
         LEFT JOIN [Peaks] AS [p]
                ON [p].[MountainId] = [m].[Id]
        	) 
		AS [PeakRankingSubquery]
   WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name]