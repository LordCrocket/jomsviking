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
; rdi: Address to towns
; rsi: Address to fleet
;
find_workers:
    enter   36,0
    .towns equ 0
    .fleet equ 8
    .number equ 16

    mov [rsp+.towns],rdi
    mov [rsp+.fleet],rsi

    mov rdi,8
    call next_random

    mov [rsp+.number],rax

    ; Get town
    mov rdi,[rsp+.towns]
    mov rsi, rax

    call get

    mov rsi,[rsp+.fleet]

    ; Add value
    movzx rdx, word [rsi]
    add [rax], dl

    mov rax,[rsp+.number]

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

    mov rdi,8
    call next_random
    mov [rsp+.number],rax


    ; Get town
    mov rdi,[rsp+.towns]
    mov rsi, rax

    call get

    mov rsi,[rsp+.joms]
    mov rdx, [rax]
    movzx rsi, word [rsi]

    xor rcx,rcx
    sub rdx, rsi
    cmovl rdx, rcx

    mov [rax], dl

    mov rax,[rsp+.number]

    leave
    ret
