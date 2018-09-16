%{
/**********************************************************************
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;

%}
%option noyywrap

WS          [ \t]

%%

if		{ yTRACE(IF); return IF; }
else	{ yTRACE(ELSE); return ELSE; }

,		{ yTRACE(COMMA); return COMMA; }
;		{ yTRACE(SEMI_COLUMN); return SEMI_COLUMN; }

true	{ yylval.as_bool = true; yTRACE(BOOL_TRUE); return BOOL_TRUE; }
false 	{ yylval.as_bool = false; yTRACE(BOOL_FALSE); return BOOL_FALSE; }

bool	{ yTRACE(BOOL); return BOOL; }
bvec2	{ yTRACE(BVEC2); return BVEC2; }
bvec3	{ yTRACE(BVEC3); return BVEC3; }
bvec4	{ yTRACE(BVEC4); return BVEC4; }

int		{ yTRACE(INT); return INT; }
ivec2	{ yTRACE(IVEC2); return IVEC2; }
ivec3	{ yTRACE(IVEC3); return IVEC3; }
ivec4	{ yTRACE(IVEC4); return IVEC4; }

float	{ yTRACE(FLOAT); return FLOAT; }
vec2	{ yTRACE(VEC2); return VEC2; }
vec3	{ yTRACE(VEC3); return VEC3; }
vec4	{ yTRACE(VEC4); return VEC4; }

const	{ yTRACE(CONST); return CONST; }

\"		{ yTRACE(DOUBLE_QUOTE) return DOUBLE_QUOTE; }
\'		{ yTRACE(SINGLE_QUOTE) return SINGLE_QUOTE; }

gl_FragColor		{ yTRACE(GL_FRAGCOLOR); return GL_FRAGCOLOR; }
gl_FragDepth		{ yTRACE(GL_FRAGDEPTH); return GL_FRAGDEPTH; }
gl_FragCoord		{ yTRACE(GL_FRAGCOORD); return GL_FRAGCOORD; }
gl_TexCoord			{ yTRACE(GL_TEXCOORD); return GL_TEXCOORD; }
gl_Color			{ yTRACE(GL_COLOR); return GL_COLOR; }
gl_Secondary		{ yTRACE(GL_SECONDARY); return GL_SECONDARY; }
gl_FogFragCoord		{ yTRACE(GL_FOGFRAGCOORD); return GL_FOGFRAGCOORD; }
gl_Light_Half		{ yTRACE(GL_LIGHT_HALF); return GL_LIGHT_HALF; }
gl_Light_Ambient	{ yTRACE(GL_LIGHT_AMBIENT); return GL_LIGHT_AMBIENT; }
gl_Material_Shininess	{ yTRACE(GL_MATERIAL_SHININESS); return GL_MATERIAL_SHININESS; }
env1				{ yTRACE(ENV1); return ENV1; }
env2				{ yTRACE(ENV2); return ENV2; }
env3				{ yTRACE(ENV3); return ENV3; }

lit			{ yTRACE(LIT); return LIT; }
dp3			{ yTRACE(DP3); return DP3; }
rsq			{ yTRACE(RSQ); return RSQ; }

while		{ yTRACE(WHILE); return WHILE; }

\{			{ yTRACE(LEFT_CBRACKET); return LEFT_CBRACKET; }
\}			{ yTRACE(RIGHT_CBRACKET); return RIGHT_CBRACKET; }
\(			{ yTRACE(LEFT_BRACKET); return LEFT_BRACKET; }
\)			{ yTRACE(RIGHT_BRACKET); return RIGHT_BRACKET; }
\[			{ yTRACE(LEFT_SBRACKET); return LEFT_SBRACKET; }
\]			{ yTRACE(RIGHT_SBRACKET); return RIGHT_SBRACKET; }
\!			{ yTRACE(NOT); return NOT; } 
\*			{ yTRACE(MULTI); return MULTI; }
\/			{ yTRACE(DIVIDE); return DIVIDE; }
\+			{ yTRACE(PLUS); return PLUS; }
\-			{ yTRACE(MINUS); return MINUS; }
\<			{ yTRACE(LESS); return LESS; }
\<\=		{ yTRACE(LESS_EQUAL); return LESS_EQUAL; }
\> 			{ yTRACE(GREATER); return GREATER; }
\>\=		{ yTRACE(GREATER_EQUAL); return GREATER_EQUAL; }
\=\=		{ yTRACE(DOUBLE_EQUAL); return DOUBLE_EQUAL; }
\!\=		{ yTRACE(NOT_EQUAL); return NOT_EQUAL; }
\^			{ yTRACE(XOR); return XOR; }
\&\&		{ yTRACE(LOGICAL_AND); return LOGICAL_AND; }
\|\|		{ yTRACE(LOGICAL_OR); return LOGICAL_OR; }
=			{ yTRACE(SINGLE_EQUAL); return SINGLE_EQUAL; }

\/\*		{ yTRACE(OPEN_COMMENT); return OPEN_COMMENT; }
\*\/		{ yTRACE(CLOSE_COMMENT); return CLOSE_COMMENT; }

void		{ yTRACE(VOID); return VOID; }

[A-Za-z_][A-Za-z0-9_]*	{
							if (yyleng <= MAX_IDENTIFIER) {
								yylval.as_id = (char *)malloc((yyleng + 1) * sizeof(char));
								if (yylval.as_id == NULL) {
									yERROR("Failed to allocate memory for identifier's name");								
								}

								strncpy(yylval.as_id, yytext, yyleng * sizeof(char));
								yTRACE(IDENTIFIER);
								return IDENTIFIER;
							} 
							yERROR("Please choose another identifier name with length less than or equal to 32");	
						}

[+-]?[0-9]+				{
							if (yyleng >= 6) {
								yERROR("Integer's absolute value exceeds maximum value(32767)");	
							}
							
							int val = atoi(yytext);
							if (abs(val) >= MAX_INTEGER) {
								yERROR("Integer's absolute value exceeds maximum value(32767)");					
							}
							
							yylval.as_int = val;
							yTRACE(INTEGER_LITERAL);
							return INTEGER_LITERAL;
						}

([+-]?[0-9]*\.[0-9]+)|([+-]?[0-9]+\.[0-9]*)	{
												yylval.as_float = atof(yytext);
												yTRACE(FLOAT);
												return FLOAT;
											}

%%
