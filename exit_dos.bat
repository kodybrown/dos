@echo off

:: Save the macros.
call %~dp0alias.bat --save

:: Save the command history.
call %~dp0history.bat --save

exit
