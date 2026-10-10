#include <stdio.h>

int main() {
    int choose;
    int life;
    int death;
    int temp;
    choose = 2;
    life = 13;
    death = 17;

    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

    while (life < death) {
        printf("life:%d,death:%d,choose:%d\n", life, death, choose);
        temp = death;
        death = life + 1;
        life = temp;
        
        if (choose < life || choose < death) {
            life = choose;
        }
    }
    
    return 0;
}
