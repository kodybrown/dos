@rem c.bat

:p
	@if "%~1"=="" goto :e

	@if /i "%~1"=="b" cd /D c:\bin && shift && goto :p
	@if /i "%~1"=="bin" cd /D c:\bin && shift && goto :p
	@if /i "%~1"=="/bin" cd /D c:\bin && shift && goto :p

	@if /i "%~1"=="root" cd /D "%UserProfile%\Root" && shift && goto :p
	@if /i "%~1"=="/root" cd /D "%UserProfile%\Root" && shift && goto :p

	@if /i "%~1"=="tools" call :c "%tools%" && shift && goto :p
	@if /i "%~1"=="/tools" cd /D "%tools%" && shift && goto :p
	@if /i "%~1"=="t" cd /D "%tools%" && shift && goto :p

	@if /i "%~1"=="dev" cd /D "%UserProfile%\Documents\Development" && shift && goto :p
	@if /i "%~1"=="/dev" cd /D "%UserProfile%\Documents\Development" && shift && goto :p

	@if /i "%~1"=="~" cd /D "%UserProfile%" && shift && goto :p
	@if /i "%~1"=="~/" cd /D "%UserProfile%" && shift && goto :p
    @if /i "%~1"=="//" call :cd_user && shift && goto :p
	@if /i "%~1"=="profile" cd /D "%UserProfile%" && shift && goto :p
	@if /i "%~1"=="home" call :cd_user && shift && goto :p

	@if /i "%~1"=="appdata" cd /D "%UserProfile%\AppData\Roaming" && shift && goto :p
	@if /i "%~1"=="roaming" cd /D "%UserProfile%\AppData\Roaming" && shift && goto :p
	@if /i "%~1"=="local" cd /D "%UserProfile%\AppData\Local" && shift && goto :p

	@if /i "%~1"=="e" cd /D "%UserProfile%\Desktop" && shift && goto :p
	@if /i "%~1"=="desktop" cd /D "%UserProfile%\Desktop" && shift && goto :p

	@if /i "%~1"=="d" cd /D "%UserProfile%\Documents" && shift && goto :p
	@if /i "%~1"=="docs" cd /D "%UserProfile%\Documents" && shift && goto :p

	@if /i "%~1"=="downloads" (
		@if exist "c:\downloads" cd /D "c:\downloads" && shift && goto :p
		@if exist "%UserProfile%\Downloads" cd /D "%UserProfile%\Downloads" && shift && goto :p
	)

	@if /i "%~1"=="installers" (
		@if exist "c:\installers" cd /D "c:\installers" && shift && goto :p
		@if exist "%UserProfile%\Installers" cd /D "%UserProfile%\Installers" && shift && goto :p
	)



	@cd %~1

	@shift
	@goto :p

:c
	set "arg=%~1"

	rem Replace all forward-slashes with back-slashes.
	set arg=%arg:/=\%
	rem Replace dlb-backslashes with a single back-slash
	set arg=!arg:\\=\!

	rem My common shorcut/replacements..
	if "[!arg:~0,2!]"=="[~/]" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,2!"=="//" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,3!"=="/~/" set arg=%UserProfile%\!arg:~3!
	if "!arg:~0,3!"=="/b/" set arg=%BIN%\!arg:~3!
	if "!arg:~0,3!"=="/e/" set arg=%UserProfile%\Desktop\!arg:~3!
	if "!arg:~0,3!"=="/d/" set arg=%UserProfile%\Documents\!arg:~3!
	if "!arg:~0,3!"=="/w/" set arg=%UserProfile%\Downloads\!arg:~3!

	if defined __verbose echo Changing directory to: `%key%`
	cd "%key%"

	goto :eof

:e
	@exit /B 1

rem Change to directory via arguments or from a menu.
rem Author: Kody Brown (thewizard@wasatchwizard.com)
rem Created 2004-05-25 @wasatchwizard
rem Copyright: Free

rem +++++++++++++++++++
rem  REQUIRES:
rem    hdchoice.exe
rem +++++++++++++++++++

