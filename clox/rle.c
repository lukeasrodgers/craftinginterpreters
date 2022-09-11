#include "rle.h"
#include "memory.h"

Encoded rle_encode(char* str, int str_len) {
    Run* runs = malloc(sizeof(Run) * str_len); // size should actually be ≤ str_len
    Encoded encoded;
    encoded.capacity = str_len;
    int c;
    int len = 0, last_val = -1;
    for (int i = 0; i < str_len; i++) {
        c = (int) str[i];
        if (c == '\0') break;
        int val = c;

        if (val != last_val) {
            if (encoded.capacity == len) {
                int oldCapacity = encoded.capacity;
                encoded.capacity = GROW_CAPACITY(oldCapacity);
                encoded.runs = GROW_ARRAY(Run, encoded.runs, oldCapacity, encoded.capacity);
            }
            Run r;
            r.val = val;
            r.count = 1;
            runs[len] = r;
            len += 1;
            last_val = val;
        } else {
            runs[len - 1].count += 1;
        }
    }

    encoded.runs = runs;
    encoded.len = len;
    return encoded;
}


void add_to_rle(Encoded *encoded, int c) {
    int len = encoded->len;
    if (len == 0) {
        int oldCapacity = encoded->capacity;
        encoded->capacity = GROW_CAPACITY(oldCapacity);
        encoded->runs = malloc(sizeof(Run) * encoded->capacity);
    }
    if (c == encoded->runs[len - 1].val && len > 0) {
        encoded->runs[encoded->len - 1].count++;
    } else if (c == '\0') {
        return;
    } else {

        if (encoded->capacity == len) {
            int oldCapacity = encoded->capacity;
            encoded->capacity = GROW_CAPACITY(oldCapacity);
            encoded->runs = GROW_ARRAY(Run, encoded->runs, oldCapacity, encoded->capacity);
        }

        Run r;
        r.val = c;
        r.count = 1;
        encoded->runs[len] = r;
        encoded->len += 1;
    }
}

void print_rle_decoded(Encoded encoded) {
    printf("Decoded: \n");
    for (int i = 0; i < encoded.len; i++) {
        Run r = encoded.runs[i];
        for (int j = 0; j < r.count; j++) {
            printf("%d", r.val);
        }
    }
    printf("\n");
}

void print_rle(Encoded encoded) {
    printf("Decoded: \n");
    for (int i = 0; i < encoded.len; i++) {
        Run r = encoded.runs[i];
        printf("%dx%d ", r.count, r.val);
    }
    printf("\n");
}

int val_at_index(Encoded encoded, int index) {
    if (index < 0) return -1;
    for (int i = 0, j = 0; i < encoded.len; i++) {
        Run r = encoded.runs[i];
        if (index < j + r.count) {
            return r.val;
        } else {
            j += r.count;
        }
    }
    return -1;
}