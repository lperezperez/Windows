<#
    .SYNOPSIS
    Sets the Solarized color scheme for command prompt and PowerShell .lnk files.
    .DESCRIPTION
    Updates the color palette in the specified .lnk files to match Solarized Dark/Light color scheme.
    .PARAMETER Mode
    The Solarized mode to apply into the .lnk files specified.
    .PARAMETER LnkFiles
    A list of .lnk files in which the Solarized mode will be applied.
#>
param(
    [Parameter()]
    [ValidateSet("Dark", "Light")]
    [string]$Mode = "Dark",
    [Parameter()]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$LnkFiles = @("$Env:AppData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell (x86).lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Bash on Ubuntu on Windows.lnk")
)
Add-Type -Path "$PSScriptRoot\Windows.Shell.cs" -ReferencedAssemblies System.Drawing
foreach ($lnkFile in $LnkFiles) {
    if (Test-Path $lnkFile) {
        [Windows.Shell.Link]::SetSolarizedMode($Mode, $lnkFile)
        Write-Host "Solarized $Mode applied to $lnkFile"
    }
}