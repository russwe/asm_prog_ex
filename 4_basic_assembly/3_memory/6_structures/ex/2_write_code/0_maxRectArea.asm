;   0.  Area competition.
;   
;       For every rectangle R which is parallel to the X and Y axes, we can
;       represent R using two points.
;   
;       Example:
;     
;         A------------B
;         |     R      |
;         |            |
;         D------------C
;   
;         We could represent the rectangle in the drawing using the points A(x,y)
;         and C(x,y) for example. Basically, we need 4 numbers to represent this
;         kind of rectangle: 2 coordinates for A, and 2 coordinates for C.
;   
;         I remind you that the area of a rectangle is computed as the
;         multiplication of its height by its width.
;   
;   
;       Write a program that takes the coordinates of two rectangles (2 points or 4
;       dwords for each rectangle), and then finds out which rectangle has the
;       larger area.
;   
;       The program then outputs 0 if the first rectangle had the largest area, or 1
;       if the second rectangle had the largest area. 
;   
;       In addition, the program prints the area of the rectangle that won the area
;       competition.

;
;       Coord-System Used: Origin (0,0) @ Upper-Left
;

format PE console
entry start

include 'win32a.inc'

struct AREA
    dwHigh  dd ?
    dwLow   dd ?
ends

section '.bss' readable writable
    maxArea     AREA    0,0
    maxRectNum  dd      ?

rectCount = 2

section '.text' code readable executable

start:
    ; Read Rect0, Compute Area, and Save
    ; Read Rect1, Compute Area, and Save
    mov     ecx, rectCount
computeRectArea:
    call    read_hex    ; R.ul.x
    mov     ebx, eax

    call    read_hex    ; R.ul.y
    mov     ebp, eax

    call    read_hex    ; R.lr.x
    mov     esi, eax
    cmp     esi, ebx
    jb      exit

    call    read_hex    ; R.lr.y
    mov     edi, eax
    cmp     edi, ebp
    jb      exit

    mov     eax, esi    ; R.lr.x
    sub     eax, ebx    ; R.lr.x - R.ul.x   // width

    mov     edx, edi    ; R.lr.y
    sub     edx, ebp    ; R.lr.y - R.ul.y   // height

    mul     edx         ; edx:eax = width * height

    cmp     edx, dword [maxArea.dwHigh]
    ja      newMax  ; high-order bits >
    jb      next    ; high-order bits <
    cmp     eax, dword [maxArea.dwLow]
    jbe     next    ; high-order bits =, low-order bits <=
newMax:
    mov     dword [maxArea.dwHigh] , edx
    mov     dword [maxArea.dwLow]  , eax
    mov     dword [maxRectNum]     , ecx

next:
    loop    computeRectArea

    call    print_delimiter

    mov     eax, [maxRectNum]
    sub     eax, rectCount
    neg     eax
    call    print_eax

    call    print_delimiter

    mov     eax, [maxArea.dwHigh]
    call    print_eax

    mov     eax, [maxArea.dwLow]
    call    print_eax

exit:
    push    0
    call    [ExitProcess]

include 'training.inc'