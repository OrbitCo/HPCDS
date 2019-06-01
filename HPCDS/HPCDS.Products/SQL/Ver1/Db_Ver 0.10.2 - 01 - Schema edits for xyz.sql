USE [hpcds-pp] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Purpose: To Display and Download BNPM data with aggergated chemicals
--
-- Applies to: `_hpcds-pp - 2019-05-24b - v0.10.2 vSearchReport w VT-OR-WA.zip` (43 MB)
-- Applied on: 2019-05-30 20:47:53.013 on app10/odata/hpcds/ Ver 0.6.3 for bnpm display update and download (< 0secs)
--
-- Produced: v0.11 (1x View)
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

-- HPCDS-232(b) - Join BNPM with Chemical for Public View (at Product Model Level)
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();

	-- 01 - drop & create view
	-- EXEC('DROP VIEW [dbo].[vInventoryBnPmWithChem]');
	SET @sql = Replace('
		CREATE VIEW [dbo].[vInventoryBnPmWithChem] AS
			SELECT inv.InventoryBNPMId, inv.OrganizationId, org.OrganizationName
				, inv.BrandName
				, inv.ProductModel			
				, REPLACE(
					SUBSTRING(
					( SELECT FORMATMESSAGE(''| %s [%s]'',invChem.VT_ChemicalNameDescription, invChem.VT_ChemicalID) AS ''data()'' 
							FROM InventoryBNPMChemical invChem
							WHERE invChem.InventoryBNPMId = inv.InventoryBNPMId
							ORDER BY invChem.VT_ChemicalNameDescription -- TODO (HPCDS-86) : Get HPCDS Master Chem name
					  FOR XML  PATH('''') 
						) , 2 , 9999)
						, ''|'', '';<br>'') As ChemicalNames
				, ROW_NUMBER() OVER (ORDER BY org.OrganizationName, inv.BrandName , inv.ProductModel) AS rownum

			FROM InventoryBNPM inv
				   INNER JOIN [auth].[dbo].[Organizations] org on inv.OrganizationId = org.ID
	', '[auth]' , @AuthDb);
	EXEC(@sql);

	-- 02 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-232(b) - Inventory BNPM: View at Product-Model Detail Level w/concat Chemicals [supports HPCDS-69, HPCDS-126], w/row num');

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
