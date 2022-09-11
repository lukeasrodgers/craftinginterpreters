#include <stdio.h>
#include "rle.c"
#include <assert.h>

int main (int argc, char** argv) {
    printf("hello world\n");

    char* str = "aabbcccc";
    Encoded encoded = rle_encode(str, 8);
    print_rle_decoded(encoded);
    print_rle(encoded);

    assert(val_at_index(encoded, 0) == 97);
    assert(val_at_index(encoded, 1) == 97);
    assert(val_at_index(encoded, 2) == 98);
    assert(val_at_index(encoded, 4) == 99);
    assert(val_at_index(encoded, 10) == -1);

    printf("val at index 1 = %d\n", val_at_index(encoded, 1));
    printf("val at index 4 = %d\n", val_at_index(encoded, 4));
    printf("val at index 5 = %d\n", val_at_index(encoded, 5));
    printf("val at index 20 = %d\n", val_at_index(encoded, 20));

    add_to_rle(&encoded, 'c');
    print_rle_decoded(encoded);
    print_rle(encoded);
    add_to_rle(&encoded, 'd');
    print_rle_decoded(encoded);
    print_rle(encoded);

    int *n = malloc(sizeof(int) * 10);
    n[0] = 1;
    n[1] = 2;


    add_to_rle(&encoded, 'd');
    add_to_rle(&encoded, 'e');
    add_to_rle(&encoded, 'f');
    add_to_rle(&encoded, 'g');
    add_to_rle(&encoded, 'd');
    add_to_rle(&encoded, 'e');
    add_to_rle(&encoded, 'f');
    add_to_rle(&encoded, 'g');
    add_to_rle(&encoded, 'd');
    add_to_rle(&encoded, 'e');
    add_to_rle(&encoded, 'f');
    add_to_rle(&encoded, 'g');
    add_to_rle(&encoded, 'd');
    add_to_rle(&encoded, 'e');
    add_to_rle(&encoded, 'f');
    add_to_rle(&encoded, 'g');
    print_rle_decoded(encoded);
    print_rle(encoded);

    printf("nums: %d %d\n", n[0], n[1]);

    return 0;
}