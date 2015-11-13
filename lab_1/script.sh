#! /bin/bash

# This script recieves a .l ($1) file and generates the
# corresponding C code by using flex. Then it compiles this
# code using gcc and runs it using the file specified at $2

if [ -z "$1" ]; then
    echo "How to use:"
    echo "  -With only one argument, which is the flex .l file."
    echo "   This creates AND compiles the C code using flex and gcc."
    echo "     Example: ./script.sh tokens.l"
    echo "     returns tokens.c and tokens.out files. "
    echo ""
    echo "  -With two arguments. It does the same thing as before but"
    echo "   also runs the generated code against the file specified "
    echo "   as the second argument."
    echo "     Example: ./script.sh tokens.l sphere.rtls"
    echo "     returns the same files as before as well as a file named"
    echo "     tokens_result.txt, which is the resulting file that has"
    echo "     to match the file given by the teacher."
    exit 0
fi
echo 'Creating lexer from file '$1'.'
FILE=$1
NAME=`echo "$FILE" | cut -d'.' -f1`
flex -o $NAME.c $FILE

echo 'Compiling generated file' $NAME.c.
gcc $NAME.c -o $NAME.out

if [ ! -z "$2" ]; then
    echo "Running generated code against $2 file."
    ./$NAME.out < $2 > "$NAME""_result.txt"
    #cat "$NAME""_result.txt"
fi
