@setlocal EnableDelayedExpansion
@echo off

:init
    set "version=0.9.11"

    :: --------------------------------------------------------
    :: Save the batch file's name and path.. This is lost when
    :: `shift` is called (while parsing arguments).
    :: --------------------------------------------------------
    set __batfile=%~nx0
    set __batname=%~n0
    set __batpath=%~dp0

    :: --------------------------------------------------------
    :: `opt_quiet` flag trumps everything: there will be no
    :: output, except errors, and no prompting the user.
    ::
    :: If something can't be figured out without user input,
    :: the batch is expected to know what to do, or it is
    :: expected to fail gracefully with an error code.
    :: --------------------------------------------------------
    set "opt_quiet="
    call get_envar_value.cmd opt_quiet [bool] rm-quiet

    :: --------------------------------------------------------
    :: `opt_verbose` indicates to output additional info during
    :: processing.
    :: --------------------------------------------------------
    set "opt_verbose="
    call get_envar_value.cmd opt_verbose [bool] rm-verbose

    :: --------------------------------------------------------
    :: `opt_debug` indicates to output a LOT of additional info
    :: during processing: basically, everything..
    :: --------------------------------------------------------
    set "opt_debug="
    call get_envar_value.cmd opt_debug [bool] rm-debug

    :: --------------------------------------------------------
    :: `opt_force` indicates to force deleting of read-only
    :: files.
    :: --------------------------------------------------------
    set "opt_force="
    call get_envar_value.cmd opt_force [bool] rm-force

    :: --------------------------------------------------------
    :: `opt_recycle` indicates to move the files to the
    :: Recycle Bin (via recycle.exe) instead of deleting the
    :: files (via DEL).
    :: --------------------------------------------------------
    set "opt_recycle=yes"
    call get_envar_value.cmd opt_recycle [bool] rm-recycle

    :: --------------------------------------------------------

    set "opt_interactive=yes"
    call get_envar_value.cmd opt_interactive [bool] rm-interactive

    set "opt_interactive=yes"
    call get_envar_value.cmd opt_interactive [bool] rm-interactive

    :: --------------------------------------------------------

    set "cmds="
    set "showname="
    set "arg="

    set "is_option="
    set "is_not="
    set "is_reverse="

:parse
    :: Loop through all command-line arguments
    :: by jumping to :parse until there are no more
    :: arguments left.
    if "%~1"=="" goto :main

    :: Get the current argument.
    set "arg=%~1"
    :: Get the first character of `arg`
    set "arg1=!arg:~0,1!"
    :: Clear/reset some options
    set "is_option="
    set "is_not=yes"
    set "is_reverse="

    if "!arg1!"=="-" (
        :: Remove ALL starting `-` characters, if present.
        for /f "tokens=* delims=-" %%a in ("!arg!") do set arg=%%a
        set "is_option=yes"
    )
    if "!arg1!"=="/" (
        :: Remove the starting `/` character, if present.
        for /f "tokens=* delims=/" %%a in ("!arg!") do set arg=%%a
        set "is_option=yes"
    )
    if "!arg1!"=="~" (
        :: Remove the starting `~` character, if present.
        for /f "tokens=* delims=~" %%a in ("!arg!") do set arg=%%a
        set "is_option=yes"
        set "is_not="
        set "is_reverse=yes"
        rem set "arg=~!arg!"
    )

    if "!is_option!"=="yes" (
        :: Get the first character of `arg`
        set "arg1=!arg:~0,1!"

        rem if defined opt_debug echo arg  = '%arg%'
        rem if defined opt_debug echo arg1 = '%arg1%'

        if defined opt_debug echo is_option: !arg!
        if defined opt_debug echo is_reverse = !is_reverse!

        :: Help
        if /i "!arg1!"=="?" call :usage && endlocal && exit /B 0
        if /i "!arg1!"=="h" call :usage && endlocal && exit /B 0
        if /i "!arg!"=="help" call :usage "%~2" && endlocal && exit /B 0

        :: Version
        if /i "!arg!"=="version" call :version f && goto :end
        if /i "!arg1!"=="v" call :version && goto :end

        :: Quiet
        if /i "!arg1!"=="q" set "opt_quiet=!is_not!" && shift && goto :parse

        :: Verbose
        if /i "!arg!"=="verbose" set "opt_verbose=!is_not!" && shift && goto :parse
        if /i "!arg1!"=="e" set "opt_verbose=!is_not!" && shift && goto :parse

        :: Debug
        if /i "!arg!"=="debug" set "opt_debug=!is_not!" && shift && goto :parse
        if /i "!arg1!"=="d" set "opt_debug=!is_not!" && shift && goto :parse

        :: Force
        if /i "!arg1!"=="f" set "opt_force=!is_not!" && shift && goto :parse

        :: Interactive
        if /i "!arg1!"=="i" set "opt_interactive=!is_not!" && shift && goto :parse

        :: Recursive
        if /i "!arg!"=="-r" (
            set arg=/S
        ) else if /i "!arg!"=="--recursive" (
            set arg=/S
        )

        :: verbose
        if /i "!arg!"=="-v" (
            set arg=/-Q
        ) else if /i "!arg!"=="--verbose" (
            set arg=/-Q
        )

        :: quiet
        if /i "!arg!"=="-q" (
            set arg=/Q
        ) else if /i "!arg!"=="--quiet" (
            set arg=/Q
        )

    ) else (
        rem My common shorcut/replacements..
        if "[!arg:~0,2!]"=="[~/]" set "arg=%UserProfile%\!arg:~2!" && set "showname=true"
        if "!arg:~0,2!"=="//" set "arg=%UserProfile%\!arg:~2!" && set "showname=true"
        if "!arg:~0,3!"=="/~/" set "arg=%UserProfile%\!arg:~3!" && set "showname=true"
        if "!arg:~0,3!"=="/b/" set "arg=%BIN%\!arg:~3!" && set "showname=true"
        if "!arg:~0,3!"=="/e/" set "arg=%UserProfile%\Desktop\!arg:~3!" && set "showname=true"
        if "!arg:~0,3!"=="/d/" set "arg=%UserProfile%\Documents\!arg:~3!" && set "showname=true"
        if "!arg:~0,3!"=="/w/" set "arg=%UserProfile%\Downloads\!arg:~3!" && set "showname=true"

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
    )

    set cmds=%cmds% %arg%

    shift
    goto :parse

:main
    rem left-trim the input
    for /f "tokens=* delims= " %%a in ("!cmds!") do set cmds=%%a

    if defined showname echo del !cmds! && set "showname="


    if defined opt_force set "cmds=!cmds! /F"
    if defined opt_interactive set "cmds=!cmds! /P"

    if defined opt_recycle (
        if not defined cmds recycle /?
        if defined cmds recycle %cmds%
    ) else (
        if not defined cmds del /?
        if defined cmds del %cmds%
    )

    endlocal && exit /B %errorlevel%

