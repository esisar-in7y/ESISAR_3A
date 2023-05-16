#ifndef DM
//Il DM : dimensions matrice carrée
#define DM 2
//Il NF : nombre de processus fils
int **mat1, **mat2, **matsomme;
#else
extern int **mat1, **mat2, **matsomme;
#endif
#define NF DM*DM
//Il mat1 et mat2 sont les 2 matrices lues au clavier. La matrice matsomrne
//correspond à la somme des 2 matrices mat1 et mat2.
/*** fonctions à compléter ***/
void lecture_matrice(void);
//lecture des éléments des 2 matrices mat1 et mat2
int somme(int vl, int v2);
//Il somme de 2 entiers
void creation(pid_t tab[NF] );
//Il création de 4 processus fils dont chacun calculera une somme élémentaire
/*** fonctions fournies ***/
int **allocate_matrice(int i, int j);
//Il allocation de la zone mémoire pour la création des matrices
void affiche_matrice(int **mat, int i, int j);
//Il affichage des éléments d'une matrice
void free_matrice(int** mat, int i);
//Il libération de la zone mémoire occupée par une matrice
void free_matrices(void);
//libération de la zone mémoire occupée par les 3 matrices de cet exercices
