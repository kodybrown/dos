@echo off

goto :init

::+++++++++++++++++++
:: REQUIRES:
::   --
:: OPTIONAL:
::   edpath.bat
::+++++++++++++++++++

:usage
    echo %__batfile% - sets up and configures the current command prompt.
    echo Created 2012-2014 by Kody Brown ^<thewizard@wasatchwizard.com^>
    echo This file is in the Public Domain.
    echo.
    goto :eof

:init
    :: --------------------------------------------------------
    :: Save the batch file's name and path.. This is lost when
    :: `shift` is called (while parsing arguments).
    :: --------------------------------------------------------
    set "__batfile=%~nx0"
    set "__batname=%~n0"
    set "__batdrive=%~d0"
    set "__batpath=%~dp0"

    :: --------------------------------------------------------
    :: `opt_quiet` flag trumps everything: there will be no
    :: output, except errors, and no prompting the user.
    ::
    :: If something can't be figured out without user input,
    :: the batch is expected to know what to do, or it is
    :: expected to fail gracefully with an error code.
    :: --------------------------------------------------------
    set "opt_quiet="

    :: --------------------------------------------------------
    :: `opt_pause` indicates to pause at the end.
    :: --------------------------------------------------------
    set "opt_pause="

    :: --------------------------------------------------------
    :: `opt_verbose` indicates to output additional info during
    :: processing.
    :: --------------------------------------------------------
    set "opt_verbose="

    set "opt_debug="

    set "start_drive=%__batdrive%"

    if "%~1"=="" goto :main

:parse
    if "%~1"=="" goto :post_parse

    set a=%~1
    :: Replace all '--' with '-' (for options)
    set a=%a:--=-%
    :: Get the first 2 characters of `a`
    set a2=%a:~0,2%

    if /i "%a%"=="/?" call :usage && endlocal && exit /B 0
    if /i "%a2%"=="-h" call :usage && endlocal && exit /B 0

    if /i "%a2%"=="-q" set "opt_quiet=yes" && shift && goto :parse
    if /i "%a2%"=="/q" set "opt_quiet=yes" && shift && goto :parse

    if /i "%a2%"=="-e" set "opt_verbose=yes" && shift && goto :parse
    if /i "%a2%"=="/v" set "opt_verbose=yes" && shift && goto :parse

    if /i "%a2%"=="-d" set "opt_debug=yes" && shift && goto :parse
    if /i "%a2%"=="/d" set "opt_debug=yes" && shift && goto :parse

    if /i "%a2%"=="-p" set "opt_pause=yes" && shift && goto :parse
    if /i "%a2%"=="/p" set "opt_pause=yes" && shift && goto :parse

    if "%a2:~1,1%"==":" set "start_drive=%a2%" && shift && goto :parse

    shift
    goto :parse

:post_parse
    if defined opt_quiet set "opt_verbose=" && set "opt_pause="
    if defined opt_debug set "opt_quiet=" && set "opt_verbose=yes" && set "opt_pause=yes"

:main
    :: Let's get started..

:standard_setup
    if defined opt_verbose echo Setting standard envars..

    set "bin=%start_drive%\bin"
    rem set "dev=%start_drive%\dev"
    set "dev=%start_drive%\Users\Kody\Documents\Development"
    set "downloads=%start_drive%\downloads"
    set "installers=%start_drive%\installers"
    set "tools=%start_drive%\tools"

    if /i "%start_drive%"=="c:" set "ThumbDrive=T:"
    if /i not "%start_drive%"=="c:" set "ThumbDrive=%start_drive%"

    set "profile=%start_drive%\Users\Kody"
    set "profileData=%start_drive%\Users\Kody\AppData\Roaming"

:ipaddr_setup
    if defined opt_verbose echo Creating IPADDR envar..

    :: This sets the `ipaddr` envar to the current ip address.
    if exist "set_ipaddr_envar.bat" call set_ipaddr_envar.bat

:pathext_setup
    if defined opt_verbose echo Updating PATHEXT..

    if not defined PATHEXT_ORIG set "PATHEXT_ORIG=%PATHEXT%"
    set "PATHEXT=.BAT;.CMD;.COM;.LNK;.EXE;.AHK;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.CSR;.CSB;.PY;.PYW"

