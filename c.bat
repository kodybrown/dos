::#!/dos/rocks!

:: c.bat

:p
    @if "%~1"=="" goto :e

    @set a=%~1
   :skip_a

    @if "[%a:~0,2%]"=="[~/]" pushd "%UserProfile%\%a:~2,1000%" && shift && goto :p
    @if "[%a:~0,2%]"=="[//]" pushd "%UserProfile%\%a:~2,1000%" && shift && goto :p
    @if "%a:~0,3%"=="/~/"    pushd "%UserProfile%\%a:~3,1000%" && shift && goto :p

    @if "%a:~0,3%"=="/b/" pushd "%bin%\%a:~3,1000%" && shift && goto :p
    @if "%a:~0,3%"=="/e/" pushd "%UserProfile%\Desktop\%a:~3,1000%" && shift && goto :p
    @if "%a:~0,3%"=="/d/" pushd "%UserProfile%\Documents\%a:~3,1000%" && shift && goto :p
    @if "%a:~0,3%"=="/w/" pushd "%UserProfile%\Downloads\%a:~3,1000%" && shift && goto :p

    @call :label_exists cd_%a%
    @if defined _foundit call :cd_%a% && set "_foundit=" && shift && goto :p

:: rem     @if /i "%~1"=="b"      pushd c:\bin && shift && goto :p
:: rem     @if /i "%~1"=="/bin"   pushd c:\bin && shift && goto :p
:: rem
:: rem     @if /i "%~1"=="r"      pushd "%UserProfile%\Root" && shift && goto :p
:: rem     @if /i "%~1"=="/root"  pushd "%UserProfile%\Root" && shift && goto :p
:: rem
:: rem     @rem help t, /tools                 cd c:\tools or %%UserProfile%%\Tools
:: rem     @ rem if /i "%~1"=="t"      call :cdor "%~1" "%tools%" "c:\tools" "%UserProfile%\Tools" && shift && goto :p
:: rem     @ rem if /i "%~1"=="/tools" call :cdor "%~1" "%tools%" "c:\tools" "%UserProfile%\Tools" && shift && goto :p
:: rem     @if /i "%~1"=="t"      call :cd_t "%~1" && shift && goto :p
:: rem     @if /i "%~1"=="/tools" call :cd_/tools "%~1" && shift && goto :p
:: rem
:: rem     @rem help /dev                      cd c:\dev or %%UserProfile%%\Documents\Development
:: rem     @if /i "%~1"=="/dev" call :cd_development "%~1" && shift && goto :p
:: rem
:: rem     @rem help ~, /profile, /home        cd %%UserProfile%%
:: rem     @if /i "%~1"=="~"        pushd "%UserProfile%" && shift && goto :p
:: rem     @if /i "%~1"=="/profile" pushd "%UserProfile%" && shift && goto :p
:: rem     @if /i "%~1"=="/home"    pushd "%UserProfile%" && shift && goto :p
:: rem
:: rem     @rem help /appdata                  cd %%UserProfile%%\AppData
:: rem     @if /i "%~1"=="/appdata" pushd "%UserProfile%\AppData" && shift && goto :p
:: rem     @rem help /roaming                  cd %%UserProfile%%\AppData\Roaming
:: rem     @if /i "%~1"=="/roaming" pushd "%UserProfile%\AppData\Roaming" && shift && goto :p
:: rem     @rem help /local                    cd %%UserProfile%%\AppData\Local
:: rem     @if /i "%~1"=="/local"   pushd "%UserProfile%\AppData\Local" && shift && goto :p
:: rem
:: rem     @rem help e, /desktop               cd %%UserProfile%%\Desktop
:: rem     @if /i "%~1"=="e"        pushd "%UserProfile%\Desktop" && shift && goto :p
:: rem     @if /i "%~1"=="/desktop" pushd "%UserProfile%\Desktop" && shift && goto :p
:: rem
:: rem     @rem help d, /documents             cd %%UserProfile%%\Documents
:: rem     @if /i "%~1"=="d"     pushd "%UserProfile%\Documents" && shift && goto :p
:: rem     @if /i "%~1"=="/docs" pushd "%UserProfile%\Documents" && shift && goto :p
:: rem
:: rem     @rem help w, /downloads             cd c:\downloads or %%UserProfile%%\Downloads
:: rem     @if /i "%~1"=="w" call :cd_downloads "%~1" && shift && goto :p
:: rem     @if /i "%~1"=="downloads" call :cd_downloads "%~1" && shift && goto :p
:: rem
:: rem     @rem help i, /installers            cd c:\installers or %%UserProfile%%\Installers
:: rem     @if /i "%~1"=="i" call :cd_installers "%~1" && shift && goto :p
:: rem     @if /i "%~1"=="/installers" call :cd_installers "%~1" && shift && goto :p
:: rem
:: rem     @if /i "%~1"=="d"     pushd "%UserProfile%\Documents" && shift && goto :p
:: rem     @if /i "%~1"=="/docs" pushd "%UserProfile%\Documents" && shift && goto :p
:: rem

    @if not exist "%~1" echo couldn't find: %~1..
    @if exist "%~1" cd %~1

    @shift
    @goto :p

:e
    @exit /B 1


:label_exists
    :: ARGS: extension
    @set "_foundit="
    @for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /i /B /C:":%~1" "%~f0""') do @set "_foundit=1" && goto :eof
    @goto :eof


::@help  t, /tools                   cd c:\tools or %%UserProfile%%\Tools
:cd_t
:cd_/tools
    @call :cdor tools "%tools%" "c:\tools" "%UserProfile%\Tools"
    @goto :eof

:cd_dev
:cd_/dev
:cd_development
    @call :cdor development "%dev%" "c:\dev" "%UserProfile%\Documents\Development"
    @goto :eof

:cd_downloads
    @call :cdor downloads "%downloads%" "c:\downloads" "%UserProfile%\Downloads"
    @goto :eof

:cd_installers
    @call :cdor installers "%installers%" "c:\installers" "%UserProfile%\Installers"
    @goto :eof

:cdor
    @set n=%~1
    @shift
   :cdor_loop
    @if "%~1"=="" goto :cdor_end
    @if exist "%~1" pushd "%~1" && goto :eof
    @shift && goto :cdor_loop
   :cdor_end
    @echo couldn't find: %n% && goto :eof

