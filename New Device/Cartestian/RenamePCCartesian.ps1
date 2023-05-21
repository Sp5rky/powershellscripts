# Get the PCs serial number and rename the PC to cart-<serial number>
$Serial = (Get-WmiObject Win32_BIOS).SerialNumber
Rename-Computer -NewName cart-$Serial -Force