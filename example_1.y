%{
# include <stdio.h>
%}

/* declare tokens */
%token class
%token material texture
%token IDENTIFIER
%token SEMICOLON COLON
%token NEWLINE

%%

SHADER_DEF:
|class IDENTIFIER COLON material SEMICOLON { printf(" SHADER_DEF material\n");}
|class IDENTIFIER COLON texture SEMICOLON { printf(" SHADER_DEF texture\n");}
;


%%

int main( int argc, char **argv )
{

  // we assume that the input file is given as input as first argument
  ++argv, --argc;   
  if ( argc > 0 )
    stdin = fopen( argv[0], "r" );
  yyparse();
  return 0;
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}
