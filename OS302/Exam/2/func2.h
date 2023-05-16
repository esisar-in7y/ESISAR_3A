#ifndef DNI
#define DNI
// Création de deux tubes nommés à partir des deux chemins en paramètres
// Attention à verifier que le tube n'existe pas déja (pensez à "unlink)
void init_pipes(char *f1, char *f2 ) ;
// lit et retourne un seul caractère à partir du tube en paramètre
char readNextint (char *f);
// écrit l'entier passé en paramètre dans le tube
// Attention: pensez à convertir l'entier de type "int" en sont équivalent
//"char"
void writeNextint(char *f, int n);
#endif