DEFAULT REL
%include "src/common.inc"
%include "src/random.inc"
%include "src/logic.inc"
%include "src/graphic.inc"
%include "src/data-structs.inc"

extern malloc

segment .bss
    struc   game_state
        gs_player:  resq 1
        gs_joms:    resw 1
        gs_j_gold:  resw 1
        alignb 8
    endstruc

    struc   player_state
        p_towns:   resq 1
        p_gold:  resw 1
        p_base:  resw 1
        p_fleet: resw 1
        alignb 8
    endstruc

segment .data
    game: istruc game_state
        at gs_player, dq  0
        at gs_joms, dw  50
        at gs_j_gold, dw  0
    iend

    work dw 0
    attack db 0



segment .text
    global  asm_main
asm_main:
    enter   16,0 ; Make room for local loop variable

    mov qword [rsp],2

    ; Init towns
    push rbx

    xor rax,rax
    mov rbx, 13
.loop:
    mov rdi,rax
    xor rsi, rsi
    call push
    dec rbx
    jnz .loop

    mov rbx,rax

    ; Init player and link to gamestate
    mov rdi, player_state_size
    call malloc wrt ..plt

    mov [rax+p_towns],rbx
    mov [rax+p_gold],word 0
    mov [rax+p_base],word 50
    mov [rax+p_fleet],word 10

    mov [game+gs_player], rax

    pop rbx

    call init_seed

while:
    cmp qword [rsp], 0
    je endwhile

    call draw_graphics


	call scan
	mov [rsp], rax

    cmp rax, 1
    jne .end

    call print_bribe
	call scan


    mov rsi,[game+gs_player]
    movzx rdx,word [rsi+p_gold]
    mov rdi,rdx

    xor rcx,rcx
    sub rdx, rax

    cmovl rax, rdi
    cmovl rdx, rcx

    mov [rsi+p_gold],dx
    add [game+gs_j_gold], ax

.end:
   ; Calculate new gold
    mov rax, [game+gs_player]
    lea rdi, [rax+p_base]
    mov rsi, [rax+p_towns]
    lea rdx, [rax+p_gold]
    call generate_gold


    ; Find new workers

    mov rax, [game+gs_player]
    mov rdi, [rax+p_towns]
    lea rsi, [rax+p_fleet]
    call find_workers

    ; Save info to display
    inc rax
    mov [work], al

    ; Activate jomsviking
    mov rax, [game+gs_player]
    mov rdi, [rax+p_towns]
    lea rsi, [game+gs_joms]
    call active_jomsviking

    ; Save info to display
    inc rax
    mov [attack], al

    jmp while
endwhile:

    mov     rax, 0            ; return back to C
    leave                     
    ret
