@setlocal EnableDelayedExpansion
@echo off

rem Securely deletes a file or complete folder

rem +++++++++++++++++++
rem  REQUIRES:
rem    sdelete.exe
rem  OPTIONAL:
rem    pcolor.exe
rem    sleep.exe
rem +++++++++++++++++++

if "%~1"=="" goto :passesrequired
set /a PASSES=%1
shift

if "%~1"=="" goto :fileisrequired

:parse
    if "%~1"=="" goto :end

    if exist "%~1\*.*" call :deldir "%~1" && shift && goto :done
    if exist "%~1" call :delfile "%~1" && shift && goto :done

    :doesntexist
        if exist pcolor.exe call pcolor.exe --crlf {Red}FAILED! \n {Gray}The specified file or folder was not found. \n
        if not exist pcolor.exe echo FAILED! The specified file or folder was not found.
        shift
        goto :parse

    :done
        if not exist "%~1" call pcolor.exe --crlf {White}SUCCESSFUL! \n {Gray}Securely deleted "%~1"..
        if exist "%~1" call pcolor.exe --crlf {Red}FAILED! \n {Gray}Failed to securely delete "%~1"..
        goto :parse

:deldir
    call pcolor.exe --crlf {White}STARTING: \n {Gray}Securely deleting the specified folder "%~1".. \n
    attrib -r -h -s "%~1\*.*" /S /D /L
    sdelete -s -p %PASSES% "%~1\*.*"
    goto :eof

:delfile
    call pcolor.exe --crlf {White}STARTING: \n {Gray}Securely deleting the specified file "%~1".. \n
    attrib -r -h -s "%~1"
    echo sdelete -p %PASSES% "%~1"
    sdelete -p %PASSES% "%~1"
    goto :eof

:passesrequired
	call pcolor.exe --crlf {Red}FAILED! \n {Gray}The number of passes is required.
	if not defined __quiet pause
	endlocal && exit /B 1

:fileisrequired
	call pcolor.exe --crlf {Red}FAILED! \n {Gray}A file or folder is required.
    if not defined __quiet pause
	endlocal && exit /B 2

:end
    call pcolor.exe --crlf {White}FINISHED! \n
    if not defined __quiet (
        if exist "%bin%\sleep.exe" "%bin%\sleep.exe" 350
        if not exist "%bin%\sleep.exe" pause
    )
    endlocal && exit /B 0
