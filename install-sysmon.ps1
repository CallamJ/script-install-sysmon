#####################################################
# 
# Description: Downloads and installs the latest 
# Sysmon version with a sysmon-modular config file.
# 
# Note: 
# 
# Produced for: managed clients.
# 
# (c) Comprehensive Computing LLC
# 
# Author: Byrom Jomaa
# 
#####################################################

# URLs and file paths:
$WorkingDirectory="C:\Sysmon"
$SysmonURL="https://download.sysinternals.com/files/Sysmon.zip"
$SysmonConfigFileURL="https://raw.githubusercontent.com/ByromJomaa/sysmon-modular/master/sysmonconfig.xml"
$SysmonArchivePath="$WorkingDirectory\Sysmon.zip"
$SysmonConfigFilePath="C:\ProgramData\config.xml"
$SysmonCanaryConfigFilePath="C:\Windows\sysmonconfig.xml"

# Create a new working directory if DNE:
New-Item -Path "C:\" -Name "Sysmon" -ItemType "directory" -Force | Out-Null
if(-not $?)
{
    $msg = $Error[0].Exception.Message
    "$WorkingDirectory directory failed to be created with the error: $msg."
    Exit 1
}
Write-Host "$WorkingDirectory directory created"

# Download Sysmon and config file:
Invoke-Webrequest -URI $SysmonURL -OutFile $SysmonArchivePath
if(-not $?)
{
    $msg = $Error[0].Exception.Message
    "Sysmon failed to download with the error: $msg."
    Exit 1
}
Invoke-Webrequest -URI $SysmonConfigFileURL -OutFile $SysmonConfigFilePath
if(-not $?)
{
    $msg = $Error[0].Exception.Message
    "Config file failed to download with the error: $msg."
    Exit 1
}
Copy-Item $SysmonConfigFilePath -Destination $SysmonCanaryConfigFilePath
Write-Host "Sysmon and config downloaded"

# Extract Sysmon installer:
Expand-Archive -LiteralPath $SysmonArchivePath -DestinationPath $WorkingDirectory
if(-not $?)
{
    $msg = $Error[0].Exception.Message
    "Sysmon installer archive failed to unzip with the error: $msg."
    Exit 1
}
Write-Host "Sysmon installer archive unzipped"

# Run installer:
C:\Sysmon\Sysmon64.exe -accepteula -i $SysmonConfigFilePath

# Delete unnecessary contents of working directory:
del "$WorkingDirectory\Sysmon64a.exe"
del "$WorkingDirectory\Sysmon.exe"
del "$WorkingDirectory\Sysmon.zip"
