' Run UAC if necessary.
If WScript.Arguments.length = 0 Then
	CreateObject("Shell.Application").ShellExecute "WScript.exe", """" & WScript.ScriptFullName & """ UAC", "", "RunAs", 1
	WScript.Quit
End If
Set ScriptingFileSystemObject = CreateObject("Scripting.FileSystemObject")
' Copy wallpapers to wallpapers default theme folder
For Each file In ScriptingFileSystemObject.GetFolder(ScriptingFileSystemObject.GetAbsolutePathName(ScriptingFileSystemObject.BuildPath(ScriptingFileSystemObject.GetParentFolderName(ScriptingFileSystemObject.GetFile(Wscript.ScriptFullName)), "..\Wallpapers"))).Files
    ScriptingFileSystemObject.CopyFile file.Path, "C:\Windows\Web\Wallpaper\Theme1\"
Next