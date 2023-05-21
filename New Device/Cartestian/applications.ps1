param (
    [Parameter(Mandatory = $true)]
    [string]$laptoptype
)

$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object { $_.EndsWith('.msixbundle') }
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split('/')[-1]
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 1 of 2'
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
Write-Progress -Activity 'Installing Winget CLI...' -Status 'Downloading Step 2 of 2'
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Set-Variable ProgressPreference SilentlyContinue
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage $latestWingetMsixBundle
Set-Variable ProgressPreference Continue

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
        'Python.Python.3.9 -v 3.9.5'
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
                    Invoke-WebRequest -Uri $source -OutFile $destination
                    Write-Progress -Activity "Downloading $filename" -Status 'Download Complete' -Completed
                    break
                }
                catch {
                    $retryCount++
                    if ($retryCount -ge $retryLimit) {
                        Write-Warning "There was an error downloading the file after $retryLimit attempts: $_"
                        break
                    }
                    else {
                        Write-Warning "Error downloading the file, attempt $retryCount of $retryLimit : $_"
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
            Write-Host "Successfully extracted '$($zipFile.Name)' to '$destinationPath'"

            # Delete the original zip file
            Remove-Item -Path $zipFile.FullName -Force
            Write-Host "Deleted '$($zipFile.Name)'"
        }
        catch {
            Write-Warning "Failed to extract '$($zipFile.Name)': $_"
        }
    }
    # extra code to install
}

function Analytics {
    Write-Host -Activity 'Installing Analytics laptop...' -ForegroundColor Green
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
    $anal1 = 'https://onedrive.live.com/download?cid=9CAB1ECFC3DC039E&resid=9CAB1ECFC3DC039E%21661041&authkey=ANTSHPqYbhEa4mk'

    $files = @{
        'RStudio.zip' = $anal1
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
                    Invoke-WebRequest -Uri $source -OutFile $destination
                    Write-Progress -Activity "Downloading $filename" -Status 'Download Complete' -Completed
                    break
                }
                catch {
                    $retryCount++
                    if ($retryCount -ge $retryLimit) {
                        Write-Warning "There was an error downloading the file after $retryLimit attempts: $_"
                        break
                    }
                    else {
                        Write-Warning "Error downloading the file, attempt $retryCount of $retryLimit : $_"
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
        
        try {
            Expand-Archive -Path $zipFile.FullName -DestinationPath $destinationPath -Force
            Write-Host "Successfully extracted '$($zipFile.Name)' to '$destinationPath'"

            # Delete the original zip file
            Remove-Item -Path $zipFile.FullName -Force
            Write-Host "Deleted '$($zipFile.Name)'"
        }
        catch {
            Write-Warning "Failed to extract '$($zipFile.Name)': $_"
        }
    }
    # extra code to install  
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
