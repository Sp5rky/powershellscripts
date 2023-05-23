#Run Microsoft Store Updates in background while doing Windows Updates
Start-Job -ScriptBlock {
    Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
} | Out-Null

#Start Windows Updates Process
Write-Progress -Activity "Twisted Fish Automation - Installing NuGet Package Provider" -Status "Step 1 of 6"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force > $null

Write-Progress -Activity "Twisted Fish Automation - Setting PSRepository" -Status "Step 2 of 6"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted > $null

Write-Progress -Activity "Twisted Fish Automation - Installing PSWindowsUpdate Module" -Status "Step 3 of 6"
Install-Module PSWindowsUpdate -Confirm:$False > $null

Write-Progress -Activity "Twisted Fish Automation - Setting Execution Policy" -Status "Step 4 of 6"
Set-ExecutionPolicy RemoteSigned -Force > $null

Write-Progress -Activity "Twisted Fish Automation - Importing PSWindowsUpdate Module" -Status "Step 5 of 6"
Import-Module PSWindowsUpdate > $null

Write-Progress -Activity "Twisted Fish Automation - Running Windows Update" -Status "Step 6 of 6"
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

#Run Microsoft Store Updates again as the first time it will normally update MS Store App first this just finishes whatever is left to install.
Start-Job -ScriptBlock {
    Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
} | Out-Null

Write-Host 'Finished Running Windows Update' -ForegroundColor Green