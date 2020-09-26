.model small 
	.stack 100h
	inclide procs.inc
	.data
	mens db 10,13,"Ingresa una palabra:",0
	mens_2 db 10,13,"Es palindromo",0
	mens_3 db 10,13,"No palindromo",0
	cad db 10 dup(0)
	.code
	main proc
	mov ax,@data
	mov ds,ax
	
	mov dx,offset mens
	call puts 
	mov bx,offset cad 
	call gets 
	mov cx,0
	mov ax,0
	
	mov si,offset cad
@@nxt:	
	cmp byte ptr [si],00h
	je @@verificar
	push [si]
	dec si
	inc cx 
	jmp @@nxt
	
	@@verificar:
	dec cx 
	@@palin:
	dec si 
	pop ax 
	cmp byte ptr [si],ax
	jne @@no_Es
	loop @@palin
	
	mov dx,offset mens_2
	call puts 
	jmp @@fin
	
	@@no_Es:
	mov dx,offset mens_3
	call puts 
	
	@@fin:
	mov ah,04ch
	mov al,0
	int 21h
	endp 
	gets proc
			push ax
			push cx
			push bx
			PUSH DX
			mov cl,0
	@@captura:mov ah,01h;capturamos el primer caracter
			  int 21h
	@@borrar:cmp al,8		;verificamos si es el backspace
			 jne @@enter	;si no es igual saltamos a verificar si se preciono un enter
			 cmp cl,0		;comparamos si cl es 0,si lo es entonces no hay elemento que borrar
			 mov dl," "		;funcion para eliminar el eco de la pantalla
			 mov ah,02h			 ;
			 int 21h
			 je @@captura	;si cl es 0 entonces brincamos a la captura otra vez
			 mov byte ptr[bx],0	;en caso que si se preciono el y cl no sea 0 backspace borramos el elemento
			 dec bx				;decrementamos bx para apuntar a la direccion bx-1 un elemento atras
			 inc cl				;incrementamos cl por el eco agregado para eliminar el elemento en pantalla
			 mov dl,8			;pasamos a al el backspace para retroceder un elemento hacia atras
			 mov ah,02h
			 int 21h
			 jmp @@captura		;volvemos a capturar un caracter
	@@enter: cmp al,13			;si el caracter ingresado es enter salimos de la capturacion de la cadena
			 je @@fin
			 mov [bx],al		;si no es igual pasamos el elemento al al contenido de [bx]
			 inc bx				;incrementamos bx para apuntar a la siguiente direccion
			 dec cl				;decremento cl para cuando se utilize un backspace no se atore en el mismo elemento
			 jmp @@captura
	@@fin:	 mov byte ptr[bx],0 ;ya que capturo toda su cadena dejamos el ultimo elemento con un 0
			
			POP DX
			pop bx
			pop cx
			pop ax
			ret
			endp
	
end 