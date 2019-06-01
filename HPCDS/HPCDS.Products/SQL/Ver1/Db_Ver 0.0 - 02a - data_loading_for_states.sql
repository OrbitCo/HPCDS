USE [hpcds-states]
GO

-- Temporarly enable to address "SQL Server blocked access to STATEMENT 'OpenRowset/OpenDatasource' of component 'Ad Hoc Distributed Queries' because this component is turned off"
sp_configure 'show advanced options', 1; 	
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1; 
RECONFIGURE; 
GO
SP_CONFIGURE 'XP_CMDSHELL',1;
RECONFIGURE;
GO

-- Allow Microsoft.ACE.OLEDB.12.0 to run on SQL Server 2012 src: https://stackoverflow.com/questions/36987636/cannot-create-an-instance-of-ole-db-provider-microsoft-jet-oledb-4-0-for-linked/37197221#37197221
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1   
-- skipped, due to invalid format specification '$1!.' no idea : EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParam', 1

--HPCDS-13: WA & VT Data loading
Declare @FileDir VARCHAR(400)
Declare @FilePath VARCHAR(700)
Declare @sql nvarchar(max)

-- On ERG-DevDb: 
Set @FileDir = 'C:\data\HPCDS.esavelli'
-- Local, Smit/Em: Set @FileDir = '\\172.16.12.20\Shared\PUBLIC\Savelli.Em.bos\HPCDS\data'

-- WA : SharePoint - https://easternresearchgroup.sharepoint.com/:x:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/State%20Materials/WA%20Data%20(confidential)/cspa-database/cspa_data.xlsx?d=w7281f55b6c2b41a69764aa7f4033e52e&csf=1&e=Im4RMb
Set @FilePath=@FileDir+'\WA\CSPA-Database\cspa_data.xlsx'

Set @sql='INSERT INTO [WA-PRODUCTSEGMENT] (PRODUCTSEGMENTID, PRODUCTSEGMENTCODE, PRODUCTSEGMENTDESCRIPTION, CREATEDBYNAME,  CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE) 
SELECT PRODUCTSEGMENTID, PRODUCTSEGMENTCODE, PRODUCTSEGMENTDESCRIPTION, CREATEDBYNAME,  CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE 
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ProductSegment$]'')';
Exec(@sql)

Set @sql='INSERT INTO [WA-PRODUCTFAMILY] (PRODUCTFAMILYID, PRODUCTFAMILYCODE, PRODUCTFAMILYDESCRIPTION, PRODUCTSEGMENTID, CREATEDBYNAME, CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE)
SELECT PRODUCTFAMILYID, PRODUCTFAMILYCODE, PRODUCTFAMILYDESCRIPTION, PRODUCTSEGMENTID, CREATEDBYNAME, CREATEDDATE, MODIFIEDBYNAME, MODIFIEDDATE 
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ProductFamily$]'')';
Exec(@sql)

Set @sql='insert into [WA-ProductClass] (ProductClassId, ProductClassCode, ProductClassDescription, ProductFamilyId, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ProductClassId, ProductClassCode, ProductClassDescription, ProductFamilyId, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ProductClass$]'')';
Exec(@sql)

Set @sql='insert into [WA-ProductBrick] (ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassId, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassId, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ProductBrick$]'')';
Exec(@sql)

Set @sql='insert into [WA-Component] (ComponentId, ComponentName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ComponentId, ComponentName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.Component$]'')';
Exec(@sql)

Set @sql='insert into [WA-ChemicalFunction] (ChemicalFunctionId, ChemicalFunctionName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ChemicalFunctionId, ChemicalFunctionName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.ChemicalFunction$]'')';
Exec(@sql)

Set @sql='insert into [WA-Chemical] (ChemicalId, ChemicalName, CASNumber, EuropeanCommissionNumber, EPAIdentifier, IsSingleChemicalFlag, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CASNumberSortValue)
SELECT ChemicalId, ChemicalName, CASNumber, EuropeanCommissionNumber, EPAIdentifier, IsSingleChemicalFlag, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CASNumberSortValue
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.Chemical$]'')';
Exec(@sql)

