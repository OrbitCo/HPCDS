USE [master]
GO
-- 2019-03-20 - Created on ERG-DevDb 
--            N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\'
-- Local, Em: N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\'

/****** Object:  Database [hpcds-states]    Script Date: 3/13/2019 2:35:18 PM ******/
CREATE DATABASE [hpcds-states]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hpcds-states', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\hpcds-states.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hpcds-states_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\hpcds-states_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [hpcds-states] SET COMPATIBILITY_LEVEL = 110
GO

USE [hpcds-states]
GO
/****** Object:  User [hpcds-Admin]    Script Date: 12/26/2018 6:47:32 PM ******/
CREATE USER [HPCDS_ADMIN] FOR LOGIN [HPCDS_ADMIN] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HPCDS_ADMIN]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [HPCDS_ADMIN]
GO

/****** Object:  Table [dbo].[VT-Disclosure_Chemical_Data]    Script Date: 11/7/2018 11:57:09 AM ******/
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

/****** Object:  Table [dbo].[VT-Disclosure_Products_Data]    Script Date: 11/7/2018 11:57:46 AM ******/
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

	--/****** Object:  Table [dbo].[VT-HLAddress]    Script Date: 12/27/2018 11:58:15 AM ******/
	--CREATE TABLE [dbo].[VT-HLAddress](
	--	[ID] [int] NOT NULL,
	--	[Address1] [varchar](max) NULL,
	--	[Address2] [varchar](max) NULL,
	--	[City] [varchar](50) NULL,
	--	[StateCode] [char](2) NULL,
	--	[StateName] [varchar](100) NULL,
	--	[CountryID] [char](3) NULL,
	--	[Zip5] [char](5) NULL,
	--	[Zip4] [char](4) NULL,
	--	[Phone] [varchar](15) NULL,
	--	[Email] [varchar](100) NULL
	--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLBrick]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLBrick](
	--	[ID] [int] NOT NULL,
	--	[BrickNumber] [varchar](50) NULL,
	--	[Description] [varchar](255) NULL,
	--	[Category] [varchar](100) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLCAS]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLCAS](
	--	[ID] [int] NOT NULL,
	--	[CAS] [varchar](255) NULL,
	--	[ChemicalName] [varchar](255) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLChemicalFunctions]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLChemicalFunctions](
	--	[ID] [int] NOT NULL,
	--	[DisclosureID] [int] NOT NULL,
	--	[PrimayFunctionID] [int] NOT NULL,
	--	[ProductDescriptionID] [int] NOT NULL,
	--	[BrickID] [int] NOT NULL,
	--	[TradeSecretID] [int] NOT NULL,
	--	[ConcentrationID] [int] NOT NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLClient]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLClient](
	--	[ID] [int] NOT NULL,
	--	[MembershipID] [int] NOT NULL,
	--	[ClientID] [int] NOT NULL,
	--	[ClientTypeID] [char](2) NULL,
	--	[ClientName] [varchar](100) NOT NULL,
	--	[UserID] [nvarchar](100) NOT NULL,
	--	[Email] [varchar](100) NULL,
	--	[PhoneAreaCode] [char](3) NULL,
	--	[PhoneNo] [char](7) NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[CreatedIP] [varchar](15) NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](15) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLConcentration]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLConcentration](
	--	[ID] [int] NOT NULL,
	--	[Description] [varchar](255) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLCountry]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLCountry](
	--	[ID] [char](3) NOT NULL,
	--	[Description] [varchar](50) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLDisclosure]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLDisclosure](
	--	[ID] [int] NOT NULL,
	--	[DisclosureID] [varchar](50) NOT NULL,
	--	[CASID] [int] NOT NULL,
	--	[ClientId] [int] NOT NULL,
	--	[ManufacturerID] [int] NOT NULL,
	--	[TradeAssociationID] [int] NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedIP] [varchar](20) NULL,
	--	[Status] [varchar](15) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLDisclosureFiling]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLDisclosureFiling](
	--	[Id] [int] NOT NULL,
	--	[DisclosureId] [int] NULL,
	--	[FilingDescription] [varchar](100) NULL,
	--	[FilingDateTime] [datetime] NULL,
	--	[IsOnlineFiling] [bit] NULL,
	--	[EffectiveDate] [datetime] NULL,
	--	[ClientID] [int] NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLDocumentGeneration]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLDocumentGeneration](
	--	[ID] [int] NOT NULL,
	--	[DocumentTypeID] [tinyint] NOT NULL,
	--	[WorkOrderID] [int] NULL,
	--	[FileName] [varchar](200) NULL,
	--	[Filepath] [varchar](255) NULL,
	--	[ClientID] [int] NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLMailDeliveryNotice]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLMailDeliveryNotice](
	--	[NoticeId] [int] NOT NULL,
	--	[ClientId] [int] NULL,
	--	[EmailAddress] [varchar](256) NULL,
	--	[TransactionType] [char](256) NULL,
	--	[SentTime] [datetime] NULL,
	--	[IPAddress] [varchar](50) NULL,
	--	[Id] [int] NULL,
	--	[Body] [varchar](max) NULL,
	--	[EmailSubject] [varchar](200) NULL
	--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLManfandTradeAssociationID]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLManfandTradeAssociationID](
	--	[ID] [int] NOT NULL,
	--	[ManufacturerID] [int] NOT NULL,
	--	[TradeAssociationID] [int] NOT NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLManufacturer]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLManufacturer](
	--	[ID] [int] NOT NULL,
	--	[Name] [varchar](255) NULL,
	--	[AddressID] [int] NOT NULL,
	--	[ContactName] [varchar](255) NULL,
	--	[ContactAddressID] [int] NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLMembership]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLMembership](
	--	[MembershipId] [int] NOT NULL,
	--	[UserName] [varchar](50) NOT NULL,
	--	[Password] [varchar](50) NOT NULL,
	--	[LastLogin] [datetime] NULL,
	--	[IsOnline] [bit] NULL,
	--	[CreatedDate] [datetime] NULL,
	--	[CreatedIP] [varchar](20) NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](20) NULL,
	--	[CreatedBy] [int] NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLPaymentMethod]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLPaymentMethod](
	--	[ID] [tinyint] NOT NULL,
	--	[Description] [varchar](50) NULL,
	--	[PaymentID] [char](3) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLPaymentStatus]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLPaymentStatus](
	--	[Id] [char](2) NOT NULL,
	--	[PaymentStatusDesc] [varchar](50) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLPrimayFunction]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLPrimayFunction](
	--	[ID] [int] NOT NULL,
	--	[Description] [varchar](255) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLProductDescription]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLProductDescription](
	--	[ID] [int] NOT NULL,
	--	[Description] [varchar](255) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLProductFileInfo]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLProductFileInfo](
	--	[Id] [int] NOT NULL,
	--	[FileName] [varchar](300) NULL,
	--	[FilePath] [varchar](300) NULL,
	--	[DisclosureID] [int] NULL,
	--	[Status] [char](1) NULL,
	--	[CreatedDate] [datetime] NULL,
	--	[CreatedBy] [int] NULL,
	--	[CreatedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLProducts]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLProducts](
	--	[ID] [int] NOT NULL,
	--	[ProductBrandName] [varchar](255) NULL,
	--	[Model] [varchar](255) NULL,
	--	[DisclosureID] [int] NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLReports]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLReports](
	--	[ID] [int] NOT NULL,
	--	[StartDate] [datetime] NULL,
	--	[EndDate] [datetime] NULL,
	--	[FileName] [varchar](100) NULL,
	--	[FilePath] [varchar](500) NULL,
	--	[CreatedDate] [datetime] NULL,
	--	[ReportType] [char](2) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLStaff]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLStaff](
	--	[ID] [int] NOT NULL,
	--	[StaffName] [varchar](100) NULL,
	--	[Email] [varchar](100) NULL,
	--	[PhoneAreaCode] [char](3) NULL,
	--	[PhoneNo] [char](7) NULL,
	--	[MembershipID] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[CreatedIP] [varchar](15) NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](15) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLState]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLState](
	--	[StateCode] [char](2) NOT NULL,
	--	[Name] [varchar](30) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTradeAssociation]    Script Date: 12/27/2018 11:58:15 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTradeAssociation](
	--	[ID] [int] NOT NULL,
	--	[Name] [varchar](255) NULL,
	--	[AddressID] [int] NOT NULL,
	--	[ContactName] [varchar](255) NULL,
	--	[ContactAddressID] [int] NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTradeSecret]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTradeSecret](
	--	[ID] [int] NOT NULL,
	--	[Description] [varchar](255) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTransactionCategory]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTransactionCategory](
	--	[Id] [int] NOT NULL,
	--	[Description] [varchar](50) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTransactions]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTransactions](
	--	[Id] [int] NOT NULL,
	--	[WorkOrderId] [int] NULL,
	--	[TransactionTypeId] [int] NULL,
	--	[StatusId] [int] NULL,
	--	[Amount] [money] NULL,
	--	[DisclosureID] [int] NULL,
	--	[CheckNo] [varchar](25) NULL,
	--	[IsNoFee] [bit] NULL,
	--	[IsExpdite] [bit] NULL,
	--	[DateTimeReceived] [date] NULL,
	--	[DateTimeComplete] [date] NULL,
	--	[Comments] [varchar](250) NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTransactionStatus]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTransactionStatus](
	--	[Id] [int] NOT NULL,
	--	[StatusDesc] [varchar](50) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLTransactionType]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLTransactionType](
	--	[Id] [int] NOT NULL,
	--	[TransactionTypeCode] [varchar](20) NULL,
	--	[TransactionCategoryId] [int] NULL,
	--	[FilingCategoryId] [char](5) NULL,
	--	[Fee] [money] NULL,
	--	[ExpediteFee] [money] NULL,
	--	[Description] [varchar](100) NULL,
	--	[AdditionalFee] [money] NULL,
	--	[EffectiveStartDate] [date] NULL,
	--	[EffectiveEndDate] [date] NULL,
	--	[ReinstantFee] [money] NULL,
	--	[DateTimeCreated] [datetime] NULL,
	--	[ClientId] [int] NOT NULL,
	--	[ChangeFee] [money] NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NOT NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLUncommitedTransactions]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLUncommitedTransactions](
	--	[ID] [int] NOT NULL,
	--	[PaymentMethodID] [tinyint] NULL,
	--	[PaymentStatusID] [char](3) NULL,
	--	[CreditCardNumber] [char](9) NULL,
	--	[CreditCardExpiry] [date] NULL,
	--	[CreditCardAuthorizationNumber] [char](20) NULL,
	--	[AmountCreditCardSubmitted] [money] NULL,
	--	[ClientID] [int] NULL,
	--	[ErrorDescription] [varchar](250) NULL,
	--	[ManufacturerID] [int] NULL,
	--	[AccountNumber] [char](20) NULL,
	--	[ABACode] [char](9) NULL,
	--	[AccountType] [char](30) NULL,
	--	[BankName] [varchar](50) NULL,
	--	[BankAccount] [varchar](50) NULL,
	--	[CreatedBy] [int] NULL,
	--	[CreatedDate] [datetime] NULL,
	--	[CreatedIP] [varchar](15) NOT NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedIP] [varchar](15) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLWorkOrder]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLWorkOrder](
	--	[Id] [int] NOT NULL,
	--	[WorkorderNumber] [varchar](15) NULL,
	--	[SourceId] [tinyint] NULL,
	--	[TotalAmount] [money] NULL,
	--	[TotalPayAmount] [money] NULL,
	--	[IsOnline] [bit] NULL,
	--	[DateTimeReceived] [datetime] NULL,
	--	[DateTimeCompleted] [datetime] NULL,
	--	[ActualDateTimeReceived] [datetime] NULL,
	--	[ActualDateTimeCompleted] [datetime] NULL,
	--	[DateTimeCreated] [datetime] NULL,
	--	[SubmittiorName] [varchar](200) NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO
	--/****** Object:  Table [dbo].[VT-HLWorkOrderPay]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLWorkOrderPay](
	--	[Id] [int] NOT NULL,
	--	[WorkorderId] [int] NULL,
	--	[Amount] [money] NULL,
	--	[PaymentTypeId] [char](3) NULL,
	--	[RoutingNumber] [varchar](50) NULL,
	--	[AccountNumber] [varchar](50) NULL,
	--	[ChCrMoNo] [varchar](50) NULL,
	--	[ChCrMoName] [varchar](100) NULL,
	--	[ChCrMoReject] [bit] NULL,
	--	[PaymentStatusId] [char](2) NULL,
	--	[DateTimeCreated] [datetime] NULL,
	--	[IPAddress] [varchar](15) NULL,
	--	[AuthorizationNo] [varchar](20) NULL,
	--	[UserId] [int] NULL,
	--	[PaymentReferenceNo] [varchar](50) NULL,
	--	[CardType] [varchar](3) NULL,
	--	[ClientId] [int] NOT NULL,
	--	[CreatedBy] [int] NOT NULL,
	--	[CreatedIP] [varchar](20) NOT NULL,
	--	[CreatedDate] [datetime] NOT NULL,
	--	[ModifiedDate] [datetime] NULL,
	--	[ModifiedBy] [int] NULL,
	--	[ModifiedIP] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO

	--/****** Object:  Table [dbo].[VT-HLWorkOrderSource]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [dbo].[VT-HLWorkOrderSource](
	--	[Id] [tinyint] NOT NULL,
	--	[Description] [varchar](20) NULL
	--) ON [PRIMARY]
	--GO

	--/****** Object:  Table [dbo].[VT-sysdiagrams]    Script Date: 12/27/2018 11:58:16 AM ******/
	--SET ANSI_NULLS ON
	--GO
	--SET QUOTED_IDENTIFIER ON
	--GO
	--CREATE TABLE [VT-sysdiagrams] (name nvarchar(128) NOT NULL
	--, principal_id int NOT NULL
	--, diagram_id int NOT NULL
	--, [version] int NULL
	--, [definition] varbinary(max) NULL)
	--GO

/****** Object:  Table [dbo].[WA-Chemical]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Chemical](
	[ChemicalId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ChemicalFunction]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ChemicalFunction](
	[ChemicalFunctionId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-Component]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Component](
	[ComponentId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ConcentrationCategory]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ConcentrationCategory](
	[ConcentrationCategoryId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-CSPAOrganization]    Script Date: 1/3/2019 2:25:44 PM ******/
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
/****** Object:  Table [dbo].[WA-Document]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Document](
	[DocumentId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-OrganizationRelationship]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-OrganizationRelationship](
	[OrganizationRelationshipId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductBrick]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductBrick](
	[ProductBrickId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductCategory]    Script Date: 10/23/2018 4:11:29 PM ******/
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
/****** Object:  Table [dbo].[WA-ProductClass]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductClass](
	[ProductClassId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductFamily]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductFamily](
	[ProductFamilyId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ProductSegment]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ProductSegment](
	[ProductSegmentId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-PublicViewableDateSetting]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-PublicViewableDateSetting](
	[PublicViewableDateId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-Report]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-Report](
	[ReportId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ReportAccountableOrganization]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ReportAccountableOrganization](
	[ReportAccountableOrganizationId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-ReportDetail]    Script Date: 10/23/2018 4:11:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-ReportDetail](
	[ReportDetailId] [int]  NOT NULL,
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
/****** Object:  Table [dbo].[WA-UserAccount]    Script Date: 1/3/2019 2:25:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WA-UserAccount](
	[UserAccountId] [int]  NOT NULL,
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

/****** Object:  Table [dbo].[OR-tblTFK_compiled_addreporterinfo]    Script Date: 1/7/2019 12:14:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OR-tblTFK_compiled_addreporterinfo](
	[Filename] [varchar](70) NOT NULL,
	[Manufacturer/TaxID] [varchar](10) NULL,
	[OR-IDAssignedByERG] [int] Null,
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

-- HPCDS-11 - Cross Reference Files to Master Legacy Org table
/****** Object:  Table [dbo].[XREF_OR_TO_MASTER_ORG]    Script Date: 2/7/2019 9:00:39 AM ******/
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
/****** Object:  Table [dbo].[XREF_VT_TO_MASTER_ORG]    Script Date: 2/7/2019 9:00:39 AM ******/
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
/****** Object:  Table [dbo].[XREF_WA_TO_MASTER_ORG]    Script Date: 2/7/2019 9:00:39 AM ******/
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

-- HPCDS-11 - Consolidated Organization List for mapping
/****** Object:  Table [dbo].[Legacy_Organization]    Script Date: 2/4/2019 9:23:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Legacy_Organization](
	[MOID] [int] NOT NULL,
	[Program Count] [int] NULL,
	[WA ID] [int] NULL,
	[WA PIN] [varchar](10) NULL,
	[WA-ID2] [int] NULL,
	[WA-PIN2] [varchar](10) NULL,
	[WA-ID3] [int] NULL,
	[WA-PIN3] [varchar](10) NULL,
	[VT-manufacturer ID] [int] NULL,
	[VT-manufacturer ID2] [int] NULL,
	[VT-Trade Assoc ID] [int] NULL,
	[OR- ID (Manufacturer ID/TIN)] [varchar](15) NULL,
	[OR- ID 2 (Manufacturer ID/TIN)2] [varchar](15) NULL,
	[OR-ID Assigned by ERG] [int] NULL,
	[MASTERNAME] [varchar](70) NULL,
	[Physical Address (VT)] [varchar](150) NULL,
	[Address source] [varchar](40) NULL,
	[Line1Address] [varchar](150) NULL,
	[Line2Address] [varchar](70) NULL,
	[CityName] [varchar](40) NULL,
	[StateCode] [varchar](20) NULL,
	[PostalCodeNumber] [varchar](15) NULL,
	[CountryCode] [varchar](15) NULL,
	[Secondary address] [varchar](150) NULL,
	[Notes from states] [varchar](250) NULL,
 CONSTRAINT [PK_Legacy_Organization] PRIMARY KEY CLUSTERED 
(
	[MOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

