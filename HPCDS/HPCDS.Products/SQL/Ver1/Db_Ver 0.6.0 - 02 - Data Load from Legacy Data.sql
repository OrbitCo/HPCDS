USE [hpcds-pp] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Applied to: hpcds-pp backup of DbVersion v0.6.0/v0.7.0
--				hpcds-pp - v0.7.0 - 2019-05-23.bak
--				hpcds-states - v0.7.0 - 2019-05-23.bak
--
-- Purpose: Transform Legacy VT BNPM into the HPCDS Inventory for Relevant Master Organizations (sprint 4a/4b - View/Download BNPM on Search Public HPCDS-69)

SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


DECLARE @sq int;
DECLARE @DbVer nvarchar(10);
DECLARE @AuthDb nvarchar(30) = '[hpcds-pp-auth]'; -- '[hpcds-pp-auth]';
DECLARE @sql nvarchar(1000);

SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;

-- HPCDS-167 - Archive Legacy BNPM data from VT System 
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 

	-- 01 - Create inital BNPM tables
	CREATE TABLE [dbo].[InventoryBNPM](
		[InventoryBNPMId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[OrganizationId] int NOT NULL,
		[BrandName] [varchar](270) NULL,
		[ProductModel] [varchar](270) NULL,
		[IsArchived] [bit] NULL CONSTRAINT DF_BNPM_IsArchived DEFAULT 0,

		[VT_ManufacturerID] [nvarchar](50) NULL,
		[VT_ManufacturerName] [varchar](1000) NULL,
		[cntOfBrands] [int] NULL,
		[cntOfModels] [int] NULL,
		[cntOfChemicals] [int] NULL,
		[CreatedByName] [varchar](256) NOT NULL,
		[CreatedOn] [datetime] NOT NULL CONSTRAINT DF_BNPM_CreatedOn DEFAULT getutcdate(),
		[ModifiedByName] [varchar](256) NOT NULL,
		[ModifiedOn] [datetime] NOT NULL CONSTRAINT DF_BNPM_ModifiedOn DEFAULT getutcdate(),
	) ON [PRIMARY]
	GO
	
	CREATE TABLE [dbo].[InventoryBNPMChemical](
		[InventoryBNPMChemicalId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[InventoryBNPMId] int NOT NULL,		
		[ChemicalId] int NOT NULL,

		[VT_ManufacturerID] [nvarchar](50) NULL,
		[VT_ChemicalID] [varchar](1000) NULL,
		[VT_ChemicalNameDescription] [varchar](1000) NULL,
		[VT_BrandName] [varchar](1000) NULL,
		[VT_ProductModel] [varchar](1000) NULL,
		[cntDisclosures] [int] NULL,
	) ON [PRIMARY]
	GO

	-- 02 - Track Change
	DECLARE @DbVer nvarchar(10) = dbo.FuncGetVersion();
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-Table' , @DbVer,'HPCDS-167(b) - Inventory BNPM: create inital table from legacy data from VT  [supports HPCDS-69]');

-- HPCDS-69 - Populate Archived/Legacy BNPM data from VT
	-- 03a - Fill intial data from VT's legacy data to support View/Download BNPM (HPCDS-69)
	DECLARE @sq int = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	
	INSERT INTO [dbo].InventoryBNPM ( [OrganizationId], [BrandName], [ProductModel], [IsArchived], 
							[VT_ManufacturerID], [VT_ManufacturerName], [cntOfBrands], [cntOfModels], [cntOfChemicals], [CreatedByName], [ModifiedByName])
		SELECT CAST(-1 as int) as OrganizationId  ,p.[BrandName]  ,p.[ProductModel], CAST(1 as bit) as IsArchived
			  ,d.ManufacturerID as VT_ManufacturerID ,p.[ManufacturerName]
			  , 0 as cntOfBrands
			  , 0 as cntOfModels
			  , count(DISTINCT d.ChemicalID) as cntOfChemicals
			  , FORMATMESSAGE('SYS, Legacy Inv-BNPM HPCDS-69 (%s)', @DbVer)
			  , FORMATMESSAGE('SYS, Legacy Inv-BNPM HPCDS-69 (%s)', @DbVer)
		FROM [hpcds-states].[dbo].[VT-Disclosure_Products_Data] p
				INNER JOIN (
					SELECT df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName, count(*) cnt
					FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] df
					GROUP BY df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName
				) d ON p.DisclosureNumber = d.DisclosureID AND p.ChemicalID = d.ChemicalID
		GROUP BY d.ManufacturerID 
			  ,p.[ManufacturerName]
			  ,p.[BrandName]
			  ,p.[ProductModel]
		;
		
	-- 03b - Update with HPCDS master organization 
	UPDATE inv
		SET OrganizationId = x.MOID
		FROM InventoryBNPM inv
			INNER JOIN [hpcds-states].[dbo].XREF_VT_TO_MASTER_ORG x ON x.VT_manufacturer_ID = inv.VT_ManufacturerID
		;

	-- 03c - Update with count of unique Product Models per Manuf+Brand
	UPDATE inv
		SET cntOfModels = c.cnt 
		FROM InventoryBNPM inv
			INNER JOIN (
				SELECT d.ManufacturerID, p.[BrandName], count(distinct p.ProductModel) as cnt
				FROM [hpcds-states].[dbo].[VT-Disclosure_Products_Data] p
					INNER JOIN (
						SELECT df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName, count(*) cnt
						FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] df
						GROUP BY df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName
					) d ON p.DisclosureNumber = d.DisclosureID AND p.ChemicalID = d.ChemicalID
					GROUP BY d.ManufacturerID 
						  ,p.[ManufacturerName]
						  ,p.[BrandName]
				) c ON inv.VT_ManufacturerID = c.ManufacturerID AND inv.BrandName = c.BrandName
		;

	-- 03d - Update with count of unique Brands per Manuf
	UPDATE inv
		SET cntOfBrands = c.cnt 
		FROM InventoryBNPM inv
			INNER JOIN (
				SELECT d.ManufacturerID, count(distinct p.[BrandName]) as cnt
				FROM [hpcds-states].[dbo].[VT-Disclosure_Products_Data] p
					INNER JOIN (
						SELECT df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName, count(*) cnt
						FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] df
						GROUP BY df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName
					) d ON p.DisclosureNumber = d.DisclosureID AND p.ChemicalID = d.ChemicalID
					GROUP BY d.ManufacturerID 
						  ,p.[ManufacturerName]
				) c ON inv.VT_ManufacturerID = c.ManufacturerID
		;

	-- 04a - Initiate the HPCDS BNPM-Chemical table
	INSERT INTO [dbo].[InventoryBNPMChemical] ( [InventoryBNPMId], [ChemicalId], VT_ManufacturerID, VT_BrandName, VT_ProductModel, VT_ChemicalID, VT_ChemicalNameDescription, cntDisclosures)
		SELECT -1, -1, d.ManufacturerID, p.[BrandName], p.ProductModel, p.ChemicalID, p.ChemicalNameDescription, count(distinct p.DisclosureNumber) as cntDisclosures
		FROM [hpcds-states].[dbo].[VT-Disclosure_Products_Data] p
			INNER JOIN (
				SELECT df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName, count(*) cnt
				FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] df
				GROUP BY df.DisclosureID, df.ChemicalID, df.ManufacturerID, df.ManufacturerName
			) d ON p.DisclosureNumber = d.DisclosureID AND p.ChemicalID = d.ChemicalID
		GROUP BY d.ManufacturerID, p.[BrandName], p.ProductModel, p.ChemicalID, p.ChemicalNameDescription
	;

	-- 04b - update with HPCDS master organization id
	UPDATE invChem
		SET [InventoryBNPMId] = inv.[InventoryBNPMId]
		FROM [InventoryBNPMChemical] invChem
			INNER JOIN InventoryBNPM inv ON inv.VT_ManufacturerID = invChem.VT_ManufacturerID AND inv.BrandName = invChem.VT_BrandName AND inv.ProductModel = invChem.VT_ProductModel
		;

	-- 04c - update with HPCDS master chemical id
	-- TODO (HPCDS-86) : (temp) map by CASRN to WA's Chemical IDs
	UPDATE invChem
		SET ChemicalId = c.ChemicalId
		FROM [InventoryBNPMChemical] invChem
			INNER JOIN Chemical c on c.CASNumber = invChem.VT_ChemicalID

	-- 05 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Data Load' , @DbVer,'HPCDS-69(b) - Search BNPM: with Legacy VT data');

