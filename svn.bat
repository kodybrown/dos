@rem svn svn   svn %*    (this file)
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
    svn.exe %*
    exit /B 0

:usage
    for /f %%g in ('dir /b %~dp0s*.bat') do (
        set /p l=<"%~dp0%%g"
        if "!l:~0,8!"=="@rem svn" echo. !l:~9,5! ^> !l:~15,1000!
    )
    exit /B 0
