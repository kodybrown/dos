dos utilities
=============

Some of my batch files and scripts. Jump to the bottom for details about how I have set up my DOS environment as well as listing a few executable/utilities that are frequently used in my batch files.

### Setting up the DOS environment

* [__start_dos.bat__](https://github.com/kodybrown/dos/blob/master/start_dos.bat) » sets up my DOS environment. calls `alias.bat --load` and `history.bat --load` to get things started. it then sets a bunch of envars and adds some paths to the PATH envar, etc.
* [__exit_dos.bat__](https://github.com/kodybrown/dos/blob/master/exit_dos.bat) » shuts down my DOS environment. calls `alias.bat --save` and `history.bat --save` to get closed down. create an alias for 'exit' so that this file is called instead of _just_ exiting the prompt; 'doskey exit %bin%\exit_dos.bat'.
* [Documentation](https://github.com/kodybrown/dos/blob/master/start_dos.bat.md)

### Using aliases (DOSKEY macros)

* [__alias.bat__](https://github.com/kodybrown/dos/blob/master/alias.bat) » allows using 'alias' like on Linux (all via DOSKEY). requires start_dos.bat and exit_dos.bat.
* [Documentation](https://github.com/kodybrown/dos/blob/master/alias.bat.md)

### Saving and retrieving command-line history

* [__hist.bat__](https://github.com/kodybrown/dos/blob/master/history.bat) » calls history.bat.
* [__history.bat__](https://github.com/kodybrown/dos/blob/master/history.bat) » allows using 'history' like on Linux. requires start_dos.bat and exit_dos.bat.
* [Documentation](https://github.com/kodybrown/dos/blob/master/history.bat.md)

### Running applications with elevated permissions (as administrator)

> These have been deprecated in favor of the PowerShell `sudo` script. Execute the following to install it via [scoop](https://github.com/lukesampson/scoop):

    > scoop update
    > scoop install sudo

* [__elevate.cmd__](https://github.com/kodybrown/dos/blob/master/elevate.cmd) » open the specified application with elevated permissions (run as administrator).
* [__elevate.vbs__](https://github.com/kodybrown/dos/blob/master/elevate.vbs) » this is NOT called directly. elevate.cmd calls this.
* [Documentation](https://github.com/kodybrown/dos/blob/master/elevate.md)

### Basic utilities and wrappers

Simple menu system

* [__c.bat__](https://github.com/kodybrown/dos/blob/master/c.bat) » cool little system menu and directory changing util.

Editors

* [__edit.bat__](https://github.com/kodybrown/dos/blob/master/edit.bat) » opens a text editor using the specified argument(s) if provided. Also replaces all '/' characters with '\' and various other parsing enhancements. if `hosts` is the first argument, opens the machine's hosts file using sudo if available.
* [__n.bat__](https://github.com/kodybrown/dos/blob/master/n.bat) » calls 'edit.bat' with the editor being forced to Notepad2.
* [__notepad.bat__](https://github.com/kodybrown/dos/blob/master/notepad.bat) » calls 'edit.bat' with the editor being forced to Notepad2.
* [__np.bat__](https://github.com/kodybrown/dos/blob/master/np.bat) » calls 'edit.bat' with the editor being forced to Notepad++.
* [__open.bat__](https://github.com/kodybrown/dos/blob/master/open.bat) » calls 'edit.bat'.
* [__subl.bat__](https://github.com/kodybrown/dos/blob/master/subl.bat) » calls 'edit.bat' with the editor being forced to Sublime Text.
* [__sublime.bat__](https://github.com/kodybrown/dos/blob/master/sublime.bat) » calls 'edit.bat' with the editor being forced to Sublime Text.

Securely deleting files

* [__sdel.bat__](https://github.com/kodybrown/dos/blob/master/sdel.bat) » calls 'sdelete.exe' with default arguments and the specified (arg1) number of passes.
* [__sdel1.bat__](https://github.com/kodybrown/dos/blob/master/sdel1.bat) » calls 'sdel.bat 1'.
* [__sdel5.bat__](https://github.com/kodybrown/dos/blob/master/sdel5.bat) » calls 'sdel.bat 5'.
* [__sdel8.bat__](https://github.com/kodybrown/dos/blob/master/sdel8.bat) » calls 'sdel.bat 8'.
* [__sdelete_prep.bat__](https://github.com/kodybrown/dos/blob/master/sdelete_prep.bat) » deletes a ton of un-important (non-private) files using the standard DEL. i use this on a directory before securely deleting it, so that it is much faster.
* [__sdelete_repeater.bat__](https://github.com/kodybrown/dos/blob/master/sdelete_repeater.bat) » securely deletes all free space one pass at a time. it will not stop. (the reason for one pass in a loop, is if i execute 'sdelete -p 8 -c C:' the process may only have enough time to run get say 4 or 5 passes. using a single-pass in a loop i would get all free space hit 4 or 5 times, whereas the other way, i would only get half of the free space hit 8 times.)

DIR command wrappers

* [__dc.bat__](https://github.com/kodybrown/dos/blob/master/dc.bat) » lists files where name contains the value specified.
* [__dd.bat__](https://github.com/kodybrown/dos/blob/master/dd.bat) » lists (only) directories where name contains the value specified.
* [__de.bat__](https://github.com/kodybrown/dos/blob/master/de.bat) » lists files where name (not including extension) ends with the value specified.
* [__ds.bat__](https://github.com/kodybrown/dos/blob/master/ds.bat) » lists files where name starts with the value specified.
* [__dx.bat__](https://github.com/kodybrown/dos/blob/master/dx.bat) » lists files where extension contains the value specified.

Misc. utilities

* [__''.bat__](https://github.com/kodybrown/dos/blob/master/''.bat) » changes to the root of the current drive (ie: 'cd\').
* [__'.bat__](https://github.com/kodybrown/dos/blob/master/'.bat) » changes to the current directories parent (ie: 'cd..'). did i mention that i'm lazy, yet?
* [__bigtext.bat__](https://github.com/kodybrown/dos/blob/master/bigtext.bat) » displays all arguments as very large, ASCII-based characters.
* [__cdor.bat__](https://github.com/kodybrown/dos/blob/master/cdor.bat) » changes to first argument (a directory) that exists.
* [__cleanfree.bat__](https://github.com/kodybrown/dos/blob/master/cleanfree.bat) » cleans (securely deletes) free space. requires 'sdelete.exe'.
* [__cleantemp.bat__](https://github.com/kodybrown/dos/blob/master/cleantemp.bat) » cleans out some various temporary directories. will use 'sdelete.exe' if present.
* [__Cleanup-Setup.bat__](https://github.com/kodybrown/dos/blob/master/Cleanup-Setup.bat) » configures 'cleanmgr.exe' (Cleanup Wizard) for use with 'Cleanup.bat'.
* [__Cleanup.bat__](https://github.com/kodybrown/dos/blob/master/Cleanup.bat) » runs 'cleanmgr.exe' using the options specified via 'Cleanup-Setup.bat'.
* [__count.bat__](https://github.com/kodybrown/dos/blob/master/count.bat) » counts the number of lines in the specified file and returns the count as the errorlevel.
* [__doserrors.bat__](https://github.com/kodybrown/dos/blob/master/doserrors.bat) » displays a list of all of the MSDOS extended error codes.
* [__emptybin.bat__](https://github.com/kodybrown/dos/blob/master/emptybin.bat) » empties the recycle bin. requires 'recycle.exe' or 'nircmd.exe'.
* [__get.bat__](https://github.com/kodybrown/dos/blob/master/get.bat) » provides easy access to system information, such as 'get ip', 'get drives', 'get sid', etc.
* [__guid.bat__](https://github.com/kodybrown/dos/blob/master/guid.bat) » creates a new GUID and copies it to the clipboard. requires 'powershell'.
* [__hide.bat__](https://github.com/kodybrown/dos/blob/master/hide.bat) » shortcut to hide files and/or directories
* [__iiskill.bat__](https://github.com/kodybrown/dos/blob/master/iiskill.bat) » kill iis (internet information server).
* [__iisrestart.bat__](https://github.com/kodybrown/dos/blob/master/iisrestart.bat) » restart iis. this is _not_ the same as 'iisreset'. this restarts the iis admin process as well as the worker process(es).
* [__iisstart.bat__](https://github.com/kodybrown/dos/blob/master/iisstart.bat) » start iis (admin service) and the worker process(es).
* [__iisstop.bat__](https://github.com/kodybrown/dos/blob/master/iisstop.bat) » stop iis (admin service) and the worker process(es).
* [__killdead.bat__](https://github.com/kodybrown/dos/blob/master/killdead.bat) » kills all applications (processes) that are not responding.
* [__killwebdev.bat__](https://github.com/kodybrown/dos/blob/master/killwebdev.bat) » kills all WebDev.WebServer40.exe processes.
* [__nu.bat__](https://github.com/kodybrown/dos/blob/master/nu.bat) » simple wrapper for `net use`. yes. i am a lazy typer.. err.. typist.
* [__ReplaceInFile.bat__](https://github.com/kodybrown/dos/blob/master/ReplaceInFile.bat) » replaces content in files.
* [__screensaver.bat__](https://github.com/kodybrown/dos/blob/master/screensaver.bat) » starts the screen saver.
* [__set_ipaddr_envar.bat__](https://github.com/kodybrown/dos/blob/master/set_ipaddr_envar.bat) » saves the current ip address to an environment variable.
* [__setdatevars.cmd__](https://github.com/kodybrown/dos/blob/master/setdatevars.cmd) » sets environment variables to the current date.
* [__settimevars.cmd__](https://github.com/kodybrown/dos/blob/master/settimevars.cmd) » sets environment variables to the current time.
* [__unhide.bat__](https://github.com/kodybrown/dos/blob/master/unhide.bat) » shortcut to show (unhide) files and/or directories
* [__wget+.bat__](https://github.com/kodybrown/dos/blob/master/wget+.bat) » shows common usage of wget.exe.

I hate iTunes.

* [__itunes-start.bat__](https://github.com/kodybrown/dos/blob/master/itunes-start.bat) » starts itunes' services and helper, then starts itunes itself.
* [__itunes-stop.bat__](https://github.com/kodybrown/dos/blob/master/itunes-stop.bat) » stops all of itunes' services, helper, and itunes itself.

### Linux on DOS wrappers

The following batch files do a decent job of emulating linux commands in dos.
For instance, common '--' arguments are supported and will convert forward slashes to back-slashes.

* [__cp.bat__](https://github.com/kodybrown/dos/blob/master/cp.bat) » copies files based on specified arguments.
* [__la.bat__](https://github.com/kodybrown/dos/blob/master/la.bat) » lists files based on specified arguments.
* [__ll.bat__](https://github.com/kodybrown/dos/blob/master/ll.bat) » lists files based on specified arguments.
* [__lla.bat__](https://github.com/kodybrown/dos/blob/master/lla.bat) » lists files based on specified arguments.
* [__lls.bat__](https://github.com/kodybrown/dos/blob/master/lls.bat) » lists files based on specified arguments.
* [__ls.bat__](https://github.com/kodybrown/dos/blob/master/ls.bat) » lists files based on specified arguments.
* [__mv.bat__](https://github.com/kodybrown/dos/blob/master/mv.bat) » moves a file or files.
* [__pwd.bat__](https://github.com/kodybrown/dos/blob/master/pwd.bat) » prints the working directory ('cd').
* [__rm.bat__](https://github.com/kodybrown/dos/blob/master/rm.bat) » deletes a file or files.

Also, check out the sections above on aliases and history.

### Beyond Compare wrappers

[Beyond Compare](http://www.scootersoftware.com/) is one of maybe three apps that I use **constantly** for so much of my daily work! It rocks.

* [__bc.bat__](https://github.com/kodybrown/dos/blob/master/bc.bat) » provides a wrapper to find and execute BCompare.exe with the specified arguments. examples: 'bc C:\bin C:\bin-backup', 'bc \ .'. read [this](http://www.scootersoftware.com/v4help/index.html?command_line_reference.html) for the command-line details.
* [__bcscript.bat__](https://github.com/kodybrown/dos/blob/master/bcscript.bat) » enables the creation and use of .bcscript files that opened in BCompare.exe as a script file. read [this](http://www.scootersoftware.com/v4help/index.html?command_line_reference.html) for details about creating your own BC script files.

### Git wrappers

~~I have all but replaced these batch files with aliases (doskey macros). See 'Aliases (DOSKEY macros)' above for more details.~~ I always come back to my batch files. They just work.

* [__git.bat__](https://github.com/kodybrown/dos/blob/master/git.bat) » provides a wrapper to find and execute git.exe. also supports a 'purge' option. type `git --` to show all shortcuts.
* [__ga.bat__](https://github.com/kodybrown/dos/blob/master/ga.bat) » adds files (ie: 'git.bat add [.|%*]'). if no argument is specified, it appends a dot ('.') for adding 'all'.
* [__gb.bat__](https://github.com/kodybrown/dos/blob/master/gb.bat) » branches (ie: 'git.bat branch %*').
* [__gc.bat__](https://github.com/kodybrown/dos/blob/master/gc.bat) » source checkout (ie: 'git.bat checkout %*').
* [__gd.bat__](https://github.com/kodybrown/dos/blob/master/gd.bat) » diff on the command-line (ie: 'git.bat diff %*').
* [__gdt.bat__](https://github.com/kodybrown/dos/blob/master/gdt.bat) » diff using the 'difftool' (ie: 'git.bat difftool %*').
* [__gh.bat__](https://github.com/kodybrown/dos/blob/master/gh.bat) » shows the history (ie: 'git.bat log --oneline --graph --date=short --all --max-count=20 %*').
* [__gi.bat__](https://github.com/kodybrown/dos/blob/master/gi.bat) » commits changes (ie: 'git.bat commit %*').
* [__gitpatch.bat__](https://github.com/kodybrown/dos/blob/master/gitpatch.bat) » saves a patch of changes to the desktop. can specify '--cached' or not. includes date/time in the filename.
* [__gl.bat__](https://github.com/kodybrown/dos/blob/master/gl.bat) » show logs (ie: 'git.bat log %*').
* [__gm.bat__](https://github.com/kodybrown/dos/blob/master/gm.bat) » merge using the 'mergetool' (ie: 'git.bat mergetool %*').
* [__gp.bat__](https://github.com/kodybrown/dos/blob/master/gp.bat) » pull (ie: 'git.bat pull %*').
* [__gs.bat__](https://github.com/kodybrown/dos/blob/master/gs.bat) » shows the status (ie: 'git.bat status %*').
* [__gz.bat__](https://github.com/kodybrown/dos/blob/master/gz.bat) » add specified file to .gitignore (ie: 'echo %1 >> .gitignore').

### Subversion (SVN) wrappers

* [__svn.bat__](https://github.com/kodybrown/dos/blob/master/svn.bat) » provides a wrapper to find and execute svn.exe. type `svn --` to show all shortcuts.
* [__sa.bat__](https://github.com/kodybrown/dos/blob/master/sa.bat) » adds files (ie: 'svn.bat add [.|%*]'). if no argument is specified, it appends a dot ('.') for adding 'all'.
* [__sb.bat__](https://github.com/kodybrown/dos/blob/master/sb.bat) » show who's to blame for changes to a file (ie: 'svn.bat blame %*').
* [__sd.bat__](https://github.com/kodybrown/dos/blob/master/sd.bat) » diff on the command-line (ie: 'svn.bat diff %*').
* [__si.bat__](https://github.com/kodybrown/dos/blob/master/si.bat) » commits changes (ie: 'svn.bat commit %*').
* [__so.bat__](https://github.com/kodybrown/dos/blob/master/so.bat) » source checkout (ie: 'svn.bat checkout %*').
* [__ss+.bat__](https://github.com/kodybrown/dos/blob/master/ss+.bat) » shows the status, excluding ignored/untracked files (ie: 'svn.bat status --no-ignore %*').
* [__ss.bat__](https://github.com/kodybrown/dos/blob/master/ss.bat) » shows the status (ie: 'svn.bat status %*').

### Vagrant wrappers

* [__va.bat__](https://github.com/kodybrown/dos/blob/master/va.bat) » provides a wrapper to execute vagrant.exe. type `va --` to show all shortcuts.
* [__vh.bat__](https://github.com/kodybrown/dos/blob/master/vh.bat) » stop/turn off the vagrant machine (ie: 'vagrant.bat halt %*').
* [__vr.bat__](https://github.com/kodybrown/dos/blob/master/vr.bat) » resumes the vagrant machine (ie: 'vagrant.bat resume %*').
* [__vs.bat__](https://github.com/kodybrown/dos/blob/master/vs.bat) » shows the status of the vagrant machine (ie: 'vagrant.bat status %*').
* [__vssh.bat__](https://github.com/kodybrown/dos/blob/master/vssh.bat) » connect to the vagrant via SSH (ie: 'vagrant.bat ssh %*').
* [__vu.bat__](https://github.com/kodybrown/dos/blob/master/vu.bat) » start the vagrant (ie: 'vagrant.bat up %*').

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

* [__exportlink.vbs__](https://github.com/kodybrown/dos/blob/master/exportlink.vbs) » updates the properties of the specified links (shortcuts) including the target, arguments, directory, icon, description, hotkey, and windowstyle.
[Documentation](https://github.com/kodybrown/dos/blob/master/exportlink.vbs.md)
* [__updatelinks.vbs__](https://github.com/kodybrown/dos/blob/master/exportlink.vbs) » replaces properties of .lnk files.
* [Documentation](https://github.com/kodybrown/dos/blob/master/updatelinks.vbs.md)

### Easily display and edit the PATH environment variable

* [__edpath.bat__](https://github.com/kodybrown/dos/blob/master/edpath.bat) » easily edit the PATH environment variable with a few options (such as --prepend, --remove, --force, etc.).
* [Documentation](https://github.com/kodybrown/dos/blob/master/edpath.bat.md)
* [__pathx.bat__](https://github.com/kodybrown/dos/blob/master/pathx.bat) » easily display the PATH environment variable with each path on its own line.

### Shutdown, Reboot, and Hibernate

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

> Note: I have started moving things back to %UserProfile%, instead of %Profile%.

#### __%TOOLS%__

This is where the big tools go. Applications such as mingw, ~~Go~~, ~~Git~~, ~~Subversion~~, ~~Mercurial~~, Google ADK, ~~nodejs~~, Mono, Python, ~~Perl~~, ~~Chocolately~~ (I never really got excited about Chocolately and don't use it anymore; [scoop](https://github.com/lukesampson/scoop) fits my style much better), Vagrant, and many more all go here. This folder is ~~HUGE~~ getting smaller as I use scoop for more and more packages.

I generally install tools in a 'version-less' folder, such as `%tools%\mono` and `%tools%\git`. I create a new directory under it with the version number in it, to use as a reference. For the rare occasion there is a need to simultaneously install multiple versions, I include the version in the directory name. The only example I have of that is Python 2.x and Python 3.x, which I install to `%tools%\Python276` and `%tools%\Python334`. (For my default Python version, I create an un-versioned junction that points to my default or standard version. In this case I point `%tools%\Python` (junction) to `%tools%\Python334`. See link below to download junction.exe.

## Expected executable utilities

Some of my batch and script files require additional (executable) utilities. These are listed here.

* __cat.exe__ — I am referring to my version of [cat.exe](https://github.com/kodybrown/cat), because it does beautiful word-wrapping on the command-line.
* __junction.exe__ — create directory junctions (ie: two different directory paths pointing to the same location/set of files). Download from [Microsoft Sysinternals](http://technet.microsoft.com/en-us/sysinternals/bb896768.aspx).
* __sdelete.exe__ — permanently and securely delete your files. Download from [Microsoft Sysinternals](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx)
* __sleep.exe__ — I am referring to my version of [sleep.exe](https://github.com/kodybrown/sleep), but any version will work assuming it's first argument is the number of milliseconds to wait before exiting.
* __sort.exe__ — You can build/compile your own or download one of the many fine versions available. I prefer the mingw package, but that doesn't mean anything to anyone else. For convience, I have uploaded the sort.exe from my mingw installation to my Dropbox account. Download the official [msys-coreutils-5.97-3](http://sourceforge.net/projects/mingw/files/MSYS/Base/coreutils/coreutils-5.97-3/) package or just sort.exe from [my Dropbox](https://dl.dropboxusercontent.com/u/123747/utils/sort.exe). (NOTE: The Microsoft version of sort.exe works just fine, but the *nix version allows me to also remove duplicates.) **Updated:** scoop provides an easy way to install BusyBox, which includes sort.exe. install it using 'scoop update && scoop install BusyBox'.
