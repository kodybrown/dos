@echo off

if exist "%bin%\recycle.exe" call "%bin%\recycle.exe" /E /F && exit /B 0
if exist "%bin%\nircmd.exe" call "%bin%\nircmd.exe" emptybin && exit /B 0

start shell:RecycleBinFolder
