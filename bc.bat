@setlocal EnableDelayedExpansion
@echo off

:init
	set __batname=%~nx0
	set __batfile=%~0
	set __app=Beyond Compare
	set __quiet=
	set /a __wait=1

	set __bc=
	set cmds=
    set showname=

:parse
    if "%~1"=="" goto :main

	if "%~1"=="/?" call :usage && endlocal && exit /B 0
	if /i "%~1"=="--help" call :usage && endlocal && exit /B 0
	if /i "%~1"=="-help" call :usage && endlocal && exit /B 0

	if /i "%~1"=="--online" call :usage online && endlocal && exit /B 0
	if /i "%~1"=="-online" call :usage online && endlocal && exit /B 0
	if /i "%~1"=="--online-help" call :usage online && endlocal && exit /B 0

	if /i "%~1"=="--quiet" set __quiet=true && shift && goto :parse
	if /i "%~1"=="-quiet" set __quiet=true && shift && goto :parse

	if /i "%~1"=="-" set /a __wait=0 && shift && goto :parse
	if /i "%~1"=="--" set /a __wait=0 && shift && goto :parse

    set arg=%~1
    rem echo !arg:~0,1!

    rem :: If the argument contains '~/' then replace it with %UserProfile%
    rem if "!arg:~0,2!"=="~\" (
    rem     set arg=!arg:~/=%UserProfile%!
    rem     echo arg=!arg!
    rem )

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

    set cmds=%cmds% %arg%

    shift
    goto :parse

:main
	rem call :findbc
	rem set __bc=%bin%\apps\Beyond Compare 3\BCompare.exe
	set __bc=%bin%\apps\Beyond Compare 4\BCompare.exe
    rem echo __bc==%__bc%

	if exist "%__bc%" (
		if not defined __quiet echo Opening %__app%..

		rem if %__wait% EQU 0 start "beyond compare" "%__app%" /b "%__bc%" %*
		rem if %__wait% NEQ 0 call "%__app%" /b "%__bc%" %*

        rem left-trim the input
        for /f "tokens=* delims= " %%a in ("!cmds!") do set cmds=%%a

		if defined showname echo "%__bc%" %cmds% && set "showname="

		start "%__app%" /b "%__bc%" %cmds%

	    endlocal && set "__bc=%__bc%" && exit /B %errorlevel%
	)

	echo Could not find %__app%
	endlocal && set "__bc=" && exit /B 0

:usage
	echo %__batname% ^| Created 2010-2013 @wasatchwizard
	echo        ^| Executes Beyond Compare, trying numerous install locations.
	echo        ^| Tries to find v4, then v3, but will resort to v2 if necessary.
	echo.
	echo USAGE:
	echo   %__batname% [options] file1 file2
	echo   %__batname% [options] path1 path2
	echo.
	echo All arguments are passed to Beyond Compare as is.
	echo.

	if /i "%~1"=="online" (
		echo Opening online help..
		start "BCOnlineHelp" "http://www.scootersoftware.com/help/index.html?command_line_reference.html"
	) else (
		echo For online help for Beyond Compare type `%__batname% --online-help`,
		echo which will open: http://www.scootersoftware.com/help/index.html?command_line_reference.html
	)

	goto :eof

 rem :findbc
 rem 	rem Try to find v4 first..
 rem     if exist "%bin%\apps\Beyond Compare 4\BCompare.exe" set "__bc=%BIN%\apps\Beyond Compare 4\BCompare.exe" && goto :eof
 rem     if exist "C:\bin\apps\Beyond Compare 4\BCompare.exe" set "__bc=C:\bin\apps\Beyond Compare 4\BCompare.exe" && goto :eof
 rem     if exist "%Profile%\Root\apps\Beyond Compare 4\BCompare.exe" set "__bc=%Profile%\Root\apps\Beyond Compare 4\BCompare.exe" && goto :eof
 rem     if exist "T:\bin\apps\Beyond Compare 4\BCompare.exe" set "__bc=T:\root\apps\Beyond Compare 4\BCompare.exe" && goto :eof
 rem     if exist "C:\Program Files (x86)\Beyond Compare 4\BCompare.exe" set "__bc=c:\Program Files (x86)\Beyond Compare 4\BCompare.exe" && goto :eof
 rem     if exist "C:\Program Files\Beyond Compare 4\BCompare.exe" set "__bc=C:\Program Files\Beyond Compare 4\BCompare.exe" && goto :eof
 rem
 rem     rem Try to find v3..
 rem 	if exist "%bin%\apps\Beyond Compare 3\BCompare.exe" set "__bc=%BIN%\apps\Beyond Compare 3\BCompare.exe" && goto :eof
 rem 	if exist "C:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=C:\bin\apps\Beyond Compare 3\BCompare.exe" && goto :eof
 rem 	if exist "%Profile%\Root\apps\Beyond Compare 3\BCompare.exe" set "__bc=%Profile%\Root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
 rem 	if exist "T:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=T:\root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
 rem     if exist "C:\Program Files (x86)\Beyond Compare 3\BCompare.exe" set "__bc=c:\Program Files (x86)\Beyond Compare 3\BCompare.exe" && goto :eof
 rem 	if exist "C:\Program Files\Beyond Compare 3\BCompare.exe" set "__bc=C:\Program Files\Beyond Compare 3\BCompare.exe" && goto :eof
 rem
 rem 	rem May as well try v2..
 rem 	if exist "%bin%\apps\Beyond Compare 2\BC2.exe" set "__bc=%BIN%\apps\Beyond Compare 2\BC2.exe" && goto :eof
 rem 	if exist "C:\bin\apps\Beyond Compare 2\BC2.exe" set "__bc=C:\bin\apps\Beyond Compare 2\BC2.exe" && goto :eof
 rem 	if exist "C:\root\apps\Beyond Compare 2\BC2.exe" set "__bc=C:\root\apps\Beyond Compare 2\BC2.exe" && goto :eof
 rem 	if exist "%Profile%\Root\apps\Beyond Compare 2\BC2.exe" set "__bc=%Profile%\Root\Apps\Beyond Compare 2\BC2.exe" && goto :eof
 rem 	if exist "T:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=T:\root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
 rem 	if exist "C:\Program Files (x86)\Beyond Compare 2\BC2.exe" set "__bc=C:\Program Files (x86)\Beyond Compare 2\BC2.exe" && goto :eof
 rem
 rem 	set "__bc="
 rem 	goto :eof
