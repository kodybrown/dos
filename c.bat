@echo off

rem Change to directory via arguments or from a menu.
rem Author: Kody Brown (thewizard@wasatchwizard.com)
rem Created 2004-05-25 @wasatchwizard
rem Copyright: Free

rem +++++++++++++++++++
rem  REQUIRES:
rem    hdchoice.exe
rem +++++++++++++++++++

:init
	set key=
	set arg=

	if "%~1"=="" goto :displaymenu

:parse
	if "%~1"=="" goto :main

	if not defined key (
		set key=%~1
	) else if not defined arg (
		set arg=%~1
	) else (
		goto :main
	)

	shift
	goto :parse

:main
	if /i "%key%"=="\" cd \ && exit /B 0

	if /i "%key%"=="i" goto :editonly
	if /i "%key%"=="edit" goto :editonly

	rem Go to 'my' user directory, which may or may
	rem not be the '%UserProfile%' directory.
	if /i "%key%"=="~" goto :cd_user
	if /i "%key%"=="~/" goto :cd_user
	if /i "%key%"=="home" goto :cd_user
	if /i "%key%"=="kody" goto :cd_user

	rem Go to the '%UserProfile%' directory.
	if /i "%key%"=="u" goto :cd_userprofile
	if /i "%key%"=="usr" goto :cd_userprofile
	if /i "%key%"=="user" goto :cd_userprofile
	if /i "%key%"=="userprofile" goto :cd_userprofile

	rem Go to the bin directory ('%BIN%' or 'C:\bin').
	if /i "%key%"=="b" goto :cd_bin
	if /i "%key%"=="bin" goto :cd_bin

	rem Go to my bin\help directory ('%BIN%\help').
	if /i "%key%"=="h" set arg=help && goto :cd_bin
	if /i "%key%"=="help" set arg=help && goto :cd_bin

	rem Go to the root directory ('%PROFILE%\Root').
	if /i "%key%"=="t" goto :cd_bin
	if /i "%key%"=="root" goto :cd_bin

	rem Go to the desktop directory.
	if /i "%key%"=="e" goto :cd_desktop
	if /i "%key%"=="desktop" goto :cd_desktop

	rem Go to the documents directory.
	if /i "%key%"=="d" goto :cd_docs
	if /i "%key%"=="documents" goto :cd_docs
	if /i "%key%"=="docs" goto :cd_docs

	rem Go to the downloads directory.
	if /i "%key%"=="w" goto :cd_downloads
	if /i "%key%"=="downloads" goto :cd_downloads

	rem Go to the code directory.
	if /i "%key%"=="c" goto :cd_code
	if /i "%key%"=="code" goto :cd_code

	rem Go to the journal directory.
	if /i "%key%"=="j" goto :cd_journal
	if /i "%key%"=="journal" goto :cd_journal

	rem Go to the current month's journal directory.
	if /i "%key%"=="jc" goto :cd_journal_currentmonth
	if /i "%key%"=="m" goto :cd_journal_currentmonth
	if /i "%key%"=="curmo" goto :cd_journal_currentmonth
	if /i "%key%"=="currentmonth" goto :cd_journal_currentmonth

	rem Go to the last month's journal directory.
	if /i "%key%"=="jl" goto :cd_journal_lastmonth
	if /i "%key%"=="l" goto :cd_journal_lastmonth
	if /i "%key%"=="lastmo" goto :cd_journal_lastmonth
	if /i "%key%"=="lastmonth" goto :cd_journal_lastmonth

	rem Go to the serial numbers directory.
	if /i "%key%"=="js" goto :cd_serials
	if /i "%key%"=="s" goto :cd_serials
	if /i "%key%"=="serial" goto :cd_serials
	if /i "%key%"=="serials" goto :cd_serials
	if /i "%key%"=="serialnum" goto :cd_serials
	if /i "%key%"=="serialnums" goto :cd_serials

	rem Go to the cheat-sheats directory ('%PROFILE%\.cheats').
	if /i "%key%"=="cheats" goto :cd_cheatsheets
	if /i "%key%"=="cheatsheets" goto :cd_cheatsheets
	if /i "%key%"=="sheets" goto :cd_cheatsheets

	rem Go to the obeo (source) directory ('C:\obeo').
	if /i "%key%"=="o" goto :cd_obeo
	if /i "%key%"=="obeo" goto :cd_obeo

	rem Go to my temp directory ('C:\temp').
	if /i "%key%"=="x" goto :cd_temp
	if /i "%key%"=="temp" goto :cd_temp

	rem Go to the user's temp directory ('C:\Users\UserName\AppData\Local\Temp').
	if /i "%key%"=="usertemp" goto :cd_temp_user
	if /i "%key%"=="usrtemp" goto :cd_temp_user

	rem Go to the system temp directory ('C:\Windows\Temp').
	if /i "%key%"=="systemp" goto :cd_temp_system
	if /i "%key%"=="systemtemp" goto :cd_temp_system

	rem Go to the program files directory ('C:\Program Files').
	if %key% EQU 6 goto :cd_progfiles
	if /i "%key%"=="programs" goto :cd_progfiles
	if /i "%key%"=="progfiles" goto :cd_progfiles
	if /i "%key%"=="programfiles" goto :cd_progfiles

	rem Go to the program files (x86) directory ('C:\Program Files (x86)').
	if %key% EQU 8 goto :cd_progfiles86
	if /i "%key%"=="x86" goto :cd_progfiles86
	if /i "%key%"=="programs86" goto :cd_progfiles86
	if /i "%key%"=="progfiles86" goto :cd_progfiles86
	if /i "%key%"=="programfiles86" goto :cd_progfiles86

	if /i "%key%"=="a" goto :cd_venafi
	if /i "%key%"=="venafi" goto :cd_venafi

	if %key% EQU 1 goto :cd_recent
	if /i "%key%"=="recent" goto :cd_recent

	rem if /i "%key%"=="v" call vsvars.bat && exit /B 0

	if exist "%~dp0pcolor.exe" ( "%~dp0pcolor.exe" {Red}Invalid argument: %key% ) else ( echo Invalid argument: %key% )
	if not defined __quiet (
		if exist "%~dp0sleep.exe" ( "%~dp0sleep.exe" 200 ) else ( pause )
	)

	exit /B 1


