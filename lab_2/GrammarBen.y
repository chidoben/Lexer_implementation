%{
# include <stdio.h>
//Flags of what shader has been declared
int shaderCamera = 0;
int shaderMaterial = 0;
int shaderTexture = 0;
int shaderPrimitive = 0;
//Flags regarding what tipe of interface methods have been used
int methodCamera = 0;
int methodMaterial = 0;
int methodTexture = 0;

//Flags to stateAccess
int textureAccess = 0;
%}

/* declare tokens */
%token COLOR INT FLT BOOL VEC2 VEC3 VEC4 IVEC2 IVEC3 IVEC4 BVEC2 BVEC3 BVEC4 PRIMITIVE CAMERA MATERIAL TEXTURE LIGHT RETURN 
%token QUALIFIER
%token FLOAT INTEGER EXPONENTIAL
%token IDENTIFIER SWIZZLE
%token SEMICOLON COLON
%token NEWLINE 
%token PLUS MUL MINUS DIV ASSIGN EQUAL NOT_EQUAL LT LE GT GE COMMA LPARENTHESIS RPARENTHESIS LBRACKET RBRACKET LBRACE RBRACE AND OR INC DEC
%token MUL_ASSIGN   DIV_ASSIGN  MOD_ASSIGN  ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN  XOR_ASSIGN  OR_ASSIGN        
%token CLASS INVERSE PERPENDICULAR DOMINANTAXIS HIT LUMINANCE RAND MIN MAX ILLUMINANCE AMBIENT BREAK CASE CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FOR GOTO IF SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID WHILE
%token INSIDE POW DOT SQRT TRACE
%start translation_unit
%%

translation_unit: external_declaration
	        | translation_unit external_declaration
	        ;

external_declaration: function_definition
	            | declaration
                    | SHADER_DEF
                    ;
/**************************/
function_definition: declaration_specifiers declarator declaration_list compound_statement  { printf("FUNCTION_DEF\n");}
	           | declaration_specifiers declarator compound_statement { printf("FUNCTION_DEF\n");}
	           ;

/********************/

declaration: declaration_specifiers SEMICOLON { printf("DECLARATION\n");}
	   | declaration_specifiers init_declarator_list SEMICOLON { printf("DECLARATION\n");}
	   ;

SHADER_DEF: CLASS IDENTIFIER COLON MATERIAL SEMICOLON { printf("SHADER_DEF material\n"); shaderMaterial=1;}
          | CLASS IDENTIFIER COLON TEXTURE SEMICOLON { printf("SHADER_DEF texture\n"); shaderTexture=1;}
          | CLASS IDENTIFIER COLON CAMERA SEMICOLON { printf("SHADER_DEF camera\n"); shaderCamera=1;}
          | CLASS IDENTIFIER COLON PRIMITIVE SEMICOLON { printf("SHADER_DEF primitive\n"); shaderPrimitive=1;}
          ;
/**************************/
declaration_specifiers: storage_class_specifier declaration_specifiers
	              | storage_class_specifier
	              | type_specifier declaration_specifiers
	              | type_specifier
	              | type_qualifier declaration_specifiers
	              | type_qualifier
	              ;

declarator: direct_declarator
	  ;


declaration_list: declaration
	        | declaration_list declaration
	        ;

compound_statement: LBRACE RBRACE
	          | LBRACE  block_item_list RBRACE
	          ;

init_declarator_list: init_declarator
	            | init_declarator_list COMMA init_declarator
	            ;
/**************************/

storage_class_specifier: TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
	               | EXTERN
	               | STATIC
	               ;

type_specifier: VOID
		  | COLOR
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


type_qualifier: CONST
	      ;

