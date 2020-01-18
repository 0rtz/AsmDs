SHELL = /bin/sh

MKDIR_P = mkdir -p
DIR_LIB = lib
DIR_OUT = out

.PHONY: directories

all : directories test

directories : ${DIR_LIB} ${DIR_OUT}

${DIR_LIB} :
	${MKDIR_P} ${DIR_LIB}

${DIR_OUT} :
	${MKDIR_P} ${DIR_OUT}

${DIR_OUT}/%.o : %.asm
	yasm -f elf64 -g dwarf2 -o $@ $<

${DIR_LIB}/lib%.so : ${DIR_OUT}/%.o
	gcc -shared -o $@ $<

test : ${DIR_LIB}/libdynamicArray.so ${DIR_LIB}/liblinkedList.so ${DIR_LIB}/libqueueLinkedList.so ${DIR_LIB}/libqueueArray.so ${DIR_LIB}/libhashTable.so test.c
	gcc -g -L${DIR_LIB}/ -Wl,-rpath=${DIR_LIB}/ -Wall -o test test.c -ldynamicArray -llinkedList -lqueueLinkedList -lqueueArray -lhashTable

clean :
	rm -f test ; rm -r -f ${DIR_LIB} ${DIR_OUT}
