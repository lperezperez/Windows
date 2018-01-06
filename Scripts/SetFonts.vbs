Function MatchExtension(filePath, extension)
	MatchExtension = (StrComp(ScriptingFileSystemObject.GetExtensionName(filePath), extension, vbTextCompare) = 0)
End Function
Sub InstallFonts(folder)
	Set folderNameSpace = CreateObject("Shell.Application").Namespace(folder.Path)
	fontsFolderPath = WScriptShell.SpecialFolders("Fonts")
	For Each file In folder.files
		If MatchExtension(file.Path, "TTF") OR MatchExtension(file.Path, "OTF") Then
			If Not ScriptingFileSystemObject.FileExists(ScriptingFileSystemObject.BuildPath(fontsFolderPath, file.Name)) Then
				folderNameSpace.ParseName(file.Name).InvokeVerb("Install")
			End If
		End If
	Next
    For Each subfolder in folder.SubFolders
		InstallFonts subfolder
    Next
End Sub
Set ScriptingFileSystemObject = CreateObject("Scripting.FileSystemObject")
fontsFolderPath = ScriptingFileSystemObject.GetAbsolutePathName(ScriptingFileSystemObject.BuildPath(ScriptingFileSystemObject.GetParentFolderName(ScriptingFileSystemObject.GetFile(Wscript.ScriptFullName)), "..\Fonts"))
If ScriptingFileSystemObject.FolderExists(fontsFolderPath) Then
	Set WScriptShell = CreateObject("WScript.Shell")
	InstallFonts ScriptingFileSystemObject.GetFolder(fontsFolderPath)
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont\01", "Fira Mono", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont\02", "Inconsolata", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Bold (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Bold Italic (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Italic (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Light (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Semibold (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\Segoe UI Symbol (TrueType)", "", "REG_SZ"
	WScriptShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes\Segoe UI", "Fira Sans", "REG_SZ"
End If