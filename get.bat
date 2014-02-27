@echo off

:init
	set __batname=%~n0
	set __tmpfile="%TEMP%\%~0_%RANDOM%_%RANDOM%_%RANDOM%.tmp"
	set "__pause="
	set "__all="

	set find=C:\Windows\System32\find.exe

	if "%~1"=="" call :show_usage && goto :main

	call :show_datetime

:parse
	if "%~1"=="" goto :main

	if "%~1"=="/?" call :show_usage && goto :main
	if /i "%~1"=="/help" call :show_usage && goto :main
	if /i "%~1"=="--help" call :show_usage && goto :main
	if /i "%~1"=="-help" call :show_usage && goto :main

	if /i "%~1"=="/p" set "__pause=1" && shift && goto :parse
	if /i "%~1"=="/pause" set "__pause=1" && shift && goto :parse
	if /i "%~1"=="--pause" set "__pause=1" && shift && goto :parse
	if /i "%~1"=="-pause" set "__pause=1" && shift && goto :parse

	if /i "%~1"=="all" call :show_all && goto :main

	call :show_%~1
	shift
	goto :parse

:main
    if exist %__tmpfile% del /Q %__tmpfile%
	if defined __pause set /P _tmp=^>  Press any key to continue
	exit /B 0

:show_usage
	echo GET.bat displays system information
	echo Created 2012-2014 @wasatchwizard
	echo.
	echo USAGE:
	echo type '%__batname% sys' to display machine info.
	echo type '%__batname% ip' to display ip info.
	echo type '%__batname% sid' to display the machine's SID.
	echo type '%__batname% drives' to display drive info.
	echo type '%__batname% apps' to display current running applications.
	echo.
	echo type '%__batname% all' to display all info.
	goto :eof

:show_datetime
	:: Display the date/time
	date /t>%__tmpfile%
	set /P _tmpdate=<%__tmpfile%
	time /t>%__tmpfile%
	set /P _tmptime=<%__tmpfile%
	echo %_tmpdate% %_tmptime%
	goto :eof

:show_all
	rem Start the fall-through for 'all'
	set "__all=1"

:show_i
:show_info
:show_sys
:show_system
:show_sysinfo
	echo.
	echo COMPUTER INFO
	echo ---------------------------------------------------------------------------
	echo USER:      %username%
	echo COMPUTER:  %computername%
	echo DOMAIN:    %userdomain%
	echo ---------------------------------------------------------------------------
	if exist "uptime.exe" call uptime.exe
	if exist "psinfo.exe" call psinfo.exe
	if not defined __all goto :eof

:show_i
:show_ip
	if defined __all goto :skip_ip
	call :show_ip4
	call :show_ip6
	goto :eof
	:skip_ip

:show_4
:show_ip4
:show_ipv4
	echo.
	echo IPv4 ADDRESS
	echo ---------------------------------------------------------------------------
	ipconfig| %find% "IPv4 Address"
	echo ---------------------------------------------------------------------------
	if not defined __all goto :eof

:show_6
:show_ip6
:show_ipv6
	echo.
	echo IPv6 ADDRESS
	echo ---------------------------------------------------------------------------
	ipconfig| %find% "IPv6 Address"
	echo ---------------------------------------------------------------------------
	if not defined __all goto :eof

:show_d
:show_drive
:show_drv
:show_drives
	echo.
	echo DRIVES
	for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		if exist "%%i:\" (
			echo ---------------------------------------------------------------------------
			echo %%i:
			vol %%i:
		)
	)
	echo ---------------------------------------------------------------------------
	rem fsutil volume diskfree c:
	rem fsutil fsinfo drives
	rem fsutil fsinfo drivetype c:
	if not defined __all goto :eof

:show_t
:show_task
:show_tasks
:show_tasks
:show_app
:show_apps
	echo.
	echo Tasks that are not responding
	echo ---------------------------------------------------------------------------
	rem taskkill /FI "STATUS eq not responding"
	tasklist /FI "STATUS eq not responding"
	if not defined __all goto :eof

:show_s
:show_sid
	if defined __all goto :skip_sid
	call :show_ip4
	call :show_ip6
	goto :eof
	:skip_sid

:show_u
:show_usid
:show_usrsid
:show_usersid
	where "psgetsid.exe" >NUL
	if %errorlevel% equ 0 (
		echo.
		echo ---------------------------------------------------------------------------
		call psgetsid.exe \\%computername%
	)
	if not defined __all goto :eof

:show_c
:show_csid
:show_computersid
:show_syssid
	where "psgetsid.exe" >NUL
	if %errorlevel% equ 0 (
		echo.
		echo ---------------------------------------------------------------------------
		call psgetsid.exe %username%
	)
	if not defined __all goto :eof

:end_fallthrough
	:: Finish the fall-through for 'all'
	goto :main