-- HPCDS-167(c) - Add FKyes and indexes to help with performance
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	-- 01 - set index for Org Id; Brand and Product Model
	EXEC('
		CREATE NONCLUSTERED INDEX IX_InventoryOrgBNPM ON dbo.InventoryBNPM
			(
			OrganizationId,
			BrandName,
			ProductModel
			) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	');

	-- 02 - set index for invBNPM and Chemical Id
	EXEC('
		CREATE NONCLUSTERED INDEX [IX_InventoryBNPMChemical] ON [dbo].[InventoryBNPMChemical]
		(
			[InventoryBNPMId] ASC,
			[ChemicalId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	');

	-- 03 - Add FKey between Inv
	EXEC('
		ALTER TABLE dbo.InventoryBNPMChemical ADD CONSTRAINT FK_InventoryBNPMChemical_InventoryBNPM 
			FOREIGN KEY ( InventoryBNPMId ) REFERENCES dbo.InventoryBNPM ( InventoryBNPMId ) ON UPDATE  NO ACTION  ON DELETE  CASCADE ;

		ALTER TABLE dbo.InventoryBNPMChemical ADD CONSTRAINT FK_InventoryBNPMChemical_Chemical 
			FOREIGN KEY ( ChemicalId ) REFERENCES dbo.Chemical ( ChemicalId ) ON UPDATE  NO ACTION ON DELETE  NO ACTION ;
	');

	-- 04 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-Table' , @DbVer,'HPCDS-167(c) - Inventory BNPM: add table indexes and FKey [supports HPCDS-69]');

-- HPCDS-127 - View for Aggergated BNPM at the Manufactor
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	-- 01 - drop & create view
	-- EXEC('DROP VIEW [dbo].[vInventoryByOrg]');
	EXEC('CREATE VIEW [dbo].[vInventoryByOrg] AS
			SELECT i.OrganizationId
				, i.VT_ManufacturerName as OrganizationName -- TODO (HPCDS-127) : Get HPCDS Master Org
				, max(i.cntOfBrands) as cntOfBrands
				, SUBSTRING(
					( SELECT ''| '' + x.BrandName AS ''data()'' 
						FROM (
							-- Include only the top 20 brands based on number of models
							SELECT TOP(20) b.BrandName as BrandName
							FROM InventoryBNPM b
							WHERE b.OrganizationId = i.OrganizationId 
								-- TODO (HPCDS-127) : Limit to those included in a report
								-- Incluce brands with 2+ models unless the org has few brands; and if the org has alot of brands then it must have 3+ models
								AND (( b.cntOfBrands <= 20 AND b.cntOfModels > 1 ) OR (  b.cntOfBrands > 20 AND b.cntOfModels > 2 ) OR (  b.cntOfBrands <= 3 AND b.cntOfModels <= 3 ))
								-- Avoid long Brandnames (indicator of a mix of brand and product model)
								AND LEN(b.BrandName) < 50
							GROUP BY b.BrandName, b.cntOfModels
							ORDER BY b.cntOfModels desc ) x
						ORDER BY x.BrandName
					  FOR XML PATH('''') 
					) , 2 , 9999) As Brands
				--, SUBSTRING(
				--	( SELECT FORMATMESSAGE(''| %s (%i, %i)'',b.BrandName, b.cntOfModels, max(b.cntOfChemicals)) AS ''data()'' 
				--			FROM InventoryBNPM b
				--			WHERE b.OrganizationId = i.OrganizationId -- AND b.cntOfModels > 1
				--			GROUP BY b.BrandName, b.cntOfModels
				--			ORDER BY b.cntOfModels desc
			
				--	  FOR XML PATH('') 
				--	) , 2 , 9999) As AllBrands
			FROM InventoryBNPM i
			-- TODO (HPCDS-127) : Limit to those included in a report
			GROUP BY i.OrganizationId, i.VT_ManufacturerName
	');
	
	-- 02 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-127(a) - Inventory BNPM: View at Org Level with top Brands [supports HPCDS-69]');

-- HPCDS-205 - Join BNPM with Chemical for Public View (at Product Model Level)
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	-- 01 - drop & create view
	-- EXEC('DROP VIEW [dbo].[vInventoryBnPmByChem]');
	EXEC('CREATE VIEW [dbo].[vInventoryBnPmByChem] AS
		SELECT inv.InventoryBNPMId, inv.OrganizationId, inv.VT_ManufacturerName as OrganizationName -- TODO (HPCDS-127) : Get HPCDS Master Org
			, invChem.ChemicalId
			, invChem.VT_ChemicalNameDescription as ChemicalName -- TODO (HPCDS-86) : Get HPCDS Master Chem name
			, inv.BrandName
			, inv.ProductModel
			, invChem.cntDisclosures
		FROM InventoryBNPM inv
			   INNER JOIN InventoryBNPMChemical invChem on inv.InventoryBNPMId = invChem.InventoryBNPMId
		-- ORDER BY invChem.VT_ChemicalNameDescription, inv.BrandName, inv.ProductModel
	');

	-- 02 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-205(a) - Inventory BNPM: View at Product-Model-Chemical Detail Level [supports HPCDS-69, HPCDS-126]');


COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;

SELECT * FROM [dbo].[_TrackModifications] ORDER BY ID;