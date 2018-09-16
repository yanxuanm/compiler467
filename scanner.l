%{
/**********************************************************************
 *
 * **YOUR GROUP INFO SHOULD GO HERE**
 *
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



gl_FragColor		{ yTRACE(GL_FRAGCOLOR); return GL_FRAGCOLOR; }
gl_FragDepth		{ yTRACE(GL_FRAGDEPTH); return GL_FRAGDEPTH; }
gl_FragCoord		{ yTRACE(GL_FRAGCOORD); return GL_FRAGCOORD; }
gl_TexCoord		{ yTRACE(GL_TEXCOORD); return GL_TEXCOORD; }
gl_Color		{ yTRACE(GL_COLOR); return GL_COLOR; }
gl_Secondary		{ yTRACE(GL_SECONDARY); return GL_SECONDARY; }
gl_FogFragCoord		{ yTRACE(GL_FOGFRAGCOORD); return GL_FOGFRAGCOORD; }
gl_Light_Half		{ yTRACE(GL_LIGHT_HALF); return GL_LIGHT_HALF; }
gl_Light_Ambient	{ yTRACE(GL_LIGHT_AMBIENT); return GL_LIGHT_AMBIENT; }
gl_Material_Shininess	{ yTRACE(GL_MATERIAL_SHININESS); return GL_MATERIAL_SHININESS; }
env1			{ yTRACE(ENV1); return ENV1; }
env2			{ yTRACE(ENV2); return ENV2; }
env3			{ yTRACE(ENV3); return ENV3; }


lit			{ yTRACE(LIT); return LIT; }
dp3			{ yTRACE(DP3); return DP3; }
rsq			{ yTRACE(RSQ); return RSQ; }


while			{ yTRACE(WHILE); return WHILE; }


\!			{ yTRACE(NOT); return NOT; } 
\^			{ yTRACE(POWER); return POWER; }
\*			{ yTRACE(MULTI); return MULTI; }
\/			{ yTRACE(DIVIDE); return DIVIDE; }
\=\=			{ yTRACE(EQUAL); return EQUAL; }
\!\=			{ yTRACE(NOT_EQUAL); return NOT_EQUAL; }
\<			{ yTRACE(LESS); return LESS; }
\<\=			{ yTRACE(LESS_EQUAL); return LESS_EQUAL; }
\> 			{ yTRACE(GREATER); return GREATER; }
\>\=			{ yTRACE(GREATER_EQUAL); return GREATER_EQUAL; }
\&\&			{ yTRACE(LOGICAL_AND); return LOGICAL_AND; }
\|\|			{ yTRACE(LOGICAL_OR); return LOGICAL_OR; }

\/\*			{ yTRACE(OPEN_COMMENTS); return OPEN_COMMENTS; }
\*\/			{ yTRACE(CLOSE_COMMENTS); return CLOSE_COMMENTS; }

void			{ yTRACE(VOID); return VOID; }



%%
