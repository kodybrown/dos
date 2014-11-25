@echo off

:init
    set "yesToAllFiles="
    set "yesToAllDirs="

:main
    echo.
    echo This will delete all files matching common packages
    echo in preparation for securely deleting the rest of the files.
    echo.
    echo Press Ctrl+C to cancel or any other key to continue:
    pause

    echo.
    echo Legend:
    echo   [Y]es to perform the operation
    echo   [N]o to skip the operation
    echo.

    call :file_prompt "*.jpeg *.jpg *.gif *.png *.ico"
    call :file_prompt "*.ttf *.otf *.eot *.woff"
    call :file_prompt "*.flv *.swf"
    call :file_prompt "*.mp3 *.mp4 *.ogg"
    call :file_prompt "*.suo"
    call :file_prompt "*.pdf"
    call :file_prompt "*.exe"
    call :file_prompt "*.dll"
    call :file_prompt "AjaxControlToolkit.exe AjaxControlToolkit.dll"
    call :file_prompt "*.bat *.cmd"
    call :file_prompt "*.psd *.ai"

    call :file_pattern "ext-"
    call :dir_prompt "Ext"
    
    call :file_pattern "jquery"
    call :dir_prompt "jquery jquery-*"

    call :file_pattern "angular"
    call :dir_prompt "angular angular-ui"

    call :file_pattern "bootstrap"
    call :dir_prompt "bootstrap"
    
    call :file_pattern "font-awesome"
    call :dir_prompt "font-awesome"
    call :file_pattern "fontawesome"
    call :dir_prompt "fontawesome"
    
    call :file_pattern "modernizr"
    call :dir_prompt "modernizr"

    call :file_pattern "html5shiv"
    call :dir_prompt "html5shiv"

    call :file_pattern "kendo"
    call :dir_prompt "kendo"

    call :file_pattern "knockout"
    call :dir_prompt "knockout"

    call :dir_prompt "bin obj"
    call :dir_prompt "debug release"
    call :dir_prompt "Web References"

    call :dir_prompt "packages"
    call :dir_prompt ".nuget"
    call :dir_prompt "node_modules"
    call :dir_prompt "bower_components"

    echo.
    echo Finished.

    goto :end

:file_pattern
    call :file_prompt "%~1*.js* %~1*.css* %~1*.less* %~1*.scss* %~1*.map %~1*.svg"
    goto :eof

:file_prompt
    echo.

    if defined yesToAllFiles (
        echo DELETE FILE^(S^): %~1 [yna/f] F
        call :file_delete "%~1"
        goto :eof
    )

    choice /C ynaf /N /M "DELETE FILE(S): %~1? [yn/f] "
    if %errorlevel% EQU 4 set "yesToAllFiles=1" && call :file_delete "%~1" && goto :eof
    if %errorlevel% EQU 3 goto :end
    if %errorlevel% EQU 2 goto :eof
    if %errorlevel% EQU 1 call :file_delete "%~1" && goto :eof
    goto :eof

:file_delete
    call del /s /f /q %~1
    goto :eof

:dir_prompt
    echo.

    if defined yesToAllDirs (
        echo DELETE DIR^(S^): %~1 [yna/d] D
        call :dir_delete "%~1"
        goto :eof
    )

    choice /C ynad /N /M "DELETE DIR(S): %~1? [yn/d] "
    if %errorlevel% EQU 4 set "yesToAllDirs=1" && call :dir_delete "%~1" && goto :eof
    if %errorlevel% EQU 3 goto :end
    if %errorlevel% EQU 2 goto :eof
    if %errorlevel% EQU 1 call :dir_delete "%~1" && goto :eof
    goto :eof

:dir_delete
    call rrd.exe /s %~1
    goto :eof


:end
    set "yesToAllFiles="
    set "yesToAllDirs="
    exit /B 0
