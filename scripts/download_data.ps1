#============================================================
# Download Database Backup File with AWS S3 Objects
#============================================================

Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"

$accessKey = "AKIAIGXATIXFSPCAV7OQ"                                  # Amazon access key.   
$secretKey = "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"              # Amazon secret key.

Set-AWSCredentials -AccessKey $accessKey -SecretKey $secretKey

$bucketName = "bngconserve"
$localFile = "e:\Backup\RiskMan.bak"

#SMTP server name
$smtpServer = "email-smtp.us-east-1.amazonaws.com"

#Creating a Mail object
$msg = new-object Net.Mail.MailMessage

#Creating SMTP server object
$smtp = new-object Net.Mail.SmtpClient($smtpServer, 25)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential("AKIAJG6FJUHANBMMPDQQ", "Ao7FcO3S8wiJWLkdyZwuidzknaCzyYIj1uhrVexovJA+");

#Email structure 
$msg.From = "chinsu.park@picnet.com.au"
$msg.To.Add("chinsu.park@picnet.com.au")
$msg.subject = "BNG Production to Demo Database (BNG Office)"
$msg.body = ""


try {
    $results = Get-S3Object -BucketName bngconserve -KeyPrefix database/
    $results = $results | Sort-Object -Property LastModified –Descending
    $msg.body += "<p>downloading... " + $results[0].Key + "</p>"
    Read-S3Object -BucketName $bucketName -Key $results[0].Key -File $localFile
    $msg.body += "<p>Download Completed</p>"
}
catch {
    $msg.body += "<p>File Download Failed!!!: " + $_.Exception.Message + "</p>"
    $smtp.Send($msg)
    exit
}

#============================================================
# Verify the backup file
#============================================================

#$sql = "Use master 
#RESTORE VERIFYONLY FROM DISK = '$localFile'
#"

#try {
    #$msg.body += "<p>Verifying... " + $backupFile + "</p>"
    #$result = sqlcmd -Q $sql -S "." -U sa -P Stleonards1
    #$msg.body += "<p>" + $result + "</p>"
    #if(-not $msg.body.Contains("The backup set on file 1 is valid")) {
        #throw "Failed to verify the database backup"
    #}
#}
#catch [exception] {
#
    #$msg.body += "<p>Verifying Database Failed!!!: " + $_.Exception.Message + "</p>"
#    $smtp.Send($msg)
#    exit
#}


#============================================================
# Restore a Database using PowerShell and sqlcmd
# to the same database, with different location
#============================================================

$backupFile = $localFile
$dbName = "RiskMan"
$dblogicName = "RiskMan"
$dbPath = "E:\Data\RiskMan_1.mdb"
$logLogicName = "RiskMan_Log"
$logPath = "E:\Data\RiskMan_2.ldf"


#drop & restore the database

$sql = "Use master 
IF EXISTS(select * from sys.databases where name='" + $dbName + "') 
BEGIN
    ALTER DATABASE " + $dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE " + $dbName + ";
END
    RESTORE DATABASE " + $dbName + "
    FROM DISK = '" + $backupFile + "'
    WITH MOVE '" + $dblogicName + "' TO '" + $dbPath + "',
         MOVE '" + $logLogicName + "' TO '" + $logPath + "',
         REPLACE,RECOVERY;"

$sql

try {    
    $result = sqlcmd -Q $sql -S "." -U sa -P Stleonards1
    $msg.body += "<p>Restoring... " + $dbName + "</p>"
    $msg.body += "<p>" + $result + "</p>"
    if($msg.body.Contains("terminating abnormally")) {
        throw "$results"
    }
    $msg.body += "<p>Restore Completed</p>"
}
catch [exception] {

    $msg.body += "<p>Restore Database Failed!!!: " + $_.Exception.Message + "</p>"
    $smtp.Send($msg)
    exit
}


#============================================================
# Senitise database
#============================================================

$script = "C:\Scripts\sanitise_bng.sql";

try {
    $msg.body += "<p>Senatise database..." + $dbName + "</p>"
    $result = sqlcmd -S "." -U sa -P Stleonards1 -i $script
    $msg.body += "<p>" + $result + "</p>"
    $msg.body += "<p>Senatise Completed</p>"
    $msg.body += "<p>Done</p>"
}
catch [exception] {

    $msg.body += "<p>Senatise Database Failed!!!: " + $_.Exception.Message + "</p>"
    $smtp.Send($msg)
    exit
}

$smtp.Send($msg)
"Done"