:init
    set batver=0.6.40727
    set batname=%~n0
    set batname_ext=%~nx0
    set batname_full=%~dpnx0
    set batext=%~x0
    set batpath=%~dp0

	set "__debug="
    set "key="

	if "%~1"=="" goto :displaymenu

:parse
    if "%~1"=="" goto :main

    set "arg=%~1"
    set "opt="

    :check_opts
      if "!arg:~0,1!"=="-" set "opt=1" && set "arg=!arg:~1!" && goto :check_opts
      if "!arg:~0,1!"=="/" set "opt=1" && set "arg=!arg:~1!" && goto :check_opts

    if defined opt (
        rem This will allow distinguishing between an opt and arg of the same name.
        rem i.e.: `--param vs. param`
        rem I don't recommend using a name for both an opt and an arg...
    )

    rem HELP
    if /i "!arg:~0,1!"=="?" shift && call :show_apphelp %* && exit /B 0
    if /i "!arg:~0,1!"=="h" shift && call :show_apphelp %* && exit /B 0

    rem VERSION
    if /i "!arg:~0,1!"=="v" shift && call :show_appinfo %* && exit /B 0

    rem DEBUG
    if /i "!arg:~0,1!"=="d" set "__debug=1" && shift && goto :parse


	if "%~1"=="" goto :displaymenu

