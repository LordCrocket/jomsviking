DEFAULT REL
%include "src/common.inc"
%include "src/random.inc"
%include "src/logic.inc"
%include "src/graphic.inc"
%include "src/data-structs.inc"

extern malloc
extern free

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
        at gs_joms, dw  5
        at gs_j_gold, dw  0
    iend

    work dw 0
    attack db 0



segment .text
    global  asm_main
asm_main:
    enter   16,0 ; Make room for local loop variable
    .choice equ 0
    .rbx equ 8

    mov qword [rsp],2
    mov qword [rsp+8],2


    ; Save rbx
    mov [rsp+.rbx],rbx

    call new_list
    mov rbx,rax

    ; Init player and link to gamestate
    mov rdi, player_state_size
    call malloc wrt ..plt

    mov [rax+p_towns],rbx
    mov [rax+p_gold],word 0
    mov [rax+p_base],word 50
    mov [rax+p_fleet],word 10

    mov [game+gs_player], rax
    
    ; Restore rbx
    mov [rsp+.rbx],rbx

    call init_seed

while:
    cmp qword [rsp], 0
    je endwhile

    call draw_graphics


	call scan
	mov [rsp], rax

    cmp rax, 1
    je .bribe


    cmp rax, 2
    je .transfer

    jmp .end

.bribe:
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
    jmp .end

.transfer:
    mov [rsp+asm_main.rbx],rbx

    mov rax, [game+gs_player]
    mov rdi, [rax+p_towns]
    call size

    cmp rax,0
    je .end

    mov rbx,rax
.loop:
    call print_transfer
	call scan

    cmp rax,1
    jl .loop

    cmp rax,rbx
    jg .loop

    dec rax

    mov rsi,rax

    mov rax, [game+gs_player]

    movzx rdx, word [rax+p_base]
    mov rdi, [rax+p_towns]

    xor rcx,rcx
    mov rbx,10
    sub rdx,10

    cmovl rdx,rcx
    cmovl rbx,rcx

    mov word [rax+p_base],dx


    call get
    add [rax+n_value],rbx

    mov rbx,[rsp+asm_main.rbx]
.end:
   ; Calculate new gold
    mov rax, [game+gs_player]
    lea rdi, [rax+p_base]
    mov rsi, [rax+p_towns]
    lea rdx, [rax+p_gold]
    call generate_gold


    ; Find new workers

    mov rdi, [game+gs_player]
    call find_workers

    ; Save info to display
    inc rax
    mov [work], al

    ; Activate jomsviking
    mov rax, [game+gs_player]
    lea rdi, [rax+p_towns]
    lea rsi, [game+gs_joms]
    lea rdx, [game+gs_j_gold]
    call active_jomsviking

    ; Save info to display
    inc rax
    mov [attack], al

    jmp while
endwhile:

    mov     rax, 0            ; return back to C
    leave                     
    ret
