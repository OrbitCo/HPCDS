-- This script applies to [hpcds-dev]; [hpcds-ir]; [hpcds-pp]; [hpcds-qa]

USE [master]
GO
-- 2019-03-20 - Created on ERG-DevDb -dev, -ir
--            N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\'
-- Local, Em: N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\'

/****** Object:  Database [hpcds-dev]    Script Date: 3/13/2019 2:35:18 PM ******/
CREATE DATABASE [hpcds-dev]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hpcds-dev', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\hpcds-dev.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hpcds-dev_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\hpcds-dev_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [hpcds-dev] SET COMPATIBILITY_LEVEL = 110
GO

USE [hpcds-dev] -- OR [hpcds-ir]; [hpcds-pp]; [hpcds-qa]
GO
/****** Object:  User [HPCDS_WEB_USER]    Script Date: 12/26/2018 6:44:38 PM ******/
CREATE USER [HPCDS_WEB_USER] FOR LOGIN [HPCDS_WEB_USER] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [hpcds-Admin]    Script Date: 12/26/2018 6:44:39 PM ******/
CREATE USER [HPCDS_ADMIN] FOR LOGIN [HPCDS_ADMIN] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [HPCDS_WEB_USER]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [HPCDS_WEB_USER]
GO
ALTER ROLE [db_owner] ADD MEMBER [HPCDS_ADMIN]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [HPCDS_ADMIN]
GO

