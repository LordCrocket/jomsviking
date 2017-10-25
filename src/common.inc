extern	printf
extern	scanf 
extern	getchar


segment .data
    integer1 times 8 db 0 ;
    formatin db "%d", 0

segment .text


print:
    enter   0,0 
	xor	rax, rax
	call	printf wrt ..plt
	leave
	ret
scan:
	enter 0,0
.scanf:
	mov rdi, formatin
    mov  rsi, integer1
	xor  rax,rax
	call scanf wrt ..plt
    cmp rax,0
    jg .return

    ;
    ; Flush input
    ;
.flush_stdin:
    call getchar wrt ..plt
    cmp rax, 10 ;
    jnz .flush_stdin
    jmp .scanf

.return:
	mov rax, [integer1]
	leave
	ret

