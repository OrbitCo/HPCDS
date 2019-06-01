USE [hpcds-pp] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Purpose: Sample Legacy Data for Searching (HPCDS-85)
--
-- Applies to: `DbBackup - hpcds-pp - 2019-05-23b - v0.9.4 wInvBNPM.zip`
-- Applied on: 2019-05-24 7:58 AM on app10/odata/hpcds/ Ver 0.6.2.1 patch update for multi-state search (< 10sec)
--
-- Produced: v0.10.2 (2x Table/View)
--
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


DECLARE @sq int;
DECLARE @DbVer nvarchar(10);
DECLARE @AuthDb nvarchar(30) = '[hpcds-pp-auth]';
DECLARE @sql nvarchar(1000);

SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;
		 
-- HPCDS-85(b) - Schema Edits for placeholder for Origin IDs from Legacy DBs
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 

	-- 01 - Add columns to host PKeys from legacy database
	ALTER TABLE dbo.Report ADD
		WA_ReportId int NULL,
		VT_ReportId nvarchar(50) NULL
		-- OR - has no PKey
	GO

	-- 02 - Add VTs Version of Concentration Label
	ALTER TABLE dbo.ConcentrationCategory ADD VT_Concentration nvarchar(150) NULL
	GO
	
	-- 03 - Track Change
	DECLARE @DbVer nvarchar(10) = dbo.FuncGetVersion();
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-Table' , @DbVer,'HPCDS-85(b) - Report: Add columns to indicate the PKey of Originating DB.');

-- HPCDS-85(c) - Data to support XREF to master schema
	DECLARE @sq int = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	-- 01 - For WA set the legacy PKey for Reports
	UPDATE [dbo].[Report] SET WA_ReportId = ReportId WHERE ReportingState = 'WA';
	
	-- 02 - For VT add x-ref value of Concentration Range to WA/OR's
	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than the PQL but less than 100 ppm' WHERE [ConcentrationCategoryId] = 1
	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than 100 ppm but less than 500 ppm' WHERE [ConcentrationCategoryId] = 2
	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than 500 ppm but less than 1,000 ppm' WHERE [ConcentrationCategoryId] = 3

	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than 1,000 ppm but less than 5,000 ppm' WHERE [ConcentrationCategoryId] = 4
	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than 5,000 ppm but less than 10,000 ppm' WHERE [ConcentrationCategoryId] = 5
	UPDATE [dbo].[ConcentrationCategory] SET VT_Concentration = 'Equal to or more than 10,000 ppm' WHERE [ConcentrationCategoryId] = 6;
	
	-- 03 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		VALUES ('Data Load' , @DbVer,'HPCDS-85(c) - XREF: to map VT_Concentration Ranges and set ReportingState for WA.');

