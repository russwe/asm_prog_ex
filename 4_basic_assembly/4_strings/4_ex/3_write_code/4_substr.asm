;   4.  Substring
;   
;       Write a program that asks the user for two strings: s1,s2. 
;       
;       The program then searches for all the occurrences of s2 inside s1, and prints
;       back to the user the locations of all the found occurrences.
;   
;       Example:
;         
;         Input:  s1 = 'the colors of my seas are always with me.'
;                 s2 = 'th'
;   
;         Search: s1 = 'the colors of my seas are always with me.'
;                       th                                 th
;                       00000000000000001111111111111111222222222
;                       0123456789abcdef0123456789abcdef012345678
;   
;         Output: Substring was found at locations:
;                 0
;                 23

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szPrompt1   db 's1: ', 0
    szPrompt2   db 's2: ', 0

section '.bss' readable writeable
    MAX_STR = 256

    sz1 db MAX_STR dup (?)
    sz2 db MAX_STR dup (?)

section '.text' code readable executable
start:
    ; totes not implementing a suffix trie in ASM, so...
    ; O(n^2) solution it is!

    mov     esi, szPrompt1
    call    print_str

    mov     edi, sz1
    mov     ecx, MAX_STR
    call    read_line

    mov     esi, szPrompt2
    call    print_str

    mov     edi, sz2
    mov     ecx, MAX_STR
    call    read_line

    mov     edx, sz1    
walk1:
    mov     esi, edx    ; pointer into parent string
    mov     edi, sz2    ; pointer into substring
match2:
    mov     al, byte [esi]
    cmp     al, byte [edi]
    jne     nextWalk1
    
    inc     edi
    cmp     byte [edi], 0
    jne     nextMatch2

    mov     eax, edx
    sub     eax, sz1
    call    print_eax
    jmp     nextWalk1

nextMatch2:
    inc     esi
    jmp     match2

nextWalk1:
    inc     edx
    cmp     byte [edx], 0
    jne     walk1

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'