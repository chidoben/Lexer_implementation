/* Example 1, Hello-World Lexer */
%{
#include <stdio.h>
#include "hello.yy.h" // the output of bison on example2 Hello-World Parser

void yyerror ( char *); // we need to forward declare these functions ,
int yyparse ( void );

%}
%%
 
";"           return SEMICOLON ;

"hello-world" { printf("got HELLO token\n"); return HELLO; }

"quit"        { printf("got QUIT token\n"); return QUIT; }

[ \t\n]+      ; // do nothing on whitespace

%%

void yyerror(char *str) { printf("ERROR: Could not parse !\n "); }

int yywrap(void) { }

int main ( void ) {
  // we don ’t want to do anything extra, just start the parser
  yyparse (); // yyparse is defined for us by flex
}
