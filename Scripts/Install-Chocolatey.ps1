# If not currently running "as Administrator"...
if (-Not $(new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Starts a new PowerShell elevated process
    Start-Process -FilePath "PowerShell" -ArgumentList $MyInvocation.MyCommand.Definition -Verb runas
    # Exit current process
    Exit
}
# Create PowerShell profile.
if (-Not (Test-Path $Profile)) {
    New-item –type file –force $Profile
}
# Install Chocolatey
if (-Not (Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
    # Update session environment variables
    $RefreshEnv = Join-Path $Env:ProgramData "Chocolatey\helpers\functions\Update-SessionEnvironment.ps1"
    if (Test-Path $RefreshEnv) {
        $RefreshEnv
    }
}
& choco feature enable -n=allowGlobalConfirmation
& choco install "..\Settings\packages.config"