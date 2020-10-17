<#
    .SYNOPSIS
    Creates or overwrites a new Windows shell library.
    .DESCRIPTION
    The New-Library command creates or overwrites a new Windows shell library with the specified parameters.
    .PARAMETER Name
    The name of the library.
    .PARAMETER Type
    The content type of the library.
    .PARAMETER Paths
    Paths for the library content. The first path will be the default path for save.
    .PARAMETER Pinned
    Indicates whether the library is pinned in the navigation pane.
    .EXAMPLE
    New-Library "New library" C:\Generic

    Creates a new generic library with an unique path.
    .EXAMPLE
    New-Library "New videos library" D:\Videos -Type Videos

    Creates a new video library with an unique path.
    .EXAMPLE
    New-Library "New documents library" -Type Documents -Paths C:\Documents, D:\Documents

    Creates a new documents library with multiple paths.
    .EXAMPLE
    New-Library "New music library" -Type Music -Paths C:\Music, D:\Music -Pinned

    Creates a new music library with multiple paths, pinned to the navigation pane.
#>
param
(
    [Parameter(Mandatory, Position=0)][string]$Name,
    [Parameter(Mandatory, Position=1)][string[]]$Paths,
    [ValidateSet("Generic", "Documents", "Music", "Pictures", "Videos")][string]$Type = "Generic",
    [switch]$Pinned
)
function LoadNugetDll
{
    [OutputType([bool])]
    param([Parameter(Mandatory)][string]$PackageName)
    if ((Get-Package -Name $PackageName).Count -eq 0) { Install-Package -Name $PackageName -ProviderName nuget -Source "https://www.nuget.org/api/v2/" -Scope CurrentUser -Force }
    $maxVersion = 0
    $dllPath = ""
    foreach ($dll in Get-ChildItem (Join-Path (Split-Path -Parent (Get-Package -Name $PackageName).Source) lib) -Filter *.dll -Recurse)
    {
        $version = $dll.Directory.Name -replace "net", ""
        if ($version -match "^\d+$" -and $version -gt $maxVersion)
        {
            $maxVersion = $version
            $dllPath = $dll.FullName
        }
    }
    if (-Not (Test-Path $dllPath))
    {
        Write-Error "Cannot find dependency $PackageName."
        return $false
    }
    Add-Type -Path $dllPath
    return $true
}
if (-Not (LoadNugetDll("Microsoft-WindowsAPICodePack-Core")) -or -Not (LoadNugetDll("Microsoft-WindowsAPICodePack-Shell"))) { return }
if (-Not [Microsoft.WindowsAPICodePack.Shell.ShellLibrary]::IsPlatformSupported)
{
    Write-Error "Libraries are not supported in this platform."
    return
}
$library = New-Object Microsoft.WindowsAPICodePack.Shell.ShellLibrary -ArgumentList $Name, $true
switch($Type)
{
    "Generic" { $library.LibraryType = [Microsoft.WindowsAPICodePack.Shell.LibraryFolderType]::Generic }
    "Documents" { $library.LibraryType = [Microsoft.WindowsAPICodePack.Shell.LibraryFolderType]::Documents }
    "Music" { $library.LibraryType = [Microsoft.WindowsAPICodePack.Shell.LibraryFolderType]::Music }
    "Pictures" { $library.LibraryType = [Microsoft.WindowsAPICodePack.Shell.LibraryFolderType]::Pictures }
    "Videos" { $library.LibraryType = [Microsoft.WindowsAPICodePack.Shell.LibraryFolderType]::Videos }
}
foreach($path in $Paths) { if (Test-Path $path -PathType Container) { $library.Add($path) } }
$library.DefaultSaveFolder = $Paths[0]
#if (Test-Path $path -PathType Leaf) { $library.IconResourceId = (New-Object Microsoft.WindowsAPICodePack.Shell.IconReference -ArgumentList "$IconPath,$IconIndex") }
$library.IsPinnedToNavigationPane = $Pinned
$library.Close()