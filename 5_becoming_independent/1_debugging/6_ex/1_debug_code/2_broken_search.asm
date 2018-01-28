; Becoming Independent
; ====================
; 
; Debugging
; ---------
; 
; Broken Search
; @@@@@@@@@@@@@
;
; 0     Read the main comment of this program.
;
; 1.    Assemble and run this program. Give the program an example input, and
;       observe the program's operation.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;
; 3.    The code contains a few errors. Find those errors and fix them, so that
;       the program runs correctly. Use a debugger for this task. You may need
;       to add/remove/change a few instructions in this program.
;

; The program requests a number from the user, and looks for that number inside
; an array. An apropriate message is give to the user regarding the search
; results.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.data' data readable writeable
    please_enter    db  'Please enter a number: ',13,10,0
    my_arr          dd  0h,1h,6h,1fh,32h,101h,4a2h,1211h,16bch,2998h,0abcdh,10000h
    ARR_LEN = ($ - my_arr) / 4

    not_inside      db  'Your number is not inside my array!',13,10,0
    inside          db  'Your number is inside my array!',13,10,0
; ===============================================
section '.text' code readable executable

start:
    ; Ask for a number:
    mov     esi,please_enter
    call    print_str

    ; Read a number:
    call    read_hex

    push    eax
    push    ARR_LEN
    push    my_arr
    call    is_in_array
    add     esp,4*3

    test    eax,eax
    jz      .not_in_array
    ; We are here if the number is inside the array:
    mov     esi,inside
    call    print_str

    jmp     .end_prog
.not_in_array:
    ; We are here if the number is not inside the array:
    mov     esi,not_inside
    call    print_str

.end_prog:
    ; Exit the process:
	push	0
	call	[ExitProcess]

; =========================================
; is_in_array(array,arr_len,x)
; 
; Operation:
;   Search the element x inside the array array, of length arr_len.
;
; Input: 
;   array   - Address of array of dwords (Must be sorted).
;   arr_len - Amount of dwords in the array.
;   x       - Dword to find inside the array.
; 
; Output:
;   eax = 1     If the dword x is inside the array.
;   eax = 0     Otherwise.
;
is_in_array:
    .array = 8
    .arr_len = 0ch
    .x = 10h
    push    ebp
    mov     ebp,esp

    ; ! Really should save register state, but not actually required here
    ; eax: middle index | ret 0, if no match; 1, otherwise
    ; ebx: comparison value
    ; ecx: start array pointer
    ; esi: left index
    ; edi: right index

    mov     ebx,dword [ebp + .x]
    mov     ecx,dword [ebp + .array]
    xor     esi,esi
    mov     edi,dword [ebp + .arr_len]
    dec     edi

.next_iter:
    ; Check if the search has ended:
    xor     eax,eax
    cmp     esi,edi
    ja      .end_func

    ; Get the middle index of the partition:
    mov     eax,edi
    sub     eax,esi
    shr     eax,1
    add     eax,esi

    mov     edx,[ecx + 4*eax]

    cmp     ebx,edx
    ja      .too_big
    jb      .too_small

    ; We have a match here:
    xor     eax,eax
    inc     eax
    jmp     .end_func

.too_small:
    ; We are here if the number is too small:
    mov     edi,eax
    dec     edi
    jmp     .next_iter
.too_big:
    ; We are here if the number is too big:
    mov     esi,eax
    inc     esi
    jmp     .next_iter

.end_func:
    leave
    ret

include 'training.inc'
