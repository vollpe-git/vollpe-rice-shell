#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* flag = "unipi{REDACTED}";

void init(){
    setvbuf(stdin, 0, 2, 0);
    setvbuf(stdout, 0, 2, 0);
}

int main(){
    init();
    char name[32];
    int age;
    puts("Give me your name:");
    scanf("%31s", &name);
    puts("Give me your age:");
    scanf("%d", &age);
    printf("%d", sizeof(int));
    if(age > 18){
        puts("You are lying!");
        exit(0);
    }
    uint double_age = age * 2;
    if(double_age > 36){
        puts("We don't want kids here");
        puts(flag);
    }
    return 0;
}