dos
===

Some of my batch files and scripts

# DOS environment

blah blah

While I have tried to always make my batch files work in any environment, you may need to change some variables, envars, and/or paths to suit your needs and your computer environment.

### Expected environment variables

blah blah description blah

    BIN         This is where all of my utilities live. Within this folder
                is the apps folder (`%bin%\apps`). Any utility that is larger
                than one or two files is put in apps within its own folder
                (such as `%bin%\apps\tcmd`).

    PROFILE     Generally, this is the same as %UserProfile%. The reason I
                have a separate envar is because I often am working on
                someone else's computer and launch a console window to use
                my tools. So, I can `set` the profile path without affecting
                Windows' normal behavior, etc.

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


