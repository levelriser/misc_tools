#0. Variables
$MinecraftMainURL = "https://www.minecraft.net/en-us/download/server/bedrock/"
$DownloadLink = (Invoke-WebRequest -Uri $MinecraftMainURL).links.href | Select-String  -Pattern "/bin-win/bedrock-serve" | Out-String

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


Start-Process "C:\minecraft_active_server\bedrock_server.exe"

