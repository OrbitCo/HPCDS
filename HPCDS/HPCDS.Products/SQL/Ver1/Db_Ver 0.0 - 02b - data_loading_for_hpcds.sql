USE [hpcds-dev] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

SET IDENTITY_INSERT [PRODUCTSEGMENT] ON
INSERT INTO [PRODUCTSEGMENT] (PRODUCTSEGMENTID, PRODUCTSEGMENTCODE, PRODUCTSEGMENTDESCRIPTION, CREATEDBYNAME,  CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE) 
SELECT PRODUCTSEGMENTID, PRODUCTSEGMENTCODE, PRODUCTSEGMENTDESCRIPTION, CREATEDBYNAME,  CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE 
FROM [hpcds-states].[dbo].[WA-ProductSegment];

SET IDENTITY_INSERT [PRODUCTSEGMENT] OFF

Set IDENTITY_INSERT [PRODUCTFAMILY] ON
INSERT INTO [PRODUCTFAMILY] (PRODUCTFAMILYID, PRODUCTFAMILYCODE, PRODUCTFAMILYDESCRIPTION, PRODUCTSEGMENTID, CREATEDBYNAME, CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE)
SELECT PRODUCTFAMILYID, PRODUCTFAMILYCODE, PRODUCTFAMILYDESCRIPTION, PRODUCTSEGMENTID, CREATEDBYNAME, CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE 
FROM [hpcds-states].[dbo].[WA-ProductFamily];

Set IDENTITY_INSERT [PRODUCTFAMILY] OFF

Set IDENTITY_INSERT [ProductClass] ON
INSERT INTO [ProductClass] (ProductClassId, ProductClassCode, ProductClassDescription, ProductFamilyId, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ProductClassId, ProductClassCode, ProductClassDescription, ProductFamilyId, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ProductClass];

Set IDENTITY_INSERT [ProductClass] OFF

Set IDENTITY_INSERT [ProductBrick] ON
INSERT INTO [ProductBrick] (ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassId, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassId, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ProductBrick];

Set IDENTITY_INSERT [ProductBrick] OFF

Set IDENTITY_INSERT [Component] ON
INSERT INTO [Component] (ComponentId, ComponentName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ComponentId, ComponentName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-Component];

Set IDENTITY_INSERT [Component] OFF

Set IDENTITY_INSERT [ChemicalFunction] ON
INSERT INTO [ChemicalFunction] (ChemicalFunctionId, ChemicalFunctionName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ChemicalFunctionId, ChemicalFunctionName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ChemicalFunction];

Set IDENTITY_INSERT [ChemicalFunction] OFF

Set IDENTITY_INSERT [Chemical] ON
INSERT INTO [Chemical] (ChemicalId, ChemicalName, CASNumber, EuropeanCommissionNumber, EPAIdentifier, IsSingleChemicalFlag, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CASNumberSortValue)
SELECT ChemicalId, ChemicalName, CASNumber, EuropeanCommissionNumber, EPAIdentifier, IsSingleChemicalFlag, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CASNumberSortValue
FROM [hpcds-states].[dbo].[WA-Chemical];

Set IDENTITY_INSERT [Chemical] OFF

INSERT INTO [CSPAOrganization] (AffiliationOrganizationId, OrganizationPIN, AccountablePartyFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, IsSupplierConfidentialFlag, RequestSupplierConfidentialDatetime)
SELECT AffiliationOrganizationId, OrganizationPIN, AccountablePartyFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, IsSupplierConfidentialFlag, RequestSupplierConfidentialDatetime
FROM [hpcds-states].[dbo].[WA-CSPAOrganization];


Set IDENTITY_INSERT [ConcentrationCategory] ON
INSERT INTO [ConcentrationCategory] (ConcentrationCategoryId, ConcentrationCategoryName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ConcentrationCategoryId, ConcentrationCategoryName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ConcentrationCategory];

Set IDENTITY_INSERT [ConcentrationCategory] OFF

Set IDENTITY_INSERT [OrganizationRelationship] ON
INSERT INTO [OrganizationRelationship] (OrganizationRelationshipId, ReportingOrganizationId, AccountableOrganizationId, BlockedFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT OrganizationRelationshipId, ReportingOrganizationId, AccountableOrganizationId, BlockedFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-OrganizationRelationship];

Set IDENTITY_INSERT [OrganizationRelationship] OFF

Set IDENTITY_INSERT [Report] ON
INSERT INTO [Report] (ReportId, ProductBrickId, ReporterOrganizationId, SubmittedDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CopiedFromReportId)
SELECT ReportId, ProductBrickId, ReporterOrganizationId, SubmittedDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CopiedFromReportId
FROM [hpcds-states].[dbo].[WA-Report];

Set IDENTITY_INSERT [Report] OFF

Set IDENTITY_INSERT [ReportDetail] ON
INSERT INTO [ReportDetail] (ReportDetailId, ReportId, ComponentId, ChemicalId, ChemicalFunctionId, ConcentrationCategoryId, ConcentrationValue, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ReportDetailId, ReportId, ComponentId, ChemicalId, ChemicalFunctionId, ConcentrationCategoryId, ConcentrationValue, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ReportDetail];

Set IDENTITY_INSERT [ReportDetail] OFF

Set IDENTITY_INSERT [ReportAccountableOrganization] ON
INSERT INTO [ReportAccountableOrganization] (ReportAccountableOrganizationId, ReportId, AccountableOrganizationId, TargetAgeGroupDescription, RequestedConfidentialFlag, IsConfidentialFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ReportAccountableOrganizationId, ReportId, AccountableOrganizationId, TargetAgeGroupDescription, RequestedConfidentialFlag, IsConfidentialFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-ReportAccountableOrganization];

Set IDENTITY_INSERT [ReportAccountableOrganization] OFF

Set IDENTITY_INSERT [UserAccount] ON
INSERT INTO [UserAccount] (UserAccountId, AffiliationId, OrganizationId, DeletedAccountFlag, BannedAccountFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, BannedReasonDescription)
SELECT UserAccountId, AffiliationId, OrganizationId, DeletedAccountFlag, BannedAccountFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, BannedReasonDescription
FROM [hpcds-states].[dbo].[WA-UserAccount];

Set IDENTITY_INSERT [UserAccount] OFF

Set IDENTITY_INSERT [PublicViewableDateSetting] ON
INSERT INTO [PublicViewableDateSetting] (PublicViewableDateId, PublicViewableDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT PublicViewableDateId, PublicViewableDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM [hpcds-states].[dbo].[WA-PublicViewableDateSetting];

Set IDENTITY_INSERT [PublicViewableDateSetting] OFF

-- 04 - Example of tracking 
DECLARE @t int = NEXT VALUE FOR dbo.SeqVerPatch;

INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		VALUES ('Data Load' , dbo.FuncGetVersion() ,'Initilize Load WA''s data and master Legacy Org table')
GO