:main
	if "%~1"=="" goto :end


	set "key=%~1"

	if /i "%key%"=="\" cd \ && shift && goto :main

	if /i "%key%"=="i" goto :editonly
	if /i "%key%"=="edit" goto :editonly

	rem Go to 'my' user directory, which may or may
	rem not be the '%UserProfile%' directory.
	if /i "%key%"=="~" call :cd_user && shift && goto :main
	if /i "%key%"=="~/" call :cd_user && shift && goto :main
    if /i "%key%"=="//" call :cd_user && shift && goto :main
	if /i "%key%"=="home" call :cd_user && shift && goto :main
	if /i "%key%"=="kody" call :cd_user && shift && goto :main
	if /i "%key%"=="profile" call :cd_user && shift && goto :main

	rem Go to the '%UserProfile%' directory.
	if /i "%key%"=="u" call :cd_userprofile && shift && goto :main
	if /i "%key%"=="usr" call :cd_userprofile && shift && goto :main
	if /i "%key%"=="user" call :cd_userprofile && shift && goto :main
	if /i "%key%"=="userprofile" call :cd_userprofile && shift && goto :main

	rem Go to the bin directory ('%BIN%' or 'C:\bin').
	if /i "%key%"=="b" call :cd_bin && shift && goto :main
	if /i "%key%"=="bin" call :cd_bin && shift && goto :main

	rem Go to my bin\help directory ('%BIN%\help').
	if /i "%key%"=="man" call :cd_bin && shift && goto :main
	if /i "%key%"=="manpages" call :cd_bin && shift && goto :main
	if /i "%key%"=="man-pages" call :cd_bin && shift && goto :main

	rem Go to the root directory ('%PROFILE%\Root').
	if /i "%key%"=="t" call :cd_bin && shift && goto :main
	if /i "%key%"=="root" call :cd_bin && shift && goto :main

	rem Go to the desktop directory.
	if /i "%key%"=="e" call :cd_desktop && shift && goto :main
	if /i "%key%"=="desktop" call :cd_desktop && shift && goto :main

	rem Go to the documents directory.
	if /i "%key%"=="d" call :cd_docs && shift && goto :main
	if /i "%key%"=="documents" call :cd_docs && shift && goto :main
	if /i "%key%"=="docs" call :cd_docs && shift && goto :main

	rem Go to the downloads directory.
	if /i "%key%"=="w" call :cd_downloads && shift && goto :main
	if /i "%key%"=="downloads" call :cd_downloads && shift && goto :main

	rem Go to the code directory.
	if /i "%key%"=="c" call :cd_code && shift && goto :main
	if /i "%key%"=="code" call :cd_code && shift && goto :main

	rem Go to the journal directory.
	if /i "%key%"=="j" call :cd_journal && shift && goto :main
	if /i "%key%"=="journal" call :cd_journal && shift && goto :main

	rem Go to the current month's journal directory.
	if /i "%key%"=="jc" call :cd_journal_currentmonth && shift && goto :main
	if /i "%key%"=="currentmonth" call :cd_journal_currentmonth && shift && goto :main

	rem Go to the last month's journal directory.
	if /i "%key%"=="jl" call :cd_journal_lastmonth && shift && goto :main
	if /i "%key%"=="lastmonth" call :cd_journal_lastmonth && shift && goto :main

	rem Go to the serial numbers directory.
	if /i "%key%"=="js" call :cd_serials && shift && goto :main
	if /i "%key%"=="serial" call :cd_serials && shift && goto :main
	if /i "%key%"=="serials" call :cd_serials && shift && goto :main

	rem Go to the cheat-sheats directory ('%PROFILE%\.cheats').
	if /i "%key%"=="cheats" call :cd_cheatsheets && shift && goto :main
	if /i "%key%"=="cheatsheets" call :cd_cheatsheets && shift && goto :main
	if /i "%key%"=="sheets" call :cd_cheatsheets && shift && goto :main

	rem Go to the obeo (source) directory ('C:\obeo').
	if /i "%key%"=="o" call :cd_obeo && shift && goto :main
	if /i "%key%"=="obeo" call :cd_obeo && shift && goto :main

	rem Go to my temp directory ('C:\temp').
	if /i "%key%"=="x" call :cd_temp && shift && goto :main
	if /i "%key%"=="temp" call :cd_temp && shift && goto :main

	rem Go to the user's temp directory ('C:\Users\UserName\AppData\Local\Temp').
	if /i "%key%"=="usertemp" call :cd_temp_user && shift && goto :main
	if /i "%key%"=="usrtemp" call :cd_temp_user && shift && goto :main

	rem Go to the system temp directory ('C:\Windows\Temp').
	if /i "%key%"=="systemp" call :cd_temp_system && shift && goto :main
	if /i "%key%"=="systemtemp" call :cd_temp_system && shift && goto :main

	rem Go to the program files directory ('C:\Program Files').
	if %key% EQU 6 call :cd_progfiles && shift && goto :main
	if /i "%key%"=="programs" call :cd_progfiles && shift && goto :main
	if /i "%key%"=="progfiles" call :cd_progfiles && shift && goto :main
	if /i "%key%"=="programfiles" call :cd_progfiles && shift && goto :main

	rem Go to the program files (x86) directory ('C:\Program Files (x86)').
	if %key% EQU 8 call :cd_progfiles86 && shift && goto :main
	if /i "%key%"=="x86" call :cd_progfiles86 && shift && goto :main
	if /i "%key%"=="programs86" call :cd_progfiles86 && shift && goto :main
	if /i "%key%"=="progfiles86" call :cd_progfiles86 && shift && goto :main
	if /i "%key%"=="programfiles86" call :cd_progfiles86 && shift && goto :main

	if /i "%key%"=="a" call :cd_venafi && shift && goto :main
	if /i "%key%"=="venafi" call :cd_venafi && shift && goto :main

	if %key% EQU 1 call :cd_recent && shift && goto :main
	if /i "%key%"=="recent" call :cd_recent && shift && goto :main

	rem if /i "%key%"=="v" call vsvars.bat && shift && goto :main

	rem if exist "%~dp0pcolor.exe" ( "%~dp0pcolor.exe" {Red}Invalid argument: %key% ) else ( echo Invalid argument: %key% )
	rem if not defined __quiet (
	rem 	if exist "%~dp0sleep.exe" ( "%~dp0sleep.exe" 200 ) else ( pause )
	rem )

	rem TODO:
	rem if `:cd_%key%` exists in the file then:
	rem goto :cd_%key%

	cd %key%
	shift
	goto :main

