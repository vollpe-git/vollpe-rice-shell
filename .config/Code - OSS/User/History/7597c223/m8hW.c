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
				printf("sono il figlio. pid = %d, ppid = %d, numero d'ordine = %d\n", getpid(), getppid(), i+1);
				pidf = getpid();
				pidw = pid;
				printf("figlio; pid = %d<------\n", pid);
				sleep(3*(i+1));
				printf("figlio %d: termino con exit status %d\n", i+1, 3*(i+1));
				exit(3*(i+1));
			}else{
				printf("sono il padre, pid = %d, pid figlio = %d\n", getpid(), pidf);
			}
		}
	}
	
	if(getpid() == pidp){
		printf("padre; pid = %d<------\n", pid);
		pidw = waitpid(pidw, &status, 0);
		printf("sono il padre alla fine ed ho aspettato il figlio con pid = %d\t", pidf);
		if (pidw > 0 && WIFEXITED(status)){
			printf("figlio terminato con exit status = %d", WEXITSTATUS(status));
		}
	}
}
