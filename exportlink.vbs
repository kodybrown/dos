On Error Goto 0

'
' Exports/imports the properties of the specified link (shortcut) including the
' target, arguments, directory, icon, description, hotkey, and windowstyle.
'
' Copyright (C) 2013-2014 Kody Brown (@wasatchwizard)
' Released under the MIT License.
'
' USAGE:
'   exportlink.vbs [--export] "input.lnk" "output.txt"
'   exportlink.vbs --import "input.txt" "output.lnk" "original-shortcut.lnk"
'

' Objects
Set wso = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set args = WScript.Arguments

' Constants
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0
Const WindowNormal = 1, WindowMinimized = 2, WindowMaximized = 3

' Options
Dim OptVerbose : OptVerbose = False
Dim OptUpdateLink : OptUpdateLink = False
Dim OptOverwriteLink : OptOverwriteLink = False

' Settings
Dim File1 : File1 = ""
Dim File2 : File2 = ""

' Get the command-line parameters..
If args.Count > 0 Then
    For i = 0 to args.Count - 1
        a = args(i)
        If Left(a, 1) = "-" Or Left(a, 1) = "/" Then
            ' OPTIONS..
            Do
                a = Right(a, Len(a) - 1)
            Loop While Left(a, 1) = "-" Or Left(a, 1) = "/"

            If StrComp(a, "verbose", vbTextCompare) = 0 Or StrComp(a, "v", vbTextCompare) = 0 Then
                OptVerbose = True
            ElseIf StrComp(a, "import", vbTextCompare) = 0 Or StrComp(a, "update", vbTextCompare) = 0 Then
                OptUpdateLink = True
            ElseIf StrComp(a, "overwrite", vbTextCompare) = 0 Or StrComp(a, "replace", vbTextCompare) = 0 Then
                OptOverwriteLink = True
            ElseIf StrComp(a, "export", vbTextCompare) = 0 Then
                OptUpdateLink = False
            Else
                WScript.Echo "Unknown option: " & args(i)
            End If
        Else
            If Len(File1) = 0 Then
                File1 = a
            ElseIf Len(File2) = 0 Then
                File2 = a
            Else
                WScript.Echo "Unknown argument: " & args(i)
            End If
        End If
    Next
End If

If OptUpdateLink Or OptOverwriteLink Then
    If Len(File1) = 0 Then
        WScript.Echo "Missing text-file (first argument). Must be a text file (*.txt)."
        WScript.Quit(21)
    ElseIf Len(File2) = 0 Then
        WScript.Echo "Missing shortcut-file (second argument). Must be a shortcut file (*.lnk)."
        WScript.Quit(22)
    End If

    UpdateLink File1, File2
Else
    If Len(File1) = 0 Then
        WScript.Echo "Missing shortcut-file (first argument). Must be a shortcut file (*.lnk)."
        WScript.Quit(31)
    ElseIf Len(File2) = 0 Then
        WScript.Echo "Missing text-file (second argument). Must be a text file (*.txt)."
        WScript.Quit(32)
    End If

    ExportLink File1, File2
End If

If OptVerbose Then
    WScript.Echo "finished."
End If

Set wso = Nothing
Set fso = Nothing

WScript.Quit(0)


'--------------------------------------------------------------------
' Methods
'--------------------------------------------------------------------

