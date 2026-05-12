#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>

int main(){
	int n, status;
	pid_t pid = 1, pidw, pidf, pidp = getpid();
	printf("inserire numero: ");
	scanf("%d", &n);
	printf("numero inserito: %d\n", n);
	for (int i = 0; i < n; i++){
		if(getpid() == pidp){
			pid = fork();
			if (pid < 0){
				printf("errore fork\n\n");
			}else if (pid == 0){
				printf("sono il figlio\n. pid = %d, ppid = %d, numero d'ordine = %d", getpid(), getppid(), i);
				pidf = getpid();
			}else{
				//printf("sono il padre\n");
			}
		}
	}
	if(getpid() == pidp){
		printf("sono il padre\n");
	}
}
