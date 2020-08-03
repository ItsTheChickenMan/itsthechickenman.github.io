# A simple makefile for compiling lbfc

NAME=lbfc
CC=gcc
INSTALL_DIR=./bin/
INCLUDE_DIR=./include/
LIB_DIR=./lib/
SRC_DIR=./src/
OBJ_DIR=$(SRC_DIR)obj/

CFLAGS=-I$(INCLUDE_DIR) -L$(LIB_DIR)
LIBS=

_DEPS=lexer.h
DEPS=$(patsubst %,$(INCLUDE_DIR)/%,$(_DEPS))

_OBJ=lbfc.o
OBJ=$(patsubst %,$(OBJ_DIR)%,$(_OBJ))


$(OBJ_DIR)%.o: $(SRC_DIR)%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)
	
.PHONY: all clean uninstall

all: $(OBJ)
	$(CC) $^ -o $(INSTALL_DIR)$(NAME) $(CFLAGS) $(LIBS)
	
clean:
	rm -f $(OBJ_DIR)*.o
	
uninstall: clean
	rm -f $(INSTALL_DIR)*.*