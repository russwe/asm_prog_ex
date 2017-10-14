;   3.  Common sense
;   
;       Write a program that reads a string from the user, and then finds out the
;       most common character in the string. (Don't count spaces).
;       
;       Finally the program prints that character back to the user, together with
;       its number of occurrences in the string.
;       
;       Example:
;   
;         Input:  The summer is the place where all things find their winter
;   
;         Output: The character e is the most common character on the string.
;               Amount of occurrences: 8

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szPrompt  db 'Enter a line: ', 0

section '.data' data readable writable
    addCounts dd 256 dup (0)
    sizeof.addCounts = ($ - addCounts) / 4

    dbInput     db 1 dup (0)
    ddBytesRead dd 1 dup (0)

    szOutput    db '"?" was the most common character at: ', 0

section '.text' code readable executable
start:
    mov     esi, szPrompt
    call    print_str

    ; Get STDIN (from training.inc)
    push    STD_INPUT_HANDLE  ; -10
    call    [GetStdHandle]
    mov     ebp,eax
computeCounts:
    ; read_byte (from training.inc)
    push    0
    mov     ecx, ddBytesRead
    push    ecx
    push    1       ; Read one byte.
    mov     ecx, dbInput
    push    ecx
    push    ebp
    call    [ReadFile]

    xor     eax, eax
    mov     al, byte [dbInput]

    cmp     al, 13
    je      nextComputeCounts
    inc     dword [addCounts + 4 * eax]
nextComputeCounts:
    jnz     computeCounts

    xor     eax, eax   ; max letter
    xor     ebx, ebx   ; max count
    xor     ecx, ecx   ; index into input
findMax:
    mov     edx, dword [addCounts + 4 * ecx]
    cmp     ebx, edx
    jae     nextFindMax

    mov     eax, ecx
    mov     ebx, edx

nextFindMax:
    inc     ecx
    cmp     ecx, sizeof.addCounts
    jb      findMax

output:
    mov     byte [szOutput+1], al
    mov     esi, szOutput
    call    print_str

    mov     eax, ebx
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'