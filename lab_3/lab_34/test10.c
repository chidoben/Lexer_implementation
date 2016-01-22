/*
  Test 10, uninitialized variables in different functions.
*/

#include <stdio.h>


void fun_a(int *x){
    *x = 0;
}

void fun_b(int *x, int y){
    *x = y;
}

void fun_c(int *x){
    // do nothing
}

int fun_d(){
    return 50;
}

int fun_e(int x){
    return x;
}


int main(){
    int a, b, c, d, e, f;

    fun_a(&a);
    fun_b(&b, 400);
    fun_c(&c);
    d = fun_d();
    e = fun_e(e);
    f = fun_e(300);

    printf("%d %d %d %d %d %d\n", a, b, c, d, e, f);
    
    return 0;
}
