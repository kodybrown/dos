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


