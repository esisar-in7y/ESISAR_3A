#include <stdio.h>
#include <stdlib.h>
#include "listeTableau.h"

#define TAILLEMAX 1000

int main()
{
    /* d�claration du tableau contenant la liste */
    element maListe[TAILLEMAX];

    creerListeVide(maListe);

    /* ... */

    afficherListe(maListe);

    return 0;
}
