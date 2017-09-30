;   0.  Find closest number.
;       
;       Add the following into the data section:
;   
;       nums  dd  23h,75h,111h,0abch,443h,1000h,5h,2213h,433a34h,0deadbeafh
;   
;       This is an array of numbers. 
;       
;       Write a program that receives a number x as input, and finds the dword
;       inside the array nums, which is the closest to x. (We define the distance
;       between two numbers to be the absolute value of the difference: |a-b|).
;   
;       Example:
;   
;       For the input of 100h, the result will be 111h, because 111h is closer to
;       100h than any other number in the nums array. (|100h - 111h| = 11h).

format PE console
entry start

include 'win32a.inc' 

section '.data' data readable writeable

nums  dd  23h,75h,111h,0abch,443h,1000h,5h,2213h,433a34h,0deadbeafh
nums_end:


section '.text' code readable executable

; edx: abs compute
; eax: input, current num, abs compute
; ebx: x

; ecx: loop index into nums
; esi: index into nums of lowest distance

; edi: lowest recorded distance

start:
    call    read_hex    ; x
    mov     ebx, eax

    xor     esi, esi
    xor     edi, edi
    not     edi
    shr     edi, 1

    mov     ecx, (nums_end - nums) / 4
check_num:
    dec     ecx
    mov     eax, dword [nums + 4*ecx]
    sub     eax, ebx

    ; Compute ABS(eax)
    cdq
    xor     eax,edx
    sub     eax,edx

    cmp     eax, edi
    cmovl   esi, ecx
    cmovl   edi, eax
    
    test    ecx, ecx
    jnz     check_num

    mov     eax, dword [nums + 4*esi]
    call    print_eax

exit:
	push	0
	call	[ExitProcess]

include 'training.inc'
