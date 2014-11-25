@setlocal EnableDelayedExpansion
@echo off

:parse
    if "%~1"=="-" goto :usage
    if "%~1"=="--" goto :usage
    if "%~1"=="?" goto :usage
    if "%~1"=="/?" goto :usage
    if "%~1"=="--help" goto :usage
    if "%~1"=="-h" goto :usage

:main
    vagrant %*
    exit /B 0

:usage
    echo va.bat ^> vagrant %%*    ^(this file^)
    for /f %%g in ('dir /b %~dp0v*.bat') do (
        set /p l=<"%~dp0%%g"
        if "!l:~1,7!"=="vagrant" echo %%~nxg ^> !l:~1,1000!
    )
    exit /B 0
