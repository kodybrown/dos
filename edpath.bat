@setlocal EnableDelayedExpansion
@echo off

:init
    set batname=%~n0
    set "__quiet="
    set "__debug="
    set "__pause="
    set "__force="
    set "__prepend="
    set "__remove="
    set "__newdir="
    set "__newpath="

:parse
    if "%~1"=="" goto :main

    if "%~1"=="" call :usage && endlocal && exit /B 0
    if /i "%~1"=="--help" call :usage && endlocal && exit /B 0
    if /i "%~1"=="help" call :usage && endlocal && exit /B 0
    if /i "%~1"=="/?" call :usage && endlocal && exit /B 0
    if /i "%~1"=="/h" call :usage && endlocal && exit /B 0
    if /i "%~1"=="/help" call :usage && endlocal && exit /B 0

    if /i "%~1"=="--quiet" set "__quiet=1" && shift && goto :parse
    if /i "%~1"=="-quiet" set "__quiet=1" && shift && goto :parse
    if /i "%~1"=="/quiet" set "__quiet=1" && shift && goto :parse

    if /i "%~1"=="--debug" set "__debug=1" && shift && goto :parse
    if /i "%~1"=="-debug" set "__debug=1" && shift && goto :parse

    if /i "%~1"=="--pause" set "__pause=1" && shift && goto :parse
    if /i "%~1"=="-pause" set "__pause=1" && shift && goto :parse
    if /i "%~1"=="/pause" set "__pause=1" && shift && goto :parse

    if /i "%~1"=="--force" set "__force=1" && shift && goto :parse
    if /i "%~1"=="-force" set "__force=1" && shift && goto :parse
    if /i "%~1"=="-f" set "__force=1" && shift && goto :parse
    if /i "%~1"=="/f" set "__force=1" && shift && goto :parse

    if /i "%~1"=="--prepend" set "__prepend=1" && shift && goto :parse
    if /i "%~1"=="-prepend" set "__prepend=1" && shift && goto :parse
    if /i "%~1"=="-p" set "__prepend=1" && shift && goto :parse
    if /i "%~1"=="/p" set "__prepend=1" && shift && goto :parse

    if /i "%~1"=="--append" set "__prepend=" && shift && goto :parse
    if /i "%~1"=="-append" set "__prepend=" && shift && goto :parse
    if /i "%~1"=="-a" set "__prepend=" && shift && goto :parse
    if /i "%~1"=="/a" set "__prepend=" && shift && goto :parse

    if /i "%~1"=="--remove" set "__remove=1" && shift && goto :parse
    if /i "%~1"=="-remove" set "__remove=1" && shift && goto :parse
    if /i "%~1"=="--delete" set "__remove=1" && shift && goto :parse
    if /i "%~1"=="-delete" set "__remove=1" && shift && goto :parse
    if /i "%~1"=="-d" set "__remove=1" && shift && goto :parse
    if /i "%~1"=="/d" set "__remove=1" && shift && goto :parse

    set __newdir=%~1

    shift
    goto :parse

:main
    if "%__newdir%"=="" endlocal && exit /B 1

    if defined __debug (
        call :println ARGS: debug is turned on..
        call :println ARGS: location: !__newdir!
        if defined __remove (
            call :println ARGS: remove location from path..
        ) else (
            if defined __prepend call :println ARGS: insert location at begining of path..
            if not defined __prepend call :println ARGS: append location to end of path..
        )
        if defined __force call :println ARGS: force new location into path..
        if defined __pause call :println ARGS: pause is turned on..
    )

    set tmpfile=%TEMP%\edpath_bat_%random%_%random%_%random%.tmp

    :: TODO trim any trailing semi-colon's from `__newdir`.

    if defined __debug call :println Checking if `%__newdir%` is already in the path
    echo ;%PATH%; | C:\Windows\System32\find.exe /C /I ";%__newdir%;" >"%tmpfile%"
    set /P path_exists=<"%tmpfile%"

    if exist "%tmpfile%" del /Q "%tmpfile%"
    set "tmpfile="

    if defined __remove (
        if "%path_exists%"=="0" (
            call :println The location is not in the path..
        ) else (
            call :removefrompath
        )
    ) else (
        if "%path_exists%"=="0" (
            call :println The location is not in the path.. adding..
            call :addtopath
        ) else (
            if defined __debug call :println The location already exists..
            if defined __force (
                if defined __debug call :println Removing existing entry for `%__newdir%`,
                call :removefrompath
                set "PATH=!__newpath!"

                if defined __debug call :println Adding the new location into the path..
                call :addtopath
            ) else (
                if not defined __debug call :println The location already exists..
                call :println Use the following to force the new location onto the path:
                if defined __prepend call :println     %batname% --force --prepend "%__newdir%"
                if not defined __prepend call :println     %batname% --force --append "%__newdir%"
            )
        )
    )

    if defined __pause pause

    if defined __pathchanged (
        if defined __debug call :println Updating PATH envar..
        endlocal && set "PATH=%__newpath%" && exit /B 0
    ) else (
        endlocal && exit /B 0
    )

:usage
    echo Easily edit the PATH environment variable.
    echo Copyright (C) 2011-2014 Kody Brown (@wasatchwizard)
    echo.
    echo USAGE:
    echo.
    echo   %batname% [options] path
    echo.
    echo OPTIONS:
    echo.
    echo   --debug       Outputs additional information while processing.
    echo   --pause       Pauses at the end of processing.
    echo   --append      Adds the specified path to the end of the PATH envar.
    echo   --prepend     Adds the specified path to the beginning of the PATH envar.
    echo   --remove      Removes the path from the PATH envar.
    echo   --force       Forces adding a path, even if it already exists.
    echo.
    echo   If `append` and `prepend` are omitted, `append` is assumed.
    echo.
    echo EXAMPLES:
    echo.
    echo   Append `C:\NewPath` to the end of the PATH envar.
    echo.
    echo     $ %batname% [--append] C:\NewPath
    echo.
    echo   Append `C:\NewPath` to the begining of the PATH envar.
    echo.
    echo     $ %batname% --prepend C:\NewPath
    echo.
    echo   Append `C:\NewPath` to the beginning of the PATH envar, even if it already
    echo   exists in the path.
    echo.
    echo     $ %batname% --force --prepend C:\NewPath
    echo.
    echo   Removes `C:\Path` from the PATH envar.
    echo.
    echo     $ %batname% --remove C:\Path
    echo.
    echo NOTES:
    echo.
    echo  Changes to the PATH envar only affect the current process.
    echo.

    goto :eof

:println
    if not defined __quiet echo %*
    goto :eof

:addtopath
    if defined __debug call :println Adding location to path..

    if defined __prepend set __newpath=%__newdir%;%path%
    if not defined __prepend set __newpath=%path%;%__newdir%

    set __pathchanged=1
    goto :eof

:removefrompath
    set "__newpath="

    for %%G in ("%PATH:;=" "%") do (
        call :trim loc "%%~G"

        if "!loc!"=="" (
            rem do nothing
        ) else if /i "!loc!"=="!__newdir!" (
            rem Skip the new dir.
            rem ie: do not add it to the new path var.
        ) else (
            set __newpath=!__newpath!!loc!;
        )
    )

    set __pathchanged=1
    goto :eof

:trim
    set var=%1
    set str=%~2
    rem trim left
    for /f "tokens=* delims= " %%a in ("%str%") do set str=%%a
    rem trim right
    for /l %%a in (1,1,99) do if "!str:~-1!"==" " set str=!str:~0,-1!
    set !var!=!str!
    rem echo loc=%loc%
    goto :eof
