@echo off

if not defined __ALIASES_FILE set __ALIASES_FILE=%UserProfile%\.dos_aliases
set __ALIASES_FILE_BACKUP=%UserProfile%\Settings\AutoBackup\dos_aliases

:init
    set __doskey=C:\Windows\System32\doskey.exe
    rem set __sort=%tools%\mingw\msys\1.0\bin\sort.exe
    set __sort=%msys%\sort.exe
    set __find=C:\Windows\System32\find.exe

    set "__verbose="
    set "__backuponsave=true"

    call :setdatevars
    call :settimevars

:main
    if "%~1"=="/?" call :usage "%~2" && exit /B 0
    if /i "%~1"=="-help" call :usage "%~2" && exit /B 0
    if /i "%~1"=="--help" call :usage "%~2" && exit /B 0

    if /i "%~1"=="-verbose" set __verbose=true && shift && goto :main
    if /i "%~1"=="--verbose" set __verbose=true && shift && goto :main

    if /i "%~1"=="-edit" call :editmacros && goto :end
    if /i "%~1"=="--edit" call :editmacros && goto :end

    if /i "%~1"=="-save" call :savemacros && goto :end
    if /i "%~1"=="--save" call :savemacros && goto :end

    if /i "%~1"=="-backup" call :backupmacros && goto :end
    if /i "%~1"=="--backup" call :backupmacros && goto :end

    if /i "%~1"=="-del" call :deletemacro %~2 && goto :end
    if /i "%~1"=="--del" call :deletemacro %~2 && goto :end
    if /i "%~1"=="-delete" call :deletemacro %~2 && goto :end
    if /i "%~1"=="--delete" call :deletemacro %~2 && goto :end

    if /i "%~1"=="-load" call :loadmacros && goto :end
    if /i "%~1"=="--load" call :loadmacros && goto :end

    if "%~1"=="-" call :querymacros "%~2" && goto :end
    if "%~1"=="--" call :querymacros "%~2" && goto :end
    if /i "%~1"=="-q" call :querymacros "%~2" && goto :end
    if /i "%~1"=="-query" call :querymacros "%~2" && goto :end
    if /i "%~1"=="--query" call :querymacros "%~2" && goto :end

    if /i "%~1"=="-all" call :listmacros all && goto :end
    if /i "%~1"=="--all" call :listmacros all && goto :end

    if "%~1"=="" (
        rem List all macros.
        call :listmacros
        goto :end
    ) else (
        rem Create a new macro.
        call "%__doskey%" %*
    )

:end
    call :deldatevars
    call :deltimevars

    set "__doskey="
    set "__find="
    set "__sort="

    exit /B 0

:usage
    echo Provides an emulation layer to enable using the DOSKEY command like the
    echo Linux/UNIX `alias` command.
    echo Created 2012 @wasatchwizard.
    echo.
    echo USAGE: alias.bat [options]
    echo.
    echo   no-args       Lists all macros.
    echo.
    echo   one-arg       Lists all macros that contain one-arg.
    echo   --query x     Lists all macros that contain x.
    echo.
    echo   --all         Lists all macros for all executables which have macros.
    echo.
    echo   --edit        Opens the `%%__ALIASES_FILE%%` in Notepad2 (or Notepad).
    echo                 Be sure to `alias --load` changes when finished.
    echo.
    echo   --save        Saves the current macros to `%%__ALIASES_FILE%%`,
    echo                 only if the `dos_aliases_loaded` envar is present.
    if defined dos_aliases_loaded echo                 Currently, the `dos_aliases_loaded` envar IS present.
    if not defined dos_aliases_loaded echo                 Currently, the `dos_aliases_loaded` envar is NOT present.
    echo.
    echo   --backup      Saves current macros, then creates a backup of it, appending
    echo                 the current date/time stamp in the file name.
    echo.
    echo   --load        Updates the current set of macros in the current environment /
    echo                 process, with those from the `%%__ALIASES_FILE%%` file.
    echo.
    echo                 NOTE: Any new macros created in the current session will be lost,
    echo                 unless you save them first; however saving current macros will
    echo                 overwrite the macro file, which would defeat the purpose of load.
    echo.
    echo   --del macro   Deletes the macro named `macro`.
    echo                 You can also use `alias macro=` to delete the macro.
    echo.
    echo USAGE: alias.bat macroname=macro definition
    echo.
    echo  The following are some special codes in Doskey macro definitions:
    echo.
    echo   $T     Command separator. Allows multiple commands in a macro.
    echo   $1-$9  Batch parameters. Equivalent to %%1-%%9 in batch programs.
    echo   $*     Symbol replaced by everything following macro name on command line.
    echo.
    echo  Type `doskey /?` for all the details.
    echo.
    echo The macro file (if saved/exists) is located at:
    echo   `%__ALIASES_FILE%`
    goto :eof

