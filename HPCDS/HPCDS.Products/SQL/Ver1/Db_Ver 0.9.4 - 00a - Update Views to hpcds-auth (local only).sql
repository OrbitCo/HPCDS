USE [hpcds-dev]
-- for LocalDb ONLY ------------------------------------------------------------------------
-- Purpose: Change view to point to hpcds-auth and not hpcds-pp-auth
--
-- Applies to: `DbBackup - hpcds-pp - 2019-05-23b - v0.9.4 wInvBNPM.zip`
-- -----------------------------------------------------------------------------------------
GO
/****** Object:  View [dbo].[vUserRoles]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vUserRoles]
GO
/****** Object:  View [dbo].[vQuestions]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vQuestions]
GO
/****** Object:  View [dbo].[vInventoryByOrg]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vInventoryByOrg]
GO
/****** Object:  View [dbo].[vInventoryBnPmByChem]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vInventoryBnPmByChem]
GO
/****** Object:  View [dbo].[vSearchReport]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vSearchReport]
GO
/****** Object:  View [dbo].[vOrganizations]    Script Date: 5/23/2019 3:24:28 PM ******/
DROP VIEW [dbo].[vOrganizations]
GO
/****** Object:  View [dbo].[vOrganizations]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE VIEW [dbo].[vOrganizations] AS
	SELECT O.ID, O.PIN, O.OrganizationName, O.IsLegacy, O.LegacyWaPins, O.IsActive,
			O.ContactUserId,
			O.DUNSNumber,
			U.Email, U.PhoneNumber, U.FirstName, U.LastName, U.JobTitle,
			A.AddressLine1, A.AddressLine2, A.City, A.StateProv, A.PostalCodeNumber, A.CountryCd, A.AddressType
	FROM   [hpcds-auth].dbo.Organizations AS O LEFT OUTER JOIN
	       [hpcds-auth].dbo.AspNetUsers AS U ON O.ContactUserId = U.Id INNER JOIN
	       [hpcds-auth].dbo.OrganizationAddresses AS A ON O.ID = A.OrganizationID 
	WHERE A.AddressType = 0
	
GO
/****** Object:  View [dbo].[vSearchReport]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
				, 'TBD' as ProductBrandName
				, 'TBD' as ProductModel
				, 0 as UnitSoldInOR
				, 0 as UnitOfferedForSale
				, 'TBD' as AttachedFiles
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
	
GO
/****** Object:  View [dbo].[vInventoryBnPmByChem]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vInventoryBnPmByChem] AS
		SELECT inv.InventoryBNPMId, inv.OrganizationId, inv.VT_ManufacturerName as OrganizationName -- TODO (HPCDS-127) : Get HPCDS Master Org
			, invChem.ChemicalId
			, invChem.VT_ChemicalNameDescription as ChemicalName -- TODO (HPCDS-86) : Get HPCDS Master Chem name
			, inv.BrandName
			, inv.ProductModel
			, invChem.cntDisclosures
		FROM InventoryBNPM inv
			   INNER JOIN InventoryBNPMChemical invChem on inv.InventoryBNPMId = invChem.InventoryBNPMId
		-- ORDER BY invChem.VT_ChemicalNameDescription, inv.BrandName, inv.ProductModel
	
GO
/****** Object:  View [dbo].[vInventoryByOrg]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vInventoryByOrg] AS
			SELECT i.OrganizationId
				, i.VT_ManufacturerName as OrganizationName -- TODO (HPCDS-127) : Get HPCDS Master Org
				, max(i.cntOfBrands) as cntOfBrands
				, SUBSTRING(
					( SELECT '| ' + x.BrandName AS 'data()' 
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
					  FOR XML PATH('') 
					) , 2 , 9999) As Brands
				--, SUBSTRING(
				--	( SELECT FORMATMESSAGE('| %s (%i, %i)',b.BrandName, b.cntOfModels, max(b.cntOfChemicals)) AS 'data()' 
				--			FROM InventoryBNPM b
				--			WHERE b.OrganizationId = i.OrganizationId -- AND b.cntOfModels > 1
				--			GROUP BY b.BrandName, b.cntOfModels
				--			ORDER BY b.cntOfModels desc
			
				--	  FOR XML PATH(') 
				--	) , 2 , 9999) As AllBrands
			FROM InventoryBNPM i
			-- TODO (HPCDS-127) : Limit to those included in a report
			GROUP BY i.OrganizationId, i.VT_ManufacturerName
	
GO
/****** Object:  View [dbo].[vQuestions]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vQuestions] AS
		SELECT ID, Questions
		FROM   [hpcds-auth].dbo.SecurityQuestions
GO
/****** Object:  View [dbo].[vUserRoles]    Script Date: 5/23/2019 3:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vUserRoles] AS
		SELECT Id, Name
		FROM   [hpcds-auth].dbo.AspNetRoles
GO
