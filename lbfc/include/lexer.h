#include <stdio.h>
#include <stdlib.h>

enum Token {
	// special characters
	tok_eof=		-1,
	
	// commands
	tok_pointeradd= -2,
	tok_pointermin= -3,
	tok_memadd= 	-4,
	tok_memmin=		-5,
	tok_memout=		-6,
	tok_memin=		-7,
	tok_loopstart=	-8,
	tok_loopend=	-9,
};

int gettok(FILE *stream){
	char e = ' ';
	
	//Skip whitespace
	while(isspace(e)){
		e = fgetc(stream);
	}
	
	//Token parser
	switch(e){
		case '+':
			return tok_memadd;
		case '-':
			return tok_memmin;
		case '>':
			return tok_pointeradd;
		case '<':
			return tok_pointermin;
		case '.':
			return tok_memout;
		case ',':
			return tok_memin;
		case '[':
			return tok_loopstart;
		case ']':
			return tok_loopend;
		case '#':
			do
				fgetc(stream);
			while(e != EOF && e != '\n' && e != '\r');
			
			if(e != EOF) return gettok(stream);
			
			break;
		case EOF:
			return tok_eof;
		default:
			return (int) e;
	}
}