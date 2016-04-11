
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct 
{
 int ival;
 char str[500];
}tstruct ; 

#define YYSTYPE  tstruct 

%}


%token	CLANTAG
%token	HEAD
%token  NUM
%token  TIMESTAMP
%token	FAILURE	
%token	NAME
%token	LINEBREAK
%token	PARAGRAPH
%token 	GUILDTAG
%token  CLOSINGSPAN
%token	USERTAG
%token	CLOSINGB
%token	OPENINGSOLDIER
%token	OPENINGSPY
%token	COMMANUMBER
%token	PERCENTAGE
%token	SOLDIERS
%token	SPIES
%token  ATTACKING
%token  GUILDNAME
%token	SUCCESS
%token	ASSASSINATE
%token	ATTACK
%token  STEAL
%token  SCOUT
%token	FROM
%token  CLOSING
%token  MAKES 
%token  OPENINGGOLD 
%token  PLUNDERCONTRIBUTION
%token	LOSES
%token  CLOSINGP
%token  HR
%token  GAINS
%token  GOLD
%token  KNOCKED
%token  THEMSELVES
%token  OUT
%token	TOTALPLUNDER
%token 	CLOSINGBODY
%token  AND
%%


log: header recordlist { 
                }
   ;

header:
	HEAD PARAGRAPH TOTALPLUNDER combinedname gold ',' combinedname gold CLOSINGP HR
;

combinedname
	:	NAME
	| combinedname NAME
	;
	
recordlist
    :  /* empty */
    |  recordlist record  
                   {
                     printf("%s",$2.str);  
                   }
    ;

record
	: PARAGRAPH TIMESTAMP clan troopinformation ATTACKING clan troopinformation LINEBREAK actionresult '.' closingknockoutlayer CLOSINGP endingtag
						{
							strcpy( $$.str, $2.str);
							strcat( $$.str, "\t" );
							(strcmp($3.str,$6.str)>0)?(strcat($$.str,"0")):(strcat($$.str,"1"));
							strcat( $$.str, "\t" );
							strcat( $$.str, $4.str);
							strcat( $$.str, "\t");
							strcat( $$.str, $7.str);
							strcat( $$.str, "\t");
							strcat( $$.str, $9.str);
							strcat( $$.str, "\t");
							strcat( $$.str, $11.str);
							strcat( $$.str, $13.str);
						}
;

endingtag:
	HR	{strcpy( $$.str, "\n");}
	| CLOSINGBODY {strcpy( $$.str, "");}
	;
troopinformation
	: user personaltroopcount {
		strcpy($$.str, $1.str);
		strcat($$.str, "\t");
		strcat($$.str, $2.str);}
	;

clan
	: GUILDTAG GUILDNAME CLOSINGSPAN {strcpy($$.str, $2.str);}
	;

user
	:	USERTAG NAME CLOSINGB	{strcpy($$.str, $2.str);}
	;

personaltroopcount
	: '(' personalsoldiercount personalspycount ')'
		{
			strcpy($$.str, $2.str);
			strcat($$.str, "\t");
			strcat($$.str, $3.str);
		}
	;

personalsoldiercount
	:	OPENINGSOLDIER COMMANUMBER CLOSINGB '(' OPENINGSOLDIER PERCENTAGE CLOSINGB ')' SOLDIERS
		{
			strcpy($$.str, $2.str);
			strcat($$.str, "\t");
			strcat($$.str, $6.str);
		}
	|   OPENINGSOLDIER COMMANUMBER CLOSINGB SOLDIERS
		{
			strcpy($$.str, $2.str);
			strcat($$.str, "\t0%");
		}
	;

personalspycount
	:	OPENINGSPY COMMANUMBER CLOSINGB '(' OPENINGSPY PERCENTAGE CLOSINGB ')' SPIES
		{
			strcpy($$.str, $2.str);
			strcat($$.str, "\t");
			strcat($$.str, $6.str);
		}
	|	OPENINGSPY COMMANUMBER CLOSINGB SPIES
		{
			strcpy($$.str, $2.str);
			strcat($$.str, "\t0%");
		}
	;

actionresult
	:	user SUCCESS action CLOSINGSPAN user	{strcpy($$.str, $2.str); 
												 strcat($$.str, "\t");
												 strcat($$.str, $3.str);
												 }
	|	user FAILURE action	CLOSINGSPAN user	{strcpy($$.str, $2.str);
												 strcat($$.str, "\t");
												 strcat($$.str, $3.str);
												}
	;

action
	:	ASSASSINATE	{strcpy($$.str, $1.str);}
	|	SCOUT		{strcpy($$.str, $1.str);}
	|	ATTACK		{strcpy($$.str, $1.str);}
	|	STEAL		{strcpy($$.str, $1.str);}
	|	STEAL FROM  {strcpy($$.str, $1.str);}
	;

closingknockoutlayer:
	closing	{strcpy($$.str, "NOKO");}
	| closing knockout	{strcpy($$.str, $2.str);}
	;
closing:
	user makes ',' loses '.' user loses '.'
	| user gains ',' loses '.' user loses '.'
	| user loses '.' user loses '.'
	| user loses '.'
	| user makes ',' loses '.'
	;
makes:
		MAKES gold PLUNDERCONTRIBUTION
	;
gains:
		GAINS gold GOLD
	;
loses:
		LOSES personalspycount
	|	LOSES personalsoldiercount
	|	LOSES personalsoldiercount personalspycount
	|	LOSES gold GOLD
	|	LOSES gold GOLD ',' personalsoldiercount
	|   LOSES gold GOLD ',' personalspycount
	;
gold:
	OPENINGGOLD COMMANUMBER CLOSINGB
;

knockout:
	NAME KNOCKED THEMSELVES OUT	{strcpy($$.str, "SKO");}
	| NAME KNOCKED NAME OUT		{strcpy($$.str, "KO");}
	| NAME KNOCKED THEMSELVES AND NAME OUT {strcpy($$.str, "SKOKO");}
	;
%%



main ()
{
  yyparse ();
}

yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
}

