
# Empty the Recycle Bin from the command-line

* [__emptybin.bat__](https://github.com/kodybrown/dos/blob/master/emptybin.bat) » empties the recycle bin. requires 'recycle.exe' or 'nircmd.exe'.

## Usage:

This simple batch file simply attempts to call `recycle.exe` or `nircmd.exe` to empty the recycle bin.

    USAGE:
      emptybin.bat

## Details about `recycle.exe`

I use `recycle.exe` from [Frank P. Westlake][1]. It provides a nice before and after status. (I've been using Frank's various utilities for well over ten years..)

    C:\> recycle.exe /E /F
    Recycle Bin: ALL
        Recycle Bin C:  44 items, 42,613,970 bytes.
        Recycle Bin D:   0 items, 0 bytes.
                Total:  44 items, 42,613,970 bytes.

    Emptying Recycle Bin: ALL
        Recycle Bin C:   0 items, 0 bytes.
        Recycle Bin D:   0 items, 0 bytes.
                Total:   0 items, 0 bytes.

It also has many more uses and options (output listed is from /?).

    Recycle all files and folders in C:\TEMP:
      RECYCLE C:\TEMP\*

    List all DOC files which were recycled from any directory on the C: drive:
      RECYCLE /L C:\*.DOC

    Restore all DOC files which were recycled from any directory on the C: drive:
      RECYCLE /U C:\*.DOC

    Restore C:\temp\junk.txt to C:\docs\resume.txt:
      RECYCLE /U "C:\temp\junk.txt" "C:\docs\resume.txt"

    Rename in place C:\etc\config.cfg to C:\archive\config.2007.cfg:
      RECYCLE /R "C:\etc\config.cfg" "C:\archive\config.2007.cfg"

  [1]: http://ss64.net/westlake/xp/index.html
