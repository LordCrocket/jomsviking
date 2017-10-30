DEFAULT REL
%include "src/common.inc"
%include "src/random.inc"
%include "src/logic.inc"
%include "src/graphic.inc"

segment .data

    struc   game_state
        gs_joms:    resb 1
        gs_j_gold:  resb 1
        gs_player:  resq 1
    endstruc

    struc   player_state
        p_gold:  resw 1
        p_base:  resb 1
        p_fleet: resb 1
    endstruc

    game: istruc game_state
        at gs_joms, db  50
        at gs_j_gold, db  50
        at gs_player, dq  0
    iend

    player: istruc player_state
        at p_gold, dw  0
        at p_base, db  50
        at p_fleet, db  10
    iend

    work dw 0
    attack db 0

    towns times 8 db 0

    multiplier dq 25214903917
    increment db 11

segment .text
    global  asm_main
asm_main:
    enter   16,0 ; Make room for local loop variable

    mov qword [rsp],2

    ; Link player to gamestate
    lea rax ,[player]
    mov [game+gs_player], rax


    call init_seed

while:
    cmp qword [rsp], 0
    je endwhile

    call draw_graphics

	call scan
	mov [rsp], rax


   ; Calculate new gold
    mov rax, [game+gs_player]
    lea rdi, [rax+p_base]
    mov rsi, towns
    lea rdx, [rax+p_gold]
    call generate_gold


    ; Find new workers

    mov rax, [game+gs_player]
    mov rdi, towns
    lea rsi, [rax+p_fleet]
    call find_workers

    ; Save info to display
    inc rax
    mov [work], al

    ; Activate jomsviking
    mov rdi, towns
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
