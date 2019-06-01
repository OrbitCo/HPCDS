USE [hpcds-dev] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Applied to: DbVersion v0.4, after initial login/registration module
--
-- Purpose: To apply changes related to sprint 4b, Login/Registration Modules, part 2 - related to My Org profiles
--          Schema Changes

SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


DECLARE @sq int;
DECLARE @DbVer nvarchar(10);

SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;

-- HPCDS-62 - Registration: State and Country Data records and E4bditors	
	-- 01 - Create Lookup tables
	/****** Object:  Table [dbo].[L_Country]    Script Date: 4/16/2019 3:12:02 PM ******/
	CREATE TABLE [dbo].[L_Country](
		[Code] [char](2) NOT NULL,
		[CountryName] [varchar](100) NOT NULL,
	 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
	(
		[Code] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO
	/****** Object:  Table [dbo].[L_State]    Script Date: 4/16/2019 3:12:02 PM ******/
	CREATE TABLE [dbo].[L_State](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[CountryCode] [char](2) NOT NULL,
		[AlphaCode] [char](2) NULL,
		[StateName] [varchar](70) NOT NULL,
		[FIPSCode] char(2) NULL,
		[UPDATED_BY] nvarchar(128) NOT NULL DEFAULT 'AUTO, ON INSERT',
		[UPDATED_ON] datetime NOT NULL DEFAULT GETUTCDATE()
	 CONSTRAINT [PK_L_State] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	-- 01b - Set FKey
	ALTER TABLE [dbo].[L_State]  WITH CHECK ADD  CONSTRAINT [FK_L_State_L_Country] FOREIGN KEY([CountryCode])
	REFERENCES [dbo].[L_Country] ([Code])
	GO
	ALTER TABLE [dbo].[L_State] CHECK CONSTRAINT [FK_L_State_L_Country]
	GO

	-- 02 - Track Change
	ALTER SEQUENCE [dbo].[SeqVerPatch] RESTART  WITH 0 ;
	declare @sq int = NEXT VALUE FOR dbo.SeqVerMinor; 
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
    declare @DbVer nvarchar(10) = dbo.FuncGetVersion();
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-Table' , @DbVer,'HPCDS-62 - Registration: State and Country Data records and Editors')
    ;

COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
