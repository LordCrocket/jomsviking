all: jomsviking
jomsviking: jomsviking.o driver.o
	gcc -o jomsviking driver.o jomsviking.o	
jomsviking.o:
	nasm -f elf64 jomsviking.asm
driver.o:
	gcc -c driver.c
clean:
	rm -f *.o jomsviking
