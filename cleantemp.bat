@SETLOCAL EnableDelayedExpansion
@echo off

rem Securely deletes all known temporary file locations.
rem Requires: sdelete.exe (from sysinternals)
rem Author: Kody Brown (kodybrown@gmail.com)
rem Created 2006-11-04

echo =============================================================================================
echo                                 Removing temporary files..
echo =============================================================================================
echo.

Title Removing temporary files..

set passes=6

for %%G in (C D G) do (
    rem if exist "%%G:" (

    rem echo checking.. "%%G:\"
    exists.exe "%%G:\\"
    rem echo ERRORLEVEL=%ERRORLEVEL%
    rem echo ERRORLEVEL=!ERRORLEVEL!

    if !ERRORLEVEL! equ 0 (
        rem echo %%G: exists!

        rem Temp files
        if exist "%%G:\Temp" call :sdelete "%%G:\Temp"
        if exist "%%G:\Windows\Temp" call :delete "%%G:\Windows\Temp"

        for %%N in (Kody.Brown Kody KBrown) do (
            rem Temp files
            if exist "%%G:\Users\%%N\AppData\Local\Temp" call :delete "%%G:\Users\%%N\AppData\Local\Temp"
            if exist "%%G:\Documents and Settings\%%N\Local Settings\Temp" call :delete "%%G:\Documents and Settings\%%N\Local Settings\Temp"

            rem Recent files history
            if exist "%%G:\Users\%%N\AppData\Roaming\Microsoft\Windows\Recent" call :sdelete "%%G:\Users\%%N\AppData\Roaming\Microsoft\Windows\Recent"
            if exist "%%G:\Users\%%N\AppData\Roaming\Microsoft\Office\Recent" call :sdelete "%%G:\Users\%%N\AppData\Roaming\Microsoft\Office\Recent"
            if exist "%%G:\Users\%%N\AppData\Roaming\Microsoft\VisualStudio\Recent" call :sdelete "%%G:\Users\%%N\AppData\Roaming\Microsoft\VisualStudio\Recent"

            rem Epson Scan preview image
            if exist "%%G:\Users\%%N\AppData\Roaming\EPSON\ESCNDV\ES0052" call :sdelete "%%G:\Users\%%N\AppData\Roaming\EPSON\ESCNDV\ES0052"

            rem Google Chrome cache
            if exist "%%G:\Users\%%N\AppData\Local\Google\Chrome\User Data" (
                for /f "tokens=*" %%H in ('"dir /ad /b "%%G:\Users\%%N\AppData\Local\Google\Chrome\User Data\*""') do (
                    if exist "%%G:\Users\%%N\AppData\Local\Google\Chrome\User Data\%%H\Cache" call :delete "%%G:\Users\%%N\AppData\Local\Google\Chrome\User Data\%%H\Cache"
                )
            )

            rem Mozilla Firefox cache
            if exist "%%G:\Users\%%N\AppData\Local\Mozilla\Firefox\Profiles" (
                for /f "tokens=*" %%H in ('"dir /ad /b "%%G:\Users\%%N\AppData\Local\Mozilla\Firefox\Profiles\*""') do (
                    if exist "%%G:\Users\%%N\AppData\Local\Mozilla\Firefox\Profiles\%%H\Cache" call :delete "%%G:\Users\%%N\AppData\Local\Mozilla\Firefox\Profiles\%%H\Cache"
                )
            )

            rem Remote Desktop cache
            if exist "%%G:\Users\%%N\AppData\Local\Microsoft\Terminal Server Client\Cache" call :delete "%%G:\Users\%%N\AppData\Local\Microsoft\Terminal Server Client\Cache"

            rem Remote Desktop cache
            if exist "%%G:\Users\%%N\AppData\Local\Microsoft\Windows\SkyDrive\logs" call :delete "%%G:\Users\%%N\AppData\Local\Microsoft\Windows\SkyDrive\logs"

        )
    )
)

rem if exist "%TEMP%" call :delete "%TEMP%"
rem if exist "%TMP%" call :delete "%TMP%"

Title Command Prompt

if [%1]==[pause] (
    pause
) else if [%1]==[-] (
    pause
) else if not !ERRORLEVEL! equ 0 (
    rem pause
)

@ENDLOCAL && exit /B 0

:sdelete
    echo %~1\*.* (secure delete)
    echo ---------------------------------------------------------------------------------------------
    sdelete.exe -p %passes% -s "%~1\*.*" >nul
    goto :eof

:delete
    echo %~1\*.* (delete)
    echo ---------------------------------------------------------------------------------------------
    del /F /Q /S "%~1\*.*" >nul
    goto :eof
