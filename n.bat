@setlocal
@echo off

rem Opens Notepad2 using the specified argument(s) if provided.
rem Also replaces all '/' characters with '\'.
rem If `hosts` is the first argument, opens the machine's hosts file.
rem Created 2007 @wasatchwizard

:init
    set __file=

:parse
    if "%~1"=="" goto :nofile

    if /i "%~1"=="hosts" (
        echo opening hosts file..
        if exist "%bin%\nircmd.exe" (
            if exist "%bin%\Notepad2.exe" start "nircmd hosts" "%bin%\nircmd.exe" elevate "%bin%\Notepad2.exe" "c:\Windows\System32\drivers\etc\hosts"
            if not exist "%bin%\Notepad2.exe" start "nircmd hosts" "%bin%\nircmd.exe" elevate "Notepad.exe" "c:\Windows\System32\drivers\etc\hosts"
            endlocal && exit /B 0
        )
        set "__file=c:\Windows\System32\drivers\etc\hosts" && shift && goto :main
    )

    set __file=%~1
    shift

:main
    if exist "%bin%\Notepad2.exe" start "notepad" /b "%bin%\Notepad2.exe" "%__file%"
    if not exist "%bin%\Notepad2.exe" start "notepad" /b "Notepad.exe" "%__file%"

    endlocal && exit /B 0

:nofile
    :: No file was specified to be open.
    :: Change to the Desktop so that any File Save As dialogs will default there. (doesn't work for notepad.exe..)
    pushd "%Profile%\Desktop"

    if exist "%bin%\Notepad2.exe" start "notepad2" /b "%bin%\Notepad2.exe"
    if not exist "%bin%\Notepad2.exe" start "notepad" /b "Notepad.exe"

    popd

    endlocal && exit /B 0