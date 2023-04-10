#1. Test if the maintenance folder exist. If it does not, create this folder. 
$activepath = "C:\minecraft_active_server\"
$backuppath = "C:\minecraft_daily_backups\"
$datevar = get-date -Format yyyy-MM-dd
$filename = "minecraft-$datevar"
$fullPath = "$path\$filename"
$zipfilename = "$filename.zip"
$bucketname = "name"


If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

#2. Create a folder for todays backup to live in. 
New-Item -ItemType Directory -Path "C:\minecraft_daily_backups\$filename"

#3. Copy the files from the active directory to the backup directory
Copy-Item $activepath\server.properties -Destination $backuppath\$filename\ -Recurse -force
Copy-Item $activepath\whitelist.json -Destination $backuppath\$filename\ -Recurse -force
Copy-Item $activepath\worlds -Destination $backuppath\$filename\ -Recurse -force

#4. Clean up the directory with the proper retention policy. By default, we will enable 7 days. You can change this by commenting out the 7 day string and using the 30 for 30 days. 
#7 days
Get-ChildItem $backuppath | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-7)} | Remove-Item -Recurse 
#30 days
#Get-ChildItem C:\minecraft_daily_backups\ | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-30)} | Remove-Item -Recurse 

#5 Compress the new backup 
Compress-Archive -Path $backuppath\$filename -DestinationPath $backuppath\$filename
Remove-Item $backuppath\$filename -force -Recurse



Write-S3Object -Region us-east-1 -BucketName $bucketname -Key "\minecraft\$filename.zip" -File "$backuppath\$filename.zip"