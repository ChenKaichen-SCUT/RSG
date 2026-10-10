/* Arbitrary signed integer parameters; no restriction to one seed state. */
void test(int p, int x) {
    while ((p == 0 && 0 <= x && x <= 2) ||
           (p == 1 && 3 <= x && x <= 4)) {
        x = 4 - x;
        p = 1 - p;
    }
}
