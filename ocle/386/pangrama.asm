section .data ; Datos inicializados
msg1: db "Programa que verifica que una palabra es pangrama en 80386 ",10 ;mensaje de inicio 
msg1_L: equ $-msg1  ;cantidad de bytes 

msg2: db "The quick brown fox jumps over the lazy dog",0 ;cadena para verificar que es isograma
msg2_L: equ $-msg2  ;cantidad de bytes 

msg3: db "pangrama",0
msg3_L: equ $-msg3

msg4: db "no pangrama",0
msg4_L: equ $-msg4 

section .bss ; Datos no inicializados
palabra resb 256
palabra_R: equ $-palabra
section .text
 global _start:

_start: 
;encabezado para imprimir mensage en 386
    mov eax,4       ;servicio de interrupcion
    mov ebx,1       ;especificamos salida a pantalla 
    mov ecx,msg1    ;direcion de memoria con caracteres a escribir  
    mov edx,msg1_L  ;cantidad de bytes a escribir 
    int 80h 

    mov eax, 3       ;servicio para capturar la palabra 
    mov ebx, 0
    mov ecx, palabra   ;variable donde se almacenara la frase pangrama
    mov edx, 256       ;cantidad de bytes para leer 
    int 80h          ;codigo donde capturamos la frase 
;parte donde se termina la ejecucion de la interrupcion para el mensage
		;codigo 
	
    mov bp,palabra_R 
    call pangrama       ;mandamos a llamar la funcion que nos verifica que sea pangrama 

mov eax, 1
mov ebx,0
int 80h        ;final del codigo NASM 

pangrama:
		push cx 
		push dx
		push si	;salvamos registros 
		push bp
		
		mov si,0
		mov al,61h              ;letra 'a' 
		mov bx,0				
		mov cx,26
		;codigo 
		
comp:	cmp byte  [bp+si],00h	;comparamos si recorrimos toda la cadena 
		jne verificar_letra
		mov si,0					;regresamos la base de la cadena en 0 
		inc al
		mov bh,0
		jmp comp
verificar_letra:
		cmp byte  [bp+si],al		;verificamos la letra 
		je moderador 				;salto que nos llevara el conteo de letras 
		inc si						;en la palabra sin contar las repetidas 
		jmp comp
moderador:
		cmp bh,1					;comparamos con 1 para no dejar que cuente letras repetidas 
		jge verificar_letra
		inc bh 						;contador de letras 
		inc bl
		loop comp
		
		cmp bl,26
		je pang 					;si es igual a 26 es pangrama 
		jl no_pangrama				;si no, no lo es 
pang:
		                            ;mensaje de pangrama
        mov eax,4       ;servicio de interrupcion
        mov ebx,1       ;especificamos salida a pantalla 
        mov ecx,msg3    ;direcion de memoria con caracteres a escribir  
        mov edx,msg3_L  ;cantidad de bytes a escribir 
        int 80h 
		 
		jmp fin 
no_pangrama:
		                            ;no pangrama 
		mov eax,4       ;servicio de interrupcion
        mov ebx,1       ;especificamos salida a pantalla 
        mov ecx,msg4    ;direcion de memoria con caracteres a escribir  
        mov edx,msg4_L  ;cantidad de bytes a escribir 
        int 80h 
		fin:
		
		pop bp
		pop si 
		pop dx
		pop cx
		ret