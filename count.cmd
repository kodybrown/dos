@echo off

rem
rem Counts the number of lines in a file.
rem Sets the errorlevel to the number of lines in the specified file (#arg1).
rem
rem The first argument is the file wherein to count the lines.
rem If there is a second argument, the count will ALSO be written into that file (always overwriting it).
rem
rem Sets errorlevel to 0 if there is an error.
rem
rem Created 2013 @wasatchwizard
rem

set count=0
set file=%~1

if not exist "%file%" exit /B 0

for /f "usebackq tokens=*" %%i in (%file%) do (call :incrementcount "%%i")

if %errorlevel% NEQ 0 exit /B 0

if not "%~2"=="" (
	if exist "%~2" del /F /Q "%~2"
	if %errorlevel% EQU 0 (
		echo %count%>"%~2"
	)
)

exit /B %count%

:incrementcount
	set /a count+=1
	goto :eof
