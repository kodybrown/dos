@echo off

echo Starting iTunes Services...

if exist "C:\Program Files\iTunes\iTunesHelper.exe" (
	start "iTunesHelper" /b "C:\Program Files\iTunes\iTunesHelper.exe"
) else if exist "C:\Program Files (x86)\iTunes\iTunesHelper.exe" (
	start "iTunesHelper" /b "C:\Program Files (x86)\iTunes\iTunesHelper.exe"
)

net start "Apple Mobile Device"
net start "Bonjour Service"
net start "iPod Service"

goto :eof
