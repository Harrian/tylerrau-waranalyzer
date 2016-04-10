

%{

typedef struct
{
 int ival;
 char str[100];
}tstruct ;

#define YYSTYPE  tstruct

#include "translatetosql.tab.h"

%}

DIGIT  [0-9]
LETTER [a-zA-Z0-9_-]
TS [0-9]{2},[ ][0-9]{1,2}:[0-9]{2}:[0-9]{2}[ ][ap]\.m\.
%%

(January|February|March|April|May|June|July|August|September|October|November|December)[ ][0-9]{2}\,[ ] {return USELESSTIMESTAMP;}
[0-9]{1,2}\:[0-9]{2}:[0-9]{2}	{strcpy(yylval.str,yytext);return USEFULTIMESTAMP;}
[ ][ap]\.m\.		{return AMPM;}
\,[0-9]{3} {strcpy(yylval.str,&yytext[1]);return TRIPLENUM;}
[0-9]{1,3}\%	{strcpy(yylval.str,yytext); return PERCENTAGE;}
[0-9]{1,3}	{strcpy(yylval.str,yytext);return NUM;}
success {return SUCCESS;}
failure	{return FAILURE;}
SKO		{return SKO;}
NOKO	{return NOKO;}
KO		{return KO;}
[a-zA-Z0-9_\-]{1,30} {strcpy(yylval.str,yytext); return NAME;}
<<EOF>>   yyterminate();  /* signal end of dialogue */
[\n]	 return NEWLINE;
.        return yytext[0];

%%

