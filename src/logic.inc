segment .text

; Calculates new gold
; rdi: Address to base
; rsi: Address to towns 
; rdx: Address to gold 

generate_gold:

    enter   0,0 

    movzx rax, word [rdi]
.loop:
    cmp rsi,0
    je .end

    add rax,[rsi+n_value]
    mov rsi,[rsi+n_next]
    jmp .loop

.end:
    add [rdx], ax
    leave
    ret

; 
; Find new workers
;
; rdi: Address to player
;
find_workers:
    enter   16,0
    .player equ 0

    mov [rsp+.player],rdi


    ;lea rdi, [rax+p_towns]
    ;lea rsi, [rdi+p_fleet]
    ;xor rsi,rsi
    ; Add value
    movzx rsi, word [rdi+p_fleet]
    mov rdi, [rdi+p_towns]

    call push

    mov rdi,[rsp+.player]
    mov [rdi+p_towns],rax

    mov rax,0

    leave
    ret

; Activate jomsviking
;
; rdi: Address to towns
; rsi: Address to joms
;
active_jomsviking:
    enter   32,0

    .towns equ 0
    .joms equ 8
    .number equ 16

    mov [rsp+.towns],rdi
    mov [rsp+.joms],rsi

    mov rdi,[rdi]

    call size

    mov rdi,rax
    call next_random
    mov [rsp+.number],rax


    ; Get town
    mov rdi,[rsp+.towns]
    mov rdi,[rdi]
    mov rsi, rax

    call get

    mov rsi,[rsp+.joms]
    mov rdx, [rax+n_value]
    movzx rsi, word [rsi]


    sub rdx, rsi
    cmp rdx,0
    jle .remove

    mov [rax], dl
    jmp .end

.remove:
    mov rdi,[rsp+.towns]
    mov rsi,[rsp+.number]
    call remove

.end:
    mov rax,[rsp+.number]

    leave
    ret
