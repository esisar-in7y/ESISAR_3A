#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <wait.h>
#define DM 2
#include "func1.h"
void lecture_matrice(void)
{ /* Lit 2 matrices d'éléments entiers et de dimensions 2x2 - à compléter */
	printf("Read matrice\n");
//	affiche_matrice(mat1,DM,DM);
	printf("%p\n",mat1);
	int val;
	for(int x=0;x<DM;x++){
		for(int y=0;y<DM;y++){
			printf("Entrez la valeur mat1[%d][%d]:",x,y);
			scanf("%d",&mat1[x][y]);
		}
	}
	for(int x=0;x<DM;x++){
		for(int y=0;y<DM;y++){
			printf("Entrez la valeur mat2[%d][%d]:",x,y);
			scanf("%d",&mat2[x][y]);
		}
	}
}
int somme(int v1, int v2)
{ /* renvoie la somme des 2 entiers tra ns mis en argwnents - à completer */
	return v1+v2;
}
void creation(pid_t tab[NF])
{ /*
 Permet de créer 4 processus fils dont les PID sont stockés dans le tableau
 tab. Chaque processus fils effectue une somme élémentaire :
 Le fils 1 effectue la somme de mat1[0][O] et mat2[O][O]
 Le fils 2 effectue la somme de mat1[O][1] et mat2[0][1]
 Le fils 3 effectue la somme de mat1[l][O] et mat2[1][O]
 Le fils 4 effectue la somme de mat1[l][l] et mat2[1][1]
 Chaque processus fils transmets le résultat de son calcul au processus père au
 moyen de la fonction exit().
 */
	printf("Création processus \n");
	for(int x=0;x<DM;x++){
		for(int y=0;y<DM;y++){
			if((tab[x*DM+y]=fork())==0){
				exit(somme(mat1[x][y],mat2[x][y]));
			}
		}
	}
}
int **allocate_matrice(int i, int j)
{
	int k;
	int **mat;
	mat = malloc(i * sizeof(*mat));
	for (k = 0; k < i; k++)
	{
		mat[k] = malloc(j * sizeof(*mat[k]));
	}
	return mat;
}
void affiche_matrice(int **mat, int i, int j)
{
	int k, l;
	for (k = 0; k < i; k++)
	{
		for (l = 0; l < j; l++)
		{
			printf("%d \t", mat[k][l]);
		}
		printf("\n");
	}
}
void free_matrice(int **mat, int i)
{
	int k;
	for (k = 0; k < i; k++)
	{
		free(mat[k]);
	}
	free(mat);
}
void free_matrices()
{
	free_matrice(mat1, DM);
	free_matrice(mat2, DM);
	free_matrice(matsomme, DM);
}
