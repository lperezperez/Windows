<#
.SYNOPSIS
Sets a icon file as the custom icon for the folder.
.DESCRIPTION
Sets the specified icon file path as the custom icon for the folder path specified. Requires both the path to an icon file to be used as image and the path to the folder that will show the icon.
Will create two files (desktop.ini and folder.ico) under the folder path, both set as hidden files.
.EXAMPLE
Set-FolderIcon -IconPath "C:\Users\Mark\Downloads\wii_folder.ico" -FolderPath "\\FAMILY\Media\Wii"
Changes the default folder icon for the specified UNC path with the specified icon.
#>
function Set-FolderIcon
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True, Position=0)]
        [string[]]$IconPath,
        [Parameter(Mandatory=$True, Position=1)]
        [string]$FolderPath,
        [Parameter(Mandatory=$False)]
        [string]$InfoTip
    )
    begin
    {
        $desktopIniPath = "$FolderPath\desktop.ini"
        $folderIconPath = "$FolderPath\folder.ico"
        $desktopIniContent = "[.ShellClassInfo]
            ConfirmFileOp=0
            IconFile=folder.ico
            IconIndex=0"
        if ($PSBoundParameters.ContainsKey('InfoTip'))
        {
            $desktopIniContent = "`r`nInfoTip=$InfoTip"
        }
    }
    process
    {
        $desktopIniContent | Out-File $desktopIniPath
        Copy-Item -Path $IconPath -Destination $folderIconPath
    }
    end
    {
        $(Get-Item $desktopIniPath).Attributes = "Hidden";
        $(Get-Item $folderIconPath).Attributes = "Hidden";
    }
}