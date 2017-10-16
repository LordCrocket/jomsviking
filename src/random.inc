segment .bss
	seed 	resq 1
segment .text

;
;   Generate a seed
;

init_seed:
    enter 0,0
    rdtsc
    shl rdx,32
    or rax,rdx
    mov [seed], rax
    leave
    ret

;
;   Linear congruential generator
;
;   Example usage: random number between 0-7
;   call next_random
;   mov rax,[seed]
;   shl rax, 61
;   shr rax, 61

next_random:
    enter 0,0

    ; Multiply last number with multiplier
    ; The top half of the result can be ignored as
    ; we will perform a modolus with a number that is
    ; a power of 2. The left most bits will then just be
    ; ignored
    mov rcx, [seed]
    mov rax, [multiplier]
    mul rcx


    ; Add the increment
    add rax, [increment]
    ; Trucate the 12 bits which is equivalent to
    ; rax % 2^48
    shl rax, 16
    shr rax, 16

    ; Use only bits 47..16
    shr rax, 16

    ; Store the new value
    mov [seed],rax

    leave
    ret

