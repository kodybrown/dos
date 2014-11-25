@echo off

if not defined __HISTORY_FILE set __HISTORY_FILE=%Profile%\.dos_history
set __HISTORY_FILE_BACKUP=%Profile%\Settings\AutoBackup\dos_history

:init
    set __doskey=C:\Windows\System32\doskey.exe
    rem set __sort=%tools%\mingw\msys\1.0\bin\sort.exe
    set __sort=%msys%\sort.exe
    set __cat=%bin%\cat.exe
    set __grep=%bin%\grep.exe

    set "__verbose="
    set "__backuponsave=true"
    set "__sessiononly="

    call :setdatevars
    call :settimevars

:main
    if "%~1"=="/?" call :usage "%~2" && exit /B 0
    if "%~1"=="-help" call :usage "%~2" && exit /B 0
    if "%~1"=="--help" call :usage "%~2" && exit /B 0

    if "%~1"=="-verbose" set __verbose=true && shift && goto :main
    if "%~1"=="--verbose" set __verbose=true && shift && goto :main

    if "%~1"=="-edit" call :edithistory && goto :end
    if "%~1"=="--edit" call :edithistory && goto :end

    if "%~1"=="-save" call :savehistory "%~2" && goto :end
    if "%~1"=="--save" call :savehistory "%~2" && goto :end

    if "%~1"=="-backup" call :backuphistory "%~2" && goto :end
    if "%~1"=="--backup" call :backuphistory "%~2" && goto :end

    rem if "%~1"=="-del" call :deletehistory "%~2" && goto :end
    rem if "%~1"=="--del" call :deletehistory "%~2" && goto :end
    rem if "%~1"=="-delete" call :deletehistory "%~2" && goto :end
    rem if "%~1"=="--delete" call :deletehistory "%~2" && goto :end

    if "%~1"=="-ss" set __sessiononly=true && shift && goto :main
    if "%~1"=="-sess" set __sessiononly=true && shift && goto :main
    if "%~1"=="-session" set __sessiononly=true && shift && goto :main
    if "%~1"=="--ss" set __sessiononly=true && shift && goto :main
    if "%~1"=="--sess" set __sessiononly=true && shift && goto :main
    if "%~1"=="--session" set __sessiononly=true && shift && goto :main

    if "%~1"=="-load" call :loadhistory && goto :end
    if "%~1"=="--load" call :loadhistory && goto :end

    call :listhistory "%~1"

:end
    call :deldatevars
    call :deltimevars

    set "__doskey="
    set "__sort="
    set "__cat="
    set "__grep="

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
    echo   --save        Saves the current history to `%%__HISTORY_FILE%%`,
    echo                 only if the `dos_history_loaded` envar is present.
    if defined dos_history_loaded echo                 Currently the `dos_history_loaded` envar is present.
    if not defined dos_history_loaded echo                 Currently the `dos_history_loaded` envar is not present.
    echo.
    echo   --backup      Saves current macros, then creates a backup copy of it, using
    echo                 the current date/time stamp in the file name.
    echo.
    echo   --load        Updates the current set of commands in the current processes
    echo                 history, with those from the `%%__HISTORY_FILE%%` file.
    echo.
    echo USAGE: history.bat query
    echo.
    echo                 Lists all commands executed, that contain `query` in it.
    echo.
    echo The saved history file is located at:
    echo   `%__HISTORY_FILE%`
    goto :eof

:listhistory
    if defined __sessiononly call :listsessionhistory "%~1" && goto :eof

    if "%~1"=="" call "%__cat%" "%__HISTORY_FILE%"
    if not "%~1"=="" call "%__cat%" "%__HISTORY_FILE%" | "%__grep%" -i "%~1"
    goto :eof

    :listsessionhistory
        if "%~1"=="" echo 1 && "%__doskey%" /history
        if not "%~1"=="" "%__doskey%" /history | "%__grep%" -i "%~1"
        goto :eof

:edithistory
    where "Notepad2" >NUL
    if %errorlevel% EQU 0 start "notepad2" /WAIT "notepad2.exe" "%__HISTORY_FILE%"
    if %errorlevel% NEQ 0 start "notepad" /WAIT "notepad.exe" "%__HISTORY_FILE%"
    goto :eof

:loadhistory
    set dos_history_loaded=true
    goto :eof

:backuphistory
    if not defined dos_history_loaded (
        echo HISTORY has not been loaded.
        echo I cannot backup.
        goto :eof
    )

    rem if not "%~1"=="no-save" (
    rem     call :savehistory no-backup
    rem )

    set BackupFile=%__HISTORY_FILE_BACKUP%.%yy%%mm%%dd%-%hh%%nn%%ss%.txt
    copy /Y "%__HISTORY_FILE%" "%BackupFile%" >NUL 2>&1

    if not "%~1"=="no-save" (
        if defined __verbose echo history file was BACKED-UP.
    )

    goto :eof

:savehistory
    if not defined dos_history_loaded (
        echo HISTORY has not been loaded.
        echo I cannot save.
        goto :eof
    )

    rem Output the current session's command-line history to a temporary file.
    set tmp=%TEMP%\history.%yy%-%mm%-%dd%-%hh%-%nn%-%ss%-%ii%.tmp

    rem First, copy the current history file to the tmp file.
    call copy /Y "%__HISTORY_FILE%" "%tmp%" >NUL

    rem Append, the current session's history to the tmp file.
    call "%__doskey%" /history >>"%tmp%"
    if %errorlevel% NEQ 0 (
        echo HISTORY failed to export.
        echo history file was left UNCHANGED.
        if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1
        goto :eof
    )

    rem rem Sort and remove the duplicate lines.
    rem rem Outputting the results to the history file.
    rem call "%__sort%" --ignore-case --unique --output="%__HISTORY_FILE%" "%tmp%"
    call move "%tmp%" "%__HISTORY_FILE%" >NUL 2>&1

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
    call "%__doskey%" %~1=
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

:deldatevars
    rem removes global variables
    set "mm="
    set "dd="
    set "yy="
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

:deltimevars
    rem removes global variables
    set "hh="
    set "nn="
    set "ss="
    set "ii="
    goto :eof

:incrementcount
    set /a count+=1
    goto :eof
