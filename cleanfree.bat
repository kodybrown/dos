@setlocal EnableDelayedExpansion
@echo off

if "%1"=="/?" (
	echo Continually securely deletes all free space on all available drives. Does not stop.
	echo Created 2007 @wasatchwizard
    echo +++++++++++++++++++
    echo  REQUIRES:
    echo    sdelete.exe from sysinternals
    echo +++++++++++++++++++
	endlocal && exit /B 0
)

:init
    set /a max=10
    set /a count=0

:parse
    if not "%1"=="" (
        set drive=%~1
    ) else (
        set drive=C
    )

:main
    rem gte == greater than or equal
	if %count% equ %max% endlocal && exit /B 0

    echo Cleaning free space ^(pass %count% of %max^)..

    call :incrementcount

    echo ---------------------------------------------------------------------
    echo Starting pass #%count% for %drive%
    date /T
    time /T

    rem if exist "%drive%:\" (
        sdelete.exe -p 1 -c -z %drive%
    rem )

    goto :main

:incrementcount
    set /a count+=1
    goto :eof
