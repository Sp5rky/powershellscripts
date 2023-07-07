<#
.NOTES
    Version:          1.0
    Author:           George Slight @ Twisted Fish
    Creation Date:    May 21, 2023
#>

# Get the PCs serial number and rename the PC to cart-<serial number>
$Serial = (Get-WmiObject Win32_BIOS).SerialNumber; Rename-Computer -NewName cart-$Serial -Force