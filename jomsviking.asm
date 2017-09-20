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
    fmt db "%d",10, 0
    
    base_string db "Base:",0
    
    base db 0;
    fleet db 0;
    town1 db 0;
    town2 db 0;
    town3 db 0;
    town4 db 0;


segment .text
    global  asm_main
asm_main:
    enter   0,0 

while:
    cmp r13,0
    je endwhile

    mov rdi,clear
    call print

    mov rdi,main_menu
    call print


    mov rax,[base]
    cmp rax,0
    jg print_block
    jmp next
print_block:
        mov rdi,base_string
        call print
        mov rdi,fmt
	    mov rsi,[base]
        call print
next:

	call scan
	mov r13, rax

    inc byte [base]

    jmp while
endwhile:

    mov     rax, 0            ; return back to C
    leave                     
    ret
