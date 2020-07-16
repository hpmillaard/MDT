Dim FSO : Set FSO = CreateObject("Scripting.FileSystemObject")
Dim oShell : Set oShell = CreateObject("Shell.Application")

CurrentPath = FSO.GetParentFolderName(Wscript.ScriptFullName)

oShell.ShellExecute "powershell", "-executionpolicy bypass -file """ & CurrentPath & "\MDT Apps.ps1"" uac", "", "runas", 1
wscript.quit