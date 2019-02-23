# If not currently running "as Administrator"...
If (-Not $(new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Starts a new PowerShell elevated process
    Start-Process -FilePath "PowerShell" -ArgumentList $MyInvocation.MyCommand.Definition -Verb runas
    # Exit current process
    Exit
}
# Create PowerShell profile.
If (-Not (Test-Path $Profile)) {
    New-item –type file –force $Profile
}
# Install Chocolatey
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
# Update session environment variables
$refreshenv = Join-Path $env:ProgramData "Chocolatey\helpers\functions\Update-SessionEnvironment.ps1"
if (Test-Path $refreshenv) {
    $refreshenv
}
Write-Host -NoNewLine "Press any key to continue..."
[Console]::ReadKey() | Out-Null