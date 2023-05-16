#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <wait.h>
#include "func1.h"
/** ne doit pas être modifié **/
int main(void)
{
	int i;
	pid_t mes_fils[NF];
	int status;
	mat1 = allocate_matrice(DM, DM);
	mat2 = allocate_matrice(DM, DM);
	matsomme = allocate_matrice(DM, DM);
	printf("%p\n",mat1);
//	affiche_matrice(mat1,DM,DM);
	lecture_matrice();
	creation(mes_fils);
	for (i = 0; i < NF; i++)
	{
		waitpid(mes_fils[i], &status, 0);
		printf("status fils %d %04x\n", (i + 1), status);
		matsomme[i / DM][i % DM] = status >> 8;
	}
	affiche_matrice(matsomme, DM, DM);
	return 0;
}