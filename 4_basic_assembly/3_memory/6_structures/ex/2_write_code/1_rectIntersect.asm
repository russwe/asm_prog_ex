;   1.  Check intersection.
;       
;       Assume that we have two rectangles R,Q which are parallel to the X and Y
;       axes. We say that R and Q intersect if there is a point which is inside both
;       of them.
;       
;       Example:
;         
;         Intersecting rectangles:        Non intersecting rectangles:
;   
;         +---------+                     +-----+
;         | R       |                     | R   |   +------+
;         |     +---+----+                |     |   | Q    |
;         |     |   |  Q |                +-----+   |      |
;         +-----+---+    |                          |      |
;               |        |                          +------+
;               +--------+
;   
;       Write a program that takes the coordinates of two rectangles (Just like in
;       the previous exercise), and finds out if the rectangles are intersecting.
;       The program will print 1 if they are intersecting, and 0 otherwise.
;   
;       Example:
;         First rectangle:  (1,5) (4,9)
;         Second rectangle: (3,4) (6,10)
;   
;         Those two rectangle are intersecting.

;
;       Coord-System Used: Origin (0,0) @ Upper-Left
;

format PE console
entry start

include 'win32a.inc'

struct COORD
    x dd  ?
    y dd  ?
ends

struct RECT
    ul  COORD   ?
    lr  COORD   ?
ends

section '.bss' readable writable
    r1  RECT    ?
    r2  RECT    ?

section '.text' code readable executable

; For intersection to occur ALL below MUST BE true
;
; r1.ul.x <= r2.lr.x
; r1.lr.x >= r2.ul.x
;
; r1.ul.y <= r2.lr.y
; r1.lr.y >= r2.ul.y
;

start:
    ; r1
    call    read_hex
    mov     dword [r1.ul.x], eax

    call    read_hex
    mov     dword [r1.ul.y], eax

    call    read_hex
    mov     dword [r1.lr.x], eax

    call    read_hex
    mov     dword [r1.lr.y], eax

    ; r2
    call    read_hex
    mov     dword [r2.ul.x], eax

    call    read_hex
    mov     dword [r2.ul.y], eax

    call    read_hex
    mov     dword [r2.lr.x], eax

    call    read_hex
    mov     dword [r2.lr.y], eax

    ; r1.ul.x <= r2.lr.x
    mov     eax, [r1.ul.x]
    cmp     eax, [r2.lr.x]
    ja      noIntersect

    ; r1.lr.x >= r2.ul.x
    mov     eax, [r1.lr.x]
    cmp     eax, [r2.ul.x]
    jb      noIntersect
    ;
    ; r1.ul.y <= r2.lr.y
    mov     eax, [r1.ul.y]
    cmp     eax, [r2.lr.y]
    ja      noIntersect

    ; r1.lr.y >= r2.ul.y
    mov     eax, [r1.lr.y]
    cmp     eax, [r2.ul.y]
    jb      noIntersect

intersect:
    mov     eax, 1
    jmp     output

noIntersect:
    mov     eax, 0

output:
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'