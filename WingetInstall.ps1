<#
.NOTES
	Version:        1.0
	Author:         George Slight
	Creation Date:  02/06/2023
#>

$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object { $_.EndsWith('.msixbundle') }
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split('/')[-1]
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 1 of 2'
Set-Variable ProgressPreference SilentlyContinue
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
Set-Variable ProgressPreference Continue
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 2 of 2'
Set-Variable ProgressPreference SilentlyContinue
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Try { Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx -ErrorAction Stop } Catch {}
Add-AppxPackage $latestWingetMsixBundle
Set-Variable ProgressPreference Continue