/*********************************************************************
 * OS302 - shm - Exercice 2                                          *
 * Utilisation des segments de memoire partagee                      *
 *********************************************************************/
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "segment_memoire.h"

int main() {
  
  int pid;      // le PID du processus
  char *mem;    // pointeur vers le segment memoire
  int shmid;    // l'identificateur du segment memoire
  char *nom = (char *) malloc(15*sizeof(char));
  nom = "exo2.c";

  // a completer : creation du segment de memoire partagee
  // ...
  int memory=cree_segment(100, nom, 0);
  // creation du processus fils
  pid = fork();
  if (pid == -1) {
    perror("impossible de creer un processu fils!");
    exit(-1);
  }
  else if (pid == 0) {
    sleep(2);
    // je suis le fils!
    // a completer : s'attacher au segment et affichage de son contenu
    // ...
    afficher_info_segment(memory);
  }
  else {
    // je suis le pere!
    // a completer : attachement et ecriture sur le segment de memoire partagee
    // a completer : attendre la fin du fils + detacher le segment et le detruire
    // ...
    mem = (char *) shmat(memory, NULL, 0);
    strcpy(mem, "Bonjour\n");
    printf("J'ai ecrit: %s\n", mem);
    waitpid(pid, NULL, 0);
    detruire_segment(memory);
  }
  return 0;
}