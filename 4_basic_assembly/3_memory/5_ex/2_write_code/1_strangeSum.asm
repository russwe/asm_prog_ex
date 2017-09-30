;   1.  Strange sum.
;   
;       Write a program that gets a number n as input, and then receives a list of n
;       numbers: a_1, a_2, ..., a_n.
;   
;       The program then outputs the value n*a_1 + (n-1)*a_2 + ... + 1*a_n.
;       Here * means multiplication.
;   
;       Example:
;   
;       Assume that the input received was n=3, together with the following list of
;       numbers:  3,5,2.
;       Hence the result will be 3*3 + 2*5 + 1*2 = 9 + 10 + 2 = 21 = 0x15
;   
;       
;       Question for thought: Could you write this program without using memory?
;
;       Of course.  Why would I use memory at all?!

format PE console
entry start

include 'win32a.inc' 

section '.text' code readable executable

start:
    call    read_hex    ; n
    test    eax, eax
    jz      exit

    xor     edi, edi    ; sum = 0
    mov     ecx, eax
computeSum:
    call    read_hex    ; a_(l-n+1)
    mul     ecx         ; edx:eax = n * a_(l-n+1)
    add     edi, eax    ; sum += n * a_(l-n+1)
    loop    computeSum

    mov     eax, edi
    call    print_eax

exit:
	push	0
	call	[ExitProcess]

include 'training.inc'
