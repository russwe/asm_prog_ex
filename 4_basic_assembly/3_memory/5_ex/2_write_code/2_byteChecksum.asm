;   2.  Byte checksum.
;   
;       Create a program that calculates the sum of all its bytes modulo 0x100.
;       (The program will actually sum itself).
;   
;       HINT: You can use the ars_poetic exercise (See Read Code section) as a basis
;       for your program.

format PE console
entry start

begin:

include 'win32a.inc'

section '.text' code readable executable

start:
    mov     ebx, begin
    mov     ecx, endl

    xor     eax, eax
csum:
    mov     edx, [ecx]
    add     eax, edx
    and     eax, 0ffh
    
    dec     ecx
    cmp     ecx, ebx
    jae     csum

    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'

endl: