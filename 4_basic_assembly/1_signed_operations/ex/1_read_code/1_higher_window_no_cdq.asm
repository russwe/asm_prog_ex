format PE console
entry start

include 'win32a.inc' 

section '.text' code readable executable

start:

    call    read_hex        ; eax = a
    cmp     eax,0
    jns     positive        ; a is not signed -> positive
    mov     eax,1           ; no:
    call    print_eax       ; output 1
    jmp     end_if
positive:
    mov     eax,0
    call    print_eax       ; output 0
end_if:

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'