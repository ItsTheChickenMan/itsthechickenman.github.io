#include <stdio.h>

#include "lexer.h"
#include "parser.h"

int main(int argc, char* argv[]){
	const char* src = argv[1];
	
	FILE *stream = fopen(src, "r");
	
	if(stream == NULL){
		perror("Failed to load source file");
		return -1;
	}	
	
	int e;
	
	
	
	return 0;
}