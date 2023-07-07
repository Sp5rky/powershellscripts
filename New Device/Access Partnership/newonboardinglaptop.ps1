<#
.NOTES
    Version:          1.0.0
    Author:           George Slight @ Twisted Fish
    Creation Date:    May 10, 2023
#>
# Check if the current PowerShell session is running as an administrator and save the current user to a variable for later
$currentuser = whoami
$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Check if the current user is a member of the Administrators group
$isInAdministratorsGroup = ((net localgroup Administrators) -like "*$currentuser*")
if (-not $isInAdministratorsGroup) {
    Write-Host 'The current user is not a member of the Administrators group. Adding now and will logout run powershell again as Administrator once logged back in' -ForegroundColor Red
    Start-Process -FilePath 'powershell' -ArgumentList "Add-LocalGroupMember -Group 'Administrators' -Member '$currentuser'" -Verb runas
    $seconds = 15
    for ($i = 1; $i -le $seconds; $i++) {
        Write-Progress -Activity 'Logout' -Status "Logging out in $((15 - $i)) seconds" -PercentComplete (($i / $seconds) * 100)
        Start-Sleep -Seconds 1
    }
    Shutdown.exe /l
    exit
}
if (-not $isAdministrator) {
    Write-Output 'The current PowerShell session is not running as an administrator. Starting a new PowerShell session as an administrator...'
    Start-Process -FilePath 'powershell' -ArgumentList 'iwr -useb https://tinyurl.com/TFAccessLaptop | iex' -Verb runas
    exit
}

Clear-Host
Write-Host ''
Write-Host '                   .-+++++++++++++++=.' -ForegroundColor Red
Write-Host '                  -##=-------------*##' -ForegroundColor Red
Write-Host '      ............--..............:##+' -ForegroundColor Red
Write-Host ' .+###############################*=: ' -ForegroundColor Red
Write-Host '.##.             ==                   ' -ForegroundColor Red
Write-Host '.##=============+##=========-:        ' -ForegroundColor Red
Write-Host ' .=++++++++++++*##*++++++++*##:       ' -ForegroundColor Red
Write-Host '               :==         =##.       ' -ForegroundColor Red
Write-Host '          .+################+.        ' -ForegroundColor Red
Write-Host '         -#*::=+=:::::::::.           ' -ForegroundColor Red
Write-Host '         ##.  ##-                     ' -ForegroundColor Red
Write-Host '        +#*  :#*                      ' -ForegroundColor Red
Write-Host '       :##:  +#-                      ' -ForegroundColor Red
Write-Host '       +##  :##                       ' -ForegroundColor Red
Write-Host '       ##=  ##=                       ' -ForegroundColor Red
Write-Host '      :##=:+#*                        ' -ForegroundColor Red
Write-Host ''    
Write-Host 'Twisted Fish - AP New Laptop Setup'
Write-Host ''

$manufacturer = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer
if ($manufacturer -eq 'Hewlett-Packard' -or $manufacturer -eq 'HP') {
    Write-Host 'Starting Bloatware Removal' -ForegroundColor Green

    $url = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661653&authkey=AEEmWpFLFnhjboA'
    $output = './uninstallHPCO.iss'
    Invoke-WebRequest -Uri $url -OutFile $output

    $remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/HPbloatware.ps1'
    $scriptBlock = [Scriptblock]::Create($remoteScript)
    Invoke-Command -ScriptBlock $scriptBlock | Out-Null
}

Write-Host 'Starting Bloatware Removal' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/bloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/WindowsUpdates.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

# Once the script finishes run it again removing the current user as administrator (very dirty method for winget workaround)
$currentuser = whoami
if (-not $isInAdministratorsGroup) {
    Start-Process -FilePath 'powershell' -ArgumentList "Add-LocalGroupMember -Group 'Administrators' -Member '$currentuser' /delete" -Verb runas
    $seconds = 15
    for ($i = 1; $i -le $seconds; $i++) {
        Write-Progress -Activity 'Logout' -Status "Logging out in $((15 - $i)) seconds" -PercentComplete (($i / $seconds) * 100)
        Start-Sleep -Seconds 1
    }
    Shutdown.exe /l
    exit
}