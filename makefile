
logreader: wartranslatelex.yy.c waranalyzer.tab.c 
	gcc waranalyzer.tab.c waranalyzerlex.yy.c -lfl -ly -o logreader 

translate: translatetosqllex.yy.c translatetosql.tab.c 
	gcc translatetosql.tab.c translatetosqllex.yy.c -lfl -ly -o translate
	
translatetosqllex.yy.c: translatetosql.l
	flex -o translatetosqllex.yy.c -i translatetosql.l

translatetosql.tab.c: translatetosql.y
	bison -dv translatetosql.y
	
wartranslatelex.yy.c: waranalyzer.l
	flex -o wartranslatelex.yy.c -i waranalyzer.l

waranalyzer.tab.c: waranalyzer.y
	bison -dv waranalyzer.y

clean:
	rm -f lex.yy.c 
	rm -f waranalyzer.output
	rm -f waranalyzer.tab.h
	rm -f waranalyzer.tab.c
	rm -f go 

