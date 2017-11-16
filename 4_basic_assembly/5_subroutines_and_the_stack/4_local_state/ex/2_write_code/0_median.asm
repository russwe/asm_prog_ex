;   0.  Median
;   
;       Given an array of numbers, The median is defined to be the middle number in
;       the sorted array. (If there are two middle numbers, we pick one of them).
;   
;       Examples:
;   
;         For the array: {4,8,1,9,23h,41h,15h,13h,44h} the median is 13h. (Sort the
;         array and find the middle number, for example).
;   
;         For the array: {4,9,1,5}, then median could be chosen to be both 4 or 5.
;   
;       NOTE that the median is not the same as the mean of the array.
;   
;   
;       0.  Write a function that gets an address of an array of dwords, and the
;           length of the array. The function will then return the median of the 
;           array.
;   
;       1.  Test your function with a few different arrays, and verify the results.
;   
;       2.  Bonus: What is the running time complexity of the function you wrote?
;           Could you find a faster way to find the median of an array?

format PE console
entry start

include 'win32a.inc'

section '.const' data readable
    szLengthPrompt  db  "Enter desired array length: ", 0
    szEntryPrompt   db  "> ", 0
    szResult        db  "Median: ", 0
    szNewLine       db  13, 10, 0

section '.data' code readable executable
start:
    ; Collect array entries
    mov     esi, szLengthPrompt
    call    print_str
    call    read_hex
    mov     ebx, eax

    mov     esi, szEntryPrompt
    mov     ecx, ebx
.readItem:
    call    print_str
    call    read_hex
    push    eax

    dec     ecx
    jnz     .readItem

    push    esp
    push    ebx
    call    median
    lea     ebx, [ebx*4 + 4 + 4]
    add     esp, ebx

    mov     esi, szResult
    call    print_str

    call    print_eax

    mov     esi, szNewLine
    call    print_str
    call    print_str

.exit:
    push    0
    call    [ExitProcess]

;   INPUT
;       variadic, N dwords on the stack, 1 dword of length (value N)
;   OUTPUT
;       eax: median number of sorted array 
;   DESCRIPTION
;       Compute the median of a set of numbers
median:
    .len = 08h
    .arr = 0ch
    push    ebp
    mov     ebp, esp

    push    ecx
    push    esi
    push    edi

    mov     esi, [ebp + .arr]
    mov     ecx, [ebp + .len]

    lea     edi, [esi + 4*ecx - 4]

    push    edi ; right
    push    esi ; left
    call    qsort

    ; extract 'middle' number (median)
    mov     eax, ecx
    shr     eax, 1
    lea     eax, [esi + 4*eax]
    mov     eax, [eax]

    pop     edi
    pop     esi
    pop     ecx

    pop     ebp
    ret

; INPUT
;   left: left pointer into partition
;   right: right pointer into partition
; OUTPUT
;   partition, sorted
; DESCRIPTION
;   quick-sort implementation
qsort:
    .left  = 8
    .right = 12
    push    ebp
    mov     ebp, esp

    push    eax     ; left value
    push    ebx     ; pivot value
    push    edx     ; right value
    push    esi     ; ptr left  (low)
    push    edi     ; ptr right (high)

    mov     esi, [ebp + .left]
    mov     edi, [ebp + .right]

    cmp     esi, edi
    jae     .terminate

    mov     ebx, [esi]

.partition:
    sub     esi, 4
    add     edi, 4

.moveRight:
    add     esi, 4
    mov     eax, [esi]

    cmp     eax, ebx
    jb      .moveRight

.moveLeft:
    sub     edi, 4   
    mov     edx, [edi]

    cmp     edx, ebx
    ja      .moveLeft

.swap:
    cmp     esi, edi
    jae     .recurse

    mov     [esi], edx
    mov     [edi], eax

    jmp .moveRight

.recurse:
    mov     ebx, edi
    mov     esi, [ebp + .left]
    mov     edi, [ebp + .right]

    ; sort left
    push    ebx     ; right (pivot)
    push    esi     ; left
    call    qsort

    ; sort right
    push    edi     ; right
    add     ebx, 4
    push    ebx     ; left (pivot + 4)
    call    qsort

.terminate:
    pop     edi
    pop     esi
    pop     edx
    pop     ebx
    pop     eax

    mov     esp, ebp
    pop     ebp
    ret     8

include 'training.inc'