direct_declarator: IDENTIFIER
	         | LPARENTHESIS declarator RPARENTHESIS
	         | direct_declarator LBRACKET RBRACKET
	         | direct_declarator LBRACKET MUL RBRACKET
	         | direct_declarator LBRACKET STATIC type_qualifier_list assignment_expression RBRACKET
	         | direct_declarator LBRACKET STATIC assignment_expression RBRACKET
	         | direct_declarator LBRACKET type_qualifier_list MUL RBRACKET
	         | direct_declarator LBRACKET type_qualifier_list STATIC assignment_expression RBRACKET
	         | direct_declarator LBRACKET type_qualifier_list assignment_expression RBRACKET
	         | direct_declarator LBRACKET type_qualifier_list RBRACKET
	         | direct_declarator LBRACKET assignment_expression RBRACKET
	         | direct_declarator LPARENTHESIS parameter_type_list RPARENTHESIS
	         | direct_declarator LPARENTHESIS RPARENTHESIS
	         | direct_declarator LPARENTHESIS identifier_list RPARENTHESIS
	         ;

block_item_list: block_item
	       | block_item_list block_item
	       ;

init_declarator: declarator ASSIGN initializer
	       | declarator
	       ;

/**************************/

type_qualifier_list: type_qualifier
	           | type_qualifier_list type_qualifier
	           ;

assignment_expression: conditional_expression
	             | unary_expression assignment_operator assignment_expression
	             ;

parameter_list: parameter_declaration
	      | parameter_list COMMA parameter_declaration
	      ;

identifier_list: IDENTIFIER
	       | identifier_list COMMA IDENTIFIER
	       ;

block_item: declaration
	  | statement
	  ;

initializer: LBRACE initializer_list RBRACE;
	   | LBRACE initializer_list COMMA RBRACE;
	   | assignment_expression
	   ;
parameter_type_list: parameter_list
	           ;
/**************************/
conditional_expression: logical_or_expression
	              | logical_or_expression '?' expression COLON conditional_expression
	              ;

unary_expression: postfix_expression
	        | INC unary_expression
	        | DEC unary_expression
	        | unary_operator cast_expression
	        | SIZEOF unary_expression
	        | SIZEOF LPARENTHESIS type_name RPARENTHESIS
	        ;

assignment_operator: ASSIGN
                    | MUL_ASSIGN
	            | DIV_ASSIGN
	            | MOD_ASSIGN
	            | ADD_ASSIGN
	            | SUB_ASSIGN
	            | LEFT_ASSIGN
	            | RIGHT_ASSIGN
	            | AND_ASSIGN
	            | XOR_ASSIGN
	            | OR_ASSIGN
	           ;

parameter_declaration: declaration_specifiers declarator
	             | declaration_specifiers abstract_declarator
	             | declaration_specifiers
	             ;

statement: labeled_statement  { printf("STATEMENT\n");}
	 | compound_statement  { printf("STATEMENT\n");}
	 | expression_statement { printf("STATEMENT\n");}
	 | selection_statement  { printf("STATEMENT\n");}
	 | iteration_statement  { printf("STATEMENT\n");}
	 | jump_statement       { printf("STATEMENT\n");}
	 ;

initializer_list: designation initializer
	        | initializer
	        | initializer_list COMMA designation initializer
	        | initializer_list COMMA initializer
	        ;

/**************************/
logical_or_expression: logical_and_expression
	             | logical_or_expression OR logical_and_expression
	             ;

expression: assignment_expression
	  | expression COMMA assignment_expression
	  ;

postfix_expression: primary_expression
			  | COLOR LPARENTHESIS argument_expression_list RPARENTHESIS
			  | VEC3 LPARENTHESIS argument_expression_list RPARENTHESIS
			  | HIT LPARENTHESIS argument_expression_list RPARENTHESIS
			  | DOT LPARENTHESIS argument_expression_list RPARENTHESIS
	          | postfix_expression LBRACKET expression RBRACKET
	          | postfix_expression LPARENTHESIS RPARENTHESIS
	          | postfix_expression LPARENTHESIS argument_expression_list RPARENTHESIS
	          //| postfix_expression '.' IDENTIFIER  //looks like swizzle
	          | postfix_expression SWIZZLE
	          | postfix_expression INC
	          | postfix_expression DEC
	          | LPARENTHESIS type_name RPARENTHESIS LBRACE initializer_list RBRACE
	          | LPARENTHESIS type_name RPARENTHESIS LBRACE initializer_list COMMA RBRACE
	          ;

