
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]
FLOAT ("-"|"+")?{DIGIT}*"."{DIGIT}*
INTEGER ("-"|"+")?{DIGIT}+
EXP ({FLOAT}|{INTEGER})E{DIGIT}+

STATE "rt_ScreenCoord"|"rt_LensCoord"|"rt_Epsilon"|"rt_HitDistance"|"rt_BoundMin"|"rt_BoundMax"|"rt_TextureUV"|"rt_TextureUVW"|"rt_TextureColor"|"rt_FloatTextureValue"|"rt_dsdu"|"rt_dtdu"|"rt_dsdv"|"rt_dtdv"|"rt_RayOrigin"|"rt_RayDirection"|"rt_InverseRayDirection"|"rt_dPdu"|"rt_dPdv"|"rt_LightDistance"|"rt_LightColor"|"rt_EmissionColor"|"rt_BSDFSeed"|"rt_PDF"|"rt_SampleColor"|"rt_BSDFValue"|"rt_du"|"rt_dv"|"rt_HitPoint"|"rt_GeometricNormal"|"rt_ShadingNormal"|"rt_LightDirection"|"rt_TimeSeed"

QUALIFIER "attribute"|"uniform"|"varying"|"public"|"private"|"scratch"

%{
#include "GrammarBen.yy.h"
int lineCounter=1;
#define ECHO
//#define ECHO printf("[%s]\n", yytext)
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
"color" {ECHO; return COLOR;}
"void" {ECHO; return VOID;}
"int" {ECHO;return INT;}
"float" {ECHO; return FLT;}
"bool" {ECHO; return BOOL;}
"vec2" {ECHO; return VEC2;}
"vec3" {ECHO; return VEC3;}
"vec4" {ECHO; return VEC4;}
"ivec2" {ECHO;return IVEC2;}
"ivec3" {ECHO;return IVEC3;}
"ivec4" {ECHO;return IVEC4;}
"bvec2" {ECHO;return BVEC2;}
"bvec3" {ECHO;return BVEC3;}
"bvec4" {ECHO;return BVEC4;}
"rt_Primitive" {ECHO;return PRIMITIVE;}
"rt_Camera" {ECHO;return CAMERA;}
"rt_Material" {ECHO;return MATERIAL;}
"rt_Texture" {ECHO;return TEXTURE;}
"rt_Light" {ECHO;return LIGHT;}
"return"    {ECHO;return RETURN;}


{STATE} { setFlag(yytext); ECHO; return IDENTIFIER;}
{QUALIFIER} {ECHO; return QUALIFIER;
             printf("QUALIFIER %s\n",yytext);}

"class" {ECHO; return CLASS;}
"inverse" {ECHO; return INVERSE;}
"perpendicular" {ECHO; return PERPENDICULAR;}
"dominantAxis" {ECHO; return DOMINANTAXIS;}
"luminance" {ECHO; return LUMINANCE;}
"rand" {ECHO; return RAND;}
"min" {ECHO; return MIN;}
"max" {ECHO; return MAX;}
"illuminance" {ECHO; return ILLUMINANCE;}
"ambient" {ECHO; return AMBIENT;}
"break" {ECHO; return BREAK;}
"case" {ECHO; return CASE;}
"const" {ECHO; return CONST;}
"continue" {ECHO; return CONTINUE;}
"default" {ECHO; return DEFAULT;}
"do" {ECHO; return DO;}
"double" {ECHO; return DOUBLE;}
"else" {ECHO; return ELSE;}
"enum" {ECHO; return ENUM;}
"extern" {ECHO; return EXTERN;}
"for" {ECHO; return FOR;}
"goto" {ECHO; return GOTO;}
"if" {ECHO; return IF;}
"sizeof" {ECHO; return SIZEOF;}
"static" {ECHO; return STATIC;}
"struct" {ECHO; return STRUCT;}
"switch" {ECHO; return SWITCH;}
"typedef" {ECHO; return TYPEDEF;}
"union" {ECHO; return UNION;}
"unsigned" {ECHO; return UNSIGNED;}
"while" {ECHO; return WHILE;}

{FLOAT} {ECHO; return FLOAT;}
{INTEGER} {ECHO; return INTEGER;}
{EXP} {ECHO; return EXPONENTIAL;}
":" {ECHO; return COLON;}
";" {ECHO; return SEMICOLON;}
"+" {ECHO; return PLUS;}
"*" {ECHO; return MUL;}
"-" {ECHO; return MINUS;}
"/" {ECHO; return DIV;}
"=" {ECHO; return ASSIGN;}
"==" {ECHO; return EQUAL;}
"!=" {ECHO; return NOT_EQUAL;}
"<" {ECHO; return LT;}
"<=" {ECHO; return LE;}
">" {ECHO; return GT;}
">=" {ECHO; return GE;}
"," {ECHO; return COMMA;}
"(" {ECHO; return LPARENTHESIS;}
")" {ECHO; return RPARENTHESIS;}
"[" {ECHO; return LBRACKET;}
"]" {ECHO; return RBRACKET;}
"{" {ECHO; return LBRACE;}
"}" {ECHO; return RBRACE;}
"&&" {ECHO; return AND;}
"||" {ECHO; return OR;}
"++" {ECHO; return INC;}
"--" {ECHO; return DEC;}
"+=" { ECHO; return ADD_ASSIGN; }
"-=" { ECHO; return SUB_ASSIGN; }
"*=" { ECHO; return MUL_ASSIGN; }
"/=" { ECHO; return DIV_ASSIGN; }
"%=" { ECHO; return MOD_ASSIGN; }
"&=" { ECHO; return AND_ASSIGN; }
"^=" { ECHO; return XOR_ASSIGN; }
"|=" { ECHO; return OR_ASSIGN; }

"."[a-zA-Z][a-zA-Z0-9]* {ECHO; return (SWIZZLE); }
[a-zA-Z][a-zA-Z0-9_]* {setFlag(yytext); ECHO; return IDENTIFIER;}
. {
	if ((int)*yytext != 13)
		printf("ERROR(%d): Unrecognized symbol \"%s\"\n",lineCounter,yytext);
	}


%%
