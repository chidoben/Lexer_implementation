/* Enrique Ortiz Pasamontes 376637, Ahmed Ezzat Mohamed Hefny Elmeleh 377483, Chidozie Benjamin Ezepue 376612, Tijmen Lodewijk Verhulsdonck 376822*/
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]
FLOAT ("-"|"+")?{DIGIT}*"."{DIGIT}*
INTEGER ("-"|"+")?{DIGIT}+
EXP ({FLOAT}|{INTEGER})E{DIGIT}+

TYPE "void"|"int"|"float"|"bool"|"vec2"|"vec3"|"vec4"|"ivec2"|"ivec3"|"ivec4"|"bvec2"|"bvec3"|"bvec4"|"rt_Primitive"|"rt_Camera"|"rt_Material"|"rt_Texture"|"rt_Light"

STATE "rt_ScreenCoord"|"rt_LensCoord"|"rt_Epsilon"|"rt_HitDistance"|"rt_BoundMin"|"rt_BoundMax"|"rt_TextureUV"|"rt_TextureUVW"|"rt_TextureColor"|"rt_FloatTextureValue"|"rt_dsdu"|"rt_dtdu"|"rt_dsdv"|"rt_dtdv"|"rt_RayOrigin"|"rt_RayDirection"|"rt_InverseRayDirection"|"rt_dPdu"|"rt_dPdv"|"rt_LightDistance"|"rt_LightColor"|"rt_EmissionColor"|"rt_BSDFSeed"|"rt_PDF"|"rt_SampleColor"|"rt_BSDFValue"|"rt_du"|"rt_dv"|"rt_HitPoint"|"rt_GeometricNormal"|"rt_ShadingNormal"|"rt_LightDirection"|"rt_TimeSeed"

QUALIFIER "attribute"|"uniform"|"varying"|"public"|"private"|"scratch"

KEYWORD "sqrt"|"dot"|"class"|"inverse"|"inside"|"perpendicular"|"dominantAxis"|"trace"|"hit"|"luminance"|"rand"|"pow"|"min"|"max"|"illuminance"|"ambient"|"break"|"case"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"for"|"goto"|"if"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"while"

%{
#include "test0.yy.h"
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

"void" {return VOID;}
"int" {return INT;}
"float" {return FLT;}
"bool" {return BOOL;}
"vec2" {return VEC2;}
"vec3" {return VEC3;}
"vec4" {return VEC4;}
"ivec2" {return IVEC2;}
"ivec3" {return IVEC3;}
"ivec4" {return IVEC4;}
"bvec2" {return BVEC2;}
"bvec3" {return BVEC3;}
"bvec4" {return BVEC4;}
"rt_Primitive" {return PRIMITIVE;}
"rt_Camera" {return CAMERA;}
"rt_Material" {return MATERIAL;}
"rt_Texture" {return TEXTURE;}
"rt_Light" {return LIGHT;}

{STATE} {printf("STATE %s\n",yytext);}
{QUALIFIER} {printf("QUALIFIER %s\n",yytext);}

"sqrt" {return SQRT;}
"dot" {return DOT;}
"class" {return CLASS;}
"inverse" {return INVERSE;}
"inside" {return INSIDE;}
"perpendicular" {return PERPENDICULAR;}
"dominantAxis" {return DOMINANTAXIS;}
"trace" {return TRACE;}
"hit" {return HIT;}
"luminance" {return LUMINANCE;}
"rand" {return RAND;}
"pow" {return POW;}
"min" {return MIN;}
"max" {return MAX;}
"illuminance" {return ILLUMINANCE;}
"ambient" {return AMBIENT;}
"break" {return BREAK;}
"case" {return CASE;}
"const" {return CONST;}
"continue" {return CONTINUE;}
"default" {return DEFAULT;}
"do" {return DO;}
"double" {return DOUBLE;}
"else" {return ELSE;}
"enum" {return ENUM;}
"extern" {return EXTERN;}
"for" {return FOR;}
"goto" {return GOTO;}
"if" {return IF;}
"sizeof" {return SIZEOF;}
"static" {return STATIC;}
"struct" {return STRUCT;}
"switch" {return SWITCH;}
"typedef" {return TYPEDEF;}
"union" {return UNION;}
"unsigned" {return UNSIGNED;}
"while" {return WHILE;}

{FLOAT} {return FLOAT;}
{INTEGER} {return INTEGER;}
{EXP} {return EXPONENTIAL;}
":" {return COLON;}
";" {return SEMICOLON;}
"+" {return PLUS;}
"*" {return MUL;}
"-" {return MINUS;}
"/" {return DIV;}
"=" {return ASSIGN;}
"==" {return EQUAL;}
"!=" {return NOT_EQUAL;}
"<" {return LT;}
"<=" {return LE;}
">" {return GT;}
">=" {return GE;}
"," {return COMMA;}
"(" {return LPARENTHESIS;}
")" {return RPARENTHESIS;}
"[" {return LBRACKET;}
"]" {return RBRACKET;}
"{" {return LBRACE;}
"}" {return RBRACE;}
"&&" {return AND;}
"||" {return OR;}
"++" {return INC;}
"--" {return DEC;}

"."[a-zA-Z][a-zA-Z0-9]* { printf("SWIZZLE %s\n", yytext+1); }
[a-zA-Z][a-zA-Z0-9_]* { return IDENTIFIER; printf("IDENTIFIER %s\n", yytext); }
. {printf("ERROR(%d): Unrecognized symbol \"%s\"\n",lineCounter,yytext);}


%%

/*int main() {
  yylex();
  //printf("%d\n",lineCounter);
  return 0;
}
*/