Set @sql='insert into [WA-CSPAOrganization] (AffiliationOrganizationId, OrganizationPIN, AccountablePartyFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, IsSupplierConfidentialFlag, RequestSupplierConfidentialDatetime)
SELECT AffiliationOrganizationId, OrganizationPIN, AccountablePartyFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, IsSupplierConfidentialFlag, RequestSupplierConfidentialDatetime
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.CSPAOrganization$]'')';
Exec(@sql)

Set @sql='insert into [WA-ConcentrationCategory] (ConcentrationCategoryId, ConcentrationCategoryName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ConcentrationCategoryId, ConcentrationCategoryName, IsVisibleFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.ConcentrationCategory$]'')';
Exec(@sql)

Set @sql='insert into [WA-OrganizationRelationship] (OrganizationRelationshipId, ReportingOrganizationId, AccountableOrganizationId, BlockedFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT OrganizationRelationshipId, ReportingOrganizationId, AccountableOrganizationId, BlockedFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [OrganizationRelationship$]'')';
Exec(@sql)
Set @sql='insert into [WA-Report] (ReportId, ProductBrickId, ReporterOrganizationId, SubmittedDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CopiedFromReportId)
SELECT ReportId, ProductBrickId, ReporterOrganizationId, SubmittedDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, CopiedFromReportId
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [Report$]'')';
Exec(@sql)

Set @sql='insert into [WA-ReportDetail] (ReportDetailId, ReportId, ComponentId, ChemicalId, ChemicalFunctionId, ConcentrationCategoryId, ConcentrationValue, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ReportDetailId, ReportId, ComponentId, ChemicalId, ChemicalFunctionId, ConcentrationCategoryId, ConcentrationValue, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ReportDetail$]'')';
Exec(@sql)

Set @sql='insert into [WA-ReportAccountableOrganization] (ReportAccountableOrganizationId, ReportId, AccountableOrganizationId, TargetAgeGroupDescription, RequestedConfidentialFlag, IsConfidentialFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT ReportAccountableOrganizationId, ReportId, AccountableOrganizationId, TargetAgeGroupDescription, RequestedConfidentialFlag, IsConfidentialFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ReportAccountableOrganization$]'')';
Exec(@sql)

Set @sql='insert into [WA-UserAccount] (UserAccountId, AffiliationId, OrganizationId, DeletedAccountFlag, BannedAccountFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, BannedReasonDescription)
SELECT UserAccountId, AffiliationId, OrganizationId, DeletedAccountFlag, BannedAccountFlag, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate, BannedReasonDescription
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [UserAccount$]'')';
Exec(@sql)

Set @sql='insert into [WA-PublicViewableDateSetting] (PublicViewableDateId, PublicViewableDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
SELECT PublicViewableDateId, PublicViewableDate, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [PublicViewableDate$]'')';
Exec(@sql)

--Note: DocumentData field is varbinary so not able to add data 
--Set IDENTITY_INSERT [WA-Document] ON
--Set @sql='insert into [WA-Document] (DocumentId, ReportAccountableOrganizationId, DocumentTitle, PrimaryDocumentFlag, DocumentData, DocumentExtension, DocumentSize, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate)
--SELECT DocumentId, ReportAccountableOrganizationId, DocumentTitle, PrimaryDocumentFlag, DocumentData, DocumentExtension, DocumentSize, CreatedByName, CreatedDate, ModifiedByName, ModifiedDate
--FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [CSPA.dbo.Document$]'')';
--Exec(@sql)
--Set IDENTITY_INSERT [WA-Document] OFF

