all:
	gcc -fPIC -Wall -Wextra -c glue_argon2.c -o glue_argon2.o
	gcc -shared -Wl,-soname,glue_argon2.so -o glue_argon2.so glue_argon2.o -lc -lmonocypher
	rm glue_argon2.o
