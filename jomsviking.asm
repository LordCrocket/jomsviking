DEFAULT REL
%include "common.inc"


segment .data
    clear   db    `\e[1;1H\e[2J`,0
main_menu:
	db	"========== JOMSVIKING!  ============",10
	db	" 1. Bribe the jomsvikings ", 10
	db	" 2. Transfer troops", 10
	db	" 0. Quit", 10
	db	"====================================",10,0
    fmt db "%u",10, 0
    town_format db "Town %u: %u",10,0

    line: db	"====================================",10,0
    choice_string: db	"Choice: ",0
    
    base_string db "Base: ",0
    fleet_string db "Fleet: ",0
    town_string db "Town ",0
    colon db ": ",0
    
    base db 0
    fleet db 0
    towns times 8 db 0

    multiplier dq 25214903917
    increment db 11

section .bss
	seed 	resq 1
segment .text
    global  asm_main
asm_main:
    enter   0,0 

    call init_seed

while:
    cmp r13,0
    je endwhile

    mov rdi,clear
    call print

    mov rdi,main_menu
    call print


    mov rdi,base_string
    call print

    mov rdi,fmt
	movzx rsi, byte [base]
    call print


    mov rdi,fleet_string
    call print

    call next_random

    mov rax,[seed]
    shl rax, 61
    shr rax, 61

    mov rdi,fmt
	;movzx rsi, byte [fleet]
    mov rsi,rax
    call print


    mov rcx,0

list_towns:

    cmp rcx,8
    push rcx
    je end_towns

    mov rax,[towns]
    cmp rax,0
    jg print_block
    jmp next
print_block:
    pop rcx
    mov rdi, rcx
    push rcx
    call print_town 
next:
    pop rcx
    inc rcx
    jmp list_towns

end_towns:

    mov rdi,line
    call print

    mov rdi,choice_string
    call print

	call scan
	mov r13, rax

    inc byte [base]
    inc byte [towns]
    inc byte [towns]

    jmp while
endwhile:

    mov     rax, 0            ; return back to C
    leave                     
    ret

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

;
;   Print towns
;

print_town:
    enter   0,0 
    mov rcx,rdi

    mov rdi,town_format
    mov rsi, rcx
    inc rsi
    mov rax, towns
    movzx rdx, byte [rax + rcx]
    call print

    leave
    ret
