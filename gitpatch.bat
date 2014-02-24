@setlocal
@echo off

set D=%DATE%
set T=%TIME%
if "%T:~0,1%"==" " set T=0%T:~1%

set CODEPATH=C:\code\Director

cd /D "%CODEPATH%"

if /i "%1"=="--cached" (
    set TYPE=--cached
) else if /i "%1"=="-cached" (
    set TYPE=--cached
) else if /i "%1"=="cached" (
    set TYPE=--cached
) else if /i "%1"=="staged" (
    set TYPE=--cached

) else if /i "%1"=="head" (
    set TYPE=HEAD
) else if /i "%1"=="all" (
    set TYPE=HEAD

) else if /i "%1"=="unstaged" (
    set TYPE=
) else (
    set TYPE=
    set TYPENAME=unstaged
)

set FILENAME=%Profile%\Desktop\%D:~-4%-%D:~4,2%-%D:~7,2% %T:~0,2%-%T:~3,2%-%T:~6,2% Current Work (%TYPENAME%).patch

rem git format-patch -1 --stdout > "%FILENAME%"
git diff %TYPE% >"%FILENAME%"

@endlocal && exit /B 0