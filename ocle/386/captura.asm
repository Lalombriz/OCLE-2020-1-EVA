section .data ; Datos inicializados
 msg1: db "Ingresa tu nombre: ",10
 msg1_L: equ $-msg1
 msg2: db "Hola "
 msg2_L: equ $-msg2
 ms: db "ingresa numero 1:",10
 ms_size: equ $-ms

section .bss ; Datos no inicializados
 nombre resb 256

section .text
 global _start:

_start:
 mov eax, 4
 mov ebx, 1
 mov ecx, msg1
 mov edx, msg1_L
 int 80h

 mov eax, 3
 mov ebx, 0
 mov ecx, nombre
 mov edx, 256
 int 80h

 mov eax, 4
 mov ebx, 1
 mov ecx, msg2
 mov edx, msg2_L
 int 80h

 mov eax, 4
 mov ebx, 1
 mov ecx, nombre
 mov edx, 256
 int 80h

 mov eax, 1
 mov ebx,0
 int 80h