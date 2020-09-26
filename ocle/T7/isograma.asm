DOSSEG 
.MODEL SMALL 
.code 
	PUBLIC _isograma
	
	_isograma proc
		push bp
		push si
		mov bp,sp
		mov si,[bp+6]
		xor ax,ax
		
		call tam
		mov cx,bx 					;movemos el tamanio de la cadena a cx
		mov al,byte ptr [si+bx]		;movemos un caracter a AL 
		
@@while:cmp cx,0
		je es_isograma
		
@@nxt:	cmp byte ptr [si],00h		;comparamos el contenido de si con null
		jne verificar				;si no es igual verificamos las letra 
		mov si,0					;si es igual ponemos si en la posicion 0
		dec bx 						;decrementamos bx para la siguiente letra 
		mov al,byte ptr [si+bx]		;movemos un caracter a AL 
		jmp @@nxt
verificar:
		cmp byte ptr [si],al		;comparamos el valor apuntado de SI con al 
		je no_isograma
		dec cx 						;decrementamos cx que es el contador del while
		inc si 						;incrementamos SI para la siguiente posicion 
		jmp @@while
		
no_isograma:	
		mov ax,0
		jmp exit 
		
es_isograma:
		mov ax,1
		
		exit:
		pop si
		pop bp
		ret 
	_isograma	endp
	
	
	tam proc 			;procedimineto para sacare el tamanio de la cadena
	push si 
	mov bx,0
	
	nxt: cmp byte ptr [si],00h
	je salir 
	inc si
	inc bx 
	jmp nxt 
	salir: 
	dec bx 
	pop si 
	ret 
	endp
		
end