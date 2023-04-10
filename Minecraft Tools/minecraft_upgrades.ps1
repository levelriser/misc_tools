#0. Variables
$DownloadLink="https://minecraft.azureedge.net/bin-win/bedrock-server-1.16.201.02.zip"


#New-Item -Path "c:\" -Name "minecraft_active_server" -ItemType "directory"
#New-Item -Path "c:\" -Name "minecraft_maintenance_backup" -ItemType "directory"

#1. Create work directories
#Create some temp directories. We will delete these after the update. 

New-Item -Path "c:\" -Name "minecraftdownloads" -ItemType "directory"
New-Item -Path "c:\" -Name "minecraftworkingdirectory" -ItemType "directory"
New-Item -Path "c:\" -Name "minecraft_tmp" -ItemType "directory"

#2. Make full backup of active directory
#Make a backup of the initial system. 

New-Item -ItemType Directory -Path "c:\minecraft_maintenance_backup\$((Get-Date).ToString('yyyy-MM-dd'))"

Copy-Item -Path c:\minecraft_active_server\* -Recurse -Destination c:\minecraft_maintenance_backup\$((Get-Date).ToString('yyyy-MM-dd')) -Container

#3. Delete all the files out of the current active directory 
Remove-Item C:\minecraft_active_server\* -force -Recurse

#4. Download zip file from web server. 
#download the update
invoke-webrequest -Uri $DownloadLink -Outfile c:\minecraftdownloads\minecraftfiles.zip

#5. Extract the files to the active directory
#extract the update to a temp directory. 
Expand-Archive c:\minecraftdownloads\minecraftfiles.zip -DestinationPath c:\minecraft_active_server\

#6. Copy the core files needed for the world to work

Copy-Item c:\minecraft_maintenance_backup\$((Get-Date).ToString('yyyy-MM-dd'))\server.properties -Destination c:\minecraft_active_server\ -Recurse -force
Copy-Item c:\minecraft_maintenance_backup\$((Get-Date).ToString('yyyy-MM-dd'))\whitelist.json -Destination c:\minecraft_active_server\ -Recurse -force
Copy-Item c:\minecraft_maintenance_backup\$((Get-Date).ToString('yyyy-MM-dd'))\worlds -Destination c:\minecraft_active_server\ -Recurse -force


#7. Clean up the extra folders
Remove-Item C:\minecraftdownloads -force -Recurse
Remove-Item C:\minecraftworkingdirectory -force -Recurse
Remove-Item C:\minecraft_tmp -force -Recurse