:end
    set "batver="
    set "batname="
    set "batname_ext="
    set "batname_full="
    set "batext="
    set "batpath="

	set "key="
	set "__debug="

	exit /B %errorlevel%



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
	echo   ^(d^) %%Profile%%\Documents
	echo   ^(e^) %%Profile%%\Desktop
	echo   ^(w^) C:\downloads
	echo   ^(u^) %%UserProfile%%
	echo   ^(p^) %%Profile%%
	echo   ^(t^) %%Profile%%\Root
	echo   ^(b^) %%BIN%%
	echo   ^(h^) %%BIN%%\help
	echo.
	echo   ^(j^) %%Profile%%\Documents\Journal
	echo   ^(j,c^) %%Profile%%\Documents\Journal\(Dates)\Current Month
	echo   ^(j,l^) %%Profile%%\Documents\Journal\(Dates)\Last Month
	echo   ^(j,s^) %%Profile%%\Documents\Journal\Serial numbers
	echo.
	echo   ^(c^) C:\code
	echo   ^(o^) C:\obeo
	echo   ^(k^) C:\kynetx
	echo.
	echo   ^(6^) C:\Program Files
	echo   ^(8^) C:\Program Files (x86)
	echo   ^(x^) C:\Temp
	echo.
	echo   ^(1^) Recent files
	echo   ----------------------------------------------------------
	echo.

	"%~dp0hdchoice.exe" /C:irqudcthvboxwe68ajms1lpb /N

	if exist "%~dp0clearline.exe" call "%~dp0clearline.exe" -10

	rem if the first argument matches a command, override the errorlevel to execute it below
	rem execute the specified command here
	if %ERRORLEVEL% equ 1 goto :editmenu
	if %ERRORLEVEL% equ 2 goto :displaymenu
	if %ERRORLEVEL% equ 3 exit /B 0

	if %ERRORLEVEL% equ 4 call :cdto_userprofile && exit /B 0

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
	goto :eof


:cdto
	set "arg=%~1"

	rem Replace all forward-slashes with back-slashes.
	set arg=%arg:/=\%
	rem Replace dlb-backslashes with a single back-slash
	set arg=!arg:\\=\!

	rem My common shorcut/replacements..
	if "[!arg:~0,2!]"=="[~/]" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,2!"=="//" set arg=%UserProfile%\!arg:~2!
	if "!arg:~0,3!"=="/~/" set arg=%UserProfile%\!arg:~3!
	if "!arg:~0,3!"=="/b/" set arg=%BIN%\!arg:~3!
	if "!arg:~0,3!"=="/e/" set arg=%UserProfile%\Desktop\!arg:~3!
	if "!arg:~0,3!"=="/d/" set arg=%UserProfile%\Documents\!arg:~3!
	if "!arg:~0,3!"=="/w/" set arg=%UserProfile%\Downloads\!arg:~3!

	if defined __verbose echo Changing directory to: `%key%`
	cd "%key%"

	goto :eof

:cd_user
	if exist "%PROFILE%" call :cdto "%PROFILE%" && goto :eof
	call :errorpath
	goto :eof

:cd_userprofile
	for %%G in ("%bin%" "C:\bin" "C:\Users\Kody\Root" "%PROFILE%\Root" "%USERPROFILE%\Root") do (
		if exist "%%G" call :cdto "%%~G" && goto :eof
	)

	if exist "C:\Users\Kody" call :cdto "C:\Users\Kody" && goto :eof
	if exist "%UserProfile%" call :cdto "%UserProfile%" && goto :eof
	call :errorpath
	goto :eof

:cd_bin
	for %%G in ("%bin%" "C:\bin" "C:\Users\Kody\Root" "%PROFILE%\Root" "%USERPROFILE%\Root") do (
		if exist "%%G" call :cdto "%%~G" && goto :eof
	)

	rem Check other possible Root folders
	for %%G in (C T D E F G I P) do (
		if exist %%G:\ (
			for %%J in ("%%G:\bin" "%%G:\root" "%%G:\Users\Kody\Root" "%%G:\Kody\Root") do (
				if exist "%%~J" (
					call :cdto "%%~J" && goto :eof
				)
			)
		)
	)

	call :errorpath
	goto :eof

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
	goto :eof

:cd_desktop
	if exist "%PROFILE%\Desktop" call :cdto "%PROFILE%\Desktop" && exit /B
	if exist "C:\Users\Kody\Desktop" call :cdto "C:\Users\Kody\Desktop" && exit /B
	goto :eof