:path_setup
    if defined opt_verbose echo Updating PATH..

    set msys=%tools%\mingw\msys\1.0\bin
    set mingw=%tools%\mingw\bin

    if not defined PATH_ORIG set "PATH_ORIG=%PATH%"

    where edpath >NUL 2>&1
    if %errorlevel% EQU 0 (
        rem Don't forget that the items are `inserted` so they
        rem need to be inserted in the reverse order of what you want.
        if defined opt_debug echo  inserting `msys`
        call edpath --quiet --force --prepend "%msys%"
        if defined opt_debug echo  inserting `mingw`
        call edpath --quiet --force --prepend "%mingw%"

        if defined opt_debug echo  inserting `shims`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\shims"
        if defined opt_debug echo  inserting `haxe`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\apps\haxe\3.1.3"
        if defined opt_debug echo  inserting `neko`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\apps\neko\2.0.0"
        if defined opt_debug echo  inserting `go`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\apps\go\1.3.3\bin"
        if defined opt_debug echo  inserting `node_modules`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\apps\nodejs\0.10.32\nodejs\node_modules\npm\node_modules"
        if defined opt_debug echo  inserting `nodejs`
        call edpath --quiet --force --prepend "%LocalAppData%\scoop\apps\nodejs\0.10.32\nodejs"

        if defined opt_debug echo  inserting `bin`
        call edpath --quiet --force --prepend "%bin%"
    ) else (
        echo edpath was not found.
        rem set PATH=%bin%;%tools%\mingw\bin;%tools%\mingw\msys\1.0\bin;%PATH%
    )

:fs_setup
    if defined opt_verbose echo Setting FS envars..

    set "fs_file=regex:.*\\.cs$;.*\\.aspx$"
    set "fs_matchcase=false"
    set "fs_pause=false"
    set "fs_recursive=true"
    set "fs_verbose=true"

:git_setup
    if defined opt_verbose echo Setting Git envars..

    set "GIT_EDITOR=%bin%\Notepad2.exe"
    rem Replace back-slashes with forward-slashes..
    set "GIT_EDITOR=%GIT_EDITOR:\=/%"

 rem :golang_setup
 rem     if defined opt_verbose echo Setting Go envars..

 rem    rem set "GOARCH=386"
 rem    set "GOARCH=amd64"
 rem    set "GOBIN=%tools%\Go\bin"
 rem    set "GOOS=windows"
 rem    set "GOROOT=%tools%\Go"

 rem    where edpath >NUL 2>&1
 rem    if %errorlevel% EQU 0 (
 rem      call edpath --quiet --force --append "%GOBIN%"
 rem    ) else (
 rem      rem set PATH=%PATH%;%GOBIN%
 rem    )

 rem :python_setup
 rem     if defined opt_verbose echo Setting Python envars..

 rem :pik_setup
 rem     if defined opt_verbose echo Setting pik envars..
 rem
 rem     set PIK_HOME=%ProfileData%\.pik

 rem :ruby_setup
 rem     if defined opt_verbose echo Setting Ruby envars..

:environment
    if defined opt_verbose echo Setting up environment..

    :: Set the prompt colors to light grey on black.
    rem color 08

    :: Set the prompt.
    rem prompt [%computername%/%ipaddr%]$S$D$S$T$_$P$G$S
    rem prompt [%username%/%computername%]$S$D$S$T$_$P$G$S
    rem prompt [%username%@%computername%] $P$G
    rem prompt [%username%@%computername%] $P$S$$$S
    rem prompt [%username%@%computername%] $P$_$$$S
    rem prompt [%username%@%computername%] $P$_$$$G
    rem prompt [%username%@%computername%] $P$G$S
    rem prompt [%username%@%computername%] $P$G
    rem prompt [%computername%] $P$G$S
    rem prompt [%computername%] $P$G
    rem prompt %username%@%computername%:$P $$$S
    rem prompt %username%@%computername% %cd:\=/%$$$S
    prompt [%username%@%computername%] $P$G

    :: Load aliases/macros and history.
    set "doskey_macros_loaded="
    set "doskey_history_loaded="

    call "%~dp0alias.bat" --load
    call "%~dp0history.bat" --load

:cleanup
    if defined opt_verbose echo Cleaning up..

    set "__batfile="
    set "__batname="
    set "__batdrive="
    set "__batpath="

    set "opt_quiet="
    set "opt_pause="
    set "opt_verbose="

    set "start_drive="

    set "a="
    set "a2="

    if defined opt_pause pause

    exit /B 0
