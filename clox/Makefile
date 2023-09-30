main: main.c memory.c chunk.c debug.c value.c rle.c vm.c compiler.c scanner.c object.c table.c
	gcc -Wall -o a.out main.c memory.c chunk.c debug.c value.c rle.c vm.c compiler.c scanner.c object.c table.c

.PHONY: test
test:
	./a.out print.lox
	./a.out globals.lox
	./a.out if.lox
	./a.out for.lox
	./a.out breakfast.lox
	./a.out fundec.lox
	./a.out outer.lox
	./a.out global-closures.lox
	./a.out global-closures.lox
	./a.out brioche.lox
	./a.out pair.lox
	./a.out bound.lox
	./a.out initializer.lox
	./a.out inherit.lox
