# C Libraries Function Indexer

This project aims to index functions from the multiple implementations of the standard C libraries, and 
for any of them show in which implementation or standard they can be found.

Examples of covered standards are : C99, C11, SuSv2, SuSv4
Examples of covered implementations are : glibc, uClibc-ng, FreeBSD libc

The goal would be to index all standard functions, GNU extensions, BSD extensions at least.
This way, when wondering if the function is GNU/BSD or standard, one could just look it up in the
database and even see wether the extension is adopted (i.e. present in other implementations) or not.

This repository contains the tools used to generate a json database of functions.

## Using the database

The database can be accessed via the web hosted implementation [here](https://valou3433.fr/cindex/).
It was generated on my personal computer, using virtual machines.

## Generating a database

Generation can only be done under linux-glibc, and it assumes that `/bin/sh` is `bash`.
You will need multiple tests systems (either physical computers or virtual machines)
to index the bsds, macos, windows implementations.

The main script should tell you everything you need :

```
chmod +x main.sh index.sh getlib.sh merge.sh # Add execution rights if needed
./main.sh
```

## Internal organization

- main.sh :
    The main script. Checks for library/std installations, runs the indexer, and asks the user to run it on different systems.
- index.sh :
    The core of the project : index functions from different libcs, check for standards. Can be run in 'local system' mode.
- index-win.bat :
    The 'local system' version of the indexer, for Windows.
- getlib.sh :
    A script to obtain (download, configure, compile, install) all tested libc (glibc, uClibc-ng, ...) under the ./libs directory.
- merge.sh :
    A script to merge outputs (i.e. indexer output and local indexer output on freebsd), used to obtain final outputs.
- merge-bigjson.sh
    A script to merge all headers json files into one big json file.

## TODO

- Generate "stdh.sh" automatically, including : C std, SuS, GNU exts, BSD exts
- MacOS indexer
- Windows indexer (WIP, need stdh generator to generate powershell arrays....)

