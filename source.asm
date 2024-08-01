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
    fd_out resb 1
    fd_in resb 1
    info resb 26

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
    
    ;mov eax, 4
    ;mov ebx, 1
    ;mov ecx, startupmsg1
    ;mov edx, size1
    ;int 0x80 ; print input for debugging reason
    cmp byte [buf], '1'
    je read
    
    cmp byte [buf], '2'
    je write

    cmp byte [buf], '3'
    je remove

    cmp byte [buf], '4'
    je exit
    ;jmp exit
read:
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    mov edx, 0777
    int 0x80 ; opens file for read

    mov [fd_in], eax ; save the file descriptor for later use

    mov eax, 3
    mov ebx, [fd_in]
    mov ecx, info
    mov edx, 26
    int 0x80 ; reads from the file

    mov eax, 6
    mov ebx, [fd_in]
    int 0x80 ; close file

    mov eax, 4
    mov ebx, 1
    mov ecx, info
    mov edx, 26
    int 0x80 ; prints the file

    jmp startup
write:
    jmp exit
remove:
    jmp exit
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