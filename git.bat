@setlocal
@echo off

rem +++++++++++++++++++
rem  REQUIRES:
rem    git.exe
rem +++++++++++++++++++

:init
    set _git_path=

    if exist "%tools%\Git\bin\git.exe" set "_git_path=%tools%\Git\bin\git.exe" && goto :parse
    if exist "C:\Git\bin\git.exe" set "_git_path=C:\Git\bin\git.exe" && goto :parse
    if exist "C:\Program Files\Git\bin\git.exe" set "_git_path=C:\Program Files\Git\bin\git.exe" && goto :parse
    if exist "C:\Program Files (x86)\Git\bin\git.exe" set "_git_path=C:\Program Files (x86)\Git\bin\git.exe" && goto :parse

:parse
    if "%~1"=="" goto :main

    if /i "%1"=="--help" call :usage && endlocal && exit /B 0
    if /i "%1"=="-help" call :usage && endlocal && exit /B 0
    if /i "%1"=="/?" call :usage && endlocal && exit /B 0
    if /i "%1"=="cmds" call :showcmds && endlocal && exit /B 0
    if /i "%1"=="commands" call :showcmds && endlocal && exit /B 0

:main
    if not exist "%_git_path%" goto :notfound

    if /i "%~1"=="purge" (
        echo This will remove all changes, including new files
        echo from your working directory.
        echo.
        echo Are you sure you want to do this?
        echo Press Ctrl+C to cancel or any other key to continue:
        pause
        if %errorlevel% NEQ 0 endlocal && exit /B 0
        :: removes staged and working directory changes
        call "%_git_path%" reset --hard
        :: remove untracked files
        call "%_git_path%" clean -f -d
        :: CAUTION: as above but removes ignored files like config.
        rem call "%_git_path%" clean -f -x -d
    ) else (
        call "%_git_path%" %*
    )
    endlocal && exit /B %errorlevel%

:notfound
    echo Could not find git.exe
    endlocal && exit /B 1

:usage
    call :showcmds
    echo.
    echo.
    echo.
    %_git_path% --help
    goto :eof

:showcmds
    rem echo A simple wrapper for Git.
    rem echo Finds git.exe and provides a few helper commands, such as 'purge', etc.
    echo.
    echo  Available batch files for Git:
    echo.
    echo    batch      command
    echo   ---------- ----------------------------------------------------
    if exist "%~dp0ga.bat" echo    ga         git add
    if exist "%~dp0gb.bat" echo    gb         git branch
    if exist "%~dp0gd.bat" echo    gd         git diff
    if exist "%~dp0gi.bat" echo    gi         git commit
    if exist "%~dp0gl.bat" echo    gl         git log
    if exist "%~dp0gh.bat" echo    gh         git log --oneline --graph --date=short --all
    if exist "%~dp0gs.bat" echo    gs         git status
    if exist "%~dp0gt.bat" echo    gt         git tag
    echo    git.bat    **this file. also g.bat.
    goto :eof
