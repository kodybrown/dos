@echo off

if not defined __DOSKEY_MACROFILE set __DOSKEY_MACROFILE=%Profile%\.doskey_macros

:init
    set doskey=C:\Windows\System32\doskey.exe
    set find=C:\Windows\System32\find.exe
    set sort=%tools%\mingw\msys\1.0\bin\sort.exe

    set __verbose=
    set __backuponsave=true

    call :setdatevars
    call :settimevars

:main
    if "%~1"=="/?" call :usage "%~2" && exit /B 0
    if /i "%~1"=="-help" call :usage "%~2" && exit /B 0
    if /i "%~1"=="--help" call :usage "%~2" && exit /B 0

    if /i "%~1"=="-verbose" set __verbose=true && shift && goto :main
    if /i "%~1"=="--verbose" set __verbose=true && shift && goto :main

    if /i "%~1"=="-edit" call :editmacros && exit /B 0
    if /i "%~1"=="--edit" call :editmacros && exit /B 0

    if /i "%~1"=="-save" call :savemacros && exit /B 0
    if /i "%~1"=="--save" call :savemacros && exit /B 0

    if /i "%~1"=="-backup" call :backupmacros && exit /B 0
    if /i "%~1"=="--backup" call :backupmacros && exit /B 0

    if /i "%~1"=="-del" call :deletemacro %~2 && exit /B 0
    if /i "%~1"=="--del" call :deletemacro %~2 && exit /B 0
    if /i "%~1"=="-delete" call :deletemacro %~2 && exit /B 0
    if /i "%~1"=="--delete" call :deletemacro %~2 && exit /B 0

    if /i "%~1"=="-load" call :loadmacros && exit /B 0
    if /i "%~1"=="--load" call :loadmacros && exit /B 0

    if "%~1"=="-" call :querymacros "%~2" && exit /B 0
    if "%~1"=="--" call :querymacros "%~2" && exit /B 0
    if /i "%~1"=="-q" call :querymacros "%~2" && exit /B 0
    if /i "%~1"=="-query" call :querymacros "%~2" && exit /B 0
    if /i "%~1"=="--query" call :querymacros "%~2" && exit /B 0

    if /i "%~1"=="-all" call :listmacros all && exit /B 0
    if /i "%~1"=="--all" call :listmacros all && exit /B 0

    if "%~1"=="" (
        rem List all macros.
        call :listmacros
        exit /B 0
    ) else (
        rem Create a new macro.
        call "%doskey%" %*
    )

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
    echo   --edit        Opens the `%%__DOSKEY_MACROFILE%%` in Notepad2.
    echo   --all         Lists all macros for all executables which have macros.
    echo.
    echo                 Be sure to `alias --load` changes when finished.
    echo.
    echo   --save        Saves the current macros to `%%__DOSKEY_MACROFILE%%`,
    echo                 only if the `doskey_macros_loaded` envar is present.
    if defined doskey_macros_loaded echo                 Currently the `doskey_macros_loaded` envar is present.
    if not defined doskey_macros_loaded echo                 Currently the `doskey_macros_loaded` envar is not present.
    echo.
    echo   --backup      Saves current macros, then creates a backup of it, appending
    echo                 the current date/time stamp in the file name.
    echo.
    echo   --load        Updates the current set of macros in the current environment /
    echo                 process, with those from the `%%__DOSKEY_MACROFILE%%` file.
    echo.
    echo                 NOTE: Any new macros created in the current session will be lost,
    echo                 unless you save them first; however saving current macros will
    echo                 overwrite the macro file, which would defeat the purpose of load.
    echo.
    echo   --del macro   Deletes the macro named `macro`. You can also use `alias macro=`
    echo                 to delete the macro.
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
    echo The saved macro file is located at:
    echo   `%__DOSKEY_MACROFILE%`
    goto :eof

:listmacros
    if "%~1"=="" call "%doskey%" /macros
    if "%~1"=="all" call "%doskey%" /macros:all
    goto :eof

:querymacros
    if "%~1"=="" call :listmacros && goto :eof
    call "%doskey%" /macros |"%find%" /i "%~1"
    goto :eof

:editmacros
    where "Notepad2" >NUL
    if %errorlevel% EQU 0 start "notepad2" /WAIT "notepad2.exe" "%__DOSKEY_MACROFILE%"
    if %errorlevel% NEQ 0 start "notepad" /WAIT "notepad.exe" "%__DOSKEY_MACROFILE%"
    goto :eof

:loadmacros
    call "%doskey%" /macrofile=%__DOSKEY_MACROFILE%
    if %errorlevel% EQU 0 call :loadmacros_success %1
    if %errorlevel% NEQ 0 call :loadmacros_failed %1
    goto :eof

    :loadmacros_success
        set doskey_macros_loaded=true
        if defined __verbose (
            if not "%~1"=="no-output" echo MACROS have been loaded.
        )
        goto :eof

    :loadmacros_failed
        set doskey_macros_loaded=
        echo MACROS failed to load.
        goto :eof

:backupmacros
    if not defined doskey_macros_loaded (
        echo MACROS have not been loaded.
        echo I cannot backup.
        goto :eof
    )

    rem if not "%~1"=="no-save" (
    rem     call :savemacros no-backup
    rem )

    set BackupFile=%__DOSKEY_MACROFILE%(%yy%-%mm%-%dd%-%hh%-%nn%-%ss%).backup
    copy /Y "%__DOSKEY_MACROFILE%" "%BackupFile%" >NUL 2>&1

    if not "%~1"=="no-save" (
        if defined __verbose (
            echo macros file BACKED UP.
        )
    )

    goto :eof

:savemacros
    if not defined doskey_macros_loaded (
        echo MACROS have not been loaded.
        echo I cannot save.
        goto :eof
    )

    :: Output all session macros to a temporary file.
    set tmp=%TEMP%\macros.%yy%-%mm%-%dd%-%hh%-%nn%-%ss%-%random%.tmp

    rem First, copy the current macros file to the tmp file.
    call copy /Y "%__DOSKEY_MACROFILE%" "%tmp%" >NUL

    rem Append, the current session's macros to the tmp file.
    call "%doskey%" /macros >>"%tmp%"
    if %errorlevel% NEQ 0 (
        echo MACROS failed to export.
        echo macro file was left UNCHANGED.
        if exist "%tmp%" del /Q /F "%tmp%" >NUL 2>&1
        goto :eof
    )

    rem Sort and remove the duplicate lines.
    rem Outputting the results to the history file.
    call "%sort%" --ignore-case --unique --output="%__DOSKEY_MACROFILE%" "%tmp%"

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
    call "%doskey%" %~1=
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
