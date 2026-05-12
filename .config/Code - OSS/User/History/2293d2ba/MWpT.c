#include <stdio.h>

int main(){
    __fd = open("/dev/null",1);
    printf("%s", (-1 < __fd) ? "true":"false");
}