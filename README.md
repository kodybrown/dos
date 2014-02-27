dos utilities
=============

Some of my batch files and scripts. Jump to the bottom for details about how I have set up my DOS environment as well as listing a few executable/utilities that are frequently used in my batch files.

### Setting up the DOS environment

* [__start_dos.bat__](https://github.com/kodybrown/dos/blob/master/start_dos.bat) » sets up my DOS environment. calls `alias.bat --load` and `history.bat --load` to get things started.
* [__exit_dos.bat__](https://github.com/kodybrown/dos/blob/master/exit_dos.bat) » shuts down my DOS environment. calls `alias.bat --save` and `history.bat --save` to get closed down.
* [Documentation](https://github.com/kodybrown/dos/blob/master/start_dos.bat.md)

### Using aliases (DOSKEY macros)

* [__alias.bat__](https://github.com/kodybrown/dos/blob/master/alias.bat) » allows using 'alias' like on Linux (all via DOSKEY). requires start_dos.bat and exit_dos.bat.
* [Documentation](https://github.com/kodybrown/dos/blob/master/alias.bat.md)

### Saving and retrieving command-line history

* [__history.bat__](https://github.com/kodybrown/dos/blob/master/history.bat) » allows using 'history' like on Linux. requires start_dos.bat and exit_dos.bat.
* [Documentation](https://github.com/kodybrown/dos/blob/master/history.bat.md)

### Basic utilities and wrappers

DIR command wrappers

* [__dc.bat__](https://github.com/kodybrown/dos/blob/master/dc.bat) » kists files where name contains the value specified.
* [__dd.bat__](https://github.com/kodybrown/dos/blob/master/dd.bat) » lists (only) directories where name contains the value specified.
* [__de.bat__](https://github.com/kodybrown/dos/blob/master/de.bat) » lists files where name (not including extension) ends with the value specified.
* [__ds.bat__](https://github.com/kodybrown/dos/blob/master/ds.bat) » lists files where name starts with the value specified.
* [__dx.bat__](https://github.com/kodybrown/dos/blob/master/dx.bat) » lists files where extension contains the value specified.

A few other little utilities

* [__''.bat__](https://github.com/kodybrown/dos/blob/master/''.bat) » changes to the root of the current drive (ie: 'cd\').
* [__'.bat__](https://github.com/kodybrown/dos/blob/master/'.bat) » changes to the current directories parent (ie: 'cd..'). did i mention that i'm lazy, yet?
* [__cdor.bat__](https://github.com/kodybrown/dos/blob/master/cdor.bat) » changes to first argument (a directory) that exists.
* [__count.bat__](https://github.com/kodybrown/dos/blob/master/count.bat) » counts the number of lines in the specified file and returns the count as the errorlevel.
* [__edit.bat__](https://github.com/kodybrown/dos/blob/master/edit.bat) » redirects to n.bat.
* [__n.bat__](https://github.com/kodybrown/dos/blob/master/n.bat) » opens notepad2. will convert forward slashes to back-slashes, 'hosts' shortcut (including sudo if available), etc.
* [__np.bat__](https://github.com/kodybrown/dos/blob/master/np.bat) » same as n.bat only for notepad++.
* [__nu.bat__](https://github.com/kodybrown/dos/blob/master/nu.bat) » simple wrapper for `net use`. yes. i am a lazy typer.. err.. typist.
* [__subl.bat__](https://github.com/kodybrown/dos/blob/master/subl.bat) » same as n.bat only for Sublime Text 3.
* [__sublime.bat__](https://github.com/kodybrown/dos/blob/master/sublime.bat) » redirects to subl.bat.

I hate iTunes.

* [__itunes-start.bat__](https://github.com/kodybrown/dos/blob/master/itunes-start.bat) » starts itunes' services and helper, then starts itunes itself.
* [__itunes-stop.bat__](https://github.com/kodybrown/dos/blob/master/itunes-stop.bat) » stops all of itunes services and helper.

### Linux on DOS wrappers

The following batch files do a decent job of emulating linux commands in dos.
For instance, common '--' arguments are supported and will convert forward slashes to back-slashes.

* [__cp.bat__](https://github.com/kodybrown/dos/blob/master/cp.bat) » copies files based on specified arguments.
* [__ls.bat__](https://github.com/kodybrown/dos/blob/master/ls.bat) » lists files based on specified arguments.
* [__mv.bat__](https://github.com/kodybrown/dos/blob/master/mv.bat) » moves a file or files.
* [__pwd.bat__](https://github.com/kodybrown/dos/blob/master/pwd.bat) » prints the working directory ('cd').
* [__rm.bat__](https://github.com/kodybrown/dos/blob/master/rm.bat) » deletes a file or files.

Also, check out the sections above on aliases and history.

### Git wrappers

I have all but replaced these batch files with aliases (doskey macros). See 'Aliases (DOSKEY macros)' above for more details.

* [__git.bat__](https://github.com/kodybrown/dos/blob/master/git.bat) » provides a wrapper to find and execute git.exe. also supports a 'purge' option.
* [__ga.bat__](https://github.com/kodybrown/dos/blob/master/ga.bat) » adds files (ie: 'git.bat add [.|%*]').if no argument is specified, it appends a dot ('.') for adding 'all'.
* [__gh.bat__](https://github.com/kodybrown/dos/blob/master/gh.bat) » shows the history (ie: 'git.bat log --oneline --graph --date=short --all --max-count=20 %*').
* [__gi.bat__](https://github.com/kodybrown/dos/blob/master/gi.bat) » commits changes (ie: 'git.bat commit %*').
* [__gitpatch.bat__](https://github.com/kodybrown/dos/blob/master/gitpatch.bat) » saves a patch of changes to the desktop. can specify '--cached' or not. includes date/time in the filename.
* [__gs.bat__](https://github.com/kodybrown/dos/blob/master/gs.bat) » shows the status (ie: 'git.bat status %*').


### Create thumbnail images from .pdf files

* [__pdf2jpg.bat__](https://github.com/kodybrown/dos/blob/master/pdf2jpg.bat) » creates a thumbnail of one or more pages within one or more .pdf files. This batch file is just an easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.
* [Documentation](https://github.com/kodybrown/dos/blob/master/pdf2jpg.bat.md)

### Encrypting files

* [__encrypt.bat__](https://github.com/kodybrown/dos/blob/master/encrypt.bat) » a simple wrapper for using openssl.exe to easily _encrypt_ files.
* [__decrypt.bat__](https://github.com/kodybrown/dos/blob/master/decrypt.bat) » a simple wrapper for using openssl.exe to easily _decrypt_ files.
* [Documentation](https://github.com/kodybrown/dos/blob/master/encrypt.bat.md)

### Editing multiple shortcut (.lnk) files

* [__updatelinks.vbs__](https://github.com/kodybrown/dos/blob/master/updatelinks.vbs) » modifies multiple shortcut (.lnk) files' properties, including the target, arguments, directory, icon, and description.
* [Documentation](https://github.com/kodybrown/dos/blob/master/updatelinks.vbs.md)

### Export and import a shortcut (.lnk) to and from a text file

This little utility is particularly useful as a Beyond Compare File Format.

* [__exportlink.vbs__](https://github.com/kodybrown/dos/blob/master/exportlink.vbs) » exports/imports the properties of the specified link (shortcut) including the target, arguments, directory, icon, description, hotkey, and windowstyle.
* [Documentation](https://github.com/kodybrown/dos/blob/master/exportlink.vbs.md)

### Easily edit the PATH environment variable

* [__edpath.bat__](https://github.com/kodybrown/dos/blob/master/edpath.bat) » easily edit the PATH environment variable with a few options (such as --prepend, --remove, --force, etc.).
* [Documentation](https://github.com/kodybrown/dos/blob/master/edpath.bat.md)

### Shutdown, Reboot, and Hibernate batch files.

Yes, I'm lazy. Actually, in this case, I am more forgetful than lazy, because I can never remember the arguments for shutdown.exe.

* [__shutdown.cmd__](https://github.com/kodybrown/dos/blob/master/shutdown.cmd) » a simple utility to shutdown your computer. Please note, that shutdown.cmd will not be run unless '.cmd' shows up before '.exe' in your `PATHEXT` environment variable.
* [__reboot.cmd__](https://github.com/kodybrown/dos/blob/master/reboot.cmd) » a simple utility to reboot/restart your computer.
* [__hibernate.cmd__](https://github.com/kodybrown/dos/blob/master/hibernate.cmd) » a simple utility to hibernate your computer.


<p>&nbsp;</p>

## My DOS environment


While I have tried to always make my batch files work in any environment, you may need to change some variables, envars, and/or paths to suit your needs and your computer environment.

### Expected environment variables

#### __%BIN%__

This is where all of my utilities live (C:\bin). This includes my exe's and all of my batch and script files. Within this folder is an apps folder (`%bin%\apps`). Any utility that is larger than one or two files, is put here with its own sub-directory (such as `%bin%\apps\tcmd`). I create a .bat or .lnk file in %bin% to the utility's main exe buried in the sub-directory.

#### __%PROFILE%__

Generally, this is the same as %UserProfile%. The reason I have a separate envar is because I often am working on someone else's computer and launch a console window to use my tools. So, I can `set` the profile path without affecting Windows' normal behavior, etc.

#### __%TOOLS%__

This is where the big tools go. Applications such as mingw, Go, Git, Subversion, ADK, nodejs, mono, Python, Perl, Chocolately, Vagrant, and many more all go here. This folder is HUGE.

I generally install tools in a 'version-less' folder, such as `%tools%\mono` and `%tools%\git`. I create a new directory under it with the version number in it, to use as a reference. For the rare occasion there is a need to simultaneously install multiple versions, I include the version in the directory name. The only example I have of that is Python 2.x and Python 3.x, which I install to `%tools%\Python276` and `%tools%\Python334`. (For my default Python version, I create an un-versioned junction that points to my default or standard version. In this case I point `%tools%\Python` (junction) to `%tools%\Python334`. See link below to download junction.exe.

## Expected executable utilities

Some of my batch and script files require additional (executable) utilities. These are listed here.

* __cat.exe__ — I am referring to my version of [cat.exe](https://github.com/kodybrown/cat), because it does beautiful word-wrapping on the command-line.
* __junction.exe__ — create directory junctions (ie: two different directory paths pointing to the same location/set of files). Download from Microsoft Sysinternals [here](http://technet.microsoft.com/en-us/sysinternals/bb896768.aspx).
* __sdelete.exe__ — permanently and securely delete your files. Download from Microsoft Sysinternals [here](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx)
* __sleep.exe__ — I am referring to my version of [sleep.exe](https://github.com/kodybrown/sleep), but any version will work assuming it's first argument is the number of milliseconds to wait before exiting.
* __sort.exe__ — You can build/compile your own or download one of the many fine versions available. I prefer the mingw package, but that doesn't mean anything to anyone else. For convience, I have uploaded the sort.exe from my mingw installation to my Dropbox account. Download the official [msys-coreutils-5.97-3](http://sourceforge.net/projects/mingw/files/MSYS/Base/coreutils/coreutils-5.97-3/) package or just sort.exe from [my Dropbox](https://dl.dropboxusercontent.com/u/123747/utils/sort.exe). (NOTE: The Microsoft version of sort.exe works just fine, but the nix version allows me to also remove duplicates.)
