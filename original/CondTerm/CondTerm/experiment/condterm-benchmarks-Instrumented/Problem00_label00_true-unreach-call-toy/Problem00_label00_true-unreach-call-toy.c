#include <stdio.h>
#include <stdlib.h>

int _nondet_int() {
    return rand();
}

int a7 = 0;


int main() {
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

    // default outpu
    int outpu = -1, inpu;

    a7 = 0;

    // main i/o-loop
    while(outpu != 0)
    {
        printf("a7:%d,outpu:%d,inpu:%d\n", a7, outpu, inpu);
        // read inpu
        inpu = _nondet_int();
        if ((inpu != 1) && (inpu != 2) && (inpu != 3) && (inpu != 4) && (inpu != 5) && (inpu != 6)) {return -2;}

        // operate eca engine
        a7++;
        if (a7 == 10) { outpu = 0; } else { outpu = inpu - 1; }
        // outpu = calculate_outpu(inpu);
    }
}
