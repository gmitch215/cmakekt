#include <stdio.h>
#include <stdlib.h>
#include <lib.h>
#include <lib2.h>

// lib1

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

// lib2
MyStruct* lib2_create() {
    MyStruct* s = (MyStruct*) malloc(sizeof(MyStruct));
    s->a = 1;
    s->b = 'a';
    s->c = 1234567890;
    return s;
}

void lib2_func(MyStruct* s) {
    printf("MyStruct: %d %c %ld\n", s->a, s->b, s->c);
}

int** lib2_create_array(int n, int m) {
    int** arr = (int**) malloc(n * sizeof(int*));
    for (int i = 0; i < n; i++) {
        arr[i] = (int*) malloc(m * sizeof(int));
        for (int j = 0; j < m; j++) {
            arr[i][j] = i * m + j;
        }
    }
    return arr;
}

void lib2_free_array(int** arr, int n) {
    for (int i = 0; i < n; i++) {
        free(arr[i]);
    }
    free(arr);
}

int main() {
    // lib1
    myLibraryFunction();
    printf("myLibraryVariable: %d\n", myLibraryVariable);
    printf("getLong: %ld\n", getLong());
    printf("getString: %s\n", getString());

    // lib2
    MyStruct* s = lib2_create();
    lib2_func(s);
    free(s);

    int** arr = lib2_create_array(3, 4);
    lib2_free_array(arr, 3);
    
    return 0;
}