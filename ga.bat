@echo off
@rem "%~dp0git.bat" add %*

if "%1"=="" (
	"%~dp0git.bat" add .
) else (
	"%~dp0git.bat" add %*
)