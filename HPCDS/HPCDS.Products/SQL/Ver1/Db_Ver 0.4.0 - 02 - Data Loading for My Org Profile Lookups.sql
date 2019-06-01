USE [hpcds-dev] -- OR [hpcds-ir] [hpcds-pp] [hpcds-qa]
GO

-- Applied to: DbVersion v0.4, after initial login/registration module
--
-- Purpose: To apply changes related to sprint 4b, Login/Registration Modules, part 2 - related to My Org profiles
--          Data Load

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


SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- for version
DECLARE @sq int;
DECLARE @DbVer nvarchar(10);
-- for file loading
Declare @FileDir VARCHAR(400)
Declare @FilePath VARCHAR(700)
Declare @sql nvarchar(max)

-- before update
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;
BEGIN TRAN;

-- On ERG-DevDb: 
Set @FileDir = 'C:\data\HPCDS.esavelli'
-- Local, Smit/Em: Set @FileDir = '\\172.16.12.20\Shared\PUBLIC\Savelli.Em.bos\HPCDS\data'

-- HPCDS-62 - Registration: State and Country Data records and Editors
	SET @sq = NEXT VALUE FOR dbo.SeqVerPatch; 
    SET @DbVer = dbo.FuncGetVersion();

	--	SharePoint : https://easternresearchgroup.sharepoint.com/:x:/r/sites/HPCDS/Shared%20Documents/Data%20Analysis/HPCDS-62_Country%26State_Tables.xlsx?d=w394026be8a6446a8b8c96a9bf3e958ec&csf=1&e=z75GZd
	Set @FilePath= @FileDir + '\Core\HPCDS-62_Country&State_Tables.xlsx'
	-- 01 - Load data from Excel
	Set @sql=FORMATMESSAGE('insert into [L_Country] (Code, CountryName) 
							SELECT Code, CountryName 
							FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=%s'', ''SELECT * FROM [Country$]'')'
								,  @FilePath);
	Exec(@sql)

	Set @sql=FORMATMESSAGE('insert into [L_State] (CountryCode, AlphaCode, StateName, FIPSCode, UPDATED_BY) 
							SELECT CountryCode, AlphaCode, StateName, FIPSCode, ''SYS Login Module for HPCDS-62 (%s)'' 
							FROM OPENROWSET (''Microsoft.ACE.OLEDB.12.0'',  ''Excel 12.0;HDR=YES;Database=%s'', ''SELECT * FROM [State$]'')'
								, @DbVer, @FilePath);
	Exec(@sql)

	
	-- 02 - Track Change
	INSERT INTO [dbo].[_TrackModifications] ([ModificationType] ,[Version] ,[Descriptions])
			VALUES ('Data Load' , @DbVer,'HPCDS-62 - Registration: State and Country Data records and Editors')
	;

COMMIT TRAN;
SELECT TOP 1 * FROM [dbo].[_TrackModifications] ORDER BY ID desc;


-- Change back to original values
-- Grant/Enable for Microsoft.ACE.OLEDB.12.0 on SQL Server 2012
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 0   
-- skipped, due to invalid format specification '$1!.' no idea EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParam', 0
GO

-- Sysconfig
GO
sp_configure 'Ad Hoc Distributed Queries', 0; 
RECONFIGURE; 
GO
SP_CONFIGURE 'XP_CMDSHELL',0;
RECONFIGURE;
GO
sp_configure 'show advanced options', 0;
RECONFIGURE;
GO
