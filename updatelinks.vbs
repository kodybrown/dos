On Error Goto 0

'
' Modifies specified link (shortcut) paths including the target, directory, icon,
' and description (if applicable).
'
' Copyright (C) 2013-2014 Kody Brown (@wasatchwizard)
'
' USAGE:
'   editlinks.vbs [/s|--recursive] [--path C:\somewhere] "replace" "with" ["replace" "with"] ["replace" "with"] ...
'
' NOTE:
'   When retrieving the TargetPath from a shortcut, it will (sometimes?)
'   expand any environment variables already in it. This will cause the number
'   of changed files to seem quite large (and never go down).
'

Set wso = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set args = WScript.Arguments

' Settings
Dim RootFolder : RootFolder = fso.GetAbsolutePathName(".")
Dim Recursive : Recursive = False
Dim Count
Dim ChangeFrom : ChangeFrom = Array()
Dim ChangeTo : ChangeTo = Array()
Dim ReplaceStr : ReplaceStr = ""
Dim useCustomValues : useCustomValues = False

' Get the command-line parameters..
If args.Count > 0 Then
    Dim NextArgIsRootFolder : NextArgIsRootFolder = False  ' When True, indicates the next argument will be used as 'RootPath'.

    For i = 0 to args.Count - 1
        a = args(i)
        If Left(a, 1) = "-" Or Left(a, 1) = "/" Then
            ' OPTIONS..
            Do
                a = Right(a, Len(a) - 1)
            Loop While Left(a, 1) = "-" Or Left(a, 1) = "/"

            If StrComp(a, "recursive", vbTextCompare) = 0 Or StrComp(a, "s", vbTextCompare) = 0 Then
                Recursive = True
            ElseIf StrComp(a, "path", vbTextCompare) = 0 Or StrComp(a, "p", vbTextCompare) = 0 Then
                NextArgIsRootFolder = True
            Else
                WScript.Echo "Unknown option: " & args(i)
            End If
        Else
            If NextArgIsRootFolder Then
                ' Set the root folder.
                RootFolder = a
                NextArgIsRootFolder = False
            ElseIf Len(ReplaceStr) = 0 Then
                ' Set the ReplaceStr (the string that gets replaced)..
                ' This will also indicate that the next argument will be the ReplaceWith string.
                ReplaceStr = a
            Else
                ReDim Preserve ChangeFrom(UBound(ChangeFrom) + 1)
                ReDim Preserve ChangeTo(UBound(ChangeTo) + 1)
                ChangeFrom(UBound(ChangeFrom)) = ReplaceStr
                ChangeTo(UBound(ChangeTo)) = a  ' The 'ReplaceWith' string.
                ReplaceStr = ""
                useCustomValues = True
            End If
        End If
    Next
End If

