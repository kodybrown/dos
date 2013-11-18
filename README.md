dos
===

Some of my batch files and scripts

## Encrypting files

* __encrypt.bat__ » a simple wrapper for using openssl.exe to encrypt files
* __decrypt.bat__ » a simple wrapper for using openssl.exe to decrypt files

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


