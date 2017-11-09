struc node
    n_value: resq 1
    n_next:  resq 1
endstruc


new_list:
    xor rax,rax
    ret

; Adds new node to list
; rdi: Address to list
; rsi: Value to add
; 
; rax: New list address
push:
    .list equ 0
    .value equ 8

    enter   16,0
    ; Save local variables
    mov [rsp+.list],rdi
    mov [rsp+.value],rsi

    ; Make room for new node
    mov rdi,node_size
    call malloc wrt ..plt
    
    ; Set list pointer as next in new node
    mov rdi, [rsp+.list]
    mov [rax+n_next], rdi

    ; Set value in new node
    mov rsi, [rsp+.value]
    mov [rax+n_value], rsi

    ; New list address is in rax

    leave
    ret

; remove(index)
; rdi: List
; rsi: Index
;
remove:
    enter 0,0

.loop:
    ; Get node
    mov rcx,[rdi]

    dec rsi
    cmp rsi,0
    jl .end

    lea rdi,[rcx+n_next]
    jmp .loop
.end:
    ; Set to point to next
    mov rdx,[rcx+n_next]
    mov [rdi],rdx
    ; Remove current
    mov rdi,rcx
    call free wrt ..plt

    leave
    ret



; get(index)
; rdi: List
; rsi: Index
;
; rax: Pointer to value at index
get:
    enter 0,0

    xor rcx,rcx
.loop:
    cmp rax,rcx
    je .end

    mov rdi,[rdi+n_next]
    inc rcx

    jmp .loop
.end:

    lea rax,[rdi+n_value]

    leave
    ret

; Size
; rdi: List
;
; rax: Size of list
size:
    enter 0,0

    xor rax,rax

.loop:
    cmp rdi, 0
    je .end
    mov rdi,[rdi+n_next]
    inc rax
    jmp .loop
.end:

    leave
    ret
