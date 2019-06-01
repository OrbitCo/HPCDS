
-- Data in VT
SELECT ManufacturerID, ManufacturerName, 
	count(*) as cntOfRecords, 
	sum(CASE TradeSecretDesc WHEN 'YES' THEN 1 ELSE 0 END) cntOfCBIs,
	count(DISTINCT [DisclosureID] ) as cntOfDisclosures,
	count(DISTINCT ChemicalID) as cntOfChems, 
	-- count(DISTINCT CASE TradeSecretDesc WHEN 'YES' THEN ChemicalID ELSE NULL END) cntOfCBIChems,
	count(DISTINCT BrickID ) as cntOfBricks, 
	min([DateTime]) as firstSubmission, max([DateTime]) as lastSubmission
  FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data]
GROUP BY ManufacturerID, ManufacturerName
-- HAVING count(DISTINCT ChemicalID) > 3 and count(DISTINCT BrickID) > 1
ORDER BY ManufacturerName
;

SELECT DISTINCT [Concentration]
FROM  [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data]
;


SELECT d.ChemicalFunction, cf.ChemicalFunctionId, cf.ChemicalFunctionName, count(*) as cntOfRecords
  FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d -- 7514
	LEFT JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction
--	WHERE cf.ChemicalFunctionId is null
GROUP BY d.ChemicalFunction, cf.ChemicalFunctionId, cf.ChemicalFunctionName
ORDER BY d.ChemicalFunction


SELECT d.Component, cp.ComponentId, cp.ComponentName, count(*) as cntOfRecords
FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d
		LEFT JOIN Component cp on cp.ComponentName = d.Component 
GROUP BY d.Component, cp.ComponentId, cp.ComponentName
ORDER BY Component


SELECT DISTINCT BrickID, BrickName -- 284
FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data]
ORDER BY BrickName


SELECT BrickID, BrickName, pb.ProductBrickId, pb.ProductBrickCode, pb.ProductBrickDescription, count(*) as cntOfRecords -- 284
FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d
	LEFT JOIN ProductBrick pb on pb.ProductBrickCode = d.BrickID 
-- WHERE pb.ProductBrickId is null
GROUP BY BrickID, BrickName, pb.ProductBrickId, pb.ProductBrickCode, pb.ProductBrickDescription
ORDER BY BrickName


SELECT count(*)
	, count(DISTINCT CASE WHEN x.VT_manufacturer_ID is NULL THEN ManufacturerID ELSE NULL END)
	, min(DISTINCT CASE WHEN x.VT_manufacturer_ID is NULL THEN ManufacturerID ELSE NULL END)
	, max(DISTINCT CASE WHEN x.VT_manufacturer_ID is NULL THEN ManufacturerID ELSE NULL END)
-- SELECT d.ManufacturerID, x.MOID
  FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d -- 7514
	LEFT JOIN [hpcds-states].dbo.XREF_VT_TO_MASTER_ORG x on x.VT_manufacturer_ID = d.ManufacturerID -- 7455
-- GROUP BY d.ManufacturerID, x.MOID


