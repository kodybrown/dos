dos
===

Some of my batch files and scripts

# DOS environment


While I have tried to always make my batch files work in any environment, you may need to change some variables, envars, and/or paths to suit your needs and your computer environment.

### Expected environment variables


    BIN         This is where all of my utilities live (C:\tools). This
                includes my exe's and all of my batch and script files. Within
                this folder is an apps folder (`%bin%\apps`). Any utility that
                is larger than one or two files, is put here with its own sub-
                directory (such as `%bin%\apps\tcmd`). I create a .bat or .lnk
                file in %bin% to the main util exe buried in the sub-directory.

    PROFILE     Generally, this is the same as %UserProfile%. The reason I have
                a separate envar is because I often am working on someone
                else's computer and launch a console window to use my tools.
                So, I can `set` the profile path without affecting Windows'
                normal behavior, etc.

    TOOLS       This is where the big tools go. Applications such as mingw, Go,
                Git, Subversion, ADK, nodejs, mono, Python, Perl, Chocolately,
                Vagrant, and many more all go here. This folder is HUGE.

                I generally install tools in a 'version-less' folder, such as
                '%tools%\mono' and '%tools%\git'. I create a new directory
                under it with the version number in it, to use as a reference.
                For the rare occasion there is a need to simultaneoudly install
                multiple versions, I include the version in the directory name.
                The only example I have of that is Python 2.x and Python 3.x,
                which I install to '%tools%\Python276' and '%tools%\Python334'.
                (For my default Python version, I create an un-versioned
                junction that points to my default or standard version. In this
                case I point '%tools%\Python' (junction) to '%tools%\Python334'.

### Expected executable utilities

#### sdelete.exe

Sysinternals.

#### sort.exe [mingw/cygwin]

> The Microsoft version of sort.exe works just fine, but the nix version allows me to also remove duplicates.

#### cat.exe

I am referring to my version of [cat.exe](https://github.com/kodybrown/cat), because it does beautiful word-wrapping on the command-line.

#### sleep.exe

I am referring to my version of [sleep.exe](https://github.com/kodybrown/sleep), but any version will work assuming it's first argument is the number of milliseconds to wait before exiting.


## Create thumbnail images from .pdf files

* __pdfjpg.bat__ » Creates a thumbnail of one or more pages within one or more .pdf files. This batch file is just an easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.

### Requires:

* __gswin64c.exe__ » GhostScript command-line tool. [[Download](http://www.ghostscript.com/download/gsdnld.html)]

### Usage:

    pdf2jpg.bat | Created 2014 @wasatchwizard.
                | Released under the MIT License.

    Creates a thumbnail of pages within a .pdf file. This batch file is just an
    easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.

      +++++++++++++++++++
       REQUIRES:
         gswin64c.exe (GhostScript)
      +++++++++++++++++++

    USAGE: pdf2jpg.bat [options] [file]

      file            Creates a thumbnail of the first page of the specified file.
      no-file         Creates a thumbnail of the first page of every .pdf file in
                      the current directory.

    OPTIONS:

      -h --help       Displays this help.
      -q --quiet      No output is displayed (except errors), and no input will be
                      asked for.
      -v --verbose    Displays extra details during processing.
      -p --pause      Pauses when it is finished (ignored if `-q` is specified).
      -R --recursive  Processes .pdf in sub-directories as well.

      --max n         Specify the maximum number of files to process.
      --overwrite [yes|no|ask]
                      Specifies what to do if the output file already exists.
                      The default if not specified is ask. The file is ignored if
                      `overwrite=ask` and `-quiet` is specified.

> Many thanks to [KenS](http://stackoverflow.com/users/701996/kens) for pointing out [just how easy it is to use ghostscript](http://stackoverflow.com/questions/12614801/how-to-execute-imagemagick-to-convert-only-the-first-page-of-the-multipage-pdf-t) directly, instead of ImageMagick.

## Encrypting files

* __encrypt.bat__ » a simple wrapper for using openssl.exe to easily encrypt files.
* __decrypt.bat__ » a simple wrapper for using openssl.exe to easily decrypt files.

### Usage:

The `encrypt.bat` and `decrypt.bat` files behave the same. So, in the examples below you can use encrypt or decrypt.

To show usage information:

    encrypt
    encrypt /?
    encrypt --help

To encrypt a file in-place (the original file is overwritten with the newly encrypted file):

    encrypt file

To encrypt a file and save the output into a new file (the original file is not touched):

    encrypt infile outfile

## Editing multiple shortcut (.lnk) files

* __editlinks.vbs__ » modifies specified shortcut (.lnk) file's paths, including the target, directory, icon, and description (if applicable).

### Usage:

The script file

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

