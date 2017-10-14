;   5.  Number to String
;   
;       We are going to write a program that converts a number into its base 10
;       representation, as a string.
;   
;       The program will read a number as input (Using the read_hex helper
;       subroutine). It will then print back the number, in base 10.
;   
;       Example:
;         
;         Input:  1f23
;         output: 7971 (Decimal representation).
;   
;       HINTS:
;         - Recall that the input number could be imagined to be in the form:
;           input = (10^0)*a_0 + (10^1)*a_1 + ... + (10^t)*a_t
;   
;         - Use repeated division method to calculate the decimal digits
;           a_0,a_1,...,a_t.
;   
;         - Find out how to translate each decimal digit into the corresponding
;           ASCII symbol. (Recall the codes for the digits '0'-'9').
;   
;         - Build a string and print it. Remember the null terminator!

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    cszPrompt   db  'Enter a hex value: ', 0
    cszEndLine  db  13, 10, 0

section '.data' data readable writeable
    szOutput        db  '0000000000', 0   ; MAX(8 hex digits) in base 10 = 4,294,967,295 -> 10 digits + \0
end.szOutput = $ - 1

section '.text' code readable executable
start:
    mov     esi, cszPrompt
    call    print_str
    call    read_hex
    test    eax, eax
    jnz     notZero
    mov     esi, end.szOutput - 1
    jmp     output

notZero:
    mov     ebx, 10
    mov     esi, end.szOutput
convert:
    xor     edx, edx
    div     ebx
    test    edx, edx
    jnz     continue
    test    eax, eax
    jz      output

continue:
    dec     esi
    add     edx, '0'
    mov     byte [esi], dl

    cmp     esi, szOutput
    ja      convert

output:
    call    print_str

    mov     esi, cszEndLine
    call    print_str

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'