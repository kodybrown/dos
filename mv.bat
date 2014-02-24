@setlocal EnableDelayedExpansion
@echo off

:init
    set cmds=
    if not "%~1"=="" goto :parse
    move /?
    endlocal && exit /B 0

:parse
    if "%~1"=="" goto :main

    set arg=%~1
    rem echo !arg:~0,1!

    :: If the argument doesn't start with a '/' or '-' then
    :: replace all '/' characters with '\'..
    if not "!arg:~0,1!"=="/" (
        if not "!arg:~0,1!"=="-" (
            set arg=!arg:/=\!
        )
    )

    if /i "!arg!"=="-f" (
        set arg=/Y
    ) else if /i "!arg!"=="--force" (
        set arg=/Y
    )

    if /i "!arg!"=="-i" (
        set arg=/-Y
    ) else if /i "!arg!"=="--interactive" (
        set arg=/-Y
    )

    set cmds=%cmds% %arg%
    shift

    goto :parse

:main
    rem echo %cmds%
    move %cmds%
    endlocal && exit /B %errorlevel%
