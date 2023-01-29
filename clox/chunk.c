#include <stdlib.h>

#include "chunk.h"
#include "memory.h"
#include "rle.h"
#include "vm.h"

void initChunk(Chunk* chunk) {
    chunk->count = 0;
    chunk->capacity = 0;
    chunk->code = NULL;
    // chunk->lines = NULL;
    Encoded encoded;
    encoded.len = 0;
    encoded.capacity = 0;
    chunk->encoded = encoded;
    initValueArray(&chunk->constants);
}

void freeChunk(Chunk* chunk) {
    FREE_ARRAY(uint8_t, chunk->code, chunk->capacity);
    // FREE_ARRAY(int, chunk->lines, chunk->capacity);
    // free rle
    initChunk(chunk);
}

void writeChunk(Chunk* chunk, uint8_t byte, int line) {
    if (chunk->capacity < chunk->count + 1) {
        int oldCapacity = chunk->capacity;
        chunk->capacity = GROW_CAPACITY(oldCapacity);
        chunk->code = GROW_ARRAY(uint8_t, chunk->code, oldCapacity, chunk->capacity);
        // chunk->lines = GROW_ARRAY(int, chunk->lines, oldCapacity, chunk->capacity);
    }
    add_to_rle(&(chunk->encoded), (uint8_t) line);

    chunk->code[chunk->count] = byte;
    // chunk->lines[chunk->count] = line;
    chunk->count++;
}

int getLine(Chunk* chunk, int offset) {
    return val_at_index(chunk->encoded, offset);
}

int addConstant(Chunk* chunk, Value value) {
    push(value);
    writeValueArray(&chunk->constants, value);
    pop();
    return chunk->constants.count - 1;
}