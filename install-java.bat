@setlocal EnableDelayedExpansion
@echo off

:: Name this batch file whatever you want and pass in the installer executable
:: as the first argument. You can also drag and drop the exe onto this batch file
:: in Windows Explorer.
:: Expected filename of the first argument should be like this:
::     jdk-8u25-windows-x64.exe

:init
	if not "%~1"=="" (
		:: Use the first argument as the installer name.
		set "filename=%~n1"
		set "exename=%~nx1"
		set "orig_exename=%~nx1"
	) else (
		echo usage: %~nx0 jdk-8u25-windows-x64.exe
		endlocal & exit /B 1
	)

	if not exist "!exename!" if exist "c:\installers\Java\!orig_exename!" (
		set "exename=c:\installers\Java\!orig_exename!"
	)
	if not exist "!exename!" if exist "\installers\Java\!orig_exename!" (
		set "exename=\installers\Java\!orig_exename!"
	)
	if not exist "!exename!" echo Could not find: !orig_exename! & goto :end

	:: jdk or jre?
	set "_type=!filename:~0,3!"

	:: Get the version.
	set "_ver=!filename:~4,4!"

	:: Get the platform.
	if "!filename:~-4!"=="-x64" (
		set "_plat="
	) else (
		set "_plat=-x86"
	)

	:: Enable/disable the log.
	rem set "log=/log ""!filename!-install.log"""
	set "log="

	:: Default to using the jdk default installation path.
	set "installdir="

	:: Uncomment the following for all jdk's to be installed like this:
	::     c:\tools\java_!_type!\6u41
	::     c:\tools\java_!_type!\7u12
	::     c:\tools\java_!_type!\8u25
	::     c:\tools\java_!_type!\8u25-x86
	rem set "basedir=c:\tools\java_!_type!"
	rem set "installdir=!basedir!\!_ver!!_plat!"

	:: Uncomment the following to target the Program Files directories
	:: for the installations. All jdk's will be installed like this:
	::     %ProgramFiles%\Java\!_type!1.6.0_41
	::     %ProgramFiles%\Java\!_type!1.7.0_12
	::     %ProgramFiles%\Java\!_type!1.8.0_25
	::     %ProgramFiles(x86)%\Java\!_type!1.8.0_25
	if "!filename:~-4!"=="-x64" (
		set "basedir=%ProgramFiles%\Java"
	) else (
		set "basedir=%ProgramFiles(x86)%\Java"
	)
	set "installdir=!basedir!\!_type!1.!_ver:~0,1!.0_!_ver:~2,2!"

	:: Set any version-specific options
	set "options="
	if "!_ver:~0,1!"=="7" (
		rem set "options=/passive"
		set "options=/s"
	) else if "!_ver:~0,1!"=="8" (
		set "options=/s"
	) else (
	 	echo Unsupported version/file.
	 	endlocal & exit /B 2
	)

:main
	:: Install the JDK.
	echo About to install:
	echo   !exename!
	echo to:
	if not "!installdir!"=="" (
		echo   "!installdir!"
	) else (
		echo   ^<default^>
	)
	echo.
	echo.
	set /P "val=Continue? [Y/n] "
	echo.
	if not "!val!"=="" if /i not "!val:~0,1!"=="y" echo Canceled. & endlocal & exit /B 0

	:: Set flags
	if not "!installdir!"=="" (
		set installdir=INSTALLDIR="!installdir!"
	)

	if "!_type!"=="jre" (
		rem works: jre-7u79-windows-x64.exe /s INSTALLDIR=\"C:\\Program Files\\Java\\jre1.7.0_79\"
		set "INSTALLDIR=!INSTALLDIR:\=\\!"
		set "INSTALLDIR=!INSTALLDIR:"=\"!"
	)

	rem ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"

	echo.
	echo Executing:
	echo     "!exename!" !options! !log! !installdir!
	echo.

	call start "!_type!" /WAIT "!exename!" !options! !log! !installdir!
	if %errorlevel% NEQ 0 echo error code #%errorlevel% occurred & pause

:end
	endlocal & exit /B
