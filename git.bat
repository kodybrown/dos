@rem git git   git %*    (this file)
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
    git.exe %*
    exit /B 0

:usage
	echo  batch   command
	echo ------- ----------------------------------------
    for /f %%g in ('dir /b %~dp0g*.bat') do (
        set /p l=<"%~dp0%%g"
        if "!l:~0,8!"=="@rem git" echo. !l:~9,5!   !l:~15,1000!
    )
    exit /B 0