If Not useCustomValues Then
    ' TODO: YOU REALLY NEED TO CHANGE THESE DEFAULTS TO YOUR OWN!!
    ' The items are a one-to-one match between the two arrays.. as in,
    ' element 1 of ChangeFrom coincides with element 1 of ChangeTo.
    ChangeFrom = Array("Dropbox\", "c:\bin", "%SystemDrive%\bin", "c:\root", "%SystemDrive%\root", "c:\users\kody\root", "%userprofile%\root", "%profile%\root", "%UserProfile%", "C:\Users\Kody", "%HOMEDRIVE%%HOMEPATH%", "C:\Users\i92102", "%bin%\Apps\", "C:\bin\Apps\")
    ChangeTo = Array("", "%bin%", "%bin%", "%bin%", "%bin%", "%bin%", "%bin%", "%bin%", "%Profile%", "%Profile%", "%Profile%", "%Profile%", "%bin%\apps\", "%bin%\apps\")
End If


Count = 0

ModifyLinks RootFolder

' WScript.Echo Count & " shortcuts changed."
WScript.Echo "finished."

Set wso = Nothing
Set fso = Nothing


'--------------------------------------------------------------------
' Methods
'--------------------------------------------------------------------

Sub ModifyLinks( foldername )
    Dim file
    Dim folder
    Dim TargetPath, Arguments, WorkingDirectory, IconLocation, Description
    Dim link
    Dim linkChanged

    For Each file in fso.GetFolder(foldername).Files
        If StrComp(Right(file.name, 4), ".lnk", vbTextCompare) = 0 Then
            Set link = wso.CreateShortcut(file)
            ' WScript.Echo "link.TargetPath=" & link.TargetPath & vbCrLf & "link.WorkingDirectory=" & link.WorkingDirectory
            linkChanged = False

            TargetPath = link.TargetPath
            If TargetPath <> "" Then
                For i = 0 To UBound(ChangeFrom)
                    If InStr(1, TargetPath, ChangeFrom(i), vbTextCompare) > 0 Then
                        linkChanged = True
                        TargetPath = Replace(TargetPath, ChangeFrom(i), ChangeTo(i), 1, -1, vbTextCompare)
                        link.TargetPath = TargetPath
                    End If
                Next
            End If

            Arguments = link.Arguments
            If Arguments <> "" Then
                For i = 0 To UBound(ChangeFrom)
                    If InStr(1, Arguments, ChangeFrom(i), vbTextCompare) > 0 Then
                        linkChanged = True
                        Arguments = Replace(Arguments, ChangeFrom(i), ChangeTo(i), 1, -1, vbTextCompare)
                        link.Arguments = Arguments
                    End If
                Next
            End If

            WorkingDirectory = link.WorkingDirectory
            If WorkingDirectory <> "" Then
                For i = 0 To UBound(ChangeFrom)
                    If InStr(1, WorkingDirectory, ChangeFrom(i), vbTextCompare) > 0 Then
                        linkChanged = True
                        WorkingDirectory = Replace(WorkingDirectory, CStr(ChangeFrom(i)), CStr(ChangeTo(i)), 1, -1, vbTextCompare)
                        link.WorkingDirectory = WorkingDirectory
                    End If
                Next
            End If

            IconLocation = link.IconLocation
            If IconLocation <> "" Then
                For i = 0 To UBound(ChangeFrom)
                    If InStr(1, IconLocation, ChangeFrom(i), vbTextCompare) > 0 Then
                        linkChanged = True
                        IconLocation = Replace(IconLocation, CStr(ChangeFrom(i)), CStr(ChangeTo(i)), 1, -1, vbTextCompare)
                        link.IconLocation = IconLocation
                    End If
                Next
            End If

            On Error Resume Next
            Description = link.Description
            On Error Goto 0
            If Err.Number = 0 Then
                If Description <> "" Then
                    For i = 0 To UBound(ChangeFrom)
                        If InStr(1, Description, ChangeFrom(i), vbTextCompare) > 0 Then
                            linkChanged = True
                            Description = Replace(Description, CStr(ChangeFrom(i)), CStr(ChangeTo(i)), 1, -1, vbTextCompare)
                            link.Description = Description
                        End If
                    Next
                End If

                If InStr(Description, "%") > 0 Then
                    Description = wso.ExpandEnvironmentStrings(Description)
                    If StrComp(Description, link.TargetPath, vbTextCompare) = 0 Then
                        ' WScript.Echo link.Description & "-" & link.TargetPath
                        linkChanged = True
                        link.Description = ""
                    End If
                End If
            End If

            If linkChanged Then
                Count = Count + 1
                On Error Resume Next
                link.Save
                On Error Goto 0
                If Err.Number = 0 Then
                    ' WScript.Echo "An error occurred while saving: " & file
                End If
                Set link = Nothing
            End If
        End If
    Next

    If Recursive Then
        For Each folder in fso.GetFolder(foldername).Subfolders
            Call ModifyLinks(folder.path)
        Next
    End If
End Sub
