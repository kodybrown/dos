
# Create thumbnail images from .pdf files

* [__pdf2jpg.bat__](https://github.com/kodybrown/dos/blob/master/pdf2jpg.bat) » Creates a thumbnail of one or more pages within one or more .pdf files. This batch file is just an easy to use wrapper for the GhostScript command-line utility `gswin64c.exe`.

## Requires:

* __gswin64c.exe__ » GhostScript command-line tool. [[Download](http://www.ghostscript.com/download/gsdnld.html)]

## Usage:

    pdf2jpg.bat | Created 2014 @wasatchwizard.
                | Released under the MIT License.

    Creates a thumbnail of pages within a .pdf file. This batch file is just an
    easy to use wrapper for the GhostScript command-line utility 'gswin64c.exe'.

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
      -p --pause      Pauses when it is finished (ignored if '-q' is specified).
      -R --recursive  Processes .pdf in sub-directories as well.

      --max n         Specify the maximum number of files to process.
      --overwrite [yes|no|ask]
                      Specifies what to do if the output file already exists.
                      The default if not specified is ask. The file is ignored if
                      'overwrite=ask' and '-quiet' is specified.

## Thanks

> Many thanks to [KenS](http://stackoverflow.com/users/701996/kens) for pointing out [just how easy it is to use ghostscript](http://stackoverflow.com/questions/12614801/how-to-execute-imagemagick-to-convert-only-the-first-page-of-the-multipage-pdf-t) directly, instead of ImageMagick.
