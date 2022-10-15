lex:lex.yy.c token_stream.c
	gcc lex.yy.c token_stream.c -o lex
lex.yy.c:lexical_analyzer.l
	flex lexical_analyzer.l