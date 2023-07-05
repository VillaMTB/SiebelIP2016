/*
	grantusr_MSSQL.sql

	PURPOSE:		To create Siebel logins and database users for Siebel IP2016 on a SQL Server instance
	USAGE:			Has to be run from a command line using sqlcmd
	PARAMETERS:		db_name = name of the Siebel database (e.g. siebeldb)
					guestcst_pwd = password for GUESTCST
					guesterm_pwd = password for GUESTERM
					ldapuser_pwd = passwrod for LDAPUSER
					sadmin_pwd = password for SADMIN
					tblo_pwd = password for Siebel table owner

	EXAMPLE:		sqlcmd -S devmssqldb.villamtb.com -U sa -P sapwd123 -v db_name="siebeldb" guestcst_pwd="123456" guesterm_pwd="1234567" ... other parameters -i path_to_sql_file\grantusr_MSSQL.sql -o path_to_log\grantusr_MSSQL.log

*/
USE [master]
GO

--Add logins if they do not exists in the database.
IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE UPPER(name) = N'SADMIN')
	CREATE LOGIN SADMIN WITH PASSWORD='$(sadmin_pwd)', DEFAULT_DATABASE=$(db_name)

IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE UPPER(name) =  N'SIEBEL' )
	CREATE LOGIN SIEBEL WITH PASSWORD='$(tblo_pwd)', DEFAULT_DATABASE=$(db_name)

IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE UPPER(name) =  N'LDAPUSER')
	CREATE LOGIN LDAPUSER WITH PASSWORD='$(ldapuser_pwd)', DEFAULT_DATABASE=$(db_name)

IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE UPPER(name) =  N'GUESTCST')
	CREATE LOGIN GUESTCST WITH PASSWORD='$(guestcst_pwd)', DEFAULT_DATABASE=$(db_name)

IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE UPPER(name) =  N'GUESTERM')
	CREATE LOGIN GUESTERM WITH PASSWORD='$(guesterm_pwd)', DEFAULT_DATABASE=$(db_name)

--	Create the database users
USE [$(db_name)]
GO
IF  EXISTS (SELECT * FROM sys.database_principals WHERE upper(name) = N'SADMIN')
	DROP USER SADMIN

IF  EXISTS (SELECT * FROM sys.database_principals WHERE upper(name) =  N'LDAPUSER')
	DROP USER LDAPUSER

IF  EXISTS (SELECT * FROM sys.database_principals WHERE upper(name) = N'GUESTCST')
	DROP USER GUESTCST

IF  EXISTS (SELECT * FROM sys.database_principals WHERE upper(name) = N'GUESTERM')
	DROP USER GUESTERM

IF  EXISTS (SELECT * FROM sys.database_principals WHERE upper(name) = N'SSE_ROLE' AND type = 'R')
	DROP ROLE SSE_ROLE

CREATE ROLE SSE_ROLE

CREATE USER SADMIN FOR LOGIN SADMIN
EXEC sp_addrolemember 'SSE_ROLE', SADMIN

CREATE USER LDAPUSER FOR LOGIN LDAPUSER
EXEC sp_addrolemember 'SSE_ROLE', LDAPUSER

CREATE USER GUESTCST FOR LOGIN GUESTCST
EXEC sp_addrolemember 'SSE_ROLE', GUESTCST

CREATE USER GUESTERM FOR LOGIN GUESTERM
EXEC sp_addrolemember 'SSE_ROLE', GUESTERM

ALTER AUTHORIZATION ON DATABASE::$(db_name) TO SIEBEL
