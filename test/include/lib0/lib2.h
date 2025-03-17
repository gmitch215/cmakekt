#pragma once

typedef struct MyStruct {
    int a;
    char b;
    unsigned long c;
} MyStruct;

MyStruct* lib2_create();

void lib2_func(MyStruct* s);

int** lib2_create_array(int n, int m);

void lib2_free_array(int** arr, int n);