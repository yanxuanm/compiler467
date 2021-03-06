%{
/***********************************************************************
 *   Interface to the parser module for CSC467 course project.
 * 
 *   Phase 2: Implement context free grammar for source language, and
 *            parse tracing functionality.
 *   Phase 3: Construct the AST for the source language program.
 ***********************************************************************/

/***********************************************************************
 *  C Definitions and external declarations for this module.
 *
 *  Phase 3: Include ast.h if needed, and declarations for other global or
 *           external vars, functions etc. as needed.
 ***********************************************************************/

#include <string.h>
#include "common.h"
//#include "ast.h"
//#include "symbol.h"
//#include "semantic.h"
#define YYERROR_VERBOSE
#define yTRACE(x)    { if (traceParser) fprintf(traceFile, "%s\n", x); }

void yyerror(const char* s);    /* what to do in case of error            */
int yylex();              /* procedure for calling lexical analyzer */
extern int yyline;        /* variable holding current line number   */

%}

/***********************************************************************
 *  Yacc/Bison declarations.
 *  Phase 2:
 *    1. Add precedence declarations for operators (after %start declaration)
 *    2. If necessary, add %type declarations for some nonterminals
 *  Phase 3:
 *    1. Add fields to the union below to facilitate the construction of the
 *       AST (the two existing fields allow the lexical analyzer to pass back
 *       semantic info, so they shouldn't be touched).
 *    2. Add <type> modifiers to appropriate %token declarations (using the
 *       fields of the union) so that semantic information can by passed back
 *       by the scanner.
 *    3. Make the %type declarations for the language non-terminals, utilizing
 *       the fields of the union as well.
 ***********************************************************************/

%{
#define YYDEBUG 1
%}


// TODO:Modify me to add more data types
// Can access me from flex useing yyval

%union {
  int as_int;
  char *as_id;
  float as_float;
  bool as_bool;
}
// TODO:Replace myToken with your tokens, you can use these tokens in flex
%token           myToken1 myToken2 

// if/else
IF
ELSE

// {}/()/[]
LEFT_CBRACKET
RIGHT_CBRACKET
LEFT_BRACKET
RIGHT_BRACKET
LEFT_SBRACKET
RIGHT_SBRACKET

// ,
COMMA

// ;
SEMI_COLUMN

// true/false
BOOL_TRUE
BOOL_FALSE

// =
SINGLE_EQUAL

// bool, bvec2, bvec3, bvec4
BOOL
BVEC2
BVEC3
BVEC4

// int, ivec2, ivec3, ivec4
INT
IVEC2
IVEC3
IVEC4

// float, vec2, vec3, vec4
FLOAT
VEC2
VEC3
VEC4

// qualifier
CONST

// double/single quote
DOUBLE_QUOTE
SINGLE_QUOTE

//PREDEFINED variables
GL_FRAGCOLOR
GL_FRAGDEPTH
GL_FRAGCOORD
GL_TEXCOORD
GL_COLOR
GL_SECONDARY
GL_FOGFRAGCOORD
GL_LIGHT_HALF
GL_LIGHT_AMBIENT
GL_MATERIAL_SHININESS
ENV1
ENV2
ENV3

//Predefined functions
LIT 
DP3 
RSQ

//Loops
WHILE

//Operators 
NOT
XOR
MULTI
DIVIDE
PLUS
MINUS
DOUBLE_EQUAL
NOT_EQUAL
LESS
LESS_EQUAL
GREATER
GREATER_EQUAL
LOGICAL_AND
LOGICAL_OR

// identifiers
IDENTIFIER

// integer/float literal
INTEGER_LITERAL
FLOAT_LITERAL

// comment
OPEN_COMMENT
CLOSE_COMMENT

// void
VOID

%start    program

%%

/***********************************************************************
 *  Yacc/Bison rules
 *  Phase 2:
 *    1. Replace grammar found here with something reflecting the source
 *       language grammar
 *    2. Implement the trace parser option of the compiler
 *  Phase 3:
 *    1. Add code to rules for construction of AST.
 ***********************************************************************/
program
  :   tokens       
  ;
tokens
  :  tokens token  
  |      
  ;
// TODO: replace myToken with the token the you defined.
token
  :     myToken1 
  |     myToken2                     
  ;


%%

/***********************************************************************ol
 * Extra C code.
 *
 * The given yyerror function should not be touched. You may add helper
 * functions as necessary in subsequent phases.
 ***********************************************************************/
void yyerror(const char* s) {
  if (errorOccurred)
    return;    /* Error has already been reported by scanner */
  else
    errorOccurred = 1;
        
  fprintf(errorFile, "\nPARSER ERROR, LINE %d",yyline);
  if (strcmp(s, "parse error")) {
    if (strncmp(s, "parse error, ", 13))
      fprintf(errorFile, ": %s\n", s);
    else
      fprintf(errorFile, ": %s\n", s+13);
  } else
    fprintf(errorFile, ": Reading token %s\n", yytname[YYTRANSLATE(yychar)]);
}

