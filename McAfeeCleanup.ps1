# McAfee Cleanup Tool
# Here we check for bunch of McAfee install locations to check if any of these exists then to run the script to speed up this step.
$installLocations = @(
    'C:\Program Files\McAfee',
    'C:\Program Files (x86)\McAfee',
    'C:\ProgramData\McAfee',
    'C:\ProgramData\McAfee\Agent',
    'C:\ProgramData\McAfee\Endpoint Security',
    'C:\ProgramData\McAfee\Endpoint Security\Logs',
    'C:\ProgramData\McAfee\Endpoint Security\Threat Prevention',
    'C:\ProgramData\McAfee\Endpoint Security\Platform',
    'C:\ProgramData\McAfee\Endpoint Security\Endpoint Security Platform',
    'C:\ProgramData\McAfee\Endpoint Security\Endpoint Security Platform\Threat Prevention'
)

$found = $false

foreach ($location in $installLocations) {
    if (Test-Path -Path $location -PathType Container) {
        $found = $true
        break
    }
}

if ($found) {
    # Define variables
    $sourceUrl = 'https://raw.githubusercontent.com/Sp5rky/wut/main/scripts/MCPR.zip'
    $downloadPath = 'C:\Temp\MCPR.zip'
    $extractPath = 'C:\Temp'
    $params = '-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s'

    # Check if the directory exists and create it if it does not
    if (-not (Test-Path $extractPath)) {
        New-Item -ItemType Directory -Force -Path $extractPath
    }

    # Download the File
    $download = Start-BitsTransfer -Source $sourceUrl -Destination $downloadPath -Asynchronous
    while ($download.JobState -ne 'Transferred') {
        [int] $dlProgress = ($download.BytesTransferred / $download.BytesTotal) * 100
        Write-Progress -Activity 'Downloading McAfee Cleanup Tool...' -Status 'Downloading' -PercentComplete $dlProgress
    }
    Complete-BitsTransfer $download.JobId

    # Extract zip file to temporary folder
    Expand-Archive -LiteralPath $downloadPath -DestinationPath $extractPath

    # Construct path to mccleanup.exe
    $exePath = Join-Path -Path $extractPath -ChildPath 'MCPR\mccleanup.exe'

    # Define progress bar parameters
    $progParams = @{
        Activity         = 'Running mccleanup.exe'
        Status           = 'Starting script this can take up to 15 minutes to complete...'
        PercentComplete  = 0
        CurrentOperation = ''
    }

    # Start progress bar
    Write-Progress @progParams

    # Run mccleanup.exe with specified parameters
    $process = Start-Process -FilePath $exePath -ArgumentList $params -Verb RunAs -PassThru

    # Define the timer variables
    $totalTime = 540 # 15 minutes in seconds
    $interval = 1 # Update interval in seconds
    $startTime = Get-Date

    # Update the progress bar while the process is running
    while (-not $process.HasExited) {
        $elapsedTime = (Get-Date) - $startTime
        $remainingTime = $totalTime - $elapsedTime.TotalSeconds
        if ($remainingTime -le 0) {
            $remainingTime = 0
        }
        $progParams['PercentComplete'] = (1 - ($remainingTime / $totalTime)) * 100
        Write-Progress @progParams
        Start-Sleep -Seconds $interval
    }

    # Update progress bar
    $progParams['PercentComplete'] = 100
    $progParams['Status'] = 'Done!'
    Write-Progress @progParams

    # Delete temporary files and folders
    Remove-Item -Path $downloadPath
    Remove-Item -Path (Join-Path -Path $extractPath -ChildPath 'MCPR') -Recurse

    Write-Host 'Finished Removing McAfee' -ForegroundColor Green
}
else {
    Write-Host 'No McAfee Found' -ForegroundColor Green
}