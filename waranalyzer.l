

%{

typedef struct
{
 int ival;
 char str[100];
}tstruct ;

#define YYSTYPE  tstruct

#include "waranalyzer.tab.h"

%}

DIGIT  [0-9]
LETTER [a-zA-Z0-9_-]
TS [0-9]{2},[ ][0-9]{1,2}:[0-9]{2}:[0-9]{2}[ ][ap]\.m\.
%%

\<!DOCTYPE[ ]HTML[ ]PUBLIC[ ]\"-\/\/W3C\/\/DTD[ ]HTML[ ]4\.01\/\/EN\"\>(.|[\n])*\<hr\/\> {return HEAD;}		  
(January|February|March|April|May|June|July|August|September|October|November|December)[ ]{TS} {strcpy(yylval.str, yytext); return TIMESTAMP;}
\<br\> {return LINEBREAK;}
\<p\>  {return PARAGRAPH;}
\<span[ ]class\=\"guild\_tag\">\[ {return GUILDTAG;}
\]\<\/span\>	{return CLOSINGGUILDTAG;}
\<b[ ]class\=\"user\"\>	{return USERTAG;}
\<\/b\>	{return CLOSINGB;}
[a-zA-Z0-9_-]{1,30} {strcpy(yylval.str,yytext); return NAME;}
(	return yytext[0];
)	return yytext[0];

[ \t\n]     /* ignore whitespace */

<<EOF>>   yyterminate();  /* signal end of dialogue */

.        /* return yytext[0]; */

%%