:displaymenu
	rem If an argument was not provided ask the user for one.

	echo.
	if exist "%~dp0pcolor.exe" (
		"%~dp0pcolor.exe" -crlf "{white}  Directories Menu" \n "{gray} ----------------------------------------------------------" \n "{gray} Commands:" ed^({white}i{gray}^)t, ^({white}r{gray}^)efresh, and ^({white}q{gray}^)uit \n
	) else (
		echo   Directories Menu
		echo   ----------------------------------------------------------
		echo   Commands ed^(i^)t, ^(r^)efresh, and ^(q^)uit
	)

	rem When adding or removing directories, be sure to upate it in
	rem all three required places: 1) menu, 2) hdchoice command, and 3) if statement.
	rem Also remember that ed<i>t, <r>efresh, and <q>uit are reserved.
	echo   ----------------------------------------------------------
	echo   (d) %%Profile%%\Documents
	echo   (e) %%Profile%%\Desktop
	echo   (w) C:\downloads
	echo   (u) %%UserProfile%%
	echo   (p) %%Profile%%
	echo   (t) %%Profile%%\Root
	echo   (b) %%BIN%%
	echo   (h) %%BIN%%\help
	echo.
	echo   (j) %%Profile%%\Documents\Journal
	echo   (m) %%Profile%%\Documents\Journal\(Dates)\Current Month
	echo   (l) %%Profile%%\Documents\Journal\(Dates)\Last Month
	echo   (s) %%Profile%%\Documents\Journal\Serial numbers
	echo.
	echo   (c) C:\code
	echo   (o) C:\obeo
	echo   (k) C:\kynetx
	echo.
	echo   (6) C:\Program Files
	echo   (8) C:\Program Files (x86)
	echo   (x) C:\Temp
	echo.
	echo   (1) Recent files
	echo   ----------------------------------------------------------
	echo.

	"%~dp0hdchoice.exe" /C:irqudcthvboxwe68ajms1lpb /N

	if exist "%~dp0clearline.exe" call "%~dp0clearline.exe" -10

	rem if the first argument matches a command, override the errorlevel to execute it below
	rem execute the specified command here
	if %ERRORLEVEL% equ 1 goto :editmenu
	if %ERRORLEVEL% equ 2 goto :displaymenu
	if %ERRORLEVEL% equ 3 exit /B 0

	if %ERRORLEVEL% equ 4 (
		if exist "%UserProfile%" (
			cd /D "%UserProfile%" && exit /B 0
		) else if exist "T:\Users\Kody" (
			cd /D "T:\Users\Kody" && exit /B 0
		)
	)

	if %ERRORLEVEL% equ 5 call "%~dp0cdd.bat" Documents && exit /B 0
	if %ERRORLEVEL% equ 6 call "%~dp0cdd.bat" code && exit /B 0
	if %ERRORLEVEL% equ 7 call "%~dp0cdd.bat" Root && exit /B 0
	if %ERRORLEVEL% equ 8 call "%~dp0cdd.bat" Cheatsheets && exit /B 0
	if %ERRORLEVEL% equ 9 call vsvars.bat
	if %ERRORLEVEL% equ 10 call "%~dp0cdd.bat" User && exit /B 0
	if %ERRORLEVEL% equ 11 call "%~dp0cdd.bat" Obeo && exit /B 0
	if %ERRORLEVEL% equ 12 call "%~dp0cdd.bat" Temp && exit /B 0
	if %ERRORLEVEL% equ 13 call "%~dp0cdd.bat" Downloads && exit /B 0
	if %ERRORLEVEL% equ 14 call "%~dp0cdd.bat" Desktop && exit /B 0
	if %ERRORLEVEL% equ 15 call "%~dp0cdd.bat" ProgFiles && exit /B 0
	if %ERRORLEVEL% equ 16 call "%~dp0cdd.bat" ProgFiles86 && exit /B 0
	if %ERRORLEVEL% equ 17 call "%~dp0cdd.bat" Venafi && exit /B 0
	if %ERRORLEVEL% equ 18 call "%~dp0cdd.bat" Journal && exit /B 0
	if %ERRORLEVEL% equ 19 call "%~dp0cdd.bat" CurrentJournal && exit /B 0
	if %ERRORLEVEL% equ 20 call "%~dp0cdd.bat" Serials && exit /B 0
	if %ERRORLEVEL% equ 21 call "%~dp0cdd.bat" Recent && exit /B 0

	if %ERRORLEVEL% equ 22 call "%~dp0cdd.bat" profile && exit /B 0
	if %ERRORLEVEL% equ 23 call "%~dp0cdd.bat" bin && exit /B 0

	exit /B 0

