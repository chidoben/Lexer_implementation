#! /bin/bash

# This script recieves a bison (.y) and flex (.lex) file ($1 and $2)
# and generates the corresponding C code by using these two tools.
# Then it compiles this code using gcc and runs it using the file 
# specified at $3

if [ -z "$1" ]; then
    echo "How to use:"
    echo "  -With two arguments, which is the bison .y file and the flex .lex file."
    echo "   This creates the C code using bison, flex AND compiles it using gcc into FILENAME.out file."
    echo "     Example: ./script.sh hello.y hello.lex"
    echo "     returns the executable FILEANME.out file. "
    echo ""
    echo "  -With three arguments. It does the same thing as before but"
    echo "   also runs the generated code against the file specified "
    echo "   as the third argument."
    echo "     Example: ./script.sh hello.y hello.lex example"
    echo "     returns the same files as before as well as a file named"
    echo "     hello_result.txt, which is the resulting file that has"
    echo "     to match the file given by the teacher."
    exit 0
fi

echo 'Creating bison from file '$1'.'
FILEBISON=$1
NAMEBISON=`echo "$FILEBISON" | cut -d'.' -f1`
bison -d $FILEBISON -o $NAMEBISON.yy.c

echo 'Creating lexer from file '$2'.'
FILEFLEX=$2
NAMEFLEX=`echo "$FILEFLEX" | cut -d'.' -f1`
flex -o $NAMEFLEX.c $FILEFLEX

echo 'Compiling generated file' $NAMEBISON.yy.c 'and' $NAMEFLEX.c 'into:' $NAMEBISON.out
gcc $NAMEBISON.yy.c $NAMEFLEX.c -o $NAMEBISON.out -lfl

if [ ! -z "$3" ]; then
    echo "Running generated code against $3 file."
    ./$NAMEBISON.out < $3 > "$NAMEBISON""_result.txt"
    #cat "$NAME""_result.txt"
fi
