@setlocal
@echo off

::
:: Elevation PowerToys for Windows Vista v1.1 (04/29/2008)
:: http://technet.microsoft.com/en-us/magazine/2008.06.elevation.aspx
::
:: REQUIRES:
::   elevate.vbs
::
:: To provide a command line method of launching applications that
:: prompt for elevation (Run as Administrator) on Windows Vista.
::
:: Usage:
::   elevate.cmd application <application arguments>
::

:: Pass raw command line agruments and first argument to elevate.vbs
:: through environment variables.
set ELEVATE_CMDLINE=%*
set ELEVATE_APP=%1

start wscript //nologo "%~dpn0.vbs" %*
