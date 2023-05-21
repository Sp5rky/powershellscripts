<#
.NOTES
    Version:          1.0.0
    Author:           George Slight
    Creation Date:    May 10, 2022
#>

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
Write-Host 'Twisted Fish - AP New Laptop Setup'
Write-Host ''

$manufacturer = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer
if ($manufacturer -eq "Hewlett-Packard" -or $manufacturer -eq "HP") {
    Write-Host 'Starting Bloatware Removal' -ForegroundColor Green

    # Download the file
    $url = 'https://public.am.files.1drv.com/y4mKro73NXOG436QLclr-5qJ1-HiRDVVsdmymT_9HWMlDgIVtI6SDratWvzqSbQPzKYvJdG4NwjUM_U9xCbH9T4wfU9WmnsJILPSzbJljr-IpqVTOOubH8E8gwrS2ceH-6tl2u9_icYJ4SEe5h4IuyjZeZDIl24VA4HvKzTPzdqomriXIizkJqgYJ48e0HRm094CiyfzsrBLuFrbzz_hdrVzHEPHWWQieMVIryXwJnfhqI?AVOverride=1'
    $output = './uninstallHPCO.iss'
    Invoke-WebRequest -Uri $url -OutFile $output

    # Run the bloatware removal script
    $remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/cea92e83459b604916a781a380dc6dd3/raw/ff503098a678ad111bacd68ee344171bf4cc668f/HPBloatware.ps1'
    $scriptBlock = [Scriptblock]::Create($remoteScript)
    Invoke-Command -ScriptBlock $scriptBlock | Out-Null
}

Write-Host 'Starting Bloatware Removal' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/fb1fc2c46c598285d23a5272d017ac6a/raw/46e44762d9d500a5ef1b4f4b55ebaf32651174a6/bloatware.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://gist.githubusercontent.com/Sp5rky/a1bdc2e90e79bf085b0d230436f8dddf/raw/5b27ae491411ce01794d0bd7c6d4250d4c174a2e/WindowsUpdate.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null