:cd_docs
	if exist "%PROFILE%\Documents" call :cdto "%PROFILE%\Documents" && exit /B
	if exist "C:\Users\Kody\Documents" call :cdto "C:\Users\Kody\Documents" && exit /B
	call :errorpath
	goto :eof

:cd_downloads
	if exist "C:\downloads" call :cdto "C:\downloads" && exit /B
	if exist "%PROFILE%\Downloads" call :cdto "%PROFILE%\Downloads" && exit /B
	if exist "C:\Users\Kody\Downloads" call :cdto "C:\Users\Kody\Downloads" && exit /B
	if exist "C:\media\Downloads" call :cdto "C:\media\Downloads" && exit /B
	goto :eof

:cd_code
	if exist "%CODE%" call :cdto "%CODE%" && exit /B
	if exist "C:\code" call :cdto "C:\code" && exit /B
	if exist "C:\projects" call :cdto "C:\projects" && exit /B
	if exist "T:\code" call :cdto "T:\code" && exit /B
	if exist "T:\projects" call :cdto "T:\projects" && exit /B
	rem if exist "%PROFILE%\Documents\Development\Projects" call :cdto "%PROFILE%\Documents\Development\Projects" && exit /B
	call :errorpath %1
	goto :eof

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
	goto :eof

:cd_o 			Obeo (source)
:cd_obeo
	if exist "C:\obeo" call :cdto "C:\obeo" && exit /B
	if exist "C:\code\obeo" call :cdto "C:\code\obeo" && exit /B
	if exist "C:\src\obeo" call :cdto "C:\src\obeo" && exit /B
	if exist "C:\projects\obeo" call :cdto "C:\projects\obeo" && exit /B
	call :errorpath
	goto :eof

:cd_oc			Obeo (contract)
:cd_obeoc
:cd_contract_obeo
	if exist "C:\obeo" call :cdto "C:\obeo" && exit /B
	if exist "C:\code\obeo" call :cdto "C:\code\obeo" && exit /B
	if exist "C:\src\obeo" call :cdto "C:\src\obeo" && exit /B
	if exist "C:\projects\obeo" call :cdto "C:\projects\obeo" && exit /B
	call :errorpath
	goto :eof

:cd_j			Journal
:cd_jrnl
:cd_journal
	if exist "%PROFILE%\Documents\Journal" call :cdto "%PROFILE%\Documents\Journal" && exit /B
	if exist "C:\Users\Kody\Documents\Journal" call :cdto "C:\Users\Kody\Documents\Journal" && exit /B
	call :errorpath
	goto :eof

:cd_m 			Journal - Current Month
:cd_curmonth
:cd_currentmonth
:cd_journal_currentmonth
	call :setdatevars
	call :settimevars
	call :setmonthnamevars
    :: Yes, that month at the end is correct.. it is acting like an array..
	if exist "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" call :cdto "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" && exit /B
	if exist "%USERPROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" call :cdto "%USERPROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" && goto :eof
	if exist "C:\Users\Kody\Documents\Journal" call :cdto "C:\Users\Kody\Documents\Journal" && goto :eof
	call :errorpath
	goto :eof

:cd_l 			Journal - Last Month
:cd_lastmonth
:cd_journal_lastmonth
	call :setdatevars
	call :settimevars
	call :setmonthnamevars
	if exist "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" call :cdto "%PROFILE%\Documents\Journal\(Dates)\%yy%\%mm% - %month%mm%%" && goto :eof
	call :errorpath
	goto :eof

:cd_serials 		Serial numbers
	if exist "%PROFILE%\Documents\Journal\Serial numbers" call :cdto "%PROFILE%\Documents\Journal\Serial numbers" && goto :eof
	if exist "C:\Users\Kody\Documents\Journal\Serial numbers" call :cdto "C:\Users\Kody\Documents\Journal\Serial numbers" && goto :eof
	call :errorpath
	goto :eof

