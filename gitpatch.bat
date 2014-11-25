@setlocal EnableDelayedExpansion
@echo off

:init
	set "D=%DATE%"
	set "T=%TIME%"
	if "%T:~0,1%"==" " set "T=0%T:~1%"

	set "filepart="

:parse
	if "%~1"=="" goto :main

	if /i "%1"=="--cached" set "fileset=--cached" && shift && goto :parse
	if /i "%1"=="-cached" set "fileset=--cached" && shift && goto :parse
	if /i "%1"=="cached" set "fileset=--cached" && shift && goto :parse
	if /i "%1"=="--staged" set "fileset=--cached" && shift && goto :parse
	if /i "%1"=="-staged" set "fileset=--cached" && shift && goto :parse
	if /i "%1"=="staged" set "fileset=--cached" && shift && goto :parse

	if /i "%1"=="--head" set "fileset=HEAD" && shift && goto :parse
	if /i "%1"=="-head" set "fileset=HEAD" && shift && goto :parse
	if /i "%1"=="head" set "fileset=HEAD" && shift && goto :parse
	if /i "%1"=="--all" set "fileset=HEAD" && shift && goto :parse
	if /i "%1"=="-all" set "fileset=HEAD" && shift && goto :parse
	if /i "%1"=="all" set "fileset=HEAD" && shift && goto :parse

	if /i "%1"=="--unstaged" set "fileset=" && shift && goto :parse
	if /i "%1"=="-unstaged" set "fileset=" && shift && goto :parse
	if /i "%1"=="unstaged" set "fileset=" && shift && goto :parse

	:: Use any other argument as part of the file name..
	if "%filepart%"=="" set filepart=%~1

	shift
	goto :parse

:main
	if "%fileset%"=="" (
		set filesetname=unstaged
	) else (
		set filesetname=!fileset!
		rem if "%filesetname:~0,2%"=="--" set filesetname=%filesetname:~2%
		if "!filesetname:~0,2!"=="--" (
	        set filesetname=!filesetname:~2!
	    )
	)

	if "!filepart!"=="" set "filepart=Current Work"
	if not "!filesetname!"=="" set "filesetname= (!filesetname!)"

	set filename=%UserProfile%\Desktop\%D:~-4%-%D:~4,2%-%D:~7,2% %T:~0,2%-%T:~3,2%-%T:~6,2% !filepart!!filesetname!.patch

	:: Different ways to create a patch..
	rem git format-patch -1 --stdout > "%filename%"
	rem git diff %fileset% >"%filename%"

	echo git diff %fileset% ^>"%filename%"
	git diff %fileset% >"%filename%"

:end
	endlocal && exit /B 0
