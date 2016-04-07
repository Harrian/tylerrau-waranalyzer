
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
%token  CLOSINGGUILDTAG
%token	USERTAG
%token	CLOSINGB
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
	: PARAGRAPH TIMESTAMP troopinformation
						{
							strcpy( $$.str, $2.str);
							strcat( $$.str, "," );
							strcat( $$.str, $3.str);
						}
;

troopinformation
	: clan user personaltroopcount {strcpy($$.str, $2.str); printf("%s\n",$2.str); }
	;

clan
	:	GUILDTAG NAME CLOSINGGUILDTAG {}
	;

user
	:	USERTAG NAME CLOSINGB	{ strcpy($$.str, $2.str);}
	;

personaltroopcount
	: '(' ')'
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