/****** Script for SelectTopNRows command from SSMS  *****/
SELECT TOP (5000) [DisclosureID]
      ,d.[ChemicalID]
      ,[ChemicalNameDescription]
      ,[ChemicalFunction]
      ,[Component]
      ,[Concentration]

      ,[BrickID]
      ,[BrickName]
      ,[TradeSecretDesc]

      ,[Status]
      ,[SubmittedBy]
      ,[DateTime]

      ,[ManufacturerID]
      ,[ManufacturerName]
      ,[PhysicalAddressofManufacturer]
      ,[ManufacturerContactPerson]
      ,[ManufacturerContactPersonAddress]
      ,[ManufacturerContactEmailAddress]
      ,[ManufacturerContactPhoneNumber]

      ,[TradeAssociationID]
      ,[TradeAssociationName]
      ,[PhysicalAddressofTradeAssociation]
      ,[TradeAssociationContactPerson]
      ,[TradeAssociationContactPersonAddress]
      ,[TradeAssociationEmailAddress]
      ,[TradeAssociationPhoneNumber]

  -- SELECT COUNT(*) started with 7514 can auto add 2523
  FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d -- 7514
	INNER JOIN Chemical c on c.CASNumber = d.ChemicalID
	INNER JOIN ConcentrationCategory cc on cc.VT_Concentration = d.Concentration
	LEFT JOIN Component cp on cp.ComponentName = d.Component -- 7087 due to Bio, see HPCDS-214 for now assume 1 when NULL
	INNER JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction -- 2703 but would be 2519 (compound-INNERS) with matches to WA TODO: HPCDS-213
	INNER JOIN ProductBrick pb on pb.ProductBrickCode = d.BrickID -- 2560 but 2378 if compounded INNERS
	INNER JOIN [hpcds-states].dbo.XREF_VT_TO_MASTER_ORG x on x.VT_manufacturer_ID = d.ManufacturerID -- 2523; 2 ORGs not XREF see HPCDS-202


-- Browse
	SELECT [InventoryBNPMId]
		  ,[OrganizationId]
		  ,[BrandName]
		  ,[ProductModel]
		  ,[IsArchived]
		  ,[VT_ManufacturerID]
		  ,[VT_ManufacturerName]
		  ,[cntOfBrands]
		  ,[cntOfModels]
		  ,[cntOfChemicals]
		  ,[CreatedByName]
		  ,[CreatedOn]
		  ,[ModifiedByName]
		  ,[ModifiedOn]
	  FROM [hpcds-dev].[dbo].[InventoryBNPM]
	  ORDER BY 
	  [VT_ManufacturerName],  [BrandName]      ,[ProductModel]

		SELECT t.*, t.rownum % 15 as mods
		FROM
		(
			SELECT [VT_ManufacturerName], count(*) as cnt, ROW_NUMBER() OVER (ORDER BY [VT_ManufacturerName]) AS rownum
			FROM [InventoryBNPM]
			GROUP BY [VT_ManufacturerName]
			-- ORDER BY [VT_ManufacturerName],  [BrandName]      ,[ProductModel]
		) AS t
		 WHERE t.rownum % 15 = 0    -- or % 40 etc



		  SELECT t.*, t.rownum -  t.rownum % 10000 as x
		FROM
		(
			SELECT [VT_ManufacturerName],  [BrandName]      ,[ProductModel], ROW_NUMBER() OVER (ORDER BY [VT_ManufacturerName],  [BrandName]      ,[ProductModel]) AS rownum
			FROM [InventoryBNPM]
			-- ORDER BY [VT_ManufacturerName],  [BrandName]      ,[ProductModel]
		) AS t
		-- WHERE t.rownum % 10000 = 0    -- or % 40 etc


-- SELECT t.*, t.rownum -  t.rownum % 10000 as x

SELECT t.OrganizationName, 
	min(t.rownum) as firstRow, max(t.rownum) as lastRow,
	min(t.rownum -  t.rownum % 10000) as inGroup,
	count(*) as cnt
	FROM
	(
		SELECT [VT_ManufacturerName] as OrganizationName,  [BrandName]      ,[ProductModel], ROW_NUMBER() OVER (ORDER BY [VT_ManufacturerName],  [BrandName]      ,[ProductModel]) AS rownum
		FROM [InventoryBNPM]
		-- ORDER BY [VT_ManufacturerName],  [BrandName]      ,[ProductModel]
	) AS t
	-- WHERE t.rownum % 10000 = 0    -- or % 40 etc
Group by t.OrganizationName



/*
	A-Ga		1	to	22428
	Gi-Gl	22429	to	129220
	Gl		129221	to	236006
	Go-Gu	236007	to	237232
	H-K		237233	to	249998
	L-N		249999	to	329841
	P-VF(1)	329842	to	493843
	VF		493844	to	666476
	VT-Z	666477	to	666671 (end)
*/

