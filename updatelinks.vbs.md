
# Editing multiple shortcut (.lnk) files

* [__editlinks.vbs__](https://github.com/kodybrown/dos/blob/master/editlinks.vbs) » modifies specified shortcut (.lnk) file's paths, including the target, directory, icon, and description (if applicable).

## Usage:

There is no usage information provided by the script itself, so here it is:

    USAGE:
      editlinks.vbs [/s|--recursive] [--path C:\somewhere] "replace" "with" ["replace" "with"] ["replace" "with"] ...

This will update all paths:

* Target — the application linked to
* Start in — the starting directory
* Icon — the location of the icon

It will also empty the description property/field if it matches (exactly) the Target.

Here is an example:

    > editlinks.vbs --path "C:\new-bin" "C:\old-bin" "C:\new-bin"

This will change all shortcuts that point to 'C:\old-bin' to point instead to 'C:\new-bin'.

> NOTE: When retrieving the TargetPath from a shortcut, it will (sometimes?) expand any environment variables already in it. This will cause the number of changed files to seem quite large (and never go down).
