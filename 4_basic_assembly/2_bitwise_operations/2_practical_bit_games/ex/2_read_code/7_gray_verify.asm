; 5.    Bonus: Write a program that "verifies" that every two consecutive
;       numbers on this list differ by at most one bit. check out all the
;       possible dwords.

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable

start:
    xor     eax,eax
    not     eax                 ; eax = ffffffff
    mov     esi,eax             ; esi = a

    xor     ebx,ebx             ; Zero ebx.
    inc     ebx                 ; ebx = 1
    xor     edi,edi             ; Zero edi.
show_one_num:
    mov     eax,ebx             ; eax = ebx = 0,1,2,...,a
    shr     eax,1               ; eax = ebx >> 1
    xor     eax,ebx             ; eax = (ebx >> 1) ^^ ebx

    ; compute hamming distance between eax and edi
    xor     ebp,ebp
    mov     ecx,32d
compute_hamming:
    ror     eax,1
    jnc     eax_0
    ror     edi,1
    jnc     noMatch
    jmp     continue
eax_0:
    ror     edi,1
    jnc     continue
noMatch:
    inc     ebp
continue:
    loop    compute_hamming

    mov     edi,eax

    cmp     ebp,1
    je      next
    call    print_eax_binary

next:
    inc     ebx
    cmp     ebx,esi
    jnz     show_one_num        ; ++ebx != a -> show_one_num

    ; Exit the process:
	push	0
	call	[ExitProcess]

include 'training.inc'
