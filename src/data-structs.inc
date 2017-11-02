struc node
    n_value: resq 1
    n_next:  resq 1
endstruc

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
