;   2.  CaSe
;       
;       Write a program that asks the user for a string. It then flips every letter
;       from lower case to UPPER case and vice versa, and prints back the result to the
;       user.
;   
;       Example:
;         Input:  Hello
;         Output: hELLO
;   
;       You may assume that the input is only made of letters. (No spaces or
;       other punctuation marks).

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szPrompt db 'Enter a string to swap-case: ', 0
    MAX_STR = 256

section '.bss' readable writeable
    szInput  db MAX_STR dup (?)
    szOutput db MAX_STR dup (?)

section '.text' code readable executable
start:
    mov     esi, szPrompt
    call    print_str

    mov     ecx, MAX_STR
    mov     edi, szInput
    call    read_line

    mov     esi, szInput
    mov     edi, szOutput
swapCase:
    mov     al, byte [esi]
    cmp     al, 'A'
    jb      notUpper
    cmp     al, 'Z'
    ja      notUpper
    jmp     upper

notUpper:
    cmp     al, 'a'
    jb      notLetter
    cmp     al, 'z'
    ja      notLetter

lower:
    sub     al, 32
    jmp     storeChar

upper:
    add     al, 32

    ; convert lower

notLetter:
storeChar:
    mov     byte [edi], al
    cmp     al, 0
    je      output

    inc     esi
    inc     edi
    jmp     swapCase

output:
    mov     esi, szOutput
    call    print_str

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'