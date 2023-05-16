/**************************************
******* A NE PAS MODIFIER *******
***************************************/
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include "func2.h"
int main(int argc, char *argv[])
{
    char fl[] = "fl", f2[] = "f2";
    init_pipes(fl, f2);
    int c;
    pid_t p;
    switch (p = fork())
    {
    case -1:
        perror("fork fail");
    case 0:
    {
        printf("Début comptage\n");
        writeNextint(fl, 1);
        do
        {
            c = readNextint(f2) - '0';
            printf("Parent\t: %d \n", c);
            c++;
            writeNextint(fl, c);
        } while (c < 9);
        exit(0);
    }
    break;
    default:
    {
        while (1)
        {
            c = readNextint(fl) - '0';
            printf("Fils\t: %d \n", c);
            c++;
            if (c == 10)
                break;
            writeNextint(f2, c);
            kill(p, 9);
        }
        printf("Fin comptage\n");
        exit(0);
    }
    break;
    }
    return 0;
}
