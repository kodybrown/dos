::!/dos/rocks!
@setlocal EnableDelayedExpansion
@echo off

goto :init

:version
    if "%~1"=="f" (
        echo edit v%version%
        echo finds and opens documents in their associated apps.
        echo created 2007-2014 @wasatchwizard
    ) else (
        echo %version%
    )
    goto :eof

:usage
    echo finds and opens documents in their associated apps.
    echo   replaces all '/' characters with '\'.
    echo   automatically determines the best editor for the file type.
    echo   if `hosts` is the first argument, opens the machine's hosts file.
    echo created 2007-2014 @wasatchwizard
    goto :eof

    rem files that call edit.bat:
    rem   n.bat
    rem   notepad.bat
    rem   np.bat
    rem   open.bat
    rem   read.bat
    rem   subl.bat

:init
    if defined opt_debug echo %TIME% :init
    set "version=0.8.3"

    :: --------------------------------------------------------
    :: Save the batch file's name and path.. This is lost when
    :: `shift` is called (while parsing arguments).
    :: --------------------------------------------------------
    set __batfile=%~nx0
    set __batname=%~n0
    set __batpath=%~dp0

    set "findstr="
    call get_envar_value.cmd findstr [bool] edit-findstr
    if not defined findstr set findstr=C:\Windows\System32\findstr.exe

    :: --------------------------------------------------------
    :: Turn case-sensitivity OFF (/i) or ON (undefined).
    :: --------------------------------------------------------
    set "opt_casesensitive="
    call get_envar_value.cmd opt_casesensitive edit-casesensitive
    if not defined opt_casesensitive set "opt_casesensitive=/i"

    :: --------------------------------------------------------
    :: `opt_quiet` flag trumps everything: there will be no
    :: output, except errors, and no prompting the user.
    ::
    :: If something can't be figured out without user input,
    :: the batch is expected to know what to do, or it is
    :: expected to fail gracefully with an error code.
    :: --------------------------------------------------------
    set "opt_quiet="
    call get_envar_value.cmd opt_quiet [bool] edit-quiet

    :: --------------------------------------------------------
    :: `opt_verbose` indicates to output additional info during
    :: processing.
    :: --------------------------------------------------------
    set "opt_verbose="
    call get_envar_value.cmd opt_verbose [bool] edit-verbose

    :: --------------------------------------------------------
    :: `opt_debug` indicates to output a LOT of additional info
    :: during processing: basically, everything..
    :: --------------------------------------------------------
    set "opt_debug="
    call get_envar_value.cmd opt_debug [bool] edit-debug

    :: --------------------------------------------------------
    :: `opt_force` indicates to open the specified file in the
    :: specified editor regardless of whether a `:file.` label
    :: exists for the file's type.
    :: --------------------------------------------------------
    set "opt_force="
    call get_envar_value.cmd opt_force [bool] edit-force

    set "__editor=%bin%\Notepad2.exe"
    set "__default_editor=%bin%\Notepad2.exe"
    set "__fallback_editor=Notepad.exe"

    set "spec="
    set "args="
    set "arg="

    if defined opt_debug echo ARGS: %*