:cd_recent 		Recent files
	if exist "%AppData%\Microsoft\Windows\Recent" call :cdto "%AppData%\Microsoft\Windows\Recent" && goto :eof
	call :errorpath
	goto :eof

:cd_favs 		Favorites
:cd_favorites
	if exist "%PROFILE%\Favorites" call :cdto "%PROFILE%\Favorites" && goto :eof
	call :errorpath
	goto :eof

:cd_x 			Temp
:cd_temp
	if exist "C:\temp" call :cdto "C:\temp" && exit /B
	if exist "%temp%" call :cdto "%temp%" && exit /B
	if exist "%tmp%" call :cdto "%tmp%" && exit /B
	call :errorpath
	goto :eof

:cd_ux 			Temp (User)
:cd_usertemp
:cd_usrtemp
:cd_user_temp
	if exist "%temp%" call :cdto "%temp%" && exit /B
	if exist "%tmp%" call :cdto "%tmp%" && exit /B
	call :errorpath
	goto :eof

:cd_sx 			Temp (System)
:cd_wintemp
:cd_systemp
:cd_sys_temp
	if exist "C:\Windows\Temp" call :cdto "C:\Windows\Temp" && exit /B
	call :errorpath
	goto :eof

:cd_p 			Program Files
:cd_6
:cd_64
:cd_progfiles64
:cd_progfiles
	if exist "%ProgramW6432%" call :cdto "%ProgramW6432%" && exit /B
	if exist "%ProgramFiles%" call :cdto "%ProgramFiles%" && exit /B
	if exist "C:\Program Files" call :cdto "C:\Program Files" && exit /B
	call :errorpath
	goto :eof

:cd_progfiles86 		Program Files ^(x86^)
	if exist "%ProgramFiles(x86)%" call :cdto "%ProgramFiles(x86)%" && exit /B
	rem if exist "C:\Program Files ^(x86^)" call :cdto "C:\Program Files ^(x86^)" && exit /B
	if exist "C:\Program Files (x86)" call :cdto "C:\Program Files (x86)" && exit /B
	call :cd_progfiles
	call :errorpath
	goto :eof

:cd_venafi
	if exist "%ProgramW6432%\Venafi\Platform" call :cdto "%ProgramW6432%\Venafi\Platform" && exit /B
	if exist "%ProgramFiles%\Venafi\Platform" call :cdto "%ProgramFiles%\Venafi\Platform" && exit /B
	if exist "C:\Program Files\Venafi\Platform" call :cdto "C:\Program Files\Venafi\Platform" && exit /B
	call :errorpath
	goto :eof

:cd_director
	if exist "%CODE%\Director" pushd "%CODE%\Director" && shift && goto :final_check %1
	if exist "C:\code\Director" pushd "C:\code\Director" && shift && goto :final_check %1
	if exist "%SRC%\Director" pushd "%SRC%\Director" && shift && goto :final_check %1
	if exist "C:\src\Director" pushd "C:\src\Director" && shift && goto :final_check %1
	if exist "%DEV%\Director" pushd "%DEV%\Director" && shift && goto :final_check %1
	if exist "C:\dev\Director" pushd "C:\dev\Director" && shift && goto :final_check %1
	if exist "C:\projects\Director" pushd "C:\projects\Director" && shift && goto :final_check %1
	call :errorpath
	goto :eof

:cd_solutions
	if exist "%CODE%\Director\Solutions" pushd "%CODE%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\code\Director\Solutions" pushd "C:\code\Director\Solutions" && shift && goto :final_check %1
	if exist "%SRC%\Director\Solutions" pushd "%SRC%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\src\Director\Solutions" pushd "C:\src\Director\Solutions" && shift && goto :final_check %1
	if exist "%DEV%\Director\Solutions" pushd "%DEV%\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\dev\Director\Solutions" pushd "C:\dev\Director\Solutions" && shift && goto :final_check %1
	if exist "C:\projects\Director\Solutions" pushd "C:\projects\Director\Solutions" && shift && goto :final_check %1
	call :errorpath
	goto :eof

