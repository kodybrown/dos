@setlocal EnableDelayedExpansion
@echo off

:init
    set _spec=
    set _args=

    if /i "%~1"=="" dir && endlocal && exit /B 0

:parse
    if "%~1"=="" goto :main

    if /i "%~1"=="/?" call :usage && endlocal && exit /B 0
    if /i "%~1"=="-help" call :usage && endlocal && exit /B 0
    if /i "%~1"=="--help" call :usage && endlocal && exit /B 0

    set arg=%~1
    set arg[0]=%arg:~0,1%

    if "!arg[0]!"=="/" (
        :: Pass normal DIR options through..
        set _args=%_args% %arg%
    ) else if "!arg[0]!"=="-" (
        :: Convert LS-based options to their DIR equivalent..
        if /i "!arg!"=="-a" (
            rem -a == show hidden files
            set _args=%_args% /AHSRAL
        ) else if /i "!arg!"=="-l" (
            rem -l == long listing / full details
            set _args=%_args% /W /-W
        ) else if /i "!arg!"=="-r" (
            rem -r == recursive
            set _args=%_args% /S
        ) else if /i "!arg!"=="-c" (
            rem -c == sort by last modification
            set _args=%_args% /OD
        ) else if "!arg!"=="-1" (
            rem -1 == Print one entry per line of output.
            set _args=%_args% /B
        )
    ) else (
        :: Since, the argument does not start with a '/' or '-',
        :: assume it is a directory or file path, so therefore
        :: replace all '/' characters with '\'..
        if not "!_spec:~0,1!"=="/" (
            if not "!_spec:~0,1!"=="-" (
                set _spec=!_spec:/=\!
            )
        )

        set _spec=%_spec% %~1
    )

    shift
    goto :parse

:main
    rem left-trim the inputs
    for /f "tokens=* delims= " %%a in ("!_args!") do set _args=%%a
    for /f "tokens=* delims= " %%a in ("!_spec!") do set _spec=%%a

    dir /on !_args! "!_spec!"

    endlocal && exit /B 0

:usage
    echo.
    echo Simple wrapper to make the DIR command accept a few options similar to `LS`.
    echo.
    echo   -a       Show hidden files.
    echo   -l       Output full details.
    echo   -r       Display matches recursively.
    echo   -c       Sort output by last modification.
    echo   -1       Print one entry per line of output.
    echo.
    echo Created 2004-2013 @wasatchwizard
    goto :eof
