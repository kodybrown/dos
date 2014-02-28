@setlocal EnableDelayedExpansion
@echo off

rem +++++++++++++++++++
rem  OPTIONAL:
rem    attr.exe [https://github.com/kodybrown/attr]
rem +++++++++++++++++++

:init
    if "%~1"=="" call :usage && exit /B 1

	set where="C:\Windows\System32\where.exe"

    call %where% sleep >NUL 2>&1
    if %errorlevel% EQU 0 set __sleep=found
    set __verbose=true

:parse
    if "%~1"=="" goto :main

    if "%~1"=="/?" call :usage && exit /B 0
    if "%~1"=="-help" call :usage && exit /B 0
    if "%~1"=="--help" call :usage && exit /B 0

    if "%~1"=="--verbose" set __verbose=true && shift && goto :parse
    if "%~1"=="-verbose" set __verbose=true && shift && goto :parse

    if exist "%~1" (
        call :getutil attr.exe attr
        if exist "!attr!" (
            attr.exe +ash "%~1"
        ) else (
            attrib -r -s -h "%~1"
            attrib +a +s +h "%~1"
        )
        if defined __verbose echo Successfully hid '%~nx1'!
    ) else (
        echo ERROR: The specified file was not found:
        echo        `%~1`
        echo.
        call :usage
    )

    shift
    goto :parse

:main
    if defined __sleep call sleep 250
    exit /B 0

:usage
    echo Hides the specified file(s).
    echo Created 2009-2014 @wasatchwizard.
    echo Released under the MIT License.
    echo.
    echo USAGE:
    echo   %~nx0 filename [filename...n]
    goto :eof

:getutil
    set tmpfile=%TEMP%\getutil-%RANDOM%%RANDOM%.txt
    where "%~1">%tmpfile%
    set /p tmpval=<%tmpfile%
    set %2=%tmpval%
    set tmpval=
    if exist "%tmpfile%" del /F /Q "%tmpfile%"
    goto :eof
