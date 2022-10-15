%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexical_analyzer.h"

int lines;
int pos_start;
int pos_end;
%}

%%

\+ { pos_start = pos_end;pos_end++;return ADD;}
\- { pos_start = pos_end;pos_end++;return SUB;}
\* { pos_start = pos_end;pos_end++;return MUL;}
\/ { pos_start = pos_end;pos_end++;return DIV;}
\< { pos_start = pos_end;pos_end++;return LT;}
\<\= { pos_start = pos_end;pos_end += 2;return LTE;}
\> { pos_start = pos_end;pos_end++;return GT;}
\>\= { pos_start = pos_end;pos_end += 2;return GTE;}
\=\= { pos_start = pos_end;pos_end += 2;return EQ;}
\!\= { pos_start = pos_end;pos_end += 2;return NEQ;}
\= { pos_start = pos_end;pos_end++;return ASSIN;}


\; { pos_start = pos_end;pos_end++;return SEMICOLON;}
\, { pos_start = pos_end;pos_end++;return COMMA;}
\( { pos_start = pos_end;pos_end++;return LPARENTHESE;}
\) { pos_start = pos_end;pos_end++;return RPARENTHESE;}
\[ { pos_start = pos_end;pos_end++;return LBRACKET;}
\] { pos_start = pos_end;pos_end++;return RBRACKET;}
\{ { pos_start = pos_end;pos_end++;return LBRACE;}
\} { pos_start = pos_end;pos_end++;return RBRACE;}


else { pos_start = pos_end;pos_end += 4;return ELSE;}
if { pos_start = pos_end;pos_end += 2;return IF;}
int { pos_start = pos_end;pos_end += 3;return INT;}
float { pos_start = pos_end;pos_end += 5;return FLOAT;}
return { pos_start = pos_end;pos_end += 6;return RETURN;}
void { pos_start = pos_end;pos_end += 4;return VOID;}
while { pos_start = pos_end;pos_end += 5;return WHILE;}


[a-zA-Z]+ { pos_start = pos_end;pos_end += strlen(yytext);return IDENTIFIER;}
[0-9]+ { pos_start = pos_end;pos_end += strlen(yytext);return INTEGER;}
[0-9]+\.|[0-9]*\.[0-9]+ { pos_start = pos_end;pos_end += strlen(yytext);return FLOATPOINT;}
\[\] { pos_start = pos_end;pos_end += 2;return ARRAY;}

[\n] { pos_start = 1;pos_end = 1;lines++;return EOL;}

\/\*([*]*(([^*/])+([/])*)*)*\*\/ { 
    for (int i = 0; i < strlen(yytext); ++i){
        pos_end++;
        if( yytext[i] == '\n' ){
            lines += 1;pos_end = 1;
        }
    }
    return COMMENT;}

[ \f\n\r\t\v] { pos_end++;pos_start = pos_end;return BLANK;}

. {return ERROR;}

%%

void analyzer(char* input_file, Token_Stream* token_stream){
    lines = 1;
    pos_start = 1;
    pos_end = 1;
    if(!(yyin = fopen(input_file,"r"))){
        printf("[ERR] No input file\n");
        exit(1);
    }
    printf("[START]: Read from: %s\n", input_file);

    int token;
    int index = 0;

    while(token = yylex()){
        switch(token){
            case COMMENT:
                break;
            case BLANK:
                break;
            case EOL:
                break;
            case ERROR:
                printf("[ERR]: unable to analysize %s at %d line, from %d to %d\n", yytext, lines, pos_start, pos_end);
            default :
                append_Token(token_stream, yytext, token, lines, pos_start, pos_end);
        }
    }
    printf("[END]: Analysis completed.\n");
    return;
}


int main(int argc, char const *argv[])
{
    if(argc != 2){
        printf("[Format]: <lex> <input file>\n");
        exit(1);
    }
    Token_Stream token_stream;
    Token_Stream_Init(&token_stream);
    char input_file[256];
    strcpy(input_file, argv[1]);
    analyzer(input_file, &token_stream);
    traversal_Token_Stream(&token_stream);
    return 0;
}
