;   4.  Rotation using shifts.
;   
;       Implement the ror instruction using the shift instructions. You may use any
;       bitwise instruction for this task, except for the rotation instructions
;       (ror,rol).

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable



start:
    call    read_hex            ; rotc
    mov     ecx, eax

    call    read_hex            ; x
    call    print_eax_binary
    
rotate:
    shr     eax, 1
    jnc     next
    or      eax, 80000000h      ; set the high bit, if we carried a bit out
next:
    loop    rotate

    call    print_eax_binary

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'