--Set IDENTITY_INSERT [WA-ProductCategory] ON
--Set @sql='insert into [WA-ProductCategory] (ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassCode, ProductClassDescription, ProductFamilyCode, ProductFamilyDescription, ProductSegmentCode, ProductSegmentDescription)
--SELECT ProductBrickId, ProductBrickCode, ProductBrickDescription, ProductClassCode, ProductClassDescription, ProductFamilyCode, ProductFamilyDescription, ProductSegmentCode, ProductSegmentDescription
--FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [ProductCategory$]'')';
--Exec(@sql)
--Set IDENTITY_INSERT [WA-ProductCategory] OFF


--delete from [WA-ProductBrick]
--select * from [WA-ReportDetail]
--delete [WA-ProductSegment]

-- VT - SharePoint : TODO, add to: https://easternresearchgroup.sharepoint.com/:f:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/State%20Materials/VT%20Data%20(modified)?csf=1&e=R5P2XF
exec('BULK INSERT [VT-Disclosure_Chemical_Data]
FROM ''' + @FileDir + '\VT\Excel_with_pipe\Disclosure_Chemical_Data_20181023010000.csv''
WITH
(	 
    FIRSTROW = 2,
    FIELDTERMINATOR = ''|'',  --CSV field delimiter
    ROWTERMINATOR = ''\n'',   --Use to shift the control to next row    
	TABLOCK	
	--LASTROW = 20,
)');

Update [VT-Disclosure_Chemical_Data]
Set DisclosureID = REPLACE(DisclosureID,'"',''),
ChemicalID = REPLACE(ChemicalID,'"',''),
ChemicalNameDescription = REPLACE(ChemicalNameDescription,'"',''),
ChemicalFunction = REPLACE(ChemicalFunction,'"',''),
Component = REPLACE(Component,'"',''),
Concentration = REPLACE(Concentration,'"',''),
BrickID = REPLACE(BrickID,'"',''),
BrickName = REPLACE(BrickName,'"',''),
TradeSecretDesc = REPLACE(TradeSecretDesc,'"',''),
[Status] = REPLACE([Status],'"',''),
SubmittedBy = REPLACE(SubmittedBy,'"',''),
[DateTime] = REPLACE([DateTime],'"',''),
ManufacturerID = REPLACE(ManufacturerID,'"',''),
ManufacturerName = REPLACE(ManufacturerName,'"',''),
PhysicalAddressofManufacturer = REPLACE(PhysicalAddressofManufacturer,'"',''),
ManufacturerContactPerson = REPLACE(ManufacturerContactPerson,'"',''),
ManufacturerContactPersonAddress = REPLACE(ManufacturerContactPersonAddress,'"',''),
ManufacturerContactEmailAddress = REPLACE(ManufacturerContactEmailAddress,'"',''),
ManufacturerContactPhoneNumber = REPLACE(ManufacturerContactPhoneNumber,'"',''),
TradeAssociationID = REPLACE(TradeAssociationID,'"',''),
TradeAssociationName = REPLACE(TradeAssociationName,'"',''),
PhysicalAddressofTradeAssociation = REPLACE(PhysicalAddressofTradeAssociation,'"',''),
TradeAssociationContactPerson = REPLACE(TradeAssociationContactPerson,'"',''),
TradeAssociationContactPersonAddress = REPLACE(TradeAssociationContactPersonAddress,'"',''),
TradeAssociationEmailAddress = REPLACE(TradeAssociationEmailAddress,'"',''),
TradeAssociationPhoneNumber = REPLACE(TradeAssociationPhoneNumber,'"','')

-- VT - SharePoint : TODO, add to: https://easternresearchgroup.sharepoint.com/:f:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/State%20Materials/VT%20Data%20(modified)?csf=1&e=R5P2XF

exec('BULK INSERT [VT-Disclosure_Products_Data]
FROM '''+ @FileDir + '\VT\Excel_with_pipe\Disclosure_Products_Data_20181023010000.csv''
WITH
(	
    FIRSTROW = 2,
    FIELDTERMINATOR = ''|'',  --CSV field delimiter
    ROWTERMINATOR = ''\n'',   --Use to shift the control to next row
    TABLOCK
)');

update [VT-Disclosure_Products_Data]
set DisclosureNumber = REPLACE(DisclosureNumber,'"',''),
ManufacturerName = REPLACE(ManufacturerName,'"',''),
ChemicalID = REPLACE(ChemicalID,'"',''),
ChemicalNameDescription = REPLACE(ChemicalNameDescription,'"',''),
BrandName = REPLACE(BrandName,'"',''),
ProductModel = REPLACE(ProductModel,'"',''),
Status = REPLACE(Status,'"',''),
DateTime = REPLACE(DateTime,'"','')

--HPCDS-12: Oregon Table schema and Data loading

-- OR - SharePoint : https://easternresearchgroup.sharepoint.com/:x:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/State%20Materials/OR%20Data%20(confidential)/TFK_2018_Reports%20-%2011262018.xlsx?d=w1b3b890bfc47417aa92e8f614839601e&csf=1&e=xG4y3v
Set @FilePath=@FileDir + '\OR\Master_Company_List_2019JAN10.xlsx'
Set @sql='insert into [OR-tblTFK_compiled_addreporterinfo] (Filename, [Manufacturer/TaxID], [OR-IDAssignedByERG], Brickforproduct, ComponentName, ChemicalNamewithCAS, ConcentrationRangeCategory,
ChemicalFunction, TargetAgeCategory, NumberofBricksSoldinORin2017, NumberofBricksOFFEREDforsaleinORin2017, State, Country, Manufacturer, [Mailling Address-mfg], [City-mfg], [State-mfg],
[ZIP code-mfg], ContactPerson1, ContactPerson1_email, ContactPerson1_title, ContactPerson1_phone, EarliestSubmissionDate, LatestSubmissionDate, NumberOfSubmissions)
SELECT Filename, [Manufacturer/Tax ID], [OR-ID Assigned by ERG], [Brick for product], [Component Name], ChemicalNamewithCAS, [Concentration Range Category], [Chemical Function], [Target  Age Category], [Number of Bricks Sold in OR in 2017], 
[Number of Bricks OFFERED for sale in OR in 2017], State, Country, Manufacturer, [Mailling Address-mfg], [City-mfg], [State-mfg], [ZIP code-mfg], ContactPerson1, ContactPerson1_email, ContactPerson1_title,
ContactPerson1_phone, EarliestSubmissionDate, LatestSubmissionDate, NumberOfSubmissions
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [OR$]'')';
Exec(@sql)

