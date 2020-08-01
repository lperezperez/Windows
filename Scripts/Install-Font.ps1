<#
    .SYNOPSIS
    Install fonts on Windows system.
    .DESCRIPTION
    Copy fonts to Windows system fonts folder and register them.
    The valid file extensions are: .fnt, .fon, .otf, .ttc and .ttf
    .PARAMETER Path
    May be either the path to a font file or to a folder containing font files to install.
    .EXAMPLE
    Install-Font -Path font
    Install provided font in Windows.
    .EXAMPLE
    Install-Font -Path folder
    Get all font files (recursively) from the specified folder and install in Windows.
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$Path,
    [switch]$Force
)
begin
{
    $Path = Resolve-Path $Path
    # If not currently running "as Administrator"...
    If (-Not $(new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        # Starts a new PowerShell elevated process
        Start-Process PowerShell -ArgumentList "-NoProfile -File $($MyInvocation.MyCommand.Definition) $($Path)" -Verb runas
        # Exit current process
        Exit
    }
    # Get system fonts folder
    $FontsFolderPath = [System.Environment]::GetFolderPath("Fonts")
    # Get system fonts registry key
    $FontsRegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    # Hashtable between font file extensions and text to append to the registry entry name of the font.
    $FontFileTypes = @{}
    $FontFileTypes.Add(".fon", "")
    $FontFileTypes.Add(".fnt", "")
    $FontFileTypes.Add(".otf", " (OpenType)")
    $FontFileTypes.Add(".ttc", " (TrueType)")
    $FontFileTypes.Add(".ttf", " (TrueType)")
    # Load P/Invoke calls
    Add-Type -Name Fonts -Namespace System -MemberDefinition @"
    /// <summary>The window handle value to send a message to all top-level windows in the system, including disabled or invisible unowned windows, overlapped windows, and pop-up windows. The message is not posted to child windows.</summary>
    public static IntPtr HWND_BROADCAST = new IntPtr(0xffff);
    /// <summary>The Windows message sent to all top-level windows in the system after changing the pool of font resources.</summary>
    public static uint WM_FONTCHANGE = 0x001D;
    /// <summary>Adds the font resource from the specified file to the system font table. The font can subsequently be used for text output by any application.</summary>
    /// <param name="lpFilename">The path of the font file.</param>
    /// <returns>
    ///     If the function succeeds, the return value specifies the number of fonts added.
    ///     If the function fails, the return value is zero. No extended error information is available.
    /// </returns>
    /// <remarks>
    ///     Any application that adds or removes fonts from the system font table should notify other windows of the change by sending a <see cref="WM_FONTCHANGE"/> message to all top-level windows in the operating system. The application should send this message by calling the SendMessage (or <see cref="PostMessage"/>) function and setting the hWnd parameter to <see cref="HWND_BROADCAST"/>.
    ///     This function installs the font only for the current session. When the system restarts, the font will not be present. To have the font installed even after restarting the system, the font must be listed in the registry.
    ///     A font listed in the registry and installed to a location other than the Windows fonts folder cannot be modified, deleted, or replaced as long as it is loaded in any session. In order to change one of these fonts, it must first be removed by calling RemoveFontResource, removed from the font registry (HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts), and the system restarted. After restarting the system, the font will no longer be loaded and can be changed.
    /// </remarks>
    [DllImport("gdi32.dll")]
    public static extern int AddFontResource(string lpFilename);
    /// <summary>Removes the fonts in the specified file from the system font table.</summary>
    /// <param name="lpFilename">The path of the font resources file.</param>
    /// <returns>
    ///     If the function succeeds, the return value is nonzero.
    ///     If the function fails, the return value is zero.
    /// </returns>
    /// <remarks>
    ///     Any application that adds or removes fonts from the system font table should notify other windows of the change by sending a <see cref="WM_FONTCHANGE"/> message to all top-level windows in the operating system. The application should send this message by calling the SendMessage (or <see cref="PostMessage"/>) function and setting the hWnd parameter to <see cref="HWND_BROADCAST"/>.
    ///     If there are outstanding references to a font, the associated resource remains loaded until no device context is using it. Furthermore, if the font is listed in the font registry (HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts) and is installed to any location other than the %windir%\fonts\ folder, it may be loaded into other active sessions (including session 0).
    ///     When you try to replace an existing font file that contains a font with outstanding references to it, you might get an error that indicates that the original font can't be deleted because it’s in use even after you call RemoveFontResource. If your app requires that the font file be replaced, to reduce the resource count of the original font to zero, call RemoveFontResource in a loop as shown in this example code. If you continue to get errors, this is an indication that the font file remains loaded in other sessions. Make sure the font isn't listed in the font registry and restart the system to ensure the font is unloaded from all sessions.
    /// </remarks>
    [DllImport("gdi32.dll")]
    public static extern bool RemoveFontResource(string lpFilename);
    /// <summary>
    ///     Places (posts) a message in the message queue associated with the thread that created the specified window and returns without waiting for the thread to process the message.
    /// </summary>
    /// <param name="hWnd">
    ///     A handle to the window whose window procedure is to receive the message. The following values have special meanings.
    ///     <list type="table">
    ///         <listheader>
    ///             <term>Value</term>
    ///             <description>Meaning</description>
    ///         </listheader>
    ///         <item>
    ///             <term>HWND_BROADCAST ((HWND)0xffff)</term>
    ///             <description>The message is posted to all top-level windows in the system, including disabled or invisible unowned windows, overlapped windows, and pop-up windows. The message is not posted to child windows.</description>
    ///         </item>
    ///         <item>
    ///             <term>NULL</term>
    ///             <description>The function behaves like a call to PostThreadMessage with the dwThreadId parameter set to the identifier of the current thread.</description>
    ///         </item>
    ///     </list>
    ///     Starting with Windows Vista, message posting is subject to UIPI. The thread of a process can post messages only to message queues of threads in processes of lesser or equal integrity level.
    /// </param>
    /// <param name="Msg">
    ///     The message to be posted.
    ///     For lists of the system-provided messages, see <see href="https://msdn.microsoft.com/en-us/library/windows/desktop/ms644927(v=vs.85).aspx#system_defined">System-Defined Messages</see>.
    /// </param>
    /// <param name="wParam">Additional message-specific information.</param>
    /// <param name="lParam">Additional message-specific information.</param>
    /// <returns>
    ///     If the function succeeds, the return value is nonzero.
    ///     If the function fails, the return value is zero. To get extended error information, call GetLastError. GetLastError returns ERROR_NOT_ENOUGH_QUOTA when the limit is hit.
    /// </returns>
    /// <remarks>
    ///     When a message is blocked by UIPI the last error, retrieved with GetLastError, is set to 5 (access denied).
    ///     Messages in a message queue are retrieved by calls to the GetMessage or PeekMessage function.
    ///     Applications that need to communicate using HWND_BROADCAST should use the RegisterWindowMessage function to obtain a unique message for inter-application communication.
    /// </remarks>
    [return: MarshalAs(UnmanagedType.Bool)]
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
"@
}
process
{
    # For each font resource file...
    foreach ($fontFile in $(Get-ChildItem -Path $Path -File -Recurse -Include *.fnt, *.fon, *.otf, *.ttc, *.ttf))
    {
        # Try to install font
        try
        {
            $fontFilePath = Join-Path $FontsFolderPath $fontFile.Name # Destination font file path
            $fontRegistryEntry = $fontFile.BaseName + $FontFileTypes.item($fontFile.Extension) # Font registry entry
            # Copy font file if destination path don't exists...
            if ((Test-Path $fontFilePath) -and !$Force) {
                Write-Host "Font $fontRegistryEntry already in Windows fonts folder." -ForegroundColor Yellow
                #continue
            }
            else { Copy-Item $fontFile.FullName $fontFilePath -Force }
            # Get Registry entry value
            $registerFont = $true
            try {
                $fontFileInstalled = Get-ItemPropertyValue $FontsRegistryKey -Name $fontRegistryEntry
                if ($fontFileInstalled -eq $fontFile.Name) { $registerFont = $false }
                else
                {
                    # Unregister and remove the font file...
                    $replacedFontPath = Join-Path $FontsFolderPath $fontFileInstalled
                    if (Test-Path $replacedFontPath)
                    {
                        if ([Fonts]::RemoveFontResource($replacedFontPath))
                        {
                            [Fonts]::PostMessage([Fonts]::HWND_BROADCAST, [Fonts]::WM_FONTCHANGE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
                            Write-Host "Font $fontRegistryEntry unregistered." -ForegroundColor Yellow
                        }
                        Remove-Item $replacedFontPath
                        Write-Host "Font $fontFileInstalled removed." -ForegroundColor Yellow
                    }
                }
            }
            catch { }
            if ($registerFont)
            {
                # Install and register font file
                Set-ItemProperty $FontsRegistryKey $fontRegistryEntry $fontFile.Name
                Write-Host "Font $fontRegistryEntry installed." -ForegroundColor Green
                if ([Fonts]::AddFontResource($fontFilePath) -eq 0) { Write-Host "Cannot register $fontRegistryEntry." -ForegroundColor Yellow }
                elseif ([Fonts]::PostMessage([Fonts]::HWND_BROADCAST, [Fonts]::WM_FONTCHANGE, [IntPtr]::Zero, [IntPtr]::Zero)) { Write-Host "Font $fontRegistryEntry registered." -ForegroundColor Green }
            }
            else { Write-Host "Font $fontRegistryEntry already installed." -ForegroundColor Yellow }
        }
        # Font cannot be installed
        catch { Write-Host "Cannot install $fontRegistryEntry font." -ForegroundColor Red }
    }
}
end { }