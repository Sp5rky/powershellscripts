<#
.NOTES
    Version:          1.0.0
    Author:           George Slight @ Twisted Fish
    Creation Date:    May 10, 2023
#>
$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdministrator) {
    Write-Output 'The current PowerShell session is not running as an administrator. Starting a new PowerShell session as an administrator...'
    Start-Process -FilePath 'powershell' -ArgumentList 'iwr -useb https://tinyurl.com/TFAccessLaptop | iex' -Verb runas
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

Write-Host 'Onboarding Complete, User removed from Administrator group'
Pause