DEFAULT REL
%include "src/common.inc"
%include "src/random.inc"
%include "src/logic.inc"
%include "src/graphic.inc"


segment .data

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
    enter   16,0 ; Make room for local loop variable

    mov qword [rsp],2

    call init_seed

while:
    cmp qword [rsp], 0
    je endwhile

    call draw_graphics

	call scan
	mov [rsp], rax


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
