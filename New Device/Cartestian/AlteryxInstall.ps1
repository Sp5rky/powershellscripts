<#
.NOTES
    Version:          1.0
    Author:           George Slight
    Creation Date:    June 30, 2023
#>

$downloadPath = 'C:\Temp'
$anal1 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703298&authkey=!AFjQIx-HG9Km368'
$anal2 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703297&authkey=!ADR8_wTpmstBwaI'
$anal3 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703296&authkey=!AJL1-aoiGE6VfBA'

$files = @{
    'AlteryxInstall.zip'      = $anal1
    'RInstaller.zip'          = $anal2
    'AlteryxPatchInstall.zip' = $anal3
}

# Check if the directory exists and create it if it does not
if (-not (Test-Path $downloadPath)) {
    New-Item -ItemType Directory -Force -Path $downloadPath
}
    
$retryLimit = 3

foreach ($filename in $files.Keys) {
    $source = $files[$filename]
    if (-not [string]::IsNullOrEmpty($source)) {
        $destination = Join-Path -Path $downloadPath -ChildPath $filename
        $retryCount = 0

        while ($retryCount -lt $retryLimit) {
            try {
                Write-Progress -Activity "Downloading $filename" -Status 'Starting Download...'
                Set-Variable ProgressPreference SilentlyContinue
                Invoke-WebRequest -Uri $source -OutFile $destination
                Set-Variable ProgressPreference Continue
                Write-Progress -Activity "Downloading $filename" -Status 'Download Complete' -Completed
                break
            }
            catch {
                $retryCount++
                if ($retryCount -ge $retryLimit) {
                    Write-Warning "There was an error downloading the $filename after $retryLimit attempts: $_"
                    break
                }
                else {
                    Write-Warning "Error downloading the $filename, attempt $retryCount of $retryLimit : $_"
                    Start-Sleep -Seconds 5  # Wait for 5 seconds before retrying
                }
            }
        }
    }
    else {
        Write-Warning "Source not specified for '$filename'. Skipping download."
    }
}
    
$zipFiles = Get-ChildItem -Path $downloadPath -Filter '*.zip'
    
foreach ($zipFile in $zipFiles) {
    # If the basename of the zip file is in the list, extract it to the Alteryx directory
    if ($zipFile.BaseName -in @('AlteryxInstall', 'RInstaller', 'AlteryxPatchInstall')) {
        $destinationPath = 'C:\Program Files\Alteryx'
    }
    else {
        $destinationPath = Join-Path -Path 'C:\Program Files' -ChildPath ($zipFile.BaseName)
    }
    
    try {
        Expand-Archive -Path $zipFile.FullName -DestinationPath $destinationPath -Force
    
        # Delete the original zip file
        Remove-Item -Path $zipFile.FullName -Force
    }
    catch {
        Write-Warning "Failed to extract '$($zipFile.Name)': $_"
    }
}

# Install Alteryx
$installerPath = 'C:\Program Files\Alteryx\AlteryxInstallx64_2023.1.1.200.exe'
$arguments = '/s'
Write-Progress -Activity 'Installing Alteryx' -Status 'Starting Install...'
Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

# Delete the installer file
Remove-Item -Path $installerPath -Force
Write-Progress -Activity 'Installing Alteryx' -Status 'Install Complete' -Completed

# Install Alteryx Patch
$installerPath = 'C:\Program Files\Alteryx\AlteryxPatchInstall_2023.1.1.1.200.exe'
$arguments = '/s'
Write-Progress -Activity 'Installing Alteryx Patch' -Status 'Starting Install...'
Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

# Delete the installer file
Remove-Item -Path $installerPath -Force
Write-Progress -Activity 'Installing Alteryx Patch' -Status 'Install Complete' -Completed

# Install Alteryx R Tools
$installerPath = 'C:\Program Files\Alteryx\RInstaller_2023.1.1.200.exe'
$arguments = '/s'
Write-Progress -Activity 'Installing Alteryx R Tools' -Status 'Starting Install...'
Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

# Delete the installer file
Remove-Item -Path $installerPath -Force
Write-Progress -Activity 'Installing Alteryx R Tools' -Status 'Install Complete' -Completed