
# Using aliases (DOSKEY macros)

* [__alias.bat__](https://github.com/kodybrown/dos/blob/master/alias.bat) » allows using 'alias' like on Linux (all via DOSKEY). requires start_dos.bat and exit_dos.bat.

This batch file provides an emulation layer to enable using the DOSKEY command like the Linux/UNIX `alias` command.

Macros are loaded at the begining of a DOS session by the [start_dos.bat](https://github.com/kodybrown/dos/blob/master/start_dos.bat) batch file or by calling `alias.bat --load`.

In order to save your aliases, either call `alias.bat --save` or create a new alias like this `alias.bat exit=exit_dos.bat $*' which will in turn call alias' --save command.

## Usage:

    USAGE:
      alias.bat [options]
      alias.bat macroname=macro definition

If there are no arguments, all macros are listed. If there is only one argument, all macros that contain it are displayed.

See `alias.bat --help` for all the details.

## Example:

Create a new macro

    > alias e=echo text: $*
    > e testing..
    text: testing..
