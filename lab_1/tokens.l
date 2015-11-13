/* Code to classify tokens  */ 
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]


%{
int tokenCount=0;
int lineCounter=1;
%}

%%
"/*" {BEGIN(MULTILINECOMMENT);}
<MULTILINECOMMENT>[^*\n]* 
<MULTILINECOMMENT>"*"+[^*/\n]* 
<MULTILINECOMMENT>\n {lineCounter++;}
<MULTILINECOMMENT>"*"+"/" {BEGIN(INITIAL);}

"//".*"\n" {lineCounter++;}

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
