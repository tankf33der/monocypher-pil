all:
	gcc -fPIC -Wall -Wextra -c glue_argon.c -o glue_argon.o
	gcc -shared -Wl,-soname,glue_argon.so -o glue_argon.so glue_argon.o -lc
	rm glue_argon.o
