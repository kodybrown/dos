@echo off

echo Stopping iTunes Services...

pskill -t iTunesHelper.exe

net stop "Apple Mobile Device"
net stop "Bonjour Service"
net stop "iPod Service"

goto :eof
