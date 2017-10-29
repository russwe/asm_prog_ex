;   1.  Dword picture
;       
;       Given a dword x, we create a corresponding ASCII picture.
;       We use the following procedure:
;   
;       0.  We look at the binary representation of x, and divide it to pairs of
;           bits. We then order the pairs of bits in a square of size 4 X 4.
;   
;           Example: 
;             For the dword 0xdeadbeef, we get:
;             0xdeadbeef = 11011110101011011011111011101111
;             0xdeadbeef = 11 01 11 10 10 10 11 01 10 11 11 10 11 10 11 11
;   
;             Ordered in a square:
;             
;             11 01 11 10
;             10 10 11 01
;             10 11 11 10
;             11 10 11 11 
;   
;       1.  Next we convert every pair of bits into one ASCII symbol, as follows:
;   
;           00 -> *
;           01 -> :
;           10 -> #
;           11 -> @
;   
;           Example:
;             For the dword 0xdeadbeef, we get the following interesting picture:
;   
;             @:@#
;             ##@:
;             #@@#
;             @#@@
;   
;       Write a program that takes a dword x as input, and prints the corresponding
;       picture representation as output.
;   
;       HINT: Organize your program using functions:
;   
;         - Create a function that transforms a number into the ASCII code of the
;           corresponding symbol. {0 -> * , 1 -> : , 2 -> # , 3 -> @}
;   
;         - Create a function that takes as arguments an address of a buffer and a
;           number x. This function will fill the buffer with the resulting ascii
;           picture. Make sure to leave room for the newline character sequences,
;           and for the null terminator.
;   
;         - Finally allocate a buffer on the bss section, read a number from the
;           user and use the previous function to fill in the buffer on the bss
;           section with the ASCII picture. Then print the ASCII picture to the
;           user.

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    glyphs      db  '*:#@'
    szPrompt    db  'Enter a DWORD: ', 0
    szEndline   db  13, 10, 0

section '.bss' readable writeable
    buffer      db  (4 * (4 + 2) + 1) dup (?)
len.buffer = $ - buffer

section '.text' code readable executable
start:
    mov     esi, szPrompt
    call    print_str
    call    read_hex

    mov     esi, szEndline
    call    print_str

    mov     edi, buffer
    call    write_glyphs

    mov     esi, buffer
    call    print_str

exit:
    push    0
    call    [ExitProcess]

; I ebx: (only low bit is converted)
; O eax: one-byte character
convert_low_bits:
    mov     eax, ebx
    and     eax, 11b
    mov     al, byte [glyphs + eax]
    ret

; I eax
; O [edi + 0..6]
; M edi += 6
write_glyphs:
    push    eax
    push    ebx
    push    ecx

    mov     ebx, eax
    mov     ecx, 4      ; number of lines
.parse_bit_line:
    push    ecx
    mov     ecx, 4      ; number of characters per line
.parse_bit_sets:
    call    convert_low_bits
    stosb   ; [edi++] <- al

    shr     ebx, 2
    loop    .parse_bit_sets

    mov     byte [edi + 0], 13
    mov     byte [edi + 1], 10
    add     edi, 2

    pop     ecx
    loop    .parse_bit_line

    mov     byte [edi], 0

    pop     ecx
    pop     ebx
    pop     eax
    ret

include 'training.inc'