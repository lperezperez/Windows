<#
    .SYNOPSIS
    Renames font files to they titles.
    .DESCRIPTION
    Renames font files at the specified path with its file title extended property.
    The valid file extensions are: .fnt, .fon, .mmm, .otf, .pbf, .pfm, .ttc and .ttf
    .PARAMETER Path
    May be either the path to a font file or to a folder containing font files.
    .PARAMETER FromFont
    Indicates whether the name will be set from the font family name. If not specified, the name will be set from the extended file properties.
    .EXAMPLE
    Rename-Font -Path folder
    Get all font files from the specified folder and renames using its extended file properties.
    .EXAMPLE
    Rename-Font -Path font
    Rename provided font using its extended file properties.
    .EXAMPLE
    Rename-Font -Path folder -FromFont
    Get all font files from the specified folder and renames using its font family names.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param
(
    [Alias('FullName', 'PSPath')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$Path,
    [Alias('FromFont', 'FontName')]
    [switch]$FromFontName
)
begin
{
    if ($FromFontName.IsPresent) { Add-Type -AssemblyName System.Drawing }
    else { $Shell = New-Object -ComObject Shell.Application }
}
process
{
    foreach ($fontFile in $(Get-ChildItem -Path $Path -File -Recurse -Include *.fnt, *.fon, *.mmm, *.otf, *.pbf, *.pfm, *.ttc, *.ttf))
    {
        if ($FromFontName.IsPresent)
        {
            # Get font name
            $privateFontCollection = New-Object System.Drawing.Text.PrivateFontCollection
            $privateFontCollection.AddFontFile($fontFile.FullName)
            $fontName = $privateFontCollection.Families.Name
            if ($privateFontCollection.Families[0].IsStyleAvailable([System.Drawing.FontStyle]::Bold)) { $fontName += " Bold" }
            if ($privateFontCollection.Families[0].IsStyleAvailable([System.Drawing.FontStyle]::Italic)) { $fontName += " Italic" }
        }
        else
        {
            $folder = $Shell.Namespace($fontFile.DirectoryName)
            # Get title extended file property
            $fontName = $folder.GetDetailsOf($folder.ParseName($fontFile.Name), 21)
        }
        if ($fontFile.BaseName -ne $fontName)
        {
            $newFontFile = $fontName + $fontFile.Extension
            if (Test-Path (Join-Path $fontFile.DirectoryName $newFontFile)) { Write-Warning "$newFontFile already exists." }
            else
            { 
                Rename-Item $fontFile.FullName $newFontFile
                Write-Host "Font $($fontFile.Name) renamed to $newFontFile." -ForegroundColor Green
            }
        }
    }
}
end { $Shell = $null }