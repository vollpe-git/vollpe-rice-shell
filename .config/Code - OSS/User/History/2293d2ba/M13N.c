#include <stdio.h>
#include <sys/stat.h>

int main(){
    int __fd = open("/dev/null",1);
    printf("%s", (-1 < __fd) ? "true":"false");
}