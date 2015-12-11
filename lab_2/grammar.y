%{
# include <stdio.h>
%}

%union {
  int int_token;
}

/* declare tokens */
%token <int_token>  INT FLT BOOL VEC2 VEC3 VEC4 IVEC2 IVEC3 IVEC4 BVEC2 BVEC3 BVEC4 PRIMITIVE CAMERA MATERIAL TEXTURE LIGHT
%token <int_token>  FLOAT INTEGER EXPONENTIAL VOID
%token <int_token>  IDENTIFIER
%token <int_token>  SEMICOLON COLON RBRACE STATE QUALIFIER COLOR
%token  <int_token>  NEWLINE SWIZZLE OTHER
%token <int_token>  PLUS MUL MINUS DIV ASSIGN EQUAL NOT_EQUAL LT LE GT GE COMMA LPARENTHESIS RPARENTHESIS LBRACKET RBRACKET LBRACE  AND OR INC DEC
%token <int_token> SQRT DOT CLASS INVERSE INSIDE PERPENDICULAR DOMINANTAXIS TRACE HIT LUMINANCE RAND POW MIN MAX ILLUMINANCE AMBIENT BREAK CASE CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FOR GOTO IF SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED  WHILE
%token <int_token> ATTRIBUTE UNIFORM VARYING PUBLIC PRIVATE SCRATCH
%token <int_token> RT_SCREENCOORD RT_LENSCOORD RT_EPSILON RT_HITDISTANCE RT_BOUNDMIN RT_BOUNDMAX RT_TEXTUREUV RT_TEXTUREUVW RT_TEXTURECOLOR RT_FLOATTEXTUREVALUE RT_DSDU RT_DTDU RT_DSDV RT_DTDV RT_RAYORIGIN RT_RAYDIRECTION RT_INVERSERAYDIRECTION RT_DPDU RT_DPDV RT_LIGHTDISTANCE RT_LIGHTCOLOR RT_EMISSIONCOLOR RT_BSDFSEED RT_PDF RT_SAMPLECOLOR RT_BSDFVALUE RT_DU RT_DV RT_HITPOINT RT_GEOMETRICNORMAL RT_SHADINGNORMAL RT_LIGHTDIRECTION RT_TIMESEED
// indicate which of the below nodes is the root of the parse tree
%start root_node

%%
root_node	
	: external_declaration
	| root_node external_declaration
	;


external_declaration
	: FUNCTION_DEF
	| DECLARATION
	| SHADER_DEF
	;
	
DECLARATION
	: declaration_specifiers SEMICOLON
	| declaration_specifiers init_declarator_list SEMICOLON
	;

	
	init_declarator
	: declarator ASSIGN INTEGER SEMICOLON
	| declarator ASSIGN FLOAT SEMICOLON
	| declarator ASSIGN EXPONENTIAL SEMICOLON
	| declarator
	;

	init_declarator_list
	: init_declarator
	| init_declarator_list COMMA init_declarator
	;

	
	type_specifier
	: VOID
	| INT
	| FLT
	| BOOL
	;
	
	declaration_list
	: DECLARATION
	| declaration_list DECLARATION
	;
	
	declarator
	: IDENTIFIER
	| LPARENTHESIS declarator RPARENTHESIS
	| declarator LPARENTHESIS RPARENTHESIS
	| declarator LPARENTHESIS identifier_list RPARENTHESIS
	| declarator LPARENTHESIS parameter_list RPARENTHESIS
	;
	
	identifier_list
	: IDENTIFIER
	| identifier_list COMMA IDENTIFIER
	;
	
	declaration_specifiers
	: type_specifier declaration_specifiers
	| type_specifier
	;
	
parameter_list
	: parameter_declaration
	| parameter_list COMMA parameter_declaration
	;
	
	compound_statement
	: LBRACE RBRACE
	| LBRACE  block_item_list RBRACE
	;
	
	statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	;
	
	expression_statement
	: SEMICOLON
	| expression SEMICOLON
	;
	
	expression
	: assignment_expression
	| expression COMMA assignment_expression
	;
	
	assignment_expression
	: IDENTIFIER ASSIGN INTEGER unary_operator INTEGER SEMICOLON
	;
	
	unary_operator
	: PLUS
	| MINUS
	;
	
	labeled_statement
	: IDENTIFIER COLON statement
	;

selection_statement
	: IF LPARENTHESIS expression RPARENTHESIS statement ELSE statement
	| IF LPARENTHESIS expression RPARENTHESIS statement
	| SWITCH LPARENTHESIS expression RPARENTHESIS statement
	;
	
	block_item_list
	: block_item
	| block_item_list block_item
	;

block_item
	: DECLARATION
	| statement
	;
parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers
	;

FUNCTION_DEF
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	;


SHADER_DEF
: CLASS IDENTIFIER COLON MATERIAL SEMICOLON { printf("SHADER_DEF material\n");}
| CLASS IDENTIFIER COLON TEXTURE SEMICOLON { printf("SHADER_DEF texture\n");}
;

%%

int main()
{
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}
