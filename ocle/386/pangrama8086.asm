.model small 
	.stack 100h
	include procs.inc 
	LOCALS
	.data
	mens db 10,13,"Si es pangrama",0
	mens2 db 10,13,"No es pangrama",0
	mens3 db 10,13,"Programa que detectaecta que una palabra sea pangrama",0
	newLine db 10,13,0
	cad db 20 dup(0)		;cadena para almacenar la palabra
	
	.code
	main proc
	mov ax,@data
	mov ds,ax
	
	mov si,offset cad
	call parametros			;obtenemos la cadena 

	mov dx,offset mens3		;imprimimos un mensaje 
	call puts 
	mov dx,offset newLine	;una linea en blanco 
	call puts 
	
	mov dx,offset cad		;la cadena de prueba 
	call puts 
	
	mov bp,offset cad
	call pangrama

	mov ah,04ch
	mov al,0
	int 21h
	endp
	
	;retorna en AX el resultado 
	pangrama proc
		push cx 
		push dx
		push si	;salvamos registros 
		push bp
		
		mov si,0
		mov al,61h
		mov bx,0
		mov cx,26
		;codigo 
		
comp:	cmp byte ptr [bp+si],00h	;comparamos si recorrimos toda la cadena 
		jne verificar_letra
		mov si,0					;regresamos la base de la cadena en 0 
		inc al
		mov bh,0
		jmp comp
verificar_letra:
		cmp byte ptr [bp+si],al		;verificamos la letra 
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
		mov dx,offset mens			;mensaje de pangrama
		call puts 
		jmp fin 
no_pangrama:
		mov dx,offset mens2			;no pangrama 
		call puts 
		fin:
		
		pop bp
		pop si 
		pop dx
		pop cx
		ret
	endp 
	
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
end