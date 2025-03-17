#pragma once

#define MACRO1 value
#define MACRO2 32
#define MACRO3(x) malloc(x)

typedef union MyUnion {
    int a;
    char b;
    unsigned long c;
} MyUnion;

MyUnion* lib3_create();

void lib3_func(MyUnion* s);

#ifdef __cplusplus
extern "C" {
#endif

int* c_only_func(int n, int m);

char* c_only_func2(const char* str);

#ifdef __cplusplus
}
#endif
