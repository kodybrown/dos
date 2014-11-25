@if "%~1"=="" for %%G in ("%path:;=" "%") do @if not "%%~G"=="" echo %%~G
@if not "%~1"=="" ( for %%G in ("%path:;=" "%") do @if not "%%~G"=="" echo %%~G ) | findstr /I %~1
