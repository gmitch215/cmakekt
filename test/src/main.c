#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lib.h>
#include <lib2.h>
#include <inner/lib3.h>

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

// lib3
MyUnion* lib3_create() {
    MyUnion* u = (MyUnion*) malloc(sizeof(MyUnion));
    u->a = 1;
    u->b = 'a';
    u->c = 1234567890;
    return u;
}

void lib3_func(MyUnion* u) {
    printf("MyUnion: %d %c %lu\n", u->a, u->b, u->c);
}

int* c_only_func(int n, int m) {
    int* arr = (int*) malloc(n * m * sizeof(int));
    for (int i = 0; i < n * m; i++) {
        arr[i] = i;
    }
    return arr;
}

char* c_only_func2(const char* str) {
    char* copy = (char*) malloc(strlen(str) + 1);
    strcpy(copy, str);
    return copy;
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

    // lib3
    MyUnion* u = lib3_create();
    lib3_func(u);
    free(u);

    int* c_arr = c_only_func(3, 4);
    for (int i = 0; i < 12; i++) {
        printf("%d ", c_arr[i]);
    }
    printf("\n");
    free(c_arr);

    char* str = c_only_func2("Hello, World!");
    printf("c_only_func2: %s\n", str);
    free(str);
    
    return 0;
}