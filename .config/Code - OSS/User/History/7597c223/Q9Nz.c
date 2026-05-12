#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>

int main(){
	int n, status;
	pid_t pid = 1, pidw, pidf;
	printf("inserire numero: ");
	scanf("%d", &n);
	printf("numero inserito: %d\n", n);
	for (int i = 0; i < n; i++){
		pid = fork();
		if (pid < 0)
			printf("errore fork");
		else if (pid == 0)
			printf("sono il figlio");
		else
			printf("sono il padre");
	}
}
