extern	printf
extern	scanf 


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
	mov rdi, formatin
    mov  rsi, integer1
	xor  rax,rax
	call scanf wrt ..plt
	mov rax, [integer1]
	leave
	ret

