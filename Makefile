EXEC 		= QuickFit
SOURCES 	= $(wildcard ./src/*.asm)
OBJECTS		= $(SOURCES:.asm=.o)

$(EXEC): $(OBJECTS)
	#ld -m elf_i386 $(OBJECTS) -o $(EXEC)
	gcc -m32 $(OBJECTS) -o $(EXEC)

%.o : %.asm
	nasm -f elf -g -F stabs $< -o $@

clean:
	rm -f $(EXEC) $(OBJECTS)
