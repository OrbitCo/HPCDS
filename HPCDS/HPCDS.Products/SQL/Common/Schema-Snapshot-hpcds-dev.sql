USE [master]
GO
/****** Object:  Database [hpcds-dev]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE DATABASE [hpcds-dev]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hpcds-pp', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-dev.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'hpcds-pp_log', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-dev_log.ldf' , SIZE = 22528KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [hpcds-dev] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hpcds-dev].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hpcds-dev] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hpcds-dev] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hpcds-dev] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hpcds-dev] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hpcds-dev] SET ARITHABORT OFF 
GO
ALTER DATABASE [hpcds-dev] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hpcds-dev] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hpcds-dev] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hpcds-dev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hpcds-dev] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hpcds-dev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hpcds-dev] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hpcds-dev] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hpcds-dev] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hpcds-dev] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hpcds-dev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hpcds-dev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hpcds-dev] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hpcds-dev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hpcds-dev] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hpcds-dev] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hpcds-dev] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hpcds-dev] SET RECOVERY FULL 
GO
ALTER DATABASE [hpcds-dev] SET  MULTI_USER 
GO
ALTER DATABASE [hpcds-dev] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hpcds-dev] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hpcds-dev] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hpcds-dev] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [hpcds-dev] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [hpcds-dev] SET QUERY_STORE = OFF
GO
USE [hpcds-dev]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [hpcds-dev]
GO
/****** Object:  User [HPCDS_WEB_USER]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE USER [HPCDS_WEB_USER] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [HPCDS_ADMIN]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE USER [HPCDS_ADMIN] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [annaone]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE USER [annaone] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [HPCDS_WEB_USER]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [HPCDS_WEB_USER]
GO
ALTER ROLE [db_owner] ADD MEMBER [HPCDS_ADMIN]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [HPCDS_ADMIN]
GO
USE [hpcds-dev]
GO
/****** Object:  Sequence [dbo].[SeqVerMajor]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE SEQUENCE [dbo].[SeqVerMajor] 
 AS [int]
 START WITH 0
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [hpcds-dev]
GO
/****** Object:  Sequence [dbo].[SeqVerMinor]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE SEQUENCE [dbo].[SeqVerMinor] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [hpcds-dev]
GO
/****** Object:  Sequence [dbo].[SeqVerPatch]    Script Date: 5/15/2019 10:10:43 PM ******/
CREATE SEQUENCE [dbo].[SeqVerPatch] 
 AS [int]
 START WITH 0
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  UserDefinedFunction [dbo].[FuncGetVersion]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
	-- 03 - Function the retrieves current version
	CREATE FUNCTION [dbo].[FuncGetVersion] ( )
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
/****** Object:  Table [dbo].[Chemical]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ChemicalFunction]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[Component]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ConcentrationCategory]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[CSPAOrganization]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ProductBrick]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ProductClass]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ProductFamily]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ProductSegment]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[Report]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ReportAccountableOrganization]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ReportDetail]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  View [dbo].[vOrganizations]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  View [dbo].[vSearchReport]    Script Date: 5/15/2019 10:10:43 PM ******/
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
				, 'WA' as States
				, YEAR(dbo.Report.SubmittedDate) as Period
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
/****** Object:  View [dbo].[vQuestions]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vQuestions] AS
		SELECT ID, Questions
		FROM   [hpcds-auth].dbo.SecurityQuestions
GO
/****** Object:  View [dbo].[vUserRoles]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vUserRoles] AS
		SELECT Id, Name
		FROM   [hpcds-auth].dbo.AspNetRoles
GO
/****** Object:  Table [dbo].[_TrackModifications]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_TrackModifications](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ModificationType] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](7) NOT NULL,
	[Descriptions] [nvarchar](255) NULL,
	[AppliedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[L_Country]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[L_Country](
	[Code] [char](2) NOT NULL,
	[CountryName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[L_State]    Script Date: 5/15/2019 10:10:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[L_State](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [char](2) NOT NULL,
	[AlphaCode] [char](2) NULL,
	[StateName] [varchar](70) NOT NULL,
	[FIPSCode] [char](2) NULL,
	[UPDATED_BY] [nvarchar](128) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
 CONSTRAINT [PK_L_State] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationRelationship]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[PublicViewableDateSetting]    Script Date: 5/15/2019 10:10:43 PM ******/
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
/****** Object:  Table [dbo].[UserAccount]    Script Date: 5/15/2019 10:10:43 PM ******/
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
ALTER TABLE [dbo].[_TrackModifications] ADD  CONSTRAINT [DF_TrackModifications_AppliedOn]  DEFAULT (getutcdate()) FOR [AppliedOn]
GO
ALTER TABLE [dbo].[L_State] ADD  DEFAULT ('AUTO, ON INSERT') FOR [UPDATED_BY]
GO
ALTER TABLE [dbo].[L_State] ADD  DEFAULT (getutcdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[L_State]  WITH CHECK ADD  CONSTRAINT [FK_L_State_L_Country] FOREIGN KEY([CountryCode])
REFERENCES [dbo].[L_Country] ([Code])
GO
ALTER TABLE [dbo].[L_State] CHECK CONSTRAINT [FK_L_State_L_Country]
GO
USE [master]
GO
ALTER DATABASE [hpcds-dev] SET  READ_WRITE 
GO
