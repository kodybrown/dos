@setlocal EnableDelayedExpansion
@echo off

if "%~1"=="/?" call :usage && endlocal && exit /B 0
if "%~1"=="help" call :usage && endlocal && exit /B 0
if "%~1"=="--help" call :usage && endlocal && exit /B 0

set _spec=
set _args=

:parse
	if "%~1"=="" goto :main

	set arg=%~1
	set firstChar=%arg:~0,1%

	if "!firstChar!"=="/" (
		set _args=%_args% %arg%
	) else (
		set _spec=*%~1*
	)

	shift
	goto :parse

:main
	rem left-trim the inputs
	for /f "tokens=* delims= " %%a in ("!_args!") do set _args=%%a
	for /f "tokens=* delims= " %%a in ("!_spec!") do set _spec=%%a

	dir /on !_args! "!_spec!"

	@endlocal
	@exit /B 0

:usage
	echo.
	echo Lists files where name contains the value specified.
	echo.
	echo   %~n0
	echo     lists all files.
	echo   %~n0 abc
	echo     lists files that contain `abc` in the name.
	echo   %~n0 [options] abc
	echo     lists files that contain `abc` in the name,
	echo     while also applying the specified options.
	echo.
	echo Created 2004-2013 @wasatchwizard
	goto :eof
