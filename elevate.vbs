'
' Elevation PowerToys for Windows Vista v1.1 (04/29/2008)
' http://technet.microsoft.com/en-us/magazine/2008.06.elevation.aspx
'
' REQUIRES:
'   elevate.vbs
'
' To provide a command line method of launching applications that
' prompt for elevation (Run as Administrator) on Windows Vista.
'
' Usage:
'   DO NOT CALL DIRECTLY!
'   Only call this from 'elevate.cmd'.
'

Set objShell = CreateObject("Shell.Application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set objWshProcessEnv = objWshShell.Environment("PROCESS")

' Get raw command line arguments and first argument from Elevate.cmd passed
' in through environment variables.
strCommandLine = objWshProcessEnv("ELEVATE_CMDLINE")
strApplication = objWshProcessEnv("ELEVATE_APP")
strArguments = Right(strCommandLine, (Len(strCommandLine) - Len(strApplication)))

If (WScript.Arguments.Count >= 1) Then
    strFlag = WScript.Arguments(0)
    If strFlag = "" Or strFlag = "/?" Or strFlag = "/help" Or strFlag = "--help" Or strFlag = "-help" Then
        DisplayUsage
        WScript.Quit(0)
    Else
        objShell.ShellExecute strApplication, strArguments, "", "runas"
    End If
Else
    DisplayUsage
    WScript.Quit
End If

Sub DisplayUsage
    WScript.Echo "elevate.vbs & elevate.cmd" & vbCrLf _
        & vbCrLf _
        & "Launches applications that prompt for elevation (i.e. Run as Administrator)" & vbCrLf _
        & "from the command line, a script, or the Run box." & vbCrLf _
        & vbCrLf _
        & "Usage:   " & vbCrLf _
        & "    elevate application <arguments>" & vbCrLf _
        & vbCrLf _
        & "Sample usage:" & vbCrLf _
        & "    elevate notepad ""C:\Windows\win.ini""" & vbCrLf _
        & "    elevate cmd /k cd ""C:\Program Files""" & vbCrLf _
        & "    elevate powershell -NoExit -Command Set-Location 'C:\Windows'" & vbCrLf _
        & vbCrLf _
        & "Usage with scripts: When using the elevate command with scripts such as" & vbCrLf _
        & "Windows Script Host or Windows PowerShell scripts, you should specify" & vbCrLf _
        & "the script host executable (i.e., wscript, cscript, powershell) as the " & vbCrLf _
        & "application." & vbCrLf _
        & vbCrLf _
        & "Sample usage with scripts:" & vbCrLf _
        & "    elevate wscript ""C:\windows\system32\slmgr.vbs"" -dli" & vbCrLf _
        & "    elevate powershell -NoExit -Command & 'C:\Temp\Test.ps1'" & vbCrLf
End Sub
