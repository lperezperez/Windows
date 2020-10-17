# If not currently running "as Administrator"...
if (-Not $(new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # Starts a new PowerShell elevated process
    Start-Process -FilePath "PowerShell" -ArgumentList $MyInvocation.MyCommand.Definition -Verb runas
    # Exit current process
    Exit
}
# Copy wallpapers to defalut theme folder
Copy-Item ..\Wallpapers\* -Destination "$Env:windir\Web\Wallpaper\Theme1"