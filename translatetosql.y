
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
%token  TRIPLENUM
%token  NOKO
%token  SKO
%token  KO
%token NEWLINE
%token USELESSTIMESTAMP
%token USEFULTIMESTAMP
%token AMPM
%%


log: linelist
   ;

linelist:
	| linelist line
	;

line:
	time userdata userdata '\t' result '\t' type '\t' kodata NEWLINE
	{printf("('%s',%s,%s,'%s','%s','%s'),\n",$1.str,$2.str,$3.str,$5.str,$7.str,$9.str);}
	| time userdata userdata '\t' result '\t' type '\t' kodata
	{printf("('%s',%s,%s,'%s','%s','%s')",$1.str,$2.str,$3.str,$5.str,$7.str,$9.str);}
;

time:
	USELESSTIMESTAMP USEFULTIMESTAMP AMPM {strcpy($$.str,$2.str);}
;
type:
	NUM {strcpy($$.str,$1.str);}
	;
result:
	SUCCESS {strcpy($$.str,"1");}
	| FAILURE {strcpy($$.str,"0");}
	;

kodata:
	NOKO {strcpy($$.str,"0");}
	|SKO {strcpy($$.str,"1");}
	|KO  {strcpy($$.str,"2");}
	;
userdata:
	'\t' NAME '\t' commanumber '\t' PERCENTAGE '\t' commanumber '\t' PERCENTAGE {
                     strcpy( $$.str, "'");
                     strcat( $$.str, $2.str);
					 strcat( $$.str, "','");
                     strcat( $$.str, $4.str);
					 strcat( $$.str, "','");
                     strcat( $$.str, $6.str);
					 strcat( $$.str, "','");	
                     strcat( $$.str, $8.str);
                     strcat( $$.str, "','");
                     strcat( $$.str, $10.str);
                     strcat( $$.str, "'");
	}
;
commanumber:
	leadingnum listoftriples {
                     strcpy( $$.str, $1.str);
                     strcat( $$.str, $2.str); 
					 }
;
leadingnum:
	NUM {strcpy( $$.str, $1.str);} 
;
listoftriples:
	{strcpy($$.str,"");}
	| listoftriples TRIPLENUM {
                     strcpy( $$.str, $1.str);
                     strcat( $$.str, $2.str); 
					 }
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

