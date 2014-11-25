@setlocal EnableDelayedExpansion
@echo off

goto :init

:usage
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

:init
	set "__quiet="
	set "__verbose="
	set "__debug="

	set "spec="
	set "args=/W "

:parse
	if "%~1"=="" goto :main

	if /i "%~1"=="/?" call :usage && endlocal && exit /B 0
	if /i "%~1"=="--help" call :usage && endlocal && exit /B 0
	if /i "%~1"=="-help" call :usage && endlocal && exit /B 0

	if /i "%~1"=="--quiet" set "__quiet=1" && shift && goto :parse
	if /i "%~1"=="--verbose" set "__verbose=1" && shift && goto :parse
	if /i "%~1"=="--debug" set "__debug=1" && shift && goto :parse

	set arg=%~1

	rem My common shorcut/replacements..
	if "[!arg:~0,2!]"=="[~/]" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,2!"=="//" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,3!"=="/~/" set arg=%UserProfile%\!arg:~3!
	if "!arg:~0,3!"=="/b/" set arg=%bin%\!arg:~3!
	if "!arg:~0,3!"=="/e/" set arg=%UserProfile%\Desktop\!arg:~3!
	if "!arg:~0,3!"=="/d/" set arg=%UserProfile%\Documents\!arg:~3!
	if "!arg:~0,3!"=="/w/" set arg=%UserProfile%\Downloads\!arg:~3!

	if defined __debug echo 0-1
rem echo arg=!arg!
	rem Handle command-line arguments.
	if "!arg:~0,1!"=="/" (
		rem Handle normal (Windows-based) command-line arguments.
		if defined __debug echo 0.1
		set args=!args! !arg!
	) else (
		if defined __debug echo 0.2
rem echo "!arg:~0,1!"
		if "!arg:~0,1!"=="-" (
			if defined __debug echo 0.2.1
			rem Convert from Linux-based `ls` commands to Windows' `dir` equivalent.
			if /i "!arg!"=="-a" (
				rem -a == show hidden files
				if defined __debug echo 0.2.1.1
				rem set args=!args! /ahsrald
			) else if /i "!arg!"=="-l" (
				echo -l == long listing / full details
				if defined __debug echo 0.2.1.2
				set args=!args! /-W
			) else if /i "!arg!"=="-r" (
				rem -r == recursive
				if defined __debug echo 0.2.1.3
				set args=!args! /S
			) else if /i "!arg!"=="-c" (
				rem -c == sort by last modification
				if defined __debug echo 0.2.1.4
				set args=!args! /OD
			) else if "!arg!"=="-1" (
				rem -1 == Print one entry per line of output.
				if defined __debug echo 0.2.1.5
				set args=!args! /B
			)
			shift
			goto :parse
		) else (
			if defined __debug echo 0.2.2
			rem Since, the argument doesn't start with a '/' or '-',
			rem assume it is a directory or file path, so therefore
			rem replace all '/' characters with '\'..
			if not "!arg:~0,1!"=="/" (
				if defined __debug echo 0.2.2.1
				if not "!arg:~0,1!"=="-" (
					if defined __debug echo 0.2.2.1.1
					rem Replace dlb-backslashes with a single back-slash
					set arg=!arg:\\=\!
					rem Replace forward-slashes with back-slashes
					set arg=!arg:/=\!
				)
			)
		)

		if defined __debug echo 0.2.end
		set spec=!spec! !arg!
	)

	if defined __debug echo 0.end

	shift
	goto :parse

:main
	rem left-trim the inputs
	for /f "tokens=* delims= " %%a in ("!args!") do set args=%%a
	for /f "tokens=* delims= " %%a in ("!spec!") do set spec=%%a

	rem Apply a default sorting order,
	rem assuming the user didn't also specify a '/O' sort..
	call :contains "!args!" "/O" result
	if not defined result set args=/ON !args!

	if defined __verbose echo executing: && echo DIR !args! "!spec!" && echo.
	dir !args! "!spec!"

	if %errorlevel% neq 0 echo. && echo executed: && echo DIR !args! "!spec!" && echo.

	endlocal && exit /B %errorlevel%

:contains
	set "tosearch_orig=%~1"
	set "tosearch=%~1"
	set "tofind=%~2"
	set "resultvar=%~3"

	if "%tosearch%"=="" set "%resultvar%=" && goto :eof

	rem Remove the string we're looking for..
	set tosearch=%tosearch:%%tofind%%=%

	rem If the source and the new search string don't match,
	rem it contains the string we're looking for.
	if "!tosearch!"=="%tosearch_orig%" (
		set "%resultvar%="
	) else (
		set "%resultvar%=true"
	)
	goto :eof