Sub UpdateLink( textFile, shortcutFile )
    Dim FileReader, link
    Dim l, Description
    Dim AR, AttrName, AttrValue
    Dim OriginalShortcut

    On Error Resume Next
    Set FileReader = fso.OpenTextFile(textFile, ForReading)
    On Error Goto 0
    If Err.Number <> 0 Then
        WScript.Echo "Could not open text file: " & textFile & vbCrLf & vbCrLf & Err.Description
        WScript.Quit(32)
    End If

    ' WSO requires that the shortcut file it opens/edits/creates
    ' ends with '.lnk' or '.url'.
    If LCase(Right(shortcutFile, 4)) = ".lnk" Then
        OriginalShortcut = shortcutFile
    Else
        OriginalShortcut = shortcutFile & ".lnk"
    End If

    If OptOverwriteLink Then
        ' We are overwriting whatever might already be in the shortcut file..
        If fso.FileExists(OriginalShortcut) Then
            fso.DeleteFile OriginalShortcut
        End If
    End If

    On Error Resume Next
    Set link = wso.CreateShortcut(shortcutFile)
    On Error Goto 0
    If Err.Number <> 0 Then
        WScript.Echo "Could not open shortcut file." & vbCrLf & vbCrLf & Err.Description
        WScript.Quit(10)
    End If

    Do While FileReader.AtEndOfStream <> True
        l = FileReader.ReadLine

        If InStr(1, l, "=") > 0 Then
            AR = Split(l, "=")
            AttrName = Trim(AR(0))
            AttrValue = Trim(AR(1))

            If InStr(1, AttrValue, "<changes will be ignored>") > 0 Then
                ' This indicates an error occurred while
                ' reading the data.. So, DON'T save it back!
                Continue
            End If

            If AttrName = "TargetPath" Then
' WScript.Echo AttrValue
                link.TargetPath = AttrValue
            ElseIf AttrName = "Arguments" Then
                link.Arguments = AttrValue
            ElseIf AttrName = "WorkingDirectory" Then
                link.WorkingDirectory = AttrValue
            ElseIf AttrName = "IconLocation" Then
                link.IconLocation = AttrValue
            ElseIf AttrName = "Description" Then
                link.Description = AttrValue
            ElseIf AttrName = "Hotkey" Then
                link.Hotkey = AttrValue
            ElseIf AttrName = "WindowStyle" Then
' WScript.Echo AttrValue
                If Len(AttrValue) > 0 Then
                    link.WindowStyle = AttrValue
                End If
            End If
        End If
    Loop

    FileReader.Close

    On Error Resume Next
    link.Save
    On Error Goto 0
    If Err.Number <> 0 Then
        WScript.Echo "An error occurred while saving shortcut." & vbCrLf & vbCrLf & Err.Description
    End If
    Set link = Nothing

    If OriginalShortcut <> shortcutFile Then
        fso.DeleteFile OriginalShortcut
        fso.MoveFile shortcutFile, OriginalShortcut
    End if
End Sub

Sub ExportLink( shortcutFile, textFile )
    Dim link, FileWriter
    Dim Description

    On Error Resume Next
    Set link = wso.CreateShortcut(shortcutFile)
    If Err.Number <> 0 Then
        WScript.Echo "Could not open shortcut file." & vbCrLf & vbCrLf & Err.Description
        WScript.Quit(10)
    End If
    On Error Goto 0

    Set FileWriter = fso.CreateTextFile(textFile)

    FileWriter.WriteLine "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    FileWriter.WriteLine "SOURCE: " & fso.GetFileName(shortcutFile)
    FileWriter.WriteLine "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    FileWriter.WriteLine "TargetPath=" & link.TargetPath
    FileWriter.WriteLine "Arguments=" & link.Arguments
    FileWriter.WriteLine "WorkingDirectory=" & link.WorkingDirectory
    FileWriter.WriteLine "IconLocation=" & link.IconLocation

    On Error Resume Next
    Description = link.Description
    On Error Goto 0
    If Err.Number = 0 Then
        FileWriter.WriteLine "Description=" & Description
    Else
        FileWriter.WriteLine "Description=<error occurred> <changes will be ignored>"
    End If

    FileWriter.WriteLine "Hotkey=" & link.Hotkey ' & " <changes will be ignored>"
    FileWriter.WriteLine "WindowStyle=" & link.WindowStyle

    FileWriter.WriteLine ""
    FileWriter.Close

    Set link = Nothing
End Sub
