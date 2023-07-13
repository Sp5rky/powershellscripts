<#
.NOTES
    Version:          1.0.0
    Author:           George Slight @ Twisted Fish
    Creation Date:    July 13, 2023
#>
$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdministrator) {
    Write-Output 'The current PowerShell session is not running as an administrator. Starting a new PowerShell session as an administrator...'
    Start-Process -FilePath 'powershell' -ArgumentList 'iwr -useb https://bit.ly/TFCartestianLaptop | iex' -Verb runas
    exit
}

Set-ExecutionPolicy Unrestricted -Force

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
Write-Host 'Twisted Fish - Cartestian New Laptop Setup'
Write-Host 'Device will automatically restart for Updates'
Write-Host ''
Write-Host 'Which laptop type are you installing?'
Write-Host '1 for Developer'
Write-Host '2 for Analytics'
Write-Host '3 for Standard'
$laptoptype = Read-Host 'Please enter your choice'

Write-Host 'Starting Chocolatey Install' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://community.chocolatey.org/install.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Mcafee Cleanup Tool' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/McAfeeCleanup.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Bloatware Removal Step 1 of 2' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/bloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Bloatware Removal Step 2 of 2' -ForegroundColor Green
$url = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661653&authkey=AEEmWpFLFnhjboA'
$output = './uninstallHPCO.iss'
Invoke-WebRequest -Uri $url -OutFile $output
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/HPbloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Application Download/Install' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/New%20Device/Cartestian/applicationschocolatey.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $laptoptype | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/WindowsUpdates.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

# Get the PCs serial number and rename the PC to cart-<serial number>
$Serial = (Get-WmiObject Win32_BIOS).SerialNumber
Rename-Computer -NewName cart-$Serial -Force

Write-Host 'Onboarding Complete, User removed from Administrator group'
Pause