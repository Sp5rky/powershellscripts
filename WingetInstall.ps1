<#
.NOTES
	Version:        1.0
	Author:         George Slight
	Creation Date:  02/06/2023
#>

# Fetch the URI of the latest version of the winget-cli from GitHub releases
$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object { $_.EndsWith('.msixbundle') }

# Extract the name of the .msixbundle file from the URI
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split('/')[-1]

# Show a progress message for the first download step
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 1 of 2'

# Temporarily set the ProgressPreference variable to SilentlyContinue to suppress progress bars
Set-Variable ProgressPreference SilentlyContinue

# Download the latest .msixbundle file of winget-cli from GitHub releases
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"

# Reset the ProgressPreference variable to Continue to allow progress bars
Set-Variable ProgressPreference Continue

# Show a progress message for the second download step
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 2 of 2'

Set-Variable ProgressPreference SilentlyContinue

# Download the VCLibs .appx package from Microsoft
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx

# Try to install the VCLibs .appx package, suppressing any error messages
Try { Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx -ErrorAction Stop } Catch {}

# Install the latest .msixbundle file of winget-cli
Add-AppxPackage $latestWingetMsixBundle
Set-Variable ProgressPreference Continue