:cd_i
:cd_installers
	if exist "C:\installers" call :cdto "C:\installers" && exit /B
	if exist "%ThumbDrive%\installers" call :cdto "%ThumbDrive%\installers" && exit /B
	call :errorpath
	goto :eof

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
	goto :eof

:cd_pics
:cd_pictures
	if exist "C:\Users\Kody\Pictures" call :cdto "C:\Users\Kody\Pictures" && exit /B
	if exist "%PROFILE%\Pictures" call :cdto "%PROFILE%\Pictures" && exit /B
	if exist "%ThumbDrive%\pictures" call :cdto "%ThumbDrive%\pictures" && exit /B
	call :errorpath
	goto :eof

:cd_media
	if exist "C:\media" call :cdto "C:\media" && exit /B
	if exist "%PROFILE%\Media" call :cdto "%PROFILE%\Media" && exit /B
	if exist "C:\Users\Kody\Media" call :cdto "C:\Users\Kody\Media" && exit /B
	if exist "%ThumbDrive%\media" call :cdto "%ThumbDrive%\media" && exit /B
	call :errorpath
	goto :eof

:cd_photos
	if exist "C:\media\photos" call :cdto "C:\mdia\photos" && exit /B
	if exist "%PROFILE%\Photos" call :cdto "%PROFILE%\Photos" && exit /B
	if exist "C:\Users\Kody\Photos" call :cdto "C:\Users\Kody\Photos" && exit /B
	if exist "%ThumbDrive%\photos" call :cdto "%ThumbDrive%\photos" && exit /B
	call :errorpath
	goto :eof

:cd_music
	if exist "C:\media\music" call :cdto "C:\media\music" && exit /B
	if exist "C:\music" call :cdto "C:\music" && exit /B
	if exist "%PROFILE%\Music" call :cdto "%PROFILE%\Music" && exit /B
	if exist "C:\Users\Kody\Music" call :cdto "C:\Users\Kody\Music" && exit /B
	if exist "%ThumbDrive%\music" call :cdto "%ThumbDrive%\music" && exit /B
	call :errorpath
	goto :eof


:show_appinfo
    echo %batname%: change directories quickly, ver: %batver%
    goto :eof

:show_apphelp
    set arg=%~2

    if /i "%~2"=="list" (
        rem call :show_help_list list
    ) else if /i "%~2"=="ls" (
        rem call :show_help_list ls
    ) else if /i "!arg:~0,1!"=="a" (
        rem call :show_help_add add
    ) else if /i "!arg:~0,1!"=="r" (
        rem call :show_help_remove remove
    ) else (
        rem Show the normal/general help contents..
        call :show_appinfo
        echo ---------------------------------------------------------------------
        echo Allows changing the current directory very quickly using a lookup
        echo list and shortcuts (command-line arguments).
        echo.
        echo USAGE:
        echo   %batname% [options] key [key][...]
        echo.
        echo Options:
        echo.
        echo   -?, help             Displays this help
        echo   -V, version          Displays the version
        rem echo   -d, debug            Outputs debug information
        echo.
        echo Commands:
        echo.
        rem echo   add                  Adds a new item to the menu
        rem echo   ls, list             Displays the Python versions
        rem echo   use, switch          Switches the current Python version
        rem echo.
        echo To get help with a specific command:
        echo.
        echo   %batname% help command
    )

    goto :eof

:show_help_add
    echo %batname%: Adds a new directory to the menu.
    echo.
    rem echo Basically, the location of %batname% is inserted into the top
    rem echo of the system's PATH environment variable. So, whenever `python`
    rem echo is called, the %batname% python handler is run instead.
    rem echo.
    rem echo NOTE: '%batname% switch' updates the system PATH environment
    rem echo variable with the specified Python, Scripts, and Lib directories.
    rem echo.
    echo USAGE:
    echo   %batname% %~1 key "description"
    goto :eof

:show_help_remove
    echo %batname%: Removes the specified menu item.
    echo.
    echo USAGE:
    echo   %batname% %~1 key
    goto :eof

:show_help_list
    echo %batname%: Displays the menu items
    echo.
    echo USAGE:
    echo   %batname% %~1
    goto :eof

