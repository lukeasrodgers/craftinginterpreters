#include <stdio.h>
#include <stdlib.h>

typedef struct Node { 
  int data;
  struct Node *next;
  struct Node *prev;
} Node;

Node *create_list(int d) {
  Node *n;
  n = malloc(sizeof(Node));
  n->data = d;
  n->next = NULL;
  n->prev = NULL;
  return n;
}

Node *insert_after(Node *node, int d) {
  Node *n;
  n = malloc(sizeof(Node));
  n->data = d;
  n->prev = node;
  n->next = NULL;
  node->next = n;
  return n;
}

void append(Node *list, int d) {
  Node *last = list->next;
  if (!last) {
    insert_after(list, d);
    return;
  } else {
    append(last, d);
  }
}

int list_size(Node *list) {
  int n = 1;
  Node *last = list->next;
  while (last) {
    n++;
    last = last->next;
  }
  return n;
}

// this and other functions should take pointer to pointer of node as list
// if null, represents empty list
// otherwise hard to represent empty list
Node *pop(Node *node) {
  Node *next = node->next;
  if (!next) {
    Node *prev = node->prev;
    prev->next = NULL;
    node->prev = NULL;
    return node;
  } else {
    return pop(next);
  }
}

int main (int argc, char ** argv) {
  printf("hello world\n");

  Node *list = create_list(1);
  printf("list has %d elements\n", list_size(list));
  append(list, 2);
  append(list, 3);

  printf("list has %d elements\n", list_size(list));
  pop(list);
  printf("after popping, list has %d elements\n", list_size(list));
  pop(list);
  printf("after popping, list has %d elements\n", list_size(list));
  pop(list);
  printf("after popping, list has %d elements\n", list_size(list));

  return 0;
}
