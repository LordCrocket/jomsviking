segment .data
    clear   db    `\e[1;1H\e[2J`,0

main_menu:
	db	" 1. Bribe the jomsvikings ", 10
	db	" 2. Transfer troops", 10
	db	" 0. Quit", 10,0

    fmt db "%u",10, 0
    town_format db "Town %u: %u",10,0

	title: db	"========== JOMSVIKING! =============",10,0
    line: db	"====================================",10,0
    choice_string: db	"Choice: ",0

    jomsviking_string db "Jomsviking strength: ",0
    attack_string db "Jomsviking last victim: Town ",0

    work_string db "Added workers to: Town ",0

    gold_string db "Gold: ",0
    base_string db "Base: ",0
    fleet_string db "Fleet: ",0
    town_string db "Town ",0
    colon db ": ",0

segment .text

draw_graphics:
    enter   0,0

    call print_clear

    mov rdi,title
    call print

    mov rdi,jomsviking_string
    call print

    mov rdi,fmt
	movzx rsi, word [game+gs_joms]
    call print

    mov rdi,attack_string
    call print

    mov rdi,fmt
	movzx rsi, byte [attack]
    call print

    mov rdi,line
    call print

    mov rdi,work_string
    call print

    mov rdi,fmt
	movzx rsi, byte [work]
    call print



    mov rdi,line
    call print

    mov rdi,gold_string
    call print

    mov rdi,fmt
    mov rsi, [game+gs_player]
	movzx rsi, word [rsi+p_gold]
    call print


    mov rdi,base_string
    call print

    mov rdi,fmt
    mov rsi, [game+gs_player]
	movzx rsi, word [rsi+p_base]
    call print


    mov rdi,fleet_string
    call print


    mov rdi,fmt
    mov rsi, [game+gs_player]
	movzx rsi, word [rsi+p_fleet]
    call print

    mov rdi, [game+gs_player]
    call print_towns

    mov rdi,line
    call print

    call print_menu

    mov rdi,line
    call print

    mov rdi,choice_string
    call print
    leave
    ret
print_menu:
    enter   0,0

    mov rdi,main_menu
    call print

    leave
    ret
print_clear:
    enter   0,0

    mov rdi,clear
    call print

    leave
    ret

;
;   Print towns
;

print_towns:
    enter   16,0
    .rbx equ 0
    .number    equ 8

    ; Save rbx
    mov [rsp+.rbx], rbx

    mov rbx, [rdi+p_towns]
    mov qword [rsp+.number], 1

.list_towns:
    cmp rbx,0

    je .end_towns

    mov rax, [rbx+n_value]

    cmp rax,0
    je .next
    ; Print

    mov rdi,town_format
    mov rsi, [rsp+.number]

    mov rdx, rax 
    call print

.next:
    inc qword [rsp+8]

    mov rbx, [rbx+n_next]

    jmp .list_towns

.end_towns:
    mov rbx,[rsp+.rbx]
    leave
    ret