unary_operator: '&'
	      | MUL
	      | PLUS
	      | MINUS
	      | '~'
	      | '!'
	      ;

cast_expression: unary_expression
	       | LPARENTHESIS type_name RPARENTHESIS cast_expression
	       ;

abstract_declarator: direct_abstract_declarator
	           ;

labeled_statement: IDENTIFIER COLON statement
	         | CASE constant_expression COLON statement
	         | DEFAULT COLON statement
	         ; 

expression_statement: SEMICOLON
	           | expression SEMICOLON
	           ;

selection_statement: IF LPARENTHESIS expression RPARENTHESIS statement ELSE statement { printf("IF - ELSE\n");}
	           | IF LPARENTHESIS expression RPARENTHESIS statement { printf("IF\n");}
	           | SWITCH LPARENTHESIS expression RPARENTHESIS statement
	           ;

iteration_statement: WHILE LPARENTHESIS expression RPARENTHESIS statement
	           | DO statement WHILE LPARENTHESIS expression RPARENTHESIS SEMICOLON
	           | FOR LPARENTHESIS expression_statement expression_statement RPARENTHESIS statement
	           | FOR LPARENTHESIS expression_statement expression_statement expression RPARENTHESIS statement
	           | FOR LPARENTHESIS declaration expression_statement RPARENTHESIS statement
	           | FOR LPARENTHESIS declaration expression_statement expression RPARENTHESIS statement
	           ;

jump_statement: GOTO IDENTIFIER SEMICOLON
	      | CONTINUE SEMICOLON
	      | BREAK SEMICOLON
	      | RETURN SEMICOLON
	      | RETURN expression SEMICOLON
	      ;

designation: designator_list ASSIGN
	   ;

type_name: specifier_qualifier_list abstract_declarator
	| specifier_qualifier_list
	;
/**************************/

logical_and_expression: inclusive_or_expression
	              | logical_and_expression AND inclusive_or_expression
	              ;

primary_expression: IDENTIFIER
	          | constant
	          //| string
	          | LPARENTHESIS expression RPARENTHESIS
	          ;

argument_expression_list: assignment_expression
	               | argument_expression_list COMMA assignment_expression
	                ;

direct_abstract_declarator: LPARENTHESIS abstract_declarator RPARENTHESIS
	                  | LBRACKET RBRACKET
	                  | LBRACKET MUL LBRACKET
	                  | LBRACKET STATIC type_qualifier_list assignment_expression RBRACKET
	                  | LBRACKET STATIC assignment_expression RBRACKET
	                  | LBRACKET type_qualifier_list STATIC assignment_expression RBRACKET
	                  | LBRACKET type_qualifier_list assignment_expression RBRACKET
	                  | LBRACKET type_qualifier_list RBRACKET
	                  | LBRACKET assignment_expression RBRACKET
	                  | direct_abstract_declarator LBRACKET RBRACKET
	                  | direct_abstract_declarator LBRACKET MUL RBRACKET
	                  | direct_abstract_declarator LBRACKET STATIC type_qualifier_list assignment_expression RBRACKET
	                  | direct_abstract_declarator LBRACKET STATIC assignment_expression RBRACKET
	                  | direct_abstract_declarator LBRACKET type_qualifier_list assignment_expression RBRACKET
	                  | direct_abstract_declarator LBRACKET type_qualifier_list STATIC assignment_expression RBRACKET
	                  | direct_abstract_declarator LBRACKET type_qualifier_list RBRACKET
	                  | direct_abstract_declarator LBRACKET assignment_expression RBRACKET
	                  | LPARENTHESIS RPARENTHESIS
	                  | LPARENTHESIS parameter_type_list RPARENTHESIS
	                  | direct_abstract_declarator LPARENTHESIS RPARENTHESIS
	                  | direct_abstract_declarator LPARENTHESIS parameter_type_list RPARENTHESIS
	                  ;

