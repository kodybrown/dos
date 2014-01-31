@echo off

if not defined __DOSKEY_HISTORYFILE set __DOSKEY_HISTORYFILE=%Profile%\.doskey_history

set doskey=C:\Windows\System32\doskey.exe
set sort=%tools%\mingw\msys\1.0\bin\sort.exe
set __verbose=
set __backuponsave=true
set __sessiononly=

:init
    call :setdatevars
    call :settimevars

:main
    if "%~1"=="/?" call :usage "%~2" && exit /B 0
    if "%~1"=="-help" call :usage "%~2" && exit /B 0
    if "%~1"=="--help" call :usage "%~2" && exit /B 0

    if "%~1"=="-verbose" set __verbose=true && shift && goto :main
    if "%~1"=="--verbose" set __verbose=true && shift && goto :main

    if "%~1"=="-edit" call :edithistory && exit /B 0
    if "%~1"=="--edit" call :edithistory && exit /B 0

    if "%~1"=="-save" call :savehistory "%~2" && exit /B 0
    if "%~1"=="--save" call :savehistory "%~2" && exit /B 0

    if "%~1"=="-backup" call :backuphistory "%~2" && exit /B 0
    if "%~1"=="--backup" call :backuphistory "%~2" && exit /B 0

    rem if "%~1"=="-del" call :deletehistory "%~2" && exit /B 0
    rem if "%~1"=="--del" call :deletehistory "%~2" && exit /B 0
    rem if "%~1"=="-delete" call :deletehistory "%~2" && exit /B 0
    rem if "%~1"=="--delete" call :deletehistory "%~2" && exit /B 0

    if "%~1"=="-ss" set __sessiononly=true && shift && goto :main
    if "%~1"=="-sess" set __sessiononly=true && shift && goto :main
    if "%~1"=="-session" set __sessiononly=true && shift && goto :main
    if "%~1"=="--ss" set __sessiononly=true && shift && goto :main
    if "%~1"=="--sess" set __sessiononly=true && shift && goto :main
    if "%~1"=="--session" set __sessiononly=true && shift && goto :main

    if "%~1"=="-load" call :loadhistory && exit /B 0
    if "%~1"=="--load" call :loadhistory && exit /B 0

    call :listhistory "%~1"
    exit /B 0

:usage
    echo List and search the command-line history using a saved history file.
    echo Created 2012 @wasatchwizard.
    echo.
    echo USAGE: history.bat [options]
    echo.
    echo   no-args       Lists all history.
    echo.
    echo   --edit        Opens the `%%__DOSKEY_MACROFILE%%` in Notepad2.
    echo                 Be sure to `alias --load` changes when finished.
    echo.
    echo   --save        Saves the current history to `%%__DOSKEY_HISTORYFILE%%`,
    echo                 only if the `doskey_history_loaded` envar is present.
    if defined doskey_history_loaded echo                 Currently the `doskey_history_loaded` envar is present.
    if not defined doskey_history_loaded echo                 Currently the `doskey_history_loaded` envar is not present.
    echo.
    echo   --backup      Saves current macros, then creates a backup copy of it, using
    echo                 the current date/time stamp in the file name.
    echo.
    echo   --load        Updates the current set of commands in the current processes
    echo                 history, with those from the `%%__DOSKEY_HISTORYFILE%%` file.
    echo.
    echo USAGE: history.bat query
    echo.
    echo                 Lists all commands executed, that contain `query` in it.
    echo.
    echo The saved history file is located at:
    echo   `%__DOSKEY_HISTORYFILE%`
    goto :eof

:listhistory
    if defined __sessiononly call :listsessionhistory "%~1" && goto :eof

    if "%~1"=="" call cat "%__DOSKEY_HISTORYFILE%"
    if not "%~1"=="" call cat "%__DOSKEY_HISTORYFILE%" | grep -i "%~1"
    goto :eof

    :listsessionhistory
        if "%~1"=="" echo 1 && doskey /history
        if not "%~1"=="" doskey /history |grep -i "%~1"
        goto :eof

:edithistory
    where "Notepad2" >NUL
    if %errorlevel% EQU 0 start "notepad2" /WAIT "notepad2.exe" "%__DOSKEY_HISTORYFILE%"
    if %errorlevel% NEQ 0 start "notepad" /WAIT "notepad.exe" "%__DOSKEY_HISTORYFILE%"
    goto :eof

:loadhistory
    set doskey_history_loaded=true
    goto :eof

:backuphistory
    if not defined doskey_history_loaded (
        echo HISTORY has not been loaded.
        echo I cannot backup.
        goto :eof
    )

    rem if not "%~1"=="no-save" (
    rem     call :savehistory no-backup
    rem )

    set BackupFile=%__DOSKEY_HISTORYFILE%(%yy%-%mm%-%dd%-%hh%-%nn%-%ss%).backup
    copy /Y "%__DOSKEY_HISTORYFILE%" "%BackupFile%" >NUL 2>&1

    if not "%~1"=="no-save" (
        if defined __verbose echo history file was BACKED-UP.
    )

    goto :eof

:savehistory
    if not defined doskey_history_loaded (
        echo HISTORY has not been loaded.
        echo I cannot save.
        goto :eof
    )

    rem Output the current session's command-line history to a temporary file.
    set tmp=%TEMP%\history.%yy%-%mm%-%dd%-%hh%-%nn%-%ss%-%ii%.tmp

    rem First, copy the current history file to the tmp file.
    call copy /Y "%__DOSKEY_HISTORYFILE%" "%tmp%" >NUL

    rem Append, the current session's history to the tmp file.
    call "%doskey%" /history >>"%tmp%"
    if %errorlevel% NEQ 0 (
        echo HISTORY failed to export.
        echo history file was left UNCHANGED.
        if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1
        goto :eof
    )

    rem Sort and remove the duplicate lines.
    rem Outputting the results to the history file.
    call "%sort%" --ignore-case --unique --output="%__DOSKEY_HISTORYFILE%" "%tmp%"

    if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1

    rem call :loadhistory no-output
    if defined __verbose echo HISTORY saved.

    rem if "%__backuponsave%"=="true" (
    rem     if not "%~1"=="no-backup" (
    rem         call :backuphistory no-save
    rem     )
    rem )

    goto :eof

:deletehistory
    call "%doskey%" %~1=
    if %errorlevel% EQU 0 (
        if defined verbose echo DELETED command from history.
    ) else (
        echo FAILED to delete command from history!?
    )
    goto :eof

:setdatevars
    rem sets global variables to the current date (mm, dd, yy) -- `yy` actually outputs `yyyy`
    for /f "tokens=1-3 delims=/.- " %%A in ("%date:* =%") do (
        set mm=%%A
        set dd=%%B
        set yy=%%C
        goto :eof
    )
    goto :eof

:settimevars
    :: sets global variables to the current time (hh, nn, ss, ii)
    for /f "tokens=1-4 delims=:. " %%A in ("%time: =0%") do (
        set hh=%%A
        set nn=%%B
        set ss=%%C
        set ii=%%D
    )
    goto :eof

:incrementcount
    set /a count+=1
    goto :eof
