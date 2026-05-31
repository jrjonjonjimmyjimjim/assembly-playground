To build the object file: `as -o file.o file.s`
To link the object file and turn it into a binary: ``ld -o file file.o -lSystem -syslibroot `xcrun --show-sdk-path` -e _main``

