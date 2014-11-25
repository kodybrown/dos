@echo off

:: set_ipaddr_envar.bat

:init
	set __ipconfig=C:\Windows\System32\ipconfig.exe
	set __find=C:\Windows\System32\find.exe

	set tmpfile=%temp%\ipaddr.%random%.txt

:main

	call %__ipconfig% | %__find% "IPv4 Address">"%tmpfile%"
	::call cat %tmpfile%

	:: Read the first line back in from the file.
	set /p ipaddr= <"%tmpfile%"

	:: Trim the line.
	for /f "tokens=* delims= " %%a in ("%ipaddr%") do set ipaddr=%%a

	:: remove the leading text.
	set ipaddr=%ipaddr:IPv4 Address=%

	:: remove all of the `. `.
	set ipaddr=%ipaddr:. =%

	:: remove the `: `.
	set ipaddr=%ipaddr:: =%


:cleanup
	set "__ipconfig="
	set "__find="

	if exist "%tmpfile%" del /Q "%tmpfile%"
	set "tmpfile="

	exit /B %errorlevel%