:listmacros
    if "%~1"=="" call "%__doskey%" /macros
    if "%~1"=="all" call "%__doskey%" /macros:all
    goto :eof

:querymacros
    if "%~1"=="" call :listmacros && goto :eof
    call "%__doskey%" /macros |"%__find%" /i "%~1"
    goto :eof

:editmacros
    where "Notepad2" >NUL
    if %errorlevel% EQU 0 start "notepad2" /WAIT "notepad2.exe" "%__ALIASES_FILE%"
    if %errorlevel% NEQ 0 start "notepad" /WAIT "notepad.exe" "%__ALIASES_FILE%"
    goto :eof

:loadmacros
    call "%__doskey%" /macrofile=%__ALIASES_FILE%
    if %errorlevel% EQU 0 call :loadmacros_success %1
    if %errorlevel% NEQ 0 call :loadmacros_failed %1
    goto :eof

    :loadmacros_success
        set dos_aliases_loaded=true
        if defined __verbose (
            if not "%~1"=="no-output" echo MACROS have been loaded.
        )
        goto :eof

    :loadmacros_failed
        set dos_aliases_loaded=
        echo MACROS failed to load.
        goto :eof

:backupmacros
    if not defined dos_aliases_loaded (
        echo MACROS have not been loaded.
        echo I cannot backup.
        goto :eof
    )

    rem if not "%~1"=="no-save" (
    rem     call :savemacros no-backup
    rem )

    set BackupFile=%__ALIASES_FILE_BACKUP%.%yy%%mm%%dd%-%hh%%nn%%ss%.txt
    copy /Y "%__ALIASES_FILE%" "%BackupFile%" >NUL 2>&1

    if not "%~1"=="no-save" (
        if defined __verbose (
            echo macros file BACKED UP.
        )
    )

    goto :eof

:savemacros
    if not defined dos_aliases_loaded (
        echo MACROS have not been loaded.
        echo I cannot save.
        goto :eof
    )

    :: Output all session macros to a temporary file.
    set tmp=%TEMP%\macros.%yy%-%mm%-%dd%-%hh%-%nn%-%ss%-%random%.tmp

    rem First, copy the current macros file to the tmp file.
    call copy /Y "%__ALIASES_FILE%" "%tmp%" >NUL

    rem Append, the current session's macros to the tmp file.
    call "%__doskey%" /macros >>"%tmp%"
    if %errorlevel% NEQ 0 (
        echo MACROS failed to export.
        echo macro file was left UNCHANGED.
        if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1
        goto :eof
    )

    rem rem Sort and remove the duplicate lines.
    rem rem Outputting the results to the history file.
    rem call "%__sort%" --ignore-case --unique --output="%__ALIASES_FILE%" "%tmp%"
    call move "%tmp%" "%__ALIASES_FILE%" >NUL 2>&1

    if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1

    if defined __verbose (
        echo MACROS saved.
    )

    rem call :loadmacros no-output
    rem if defined __verbose (
    rem     echo MACROS reloaded.
    rem )

    rem if "%__backuponsave%"=="true" (
    rem     if not "%~1"=="no-backup" (
    rem         call :backupmacros no-save
    rem     )
    rem )

    goto :eof

:deletemacro
    call "%__doskey%" %~1=
    if %errorlevel% EQU 0 (
        if defined __verbose (
            echo DELETED macro.
        )
    ) else (
        echo FAILED to delete macro!?
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
