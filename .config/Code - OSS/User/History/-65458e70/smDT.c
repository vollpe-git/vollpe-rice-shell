#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(void) {
    FILE *file;
    int status;
    pid_t pid = fork();
    if (pid == 0){
        // figlio
        file = fopen("./padrefiglio.txt", "w");
        fprintf(file, "%d", getpid());
        fclose(file);
    } else {
        // padre
        pid = wait(&status);
        if (WIFEXITED(status)){
            //printf("uscito con codice %d\n", WEXITSTATUS(status));
            file = fopen("./padrefiglio.txt", "r");
            int tmp;
            fscanf(file, "%d", &tmp);
            printf("%d\n", tmp);
            fclose(file);
        } else if (WIFSIGNALED(status))
            printf("uscita anomala con status %d\n", WTERMSIG(status));
    }

}
