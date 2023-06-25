<#
.NOTES
	Version:        1.1
	Author:         George Slight
	Creation Date:  02/06/2023
#>

# Trial shortcuts/files
$trialFiles = @(
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Offers.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Amazon.com.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HP Documentation.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Agoda.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Forge of Empires.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Planet9 Link.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Free Trials.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee\McAfee®.lnk'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee'
    'C:\Program Files (x86)\Online Services\Adobe'
)

$bloatware = @(
    'Microsoft.Microsoft3DViewer'
    'Microsoft.AppConnector'
    'Microsoft.BingFinance'
    'Microsoft.BingNews'
    'Microsoft.BingSports'
    'Microsoft.BingTranslator'
    'Microsoft.BingWeather'
    'Microsoft.BingFoodAndDrink'
    'Microsoft.BingHealthAndFitness'
    'Microsoft.BingTravel'
    'Microsoft.MinecraftUWP'
    'Microsoft.GamingServices'
    'Microsoft.GetHelp'
    'Microsoft.Getstarted'
    'Microsoft.Messaging'
    'Microsoft.Microsoft3DViewer'
    'Microsoft.MicrosoftSolitaireCollection'
    'Microsoft.NetworkSpeedTest'
    'Microsoft.News'
    'Microsoft.Office.Lens'
    'Microsoft.Office.Sway'
    'Microsoft.Office.OneNote'
    'Microsoft.OneConnect'
    'Microsoft.People'
    'Microsoft.Print3D'
    'Microsoft.SkypeApp'
    'Microsoft.Wallet'
    'Microsoft.Whiteboard'
    'Microsoft.WindowsAlarms'
    'microsoft.windowscommunicationsapps'
    'Microsoft.WindowsFeedbackHub'
    'Microsoft.WindowsMaps'
    'Microsoft.WindowsPhone'
    'Microsoft.WindowsSoundRecorder'
    'Microsoft.XboxApp'
    'Microsoft.ConnectivityStore'
    'Microsoft.CommsPhone'
    'Microsoft.ScreenSketch'
    'Microsoft.Xbox.TCUI'
    'Microsoft.XboxGameOverlay'
    'Microsoft.XboxGameCallableUI'
    'Microsoft.XboxSpeechToTextOverlay'
    'Microsoft.MixedReality.Portal'
    'Microsoft.XboxIdentityProvider'
    'Microsoft.ZuneMusic'
    'Microsoft.ZuneVideo'
    'Microsoft.Getstarted'
    'Microsoft.MicrosoftOfficeHub'
    'Clipchamp.Clipchamp'
    'SpotifyAB.SpotifyMusic'
    '*MyASUS*'
    '*ASUS Business*'
    'E046963F.AIMeetingManager'
    'E0469640.SmartAppearance'
    'MirametrixInc.GlancebyMirametrix'
    'MicrosoftTeams'
    '*EclipseManager*'
    '*ActiproSoftwareLLC*'
    '*AdobeSystemsIncorporated.AdobePhotoshopExpress*'
    '*Duolingo-LearnLanguagesforFree*'
    '*PandoraMediaInc*'
    '*CandyCrush*'
    '*BubbleWitch3Saga*'
    '*Wunderlist*'
    '*Flipboard*'
    '*Twitter*'
    '*Journal*'
    '*Facebook*'
    '*Royal Revolt*'
    '*Sway*'
    '*Speed Test*'
    '*Dolby*'
    '*Viber*'
    '*ACGMediaPlayer*'
    '*Netflix*'
    '*OneCalendar*'
    '*LinkedInforWindows*'
    '*HiddenCityMysteryofShadows*'
    '*Hulu*'
    '*HiddenCity*'
    '*AdobePhotoshopExpress*'
    '*HotspotShieldFreeVPN*'
    '*Microsoft.Advertising.Xaml*'
    'ACGMediaPlayer'
    'ActiproSoftwareLLC'
    'AdobePhotoshopExpress'                  
    'Amazon.com.Amazon'                     
    'Asphalt8Airborne'                      
    'AutodeskSketchBook'
    'BubbleWitch3Saga'                      
    'CaesarsSlotsFreeCasino'
    'CandyCrush'                           
    'COOKINGFEVER'
    'CyberLinkMediaSuiteEssentials'
    'DisneyMagicKingdoms'
    'Dolby'                                 
    'DrawboardPDF'
    'Duolingo-LearnLanguagesforFree'        
    'EclipseManager'
    'Facebook'                             
    'FarmVille2CountryEscape'
    'FitbitCoach'
    'Flipboard'                            
    'HiddenCity'
    'Hulu'
    'iHeartRadio'
    'Keeper'
    'LinkedInforWindows'
    'MarchofEmpires'
    'Netflix'                               
    'NYTCrossword'
    'OneCalendar'
    'PandoraMediaInc'
    'PhototasticCollage'
    'PicsArt-PhotoStudio'
    'Plex'                                  
    'PolarrPhotoEditorAcademicEdition'
    'RoyalRevolt'                           
    'Shazam'
    'Sidia.LiveWallpaper'              
    'SlingTV'
    'Speed Test'
    'Sway'
    'TuneInRadio'
    'Twitter'                              
    'Viber'
    'WinZipUniversal'
    'Wunderlist'
    'XING'
)

