#include <stdio.h>

int main(void) {
    FILE *file;
    int status;
    pid_t pid = fork();
    if (pid == 0){
        // figlio
        printf("figlio:\n");
        file = fopen("./padrefiglio.txt", "w");
        fprintf(file, "%d", getpid())
        fclose(file);
    }
    // padre
    printf("padre:\n");
    pid = wait(&status);
    if (WIFEXITED(&status)){
        printf("uscito con codice %d", WEXITSTATUS(status));
        file = fopen("./padrefiglio.txt", "r");
        int tmp;
        fscanf(file, "%d", &tmp);
        printf("%d", tmp);
        fclose(file);
    } else if (WIFSIGNALED(&status))
        printf("uscita anomala con status %d", WTERMSIG(status));

}
