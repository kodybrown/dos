
# Saving and retrieving command-line history

* [__history.bat__](https://github.com/kodybrown/dos/blob/master/history.bat) » allows using 'history' like on Linux. requires start_dos.bat and exit_dos.bat.

This batch file provides a way to access your command-line history in DOS.

Command-line history is loaded at the begining of a DOS session by the [start_dos.bat](https://github.com/kodybrown/dos/blob/master/start_dos.bat) batch file or by calling `history.bat --load`.

In order to save your current session's command-lines, either call `history.bat --save` or create a new alias like this `alias.bat exit=exit_dos.bat $*' which will in turn call history's --save command.

## Usage:

    USAGE:
      history.bat [options]
      history.bat query

If there are no arguments, all previous command-lines are listed. If there is only one argument, all command-line history that contain it are displayed.

See `history.bat --help` for all the details.

## Example:

Create a new macro

    > alias e=echo text: $*
    > e testing..
    text: testing..
