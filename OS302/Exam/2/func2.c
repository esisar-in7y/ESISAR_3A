#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <fcntl.h>
void init_pipes(char *f1, char *f2) {
    if(access(f1, F_OK) == 0)
        unlink(f1);
    printf("%d\n",mkfifo(f1, 0666));
    if(access(f2, F_OK) == 0)
        unlink(f2);
    printf("%d\n",mkfifo(f2, 0666));
}
char readNextint(char *f) {
    // printf("readNextint\n");
	char buffer;
	int fd=open(f,O_RDONLY);
	read(fd,&buffer,sizeof(buffer));
    // printf("readNextint: %c\n", buffer);
	close(fd);
	return buffer;
}
void writeNextint(char *f, int n){
	char buffer=n+'0';
    // printf("writeNextint %d=>%c\n", n, buffer);
	int fd=open(f,O_WRONLY);
	write(fd,&buffer,sizeof(buffer));
	close(fd);
}