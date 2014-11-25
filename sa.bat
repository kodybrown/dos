@rem svn sa    svn add %*
@if "%~1"=="" call svn add .
@if not "%~1"=="" call svn add %*
