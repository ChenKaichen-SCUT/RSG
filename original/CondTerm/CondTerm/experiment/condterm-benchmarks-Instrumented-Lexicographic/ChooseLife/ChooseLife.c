#include <stdio.h>

int main() {
    int choose;
    int life;
    int death;
    int temp;
    choose = 2;
    life = 13;
    death = 17;

    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");

    while (life < death) {
        printf("#\n");
        temp = death;
        death = life + 1;
        life = temp;
        
        if (choose < life || choose < death) {
            printf("L1\n");
            life = choose;
        }
    }
    
    return 0;
}
