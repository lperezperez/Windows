<#
    .SYNOPSIS
    Sets a icon file as the custom icon for the folder.
    .DESCRIPTION
    Sets the specified icon file path as the custom icon for the folder path specified. Requires both the path to an icon file to be used as image and the path to the folder that will show the icon.
    Will create two files (desktop.ini and folder.ico) under the folder path, both set as hidden files.
    .PARAMETER IconPath
    The path of the file that contains the icon
    .PARAMETER FolderPath
    The path of the folder to set the icon.
    .PARAMETER InfoTip
    A description for the folder.
    .EXAMPLE
    Set-FolderIcon -IconPath "C:\wii_folder.ico" -FolderPath "C:\Wii" -InfoTip "The Wii folder"

    Changes the default folder icon for the specified UNC path with the specified icon.
#>
[CmdletBinding()]
param
(
    [Parameter(Mandatory, Position=0)]
    [string[]]$IconPath,
    [Parameter(Mandatory, Position=1)]
    [string]$FolderPath,
    [string]$InfoTip
)
begin
{
    $desktopIniPath = "$FolderPath\desktop.ini"
    $folderIconPath = "$FolderPath\folder.ico"
    $desktopIniContent = "[.ShellClassInfo]`r`nConfirmFileOp=0`r`nIconFile=folder.ico`r`nIconIndex=0"
    if ($PSBoundParameters.ContainsKey('InfoTip'))
    {
        $desktopIniContent += "`r`nInfoTip=$InfoTip"
    }
}
process
{
    Copy-Item -Path $IconPath -Destination $folderIconPath -Force
    if (Test-Path $desktopIniPath) { Remove-Item $desktopIniPath -Force }
    $desktopIniContent | Out-File $desktopIniPath
}
end
{
    $(Get-Item $folderIconPath).Attributes = "Hidden";
    $(Get-Item $desktopIniPath).Attributes = "Hidden";
}