@setlocal EnableDelayedExpansion
@echo off

goto :init

::+++++++++++++++++++
:: REQUIRES:
::   gswin64c.exe (GhostScript)
::+++++++++++++++++++

:usage
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
    echo   --max n         Specify the maximum number of .pdf files to process. (optional)
    echo                   The default is 0, which means to process all files found.
    echo   --overwrite [yes^|no^|ask]
    echo                   Specifies what to do if the output file already exists.
    echo                   The default if not specified is ask. The file is ignored if
    echo                   `overwrite=ask` and `-quiet` is specified.
    echo.
    echo   --firstp        Specifies the (first) page to output. (optional)
    echo                   The default is page 1.
    echo   --lastp         Specifies the last page to ouput. (optional)
    echo                   The default is page 1.
    echo             NOTE: Whenever `firstp` is set, `lastp` is set to the same value.
    echo                   This allows you to output any one page using only the `firstp`
    echo                   parameter. If you want a range of pages output, be sure to
    echo                   set `firstp` then `lastp` in your arguments.
    goto :eof

:init
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

    :: `__pause` indicates to pause at the end.
    set __pause=

    :: `__subdirs` indicates to process sub-directories also.
    set __subdirs=

    :: `overwrite` flag indicates the behavior to use when the
    :: output file already exists.
    ::
    :: The default is ask.
    :: Other options are yes and no.
    ::
    :: > NOTE: If you specify `quiet=true` and `overwrite=ask`
    :: >       each file (with existing output file) be skipped.
    set __overwrite=ask

    :: Use `folder.jpg` as the image name AND create a
    :: `desktop.ini` file pointing to `folder.jpg` for the
    :: directory's image.
    set __folderjpg=

    :: `__max` is the maximum number of files to process.
    set /a __max=10000
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

    :: create an icon of the image, also
    set __ico=
    :: create a shortcut to the pdf file
    :: will use ico if created..
    set __shortcut=

:parse
    if "%~1"=="" goto :main

    set a=%~1
    set a=%a:--=-%
    set a2=%a:~0,2%

    if /i "%a%"=="/?" call :usage && endlocal && exit /B 0
    if /i "%a2%"=="-h" call :usage && endlocal && exit /B 0

    if /i "%a2%"=="-q" set "__quiet=true" && shift && goto :parse
    if /i "%a2%"=="/q" set "__quiet=true" && shift && goto :parse

    if /i "%a2%"=="-v" set "__verbose=true" && shift && goto :parse
    if /i "%a2%"=="/v" set "__verbose=true" && shift && goto :parse

    if /i "%a2%"=="-p" set "__pause=true" && shift && goto :parse
    if /i "%a2%"=="/p" set "__pause=true" && shift && goto :parse

    if /i "%a2%"=="/s" set "__subdirs=/s" && shift && goto :parse
    if /i "%a2%"=="-s" set "__subdirs=/s" && shift && goto :parse
    if /i "%a2%"=="/r" set "__subdirs=/s" && shift && goto :parse
    if /i "%a2%"=="-r" set "__subdirs=/s" && shift && goto :parse

    if /i "%a2%"=="-m" set /a "__max=%~2" && shift && shift && goto :parse
    :: if /i "%a%"=="/max" set /a "__max=%~2" && shift && shift && goto :parse

    if /i "%a2%"=="-o" set "__overwrite=%~2" && shift && shift && goto :parse
    :: if /i "%a%"=="/overwrite" set "__overwrite=%~2" && shift && shift && goto :parse

    rem gswin64c parameters.
    if /i "%a%"=="-firstp" set /a "firstp=%~2" && set /a "lastp=%~2" && shift && shift && goto :parse
    if /i "%a%"=="-lastp" set /a "lastp=%~2" && shift && shift && goto :parse
    if /i "%a%"=="-size" set "size=%~2" && shift && shift && goto :parse
    if /i "%a%"=="-res" set /a "res=%~2" && shift && shift && goto :parse
    if /i "%a%"=="-device" set "device=%~2" && shift && shift && goto :parse
    if /i "%a%"=="-filext" set "filext=%~2" && shift && shift && goto :parse

    if /i "%a%"=="-folderjpg" set "__folderjpg=true" && shift && goto :parse

    if /i "%a%"=="-ico" set "__ico=true" && shift && goto :parse
    if /i "%a%"=="-icon" set "__ico=true" && shift && goto :parse

    if /i "%a%"=="-lnk" set "__shortcut=true" && shift && goto :parse
    if /i "%a%"=="-link" set "__shortcut=true" && shift && goto :parse

:main
    :: Validate `__overwrite`.
    if /i "%__overwrite%"=="all" set __overwrite=yes
    if /i "%__overwrite%"=="none" set __overwrite=no
    if /i not "%__overwrite%"=="yes" (
        if /i not "%__overwrite%"=="no" (
            if /i not "%__overwrite%"=="ask" (
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

:incrementcount
    set /a count+=1
    goto :eof

:multiplefiles
    for /f "tokens=*" %%G in ('"dir %__subdirs% /b *.pdf"') do (
        if !count! GEQ %__max% goto :eof
        call :singlefile "%%~dpnxG"
    )
    goto :eof

:singlefile
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
        :: Output the image to 'folder.jpq'.
        if defined __folderjpg set outfile=folder.jpg
        if not defined __folderjpg set outfile=%~dpn1.%filext%

        if exist "%outfile%" goto :skipimage
        :: -g%size%
        call "%gswin64c%" -dNOPAUSE -dBATCH -r%res% -sDEVICE=%device% -sOutputFile="%outfile%" -dFirstPage=%firstp% -dLastPage=%lastp% "%~1" %hideoutput%
        if %errorlevel% NEQ 0 echo **** ERROR: Could not convert file.
        :skipimage

        :: Create an icon file of the image.
        if not defined __ico goto :skipicon
            if not exist "%outfile%" goto :skipicon
            if exist "%~dpn1.ico" goto :skipicon
            if defined __verbose echo == Creating .ico file.
            ::if exist "%~dpn1.ico" del /Q /F "%~dpn1.ico"
            call convert "%outfile%" -colors 256 -background transparent -border 0 -resize 256x256 "%~dpn1.ico"
        :skipicon

        :: Create a shortcut (.lnk) to the original pdf file.
        if not defined __shortcut goto :skipshortcut
            if defined __verbose echo == Creating .lnk file.
            set lnkfile=%~dpn1.lnk
            set lnktext=%~dpn1.lnktext

            if exist "%lnkfile%" del /Q /F "%lnkfile%"

            echo TargetPath=%~dpnx1> "%lnktext%"
            echo Arguments=>> "%lnktext%"
            echo WorkingDirectory=%~dp1>> "%lnktext%"
            if exist "%~dpn1.ico" echo IconLocation=%~dpn1.ico>> "%lnktext%"
            echo Description=>> "%lnktext%"
            echo Hotkey=>> "%lnktext%"
            echo WindowStyle=>> "%lnktext%"

            call wscript.exe "%bin%\exportlink.vbs" --update "%lnktext%" "%lnkfile%"

            if exist "%lnktext%" del /Q "%lnktext%"
        :skipshortcut

        :: Create the desktop.ini file.
        if not defined __folderjpg goto :skipdesktopini
        if exist desktop.ini goto :skipdesktopini
            if defined __verbose echo == Creating desktop.ini file.
            echo [.ShellClassInfo]> "%~dp1desktop.ini"
            echo IconFile=folder.jpg>> "%~dp1desktop.ini"
            attrib +a +h +s desktop.ini
        :skipdesktopini

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
