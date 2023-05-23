<#
.NOTES
    Version:          1.0.0
    Author:           George Slight
    Creation Date:    May 10, 2022
#>

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