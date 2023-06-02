<#
.NOTES
	Version:        1.0
	Author:         George Slight
	Creation Date:  02/06/2023
#>

#Remove HP Documentation
if (Test-Path 'C:\Program Files\HP\Documentation\Doc_uninstall.cmd' -PathType Leaf) {
    Try {
        Invoke-Item 'C:\Program Files\HP\Documentation\Doc_uninstall.cmd'
        Write-Host 'Successfully removed provisioned package: HP Documentation' 
    }
    Catch {
        Write-Host  "Error Remvoving HP Documentation $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  'HP Documentation is not installed' 
}

#Remove HP Support Assistant silently

$HPSAuninstall = 'C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe'

if (Test-Path -Path 'HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport') {
    Try {
        Remove-Item -Path 'HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport'
        Write-Host  "HP Support Assistant regkey deleted $($_.Exception.Message)" 
    }
    Catch {
        Write-Host  "Error retreiving registry key for HP Support Assistant: $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  'HP Support Assistant regkey not found' 
}

if (Test-Path $HPSAuninstall -PathType Leaf) {
    Try {
        & $HPSAuninstall /s /v/qn UninstallKeepPreferences=FALSE
        Write-Host 'Successfully removed provisioned package: HP Support Assistant silently' 
    }
    Catch {
        Write-Host  "Error uninstalling HP Support Assistant: $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  'HP Support Assistant Uninstaller not found' 
}


#Remove HP Connection Optimizer

$HPCOuninstall = 'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe'

#copy uninstall file
xcopy /y .\uninstallHPCO.iss C:\Windows\install\
Write-Host  'Succesfully copied file uninstallHPCO.iss to C:\Windows\install ' 

if (Test-Path $HPCOuninstall -PathType Leaf) {
    Try {
        & $HPCOuninstall -runfromtemp -l0x0413  -removeonly -s -f1C:\Windows\install\uninstallHPCO.iss
        Write-Host 'Successfully removed HP Connection Optimizer' 
    }
    Catch {
        Write-Host  "Error uninstalling HP Connection Optimizer: $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  'HP Connection Optimizer not found' 
}


#List of packages to install
$UninstallPackages = @(
    'AD2F1837.HPJumpStarts'
    'AD2F1837.HPPCHardwareDiagnosticsWindows'
    'AD2F1837.HPPowerManager'
    'AD2F1837.HPPrivacySettings'
    'AD2F1837.HPSupportAssistant'
    'AD2F1837.HPSureShieldAI'
    'AD2F1837.HPSystemInformation'
    'AD2F1837.HPQuickDrop'
    'AD2F1837.HPWorkWell'
    'AD2F1837.myHP'
    'AD2F1837.HPDesktopSupportUtilities'
    'AD2F1837.HPEasyClean'
    'AD2F1837.HPSystemInformation'
    'Microsoft.GetHelp'
    'Microsoft.Getstarted'
    'Microsoft.MicrosoftOfficeHub'
    'Microsoft.MicrosoftSolitaireCollection'
    'Microsoft.People'
    'Microsoft.StorePurchaseApp'
    'microsoft.windowscommunicationsapps'
    'Microsoft.WindowsFeedbackHub'
    'Microsoft.Xbox.TCUI'
    'Microsoft.XboxGameOverlay'
    'Microsoft.XboxGamingOverlay'
    'Microsoft.XboxIdentityProvider'
    'Microsoft.XboxSpeechToTextOverlay'
    'Microsoft.XboxApp'
    'Microsoft.Wallet'
    'Microsoft.SkyeApp'
    'Microsoft.BingWeather'
    'Tile.TileWindowsApplication'
)

# List of programs to uninstall
$UninstallPrograms = @(
    'HP Connection Optimizer'
    'HP Documentation'
    'HP MAC Address Manager'
    'HP Notifications'
    'HP Security Update Service'
    'HP System Default Settings'
    'HP Sure Click'
    'HP Sure Run'
    'HP Sure Recover'
    'HP Sure Sense'
    'HP Sure Sense Installer'
    'HP Wolf Security Application Support for Sure Sense'
    'HP Wolf Security Application Support for Windows'
    'HP Client Security Manager'
    'HP Wolf Security'
)

#Get a list of installed packages matching our list
$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object { ($UninstallPackages -contains $_.Name) }

#Get a list of Provisioned packages matching our list
$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { ($UninstallPackages -contains $_.DisplayName) }

#Get a list of installed programs matching our list
$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }


# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {
    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]" 
    }
    Catch {
        Write-Host  "Failed to remove provisioned package: [$($ProvPackage.DisplayName)] Error message: $($_.Exception.Message)" 
    }
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host "Successfully removed Appx package: [$($AppxPackage.Name)]" 
    }
    Catch {
        Write-Host  "Failed to remove Appx package: [$($AppxPackage.Name)] Error message: $($_.Exception.Message)" 
    }
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {
    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host "Successfully uninstalled: [$($_.Name)]" 
    }
    Catch {
        Write-Host  "Failed to uninstall: [$($_.Name)] Error message: $($_.Exception.Message)" 
    }
}

#Fallback attempt 1 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x '{0E2E04B0-9EDD-11EB-B38C-10604B96B11E}' /qn /norestart
    Write-Host 'Fallback to MSI uninistall for HP Wolf Security initiated' 
}
Catch {
    Write-Host  "Failed to uninstall HP Wolf Security using MSI - Error message: $($_.Exception.Message)" 
}

#Fallback attempt 2 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x '{4DA839F0-72CF-11EC-B247-3863BB3CB5A8}' /qn /norestart
    Write-Host 'Fallback to MSI uninistall for HP Wolf 2 Security initiated' 
}
Catch {
    Write-Host  "Failed to uninstall HP Wolf Security 2 using MSI - Error message: $($_.Exception.Message)" 
}


#Remove shortcuts
$pathTCO = 'C:\ProgramData\HP\TCO'
$pathTCOc = 'C:\Users\Public\Desktop\TCO Certified.lnk'
$pathOS = 'C:\Program Files (x86)\Online Services'
$pathFT = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Free Trials.lnk'

if (Test-Path $pathTCO) {
    Try {
        Remove-Item -LiteralPath $pathTCO -Force -Recurse
        Write-Host "Shortcut for $pathTCO removed" 
    }
    Catch {
        Write-Host  "Error deleting $pathTCO $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  "Folder $pathTCO not found" 
}

if (Test-Path $pathTCOc -PathType Leaf) {
    Try {
        Remove-Item -Path $pathTCOc  -Force -Recurse
        Write-Host "Shortcut for $pathTCOc removed" 
    }
    Catch {
        Write-Host  "Error deleting $pathTCOc $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  "File $pathTCOc not found" 
}

if (Test-Path $pathOS) {
    Try {
        Remove-Item -LiteralPath $pathOS  -Force -Recurse
        Write-Host "Shortcut for $pathOS removed" 
    }
    Catch {
        Write-Host  "Error deleting $pathOS $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  "Folder $pathOS not found" 
}

if (Test-Path $pathFT -PathType Leaf) {
    Try {
        Remove-Item -Path $pathFT -Force -Recurse
        Write-Host "Shortcut for $pathFT removed" 
    }
    Catch {
        Write-Host  "Error deleting $pathFT $($_.Exception.Message)" 
    }
}
Else {
    Write-Host  "File $pathFT not found" 
}

#Clean up uninstall file for HP Connection Optimizer
Remove-Item -Path C:\Windows\install\uninstallHPCO.iss -Force
Write-Host  'Succesfully deleted file C:\Windows\install\uninstallHPCO.iss ' 