-- HPCDS-11: Load consolidated list of Legacy Organizations

--	SharePoint : https://easternresearchgroup.sharepoint.com/:x:/r/sites/HPCDS/_layouts/15/Doc.aspx?sourcedoc=%7BBABC73FF-6018-4333-9675-AE4DD98B2185%7D&file=Master_Company_List_2019JAN10.xlsx&action=default&mobileredirect=true
Set @FilePath=@FileDir + '\Consolidated\XREF_Tables.xlsx'

Set @sql='insert into [XREF_WA_TO_MASTER_ORG] ([MOID],[WA_ID],[WA_PIN])
SELECT [MOID],[WA_ID],[WA_PIN] FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [XREF_WA$]'')';
Exec(@sql)

Set @sql='insert into [XREF_VT_TO_MASTER_ORG] ([MOID],[VT_manufacturer_ID],[IsManufactureId])
SELECT [MOID],[VT_manufacturer_ID],[IsManufactureId] FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [XREF_VT$]'')';
Exec(@sql)

Set @sql='insert into [XREF_OR_TO_MASTER_ORG] ([MOID],[OR_ID],[OR_ID_AssignedByERG])
SELECT [MOID],[OR_ID],[OR_ID_AssignedByERG] FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [XREF_OR$]'')';
Exec(@sql)

-- HPCDS-11 - Legacy Organization
-- Master : SharePoint - https://easternresearchgroup.sharepoint.com/:x:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/Organizations/Master_Company_List_2019JAN10.xlsx?d=wbabc73ff601843339675ae4dd98b2185&csf=1&e=zw0TTT

