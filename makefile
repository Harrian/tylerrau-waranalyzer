
go: lex.yy.c waranalyzer.tab.c 
	gcc waranalyzer.tab.c lex.yy.c -lfl -ly -o go 

lex.yy.c: waranalyzer.l
	flex -i waranalyzer.l

waranalyzer.tab.c: waranalyzer.y
	bison -dv waranalyzer.y

clean:
	rm -f lex.yy.c 
	rm -f waranalyzer.output
	rm -f waranalyzer.tab.h
	rm -f waranalyzer.tab.c
	rm -f go 

