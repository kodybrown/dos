@setlocal
@echo off

echo bcscript.bat
:init
    set __batname=%~nx0
    set __batfile=%~0
    set __app=Beyond Compare
    set __quiet=

:parse
    if "%~1"=="/?" call :help2 && exit /B 0
    if /i "%~1"=="--help" call :help2 && exit /B 0
    if /i "%~1"=="-help" call :help2 && exit /B 0

    if /i "%~1"=="--quiet" set "__quiet=--quiet" && shift && goto :parse
    if /i "%~1"=="-quiet" set "__quiet=--quiet" && shift && goto :parse

    if "%~1"=="" (
        call :header
        echo      _______________________________________________
        echo     ^|                                               ^|+
        echo     ^|  ARGUMENT #1 IS MISSING                       ^|^|
        echo     ^|  A script file is required.                   ^|^|
        echo     ^|_______________________________________________^|^|
        echo      +-----------------------------------------------+
        call :usage
        endlocal && exit /B 1
    )
    if not exist "%~1" (
        call :header
        echo      _______________________________________________
        echo     ^|                                               ^|+
        echo     ^|  ARGUMENT #1 IS INVALID                       ^|^|
        echo     ^|  The specified script file doesn't exist.     ^|^|
        echo     ^|_______________________________________________^|^|
        echo      +-----------------------------------------------+
        call :usage
        endlocal && exit /B 1
    )

    set __file=%~1

:main
    call bc.bat %__quiet% "@%__file%"
    endlocal && exit /B

:usage
	echo.
    echo USAGE:
	echo   %__batname% scriptfile
	echo.
	goto :eof

:header
    echo %__batname% ^| created 2007-2013 @wasatchwizard
    echo              ^| simple wrapper for Beyond Compare script files.
    goto :eof

:help2
    call :header
    call :usage
    goto :eof
