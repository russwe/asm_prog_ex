;   7.  Bonus: Convert Gray into binary.
;       
;       In the "Gray" Exercise at the code reading section, we have learned that in
;       order to find the Gray code of a number x, we should shift the number x by
;       1, and xor the result with the original x value.
;   
;       In high level pseudo code: 
;         (x >> 1) XOR x.
;   
;       In assembly code:
;         mov   ecx,eax
;         shr   ecx,1
;         xor   eax,ecx
;   
;   
;       Find a way to reconstruct x from the expression (x >> 1) XOR x.
;       Write a program that takes a gray code g as input, and returns the
;       corresponding x such that g = (x >> 1) XOR x.
;   
;       NOTE that You may need to use a loop in your program.
;
;       (x >> 1) XOR x
;       x3x2x1x0
;         x3x2x1
;       g3 = x3         x3 = g3
;       g2 = x2 XOR x3  x2 = g2 XOR x3
;       g1 = x1 XOR x2  x1 = g1 XOR x2
;       g0 = x0 XOR x1  x0 = g0 XOR x1
;
;       g3g2g1g0
;         g3g2g1
;
;       Base: g_(32) = b_(32)
;       Loop: (g_(n) XOR g_(n+1)) << 1, where n = (32,0)

;       0000 ^^ 0000 = 0000
;       0001 ^^ 0000 = 0001
;       0010 ^^ 0001 = 0011
;       0011 ^^ 0001 = 0010
;       0100 ^^ 0010 = 0110
;       0101 ^^ 0010 = 0111
;       0110 ^^ 0011 = 0101
;       0111 ^^ 0011 = 0100
;       1000 ^^ 0100 = 1100
;       1001 ^^ 0100 = 1101
;       1010 ^^ 0101 = 1111
;       1011 ^^ 0101 = 1110
;       1100 ^^ 0110 = 1010
;       1101 ^^ 0110 = 1011
;       1110 ^^ 0111 = 1001
;       1111 ^^ 0111 = 1000

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
    call    read_hex    ; g
    call    print_eax_binary

    xor     ebx, ebx

    mov     edx, eax    ; edx = g_n
    rol     eax, 1      ; eax = g_(n-1)
    rcl     ebx, 1

    mov     ecx, 31d    ; we are starting the loop one binary digit in
grayToBin:
    mov     esi, edx    ; g_n
    xor     esi, eax    ; esi = g_n XOR g_(n-1)
    mov     edx, esi

    rol     esi, 1
    rcl     ebx, 1

    rol     eax, 1
    loop    grayToBin

output:
    mov     eax, ebx
    call    print_eax_binary

roundTrip:
    mov     ecx,eax
    shr     ecx,1
    xor     eax,ecx
    call    print_eax_binary

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'