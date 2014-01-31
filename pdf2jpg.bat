@setlocal EnableDelayedExpansion
@echo off

goto :init

::+++++++++++++++++++
:: REQUIRES:
::   gswin64c.exe (GhostScript)
::+++++++++++++++++++

:usage ()
    echo pdf2jpg.bat ^| Created 2014 @wasatchwizard.
    echo             ^| Released under the MIT License.
    echo.
    echo Creates a thumbnail of pages within a .pdf file. This batch file is just an
    echo easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.
    echo.
    echo Many thanks to [KenS](http://stackoverflow.com/users/701996/kens) for pointing
    echo out just how easy it is to use ghostscript by itself. See here for details:
    echo http://stackoverflow.com/questions/12614801/how-to-execute-imagemagick-to-convert-only-the-first-page-of-the-multipage-pdf-t
    echo.
    echo   +++++++++++++++++++
    echo    REQUIRES:
    echo      gswin64c.exe (GhostScript)
    echo   +++++++++++++++++++
    echo.
    echo USAGE: pdf2jpg.bat [options] [file]
    echo.
    echo   file            Creates a thumbnail of the first page of the specified file.
    echo   no-file         Creates a thumbnail of the first page of every .pdf file in
    echo                   the current directory.
        echo.
    echo OPTIONS:
    echo.
    echo   -h --help       Displays this help.
    echo   -q --quiet      No output is displayed (except errors), and no input will be
    echo                   asked for.
    echo   -v --verbose    Displays extra details during processing.
    echo   -p --pause      Pauses when it is finished (ignored if `-q` is specified).
    echo   -R --recursive  Processes .pdf in sub-directories as well.
    echo.
    echo   --max n         Specify the maximum number of files to process.
    echo   --overwrite [yes^|no^|ask]
    echo                   Specifies what to do if the output file already exists.
    echo                   The default if not specified is ask. The file is ignored if
    echo                   `overwrite=ask` and `-quiet` is specified.
    goto :eof

:init ()
    :: NOTE: envars that are prefixed with __ mean those values
    ::       can be set via a command-line argument.

    :: `gswin64c` specifies the location of the GhostScript
    :: command-line executable `gswin64c.exe`.
    ::
    :: It can be downloaded from
    :: [here](http://www.ghostscript.com/download/gsdnld.html).
    ::
    :: I changed the default installation for ghostscript.
    :: Normally, it would install somewhere like this:
    :: C:\Program Files (x86)\gs\gs910\bin\gswin64c.exe
    set gswin64c=%bin%\apps\ghostscript\bin\gswin64c.exe

    :: `__quiet` flag trumps everything: there will be no
    :: output, except errors, and no prompting the user.
    ::
    :: If something can't be figured out without user input,
    :: the batch is expected to know what to do, or it is
    :: expected to fail gracefully with an error code.
    set __quiet=

    :: `overwrite` flag indicates the behavior to use when the
    :: output file already exists.
    ::
    :: The default is ask.
    :: Other options are yes and no.
    ::
    :: > NOTE: If you specify `quiet=true` and `overwrite=ask`
    :: >       each file (with existing output file) be skipped.
    set __overwrite=ask

    :: `__pause` indicates to pause at the end.
    set __pause=
    :: `__subdirs` indicates to process sub-directories also.
    set __subdirs=

    :: `__max` is the maximum number of files to process.
    set /a __max=100
    :: `count` is the number of files that were processed.
    set /a count=0

    :: `firstp` is the first page.
    set firstp=1
    :: `lastp` is the last page.
    set lastp=1
    :: `size` is the size of the generated image (currently not used).
    set size=150x100
    :: `res` is the pixels/inch resolution.
    set res=96
    :: `device` is the output device (type).
    set device=jpeg
    :: `filext` is the output file name's extension.
    set filext=jpg

:parse ()
    if "%~1"=="" goto :main

    if /i "%~1"=="/?" call :usage && endlocal && exit /B 0
    if /i "%~1"=="--help" call :usage && endlocal && exit /B 0
    if /i "%~1"=="-help" call :usage && endlocal && exit /B 0
    if /i "%~1"=="-h" call :usage && endlocal && exit /B 0

    if /i "%~1"=="--quiet" set "__quiet=true" && shift && goto :parse
    if /i "%~1"=="-quiet" set "__quiet=true" && shift && goto :parse
    if /i "%~1"=="-q" set "__quiet=true" && shift && goto :parse
    if /i "%~1"=="/q" set "__quiet=true" && shift && goto :parse

    if /i "%~1"=="--verbose" set "__verbose=true" && shift && goto :parse
    if /i "%~1"=="-verbose" set "__verbose=true" && shift && goto :parse
    if /i "%~1"=="-v" set "__verbose=true" && shift && goto :parse
    if /i "%~1"=="/v" set "__verbose=true" && shift && goto :parse

    if /i "%~1"=="--pause" set "__pause=true" && shift && goto :parse
    if /i "%~1"=="-pause" set "__pause=true" && shift && goto :parse
    if /i "%~1"=="-p" set "__pause=true" && shift && goto :parse
    if /i "%~1"=="/p" set "__pause=true" && shift && goto :parse

    if /i "%~1"=="/s" set "__subdirs=/s" && shift && goto :parse
    if /i "%~1"=="-s" set "__subdirs=/s" && shift && goto :parse
    if /i "%~1"=="--s" set "__subdirs=/s" && shift && goto :parse
    if /i "%~1"=="/r" set "__subdirs=/s" && shift && goto :parse
    if /i "%~1"=="-r" set "__subdirs=/s" && shift && goto :parse
    if /i "%~1"=="--r" set "__subdirs=/s" && shift && goto :parse

    if /i "%~1"=="--max" set /a "__max=%~2" && shift && shift && goto :parse
    if /i "%~1"=="-max" set /a "__max=%~2" && shift && shift && goto :parse

    if /i "%~1"=="--overwrite" set "__overwrite=%~2" && shift && shift && goto :parse
    if /i "%~1"=="-overwrite" set "__overwrite=%~2" && shift && shift && goto :parse
    if /i "%~1"=="--overwrite:yes" set "__overwrite=yes" && shift && goto :parse
    if /i "%~1"=="--overwrite:no" set "__overwrite=no" && shift && goto :parse
    if /i "%~1"=="--overwrite:ask" set "__overwrite=ask" && shift && goto :parse
    if /i "%~1"=="--overwrite=yes" set "__overwrite=yes" && shift && goto :parse
    if /i "%~1"=="--overwrite=no" set "__overwrite=no" && shift && goto :parse
    if /i "%~1"=="--overwrite=ask" set "__overwrite=ask" && shift && goto :parse

:main ()
    :: Validate `__overwrite`.
    if not "%__overwrite%"=="yes" (
        if not "%__overwrite%"=="no" (
            if not "%__overwrite%"=="ask" (
                set __overwrite=ask
            )
        )
    )

    if not "%~1"=="" call :singlefile "%~1"
    if "%~1"=="" call :multiplefiles

    :completed
        if not defined __quiet (
            echo.
            echo Processed %count% files..
            if defined __pause pause
        )
        endlocal && exit /B 0
        goto :eof

:incrementcount ()
    set /a count+=1
    goto :eof

:multiplefiles ()
    for /f "tokens=*" %%g in ('"dir %__subdirs% /b *.pdf"') do (
        if !count! GEQ %__max% goto :eof
        call :singlefile "%%~g"
    )
    goto :eof

:singlefile ()
    call :incrementcount

    set "hideoutput=>NUL"

    if defined __quiet goto :singlefile_go
    echo.
    if defined __verbose goto :singlefile_out_verbose
    if not defined __verbose goto :singlefile_out_basic

    :singlefile_out_basic
        echo Processing file #!count!:
        echo %~1
        goto :singlefile_go

    :singlefile_out_verbose
        set "hideoutput="
        echo ===============================================================================
        echo == Processing file #!count!:
        echo == %~1
        echo -------------------------------------------------------------------------------
        goto :singlefile_go

    :singlefile_go
        if not exist "%~dpn1.%filext%" goto :singlefile_go_okay
        if "%__overwrite%"=="yes" goto :singlefile_go_okay
        if "%__overwrite%"=="ask" (
            if defined __quiet goto :eof
            set /P "pval=Would you like to overwrite this file [y/N]: " || set pval=n
            if /i "!pval!"=="y" goto :singlefile_go_okay
            if /i "!pval!"=="yes" goto :singlefile_go_okay
            if /i "!pval!"=="all" set "__overwrite=yes" && goto :singlefile_go_okay
            :: if /i "!pval!"=="n" echo Skipped.. && goto :eof
            :: if /i "!pval!"=="no" echo Skipped.. && goto :eof
            echo Skipped.. && goto :eof
        )
        :: if "%__overwrite%"=="no" goto :eof
        goto :eof

    :singlefile_go_okay
        :: -g%size%
        call "%gswin64c%" -dNOPAUSE -dBATCH -r%res% -sDEVICE=%device% -sOutputFile="%~dpn1.%filext%" -dFirstPage=%firstp% -dLastPage=%lastp% "%~1" %hideoutput%
        if %errorlevel% NEQ 0 echo **** ERROR: Could not convert file.

    goto :eof

rem REFERENCE:
rem  gswin64c.exe
rem   -dNOPAUSE           no pause after page
rem   -q                  `quiet', fewer messages
rem   -g<width>x<height>  page size in pixels
rem   -r<res>             pixels/inch resolution
rem   -sDEVICE=<devname>  select device
rem   -dBATCH             exit after last file
rem   -sOutputFile=<file> select output file: - for stdout, |command for pipe,
