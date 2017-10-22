OUTPUT := output
SRC := src

all: jomsviking
jomsviking: jomsviking.o driver.o
	(cd $(OUTPUT) ; gcc -o jomsviking driver.o jomsviking.o)
jomsviking.o:
	@ mkdir -p $(OUTPUT)
	nasm -f elf64   $(SRC)/jomsviking.asm -o $(OUTPUT)/jomsviking.o
driver.o:
	gcc -c $(SRC)/driver.c -o $(OUTPUT)/driver.o
clean:
	rm output/*
