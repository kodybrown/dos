@echo off
rem Runs sdelete.exe continually, cleaning all free space
:runit
	sdelete -p 1 -c C:
	goto runit
