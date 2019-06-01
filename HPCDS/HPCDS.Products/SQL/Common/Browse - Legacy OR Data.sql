/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP(20) [MOID]
      ,[OR_ID]
      ,[OR_ID_AssignedByERG]
  FROM [hpcds-states].[dbo].[XREF_OR_TO_MASTER_ORG]
GO
SELECT [OR_ID], count(DISTINCT [MOID]),count(DISTINCT [OR_ID_AssignedByERG])
  FROM [hpcds-states].[dbo].[XREF_OR_TO_MASTER_ORG]
  GROUP BY [OR_ID]
  HAVING count(DISTINCT MOID) > 1
GO


SELECT TOP (1000) [Filename]
      ,[Manufacturer/TaxID]
      ,[OR-IDAssignedByERG]
      ,[Brickforproduct]
      ,[ComponentName]
      ,[ChemicalNamewithCAS]
      ,[ConcentrationRangeCategory]
      ,[ChemicalFunction]
      ,[TargetAgeCategory]
      ,[NumberofBricksSoldinORin2017]
      ,[NumberofBricksOFFEREDforsaleinORin2017]
      ,[State]
      ,[Country]
      ,[Manufacturer]
      ,[Mailling Address-mfg]
      ,[City-mfg]
      ,[State-mfg]
      ,[ZIP code-mfg]
      ,[ContactPerson1]
      ,[ContactPerson1_email]
      ,[ContactPerson1_title]
      ,[ContactPerson1_phone]
      ,[EarliestSubmissionDate]
      ,[LatestSubmissionDate]
      ,[NumberOfSubmissions]
  FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo]

SELECT [ConcentrationRangeCategory], cc.ConcentrationCategoryId, count(*) as cntOfRecords, min(o.Manufacturer) as firstManuf
  FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] o
	LEFT JOIN ConcentrationCategory cc on o.ConcentrationRangeCategory = cc.ConcentrationCategoryName
GROUP BY [ConcentrationRangeCategory], cc.ConcentrationCategoryId


SELECT d.ComponentName, c.ComponentId, c.ComponentName, count(*) as cntOfRecords
	FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d
		LEFT JOIN Component c ON c.ComponentName = d.ComponentName
GROUP BY d.ComponentName, c.ComponentId, c.ComponentName
ORDER BY d.ComponentName

SELECT d.ChemicalFunction, cf.ChemicalFunctionId, cf.ChemicalFunctionName, count(*) as cntOfRecords
	FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d
		LEFT JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction
GROUP BY d.ChemicalFunction, cf.ChemicalFunctionId, cf.ChemicalFunctionName
ORDER BY d.ChemicalFunction

SELECT * FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d WHERE d.ChemicalFunction is null


SELECT d.Brickforproduct, pb.ProductBrickId, pb.ProductBrickCode, pb.ProductBrickDescription, count(*) as cntOfRecords
	FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d 
		 LEFT JOIN ProductBrick pb on (pb.ProductBrickDescription + '*-' + pb.ProductBrickCode = d.Brickforproduct
									OR pb.ProductBrickDescription + '-' + pb.ProductBrickCode = d.Brickforproduct
									OR pb.ProductBrickDescription + ' -  ' + pb.ProductBrickCode = d.Brickforproduct			
										)
WHERE pb.ProductBrickId is null
GROUP BY d.Brickforproduct, pb.ProductBrickId, pb.ProductBrickCode, pb.ProductBrickDescription		


SELECT distinct d.NumberofBricksOFFEREDforsaleinORin2017
	FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d 

SELECT d.ChemicalNamewithCAS, c.ChemicalId, c.ChemicalName, c.CASNumber, c.IsSingleChemicalFlag, count(*) as cntOfRecords
FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d										-- 4441 Expected
	LEFT JOIN Chemical c on c.CASNumber + ' - ' + c.ChemicalName = d.ChemicalNamewithCAS				-- 3969 (solo) likely due to format hard to match or since I haven't migrated to HPCDS-86
GROUP BY d.ChemicalNamewithCAS, c.ChemicalId, c.ChemicalName, c.CASNumber, c.IsSingleChemicalFlag
ORDER BY d.ChemicalNamewithCAS
