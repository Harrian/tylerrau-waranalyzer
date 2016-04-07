

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


\<hr\/\>	 {return HR;}
(January|February|March|April|May|June|July|August|September|October|November|December)[ ]{TS} {strcpy(yylval.str, yytext); return TIMESTAMP;}
\<br\/\> {return LINEBREAK;}
\<p\>  {return PARAGRAPH;}
\<\/p\>		 {return CLOSINGP;}
\<span[ ]class\=\"guild\_tag\"> {return GUILDTAG;}
\<\/span\>	{return CLOSINGSPAN;}
\<b[ ]class\=\"user\"\>	{return USERTAG;}
\<\/b\>	{return CLOSINGB;}
\<b[ ]class\=\"soldier\"\> {return OPENINGSOLDIER;}
\<b[ ]class\=\"spy\"\> {return OPENINGSPY;}
\<b[ ]class\=\"gold\"\> {return OPENINGGOLD;}
gold	{return GOLD;}
gains	{return GAINS;}
plunder[ ]contribution {return PLUNDERCONTRIBUTION;}
soldiers(\,|[ ]and)? {return SOLDIERS;}
spies		{return SPIES;}
attacking	{return ATTACKING;}
assassinate(s)? {strcpy(yylval.str, "1"); return ASSASSINATE;}
attack(s)?	 {strcpy(yylval.str, "0"); return ATTACK;}
steal(s)?	 {strcpy(yylval.str, "2"); return STEAL;}
scout(s)?	 {strcpy(yylval.str, "3"); return SCOUT;}
from		 {return FROM;}
loses		 {return LOSES;}
makes		 {return MAKES;}
knocked		 {return KNOCKED;}
themselves	 {return THEMSELVES;}
out\!		 {return OUT;}
\<span[ ]class\=\"success\"\>successfully {strcpy(yylval.str, "success"); return SUCCESS;}
\<span[ ]class\=\"failure\"\>fails[ ]to {strcpy(yylval.str, "failure"); return FAILURE;}

{DIGIT}({DIGIT}|\,)*	{strcpy(yylval.str, yytext); return COMMANUMBER;}
{DIGIT}{1,3}\%	{strcpy(yylval.str, yytext); return PERCENTAGE;}

\[[ a-zA-Z0-9_\-]{1,30}\] {strcpy(yylval.str,yytext); return GUILDNAME;}
[a-zA-Z0-9_\-]{1,30} {strcpy(yylval.str,yytext); return NAME;}

\(	{return yytext[0];}
\)	{return yytext[0];}
[ \t\n]     /* ignore whitespace */

[\,]		return yytext[0];
\.		return yytext[0];

<<EOF>>   yyterminate();  /* signal end of dialogue */

.        /* return yytext[0]; */

%%

