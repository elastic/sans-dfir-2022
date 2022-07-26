
$install_url = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"

Write-Output "Downloading OOSU10.exe"
Set-Location "$env:TEMP"
Invoke-WebRequest -UseBasicParsing -Uri $install_url -OutFile "${env:TEMP}\OOSU10.exe"

Write-Output "Running OOSU10.exe"
. "${env:TEMP}\OOSU10.exe" "${env:USERHOME}\provision\shutup10.cfg"