constant_expression: conditional_expression	/* with constraints */
	           ;


designator_list: designator
	       | designator_list designator
	       ;
specifier_qualifier_list: type_specifier specifier_qualifier_list
	                | type_specifier
	                | type_qualifier specifier_qualifier_list
	                | type_qualifier
	                ;
/**************************/
inclusive_or_expression: exclusive_or_expression
	               | inclusive_or_expression '|' exclusive_or_expression
	               ;

exclusive_or_expression: and_expression
	               | exclusive_or_expression '^' and_expression
	                ;
type_qualifier: QUALIFIER
	      ;

/* FIX-IT: we don't have a way of recognizing constants and string literals in our lex.*/
/*constant: I_CONSTANT		
	| F_CONSTANT
	;*/

constant: FLOAT
         | INTEGER
         | EXPONENTIAL
         ;
/*string: IDENTIFIER
       ;
/*string: STRING_LITERAL
      ;*/

designator:  LBRACKET constant_expression  RBRACKET
	  | '.' IDENTIFIER
	  ;
/**************************/

and_expression: equality_expression
	      | and_expression '&' equality_expression
	      ;
/**************************/
equality_expression: relational_expression
	           | equality_expression EQUAL relational_expression
	           | equality_expression NOT_EQUAL relational_expression
	           ;
/**************************/
relational_expression: shift_expression
	             | relational_expression LT shift_expression
	             | relational_expression GT shift_expression
	             | relational_expression LE shift_expression
	             | relational_expression GE shift_expression
	             ;
/**************************/
shift_expression: additive_expression
	        ;
/**************************/
additive_expression: multiplicative_expression
	           | additive_expression PLUS multiplicative_expression
	           | additive_expression MINUS multiplicative_expression
	           ;
/**************************/
multiplicative_expression: cast_expression
	                 | multiplicative_expression MUL cast_expression
	                 | multiplicative_expression DIV cast_expression
	                 ;
%%
void flagCheck()
{
	if(shaderMaterial)
	{
		if(methodCamera)
			yyerror("material cannot have an interface method of camera");
		if(methodTexture)
			yyerror("material cannot have an interface method of texture");
		if(textureAccess)
			yyerror("Material cannot access to a state of texture");
	}

	if(shaderCamera)
	{
		if(methodMaterial)
			yyerror("camera cannot have an interface method of material");
		if(methodTexture)
			yyerror("camera cannot have an interface method of texture");
		if(textureAccess)
			yyerror("camera cannot access to a state of texture");
	}

	if(shaderTexture)
	{
		if(methodMaterial)
			yyerror("texture cannot have an interface method of material");
		if(methodCamera)
			yyerror("texture cannot have an interface method of camera");
	}

	if(shaderPrimitive)
	{

	}
}

void setFlag(char *s)
{
	if(strcmp(s, "shade")==0)
		methodMaterial=1; //shade is an interface method of material

	if(strcmp(s, "generateRay")==0)
		methodCamera=1; //generateRay is an interface method of camera

	if(strcmp(s, "rt_TextureUVW")==0)
		textureAccess=1; //rt_TextureUVW belongs to texture shader


}

int main( int argc, char **argv )
{
  // we assume that the input file is given as input as first argument
  ++argv, --argc;   
  if ( argc > 0 )
    stdin = fopen( argv[0], "r" );
  yyparse();
  flagCheck();

  return 0;
}

yyerror(char *s)
{
  fprintf(stderr, "Error: %s\n", s);
}
