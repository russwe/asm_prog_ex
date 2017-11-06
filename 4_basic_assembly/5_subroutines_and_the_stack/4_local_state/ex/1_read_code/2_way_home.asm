; Basic Assembly
; ==============
; 
; Subroutines and the stack - Local state
; ---------------------------------------
; 
; Way Home
; @@@@@@@@
;
; 0.    Assemble and run this program.
;
; 1.    Observe the output.
;
; 2.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 3.    Read the program's code below, and try to understand what does it do. 
;       Try to describe it as simply as you can. Add comments if needed.
;
;       Fill in briefly the Output and Operation comments for the way_home
;       function.
;
; 4.    Explain the output. 
;
;       HINTS:
;       -   Add another dummy function to the chain, and compare the result.
;       -   Remove the dummy functions and call the way_home function
;           directly. What do you see? What is the meaning of that output?
;

format PE console
entry start

include 'win32a.inc' 

; ===============================================
section '.text' code readable executable


start:
    call    dummy1

    ; Exit the process:
    push    0
    call    [ExitProcess]


dummy1:
;   RA: start
    enter   0,0
;   EBP: 0
    call    dummy2
    leave
    ret

dummy2:
;   RA: dummy1
    enter   0,0
;   EBP: dummy1:EBP
    call    dummy3
    leave
    ret

dummy3:
;   RA: dummy 2
    enter   0,0
;   EBP: dummy2:EBP
    call    way_home
    leave
    ret

; ===============================================
; way_home()
;
; Output:
;   Prints the return address for all calls on the stack
; Operation:
;   Walks the stack frames, displaying return addresses
;
; "Well, I'm not sure about Kansas," said Oz, "for I haven't the faintest
; notion which way it lies. But the first thing to do is to cross the
; desert, and then it should be easy to find your way home."
;
way_home:
;   RA: dummy3
    mov     esi,ebp             ; esi = Previous Method Frame Pointer

.next_frame:
    mov     eax,dword [esi + 4] ; Move one DWORD down the stack (Return Address)
    test    eax,eax
    jz      .end_func           ; If Return Address is 0, done
    call    print_eax           ; Otherwise, print return address
    mov     esi,dword [esi]     ; Follow EBP to prior frame
    jmp     .next_frame
.end_func:

    ret

include 'training.inc'