Set @FilePath = @FileDir + '\Consolidated\Master_Company_List_20190318.xlsx'
Set @sql = 'insert into [Legacy_Organization] ([MOID],[Program Count],[WA ID],[WA PIN],[WA-ID2],[WA-PIN2],[WA-ID3],[WA-PIN3],[VT-manufacturer ID],[VT-manufacturer ID2],[VT-Trade Assoc ID],
[OR- ID (Manufacturer ID/TIN)],[OR- ID 2 (Manufacturer ID/TIN)2],[OR-ID Assigned by ERG],[MASTERNAME],[Physical Address (VT)],[Address source],[Line1Address],[Line2Address],[CityName],[StateCode],[PostalCodeNumber],[CountryCode],[Secondary address],[Notes from states])
SELECT [Master Organization ID],[Program Count],[WA ID],[WA PIN],[WA-ID2],[WA-PIN2],[WA-ID3],[WA-PIN3],[VT-manufacturer ID],[VT-manufacturer ID2],[VT-Trade Assoc ID],[OR- ID (Manufacturer ID/TIN)],
[OR- ID 2 (Manufacturer ID/TIN)2],[OR-ID Assigned by ERG],[MASTERNAME],[Physical Address (VT)],[Address source],[Line1Address],[Line2Address],[CityName],[StateCode],[PostalCodeNumber],[CountryCode],[Secondary address],[Notes from states] 
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0;HDR=YES;Database=' + @FilePath + ''', ''SELECT * FROM [MasterOrgList$]'')';
Exec(@sql)

Update [dbo].Legacy_Organization set [WA PIN] = NULL where [WA PIN] = 'NULL'
Update [dbo].Legacy_Organization set [WA-PIN2] = NULL where [WA-PIN2] = 'NULL'
Update [dbo].Legacy_Organization set [WA-PIN3] = NULL where [WA-PIN3] = 'NULL'
Update [dbo].Legacy_Organization set [OR- ID (Manufacturer ID/TIN)] = NULL where [OR- ID (Manufacturer ID/TIN)] = 'NULL'
Update [dbo].Legacy_Organization set [OR- ID 2 (Manufacturer ID/TIN)2] = NULL where [OR- ID 2 (Manufacturer ID/TIN)2] = 'NULL'
Update [dbo].Legacy_Organization set MASTERNAME = NULL where MASTERNAME = 'NULL'
Update [dbo].Legacy_Organization set [Physical Address (VT)] = NULL where [Physical Address (VT)] = 'NULL'
Update [dbo].Legacy_Organization set Line1Address = NULL where Line1Address = 'NULL'
Update [dbo].Legacy_Organization set Line2Address = NULL where Line2Address = 'NULL'
Update [dbo].Legacy_Organization set CityName = NULL where CityName = 'NULL'
Update [dbo].Legacy_Organization set PostalCodeNumber = NULL where PostalCodeNumber = 'NULL'
Update [dbo].Legacy_Organization set StateCode = NULL where StateCode = 'NULL'
Update [dbo].Legacy_Organization set CountryCode = NULL where CountryCode = 'NULL'
Update [dbo].Legacy_Organization set [Notes from states] = NULL where [Notes from states] = 'NULL'
Update [dbo].Legacy_Organization set [Secondary address] = NULL where [Secondary address] = 'NULL'
Go

-- Change back to original values
-- Grant/Enable for Microsoft.ACE.OLEDB.12.0 on SQL Server 2012
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 0   
-- skipped, due to invalid format specification '$1!.' no idea EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParam', 0
GO

-- Sysconfig
sp_configure 'Ad Hoc Distributed Queries', 0; 
RECONFIGURE; 
GO
SP_CONFIGURE 'XP_CMDSHELL',0;
RECONFIGURE;
GO
sp_configure 'show advanced options', 0;
RECONFIGURE;
GO 