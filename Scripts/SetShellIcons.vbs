On Error Resume Next
' Build Function BuildPath(path, subPath)
    BuildPath = ScriptingFileSystemObject.BuildPath(path, subPath)
End Function
Function FileExists(filePath)
    FileExists = ScriptingFileSystemObject.FileExists(filePath)
End Function
Function FolderExists(folderPath)
    FolderExists = ScriptingFileSystemObject.FolderExists(folderPath)
End Function
Set ScriptingFileSystemObject = CreateObject("Scripting.FileSystemObject")
iconsFolderPath = ScriptingFileSystemObject.GetAbsolutePathName(BuildPath(ScriptingFileSystemObject.GetParentFolderName(ScriptingFileSystemObject.GetFile(Wscript.ScriptFullName)), "..\Icons"))
If FolderExists(iconsFolderPath) Then
    updateCache = False
	Set WScriptShell = CreateObject("WScript.Shell")
    ' Set bash icon
    const BashIconFileName = "Bash.ico"
    bashIconFilePath = BuildPath(iconsFolderPath, BashIconFileName)
    If FileExists(bashIconFilePath) Then
        destinationBashIconFileNameFolderPath = BuildPath(WScriptShell.ExpandEnvironmentStrings("%LocalAppData%"), "lxss")
        If FolderExists(destinationBashIconFileNameFolderPath) Then
            ScriptingFileSystemObject.CopyFile bashIconFilePath, BuildPath(destinationBashIconFileNameFolderPath, BashIconFileName)
            WScriptShell.RegWrite "HKCU\Software\Classes\Directory\shell\Bash\", "Bash", "REG_SZ"
            WScriptShell.RegWrite "HKCU\Software\Classes\Directory\shell\Bash\Icon", BuildPath("%LocalAppData%\lxss", BashIconFileName), "REG_EXPAND_SZ"
            WScriptShell.RegWrite "HKCU\Software\Classes\Directory\shell\Bash\NeverDefault", "", "REG_SZ"
            WScriptShell.RegWrite "HKCU\Software\Classes\Directory\shell\Bash\command\", "bash.exe", "REG_SZ"
            updateCache = True
        End If
    End If
    ' Update Windows icon cache if needed
    If updateCache Then
        WScriptShell.Run "ie4uinit -show", 0 , True
    End If
End If