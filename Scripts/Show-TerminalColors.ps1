<#
    .SYNOPSIS
    Shows the correlation between the solarized color scheme and the current color scheme.
    .DESCRIPTION
    Shows the correlation between the solarized color palette and the current colors
    and a correlation between the console color table and both light and dark solarized schemes.
#>
# Map the Solarized colors to their ColorTable pairings
$SolarizedPallet = [ordered]@{
    'base03' = 'Black'
    'base02' = 'DarkGray'
    'base01' = 'DarkGreen'
    'base00' = 'DarkYellow'
    'base0' = 'DarkBlue'
    'base1' = 'DarkCyan'
    'base2' = 'Gray'
    'base3' = 'White'
    'yellow' = 'Yellow'
    'orange' = 'DarkRed'
    'red' = 'Red'
    'magenta' = 'Magenta'
    'violet' = 'DarkMagenta'
    'blue' = 'Blue'
    'cyan' = 'Cyan'
    'green' = 'Green'
}
$PalletSolarized = @{} # Will be used to invert the mapping
Write-Host
# Try and use the default foreground and background color to identify the installed theme.
# Since the color names don't necessarily represent the actual color, this isn't a
# precise way to do this, but it works for the 4 most common cases.
#   CMD:                Gray/Black
#   PowerShell:         DarkYellow/DarkMagenta
#   Solarized Light:    DarkYellow/White
#   Solarized Dark:     DarkBlue/Black
$ForegroundColor = $HOST.UI.RawUI.ForegroundColor.ToString()
$BackgroundColor = $HOST.UI.RawUI.BackgroundColor.ToString()
if ($ForegroundColor -eq 'Gray' -and $BackgroundColor -eq 'Black') {
    # CMD
    $ForegroundColor = 'White'
    $BackgroundColor = 'DarkGray'
} elseif ($ForegroundColor -eq 'DarkYellow' -and $BackgroundColor -eq 'DarkMagenta') {
    # PowerShell default
    $ForegroundColor = 'White'
    $BackgroundColor = 'Blue'
} elseif ($ForegroundColor -eq 'DarkYellow' -and $BackgroundColor -eq 'White') {
    # Solarized Light
    $ForegroundColor = 'DarkGreen'
    $BackgroundColor = 'Gray'
} elseif ($ForegroundColor -eq 'DarkBlue' -and $BackgroundColor -eq 'Black') {
    # Solarized Dark
    $ForegroundColor = 'DarkCyan'
    $BackgroundColor = 'DarkGray'
}
# Draw table of Solarized mappings
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
Write-Host " " -NoNewline
Write-Host (" {0,-15} {1,-15} {2,-15} " -f "SOLARIZED", "LIGHT", "DARK") -BackgroundColor $BackgroundColor
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
$SolarizedPallet.keys | `
    ForEach-Object {
        Write-Host " " -NoNewline
        Write-Host (" {0,-15} " -f $_) -BackgroundColor $BackgroundColor -NoNewline
        Write-Host ("{0,-15}" -f $SolarizedPallet[$_]) -NoNewline -ForegroundColor $SolarizedPallet[$_] -BackgroundColor 'White'
        Write-Host (" " -f $_) -BackgroundColor $BackgroundColor -NoNewline
        Write-Host ("{0,-15}" -f $SolarizedPallet[$_]) -NoNewline -ForegroundColor $SolarizedPallet[$_] -BackgroundColor 'Black'
        Write-Host (" " -f $_) -BackgroundColor $BackgroundColor
        $PalletSolarized.Add($SolarizedPallet[$_], $_) # Create the inverted map
    }
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
Write-Host
$Colors = [Enum]::GetValues( [System.ConsoleColor] )
# Draw table of ColorTable mappings
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
Write-Host " " -NoNewline
Write-Host (" {0, -15} {1, -15} {2, -15} " -f "COLOR TABLE", "LIGHT", "DARK") -BackgroundColor $BackgroundColor
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
$Colors | `
    ForEach-Object {
        Write-Host " " -NoNewline
        Write-Host (" {0,-11} [{1:X}] " -f $_.ToString(), $index++) -BackgroundColor $BackgroundColor -NoNewline
        Write-Host ("{0,-15}" -f $PalletSolarized[$_.ToString()]) -NoNewline -ForegroundColor $_.ToString() -BackgroundColor 'White'
        Write-Host (" " -f $_.ToString()) -BackgroundColor $BackgroundColor -NoNewline
        Write-Host ("{0,-15}" -f $PalletSolarized[$_.ToString()]) -NoNewline -ForegroundColor $_.ToString() -BackgroundColor 'Black'
        Write-Host (" " -f $_.ToString()) -BackgroundColor $BackgroundColor
    }
Write-Host " " -NoNewline
Write-Host (" " * 49) -BackgroundColor $BackgroundColor
Write-Host