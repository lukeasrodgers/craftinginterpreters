#ifndef rle_h
#define rle_h

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int val;
    int count;
} Run;

typedef struct {
    Run* runs;
    int len;
    int capacity;
} Encoded;

Encoded rle_encode(char* str, int len);
void print_rle_decoded(Encoded encoded);
void print_rle(Encoded encoded);
int val_at_index(Encoded encoded, int index);
void add_to_rle(Encoded *encoded, int c);

#endif
