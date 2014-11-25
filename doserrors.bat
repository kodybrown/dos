@echo off

echo MS-DOS extended errors
echo http://support.microsoft.com/kb/74463
echo.

echo DEC  HEX   Description
echo 00   00h   No error
echo 01   01h   Function number invalid
echo 02   02h   File not found
echo 03   03h   Path not found
echo 04   04h   Too many open files (no file handles available)
echo 05   05h   Access denied
echo 06   06h   Invalid handle
echo 07   07h   Memory control block destroyed
echo 08   08h   Insufficient memory
echo 09   09h   Memory block address invalid
echo 10   0Ah   Environment invalid (usually ^>32k in length)
echo 11   0Bh   Format invalid
echo 12   0Ch   Access code invalid
echo 13   0Dh   Data invalid
echo 14   0Eh   (reserved)
echo 15   0Fh   Invalid drive
echo 16   10h   Attempted to remove current directory
echo 17   11h   Not same device
echo 18   12h   No more tiles
echo 19   13h   Disk write-protected
echo 20   14h   Unknown unit
echo 21   15h   Drive not ready
echo 22   16h   Unknown command
echo 23   17h   Data error (CRC)
echo 24   18h   Bad request structure length
echo 25   19h   Seek error
echo 26   1Ah   Unknown media type (non-DOS disk)
echo 27   1Bh   Sector not found
echo 28   1Ch   Printer out of paper
echo 29   1Dh   Write fault
echo 30   1Eh   Read fault
echo 31   1Fh   General failure
echo 32   20h   Sharing violation
echo 33   21h   Lock violation
echo 34   22h   Disk change invalid
echo 35   23h   FCB unavailable
echo 36   24h   Sharing buffer invalid
echo 37   25h   (DOS 4+) code page mismatch
echo 38   26h   (DOS 4+) cannot complete file operation (out of input)
echo 39   27h   (DOS 4+) insufficient disk space
echo 40   28h   (reserved)
echo 41   29h   (reserved)
echo 42   2Ah   (reserved)
echo 43   2Bh   (reserved)
echo 44   2Ch   (reserved)
echo 45   2Dh   (reserved)
echo 46   2Eh   (reserved)
echo 47   2Fh   (reserved)
echo 48   30h   (reserved)
echo 49   31h   (reserved)
echo 50   32h   Network request not supported
echo 51   33h   Remote computer not listening
echo 52   34h   Duplicate name on network
echo 53   35h   Network name not found
echo 54   36h   Network busy
echo 55   37h   Network device no longer exists
echo 56   38h   Network BIOS command limit exceeded
echo 57   39h   Network adapter hardware error
echo 58   3Ah   Incorrect response from network
echo 59   3Bh   Unexpected network error
echo 60   3Ch   Incompatible remote adapter
echo 61   3Dh   Print queue full
echo 62   3Eh   Queue not full
echo 63   3Fh   Not enough space to print file
echo 64   40h   Network name was deleted
echo 65   41h   Network access denied
echo 66   42h   Network device type incorrect
echo 67   43h   Network name not found
echo 68   44h   Network name limit exceeded
echo 69   45h   Network BIOS session limit exceeded
echo 70   46h   Temporarily paused
echo 71   47h   Network request not accepted
echo 72   48h   Network print / disk redirection paused
echo 73   49h   (LANtastic) invalid network version
echo 74   4Ah   (LANtastic) account expired
echo 75   4Bh   (LANtastic) password expired
echo 76   4Ch   (LANtastic) login attempted invalid at this time
echo 77   4Dh   (LANtastic) disk limit exceed on network node
echo 78   4Eh   (LANtastic) not logged in to network node
echo 79   4Fh   (reserved)
echo 80   50h   File exists
echo 81   51h   (reserved)
echo 82   52h   Cannot make directory
echo 83   53h   Fail on INT 24h
echo 84   54h   (DOS 3.3+) too many redirections
echo 85   55h   (DOS 3.3+) duplicate redirection
echo 86   56h   (DOS 3.3+) invalid password
echo 87   57h   (DOS 3.3+) invalid parameter
echo 88   58h   (DOS 3.3+) network write fault
echo 89   59h   (DOS 4+) function not supported on network
echo 90   5Ah   (DOS 4+) required system component not installed

if /i [%1] equ [p] pause & goto :eof
if /i [%1] equ [-p] pause & goto :eof
if /i [%1] equ [/p] pause & goto :eof
if /i [%1] equ [pause] pause & goto :eof
if /i [%1] equ [-pause] pause & goto :eof
if /i [%1] equ [/pause] pause & goto :eof
if /i [%1] equ [--pause] pause & goto :eof

goto :eof
