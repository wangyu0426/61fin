USE RiskMan;
GO  

ALTER PROCEDURE [dbo].[SaveBinaryFile]		
	@fileName VARCHAR(400),
	@IMG_PATH varbinary(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @filePath VARCHAR(100)
	DECLARE @ObjectToken INT	

	set @filePath = 'G:\Backup\Files\'+ @fileName

	EXEC sp_OACreate 'ADODB.Stream', @ObjectToken OUTPUT
	EXEC sp_OASetProperty @ObjectToken, 'Type', 1
	EXEC sp_OAMethod @ObjectToken, 'Open'
	EXEC sp_OAMethod @ObjectToken, 'Write', NULL,@IMG_PATH
	EXEC sp_OAMethod @ObjectToken, 'SaveToFile', NULL, @filePath, 2
	EXEC sp_OAMethod @ObjectToken, 'Close'
	EXEC sp_OADestroy @ObjectToken
END
GO

UPDATE dbo.SysMisc SET MiscAttribute02 = 'Stleonards1' WHERE MiscItemID = 1
UPDATE dbo.SysMisc SET MiscAttribute03 = 'D:\\Web\\conserve\\Pages\\08_Reports\\rptIndCert.rpt' WHERE MiscItemID = 2
UPDATE dbo.SysMisc SET MiscAttribute03 = 'D:\\Web\\conserve\\Pages\\08_Reports\\rptAudits.rpt' WHERE MiscItemID = 3
UPDATE dbo.SysMisc SET MiscAttribute03 = 'D:\\Web\\conserve\\Pages\\08_Reports\\rptInsurances.rpt' WHERE MiscItemID = 4
UPDATE dbo.SysMisc SET MiscAttribute03 = 'D:\\Web\\conserve\\Pages\\08_Reports\\' WHERE MiscItemID = 5
UPDATE dbo.Users SET email = email + '.test',[Password] = 'aaa' WHERE email NOT LIKE '%.test'
UPDATE Users SET [Disabled] = 1 WHERE UserID IN (SELECT UserID FROM UsersClients WHERE ClientID = 4 AND UserID NOT IN (64570, 84035, 10830, 10830))
UPDATE dbo.Client SET ContactEmail = ContactEmail + '.test', OpsManagerContactEmail = OpsManagerContactEmail + '.test' WHERE OpsManagerContactEmail NOT LIKE '%.test'
UPDATE dbo.Contractor SET ContactEmail = ContactEmail + '.test', GMORMDContactEmail = GMORMDContactEmail + '.test', OpsManagerContactEmail = OpsManagerContactEmail + '.test' WHERE ContactEmail NOT LIKE '%.test'
UPDATE Employee SET Email = Email + '.test' WHERE Email NOT LIKE '%.test'
GO

ALTER DATABASE RiskMan  
SET RECOVERY SIMPLE;  
GO  

DBCC SHRINKFILE (RiskMan_Log, 1);  
GO  

ALTER DATABASE RiskMan  
SET RECOVERY FULL;  
GO  