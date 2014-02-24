
# Easily edit the PATH environment variable

* __edpth.bat__ » Easily edit the PATH environment variable with a few options (such as --prepend, --remove, --force, etc.).

## Usage:

    Easily edit the PATH environment variable.
    Copyright (C) 2011-2014 Kody Brown (@wasatchwizard)

    USAGE:

      edpath [options] path

    OPTIONS:

      --debug       Outputs additional information while processing.
      --pause       Pauses at the end of processing.
      --append      Adds the specified path to the end of the PATH envar.
      --prepend     Adds the specified path to the beginning of the PATH envar.
      --remove      Removes the path from the PATH envar.
      --force       Forces adding a path, even if it already exists.

      If `append` and `prepend` are omitted, `append` is assumed.

## Examples:

Append `C:\NewPath` to the end of the PATH envar.

    $ edpath [--append] C:\NewPath

Append `C:\NewPath` to the begining of the PATH envar.

    $ edpath --prepend C:\NewPath

Append `C:\NewPath` to the beginning of the PATH envar, even if it already exists in the path.

    $ edpath --force --prepend C:\NewPath

Removes `C:\Path` from the PATH envar.

    $ edpath --remove C:\Path

## Notes:

Changes to the PATH envar only affect the current process.

