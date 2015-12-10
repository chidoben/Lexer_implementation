%{
# include <stdio.h>
%}

/* declare tokens */
%token  INT FLT BOOL VEC2 VEC3 VEC4 IVEC2 IVEC3 IVEC4 BVEC2 BVEC3 BVEC4 PRIMITIVE CAMERA MATERIAL TEXTURE LIGHT
%token FLOAT INTEGER EXPONENTIAL
%token IDENTIFIER
%token SEMICOLON COLON
%token NEWLINE 
%token PLUS MUL MINUS DIV ASSIGN EQUAL NOT_EQUAL LT LE GT GE COMMA LPARENTHESIS RPARENTHESIS LBRACKET RBRACKET LBRACE RBRACE AND OR INC DEC
%token SQRT DOT CLASS INVERSE INSIDE PERPENDICULAR DOMINANTAXIS TRACE HIT LUMINANCE RAND POW MIN MAX ILLUMINANCE AMBIENT BREAK CASE CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FOR GOTO IF SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID WHILE

%%

SHADER_DEF:
| CLASS IDENTIFIER COLON MATERIAL SEMICOLON { printf("SHADER_DEF material\n");}
| CLASS IDENTIFIER COLON TEXTURE SEMICOLON { printf("SHADER_DEF texture\n");}
;

FUNCTION_DEF: 
	type_specifier IDENTIFIER LPARENTHESIS declaration_list RPARENTHESIS compound_statement
	; 


type_specifier
	: VOID
	| INT
	| FLT
	| BOOL
	| VEC2
	| VEC3
	| VEC4
	| IVEC2
	| IVEC3
	| IVEC4
	| BVEC2
	| BVEC3
	| BVEC4
	| PRIMITIVE
	| CAMERA
	| MATERIAL
	| TEXTURE
	| LIGHT
	;

declaration_list
	:
	| last_declerator
	| direct_declarator last_declerator

	;

last_declerator:
type_specifier IDENTIFIER ;

direct_declarator: 
	  last_declerator COMMA
	| direct_declarator
	;

compound_statement
	: LPARENTHESIS RPARENTHESIS
	| LPARENTHESIS  block_item_list RPARENTHESIS
	;

block_item_list
	: block_item
	| block_item_list block_item
	;

block_item
	: declaration
	| statement
	;

declaration
	: declaration_specifiers SEMICOLON
	| declaration_specifiers init_declarator_list SEMICOLON
	;

declaration_specifiers
	: type_specifier
	| type_specifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list COMMA init_declarator
	;

init_declarator
	: direct_declarator ASSIGN primary_expression
	| direct_declarator
	;

primary_expression
	: IDENTIFIER
	| number
	;

number
	: FLOAT
	| INTEGER
	| EXPONENTIAL
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
