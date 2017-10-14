;   1.  Palindrome
;   
;       A palindrome is a sequence of symbols which is interpreted the same if read in
;       the usual order, or in reverse order.
;       
;       Examples:
;   
;         1234k4321   is a palindrome.
;         5665        is a palindrome.
;   
;         za1221at    is not a palindrome.
;   
;   
;       Write a program that takes a string as input, and decides whether it is a
;       palindrome or not. It then prints an appropriate message to the user.

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szPrompt   db 'Enter a possible palindrome: ', 0
    szIsPalin  db '; is a palindrome.', 13, 10, 0
    szNotPalin db '; is not a palindrome.', 13, 10, 0

section '.bss' readable writable
    input db  256 dup (?)
    sizeof.input = $ - input

section '.text' code readable executable
start:
    ; Take user input
    mov     esi, szPrompt
    call    print_str

    mov     edi, input
    mov     ecx, sizeof.input
    call    read_line

    ; Compute strlen
    xor     al, al
    mov     edi, input
    mov     ecx, sizeof.input
    repne   scasb
    neg     ecx
    add     ecx, sizeof.input
 
    ; Walk front-to-middle and middle-to-front, comparing
    mov     ebx, szNotPalin
    mov     esi, input
    lea     edi, [esi + ecx]    ; move to just past the end of the string
    dec     edi                 ; point to null-terminator
    dec     edi                 ; point to last letter
    cmp     esi, edi
    jae     palin               ; short-circuit for empty and single-letter inputs
checkPalin:
    mov     al, byte [esi]
    cmp     al, byte [edi]
    jne     notPalin

    inc     esi
    dec     edi
    cmp     esi, edi
    jb      checkPalin

palin:
    mov     ebx, szIsPalin

    ; Output result
notPalin:
output:
    mov     esi, input
    call    print_str

    mov     esi, ebx
    call    print_str

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'