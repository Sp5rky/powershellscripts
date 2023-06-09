<#
.NOTES
    Version:          1.5
    Author:           George Slight @ Twisted Fish
    Creation Date:    May 16, 2023
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$laptoptype
)

function Standard {
    Write-Host 'Installing Standard laptop...' -ForegroundColor Green
    $apps = @(
        'Google.Chrome'
        'Mozilla.Firefox'
        'OpenVPNTechnologies.OpenVPN'
        'PuTTY.PuTTY'
        'Notepad++.Notepad++'
        'WinMerge.WinMerge'
        'WinSCP.WinSCP'
        'DominikReichl.KeePass'
        '7zip.7zip'
    )
    $total = $apps.Count
    $current = 0
    foreach ($app in $apps) {
        $current++
        $percentComplete = ($current / $total) * 100
        Write-Progress -Activity 'Installing Standard laptop' -Status "Installing $app" -PercentComplete $percentComplete
        winget install -e --accept-source-agreements --accept-package-agreements --silent --id $app
    }
    Write-Progress -Activity 'Installing Standard laptop' -Completed
}

function Developer {
    Write-Host 'Installing Developer laptop...' -ForegroundColor Green
    $devapps = @(
        'PostgreSQL.pgAdmin'
        'Postman.Postman'
        'Amazon.AWSCLI'
        'OpenJS.NodeJS'
        'Oracle.JDK.19'
        'Oracle.JavaRuntimeEnvironment'
        'Python.Python.3.10'
        'Microsoft.VisualStudioCode'
        'Git.Git'
        'Canonical.Ubuntu.2204'
        'Oracle.VirtualBox'
        'Docker.DockerDesktop'
    )

    $total = $devapps.Count
    $current = 0
    foreach ($devapp in $devapps) {
        $current++
        $percentComplete = ($current / $total) * 100
        Write-Progress -Activity 'Installing Developer laptop' -Status "Installing $devapp" -PercentComplete $percentComplete
        winget install -e --accept-source-agreements --accept-package-agreements --silent --id $devapp
    }
    Write-Progress -Activity 'Installing Developer laptop' -Completed

    $downloadPath = 'C:\Temp'
    $dev1 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661029&authkey=AMQ1Qy_Zjwj08Bg'
    $dev2 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661032&authkey=ALGQkehLxiKxuJc'
    $dev3 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661040&authkey=AB9JCdrs3cs8sDc'

    $files = @{
        'Workbench.zip'    = $dev1
        'SqlDeveloper.zip' = $dev2
        'Eclipse.zip'      = $dev3
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
        $destinationPath = Join-Path -Path 'C:\Program Files' -ChildPath ($zipFile.BaseName)

        if ($zipFile.BaseName -eq 'SqlDeveloper' -or $zipFile.BaseName -eq 'Eclipse') {
            $destinationPath = 'C:\Program Files'
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
    
    # Create shortcuts on Public Desktop for the Applications.
    $desktopPath = [Environment]::GetFolderPath('CommonDesktopDirectory')

    $applications = @(
        'C:\Program Files\sqldeveloper\sqldeveloper.exe',
        'C:\Program Files\Workbench\SQLWorkbench64.exe',
        'C:\Program Files\eclipse.exe'
    )

    foreach ($appPath in $applications) {
        if (Test-Path $appPath) {
            $appFile = Split-Path -Path $appPath -Leaf
            $shortcutPath = Join-Path -Path $desktopPath -ChildPath "$appFile.lnk"

            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $appPath
            $shortcut.Save()

            Write-Host "Shortcut created for $appPath"
        }
        else {
            Write-Warning "Application not found at path: $appPath"
        }
    }
}

function Analytics {
    Write-Host 'Installing Analytics laptop...' -ForegroundColor Green
    $analapps = @(
        'RProject.Rtools'
        'OSGeo.QGIS'
    )

    $total = $analapps.Count
    $current = 0
    foreach ($analapp in $analapps) {
        $current++
        $percentComplete = ($current / $total) * 100
        Write-Progress -Activity 'Installing Analytics laptop' -Status "Installing $analapp" -PercentComplete $percentComplete
        winget install -e --accept-source-agreements --accept-package-agreements --silent --id $analapp
    }
    Write-Progress -Activity 'Installing Analytics laptop' -Completed

    $downloadPath = 'C:\Temp'
    $anal1 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21661041&authkey=ANTSHPqYbhEa4mk'
    $anal2 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703298&authkey=!AFjQIx-HG9Km368'
    $anal3 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703297&authkey=!ADR8_wTpmstBwaI'
    $anal4 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9cab1ecfc3dc039e%21703296&authkey=!AJL1-aoiGE6VfBA'

    $files = @{
        'RStudio.zip' = $anal1
        'AlteryxInstall.zip' = $anal2
        'RInstaller.zip' = $anal3
        'AlteryxPatchInstall.zip' = $anal4
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
        } else {
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

    #Install RStudio
    $installerPath = 'C:\Program Files\RStudio\RStudio-2023.03.1-446.exe'
    $arguments = '/S /v /qn'
    $applicationPath = 'C:\Program Files\RStudio\rstudio.exe'
    $shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('CommonDesktopDirectory'), 'RStudio.lnk')
    Write-Progress -Activity "Installing RStudio" -Status 'Starting Install...'
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait
    
    # Delete the installer file
    Remove-Item -Path $installerPath -Force
    Write-Progress -Activity "Installing RStudio" -Status 'Install Complete' -Completed
    
    # Create a shortcut on the public desktop
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $applicationPath
    $shortcut.Save()

    # Install Alteryx
    $installerPath = 'C:\Program Files\Alteryx\AlteryxInstallx64_2023.1.1.200.exe'
    $arguments = '/s'
    Write-Progress -Activity "Installing Alteryx" -Status 'Starting Install...'
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

    # Delete the installer file
    Remove-Item -Path $installerPath -Force
    Write-Progress -Activity "Installing Alteryx" -Status 'Install Complete' -Completed

    # Install Alteryx Patch
    $installerPath = 'C:\Program Files\Alteryx\AlteryxPatchInstall_2023.1.1.1.200.exe'
    $arguments = '/s'
    Write-Progress -Activity "Installing Alteryx Patch" -Status 'Starting Install...'
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

    # Delete the installer file
    Remove-Item -Path $installerPath -Force
    Write-Progress -Activity "Installing Alteryx Patch" -Status 'Install Complete' -Completed

    # Install Alteryx R Tools
    $installerPath = 'C:\Program Files\Alteryx\RInstaller_2023.1.1.200.exe'
    $arguments = '/s'
    Write-Progress -Activity "Installing Alteryx R Tools" -Status 'Starting Install...'
    Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

    # Delete the installer file
    Remove-Item -Path $installerPath -Force
    Write-Progress -Activity "Installing Alteryx R Tools" -Status 'Install Complete' -Completed
}

# Always run Standard
Standard

# Run Developer or Analytics based on $laptoptype
if ($laptoptype -eq '1') {
    Developer
}
elseif ($laptoptype -eq '2') {
    Analytics
}

Write-Host 'Finished Installing Apps' -ForegroundColor Green