-- HPCDS-15 (temp) Load WA Schema
/****** Object:  Table [dbo].[Chemical]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chemical](
	[ChemicalId] [int] IDENTITY(1,1) NOT NULL,
	[ChemicalName] [varchar](254) NOT NULL,
	[CASNumber] [varchar](15) NULL,
	[EuropeanCommissionNumber] [varchar](50) NULL,
	[EPAIdentifier] [varchar](50) NULL,
	[IsSingleChemicalFlag] [char](1) NOT NULL,
	[IsVisibleFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CASNumberSortValue] [int] NULL,
 CONSTRAINT [PK_Chemical] PRIMARY KEY CLUSTERED 
(
	[ChemicalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChemicalFunction]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChemicalFunction](
	[ChemicalFunctionId] [int] IDENTITY(1,1) NOT NULL,
	[ChemicalFunctionName] [varchar](255) NOT NULL,
	[IsVisibleFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ChemicalFunction] PRIMARY KEY CLUSTERED 
(
	[ChemicalFunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Component]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Component](
	[ComponentId] [int] IDENTITY(1,1) NOT NULL,
	[ComponentName] [varchar](2000) NOT NULL,
	[IsVisibleFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Component] PRIMARY KEY CLUSTERED 
(
	[ComponentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcentrationCategory]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcentrationCategory](
	[ConcentrationCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[ConcentrationCategoryName] [varchar](255) NOT NULL,
	[IsVisibleFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ConcentrationCategory] PRIMARY KEY CLUSTERED 
(
	[ConcentrationCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CSPAOrganization]    Script Date: 1/3/2019 2:25:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSPAOrganization](
	[AffiliationOrganizationId] [int] NOT NULL,
	[OrganizationPIN] [varchar](8) NOT NULL,
	[AccountablePartyFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsSupplierConfidentialFlag] [char](1) NULL,
	[RequestSupplierConfidentialDatetime] [datetime] NULL,
 CONSTRAINT [PK_CSPAOrganization] PRIMARY KEY CLUSTERED 
(
	[AffiliationOrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[ReportAccountableOrganizationId] [int] NOT NULL,
	[DocumentTitle] [varchar](256) NOT NULL,
	[PrimaryDocumentFlag] [char](1) NOT NULL,
	[DocumentData] [varbinary](max) NOT NULL,
	[DocumentExtension] [varchar](10) NOT NULL,
	[DocumentSize] [int] NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationRelationship]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationRelationship](
	[OrganizationRelationshipId] [int] IDENTITY(1,1) NOT NULL,
	[ReportingOrganizationId] [int] NOT NULL,
	[AccountableOrganizationId] [int] NOT NULL,
	[BlockedFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OrganizationRelationship] PRIMARY KEY CLUSTERED 
(
	[OrganizationRelationshipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductBrick]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductBrick](
	[ProductBrickId] [int] IDENTITY(1,1) NOT NULL,
	[ProductBrickCode] [varchar](50) NOT NULL,
	[ProductBrickDescription] [varchar](1000) NOT NULL,
	[ProductClassId] [int] NOT NULL,
	[IsVisibleFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductBrick] PRIMARY KEY CLUSTERED 
(
	[ProductBrickId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategory](
	[ProductBrickId] [int] NOT NULL,
	[ProductBrickCode] [varchar](50) NOT NULL,
	[ProductBrickDescription] [varchar](1000) NOT NULL,
	[ProductClassCode] [varchar](50) NOT NULL,
	[ProductClassDescription] [varchar](1000) NOT NULL,
	[ProductFamilyCode] [varchar](50) NOT NULL,
	[ProductFamilyDescription] [varchar](1000) NOT NULL,
	[ProductSegmentCode] [varchar](50) NOT NULL,
	[ProductSegmentDescription] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductClass]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductClass](
	[ProductClassId] [int] IDENTITY(1,1) NOT NULL,
	[ProductClassCode] [varchar](50) NOT NULL,
	[ProductClassDescription] [varchar](1000) NOT NULL,
	[ProductFamilyId] [int] NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductClass] PRIMARY KEY CLUSTERED 
(
	[ProductClassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductFamily]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductFamily](
	[ProductFamilyId] [int] IDENTITY(1,1) NOT NULL,
	[ProductFamilyCode] [varchar](50) NOT NULL,
	[ProductFamilyDescription] [varchar](1000) NOT NULL,
	[ProductSegmentId] [int] NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductFamily] PRIMARY KEY CLUSTERED 
(
	[ProductFamilyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSegment]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSegment](
	[ProductSegmentId] [int] IDENTITY(1,1) NOT NULL,
	[ProductSegmentCode] [varchar](50) NOT NULL,
	[ProductSegmentDescription] [varchar](1000) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductSegment] PRIMARY KEY CLUSTERED 
(
	[ProductSegmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PublicViewableDateSetting]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PublicViewableDateSetting](
	[PublicViewableDateId] [int] IDENTITY(1,1) NOT NULL,
	[PublicViewableDate] [date] NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [date] NOT NULL,
 CONSTRAINT [PK_PublicViewableDateSetting] PRIMARY KEY CLUSTERED 
(
	[PublicViewableDateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Report]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[ProductBrickId] [int] NULL,
	[ReporterOrganizationId] [int] NOT NULL,
	[SubmittedDate] [datetime] NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CopiedFromReportId] [int] NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportAccountableOrganization]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportAccountableOrganization](
	[ReportAccountableOrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[AccountableOrganizationId] [int] NOT NULL,
	[TargetAgeGroupDescription] [varchar](50) NOT NULL,
	[RequestedConfidentialFlag] [char](1) NOT NULL,
	[IsConfidentialFlag] [char](1) NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ReportAccountableOrganization] PRIMARY KEY CLUSTERED 
(
	[ReportAccountableOrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportDetail]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportDetail](
	[ReportDetailId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[ComponentId] [int] NOT NULL,
	[ChemicalId] [int] NOT NULL,
	[ChemicalFunctionId] [int] NOT NULL,
	[ConcentrationCategoryId] [int] NULL,
	[ConcentrationValue] [int] NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ReportDetail] PRIMARY KEY CLUSTERED 
(
	[ReportDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 1/3/2019 2:25:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[UserAccountId] [int] IDENTITY(1,1) NOT NULL,
	[AffiliationId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[DeletedAccountFlag] [char](1) NOT NULL,
	[BannedAccountFlag] [char](1) NOT NULL,
	[CreatedByName] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedByName] [varchar](256) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[BannedReasonDescription] [varchar](2000) NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[UserAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Tracking Modifications via Script
	-- 01 - Create hosting table
	CREATE TABLE dbo._TrackModifications
		(
			ID int NOT NULL IDENTITY (1, 1),
			ModificationType nvarchar(50) NOT NULL,
			Version nvarchar(7) NOT NULL,
			Descriptions nvarchar(255) NULL,
			AppliedOn datetime NOT NULL
		)  ON [PRIMARY]
	GO
	ALTER TABLE dbo._TrackModifications ADD CONSTRAINT
		DF_TrackModifications_AppliedOn DEFAULT GETUTCDATE() FOR AppliedOn
	GO

	-- 02 - Sequences to keep track of releases
	CREATE SEQUENCE dbo.SeqVerMajor as int START WITH 0 INCREMENT BY 1;
	CREATE SEQUENCE dbo.SeqVerMinor as int START WITH 1 INCREMENT BY 1;
	CREATE SEQUENCE dbo.SeqVerPatch as int START WITH 0 INCREMENT BY 1;
	GO
	
	-- 03 - Function the retrieves current version
	CREATE FUNCTION dbo.FuncGetVersion ( )
		RETURNS nvarchar(10)
		AS
		BEGIN
			DECLARE @seq1 int;
			DECLARE @seq2 int;
			DECLARE @seq3 int;
	
			-- @seq1 = NEXT VALUE FOR dbo.SeqVerMajor;
			-- @seq2 = NEXT VALUE FOR dbo.SeqVerMinor;
			-- @seq3 = NEXT VALUE FOR dbo.SeqVerPatch;

			SELECT @seq1 = Cast( current_value as int) FROM sys.sequences WHERE [name]='SeqVerMajor';
			SELECT @seq2 = Cast( current_value as int) FROM sys.sequences WHERE [name]='SeqVerMinor';
			SELECT @seq3 = Cast( current_value as int) FROM sys.sequences WHERE [name]='SeqVerPatch';

			-- SELECT current_value, name FROM sys.sequences WHERE [name]in('SeqVerMajor','SeqVerMinor','SeqVerPatch');

			-- Return the result of the function
			RETURN FORMATMESSAGE('%i.%i.%i', @seq1, @seq2, @seq3)
		END
		GO
	
	-- 04 - Example of tracking 
	DECLARE @t int = NEXT VALUE FOR dbo.SeqVerMinor;

	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		 VALUES ('Schema' , dbo.FuncGetVersion() ,'Initilization')
	GO
