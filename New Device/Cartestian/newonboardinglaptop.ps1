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
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/bd540821a99e364e5b4d45c7e23e475e/raw/b93f97a211911da0716854e643f3cd0ce4788ce1/cartesianapplications.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $laptoptype | Out-Null

Write-Host 'Starting Mcafee Cleanup Tool' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/cb47b0b3ebde63d0b3cd55f8ea97704c/raw/95182b917b7176592c79722223189e4557ab0efa/mccafeecleanup.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Bloatware Removal' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/fb1fc2c46c598285d23a5272d017ac6a/raw/46e44762d9d500a5ef1b4f4b55ebaf32651174a6/bloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/a1bdc2e90e79bf085b0d230436f8dddf/raw/5b27ae491411ce01794d0bd7c6d4250d4c174a2e/WindowsUpdate.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null