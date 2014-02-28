@setlocal
@echo off

goto :main

:usage
    echo Help information for using `wget.exe`.
    echo.
    echo USAGE:
    echo   %~nx0                           Shows this help information.
    echo   %~nx0 /?                        Shows common usage hints.
    echo   %~nx0 --examples                Shows some examples.
    echo   %~nx0 --help                    Shows the complete help (`wget.exe --help`).
    echo.
    echo   %~nx0 [options] commands        Executes those options and commands.
    goto :eof

:displayhints
    call :usage
    echo.
    echo COMMON COMMANDS:
    echo.
    echo   Logging and input file:
    echo     -o,  --output-file=FILE          log messages to FILE.
    echo     -a,  --append-output=FILE        append messages to FILE.
    echo     -d,  --debug                     print lots of debugging information.
    echo   Download:
    echo     -nc, --no-clobber                skip downloads that would download to existing files.
    echo     -c,  --continue                  resume getting a partially-downloaded file.
    echo     -N,  --timestamping              don't re-retrieve files unless newer than local.
    echo          --restrict-file-names=OS    restrict chars in file names to ones OS allows.
    echo          --ignore-case               ignore case when matching files/directories.
    echo   Security:
    echo          --no-check-certificate      to ignore certificates (particularly self-signed)..
    echo   User:
    echo          --user=USER                 set both ftp and http user to USER.
    echo          --password=PASS             set both ftp and http password to PASS.
    echo   Directories:
    echo     -x,  --force-directories         force creation of directories.
    echo   HTTP options:
    echo          --no-cache                  disallow server-cached data.
    echo     -E,  --html-extension            save HTML documents with `.html' extension.
    echo          --max-redirect              maximum redirections allowed per page.
    echo          --referer=URL               include `Referer: URL' header in HTTP request.
    echo     -U,  --user-agent=AGENT          identify as AGENT instead of Wget/VERSION.
    echo   Recursive download:
    echo     -r,  --recursive                 specify recursive download.
    echo     -l,  --level=NUMBER              maximum recursion depth (inf or 0 for infinite).
    echo     -k,  --convert-links             make links in downloaded HTML point to local files.
    echo     -p,  --page-requisites           get all images, etc. needed to display HTML page.
    echo   Recursive accept/reject:
    echo     -A,  --accept=LIST               comma-separated list of accepted extensions.
    echo     -R,  --reject=LIST               comma-separated list of rejected extensions.
    echo     -D,  --domains=LIST              comma-separated list of accepted domains.
    echo          --follow-ftp                follow FTP links from HTML documents.
    echo     -np, --no-parent                 don't ascend to the parent directory.
    goto :eof

:displayexamples
    call :usage
    echo.
    echo EXAMPLES:
    echo.
    echo   %~nx0 --output-file=OUTPUT.txt --debug --recursive --level=0 --no-clobber --page-requisites --force-directories --html-extension --convert-links --restrict-file-names=windows --domains=www.ibiblio.com www.ibiblio.com/pub/somewhere
    echo.
    goto :eof

:displayall
    call :usage
    echo.
    echo.
    "%~dp0apps\wget\wget.exe " --help
    goto :eof

:main
    if /i "%1"=="--help" call :displayall && exit /B 0
    if /i "%1"=="--examples" call :displayexamples && exit /B 0
    if "%1"=="" call :usage && exit /B 0
    if "%1"=="/?" call :displayhints && exit /B 0

    "%~dp0apps\wget\wget.exe" %*

    goto :eof
