@echo off

REM Replaces a line in a file,
REM   indicated by the first word of each line.

REM This method takes three arguments:
REM   the file
REM   the word or indicator
REM   the new line contents

setlocal enabledelayedexpansion


set srcfile=filesrc.txt
set infile=file.txt


rem Copy the source file so i don't have to worry about losing it..
copy /y "%srcfile%" "%infile%"


set "LineId=%~1"
set "NewText=%~2"

call :ReplaceInFile %infile% %LineId% "%NewText%"
goto :EOF



:ReplaceInFile
	set tmpfile="%~1.tmp"

	(
		for /f "usebackq tokens=*" %%G in (%~1) do (
			rem %%G  will have each line of file
			
			for /F "tokens=1" %%H in ("%%G") do (
				rem %%H  will have the first word of %%G
				
				if /i "%%H" NEQ "%~2" (
					echo:%%G
				) else (
					echo:%%H	%~3
				)
				
			)
			
			
		)
	) > "%tmpfile%"

	if not %errorlevel% == 0 goto :EOF

	del /f /q "%1"
	rename "%tmpfile%" "%1"

	goto :EOF
