.model small
	.stack 100h
	include procs.inc 
	LOCALS
	.data
	mens db 10,13,"Programa que imprime los N numeros triangulares ingresador por el usuario",0
	mens2 db 10,13,"Fuera del limite",0
	NewLine db 10,13,0
	cad db 10 dup(0)	;cadena para almacenar el numero 
	.code
	Main proc
	mov ax,@data 
	mov ds,ax
	
	mov dx,offset mens
	call puts 			;mensaje principal
	mov dx,offset NewLine
	call puts 
	mov si,offset cad
	call parametros		;retornaremos el parametro por SI 
	mov bx,offset cad
	call atoi 			;convertimos el numero a valor numerico entero en AX
	call NumeroTriangulares 
	 
	mov ah,04ch
	mov al,0
	int 21h
	endp 
	
	NumeroTriangulares proc
	push bx
	push cx 
	push dx 
	 
	
	xor cx,cx
	xor bx,bx
	xor dx,dx 
	mov cx,ax 
	mov bx,0
	mov bh,2
	
	cmp cx,255
	mov bl,1
	mov al,1
	jg fin		;si es mayor a 255 es que no es un numero valido 
	numero:
	push ax 
	add bl,1	;hacemos el (n+1)
	mul bl 		;multiplicamos el valor de AL(BL+1)
	div bh 		;AL/BL
	mov ah,0
	push bx 
	mov bx,10
	call printNumBase
	mov ah,02
	mov dl,','
	int 21h
	pop bx 
	pop ax 
	inc ax 
	loop numero
	
	fin:
	pop dx
	pop cx 
	pop bx
	ret
	endp
	
	printNumBase PROC
		push ax 
		push bx 
		push cx	
		push dx	 
 				
		mov cx,0 
		mov dx,0
@@while:cmp ax,0
		je @@end_while
		div bx 		;dividimos el numero con la base ingresada 
		push dx 	;guardamos el resuduo a la pula
		inc cx 		;incrementamos cx para hacer uso de un loop
		xor dx,dx	;ponemos en cero dx 
		jmp @@while 
@@end_while: 
@@nxt: 
		pop dx 		;sacamos el residuo de la pila 
		add dx,30h	;ajustamos a ascii
		cmp dx,'9' 	;comparamos el numero con un 9 
		jbe @@print ;
		add dx,7h	;si es mayor a 9 lo ajusta para imprimir las letras correspondientes a HEX
@@print:mov al,dl	;mandamos el dato a desplegar al registro al 
		call putchar;
		loop @@nxt
		
		pop dx
		pop cx
		pop bx
		pop ax
		ret 
	ENDP
	
	parametros proc
		push ax				;salvo registros a utilizar
		push di				;
		push si				;
		push bx				;
		
		mov ah,62h			;ejecutamos el servicio 62h para la obtencion de parametros
		int 21h				;
		mov di,82h			;movemos al registro di el valor 82 donde inician los parametros
		mov ah,0dh			;movemos un enter a ah
@@while:cmp ES:[DI],ah		;comparamos ES:[DI] con el enter
		je @@fin			;si es igual entonces termina el ciclo
		mov al,ES:[DI]		;movemos la letra hacia el registro al
		mov [si],al			;enviamos a la cadena en si la letra de al
		inc si				;incrementamos si para apuntar a la siguiente direccion
		inc di				;incrementamos di para apuntar a la siguiente direccion
		jmp @@while
		
@@fin:	mov byte ptr[si],0	;movemos un 0 al final ya que asi terminan las cadenas
		pop bx				;volvemos a poner los registros como estaban
		pop si				;
		pop di				;
		pop ax				;
		endp
		
		atoi PROC
		push cx		;salvamos registros
		push bx
		push si
		mov si,bx 	;movemos el valor de bx a si 
		xor ax,ax	;limpiamos el registro AX
		mov cx,10	; movemos 10 decimal al registro cx
		xor bx,bx	;limpiamos el registro BX
		
@@nxt:	cmp byte ptr[si],0	;verificamos que no sea NULL el caracter de la cadena
		je @@fin			; si lo es salimos
		mov bl,[si]			;movemos un byte de CS:BX a bl
		sub bl,30h			;le restamos el valor ASCII
		mul cx				;multiplicamos el registro para hacer unidades, decenas, centenas, etc
		add ax,bx			;le sumamos el dato al registro ax
		inc si				;apuntamos ahora a la siguiente direccion de la cadena
		jmp @@nxt			;saltamos a la etiqueta nxt
@@fin:	
		pop si	
		pop bx
		pop cx
		ret
		ENDP 
		
end