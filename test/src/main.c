#include <stdio.h>
#include <stdlib.h>
#include <lib.h>

void myLibraryFunction() {
    printf("Hello from myLibraryFunction!\n");
}

int myLibraryVariable = 42;

long getLong() {
    return 1234567890;
}

char* getString() {
    return "Hello from getString!";
}

int main() {
    myLibraryFunction();
    printf("myLibraryVariable: %d\n", myLibraryVariable);
    printf("getLong: %ld\n", getLong());
    printf("getString: %s\n", getString());
    
    return 0;
}