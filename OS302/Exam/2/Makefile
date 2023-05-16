all: exo2 clean
exo2: func2.o main.o
	gcc -o exo2 func2.o main.o
func2.o: func2.c
	gcc -o func2.o -c func2.c -g -Wall
rnain.o: exo2.c func2.h
	gcc -o main.o -c exo2.c -g -Wall
clean:
	rm -rf *.o