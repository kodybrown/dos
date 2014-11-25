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
    echo Created 2012 by Kody Brown ^<thewizard@wasatchwizard.com^>
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
    :: `__quiet` flag trumps everything: there will be no
    :: output, except errors, and no prompting the user.
    ::
    :: If something can't be figured out without user input,
    :: the batch is expected to know what to do, or it is
    :: expected to fail gracefully with an error code.
    :: --------------------------------------------------------
    set "__quiet="

    :: --------------------------------------------------------
    :: `__pause` indicates to pause at the end.
    :: --------------------------------------------------------
    set "__pause="

    :: --------------------------------------------------------
    :: `__verbose` indicates to output additional info during
    :: processing.
    :: --------------------------------------------------------
    set "__verbose="

    set "__edpath=%__batpath%\edpath.bat"

    set "__drive=%__batdrive%"

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

    if /i "%a2%"=="-q" set "__quiet=1" && shift && goto :parse
    if /i "%a2%"=="/q" set "__quiet=1" && shift && goto :parse

    if /i "%a2%"=="-v" set "__verbose=1" && shift && goto :parse
    if /i "%a2%"=="/v" set "__verbose=1" && shift && goto :parse

    if /i "%a2%"=="-p" set "__pause=1" && shift && goto :parse
    if /i "%a2%"=="/p" set "__pause=1" && shift && goto :parse

    if "%a2:~1,1%"==":" set "__drive=%a2%" && shift && goto :parse

    shift
    goto :parse

:post_parse
    if defined __quiet set "__verbose="
    if defined __quiet set "__pause="

:main
    rem Let's get started..

:standard_setup
    if defined __verbose echo Setting standard envars..

    set "bin=%__drive%\bin"
    rem set "dev=%__drive%\dev"
    set "dev=%__drive%\Users\Kody\Documents\Development"
    set "downloads=%__drive%\downloads"
    set "installers=%__drive%\installers"
    set "tools=%__drive%\tools"

    if /i "%__drive%"=="c:" set "ThumbDrive=T:"
    if /i not "%__drive%"=="c:" set "ThumbDrive=%__drive%"

    set "profile=%__drive%\Users\Kody"
    set "profileData=%__drive%\Users\Kody\AppData\Roaming"

:ipaddr_setup
    if defined __verbose echo Creating IPADDR envar..

    :: This sets the `ipaddr` envar to the current ip address.
    if exist "set_ipaddr_envar.bat" call set_ipaddr_envar.bat

:pathext_setup
    if defined __verbose echo Updating PATHEXT..

    set "PATHEXT=.BAT;.CMD;.COM;.LNK;.EXE;.AHK;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.CSR;.CSB;.PY;.PYW"

:path_setup
    if defined __verbose echo Updating PATH..

    if exist "%__edpath%" (
        call "%__edpath%" --quiet --force --prepend %tools%\mingw\msys\1.0\bin
        call "%__edpath%" --quiet --force --prepend %tools%\mingw\bin
        call "%__edpath%" --quiet --force --prepend %bin%
    ) else (
        rem set PATH=%bin%;%tools%\mingw\bin;%tools%\mingw\msys\1.0\bin;%PATH%
    )

    set msys=%tools%\mingw\msys\1.0\bin
    set mingw=%tools%\mingw\bin

:fs_setup
    if defined __verbose echo Setting FS envars..

    set "fs_file=regex:.*\\.cs$;.*\\.aspx$"
    set "fs_matchcase=false"
    set "fs_pause=false"
    set "fs_recursive=true"
    set "fs_verbose=true"

:git_setup
    if defined __verbose echo Setting Git envars..

    set "GIT_EDITOR=%bin%\Notepad2.exe"
    rem Replace back-slashes with forward-slashes..
    set "GIT_EDITOR=%GIT_EDITOR:\=/%"

 rem :golang_setup
 rem     if defined __verbose echo Setting Go envars..

 rem    rem set "GOARCH=386"
 rem    set "GOARCH=amd64"
 rem    set "GOBIN=%tools%\Go\bin"
 rem    set "GOOS=windows"
 rem    set "GOROOT=%tools%\Go"

 rem    if exist "%__edpath%" (
 rem      call "%__edpath%" --force --append %tools%\Go\bin
 rem    ) else (
 rem      rem set PATH=%PATH%;%tools%\Go\bin
 rem    )

 rem :python_setup
 rem     if defined __verbose echo Setting Python envars..

 rem :pik_setup
 rem     if defined __verbose echo Setting pik envars..
 rem
 rem     set PIK_HOME=%ProfileData%\.pik

 rem :ruby_setup
 rem     if defined __verbose echo Setting Ruby envars..

:environment
    if defined __verbose echo Setting up environment..

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
    rem prompt [%username%@%computername%] $P$G

    :: Load aliases/macros and history.
    set "doskey_macros_loaded="
    set "doskey_history_loaded="

    call "%~dp0alias.bat" --load
    call "%~dp0history.bat" --load

:cleanup
    if defined __verbose echo Cleaning up..

    set "__batfile="
    set "__batname="
    set "__batdrive="
    set "__batpath="

    set "__quiet="
    set "__pause="
    set "__verbose="

    set "__edpath="
    set "__drive="

    set "a="
    set "a2="

    if defined __pause pause

    exit /B 0
