USE [master]
GO
/****** Object:  Database [hpcds-states]    Script Date: 3/13/2019 10:51:27 PM ******/
CREATE DATABASE [hpcds-states]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hpcds-states', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-states.mdf' , SIZE = 729088KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hpcds-states_log', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-states_log.ldf' , SIZE = 3612672KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [hpcds-states] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hpcds-states].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hpcds-states] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hpcds-states] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hpcds-states] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hpcds-states] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hpcds-states] SET ARITHABORT OFF 
GO
ALTER DATABASE [hpcds-states] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [hpcds-states] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hpcds-states] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hpcds-states] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hpcds-states] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hpcds-states] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hpcds-states] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hpcds-states] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hpcds-states] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hpcds-states] SET  ENABLE_BROKER 
GO
ALTER DATABASE [hpcds-states] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hpcds-states] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hpcds-states] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hpcds-states] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hpcds-states] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hpcds-states] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hpcds-states] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hpcds-states] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [hpcds-states] SET  MULTI_USER 
GO
ALTER DATABASE [hpcds-states] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hpcds-states] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hpcds-states] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hpcds-states] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [hpcds-states] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [hpcds-states] SET QUERY_STORE = OFF
GO
USE [hpcds-states]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [hpcds-states]
GO
/****** Object:  User [HPCDS_ADMIN]    Script Date: 3/13/2019 10:51:27 PM ******/
CREATE USER [HPCDS_ADMIN] FOR LOGIN [HPCDS_ADMIN] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HPCDS_ADMIN]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [HPCDS_ADMIN]
GO
/****** Object:  Table [dbo].[OR-tblTFK_compiled_addreporterinfo]    Script Date: 3/13/2019 10:51:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OR-tblTFK_compiled_addreporterinfo](
	[Filename] [varchar](70) NOT NULL,
	[Manufacturer/TaxID] [varchar](10) NULL,
	[OR-IDAssignedByERG] [int] NULL,
	[Brickforproduct] [varchar](100) NULL,
	[ComponentName] [varchar](100) NULL,
	[ChemicalNamewithCAS] [varchar](100) NULL,
	[ConcentrationRangeCategory] [varchar](70) NULL,
	[ChemicalFunction] [varchar](200) NULL,
	[TargetAgeCategory] [varchar](15) NULL,
	[NumberofBricksSoldinORin2017] [int] NULL,
	[NumberofBricksOFFEREDforsaleinORin2017] [varchar](30) NULL,
	[State] [varchar](3) NULL,
	[Country] [varchar](20) NULL,
	[Manufacturer] [varchar](70) NULL,
	[Mailling Address-mfg] [varchar](150) NULL,
	[City-mfg] [varchar](50) NULL,
	[State-mfg] [varchar](20) NULL,
	[ZIP code-mfg] [varchar](15) NULL,
	[ContactPerson1] [varchar](40) NULL,
	[ContactPerson1_email] [varchar](50) NULL,
	[ContactPerson1_title] [varchar](90) NULL,
	[ContactPerson1_phone] [varchar](30) NULL,
	[EarliestSubmissionDate] [varchar](20) NULL,
	[LatestSubmissionDate] [varchar](20) NULL,
	[NumberOfSubmissions] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VT-Disclosure_Chemical_Data]    Script Date: 3/13/2019 10:51:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VT-Disclosure_Chemical_Data](
	[DisclosureID] [nvarchar](50) NOT NULL,
	[ChemicalID] [nvarchar](50) NOT NULL,
	[ChemicalNameDescription] [nvarchar](150) NOT NULL,
	[ChemicalFunction] [nvarchar](150) NOT NULL,
	[Component] [nvarchar](150) NOT NULL,
	[Concentration] [nvarchar](150) NOT NULL,
	[BrickID] [nvarchar](50) NOT NULL,
	[BrickName] [nvarchar](150) NOT NULL,
	[TradeSecretDesc] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[SubmittedBy] [nvarchar](150) NOT NULL,
	[DateTime] [nvarchar](50) NOT NULL,
	[ManufacturerID] [nvarchar](50) NOT NULL,
	[ManufacturerName] [nvarchar](150) NOT NULL,
	[PhysicalAddressofManufacturer] [nvarchar](300) NOT NULL,
	[ManufacturerContactPerson] [nvarchar](100) NOT NULL,
	[ManufacturerContactPersonAddress] [nvarchar](300) NOT NULL,
	[ManufacturerContactEmailAddress] [nvarchar](50) NOT NULL,
	[ManufacturerContactPhoneNumber] [nvarchar](50) NOT NULL,
	[TradeAssociationID] [nvarchar](50) NOT NULL,
	[TradeAssociationName] [nvarchar](100) NOT NULL,
	[PhysicalAddressofTradeAssociation] [nvarchar](150) NOT NULL,
	[TradeAssociationContactPerson] [nvarchar](50) NOT NULL,
	[TradeAssociationContactPersonAddress] [nvarchar](100) NOT NULL,
	[TradeAssociationEmailAddress] [nvarchar](50) NOT NULL,
	[TradeAssociationPhoneNumber] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VT-Disclosure_Products_Data]    Script Date: 3/13/2019 10:51:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VT-Disclosure_Products_Data](
	[DisclosureNumber] [varchar](1000) NULL,
	[ManufacturerName] [varchar](1000) NULL,
	[ChemicalID] [varchar](1000) NULL,
	[ChemicalNameDescription] [varchar](1000) NULL,
	[BrandName] [varchar](1000) NULL,
	[ProductModel] [varchar](1000) NULL,
	[Status] [varchar](1000) NULL,
	[DateTime] [varchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WA-Chemical]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Chemical](
	[ChemicalId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ChemicalFunction]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ChemicalFunction](
	[ChemicalFunctionId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-Component]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Component](
	[ComponentId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ConcentrationCategory]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ConcentrationCategory](
	[ConcentrationCategoryId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-CSPAOrganization]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-CSPAOrganization](
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
/****** Object:  Table [dbo].[WA-Document]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Document](
	[DocumentId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-OrganizationRelationship]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-OrganizationRelationship](
	[OrganizationRelationshipId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductBrick]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductBrick](
	[ProductBrickId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductCategory]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductCategory](
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
/****** Object:  Table [dbo].[WA-ProductClass]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductClass](
	[ProductClassId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductFamily]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductFamily](
	[ProductFamilyId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductSegment]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductSegment](
	[ProductSegmentId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-PublicViewableDateSetting]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-PublicViewableDateSetting](
	[PublicViewableDateId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-Report]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Report](
	[ReportId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ReportAccountableOrganization]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ReportAccountableOrganization](
	[ReportAccountableOrganizationId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-ReportDetail]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ReportDetail](
	[ReportDetailId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[WA-UserAccount]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-UserAccount](
	[UserAccountId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[XREF_OR_TO_MASTER_ORG]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XREF_OR_TO_MASTER_ORG](
	[MOID] [int] NOT NULL,
	[OR_ID] [varchar](15) NOT NULL,
	[OR_ID_AssignedByERG] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XREF_VT_TO_MASTER_ORG]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XREF_VT_TO_MASTER_ORG](
	[MOID] [int] NOT NULL,
	[VT_manufacturer_ID] [int] NOT NULL,
	[IsManufactureId] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XREF_WA_TO_MASTER_ORG]    Script Date: 3/13/2019 10:51:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XREF_WA_TO_MASTER_ORG](
	[MOID] [int] NOT NULL,
	[WA_ID] [int] NOT NULL,
	[WA_PIN] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[XREF_WA_TO_MASTER_ORG]  WITH CHECK ADD  CONSTRAINT [FK_XREF_WA_TO_MASTER_ORG_WA-CSPAOrganization] FOREIGN KEY([WA_ID])
REFERENCES [dbo].[WA-CSPAOrganization] ([AffiliationOrganizationId])
GO
ALTER TABLE [dbo].[XREF_WA_TO_MASTER_ORG] CHECK CONSTRAINT [FK_XREF_WA_TO_MASTER_ORG_WA-CSPAOrganization]
GO
USE [master]
GO
ALTER DATABASE [hpcds-states] SET  READ_WRITE 
GO
