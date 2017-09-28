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
    fmt2 db "%d", 0
    
    base_string db "Base: ",0
    town_string db "Town ",0
    colon db ": ",0
    
    base db 0
    fleet db 0
    towns times 8 db 0


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


    mov rdi,base_string
    call print


    mov rdi,fmt
	movzx rsi, byte [base]
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

	call scan
	mov r13, rax

    inc byte [base]
    ;inc byte [towns]

    jmp while
endwhile:

    mov     rax, 0            ; return back to C
    leave                     
    ret


;
;   Print towns
;

print_town:
    enter   0,0 
    push rdi

    mov rdi,town_string
    call print

    pop rcx
    mov rdi,fmt2
    mov rsi, rcx
    inc rsi
    push rcx
    call print

    mov rdi,colon
    call print
    
    pop rcx
    mov rdi,fmt
    mov rax, towns
    mov rsi, [rax + rcx]
    call print
    leave
    ret
