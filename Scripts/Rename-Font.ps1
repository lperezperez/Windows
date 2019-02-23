<#
    .SYNOPSIS
    Renames font files to they titles.
    .DESCRIPTION
    Renames font files at the specified path with its file title extended property.
    The valid file extensions are: .fnt, .fon, .mmm, .otf, .pbf, .pfm, .ttc and .ttf
    .PARAMETER Path
    May be either the path to a font file or to a folder containing font files.
    .EXAMPLE
    Rename-Font -Path folder
    Get all font files from the specified folder and renames.
    .EXAMPLE
    Rename-Font -Path font
    Rename provided font.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName', 'PSPath')]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$Path
)
begin { $Shell = New-Object -ComObject Shell.Application }
process
{
    foreach ($fontFile in $(Get-ChildItem -Path $Path -File -Recurse -Include *.fnt, *.fon, *.mmm, *.otf, *.pbf, *.pfm, *.ttc, *.ttf))
    {
        $folder = $Shell.Namespace($fontFile.DirectoryName)
        # Get Title Extended File Property
        $fontName = $folder.GetDetailsOf($folder.ParseName($fontFile.Name), 21)
        # Get font name
        #$privateFontCollection = New-Object System.Drawing.Text.PrivateFontCollection
        #$privateFontCollection.AddFontFile($fontFile.FullName)
        #$fontName = $privateFontCollection.Families.Name
        Rename-Item $fontFile.FullName ($fontName + $fontFile.Extension)
    }
}
end { $Shell = $null }