$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object { ($bloatware -contains $_.Name) }
$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { ($bloatware -contains $_.DisplayName) }
$InstalledPrograms = Get-Package | Where-Object { $bloatware -contains $_.Name }

$totalSteps = $ProvisionedPackages.Count + $InstalledPackages.Count + $InstalledPrograms.Count
$currentStep = 0

# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {
    $currentStep++
    $progressPercent = ($currentStep / $totalSteps) * 100
    Write-Progress -Activity 'Removing provisioned packages' -Status "Package: $($ProvPackage.DisplayName)" -PercentComplete $progressPercent

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
    }
    Catch {}
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
    $currentStep++
    $progressPercent = ($currentStep / $totalSteps) * 100
    Write-Progress -Activity 'Removing appx packages' -Status "Package: $($AppxPackage.Name)" -PercentComplete $progressPercent

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
    }
    Catch {}
}

# Remove installed programs
ForEach ($InstalledProgram in $InstalledPrograms) {
    $currentStep++
    $progressPercent = ($currentStep / $totalSteps) * 100
    Write-Progress -Activity 'Removing installed programs' -Status "Program: $($InstalledProgram.Name)" -PercentComplete $progressPercent

    Try {
        $Null = $InstalledProgram | Uninstall-Package -AllVersions -Force -ErrorAction Stop
    }
    Catch {}
}

$trialFiles.ForEach({
        if (Test-Path -Path $_) {
            Write-Output "Removing $_ ..."
            Remove-Item -Path $_ -Force -Confirm:$false
        }
    })

function New-FolderForced {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Path
    )

    process {
        if (-not (Test-Path $Path)) {
            Write-Verbose "-- Creating full path to:  $Path"
            New-Item -Path $Path -ItemType Directory -Force
        }
    }
}

# Prevents Apps from re-installing
$cdm = @(
    'ContentDeliveryAllowed'
    'FeatureManagementEnabled'
    'OemPreInstalledAppsEnabled'
    'PreInstalledAppsEnabled'
    'PreInstalledAppsEverEnabled'
    'SilentInstalledAppsEnabled'
    'SubscribedContent-314559Enabled'
    'SubscribedContent-338387Enabled'
    'SubscribedContent-338388Enabled'
    'SubscribedContent-338389Enabled'
    'SubscribedContent-338393Enabled'
    'SubscribedContentEnabled'
    'SystemPaneSuggestionsEnabled'
)

New-FolderForced -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
foreach ($key in $cdm) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' $key 0
}

New-FolderForced -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' 'AutoDownload' 2

# Prevents "Suggested Applications" returning
New-FolderForced -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsConsumerFeatures' 1

Write-Host 'Finished Removing Bloatware Apps' -ForegroundColor Green

function unpin_taskbar([string]$appname) {
    $shellApp = New-Object -Com Shell.Application
    $folder = $shellApp.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')
    if ($null -eq $folder) {
        Write-Host 'Could not access the taskbar folder. Ensure the namespace GUID is correct and you have the necessary permissions.'
        return
    }

    $app = $folder.Items() | Where-Object { $_.Name -eq $appname }
    if ($null -eq $app) {
        return
    }

    $unpinVerb = $app.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' }
    if ($null -eq $unpinVerb) {
        return
    }

    $unpinVerb.DoIt()
}

foreach ($taskbarapp in 'Microsoft Store', 'Lenovo Vantage', 'AI Meeting Manager', 'Office') {
    unpin_taskbar("$taskbarapp")
}

# Win 11 cleanup, taskbar, and applications
$RegRoot = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount'
Remove-Item -Path $RegRoot -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

# Get the current user session ID
(Get-Process -Name explorer).SessionId > $null

# Restart Windows Explorer in the same session without starting File Explorer
Stop-Process -Name explorer -Force
$explorerProcess = Start-Process -FilePath explorer.exe -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue -Verb RunAs -ArgumentList ('-NoStartMenu', '-NoTray', '-NoTaskbar')
$explorerProcess | Wait-Process

$allUsersHive = Get-ChildItem -Path 'Registry::HKEY_USERS'
$targetKeyPath = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

foreach ($userHive in $allUsersHive) {
    $userSID = $userHive.PSChildName
    $userKeyPath = "Registry::HKEY_USERS\$userSID\$targetKeyPath"

    # Check if the registry path exists for the user SID
    if (Test-Path $userKeyPath) {
        Set-ItemProperty -Path $userKeyPath -Name 'TaskbarAl' -Value 0 -Type DWord
        Set-ItemProperty -Path $userKeyPath -Name 'TaskbarMn' -Value 0 -Type DWord
        Set-ItemProperty -Path $userKeyPath -Name 'TaskbarDa' -Value 0 -Type DWord
        Set-ItemProperty -Path $userKeyPath -Name 'ShowTaskViewButton' -Value 0 -Type DWord
    }
}

# Modify settings for the current user
Set-ItemProperty -Path "HKCU:\$targetKeyPath" -Name 'TaskbarAl' -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\$targetKeyPath" -Name 'TaskbarMn' -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\$targetKeyPath" -Name 'TaskbarDa' -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\$targetKeyPath" -Name 'ShowTaskViewButton' -Value 0 -Type DWord