@echo off

:init
    set __verbose=

:parse
    if "%~1"=="" goto :main

    if "%~1"=="/?" call :usage "%~2" && exit /B 0
    if /i "%~1"=="-help" call :usage "%~2" && exit /B 0
    if /i "%~1"=="--help" call :usage "%~2" && exit /B 0

    if /i "%~1"=="/v" set "__verbose=1" && shift && goto :parse
    if /i "%~1"=="/verbose" set "__verbose=1" && shift && goto :parse
    if /i "%~1"=="-verbose" set "__verbose=1" && shift && goto :parse
    if /i "%~1"=="--verbose" set "__verbose=1" && shift && goto :parse

    if defined __verbose echo Searching for '%~1'..
    if exist "%~1" (
        cd /D "%~1"
        if defined __verbose echo Changed directory to '%~1%'
        exit /B 0
    )

    shift
    goto :parse

:main
    if defined __verbose echo Did not find any of the specified directories.
    exit /B 1

:usage
    echo cdor.bat - change to the first argument (directory) that exists.
    echo Created 2010 Kody Brown (@wasatchwizard)
    echo Use at your own risk. No warranty is expressed or implied.
    echo.
    echo USAGE:
    echo   %~nx0 [-verbose] "path 1" path2 path3 "path 4 etc"
    echo.
    goto :eof

