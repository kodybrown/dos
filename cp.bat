@setlocal EnableDelayedExpansion
@echo off

:init
    set cmds=
    set showname=

    if not "%~1"=="" goto :parse

    copy /?
    endlocal && exit /B 0

:parse
    if "%~1"=="" goto :main

    set arg=%~1
    rem echo !arg:~0,1!

    rem If the argument contains '~/' then replace it with %UserProfile%
    if "!arg:~0,2!"=="~\" (
        set arg=!arg:~/=%UserProfile%!
        echo arg=!arg!
    )

    :: My common shorcut/replacements..
    if "!arg:~0,2!"=="//" (
        set arg=%UserProfile%\!arg:~2!
        set showname=true
    )
    if "!arg:~0,3!"=="/b/" (
        set arg=%BIN%\!arg:~3!
        set showname=true
    )
    if "!arg:~0,3!"=="/w/" (
        set arg=%UserProfile%\Desktop\!arg:~3!
        set showname=true
    )
    if "!arg:~0,3!"=="/e/" (
        set arg=%UserProfile%\Desktop\!arg:~3!
        set showname=true
    )
    if "!arg:~0,3!"=="/d/" (
        set arg=%UserProfile%\Documents\!arg:~3!
        set showname=true
    )

    :: If the argument doesn't start with a '/' or '-' then
    :: replace all '/' characters with '\'..
    if not "!arg:~0,1!"=="/" (
        if not "!arg:~0,1!"=="-" (
            :: Replace dlb-backslashes with a single back-slash
            set arg=!arg:\\=\!
            :: Replace forward-slashes with back-slashes
            set arg=!arg:/=\!
	        set showname=true
        )
    )

    if /i "!arg!"=="-f" (
        set arg=/F
    ) else if /i "!arg!"=="--force" (
        set arg=/F
    )

    if /i "!arg!"=="-i" (
        set arg=/-Y
    ) else if /i "!arg!"=="--interactive" (
        set arg=/-Y
    )

    if /i "!arg!"=="-r" (
        set arg=/S
    ) else if /i "!arg!"=="--recursive" (
        set arg=/S
    )

    if /i "!arg!"=="-v" (
        set arg=/-Q
    ) else if /i "!arg!"=="--verbose" (
        set arg=/-Q
    )

    if "!arg!"=="-P" (
        set arg=/L
    ) else if "!arg!"=="--no-dereference" (
        set arg=/L
    )

    set cmds=%cmds% %arg%

    shift
    goto :parse

:main
    rem left-trim the input
    for /f "tokens=* delims= " %%a in ("!cmds!") do set cmds=%%a

	if defined showname echo copy !cmds! && set "showname="

    copy %cmds%

    @endlocal && @exit /B %errorlevel%
