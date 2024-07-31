section .data
    filename db 'logs.txt', 0
    buffer db 1024 dup(0)   

section .text
    global _start

_start:
    jmp startup
startup:
    mov eax, 4
    mov ebx, 1
    mov ecx, 0x77656c636f6d6520746f206d7920746f2d646f206170700a
    mov edx, 24
    int 0x80
    
    ;jmp read
read:
    mov eax, 5         
    mov ebx, filename  
    mov ecx, 0         
    int 0x80           
    
    test eax, eax      
    js file_not_found  

    mov edx, eax      

    mov eax, 3         
    mov ebx, edx      
    mov ecx, buffer    
    mov edx, 1024      
    int 0x80           

    mov eax, 6         
    mov ebx, edx      
    int 0x80          

file_not_found:
