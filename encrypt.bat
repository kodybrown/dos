@setlocal
@echo off

:: Encrypts the file specified.
:: See the bottom of the file for usage.
:: created by wasatchwizard

:: http://tombuntu.com/index.php/2007/12/12/simple-file-encryption-with-openssl/

:: This batch requires [`openssl.exe`](http://www.openssl.org/) to be in your path.
:: You can get Windows binaries (or an installer) from the following:
:: * [Binary Distributions](http://www.openssl.org/related/binaries.html)
:: ** [Shining Light Productions](http://slproweb.com/products/Win32OpenSSL.html)
:: * [gnuwin32 openssl](http://gnuwin32.sourceforge.net/packages/openssl.htm)

:: I highly recommended that you also have [`sdelete.exe`](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx)
:: from SysInternals' suite of utilities (now part of Microsoft TechNet).
:: `sdelete.exe` is used to securely delete the original file after encrypting/decrypting.

:: You can change the encryption method here, however, I'm pretty sure that `aes-256-cbc`
:: is about the best. Type `openssl --help` to see all options.
set cipher=aes-256-cbc

:main
    if "%~1"=="" goto :usage
    if "%~1"=="/?" goto :usage
    if "%~1"=="--help" goto :usage

    set infile=%~1
    set tmpfile=%~1.encrypted
    if not "%~2"=="" (
        set outfile=%~2
    )
    if "%~2"=="" (
        set outfile=%~1
    )

    :: The 'encrypting' text was created by [asciimo](https://github.com/Marak/asciimo).
    :: Type the following: `asciimo "encrypting" jazmine`
    echo                                            o   o
    echo                                            8
    echo  .oPYo. odYo. .oPYo. oPYo. o    o .oPYo.  o8P o8 odYo. .oPYo.
    echo  8oooo8 8' `8 8    ' 8  `' 8    8 8    8   8   8 8' `8 8    8
    echo  8.     8   8 8    . 8     8    8 8    8   8   8 8   8 8    8
    echo  `Yooo' 8   8 `YooP' 8     `YooP8 8YooP'   8   8 8   8 `YooP8
    echo  :.....:..::..:.....:..:::::....8 8 ....:::..::....::..:....8
    echo  ::::::::::::::::::::::::::::ooP'.8 :::::::::::::::::::::ooP'.
    echo  ::::::::::::::::::::::::::::...::..:::::::::::::::::::::...::
    echo.
    echo     a simple wrapper for using openssl.exe to encrypt files
    echo              batch file created by wasatchwizard
    echo.
    echo    input file: %infile%
    echo        output: %outfile%
    echo.

    where.exe openssl >NUL
    if %errorlevel% neq 0 (
        echo Could not find openssl...
        echo Is it in your path?
        echo exiting.
        pause
        @endlocal && exit /B %errorlevel%
    )

    call openssl %cipher% -a -salt -in "%infile%" -out "%tmpfile%"
    if %errorlevel% neq 0 (
        echo There as an error running openssl.
        echo exiting...
        pause
        @endlocal && exit /B %errorlevel%
    )

    where.exe sdelete.exe >NUL
    if %errorlevel% neq 0 (
        echo Could not find sdelete.exe...
        echo It is more secure to use sdelete, rather than DEL.
        echo Please put it in your path.
        pause
        call del /Q "%outfile%" >NUL
    ) else (
        call sdelete.exe -p 8 "%outfile%" >NUL
    )
    call move "%tmpfile%" "%outfile%"

    @endlocal && exit /B 0

:usage
    :: The 'encrypt' text was created by [asciimo](https://github.com/Marak/asciimo).
    :: Type the following: `asciimo " encrypt " jazmine`
    echo.
    echo                                              o
    echo                                              8
    echo    .oPYo. odYo. .oPYo. oPYo. o    o .oPYo.  o8P
    echo    8oooo8 8' `8 8    ' 8  `' 8    8 8    8   8
    echo    8.     8   8 8    . 8     8    8 8    8   8
    echo    `Yooo' 8   8 `YooP' 8     `YooP8 8YooP'   8
    echo  :::.....:..::..:.....:..:::::....8 8 ....:::..:::
    echo  ::::::::::::::::::::::::::::::ooP'.8 ::::::::::::
    echo  ::::::::::::::::::::::::::::::...::..::::::::::::
    echo.
    echo    simple wrapper using openssl to encrypt files
    echo         batch file created by wasatchwizard
    echo.
    echo    USAGE:
    echo.
    echo    $ %~n0 file
    echo.
    echo      Performs in-place encryption of 'file'.
    echo      WARNING: This overwrites existing file!
    echo.
    echo    $ %~n0 infile outfile
    echo.
    echo      Encrypts 'infile' and saves to 'outfile'.
    echo.
    @endlocal && exit /B 0

