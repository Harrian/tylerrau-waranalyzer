
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
%%


log
   : HEAD recordlist { 
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
	: PARAGRAPH TIMESTAMP troopinformation ATTACKING troopinformation LINEBREAK actionresult
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
	: '(' personalsoldiercount SOLDIERS personalspycount SPIES ')'
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $4.str);
		}
	;

personalsoldiercount
	:	OPENINGSOLDIER COMMANUMBER CLOSINGB '(' OPENINGSOLDIER PERCENTAGE CLOSINGB ')'
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $6.str);
		}
	;

personalspycount
	:	OPENINGSPY COMMANUMBER CLOSINGB '(' OPENINGSPY PERCENTAGE CLOSINGB ')'
		{
			strcpy($$.str, $2.str);
			strcat($$.str, ",");
			strcat($$.str, $6.str);
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

closing:
	user makes
	;
makes:
		MAKES OPENINGGOLDTAG COMMANUMBER CLOSINGB PLUNDERCONTRIBUTION
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

