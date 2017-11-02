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
    enter   0,0

    call next_random
    mov rax,[seed]
    ; mod 8
    and rax, 111b
    xor rcx,rcx 
    ; Find town
.loop:
    cmp rax,rcx 
    je .end
  
    inc rcx 
    mov rdi,[rdi+n_next]
      
    jmp .loop
.end: 
    ; Add value
    movzx rdx, word [rsi]
    add [rdi+n_value], dl

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
    xor rcx,rcx
.loop:
    cmp rax,rcx 
    je .end
  
    inc rcx 
    mov rdi,[rdi+n_next]
      
    jmp .loop
.end:

    mov rdx, [rdi+n_value] 
    movzx rsi, word [rsi]

    xor rcx,rcx
    sub rdx, rsi
    cmovl rdx, rcx

    mov [rdi+n_value], dl

    leave
    ret
