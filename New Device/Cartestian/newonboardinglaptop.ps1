<#
.NOTES
    Version:          1.0.0
    Author:           George Slight
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

Write-Host 'Starting Winget Install' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/WingetInstall.ps1'
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
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/New%20Device/Cartestian/applications.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $laptoptype | Out-Null

Write-Host 'Starting Windows Update' -ForegroundColor Green
$remoteScript = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/Sp5rky/powershellscripts/main/WindowsUpdates.ps1'
$scriptBlock = [Scriptblock]::Create($remoteScript)
Invoke-Command -ScriptBlock $scriptBlock | Out-Null

# Get the PCs serial number and rename the PC to cart-<serial number>
$Serial = (Get-WmiObject Win32_BIOS).SerialNumber
Rename-Computer -NewName cart-$Serial -Force

# Once the script finishes run it again removing the current user as administrator (very dirty method for winget workaround)
$currentuser = whoami
$isInAdministratorsGroup = ((net localgroup Administrators) | ForEach-Object { $_.ToLower() } | Select-String -Pattern $currentuser.ToLower() -SimpleMatch)

if ($isInAdministratorsGroup) {
    Remove-LocalGroupMember -Group 'Administrators' -Member $currentuser
    $seconds = 15
    for ($i = 1; $i -le $seconds; $i++) {
        Write-Progress -Activity 'Logout' -Status "Logging out in $((15 - $i)) seconds" -PercentComplete (($i / $seconds) * 100)
        Start-Sleep -Seconds 1
    }
    Write-Host 'Onboarding Complete, User removed from Administrator group'
}