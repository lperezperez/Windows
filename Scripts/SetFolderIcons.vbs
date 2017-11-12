Sub SetFileAttribute(filePath, attribute)
    Set file = ScriptingFileSystemObject.GetFile(filePath)
    If Not file.Attributes And attribute Then
        file.Attributes = file.Attributes + attribute
    End If
End Sub
Sub SetFolderAttribute(folderPath, attribute)
    Set folder = ScriptingFileSystemObject.GetFolder(folderPath)
    If Not folder.Attributes And attribute Then
        folder.Attributes = folder.Attributes + attribute
    End If
End Sub
Sub SetFolderIcon(folderPath, iconPath, infoTip)
    If Not ScriptingFileSystemObject.FolderExists(folderPath) Then
        MsgBox "Folder don't exists:" & vbCrLf & folderPath
        Exit Sub
    End If
    If Not ScriptingFileSystemObject.FileExists(iconPath) Then
        MsgBox "File don't exists:" & vbCrLf & iconPath
        Exit Sub
    End If
    ' Copy icon to folder
    iconFileName = ScriptingFileSystemObject.GetFileName(iconPath)
    destinationIconFilePath = ScriptingFileSystemObject.BuildPath(folderPath, iconFileName)
    If Not ScriptingFileSystemObject.FileExists(destinationIconFilePath) Then
        ScriptingFileSystemObject.CopyFile iconPath, destinationIconFilePath, false
    End If
    ' Set icon file as hidden file
    SetFileAttribute destinationIconFilePath, 2
    ' Create desktop.ini file
    desktopIniFilePath = ScriptingFileSystemObject.BuildPath(folderPath, "desktop.ini")
    If ScriptingFileSystemObject.FileExists(desktopIniFilePath) Then
        ScriptingFileSystemObject.DeleteFile(desktopIniFilePath)
    End If
    Set desktopIni = ScriptingFileSystemObject.CreateTextFile(desktopIniFilePath, True)
    desktopIni.Write "[.ShellClassInfo]" & vbCrLf
    desktopIni.Write "IconResource=.\" & iconFileName & vbCrLf
    desktopIni.Write "InfoTip=" & infoTip
    desktopIni.Close
    ' Set desktop.ini file as hidden file
    SetFileAttribute desktopIniFilePath, 2
    ' Set folder as a system folder
    SetFolderAttribute folderPath, 4
End Sub
Set WScriptShell = WScript.CreateObject ("WScript.Shell")
' Get user folder path
userFolder = WScriptShell.ExpandEnvironmentStrings("%UserProfile%")
Set ScriptingFileSystemObject = CreateObject("Scripting.FileSystemObject")
' Get icons folder path
iconsFolderPath = ScriptingFileSystemObject.BuildPath(ScriptingFileSystemObject.GetParentFolderName(ScriptingFileSystemObject.GetFile(Wscript.ScriptFullName)), "..\Icons")
' Set Source folder icon
SetFolderIcon ScriptingFileSystemObject.BuildPath(userFolder, "Source"), ScriptingFileSystemObject.BuildPath(iconsFolderPath, "Source.ico"), "Contains source code"
' Set Repos folder icon
SetFolderIcon ScriptingFileSystemObject.BuildPath(userFolder, "Source\Repos"), ScriptingFileSystemObject.BuildPath(iconsFolderPath, "Repos.ico"), "Contains source code repositories"