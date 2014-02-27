@setlocal
@echo off

:init
	set __batname=%~nx0
	set __batfile=%~0
	set __app=Beyond Compare
	set __quiet=
	set /a __wait=1

	set "args="
	set "__bc="

:parse
	if "%~1"=="/?" call :usage && endlocal && exit /B 0
	if /i "%~1"=="--help" call :usage && endlocal && exit /B 0
	if /i "%~1"=="-help" call :usage && endlocal && exit /B 0

	if /i "%~1"=="--online" call :usage online && endlocal && exit /B 0
	if /i "%~1"=="-online" call :usage online && endlocal && exit /B 0
	if /i "%~1"=="--online-help" call :usage online && endlocal && exit /B 0

	if /i "%~1"=="--quiet" set __quiet=true && shift && goto :parse
	if /i "%~1"=="-quiet" set __quiet=true && shift && goto :parse

	if /i "%~1"=="-" set /a __wait=0 && shift && goto :parse
	if /i "%~1"=="--" set /a __wait=0 && shift && goto :parse

:main
	rem call :findbc
	set __bc=%bin%\apps\Beyond Compare 3\BCompare.exe
    rem echo __bc==%__bc%

	if exist "%__bc%" (
		if not defined __quiet echo Opening %__app%..

		rem if %__wait% EQU 0 start "beyond compare" "%__app%" /b "%__bc%" %*
		rem if %__wait% NEQ 0 call "%__app%" /b "%__bc%" %*
		start "%__app%" /b "%__bc%" %*

	    endlocal && set "__bc=%__bc%" && exit /B 0
	)

	echo Could not find %__app%
	endlocal && set "__bc=" && exit /B 0

:usage
	echo %__batname% ^| Created 2010-2013 @wasatchwizard
	echo        ^| Executes Beyond Compare, trying numerous install locations.
	echo        ^| Tries to find v3, but will resort to v2 if necessary.
	echo.
	echo USAGE:
	echo   %__batname% [options] file1 file2
	echo   %__batname% [options] path1 path2
	echo.
	echo All arguments are passed to Beyond Compare as is.
	echo.

	if /i "%~1"=="online" (
		echo Opening online help..
		start "BCOnlineHelp" "http://www.scootersoftware.com/help/index.html?command_line_reference.html"
	) else (
		echo For online help for Beyond Compare type `%__batname% --online-help`,
		echo which will open: http://www.scootersoftware.com/help/index.html?command_line_reference.html
	)

	goto :eof

:findbc
	rem Try to find v3 first..
	if exist "%bin%\apps\Beyond Compare 3\BCompare.exe" set "__bc=%BIN%\apps\Beyond Compare 3\BCompare.exe" && goto :eof
	if exist "C:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=C:\bin\apps\Beyond Compare 3\BCompare.exe" && goto :eof
	if exist "%Profile%\Root\apps\Beyond Compare 3\BCompare.exe" set "__bc=%Profile%\Root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
	if exist "T:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=T:\root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
    if exist "C:\Program Files (x86)\Beyond Compare 3\BCompare.exe" set "__bc=c:\Program Files (x86)\Beyond Compare 3\BCompare.exe" && goto :eof
	if exist "C:\Program Files\Beyond Compare 3\BCompare.exe" set "__bc=C:\Program Files\Beyond Compare 3\BCompare.exe" && goto :eof

	rem Since, we couldn't find v3, so try v2 instead..
	if exist "%bin%\apps\Beyond Compare 2\BC2.exe" set "__bc=%BIN%\apps\Beyond Compare 2\BC2.exe" && goto :eof
	if exist "C:\bin\apps\Beyond Compare 2\BC2.exe" set "__bc=C:\bin\apps\Beyond Compare 2\BC2.exe" && goto :eof
	if exist "C:\root\apps\Beyond Compare 2\BC2.exe" set "__bc=C:\root\apps\Beyond Compare 2\BC2.exe" && goto :eof
	if exist "%Profile%\Root\apps\Beyond Compare 2\BC2.exe" set "__bc=%Profile%\Root\Apps\Beyond Compare 2\BC2.exe" && goto :eof
	if exist "T:\bin\apps\Beyond Compare 3\BCompare.exe" set "__bc=T:\root\apps\Beyond Compare 3\BCompare.exe" && goto :eof
	if exist "C:\Program Files (x86)\Beyond Compare 2\BC2.exe" set "__bc=C:\Program Files (x86)\Beyond Compare 2\BC2.exe" && goto :eof

	set "__bc="
	goto :eof
