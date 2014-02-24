
# Encrypting files

* [__encrypt.bat__](https://github.com/kodybrown/dos/blob/master/encrypt.bat) » a simple wrapper for using openssl.exe to easily encrypt files.
* [__decrypt.bat__](https://github.com/kodybrown/dos/blob/master/decrypt.bat) » a simple wrapper for using openssl.exe to easily decrypt files.

## Usage:

_encrypt.bat_
```
                                             o
                                             8
   .oPYo. odYo. .oPYo. oPYo. o    o .oPYo.  o8P
   8oooo8 8' '8 8    ' 8  '' 8    8 8    8   8
   8.     8   8 8    . 8     8    8 8    8   8
   'Yooo' 8   8 'YooP' 8     'YooP8 8YooP'   8
 :::.....:..::..:.....:..:::::....8 8 ....:::..:::
 ::::::::::::::::::::::::::::::ooP'.8 ::::::::::::
 ::::::::::::::::::::::::::::::...::..::::::::::::

   simple wrapper using openssl to encrypt files
        batch file created by wasatchwizard

   USAGE:

   $ encrypt file

     Performs in-place encryption of 'file'.
     WARNING: This overwrites existing file!

   $ encrypt infile outfile

     Encrypts 'infile' and saves to 'outfile'.
```

_decrypt.bat_
```
        8                                     o
        8                                     8
   .oPYo8 .oPYo. .oPYo. oPYo. o    o .oPYo.  o8P
   8    8 8oooo8 8    ' 8  '' 8    8 8    8   8
   8    8 8.     8    . 8     8    8 8    8   8
   'YooP' 'Yooo' 'YooP' 8     'YooP8 8YooP'   8
 :::.....::.....::.....:..:::::....8 8 ....:::..:::
 :::::::::::::::::::::::::::::::ooP'.8 ::::::::::::
 :::::::::::::::::::::::::::::::...::..::::::::::::

   simple wrapper using openssl to decrypt files
        batch file created by wasatchwizard

   USAGE:

   $ decrypt file

     Performs in-place decryption of 'file'.
     WARNING: This overwrites existing file!

   $ decrypt infile outfile

     Decrypts 'infile' and saves to 'outfile'.
```

## Examples:

The `encrypt.bat` and `decrypt.bat` files behave the same. So, in the examples below you can use encrypt or decrypt.

To show usage information:

    encrypt
    encrypt /?
    encrypt --help

To encrypt a file in-place (the original file is overwritten with the newly encrypted file):

    encrypt file

To encrypt a file and save the output into a new file (the original file is not touched):

    encrypt infile outfile

