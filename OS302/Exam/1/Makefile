all: exol clean
exol: func1.o main.o
	gcc -std=c99 -g -o exo1 func1.o main.o
funcl.o: func1.c func1.h
	gcc -std=c99 -g -o func1.o -c func1.c -Wall
main.o: exo1.c func1.h
	gcc -std=c99 -g -o main.o -c exo1.c -Wall
clean:
	rm -rf *.o