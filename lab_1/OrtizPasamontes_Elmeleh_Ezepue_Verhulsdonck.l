/* Enrique Ortiz Pasamontes 376637, Ahmed Ezzat Mohamed Hefny Elmeleh 377483, Chidozie Benjamin Ezepue 376612, Tijmen Lodewijk Verhulsdonck 376822*/
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]
FLOAT ("-"|"+")?{DIGIT}*"."{DIGIT}*
INTEGER ("-"|"+")?{DIGIT}+
EXP ({FLOAT}|{INTEGER})E{DIGIT}+

TYPE "void"|"int"|"float"|"bool"|"vec2"|"vec3"|"vec4"|"ivec2"|"ivec3"|"ivec4"|"bvec2"|"bvec3"|"bvec4"|"rt_Primitive"|"rt_Camera"|"rt_Material"|"rt_Texture"|"rt_Light"
STATE "rt_ScreenCoord"|"rt_LensCoord"|"rt_Epsilon"|"rt_HitDistance"|"rt_BoundMin"|"rt_BoundMax"|"rt_TextureUV"|"rt_TextureUVW"|"rt_TextureColor"|"rt_FloatTextureValue"|"rt_dsdu"|"rt_dtdu"|"rt_dsdv"|"rt_dtdv"|"rt_RayOrigin"|"rt_RayDirection"|"rt_InverseRayDirection"|"rt_dPdu"|"rt_dPdv"|"rt_LightDistance"|"rt_LightColor"|"rt_EmissionColor"|"rt_BSDFSeed"|"rt_PDF"|"rt_SampleColor"|"rt_BSDFValue"|"rt_du"|"rt_dv"|"rt_HitPoint"|"rt_GeometricNormal"|"rt_ShadingNormal"|"rt_LightDirection"|"rt_TimeSeed"
QUALIFIER "attribute"|"uniform"|"varying"|"const"|"public"|"private"|"scratch"
KEYWORD "sqrt"|"dot"|"class"|"inverse"|"inside"|"perpendicular"|"dominantAxis"|"trace"|"hit"|"luminance"|"rand"|"pow"|"min"|"max"|"illuminance"|"ambient"|"break"|"case"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"for"|"goto"|"if"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"while"
%{
int lineCounter=1;
%}

%%
"/*" {BEGIN(MULTILINECOMMENT);}
<MULTILINECOMMENT>[^*\n]* 
<MULTILINECOMMENT>"*"+[^*/\n]* 
<MULTILINECOMMENT>\n {lineCounter++;}
<MULTILINECOMMENT>"*"+"/" {BEGIN(INITIAL);}
"//".*"\n" {lineCounter++;}
\n {lineCounter++;}
" "* {}

{TYPE} {printf("TYPE %s\n",yytext);}
{STATE} {printf("STATE %s\n",yytext);}
{QUALIFIER} {printf("QUALIFIER %s\n",yytext);}
{KEYWORD} {printf("KEYWORD %s\n",yytext);}

{FLOAT} {printf("FLOAT %s\n",yytext);}
{INTEGER} {printf("INTEGER %s\n",yytext);}
{EXP} {printf("EXP %s\n",yytext);}
":" {printf("COLON\n");}
";" {printf("SEMICOLON\n");}
"+" {printf("PLUS\n");}
"*" {printf("MUL\n");}
"-" {printf("MINUS\n");}
"/" {printf("DIV\n");}
"=" {printf("ASSIGN\n");}
"==" {printf("EQUAL\n");}
"!=" {printf("NOT_EQUAL\n");}
"<" {printf("LT\n");}
"<=" {printf("LE\n");}
">" {printf("GT\n");}
">=" {printf("GE\n");}
"," {printf("COMMA\n");}
"(" {printf("LPARENTHESIS\n");}
")" {printf("RPARENTHESIS\n");}
"[" {printf("LBRACKET\n");}
"]" {printf("RBRACKET\n");}
"{" {printf("LBRACE\n");}
"}" {printf("RBRACE\n");}
"&&" {printf("AND\n");}
"||" {printf("OR\n");}
"++" {printf("INC\n");}
"--" {printf("DEC\n");}

"."[a-zA-Z][a-zA-Z0-9]* { printf("SWIZZLE %s\n", yytext+1); }
[a-zA-Z][a-zA-Z0-9_]* { printf("IDENTIFIER %s\n", yytext); }
. {printf("ERROR(%d): Unrecognized symbol \"%s\"\n",lineCounter,yytext);}


%%
int main() {
  yylex();
  //printf("%d\n",lineCounter);
  return 0;
}
