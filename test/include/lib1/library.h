#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int globalVariable = 31;

void doSomething() {
    char* str = (char*) malloc(5);
    if (str == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    free(str);

    printf("Doing something...\n");
    printf("Global variable: %d\n", globalVariable);
}

const char* getLibrary2String() {
    return "Hello from getString!";
}

typedef struct OtherStruct {
    int* array;
    int size;
} OtherStruct;

OtherStruct* createOtherStruct(int size) {
    OtherStruct* s = (OtherStruct*) malloc(sizeof(OtherStruct));
    if (s == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    s->array = (int*) malloc(size * sizeof(int));
    if (s->array == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        free(s);
        exit(1);
    }
    s->size = size;
    return s;
}

void freeMyStruct(OtherStruct* s) {
    if (s != NULL) {
        free(s->array);
        free(s);
    }
}