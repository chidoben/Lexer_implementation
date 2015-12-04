/* Example 1, Hello-World Parser */
%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern void yyerror( char *);
%}
 
// the different types of tokens we want to return
%union {
  int int_token;
}

// list the different tokens of each type
%token <int_token> QUIT HELLO SEMICOLON

// indicate which of the below nodes is the root of the parse tree
%start root_node

%%

root_node:  hello_node root_node | quit_node;

hello_node: HELLO SEMICOLON 
  { printf ( "parsed a hello node !\nHello, user !\n");};

quit_node:  QUIT SEMICOLON
  { printf ( "parsed a quit node !\nGoodbye, user !\n"); exit (0);};
