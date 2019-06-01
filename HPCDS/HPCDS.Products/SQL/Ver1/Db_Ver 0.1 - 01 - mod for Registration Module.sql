USE [hpcds-dev] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]

-- Applied to: DbVersion v0.1, after initial creation
--
-- Purpose: To apply changes related to sprint 3, Login/Registration Modules

SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


DECLARE @sq int;
DECLARE @DbVer nvarchar(10);

SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;

-- (HPCDS-51/16) Views for tables in auth database ------------------------
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	SET @DbVer = dbo.FuncGetVersion();

	-- 01 - Create views ot auth related tables for hpcds, which were created via Code-First EF method
	EXEC('CREATE VIEW [dbo].[vQuestions] AS
		SELECT ID, Questions
		FROM   [hpcds-auth].dbo.SecurityQuestions');

	EXEC('CREATE VIEW [dbo].[vUserRoles] AS
		SELECT Id, Name
		FROM   [hpcds-auth].dbo.AspNetRoles');
		
	-- 02 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		 VALUES ('Schema-View' , @DbVer,'HPCDS-51/16 - Views to auth Questions and UserRoles')
	;


-- (HPCDS-18) Views for tables in auth database ------------------------
	SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
	SET @DbVer = dbo.FuncGetVersion();
	

	-- 01 - Create views ot auth related tables for hpcds, which were created via Code-First EF method
	EXEC('CREATE VIEW [dbo].[vOrganizations] AS
		SELECT [ID],[PIN],[OrganizationName],[IsLegacy],[LegacyWaPins],[IsActive]
		FROM   [hpcds-auth].dbo.Organizations;');

	-- 02 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
		 VALUES ('Schema-View' , @DbVer,'HPCDS-18 - Registering Orgs w/LegacyWaPins')
	;

    SET @sq = NEXT VALUE FOR dbo.SeqVerMinor; 
    SET @DbVer = dbo.FuncGetVersion();
    
    -- 01 - Create views ot auth related tables for hpcds, which were created via Code-First EF method
    EXEC('CREATE VIEW [dbo].[vLegacy_Organization] AS
        SELECT *
        FROM   [hpcds-states].dbo.[Legacy_Organization];');

    -- 02 - Track Change
    INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
         VALUES ('Schema-View' , @DbVer,'HPCDS-11 - Access Read-only Legacy Organiztion Data')
    ;
	
COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
