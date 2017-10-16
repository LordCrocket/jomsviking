segment .text

; Calculates new gold
; rdi: Address to base
; rsi: Address to towns 
; rdx: Address to gold 

generate_gold:

    enter   0,0 

    movzx rax, byte [rdi]

    mov rcx,7
.loop:

    add al, byte [rsi + rcx]

    dec rcx
    jnz .loop 

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
    enter   0,0

    call next_random
    mov rax,[seed]
    ; mod 8
    and rax, 111b

    mov rcx, rdi
    movzx rdx, byte [rsi]
    add [rax + rcx], dl


    leave
    ret

; Activate jomsviking
;
; rdi: Address to towns
; rsi: Address to joms
;
active_jomsviking:
    enter   0,0

    call next_random
    mov rax,[seed]
    ; mod 8
    and rax, 111b

    mov rcx, towns

    movzx rdx, byte [rax + rcx]
    movzx rsi, byte [joms]

    xor rdi,rdi
    sub rdx, rsi
    cmovl rdx, rdi

    mov [rax + rcx], dl

    leave
    ret
