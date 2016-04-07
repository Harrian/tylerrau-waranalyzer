
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
%%


log
   : recordlist { 
                  printf("Read Head\n");
                }
   ;

recordlist
    :  /* empty */
    |  recordlist record  
                   {
                     printf("%s\n",$2.str);  
                   }
    ;

record
	: PARAGRAPH TIMESTAMP troopinformation ATTACKING troopinformation LINEBREAK actionresult '.' closingknockoutlayer CLOSINGP HR
						{
							strcpy( $$.str, $2.str);
							strcat( $$.str, "," );
							strcat( $$.str, $3.str);
							strcat( $$.str, ",");
							strcat( $$.str, $5.str);
							strcat( $$.str, ",");
							strcat( $$.str, $7.str);
						}
;

troopinformation
	: clan user personaltroopcount {
		strcpy($$.str, $2.str);
		strcat($$.str, ",");
		strcat($$.str, $3.str);}
	;

clan
	: GUILDTAG GUILDNAME CLOSINGSPAN {}
	;

user
	:	USERTAG NAME CLOSINGB	{strcpy($$.str, $2.str);}
	;

personaltroopcount
	: '(' personalsoldiercount personalspycount ')'
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $4.str);
		}
	;

personalsoldiercount
	:	OPENINGSOLDIER COMMANUMBER CLOSINGB '(' OPENINGSOLDIER PERCENTAGE CLOSINGB ')' SOLDIERS
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $6.str);
		}
	|   OPENINGSOLDIER COMMANUMBER CLOSINGB SOLDIERS
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",0");
		}
	;

personalspycount
	:	OPENINGSPY COMMANUMBER CLOSINGB '(' OPENINGSPY PERCENTAGE CLOSINGB ')' SPIES
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $6.str);
		}
	|	OPENINGSPY COMMANUMBER CLOSINGB SPIES
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",0");
		}
	;

actionresult
	:	user SUCCESS action CLOSINGSPAN user	{strcpy($$.str, $2.str); 
												 strcat($$.str, ",");
												 strcat($$.str, $3.str);
												 }
	|	user FAILURE action	CLOSINGSPAN user	{strcpy($$.str, $2.str);
												 strcat($$.str, ",");
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
	closing
	| closing knockout
	;
closing:
	user makes ',' loses '.' user loses '.'
	| user gains ',' loses '.' user loses '.'
	| user loses '.' user loses '.'
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
	NAME KNOCKED THEMSELVES OUT
	| NAME KNOCKED NAME OUT
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

