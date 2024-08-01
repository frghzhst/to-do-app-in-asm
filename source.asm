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
    newline db 0x0a, 0
    lsize equ - newline
    writing db 'what do you want to add', 0x0a, 0
    wl equ - writing
    removerin db 'what do you want to remove', 0x0a, 0
    rsize equ - removerin
    nein db 'no match of what you wanted to remove', 0x0a, 0
    neinsize equ - nein

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
    xor ecx, ecx

    ;mov byte [ecx + eax], 0 
    
    ;mov eax, 4
    ;mov ebx, 1
    ;mov ecx, startupmsg1
    ;mov edx, size1
    ;int 0x80 print input for debugging reason
    
    cmp byte [buf], '1'
    je read
    
    cmp byte [buf], '2'
    je write

    cmp byte [buf], '3'
    je remove

    cmp byte [buf], '4'
    je exit

read:
    xor buf, buf
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
    xor buf, buf
    mov eax, 4
    mov ebx, 1
    mov ecx, writing
    mov edx, wl
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buf
    mov edx, 255
    int 0x80
    push buf

    mov esi, user_input   ; Point to the start of user input
    xor ecx, ecx          ; Initialize counter for size calculation

count_loop:
    cmp byte [esi], 0     ; Check for null terminator or newline character
    je end_count          ; If termination character found, end counting
    inc ecx               ; Increment counter
    inc esi               ; Move to the next byte
    jmp count_loop        ; Repeat until termination character is found
end_count:
    mov eax, 4
    mov ebx, [fd_in]
    mov ecx, buf
    mov edx, ecx
    int 0x80
    jmp startup

remove:
    xor buf, buf
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

    mov ecx, removerin
    mov edx, rsize
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buf
    mov edx, 255
    int 0x80

    mov esi, buf
    mov edi, info
loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne ne
    cmp al, 0
    je eq 
    inc esi
    inc edi
    jmp loop

ne:
    mov eax, 4
    mov ebx, 1
    mov ecx, nein
    mov edx, neinsize
    int 0x80
    jmp startup

eq:
    ;logic for removing the todo from logs
exit:

    mov eax, 4
    mov ebx, 1
    mov ecx, exitmsg
    mov edx, sizeexit
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80