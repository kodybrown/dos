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
                For the rare occasion there is a need to simultaneously install
                multiple versions, I include the version in the directory name.
                The only example I have of that is Python 2.x and Python 3.x,
                which I install to '%tools%\Python276' and '%tools%\Python334'.
                (For my default Python version, I create an un-versioned
                junction that points to my default or standard version. In this
                case I point '%tools%\Python' (junction) to '%tools%\Python334'.
                Download junction.exe [here](http://technet.microsoft.com/en-us/sysinternals/bb896768.aspx).

### Expected executable utilities

#### sdelete.exe

Sysinternals is awesome. Period. A basic requirement for using and managing a Windows machine.

Download: [sdelete.exe](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx)

#### sort.exe [mingw/cygwin]

You can build/compile your own or download one of the many fine versions available. I prefer the mingw package, but that doesn't mean anything to anyone else. For convience, I have uploaded the sort.exe from my mingw installation to my Dropbox account.

Download: [sort.exe](https://dl.dropboxusercontent.com/u/123747/utils/sort.exe)

> The Microsoft version of sort.exe works just fine, but the nix version allows me to also remove duplicates.

#### cat.exe

I am referring to my version of [cat.exe](https://github.com/kodybrown/cat), because it does beautiful word-wrapping on the command-line.

#### sleep.exe

I am referring to my version of [sleep.exe](https://github.com/kodybrown/sleep), but any version will work assuming it's first argument is the number of milliseconds to wait before exiting.



## Create thumbnail images from .pdf files

* [__pdf2jpg.bat__](https://github.com/kodybrown/dos/blob/master/pdf2jpg.bat) » Creates a thumbnail of one or more pages within one or more .pdf files. This batch file is just an easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.
* [Documentation](https://github.com/kodybrown/dos/blob/master/pdf2jpg.bat.md)

## Encrypting files

* [__encrypt.bat__](https://github.com/kodybrown/dos/blob/master/encrypt.bat) » a simple wrapper for using openssl.exe to easily _encrypt_ files.
* [__decrypt.bat__](https://github.com/kodybrown/dos/blob/master/decrypt.bat) » a simple wrapper for using openssl.exe to easily _decrypt_ files.
* [Documentation](https://github.com/kodybrown/dos/blob/master/encrypt.bat.md)


## Editing multiple shortcut (.lnk) files

* [__editlinks.vbs__](https://github.com/kodybrown/dos/blob/master/editlinks.vbs) » modifies specified shortcut (.lnk) file's paths, including the target, directory, icon, and description (if applicable).
* [Documentation](https://github.com/kodybrown/dos/blob/master/editlinks.vbs.md)