:parse
    :: Loop through all command-line arguments
    :: by jumping to :parse until there are no more
    :: arguments left.
    if "%~1"=="" goto :main

    if defined opt_debug echo %TIME% :parse `%~1`

    :: Get the current argument.
    set "arg=%~1"
    :: Get the first character of `arg`
    set "arg1=!arg:~0,1!"
    :: Clear/reset some options
    set "is_option="
    set "is_not=yes"

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
        rem set "arg=~!arg!"
    )

    if "!is_option!"=="yes" (
        if defined opt_debug echo %TIME%   is_option  == yes

        :: Get the first character of `arg`
        set "arg1=!arg:~0,1!"

        rem if defined opt_debug echo arg  = '%arg%'
        rem if defined opt_debug echo arg1 = '%arg1%'

        if defined opt_debug echo %TIME%   arg        == !arg!

        :: Help
        if /i "!arg!"=="help" call :usage "%~2" && endlocal && exit /B 0
        if /i "!arg1!"=="?" call :usage && endlocal && exit /B 0
        if /i "!arg1!"=="h" call :usage && endlocal && exit /B 0

        :: Version
        if /i "!arg!"=="version" call :version f && goto :end
        if /i "!arg1!"=="v" call :version && goto :end

        :: Quiet
        if /i "!arg1!"=="q" set "opt_quiet=!is_not!" && shift && goto :parse

        :: Verbose
        if /i "!arg!"=="verbose" set "opt_verbose=!is_not!" && shift && goto :parse
        if /i "!arg!"=="e" set "opt_verbose=!is_not!" && shift && goto :parse

        :: Debug
        if /i "!arg!"=="debug" set "opt_debug=!is_not!" && shift && goto :parse
        if /i "!arg1!"=="d" set "opt_debug=!is_not!" && shift && goto :parse

        :: Force
        if /i "!arg1!"=="f" set "opt_force=!is_not!" && shift && goto :parse

        :: Editor
        if /i "!arg!"=="editor" set "opt_force=yes" && set "__editor=%~2" && shift && shift && goto :parse

        :: Handle normal (Windows-based) command-line arguments.
        set args=!args! !arg!

    ) else (
        if defined opt_debug echo %TIME%   is_option == no

        rem My common shorcut/replacements..
        if "[!arg:~0,2!]"=="[~/]" set "arg=%UserProfile%\!arg:~2!"
        if "!arg:~0,2!"=="//" set "arg=%UserProfile%\!arg:~2!"
        if "!arg:~0,3!"=="/~/" set "arg=%UserProfile%\!arg:~3!"
        if "!arg:~0,3!"=="/b/" set "arg=%BIN%\!arg:~3!"
        if "!arg:~0,3!"=="/e/" set "arg=%UserProfile%\Desktop\!arg:~3!"
        if "!arg:~0,3!"=="/d/" set "arg=%UserProfile%\Documents\!arg:~3!"
        if "!arg:~0,3!"=="/w/" set "arg=%UserProfile%\Downloads\!arg:~3!"

        if "!arg!"=="hosts" (
            rem Open the hosts file.
            rem This ignores any specified editor and
            rem ALWAYS opens it in `__default_editor`.
            where /Q sudo >NUL 2>&1
            if !errorlevel! equ 0 (
                echo Opening hosts file..
                if exist "%__default_editor%" start "sudo" sudo "%__default_editor%" "c:\Windows\System32\drivers\etc\hosts"
                if not exist "%__default_editor%" start "sudo" sudo "%__fallback_editor%" "c:\Windows\System32\drivers\etc\hosts"
                endlocal && exit /B 0
            )
            where /Q elevate.cmd >NUL 2>&1
            if !errorlevel! equ 0 (
                echo Opening hosts file..
                if exist "%__default_editor%" start "elevate" elevate.cmd "%__default_editor%" "c:\Windows\System32\drivers\etc\hosts"
                if not exist "%__default_editor%" start "elevate" elevate.cmd "%__fallback_editor%" "c:\Windows\System32\drivers\etc\hosts"
                endlocal && exit /B 0
            )
            set "spec=c:\Windows\System32\drivers\etc\hosts" && shift && goto :main
        ) else (
            rem Since, the argument doesn't start with a '/' or '-',
            rem assume it is a directory or file path, so therefore
            rem replace all '/' characters with '\'..
            if not "!arg:~0,1!"=="/" (
                if not "!arg:~0,1!"=="-" (
                    rem Replace forward-slashes with back-slashes
                    set arg=!arg:/=\!
                    rem Replace dlb-backslashes with a single back-slash
                    set arg=!arg:\\=\!
                )
            )

            set spec=!spec! !arg!
        )
        rem The current argument is NOT an option.
        rem So, assume it is part of the query.
        set "query=!query!%~1*"
    )

    shift
    goto :parse

:main
    if defined opt_debug echo %TIME% :main

    rem Trim the left side of `args` and `spec` (just in case)..
    for /f "tokens=* delims= " %%a in ("!args!") do set args=%%a
    for /f "tokens=* delims= " %%a in ("!spec!") do set spec=%%a

    rem If no editor was passed in, then default to `__default_editor`.
    if "!__editor!"=="" set "__editor=%__default_editor%"

    rem If there is no file specified, jump to `:nofile`.
    if "!spec!"=="" goto :nofile

    if not defined opt_force (
        rem Check if there is a default editor/viewer specified in this file.
        rem For instance, .pdf files are opened automatically in Foxit while
        rem Word documents are opened in Microsoft Word, regardless of what
        rem was specified as the editor.

        call :label_exists label !spec:~-4!
        if not defined label call :label_exists label !spec:~-5!
        if defined label call :!label! __editor
    )

    if exist "!__editor!" (
        if defined opt_verbose echo executing: && echo "!__editor!" !args! "!spec!"
        start "__editor" /D "%CD%" /B "!__editor!" !args! "!spec!"
        endlocal && exit /B 0
    ) else (
        where /Q !__editor!
        if !errorlevel! equ 0 (
            if defined opt_verbose echo executing: && echo "!__editor!" !args! "!spec!"
            start "__editor" /D "%CD%" /B "!__editor!" !args! "!spec!"
            endlocal && exit /B 0
        )

        echo The specified editor does not exist: `!__editor!`
        echo Using fallback editor: `%__fallback_editor%`
        if defined opt_verbose echo executing: && echo "%__fallback_editor%" !args! "!spec!"
        start "__fallback_editor" /D "%CD%" /B "%__fallback_editor%" !args! "!spec!"
        endlocal && exit /B 0
    )

    @endlocal && exit /B 0

