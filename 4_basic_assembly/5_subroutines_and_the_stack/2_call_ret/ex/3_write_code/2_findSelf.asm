;   2.  Find yourself
;       
;       Write a program that finds the current value of EIP and prints it to the
;       console.
;   
;       HINT: Use CALL.

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable
start:
    call    find_me
    call    print_eax

    push    0
    call    [ExitProcess]

find_me:
    pop     eax
    push    eax
    ret

include 'training.inc'