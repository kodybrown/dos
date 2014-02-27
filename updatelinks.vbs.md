
# Editing multiple shortcut (.lnk) files

* [__updatelinks.vbs__](https://github.com/kodybrown/dos/blob/master/updatelinks.vbs) » modifies multiple shortcut (.lnk) files' properties, including the target, arguments, directory, icon, and description.

## Usage:

There is no usage information provided by the script itself, so here it is:

    USAGE:
      updatelinks.vbs [/s|--recursive] [--path C:\somewhere] "replace" "with" ["replace" "with"] ["replace" "with"] ...

    if 'path' is omitted, the current directory is used.

This will replace every occurrence of 'replace' with 'with' in each of the following properties:

* Target — the application linked to
* Argument — the target's arguments
* Start in — the starting directory
* Icon — the location of the icon

It will also empty the Description property if it matches the Target property (exactly).

## Example:

Here is an example:

    > updatelinks.vbs --path "C:\new-bin" "C:\old-bin" "C:\new-bin"

This will replace all occurrances of 'C:\old-bin' in each supported property with 'C:\new-bin' instead.

> NOTE: When retrieving the TargetPath from a shortcut, it will (sometimes?) expand any environment variables already in it. This will cause the number of changed files to seem quite large (and never go down). I'm not sure why this happens!?
