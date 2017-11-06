; Basic Assembly
; ==============
; 
; Subroutines and the stack - Local state
; ---------------------------------------
; 
; Minggatu
; @@@@@@@@
;
; 0.    Assemble and run this program.
;
; 1.    Give the program some example inputs, and observe the output.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Fill in briefly the Input, Output and Operation comments for every
;       function in the code.
;       For each index: (1 being the initial state)
;       Walks previous numbers left-to-right and right-to-left, multiplying values at the current indicies together
;       and summing the results to get the value at the next index
;
;       [0] = 1
;       [1] = 1*1 = 1
;       [2] = 1*1 + 1*1 = 2                     (2 + 2) / 2 = 2
;       [3] = 1*2 + 1*1 + 2*1 = 5               (3 + 2) / 2 + (3 + 3) / 3 = (5 * 3 + 6 * 2) / 6 = 15 + 12 / 6 = 27 / 6
;       [4] = 1*5 + 1*2 + 2*1 + 5*1 = 14 (e)
;       ...
;
; 4.    Bonus: What is the meaning of the output numbers? Can you find a closed
;       formula for those numbers?
;
;       https://en.wikipedia.org/wiki/Catalan_number (it appears the product notation is incorrect, see above and below)
;       http://mathworld.wolfram.com/CatalanNumber.html
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.data' data readable writeable
    wanted_elem     db  'Enter wanted element number: ',0
    elem_value      db  'Wanted element value: ',0

; ===============================================
section '.text' code readable executable

start:
    mov     esi,wanted_elem
    call    print_str
    call    read_hex

    push    eax
    call    calc_num
    add     esp,4

    mov     esi,elem_value
    call    print_str
    call    print_eax

    ; Exit the process:
    push    0
    call    [ExitProcess]

; ===============================================
; calc_num(index)
;
; Input:
;   index
; Output:
;   element at index
; Operation:
;   compute the element at the given index
;
calc_num:
    .index = 8
    push    ebp
    mov     ebp,esp

    push    ecx
    push    esi
    push    ebx

    mov     ecx,dword [ebp + .index]    ; copy index arg into ECX
    lea     ebx,[4*ecx + 4]             ; !! THIS LINE HAD A BUG [4*ecx] vs [4*ecx + 4], and was corrupting EBX on the stack
    sub     esp,ebx                     ; ESP -= 4 * (index + 1) (make enough room on stack for array with 'index+1' elements)
    mov     esi,esp                     ; ESI = ESP (start of array)

    xor     ebx,ebx                     ; EBX = 0
    mov     eax,1                       ; EAX = 1

.calc_next_num:
    ; Store the result into the array:
    mov     dword [esi + 4*ebx],eax
    
    inc     ebx
    push    ebx
    push    esi

    call    calc_next
    add     esp,4*2

    cmp     ebx,ecx
    jb      .calc_next_num
    
    mov     ecx,dword [ebp + .index]
    lea     ebx,[4*ecx+4]   ; !! Updated from bugfix
    add     esp,ebx

    pop     ebx
    pop     esi
    pop     ecx

    pop     ebp
    ret

; ===============================================
; calc_next(arr_addr,arr_len)
;
; Input:
;   array pointer, array len
; Output:
;   none
; Operation:
;   calcualtes the value for the current index and stores it in the array
;
calc_next: 
    .arr_addr = 8
    .arr_len = 0ch
    push    ebp
    mov     ebp,esp

    push    ebx
    push    ecx
    push    esi
    push    edi
    push    edx

    mov     ecx,dword [ebp + .arr_len]      ; ecx = arr len
    jecxz   .arr_len_zero
    mov     esi,dword [ebp + .arr_addr]     ; esi = pLeft
   ;mov     edi,dword [ebp + .arr_addr]     ; edi = arr ptr
    lea     edi,[esi + 4*ecx - 4]           ; edi = pRight = &arr[len-1]

    xor     ebx,ebx                         ; ebx = 0
.next_mul:
    mov     eax,dword [esi]                 ; eax = *pLeft
    mul     dword [edi]                     ; eax *= *pRight
    add     ebx,eax                         ; ebx += *pLeft * *pRight
    add     esi,4                           ; ++pLeft
    sub     edi,4                           ; --pRight
    loop    .next_mul                       ; --ecx

    mov     eax,ebx
    jmp     .end_func
.arr_len_zero:
    xor     eax,eax
.end_func:
    
    pop     edx
    pop     edi
    pop     esi
    pop     ecx
    pop     ebx

    pop     ebp
    ret

include 'training.inc'
