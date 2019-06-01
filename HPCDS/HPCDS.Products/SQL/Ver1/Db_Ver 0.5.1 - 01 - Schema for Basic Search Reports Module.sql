USE [hpcds-dev] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Applied to: DbVersion v0.5.1, after app v0.5.0 with Login/Registration most complete
--
-- Purpose: To apply changes related to sprint 4a/4b, Polish Login/Registration and Basic Report Search Modules (target app v0.6.0 5/3/2019)

SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


DECLARE @sq int;
DECLARE @DbVer nvarchar(10);

SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;

-- HPCDS-68 - Search Reports: 
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
	SET @DbVer = dbo.FuncGetVersion();

	-- 01 - Create View of Visible Columns
	EXEC('CREATE VIEW [dbo].[vSearchReport] AS
	SELECT    dbo.vOrganizations.OrganizationName
			, dbo.vOrganizations.PIN
			, dbo.ProductBrick.ProductBrickDescription
			, dbo.Component.ComponentName
			, dbo.Chemical.ChemicalName
			, dbo.Chemical.CASNumber
			, dbo.ConcentrationCategory.ConcentrationCategoryName
			, dbo.ChemicalFunction.ChemicalFunctionName
			, ''WA'' as States
			, YEAR(dbo.Report.SubmittedDate) as Period
			, dbo.Report.SubmittedDate

			-- TODO: (HPCDS-120) rename the inputs to match the fields it will filter
			, dbo.ReportAccountableOrganization.AccountableOrganizationId as SelectedCompany
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
	');
	
	-- 02 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-68(b) - Search Reports: All records from Report Details, with FKeys for Filtering')
    ;

-- TODO: (HPCDS-131) Add view to display Primary Contact for Organization

COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
