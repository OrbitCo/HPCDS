USE [hpcds-pp] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Applied to: DbVersion v0.6.0/v0.7.0
--				hpcds-pp - v0.7.0 - 2019-05-23.bak
--				hpcds-states - v0.7.0 - 2019-05-23.bak
--
-- Purpose: To apply changes related to sprint 4a/4b, Polish Login/Registration and Basic Report Search Modules (target app v0.6.0 5/3/2019)

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
		 
-- HPCDS-85 - Add column that indicates which state is being reporting to
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();

	-- 01 - Add column
	EXEC('
	ALTER TABLE dbo.Report ADD
		ReportingState varchar(2) NOT NULL CONSTRAINT DF_Report_ReportingState DEFAULT ''NA'';
	');

	-- 02 - Set existing Reports to WA's data
	EXEC(' UPDATE [dbo].[Report] SET ReportingState = ''WA''; ');

	-- 03 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-Table' , @DbVer,'HPCDS-85 - Report: Add column to indicate the state being reported to.');


-- HPCDS-142 - Search Reports: 
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();
	-- 01 - Drop old View create new one with address fields
	EXEC('DROP VIEW [dbo].[vOrganizations]');
	SET @sql = Replace('
	CREATE VIEW [dbo].[vOrganizations] AS
	SELECT O.ID, O.PIN, O.OrganizationName, O.IsLegacy, O.LegacyWaPins, O.IsActive,
			O.ContactUserId,
			O.DUNSNumber,
			U.Email, U.PhoneNumber, U.FirstName, U.LastName, U.JobTitle,
			A.AddressLine1, A.AddressLine2, A.City, A.StateProv, A.PostalCodeNumber, A.CountryCd, A.AddressType
	FROM   [auth].dbo.Organizations AS O LEFT OUTER JOIN
	       [auth].dbo.AspNetUsers AS U ON O.ContactUserId = U.Id INNER JOIN
	       [auth].dbo.OrganizationAddresses AS A ON O.ID = A.OrganizationID 
	WHERE A.AddressType = 0
	', '[auth]' , @AuthDb);
	EXEC(@sql);

	-- 01 - Drop old View create new one with more fields
	EXEC('DROP VIEW [dbo].[vSearchReport]');
	EXEC('
	CREATE VIEW [dbo].[vSearchReport] AS
		SELECT    dbo.vOrganizations.OrganizationName
				, dbo.vOrganizations.ContactUserId
				, dbo.vOrganizations.DUNSNumber 
				, dbo.vOrganizations.Email
				, dbo.vOrganizations.PhoneNumber
				, dbo.vOrganizations.FirstName
				, dbo.vOrganizations.LastName
				, dbo.vOrganizations.JobTitle
				, dbo.vOrganizations.AddressLine1
				, dbo.vOrganizations.AddressLine2
				, dbo.vOrganizations.City
				, dbo.vOrganizations.StateProv
				, dbo.vOrganizations.PostalCodeNumber
				, dbo.vOrganizations.CountryCd
				, dbo.ProductBrick.ProductBrickDescription
				, dbo.ProductClass.ProductClassDescription
				, dbo.ProductFamily.ProductFamilyDescription
				, dbo.ProductSegment.ProductSegmentDescription
				, dbo.Component.ComponentName
				, cast(0 as bit) as InaccessibleComponent
				, ''TBD'' as ProductBrandName
				, ''TBD'' as ProductModel
				, 0 as UnitSoldInOR
				, 0 as UnitOfferedForSale
				, ''TBD'' as AttachedFiles
				, dbo.Chemical.ChemicalName
				, dbo.Chemical.CASNumber
				, dbo.ConcentrationCategory.ConcentrationCategoryName
				, dbo.ChemicalFunction.ChemicalFunctionName
				, dbo.Report.ReportingState as States			-- TODO (HPCDS-14) - maybe use State Org Ids for searching instead?
				, YEAR(dbo.Report.SubmittedDate) as Period      -- TODO (HPCDS-14/145) - new period ID instead of year
				, dbo.Report.SubmittedDate
	
				-- TODO: (HPCDS-120) rename the inputs to match the fields it will filter
				, dbo.ReportAccountableOrganization.AccountableOrganizationId as SelectedCompany
				, dbo.ReportAccountableOrganization.TargetAgeGroupDescription
				, dbo.Report.ProductBrickId as ProductBricks
				, dbo.ReportDetail.ComponentId as SelectedComponent
				, dbo.ReportDetail.ChemicalId as Chemicals
				, dbo.ReportDetail.ChemicalFunctionId as SelectedFunction
		FROM dbo.Report 
				INNER JOIN dbo.ReportDetail ON dbo.Report.ReportId = dbo.ReportDetail.ReportId 
				INNER JOIN dbo.ReportAccountableOrganization ON dbo.Report.ReportId = dbo.ReportAccountableOrganization.ReportId 
				INNER JOIN dbo.CSPAOrganization ON dbo.ReportAccountableOrganization.AccountableOrganizationId = dbo.CSPAOrganization.AffiliationOrganizationId 
				INNER JOIN dbo.vOrganizations ON dbo.CSPAOrganization.OrganizationPIN = dbo.vOrganizations.PIN
				INNER JOIN dbo.ProductBrick ON dbo.Report.ProductBrickId = dbo.ProductBrick.ProductBrickId 
				INNER JOIN dbo.Component ON dbo.ReportDetail.ComponentId = dbo.Component.ComponentId 
				INNER JOIN dbo.Chemical ON dbo.ReportDetail.ChemicalId = dbo.Chemical.ChemicalId 
				INNER JOIN dbo.ChemicalFunction ON dbo.ReportDetail.ChemicalFunctionId = dbo.ChemicalFunction.ChemicalFunctionId 
				INNER JOIN dbo.ConcentrationCategory ON dbo.ReportDetail.ConcentrationCategoryId = dbo.ConcentrationCategory.ConcentrationCategoryId
				INNER JOIN dbo.ProductClass ON dbo.ProductBrick.ProductClassId = dbo.ProductClass.ProductClassId
				INNER JOIN dbo.ProductFamily ON dbo.ProductClass.ProductFamilyId = dbo.ProductFamily.ProductFamilyId
				INNER JOIN dbo.ProductSegment ON dbo.ProductFamily.ProductSegmentId = dbo.ProductSegment.ProductSegmentId
	');

	-- 03 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-142(c) - Search Reports: Updated for Organization Contact Info');

-- TODO: (HPCDS-131) Add view to display Primary Contact for Organization

COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;

SELECT * FROM [dbo].[_TrackModifications] ORDER BY ID;
