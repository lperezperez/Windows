<#
.SYNOPSIS
Sets the Solarized color palette an the specified mode for command prompt and PowerShell .lnk files.
.DESCRIPTION
Updates the color palette in the specified .lnk files to match with Solarized Dark/Light color schema and applies the specified mode.
.PARAMETER Mode
The Solarized mode to apply into the .lnk files specified.
.PARAMETER LinkFiles
A list of .lnk files to apply the Solarized mode.
#>
param
(
    [Parameter()]
    [ValidateSet("Dark", "Light")]
    [string]
    $Mode = "Dark",

    [Parameter()]
    [ValidateScript(
    {
        Foreach ($file in $_)
        {
            if (-Not (Test-Path $file))
            {
                throw "Cannot find $file"
            }
        }
        return $true
    }
    )]
    [string[]]
    $Files = @("$Env:AppData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell (x86).lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk", "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Bash on Ubuntu on Windows.lnk")
)
Add-Type -Path "$PSScriptRoot\Windows.Shell.cs" -ReferencedAssemblies System.Drawing
Foreach ($file in $Files)
{
    [Windows.Shell.Link]::SetSolarizedMode($Mode, $file)
    Write-Host "Solarized $Mode applied to $file"
}