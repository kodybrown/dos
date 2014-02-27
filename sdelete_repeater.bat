@echo off
rem Runs sdelete.exe continually, cleaning all free space
:runit
	sdelete -p 1 -z C:
	goto runit