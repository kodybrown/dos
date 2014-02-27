
# Export and import a shortcut (.lnk) to and from a text file (particularly useful as a Beyond Compare File Format)

* [__exportlink.vbs__](https://github.com/kodybrown/dos/blob/master/exportlink.vbs) » exports/imports the properties of the specified link (shortcut) including the target, arguments, directory, icon, description, hotkey, and windowstyle.

## Usage:

There is no usage information (--help) provided by the script itself, so here it is:

    USAGE:
      exportlink.vbs [--export] "input.lnk" "output.txt"
      exportlink.vbs --import "input.txt" "shortcut.lnk"

## Example:

Here is an example:

    $ exportlink.vbs "Beyond Compare 3.lnk" "Beyond Compare 3.txt"

This exports the properties from 'Beyond Compare 3.lnk' to the 'Beyond Compare 3.txt' text file.

    $ exportlink.vbs --import "Beyond Compare 3.txt" "Beyond Compare 3.lnk"

This sets the properties in 'Beyond Compare 3.lnk' from the values in the 'Beyond Compare 3.txt' text file.

### Sample output

```BatchFile
    $ exportlink.vbs "Beyond Compare 3.lnk" "Beyond Compare 3.txt"
    $ type "Beyond Compare 3.txt"

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    SOURCE: Beyond Compare 3.lnk
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    TargetPath=%bin%\apps\Beyond Compare 3\BCompare.exe
    Arguments=
    WorkingDirectory=
    IconLocation=%bin%\apps\Beyond Compare 3\BCompare.exe,0
    Description=
    Hotkey=
    WindowStyle=1
```

## Creating a Beyond Compare File Format

1. Create a new File Format named `Shortcuts`.
2. On the 'General' tab,
    1. Change the 'Mask' to `*.lnk`.
3. On the 'Conversion' tab,
    1. In the 'Conversion' drop-down, select `External program (ANSI filename)`.
    2. Set the 'Loading' text-box to `wscript.exe Helpers\exportlink.vbs %s %t`.
    3. Make sure 'Disable editing' is unchecked.
    4. Set the 'Saving' text-box to `wscript.exe Helpers\exportlink.vbs --update %s %t`.
    5. Make sure 'Trim trailing whitespace' is unchecked. (Or else, after a save bc may show the files as different, depending on the changes made. Reload/refresh the comparison to fix.)

The path for the Loading and Saving text-boxes can be an absolute path (such as 'C:\bin\exportlink.vbs') or a relative path. Relative paths start from the directory that BCompare.exe is located (such as 'C:\Progam Files (x86)\Beyond Compare 3').

I copy my utilities such as exportlink.vbs to the `Beyond Compare 3\Helpers` directory. This is pretty much the standard that I have seen for File Format converters.