:nofile
    :: No file was specified to be open.
    :: Change to the Desktop so that any File Save As dialogs will default there. (doesn't work for notepad.exe..)
    cd /D "%UserProfile%\Desktop"
    if exist "!__editor!" start "__editor" /D "%UserProfile%\Desktop" /B "!__editor!" !args!
    if not exist "!__editor!" start "__fallback_editor" /D "%UserProfile%\Desktop" /B "%__fallback_editor%" !args!
    @endlocal && exit /B 0

:label_exists
    rem ARGS: label_varname extension
    rem set "%~2="
    if defined opt_debug echo %TIME% :label_exists starting: `%~2`

    for /f "tokens=1,2,* delims=_ " %%A in ('"%findstr% %opt_casesensitive% /B /C:":file%~2" "%~f0""') do set "%~1=%%A" && goto :eof

    if defined opt_debug echo %TIME% :label_exists finished: `%~2`
    goto :eof

:file_office
    rem ARGS: envar, appname, appexe
    set "%1="
    set "params=16,15,14,13,12,11"
    for %%i in (%params%) do (
        if exist "%ProgramFiles%\Microsoft Office\Office%%i\%~3" set "%1=%ProgramFiles%\Microsoft Office\Office%%i\%~3" && set "%4=1" && goto :eof
        if exist "%ProgramFiles(x86)%\Microsoft Office\Office%%i\%~3" set "%1=%ProgramFiles(x86)%\Microsoft Office\Office%%i\%~3" && set "%4=1" && goto :eof
    )
    echo Could not find %~2..
    @endlocal && exit /B 1



:file.ans
:file.ansi
:file.asc
:file.ascii
:file.log
:file.patch
:file.text
:file.txt
    rem ARGS: envar
    set "%1=!__default_editor!"
    @endlocal && exit /B 1

:file.csv
:file.tab
    rem ARGS: envar
    set "%1="
    for %%i in ("%bin%" "%bin%\apps\Bricksoft Viewer 3.0" "c:\bin\apps\Bricksoft Viewer 3.0" "c:\Users\Kody\Root\apps\Bricksoft Viewer 3.0") do (
        if exist "%%~i\BricksoftViewer3.0beta.exe" set "%1=%%~i\BricksoftViewer3.0beta.exe" && goto :eof
    )
    echo Could not find Bricksoft Viewer..
    @endlocal && exit /B 1

:file.doc
:file.docx
    rem ARGS: envar
    set "%1="
    call :file_office %~1 Word Winword.exe success
    if defined success goto :eof
    echo Could not find Microsoft Word..
    @endlocal && exit /B 1

:file.exe
:file.dll
    rem ARGS: envar
    set "%1="
    for %%i in ("%bin%\Depends.exe" "%bin%\DependsNet.exe") do (
        if exist "%%~i" set "%1=%%~i" && goto :eof
    )
    echo Could not find Depends.exe..
    @endlocal && exit /B 1

 rem :file.lnk
 rem     rem ARGS: envar
 rem     set "%1="
 rem
 rem     :: Make sure the exportlink.vbs file is accessible.
 rem     where exportlink.vbs >NUL 2>&1
 rem     if %errorlevel% EQU 1 goto :file.lnk_notfound
 rem
 rem     for %%i in ("%bin%" "%bin%\apps\Bricksoft Viewer 3.0" "c:\bin\apps\Bricksoft Viewer 3.0" "c:\Users\Kody\Root\apps\Bricksoft Viewer 3.0") do (
 rem         if exist "%%~i\BricksoftViewer3.0beta.exe" set "%1=%%~i\BricksoftViewer3.0beta.exe" && goto :eof
 rem     )
 rem    :file.lnk_notfound
 rem     echo Could not find exportlink.vbs..
 rem     @endlocal && exit /B 1

:file.markdown
:file.md
    rem ARGS: envar
    set "%1="
    for %%i in ("%bin%\apps\MarkdownPad 2\MarkdownPad2.exe" "%bin%\apps\Sublime Text\sublime_text.exe" "%bin%\apps\Sublime Text 3\sublime_text.exe" "%bin%\apps\Sublime Text 2\sublime_text.exe") do (
        if exist "%%~i" set "%1=%%~i" && goto :eof
    )
    echo Could not find a Markdown editor..
    @endlocal && exit /B 1

:file.pdf
    rem ARGS: envar
    set "%1="
    for %%i in ("%bin%\apps\Foxit Reader" "c:\bin\apps\Foxit Reader" "c:\Users\Kody\Root\apps\Foxit Reader" "%ProgramFiles(x86)%\Foxit Software\Foxit Reader" "%ProgramFiles%\Foxit Software\Foxit Reader" "C:\Program Files (x86)\Foxit Software\Foxit Reader") do (
        if exist "%%~i\Foxit Reader.exe" set "%1=%%~i\Foxit Reader.exe" && goto :eof
    )
    echo Could not find Foxit Reader..
    @endlocal && exit /B 1

:file.ppt
:file.pptx
    rem ARGS: envar
    set "%1="
    call :file_office %~1 PowerPoint Powerpnt.exe success
    if defined success goto :eof
    echo Could not find Microsoft PowerPoint..
    @endlocal && exit /B 1

:file.xls
:file.xlsx
    rem ARGS: envar
    set "%1="
    call :file_office %~1 Excel Excel.exe success
    if defined success goto :eof
    echo Could not find Microsoft Excel..
    @endlocal && exit /B 1