:editmenu
	start "edit" /WAIT "%~dp0Notepad2.exe" "%~dp0c.bat"
	goto :displaymenu
	exit /B 0

:editonly
	start "edit" "%~dp0Notepad2.exe" "%~dp0c.bat"
	exit /B 0

:setdatevars
	rem sets global variables to the current date (mm, dd, yy) -- `yy` actually outputs `yyyy`
	for /f "tokens=1-3 delims=/.- " %%A in ("%date:* =%") do (
		set mm=%%A
		set dd=%%B
		set yy=%%C
		goto :eof
	)
	goto :eof

:settimevars
	:: sets global variables to the current time (hh, nn, ss, ii)
	for /f "tokens=1-4 delims=:. " %%A in ("%time: =0%") do (
		set hh=%%A
		set nn=%%B
		set ss=%%C
		set ii=%%D
	)
	goto :eof

:setmonthnamevars
	set month01=January
	set month02=February
	set month03=March
	set month04=April
	set month05=May
	set month06=June
	set month07=July
	set month08=August
	set month09=September
	set month10=October
	set month11=November
	set month12=December
	goto :eof

:errorpath
	echo.
	echo Could not find the specified folder: %key%
	echo If you are trying to get to a folder by the same name as a specified folder
	echo prefix it with a `.\` instead. For instance: `c.bat .\%key%`
	echo.
	exit /B 1


:cdto
	if defined __verbose echo Changing directory to: `%~1`
	pushd "%~1"
	if not "%~2"=="" (
		if exist "%~2" pushd "%~2" && exit /B 0
		exit /B 1
	)
	exit /B 0

:cd_user
	if exist "%PROFILE%" call :cdto "%PROFILE%" && exit /B 0
	call :errorpath
	exit /B 1

:cd_userprofile
	if exist "C:\Users\Kody" call :cdto "C:\Users\Kody" && exit /B 0
	if exist "%UserProfile%" call :cdto "%UserProfile%" && exit /B 0
	call :errorpath
	exit /B 1

:cd_bin
	if exist "%bin%" call :cdto "%bin%" && exit /B
	if exist "C:\bin" call :cdto "C:\bin" && exit /B
	if exist "%PROFILE%\Root" call :cdto "%PROFILE%\Root" && exit /B
	rem Check other possible Root folders
	for %%G in (C T D E F G I P) do (
		if exist %%G:\ (
			for %%J in ("%%G:\bin" "%%G:\root" "%%G:\Kody\Root" "%%G:\Users\Kody\Root") do (
				if exist "%%~J" (
					call :cdto "%%~J" && exit /B
				)
			)
		)
	)
	call :errorpath
	exit /B 1

:cd_root
	if exist "%PROFILE%\Root" call :cdto "%PROFILE%\Root" && exit /B
	rem Check other possible Root folders
	for %%G in (C T D E F G I P) do (
		if exist %%G:\ (
			for %%J in ("%%G:\root" "%%G:\Kody\Root" "%%G:\Users\Kody\Root") do (
				if exist "%%~J" (
					call :cdto "%%~J" && exit /B
				)
			)
		)
	)
	call :errorpath
	exit /B 1

:cd_desktop
	if exist "%PROFILE%\Desktop" call :cdto "%PROFILE%\Desktop" && exit /B
	if exist "C:\Users\Kody\Desktop" call :cdto "C:\Users\Kody\Desktop" && exit /B
	exit /B 1

:cd_docs
	if exist "%PROFILE%\Documents" call :cdto "%PROFILE%\Documents" && exit /B
	if exist "C:\Users\Kody\Documents" call :cdto "C:\Users\Kody\Documents" && exit /B
	call :errorpath
	exit /B 1

:cd_downloads
	if exist "C:\downloads" call :cdto "C:\downloads" && exit /B
	if exist "%PROFILE%\Downloads" call :cdto "%PROFILE%\Downloads" && exit /B
	if exist "C:\Users\Kody\Downloads" call :cdto "C:\Users\Kody\Downloads" && exit /B
	if exist "C:\media\Downloads" call :cdto "C:\media\Downloads" && exit /B
	exit /B 1

:cd_code
	if exist "%CODE%" call :cdto "%CODE%" && exit /B
	if exist "C:\code" call :cdto "C:\code" && exit /B
	if exist "C:\projects" call :cdto "C:\projects" && exit /B
	if exist "T:\code" call :cdto "T:\code" && exit /B
	if exist "T:\projects" call :cdto "T:\projects" && exit /B
	rem if exist "%PROFILE%\Documents\Development\Projects" call :cdto "%PROFILE%\Documents\Development\Projects" && exit /B
	call :errorpath %1
	exit /B 1

:cd_dev
	if exist "%DEV%" call :cdto "%DEV%" && exit /B
	if exist "C:\dev" call :cdto "C:\dev" && exit /B
	if exist "C:\src" call :cdto "C:\src" && exit /B
	if exist "C:\code" call :cdto "C:\code" && exit /B
	if exist "T:\dev" call :cdto "T:\dev" && exit /B
	if exist "T:\src" call :cdto "T:\src" && exit /B
	if exist "T:\code" call :cdto "T:\code" && exit /B
	if exist "%PROFILE%\Documents\Development\Projects" call :cdto "%PROFILE%\Documents\Development\Projects" && exit /B
	call :errorpath
	exit /B 1

:cd_o 			Obeo (source)
:cd_obeo
	if exist "C:\obeo" call :cdto "C:\obeo" && exit /B
	if exist "C:\code\obeo" call :cdto "C:\code\obeo" && exit /B
	if exist "C:\src\obeo" call :cdto "C:\src\obeo" && exit /B
	if exist "C:\projects\obeo" call :cdto "C:\projects\obeo" && exit /B
	call :errorpath
	exit /B 1

:cd_oc			Obeo (contract)
:cd_obeoc
:cd_contract_obeo
	if exist "C:\obeo" call :cdto "C:\obeo" && exit /B
	if exist "C:\code\obeo" call :cdto "C:\code\obeo" && exit /B
	if exist "C:\src\obeo" call :cdto "C:\src\obeo" && exit /B
	if exist "C:\projects\obeo" call :cdto "C:\projects\obeo" && exit /B
	call :errorpath
	exit /B 1

:cd_j			Journal
:cd_jrnl
:cd_journal
	if exist "%PROFILE%\Documents\Journal" call :cdto "%PROFILE%\Documents\Journal" && exit /B
	if exist "C:\Users\Kody\Documents\Journal" call :cdto "C:\Users\Kody\Documents\Journal" && exit /B
	call :errorpath
	exit /B 1

:cd_m 			Journal - Current Month
:cd_curmonth
:cd_currentmonth
:cd_journal_currentmonth
	call :setdatevars
	call :settimevars
	call :setmonthnamevars
	if exist "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" call :cdto "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" && exit /B
	call :errorpath
	exit /B 1

:cd_l 			Journal - Last Month
:cd_lastmonth
:cd_journal_lastmonth
	call :setdatevars
	call :settimevars
	call :setmonthnamevars
	if exist "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" call :cdto "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" && exit /B
	call :errorpath
	exit /B 1

:cd_serials 		Serial numbers
	if exist "%PROFILE%\Documents\Journal\Serial numbers" call :cdto "%PROFILE%\Documents\Journal\Serial numbers" && exit /B
	if exist "C:\Users\Kody\Documents\Journal\Serial numbers" call :cdto "C:\Users\Kody\Documents\Journal\Serial numbers" && exit /B
	call :errorpath
	exit /B 1

:cd_recent 		Recent files
	if exist "%AppData%\Microsoft\Windows\Recent" call :cdto "%AppData%\Microsoft\Windows\Recent" && exit /B
	call :errorpath
	exit /B 1

:cd_favs 		Favorites
:cd_favorites
	if exist "%PROFILE%\Favorites" call :cdto "%PROFILE%\Favorites" && exit /B
	call :errorpath
	exit /B 1

:cd_x 			Temp
:cd_temp
	if exist "C:\temp" call :cdto "C:\temp" && exit /B
	if exist "%temp%" call :cdto "%temp%" && exit /B
	if exist "%tmp%" call :cdto "%tmp%" && exit /B
	call :errorpath
	exit /B 1

:cd_ux 			Temp (User)
:cd_usertemp
:cd_usrtemp
:cd_user_temp
	if exist "%temp%" call :cdto "%temp%" && exit /B
	if exist "%tmp%" call :cdto "%tmp%" && exit /B
	call :errorpath
	exit /B 1

:cd_sx 			Temp (System)
:cd_wintemp
:cd_systemp
:cd_sys_temp
	if exist "C:\Windows\Temp" call :cdto "C:\Windows\Temp" && exit /B
	call :errorpath
	exit /B 1

:cd_p 			Program Files
:cd_6
:cd_64
:cd_progfiles64
:cd_progfiles
	if exist "%ProgramW6432%" call :cdto "%ProgramW6432%" && exit /B
	if exist "%ProgramFiles%" call :cdto "%ProgramFiles%" && exit /B
	if exist "C:\Program Files" call :cdto "C:\Program Files" && exit /B
	call :errorpath
	exit /B 1

:cd_progfiles86 		Program Files ^(x86^)
	if exist "%ProgramFiles(x86)%" call :cdto "%ProgramFiles(x86)%" && exit /B
	rem if exist "C:\Program Files ^(x86^)" call :cdto "C:\Program Files ^(x86^)" && exit /B
	if exist "C:\Program Files (x86)" call :cdto "C:\Program Files (x86)" && exit /B
	call :cd_progfiles
	call :errorpath
	exit /B 1

:cd_venafi
	if exist "%ProgramW6432%\Venafi\Platform" call :cdto "%ProgramW6432%\Venafi\Platform" && exit /B
	if exist "%ProgramFiles%\Venafi\Platform" call :cdto "%ProgramFiles%\Venafi\Platform" && exit /B
	if exist "C:\Program Files\Venafi\Platform" call :cdto "C:\Program Files\Venafi\Platform" && exit /B
	call :errorpath
	exit /B 1

:cd_director
	if exist "%CODE%\Director" pushd "%CODE%\Director" && shift && goto :final_check %1
	if exist "C:\code\Director" pushd "C:\code\Director" && shift && goto :final_check %1
	if exist "%SRC%\Director" pushd "%SRC%\Director" && shift && goto :final_check %1
	if exist "C:\src\Director" pushd "C:\src\Director" && shift && goto :final_check %1
	if exist "%DEV%\Director" pushd "%DEV%\Director" && shift && goto :final_check %1
	if exist "C:\dev\Director" pushd "C:\dev\Director" && shift && goto :final_check %1
	if exist "C:\projects\Director" pushd "C:\projects\Director" && shift && goto :final_check %1
	call :errorpath
	exit /B 1

:cd_solutions
	if exist "%CODE%\Director\Solutions" pushd "%CODE%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\code\Director\Solutions" pushd "C:\code\Director\Solutions" && shift && goto :final_check %1
	if exist "%SRC%\Director\Solutions" pushd "%SRC%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\src\Director\Solutions" pushd "C:\src\Director\Solutions" && shift && goto :final_check %1
	if exist "%DEV%\Director\Solutions" pushd "%DEV%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\dev\Director\Solutions" pushd "C:\dev\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\projects\Director\Solutions" pushd "C:\projects\Director\Solutions" && shift && goto :final_check %1
	call :errorpath
	exit /B 1

:cd_i
:cd_installers
	if exist "C:\installers" call :cdto "C:\installers" && exit /B
	if exist "%ThumbDrive%\installers" call :cdto "%ThumbDrive%\installers" && exit /B
	call :errorpath
	exit /B 1

:cd_drivers
	if exist "C:\installers\Drivers" call :cdto "C:\installers\Drivers" && exit /B
	if exist "%ThumbDrive%\installers\Drivers" call :cdto "%ThumbDrive%\installers\Drivers" && exit /B
	if exist "%ThumbDrive%\drivers" call :cdto "%ThumbDrive%\drivers" && exit /B
	rem for %%G in (C T D E F G H I J) do (
	rem 	if exist %%G:\ (
	rem 		if exist "%%G:\installers\Drivers" call :cdto "%%G:\installers\Drivers" & exit /B
	rem 		if exist "%%G:\Users\Kody\Downloads\Drivers" call :cdto "%%G:\Users\Kody\Downloads\Drivers" & exit /B
	rem 		if exist "%%G:%HomePath%\Downloads\Drivers" call :cdto "%%G:%HomePath%\Downloads\Drivers" & exit /B
	rem 	)
	rem )
	call :errorpath
	exit /B 1

:cd_pics
:cd_pictures
	if exist "C:\Users\Kody\Pictures" call :cdto "C:\Users\Kody\Pictures" && exit /B
	if exist "%PROFILE%\Pictures" call :cdto "%PROFILE%\Pictures" && exit /B
	if exist "%ThumbDrive%\pictures" call :cdto "%ThumbDrive%\pictures" && exit /B
	call :errorpath
	exit /B 1

:cd_media
	if exist "C:\media" call :cdto "C:\media" && exit /B
	if exist "%PROFILE%\Media" call :cdto "%PROFILE%\Media" && exit /B
	if exist "C:\Users\Kody\Media" call :cdto "C:\Users\Kody\Media" && exit /B
	if exist "%ThumbDrive%\media" call :cdto "%ThumbDrive%\media" && exit /B
	call :errorpath
	exit /B 1

:cd_photos
	if exist "C:\media\photos" call :cdto "C:\mdia\photos" && exit /B
	if exist "%PROFILE%\Photos" call :cdto "%PROFILE%\Photos" && exit /B
	if exist "C:\Users\Kody\Photos" call :cdto "C:\Users\Kody\Photos" && exit /B
	if exist "%ThumbDrive%\photos" call :cdto "%ThumbDrive%\photos" && exit /B
	call :errorpath
	exit /B 1

:cd_music
	if exist "C:\media\music" call :cdto "C:\media\music" && exit /B
	if exist "C:\music" call :cdto "C:\music" && exit /B
	if exist "%PROFILE%\Music" call :cdto "%PROFILE%\Music" && exit /B
	if exist "C:\Users\Kody\Music" call :cdto "C:\Users\Kody\Music" && exit /B
	if exist "%ThumbDrive%\music" call :cdto "%ThumbDrive%\music" && exit /B
	call :errorpath
	exit /B 1
