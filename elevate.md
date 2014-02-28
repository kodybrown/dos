
# Running applications with elevated permissions (as administrator)

Both of these files are required.

* [__elevate.cmd__](https://github.com/kodybrown/dos/blob/master/elevate.cmd) » open the specified application with elevated permissions (run as administrator).
* [__elevate.vbs__](https://github.com/kodybrown/dos/blob/master/elevate.vbs) » this is NOT called directly. elevate.cmd calls this.

## Usage:

There is no usage information provided by the script itself, so here it is:

    USAGE:
      elevate.cmd application [application arguments]

That's it.

## Example:

Here is an example:

    > elevate.cmd "notepad.exe" "C:\Windows\System32\drivers\etc\hosts"

This open the hosts file in and elevated notepad.exe.
