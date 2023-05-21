<#
.NOTES
    Version:          1.0.0
    Author:           George Slight
    Creation Date:    May 10, 2022
#>

Set-ExecutionPolicy Unrestricted -Force

Clear-Host
Write-Host ''
Write-Host '                   .-+++++++++++++++=.    '
Write-Host '                  -##=-------------*##    '
Write-Host '      ............--..............:##+    '
Write-Host ' .+###############################*=:     '
Write-Host '.##.             ==                       '
Write-Host '.##=============+##=========-:            '
Write-Host ' .=++++++++++++*##*++++++++*##:           '
Write-Host '               :==         =##.           '
Write-Host '          .+################+.            '
Write-Host '         -#*::=+=:::::::::.               '
Write-Host '         ##.  ##-                         '
Write-Host '        +#*  :#*                          '
Write-Host '       :##:  +#-                          '
Write-Host '       +##  :##                           '
Write-Host '       ##=  ##=                           '
Write-Host '      :##=:+#*                            '
Write-Host ''    
Write-Host 'Twisted Fish - Cartestian New Laptop Setup'
Write-Host 'Device will automatically restart for Updates'
Write-Host ''
Write-Host 'Which laptop type are you installing?'
Write-Host '1 for Developer'
Write-Host '2 for Analytics'
Write-Host '3 for Standard'
$laptoptype = Read-Host 'Please enter your choice'

Write-Host 'Starting Application Download/Install' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/New%20Device/Cartestian/applications.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $laptoptype | Out-Null

Write-Host 'Starting Mcafee Cleanup Tool' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/McAfeeCleanup.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Bloatware Removal' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/bloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/WindowsUpdates.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null