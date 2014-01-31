@echo off

set doskey_macros_loaded=
set doskey_history_loaded=

:: Load up the macros.
call %~dp0alias.bat --load

:: Load up the history.
call %~dp0history.bat --load

exit /B 0
