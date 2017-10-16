DEFAULT REL
%include "src/common.inc"
%include "src/random.inc"
%include "src/logic.inc"


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

    jomsviking_string db "Jomsviking strength: ",0
    attack_string db "Jomsvikings last victim: Town ",0

    work_string db "Added workers to: Town ",0
    
    gold_string db "Gold: ",0
    base_string db "Base: ",0
    fleet_string db "Fleet: ",0
    town_string db "Town ",0
    colon db ": ",0
    
    joms db 50
    joms_gold db 50
    attack db 0

    work dw 0
    gold dw 0
    base db 50
    fleet db 10
    towns times 8 db 0

    multiplier dq 25214903917
    increment db 11

segment .text
    global  asm_main
asm_main:
    enter   0,0 
    push r12

    call init_seed

while:
    cmp r12,0
    je endwhile

    mov rdi,clear
    call print

    mov rdi,main_menu
    call print


    mov rdi,jomsviking_string
    call print

    mov rdi,fmt
	movzx rsi, byte [joms]
    call print

    mov rdi,attack_string
    call print

    mov rdi,fmt
	movzx rsi, byte [attack]
    call print

    mov rdi,line
    call print

    mov rdi,work_string
    call print

    mov rdi,fmt
	movzx rsi, byte [work]
    call print



    mov rdi,line
    call print

    mov rdi,gold_string
    call print

    mov rdi,fmt
	movzx rsi, word [gold]
    call print


    mov rdi,base_string
    call print

    mov rdi,fmt
	movzx rsi, byte [base]
    call print


    mov rdi,fleet_string
    call print


    mov rdi,fmt
	movzx rsi, byte [fleet]
    call print


    mov rcx,0

list_towns:

    cmp rcx,8
    push rcx
    je end_towns

    mov rax, towns
    movzx rax, byte [rax + rcx]

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
	mov r12, rax


   ; Calculate new gold
    mov rdi, base
    mov rsi, towns
    mov rdx, gold
    call generate_gold


    ; Find new workers

    mov rdi, towns
    mov rsi, fleet
    call find_workers

    ; Save info to display
    inc rax
    mov [work], al

    ; Activate jomsviking
    mov rdi, towns
    mov rsi, joms
    call active_jomsviking

    ; Save info to display
    inc rax
    mov [attack], al

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
    mov rcx,rdi

    mov rdi,town_format
    mov rsi, rcx
    inc rsi
    mov rax, towns
    movzx rdx, byte [rax + rcx]
    call print


    pop r13
    pop r12

    leave
    ret
