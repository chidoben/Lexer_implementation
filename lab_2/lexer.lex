
%option noyywrap
%x MULTILINECOMMENT
DIGIT [0-9]
FLOAT ("-"|"+")?{DIGIT}*"."{DIGIT}*
INTEGER ("-"|"+")?{DIGIT}+
EXP ({FLOAT}|{INTEGER})E{DIGIT}+

QUALIFIER "attribute"|"uniform"|"varying"|"public"|"private"|"scratch"

%{
#include "grammar.yy.h"
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

"rt_ScreenCoord" {return RT_SCREENCOORD;}
"rt_LensCoord" {return RT_LENSCOORD;}
"rt_Epsilon" {return RT_EPSILON;}
"rt_HitDistance" {return RT_HITDISTANCE;}
"rt_BoundMin" {return RT_BOUNDMIN;}
"rt_BoundMax" {return RT_BOUNDMAX;}
"rt_TextureUV" {return RT_TEXTUREUV;}
"rt_TextureUVW" {return RT_TEXTUREUVW;}
"rt_TextureColor" {return RT_TEXTURECOLOR;}
"rt_FloatTextureValue" {return RT_FLOATTEXTUREVALUE;}
"rt_dsdu" {return RT_DSDU;}
"rt_dtdu" {return RT_DTDU;}
"rt_dsdv" {return RT_DSDV;}
"rt_dtdv" {return RT_DTDV;}
"rt_RayOrigin" {return RT_RAYORIGIN;}
"rt_RayDirection" {return RT_RAYDIRECTION;}
"rt_InverseRayDirection" {return RT_INVERSERAYDIRECTION;}
"rt_dPdu" {return RT_DPDU;}
"rt_dPdv" {return RT_DPDV;}
"rt_LightDistance" {return RT_LIGHTDISTANCE;}
"rt_LightColor" {return RT_LIGHTCOLOR;}
"rt_EmissionColor" {return RT_EMISSIONCOLOR;}
"rt_BSDFSeed" {return RT_BSDFSEED;}
"rt_PDF" {return RT_PDF;}
"rt_SampleColor" {return RT_SAMPLECOLOR;}
"rt_BSDFValue" {return RT_BSDFVALUE;}
"rt_du" {return RT_DU;}
"rt_dv" {return RT_DV;}
"rt_HitPoint" {return RT_HITPOINT;}
"rt_GeometricNormal" {return RT_GEOMETRICNORMAL;}
"rt_ShadingNormal" {return RT_SHADINGNORMAL;}
"rt_LightDirection" {return RT_LIGHTDIRECTION;}
"rt_TimeSeed" {return RT_TIMESEED;}

"attribute" {return ATTRIBUTE;}
"uniform" {return UNIFORM;}
"varying" {return VARYING;}
"public" {return PUBLIC;}
"private" {return PRIVATE;}
"scratch" {return SCRATCH;}


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
