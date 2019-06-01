USE [master]
GO
/****** Object:  Database [hpcds-auth]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE DATABASE [hpcds-auth]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hpcds-auth', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-auth.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'hpcds-auth_log', FILENAME = N'C:\Users\onx6\AppData\Local\MSSQLLocalDB\Data\hpcds-auth_log.ldf' , SIZE = 22528KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [hpcds-auth] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hpcds-auth].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hpcds-auth] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hpcds-auth] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hpcds-auth] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hpcds-auth] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hpcds-auth] SET ARITHABORT OFF 
GO
ALTER DATABASE [hpcds-auth] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hpcds-auth] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hpcds-auth] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hpcds-auth] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hpcds-auth] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hpcds-auth] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hpcds-auth] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hpcds-auth] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hpcds-auth] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hpcds-auth] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hpcds-auth] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hpcds-auth] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hpcds-auth] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hpcds-auth] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hpcds-auth] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hpcds-auth] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hpcds-auth] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hpcds-auth] SET RECOVERY FULL 
GO
ALTER DATABASE [hpcds-auth] SET  MULTI_USER 
GO
ALTER DATABASE [hpcds-auth] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hpcds-auth] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hpcds-auth] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hpcds-auth] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [hpcds-auth] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [hpcds-auth] SET QUERY_STORE = OFF
GO
USE [hpcds-auth]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [hpcds-auth]
GO
/****** Object:  User [HPCDS_WEB_USER]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE USER [HPCDS_WEB_USER] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [HPCDS_ADMIN]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE USER [HPCDS_ADMIN] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [annaone]    Script Date: 5/15/2019 10:10:02 PM ******/
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
USE [hpcds-auth]
GO
/****** Object:  Sequence [dbo].[SeqAddressId]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE SEQUENCE [dbo].[SeqAddressId] 
 AS [int]
 START WITH 1000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [hpcds-auth]
GO
/****** Object:  Sequence [dbo].[SeqOrganizationId]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE SEQUENCE [dbo].[SeqOrganizationId] 
 AS [int]
 START WITH 1000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
USE [hpcds-auth]
GO
/****** Object:  Sequence [dbo].[SeqQuestionId]    Script Date: 5/15/2019 10:10:02 PM ******/
CREATE SEQUENCE [dbo].[SeqQuestionId] 
 AS [int]
 START WITH 52
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 5/15/2019 10:10:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApiAudiences]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApiAudiences](
	[ClientId] [nvarchar](32) NOT NULL,
	[Base64Secret] [nvarchar](80) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Domain] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_dbo.ApiAudiences] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Hometown] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[PhoneInternationalFlag] [bit] NOT NULL,
	[O_ID] [int] NOT NULL,
	[SecQandAFailCount] [int] NOT NULL,
	[JobTitle] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationAddresses]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationAddresses](
	[ID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[AddressType] [int] NOT NULL,
	[AddressLine1] [nvarchar](150) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[City] [nvarchar](40) NULL,
	[StateProv] [nvarchar](70) NULL,
	[PostalCodeNumber] [nvarchar](24) NULL,
	[CountryCd] [nvarchar](30) NULL,
 CONSTRAINT [PK_dbo.OrganizationAddresses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizations](
	[ID] [int] NOT NULL,
	[PIN] [nvarchar](8) NULL,
	[OrganizationName] [nvarchar](255) NOT NULL,
	[IsLegacy] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LegacyWaPins] [nvarchar](36) NULL,
	[IsSameAsMailingAddress] [bit] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [uniqueidentifier] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ContactUserId] [nvarchar](128) NULL,
	[DUNSNumber] [nvarchar](9) NULL,
 CONSTRAINT [PK_dbo.Organizations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SecurityQuestions]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityQuestions](
	[ID] [int] NOT NULL,
	[Questions] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_dbo.SecurityQuestions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserQuestions]    Script Date: 5/15/2019 10:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserQuestions](
	[U_ID] [nvarchar](128) NOT NULL,
	[Q_ID] [int] NOT NULL,
	[Answer] [nvarchar](100) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_dbo.UserQuestions] PRIMARY KEY CLUSTERED 
(
	[U_ID] ASC,
	[Q_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_RoleId]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_O_ID]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_O_ID] ON [dbo].[AspNetUsers]
(
	[O_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ_OrganizationID_AddressType]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrganizationID_AddressType] ON [dbo].[OrganizationAddresses]
(
	[OrganizationID] ASC,
	[AddressType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ContactUserId]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_ContactUserId] ON [dbo].[Organizations]
(
	[ContactUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Nullable_PIN]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Nullable_PIN] ON [dbo].[Organizations]
(
	[PIN] ASC
)
WHERE ([PIN] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_OrganizationName]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_OrganizationName] ON [dbo].[Organizations]
(
	[OrganizationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Questions]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Questions] ON [dbo].[SecurityQuestions]
(
	[Questions] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Q_ID]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_Q_ID] ON [dbo].[UserQuestions]
(
	[Q_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_U_ID]    Script Date: 5/15/2019 10:10:03 PM ******/
CREATE NONCLUSTERED INDEX [IX_U_ID] ON [dbo].[UserQuestions]
(
	[U_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApiAudiences] ADD  DEFAULT ('') FOR [Domain]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ('') FOR [FirstName]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ('') FOR [LastName]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [PhoneInternationalFlag]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [O_ID]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [SecQandAFailCount]
GO
ALTER TABLE [dbo].[OrganizationAddresses] ADD  CONSTRAINT [DF_dbo.OrganizationAddresses_ID]  DEFAULT (NEXT VALUE FOR [dbo].[SeqAddressId]) FOR [ID]
GO
ALTER TABLE [dbo].[Organizations] ADD  CONSTRAINT [DF_dbo.Organizations_ID]  DEFAULT (NEXT VALUE FOR [dbo].[SeqOrganizationId]) FOR [ID]
GO
ALTER TABLE [dbo].[SecurityQuestions] ADD  CONSTRAINT [DF_dbo.Questions_ID]  DEFAULT (NEXT VALUE FOR [dbo].[SeqQuestionId]) FOR [ID]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUsers_dbo.Organizations_O_ID] FOREIGN KEY([O_ID])
REFERENCES [dbo].[Organizations] ([ID])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_dbo.AspNetUsers_dbo.Organizations_O_ID]
GO
ALTER TABLE [dbo].[OrganizationAddresses]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrganizationAddresses_dbo.Organizations_OrganizationID] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organizations] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrganizationAddresses] CHECK CONSTRAINT [FK_dbo.OrganizationAddresses_dbo.Organizations_OrganizationID]
GO
ALTER TABLE [dbo].[Organizations]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Organizations_dbo.AspNetUsers_ContactUserId] FOREIGN KEY([ContactUserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Organizations] CHECK CONSTRAINT [FK_dbo.Organizations_dbo.AspNetUsers_ContactUserId]
GO
ALTER TABLE [dbo].[UserQuestions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserQuestions_dbo.AspNetUsers_U_ID] FOREIGN KEY([U_ID])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserQuestions] CHECK CONSTRAINT [FK_dbo.UserQuestions_dbo.AspNetUsers_U_ID]
GO
ALTER TABLE [dbo].[UserQuestions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserQuestions_dbo.SecurityQuestions_Q_ID] FOREIGN KEY([Q_ID])
REFERENCES [dbo].[SecurityQuestions] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserQuestions] CHECK CONSTRAINT [FK_dbo.UserQuestions_dbo.SecurityQuestions_Q_ID]
GO
USE [master]
GO
ALTER DATABASE [hpcds-auth] SET  READ_WRITE 
GO
