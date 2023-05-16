#ifndef DNI
#define DNI
void init_pipes(char *fl, char *f2 );
char readNextint (char *f);
//Il écrit l'entier passé en paramètre dans le tube
// Attention: pensez à convertir l'entier de type "int" en sont équivalent "char"
void writeNextint(char *f, int n);
#endif