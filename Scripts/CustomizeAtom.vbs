On Error Resume Next
' Copy icon if needed
Sub CopyIcon(sourceFolderPath, destinationFilePath)
    ' If the icon file not exist...
    If Not ScriptingFileSystemObject.FileExists(destinationFilePath) Then
    	' The icon path in source folder.
    	sourceIconFilePath = ScriptingFileSystemObject.BuildPath(sourceFolderPath, ScriptingFileSystemObject.GetFileName(destinationFilePath))
    	' If the icon is stored in source path, then copy to the folder.
    	If ScriptingFileSystemObject.FileExists(sourceIconFilePath) Then
    		ScriptingFileSystemObject.CopyFile sourceIconFilePath, destinationFilePath, false
    	End If
    End If
End Sub
' Set the icon to shortcut
Sub SetShortcutIcon(shortcut, iconPath)
    ' If current icon of the shortcut is not the specified, then set the icon path
    If shortcut.IconLocation <> iconPath And shortcut.IconLocation <> iconPath & ",0" Then
        shortcut.IconLocation = iconPath
        shortcut.Save
    End If
End Sub
Sub EditAtomWindow(atomAppPath)
    Set WinMgmts = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    For Each atomProcess In WinMgmts.ExecQuery("Select * from Win32_Process Where Name = 'atom.exe'")
        atomProcess.Terminate()
    Next
    ' Get atom-window.js file path.
    atomWindowFilePath = atomAppPath & "\src\main-process\atom-window.js"
    ' Open the file for reading.
    Set AtomWindowFile = ScriptingFileSystemObject.OpenTextFile(atomWindowFilePath, 1)
    ' Split the file at the new line character. *Use the Line Feed character (Char(10)).
    lines = Split(AtomWindowFile.ReadAll, Chr(10))
    ' Close the file.
    AtomWindowFile.Close
    ' Set loop flags
    modified = False
    inOptions = False
    ' Open the file for writing.
    Set AtomWindowFile = ScriptingFileSystemObject.OpenTextFile(atomWindowFilePath, 2, true)
    Set RegExp = CreateObject("VBScript.RegExp")
    RegExp.Pattern = "^[\t ]*options[\t ]*="
    ' Loop through the lines looking for lines to keep.
    For line = LBound(lines) to UBound(lines)
        AtomWindowFile.WriteLine(lines(line))
        If Not modified Then
            If Not inOptions Then
                inOptions = RegExp.Test(lines(line))
            Else
                regExp.Pattern = "title: 'Atom',"
                If regExp.Test(lines(line)) Then
                    AtomWindowFile.WriteLine(regExp.Replace(lines(line), "frame: false,"))
                    modified = true
                End If
            End If
        End If
    Next
    'Close the file.
    AtomWindowFile.Close
    Set AtomWindowFile = Nothing
End Sub
' Run UAC if necessary.
If WScript.Arguments.length = 0 Then
	CreateObject("Shell.Application").ShellExecute "WScript.exe", """" & WScript.ScriptFullName & """ UAC", "", "RunAs", 1
	WScript.Quit
End If
Set WScriptShell = WScript.CreateObject ("WScript.Shell")
' The icons folder
customIconsFolderPath = WScriptShell.ExpandEnvironmentStrings("%LocalAppData%") & "\atom\"
' The custom icon path.
customIconPath = customIconsFolderPath & "AtomMaterial.ico"
' The custom file icon path.
customFileIconPath = customIconsFolderPath & "AtomFile.ico"
Set ScriptingFileSystemObject = CreateObject("Scripting.FileSystemObject")
iconsFolderPath = ScriptingFileSystemObject.GetAbsolutePathName(ScriptingFileSystemObject.BuildPath(ScriptingFileSystemObject.GetParentFolderName(ScriptingFileSystemObject.GetFile(Wscript.ScriptFullName)), "..\Icons"))
' Copy custom icon if needed
CopyIcon iconsFolderPath, customIconPath
' Copy custom file icon if needed
CopyIcon iconsFolderPath, customFileIconPath
' Gets the Atom shortcut path.
Set AtomShortcut = WScriptShell.CreateShortcut(WScriptShell.ExpandEnvironmentStrings("%AppData%") & "\Microsoft\Windows\Start Menu\Programs\GitHub, Inc\Atom.lnk")
' If the custom icon exists set for application and menus
If ScriptingFileSystemObject.FileExists(customIconPath) Then
	WScriptShell.RegWrite "HKCR\*\OpenWithList\atom.exe\", Nothing
	WScriptShell.RegWrite "HKCR\*\shell\Atom\Icon", customIconPath, "REG_SZ"
	WScriptShell.RegWrite "HKCR\Applications\atom.exe\DefaultIcon\", customFileIconPath, "REG_SZ"
	WScriptShell.RegWrite "HKCR\Applications\atom.exe\shell\open\Icon", customIconPath, "REG_SZ"
	WScriptShell.RegWrite "HKCR\Directory\Background\shell\Atom", customIconPath, "REG_SZ"
	WScriptShell.RegWrite "HKCR\Directory\shell\Atom\Icon", customIconPath, "REG_SZ"
	WScriptShell.RegWrite "HKCR\*\shell\Atom\Icon", customIconPath, "REG_SZ"
    SetShortcutIcon AtomShortcut, customIconPath
    SetShortcutIcon WScriptShell.CreateShortcut(WScriptShell.ExpandEnvironmentStrings("%AppData%") & "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Atom.lnk"), customIconPath
End If
' Get asar path.
appAsarPath = AtomShortcut.WorkingDirectory & "\resources\app.asar"
If ScriptingFileSystemObject.FolderExists(appAsarPath) Then
    EditAtomWindow(appAsarPath)
Else
    ' Get temporary folder.
    temporaryFolder = ScriptingFileSystemObject.GetSpecialFolder(2) & "\" & ScriptingFileSystemObject.GetTempName()
    ' Create temporary folder.
    ScriptingFileSystemObject.CreateFolder temporaryFolder
    ' Extract Atom resources.
    WScriptShell.Run "asar e " & appAsarPath & " " & temporaryFolder, 0, true
    EditAtomWindow(temporaryFolder)
    ' Compress Atom resources.
    WScriptShell.Run "asar p " & temporaryFolder & " " & appAsarPath, 0, true
    ' Run Atom.
    WScriptShell.Run """" & AtomShortcut.WorkingDirectory & "\atom.exe"""
    ' Delete temporary folder.
    ScriptingFileSystemObject.DeleteFolder temporaryFolder, true
End If
