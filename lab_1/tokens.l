/* Code to classify tokens  */ 
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]


%{
int tokenCount=0;
int lineCounter=1;
%}
letter [a-zA-Z]
digit [0-9]
DEFTYPES ["int""float""bool"]
VECTYPES i?"vec"[234]
BITYPES ["Primitive""Camera""Material""Texture""Light"]
%%
"/*" {BEGIN(MULTILINECOMMENT);}
<MULTILINECOMMENT>[^*\n]* 
<MULTILINECOMMENT>"*"+[^*/\n]* 
<MULTILINECOMMENT>\n {lineCounter++;}
<MULTILINECOMMENT>"*"+"/" {BEGIN(INITIAL);}

"//".*"\n" {lineCounter++;}

int { printf("TYPE");}
float { printf("TYPE");}
bool { printf("TYPE");}
void { printf("TYPE");}
i?"vec"[234] { printf("TYPE");}
rt_Primitive { printf("TYPE");}
rt_Camera { printf("TYPE");}
rt_Material { printf("TYPE");}
rt_Texture { printf("TYPE");}
rt_Light { printf("TYPE");}

attribute { printf("QUALIFIER");}
uniform { printf("QUALIFIER");}
varying { printf("QUALIFIER");}
const { printf("QUALIFIER");}
public { printf("QUALIFIER");}
private { printf("QUALIFIER");}
scratch { printf("QUALIFIER");}

"rt_"({letter}|{digit})+ { printf("STATE");}

{letter}({letter}|{digit})* { printf(IDENTIFIER);}
[+-]"."{digit}*	{ printf( "FLOAT"; }
[+-]{digit}+"."{digit}*	{ printf( "FLOAT"; }
"."{digit}*	{ printf( "FLOAT"; }
{digit}+"."{digit}*	{ printf( "FLOAT"; }

: { printf(COLON);}
; { printf(SEMICOLON);}

"."[a-zA-Z][a-zA-Z0-9]* { printf("SWIZZLE %s\n", yytext+1); }
[a-zA-Z][a-zA-Z0-9]* { printf("IDENTIFIER %s\n", yytext); }

\n {lineCounter++;}
" "* {}


%%
/*
[ \t]
[0-9]+    { printf("%d NUMBER \"%s\"\n", ++tokenCount, yytext); }
[a-zA-Z]+ { printf("%d WORD \"%s\"\n", ++tokenCount, yytext); }
*/

int main() {
  yylex();
  printf("%d\n",lineCounter);
  return 0;
}
