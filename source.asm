section .data
    filename db 'logs.txt', 0
    buffer db 1024 dup(0)
    startupmsg1 db '1: see todo', 0x0A, 0
    size1 equ - startupmsg1
    startupmsg2 db '2: add todo', 0x0A, 0
    size2 equ - startupmsg2
    startupmsg3 db '3: remove todo', 0x0A, 0
    size3 equ - startupmsg3
    startupmsg4 db '4: exit program', 0x0A, 0
    size4 equ - startupmsg4
    usrinpt db 'please enter a number option: ', 0
    sizeofinpt equ - usrinpt
    exitmsg db 'exiting program', 0x0a, 0
    sizeexit equ - exitmsg

section .bss
    buf resb 255

section .text
    global _start

_start:
    jmp startup

startup:
    mov eax, 4
    mov ebx, 1
    mov ecx, startupmsg1
    mov edx, size1
    int 0x80 ; print startup message 1

    mov ecx, startupmsg2
    mov edx, size2
    int 0x80 ; print startup message 2

    mov ecx, startupmsg3
    mov edx, size3
    int 0x80 ; print startup message 3

    mov ecx, startupmsg4
    mov edx, size4
    int 0x80 ; print startup message 4

    mov ecx, usrinpt
    mov edx, sizeofinpt
    int 0x80 ; prints a input indication

    mov eax, 3       
    mov ebx, 0       
    mov ecx, buf  ; buffer being the input
    mov edx, 255     
    int 0x80 ; read user input

    mov byte [ecx + eax], 0 
    
    mov eax, 4
    mov ebx, 1
    mov ecx, startupmsg1
    mov edx, size1
    int 0x80 ; print input for debugging reasons

    ;cmp buf, 1
    ;je read

    ;cmp buf, 2
    ;je write

    ;cmp buf, 3
    ;je remove

    ;cmp buf, 4
    ;jge exit
    jmp exit
read:
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    int 0x80

    test eax, eax
    js file_not_found

    mov ebx, eax  


    mov eax, 3
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    mov eax, 6
    int 0x80

file_not_found:
    mov eax, 8
    mov ebx, filename
    mov ecx, 0777
    int 0x80

    jmp read

exit:
    mov eax, 4
    mov ebx, 1
    mov ecx, exitmsg
    mov edx, sizeexit
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80