-- HPCDS-216(a) - Create a temp table for flat vSearchReport
	-- 01 - Rename Original View to vSearchReportORG
	EXEC sp_rename 
    @objname = 'vSearchReport',
    @newname = 'vSearchReportORG';
	GO

	-- 02 - Create static version of vSearchReport as tabble
	CREATE TABLE [dbo].[TEMP_vSearchReport](
		[OrganizationName] [nvarchar](255) NOT NULL,
		[ContactUserId] [nvarchar](128) NULL,
		[DUNSNumber] [nvarchar](15) NULL,
		[Email] [nvarchar](256) NULL,
		[PhoneNumber] [nvarchar](max) NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[JobTitle] [nvarchar](90) NULL,
		[AddressLine1] [nvarchar](150) NULL,
		[AddressLine2] [nvarchar](100) NULL,
		[City] [nvarchar](40) NULL,
		[StateProv] [nvarchar](70) NULL,
		[PostalCodeNumber] [nvarchar](24) NULL,
		[CountryCd] [nvarchar](30) NULL,
		[ProductBrickDescription] [varchar](1000) NOT NULL,
		[ProductClassDescription] [varchar](1000) NOT NULL,
		[ProductFamilyDescription] [varchar](1000) NOT NULL,
		[ProductSegmentDescription] [varchar](1000) NOT NULL,
		[ComponentName] [varchar](2000) NOT NULL,
		[InaccessibleComponent] [bit] NULL,
		[ProductBrandName] [varchar](3) NULL,
		[ProductModel] [varchar](3) NULL,
		[UnitSoldInOR] [int] NULL,
		[UnitOfferedForSale] [int] NULL,
		[AttachedFiles] [varchar](3) NULL,
		[ChemicalName] [varchar](254) NOT NULL,
		[CASNumber] [varchar](15) NULL,
		[ConcentrationCategoryName] [varchar](255) NOT NULL,
		[ChemicalFunctionName] [varchar](255) NOT NULL,
		[States] [varchar](2) NOT NULL,
		[Period] [int] NULL,
		[SubmittedDate] [datetime] NULL,
		[SelectedCompany] [int] NOT NULL,
		[TargetAgeGroupDescription] [varchar](50) NULL,
		[ProductBricks] [int] NULL,
		[SelectedComponent] [int] NOT NULL,
		[Chemicals] [int] NOT NULL,
		[SelectedFunction] [int] NOT NULL
	)
	GO

	-- set version
	DECLARE @sq int = NEXT VALUE FOR dbo.SeqVerPatch; 
	DECLARE @DbVer nvarchar(10) = dbo.FuncGetVersion();

	-- 03 - Inset with WA's Data
	INSERT INTO [dbo].[TEMP_vSearchReport] 
		([SelectedCompany],[OrganizationName],[DUNSNumber]
           ,[AddressLine1] ,[AddressLine2],[City],[StateProv],[PostalCodeNumber],[CountryCd]
           ,[FirstName] ,[LastName] 
		   ,[Email],[PhoneNumber] ,[ContactUserId],[JobTitle]
           ,[ProductBricks],[ProductBrickDescription],[ProductClassDescription],[ProductFamilyDescription],[ProductSegmentDescription]
		   ,[SelectedComponent],[ComponentName] ,[InaccessibleComponent]
           ,[Chemicals] ,[ChemicalName] ,[CASNumber] 
		   ,[SelectedFunction] ,[ChemicalFunctionName]
           ,[ConcentrationCategoryName]
		   ,[States],[Period] ,[SubmittedDate]
		   ,[TargetAgeGroupDescription] ,[UnitSoldInOR] ,[UnitOfferedForSale] ,[AttachedFiles]
           )
		SELECT [SelectedCompany],[OrganizationName],[DUNSNumber]
           ,[AddressLine1] ,[AddressLine2],[City],[StateProv],[PostalCodeNumber],[CountryCd]
           ,[FirstName] ,[LastName] 
		   ,[Email],[PhoneNumber] ,[ContactUserId],[JobTitle]
           ,[ProductBricks],[ProductBrickDescription],[ProductClassDescription],[ProductFamilyDescription],[ProductSegmentDescription]
		   ,[SelectedComponent],[ComponentName] ,[InaccessibleComponent]
           ,[Chemicals] ,[ChemicalName] ,[CASNumber] 
		   ,[SelectedFunction] ,[ChemicalFunctionName]
           ,[ConcentrationCategoryName]
		   ,[States],[Period] ,[SubmittedDate]
		   ,[TargetAgeGroupDescription] ,[UnitSoldInOR] ,[UnitOfferedForSale] ,[AttachedFiles]
		FROM vSearchReportORG;

	-- 02 - Add VT's Data
	INSERT INTO [dbo].[TEMP_vSearchReport]
           ([SelectedCompany],[OrganizationName]	-- ,[DUNSNumber]
           ,[AddressLine1]							-- ,[AddressLine2],[City],[StateProv],[PostalCodeNumber],[CountryCd]
           ,[FirstName]								-- ,[LastName] 
		   ,[Email],[PhoneNumber]					-- ,[ContactUserId],[JobTitle]
           ,[ProductBricks],[ProductBrickDescription],[ProductClassDescription],[ProductFamilyDescription],[ProductSegmentDescription]
		   ,[SelectedComponent],[ComponentName]		-- ,[InaccessibleComponent]
           ,[Chemicals] ,[ChemicalName] ,[CASNumber] 
		   ,[SelectedFunction] ,[ChemicalFunctionName]
           ,[ConcentrationCategoryName]
		   ,[States],[Period] ,[SubmittedDate]
													--,[TargetAgeGroupDescription] ,[UnitSoldInOR] ,[UnitOfferedForSale] --,[AttachedFiles]
           )
	SELECT x.MOID,d.ManufacturerName -- ,[DUNSNumber]
           ,d.[ManufacturerContactPersonAddress] -- ,[AddressLine2],[City],[StateProv],[PostalCodeNumber],[CountryCd]
           ,d.ManufacturerContactPerson -- ,[LastName] 
		   ,d.ManufacturerContactEmailAddress,d.ManufacturerContactPhoneNumber --,[ContactUserId],[JobTitle]
           ,pb.ProductBrickId,ISNULL(pb.ProductBrickDescription,d.BrickName),[ProductClassDescription],[ProductFamilyDescription],[ProductSegmentDescription]
		   ,ISNULL(cp.ComponentId,1),ISNULL(cp.ComponentName, d.Component) -- ,[InaccessibleComponent]
           ,c.ChemicalId ,c.ChemicalName ,c.CASNumber 
		   ,cf.ChemicalFunctionId ,ISNULL(cf.ChemicalFunctionName, d.ChemicalFunction)
           ,ISNULL(cc.ConcentrationCategoryName,d.Concentration)
		   ,'VT',YEAR(d.[DateTime]) ,d.[DateTime]
           --,[TargetAgeGroupDescription] ,[UnitSoldInOR] ,[UnitOfferedForSale] --,[AttachedFiles]
	 FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d -- 7514
		INNER JOIN Chemical c on c.CASNumber = d.ChemicalID
		INNER JOIN ConcentrationCategory cc on cc.VT_Concentration = d.Concentration
		LEFT JOIN Component cp on cp.ComponentName = d.Component										 -- 7087 due to Bio, see HPCDS-214 for now assume 1 when NULL
		INNER JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction					 -- 2703 but would be 2519 (compound-INNERS) with matches to WA TODO: HPCDS-213
		INNER JOIN ProductBrick pb on pb.ProductBrickCode = d.BrickID									 -- 2560 but 2378 if compounded INNERS
		INNER JOIN [hpcds-states].dbo.XREF_VT_TO_MASTER_ORG x on x.VT_manufacturer_ID = d.ManufacturerID -- 2523; 2 ORGs not XREF see HPCDS-202

		INNER JOIN dbo.ProductClass pc ON pb.ProductClassId = pc.ProductClassId
		INNER JOIN dbo.ProductFamily pf ON pc.ProductFamilyId = pf.ProductFamilyId
		INNER JOIN dbo.ProductSegment ps ON pf.ProductSegmentId = ps.ProductSegmentId
	;

	-- 03 - Add OR's Data
	INSERT INTO [dbo].[TEMP_vSearchReport] 
		([SelectedCompany],[OrganizationName],[DUNSNumber]
           ,[AddressLine1],[City],[StateProv],[PostalCodeNumber],[CountryCd] -- ,[AddressLine2]
           ,[FirstName] -- ,[LastName] 
           ,[Email] ,[PhoneNumber] ,[JobTitle] -- ,[ContactUserId]
           ,[ProductBricks],[ProductBrickDescription],[ProductClassDescription],[ProductFamilyDescription],[ProductSegmentDescription]
           ,[SelectedComponent],[ComponentName] -- ,[InaccessibleComponent]
           ,[Chemicals] ,[ChemicalName] ,[CASNumber] 
		   ,[SelectedFunction] ,[ChemicalFunctionName]
           ,[ConcentrationCategoryName]
		   ,[States],[Period] ,[SubmittedDate]
           ,[TargetAgeGroupDescription] ,[UnitSoldInOR] ,[UnitOfferedForSale] -- ,[AttachedFiles]
           )
           SELECT x.MOID,d.Manufacturer,d.[Manufacturer/TaxID]
           ,d.[Mailling Address-mfg] ,d.[City-mfg],d.[State-mfg],d.[ZIP code-mfg],d.Country --,[AddressLine2]
           ,d.ContactPerson1 -- ,[LastName] 
           ,d.ContactPerson1_email,d.ContactPerson1_phone ,d.ContactPerson1_title -- ,[ContactUserId]
           ,pb.ProductBrickId,pb.ProductBrickDescription,pc.ProductClassDescription,pf.ProductFamilyDescription,ps.ProductSegmentDescription
           ,ISNULL(cp.ComponentId,9),ISNULL(cp.ComponentName,'Other') -- WHERE ??? ,[InaccessibleComponent]
           ,c.ChemicalId ,c.ChemicalName ,c.CASNumber 
           ,cf.ChemicalFunctionId ,cf.ChemicalFunctionName
           ,ISNULL(cc.ConcentrationCategoryName, 'Equal to or more than 100 ppm but less than 500 ppm')
		   ,'OR',Year(d.LatestSubmissionDate) ,d.LatestSubmissionDate
		   ,d.TargetAgeCategory ,d.NumberofBricksSoldinORin2017 , TRY_CONVERT(int, d.NumberofBricksOFFEREDforsaleinORin2017) -- ,[AttachedFiles]

			FROM [hpcds-states].[dbo].[OR-tblTFK_compiled_addreporterinfo] d										-- 4441 Expected
				LEFT JOIN ConcentrationCategory cc on cc.ConcentrationCategoryName = d.ConcentrationRangeCategory	-- 4440 (solo); 1x with '100ppm - 500ppm' (2) 
				INNER JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction						-- 4415 where 26x have NULL value
				LEFT JOIN Component cp on cp.ComponentName = d.ComponentName										-- 4347 (solo) due to Other (9)
				
				INNER JOIN ProductBrick pb on (pb.ProductBrickDescription + '*-' + pb.ProductBrickCode = d.Brickforproduct -- 4111, 4137 (solo) due to 22x Bricks not mapped/matched
							OR pb.ProductBrickDescription + '-' + pb.ProductBrickCode = d.Brickforproduct
							OR pb.ProductBrickDescription + ' -  ' + pb.ProductBrickCode = d.Brickforproduct			
								)			
					INNER JOIN dbo.ProductClass pc ON pb.ProductClassId = pc.ProductClassId
					INNER JOIN dbo.ProductFamily pf ON pc.ProductFamilyId = pf.ProductFamilyId
					INNER JOIN dbo.ProductSegment ps ON pf.ProductSegmentId = ps.ProductSegmentId

				INNER JOIN Chemical c on c.CASNumber + ' - ' + c.ChemicalName = d.ChemicalNamewithCAS				-- 3667, 3969 (solo) likely due to format hard to match or since we need HPCDS-86
								
				INNER JOIN [hpcds-states].dbo.XREF_OR_TO_MASTER_ORG x on x.OR_ID = d.[Manufacturer/TaxID]			-- 3440, 4122 (solo); 3x TaxID used by multiple unique ORGS
			WHERE NOT d.[Manufacturer/TaxID] in ('123456789','410215170','710415188')

	-- 04 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		VALUES ('Schema-Table' , @DbVer,'HPCDS-216(a) - Report: vmSearchReport (temp) with WA 98 of 1000, VT 2523 of 7514, and OR 3440 of 4441 data');

	-- 05 - Replace Create Temp View 
	EXEC('CREATE VIEW [dbo].[vSearchReport] AS SELECT [OrganizationName]
      ,[ContactUserId]
      ,[DUNSNumber]
      ,[Email]
      ,[PhoneNumber]
      ,[FirstName]
      ,[LastName]
      ,[JobTitle]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[City]
      ,[StateProv]
      ,[PostalCodeNumber]
      ,[CountryCd]
      ,[ProductBrickDescription]
      ,[ProductClassDescription]
      ,[ProductFamilyDescription]
      ,[ProductSegmentDescription]
      ,[ComponentName]
      ,[InaccessibleComponent]
      ,[ProductBrandName]
      ,[ProductModel]
      ,[UnitSoldInOR]
      ,[UnitOfferedForSale]
      ,[AttachedFiles]
      ,[ChemicalName]
      ,[CASNumber]
      ,[ConcentrationCategoryName]
      ,[ChemicalFunctionName]
      ,[States]
      ,[Period]
      ,[SubmittedDate]
      ,[SelectedCompany]
      ,[TargetAgeGroupDescription]
      ,[ProductBricks]
      ,[SelectedComponent]
      ,[Chemicals]
      ,[SelectedFunction] FROM [TEMP_vSearchReport]');

	-- 06 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		VALUES ('Schema-View' , @DbVer,'HPCDS-216(a) - Report: vSearchReport temporaly replaced and feed by [TEMP_vSearchReport]');

---- HPCDS-85(d) - Load WA and VT Data into Report ----------------------------------------------------------------------------
--	-- 02a - For VT add basic Disclosure data
--	INSERT INTO [dbo].[Report]
--           ([ProductBrickId],[ReporterOrganizationId],[SubmittedDate],[ReportingState], VT_ReportId
--		   ,[CreatedByName],[CreatedDate]
--		   ,[ModifiedByName],[ModifiedDate])
--	SELECT pb.ProductBrickId,x.MOID,d.[DateTime],'VT', d.DisclosureID 
--		, d.SubmittedBy, d.[DateTime]
--		, FORMATMESSAGE('SYS, Add Legacy VT Report HPCDS-85(c) (%s)', @DbVer), d.[DateTime]
--	FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d											 -- 7514 - Expected
--		INNER JOIN ProductBrick pb on pb.ProductBrickCode = d.BrickID									 -- 7080 
--		INNER JOIN [hpcds-states].dbo.XREF_VT_TO_MASTER_ORG x on x.VT_manufacturer_ID = d.ManufacturerID -- 7035; 2 ORGs not XREF see HPCDS-202
--	;
	
--	-- 02b - For VT's Report Details...
--	INSERT INTO [dbo].[ReportDetail]
--           ([ReportId],[ComponentId]
--           ,[ChemicalId] ,[ChemicalFunctionId]
--           ,[ConcentrationCategoryId],[ConcentrationValue]
--           ,[CreatedByName] ,[CreatedDate],[ModifiedByName],[ModifiedDate])
--     SELECT r.ReportId, ISNULL(cp.ComponentId,1)
--			, c.ChemicalId, cf.ChemicalFunctionId
--			, cc.ConcentrationCategoryId, Null
--			, d.SubmittedBy, d.[DateTime]
--			, d.SubmittedBy, d.[DateTime]
--			-- , FORMATMESSAGE('SYS, Add Legacy VT Report HPCDS-85(c) (%s)', @DbVer), d.[DateTime]
--	 FROM [hpcds-states].[dbo].[VT-Disclosure_Chemical_Data] d -- 7514
--		INNER JOIN Chemical c on c.CASNumber = d.ChemicalID
--		INNER JOIN ConcentrationCategory cc on cc.VT_Concentration = d.Concentration
--		LEFT JOIN Component cp on cp.ComponentName = d.Component										 -- 7087 due to Bio, see HPCDS-214 for now assume 1 when NULL
--		INNER JOIN ChemicalFunction cf on cf.ChemicalFunctionName = d.ChemicalFunction					 -- 2703 but would be 2519 (compound-INNERS) with matches to WA TODO: HPCDS-213
--		INNER JOIN ProductBrick pb on pb.ProductBrickCode = d.BrickID									 -- 2560 but 2378 if compounded INNERS
--		INNER JOIN [hpcds-states].dbo.XREF_VT_TO_MASTER_ORG x on x.VT_manufacturer_ID = d.ManufacturerID -- 2523; 2 ORGs not XREF see HPCDS-202
--		INNER JOIN [dbo].[Report] r on r.VT_ReportId = d.DisclosureID
--									and r.ProductBrickId = pb.ProductBrickId
--									and r.ReporterOrganizationId = x.MOID
--									AND r.CreatedByName = d.SubmittedBy 	
--	-- 03 - Track Change
--    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
--         VALUES ('Data Load' , @DbVer,'HPCDS-85(c) - Report: Transform VT''s Data.');
		 

--	-- 08 - Track Change
--    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
--         VALUES ('Data Load' , @DbVer,'HPCDS-85 - Report: Add sample data to Reporter''s Active Org (995).');

COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;

SELECT * FROM [dbo].[_TrackModifications] ORDER BY ID;
