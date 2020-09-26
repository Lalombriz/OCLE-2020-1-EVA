DOSSEG 
	.model small
	.code 
		public _my_erase 
		public _my_substr
		
		_my_erase proc
			push bp 
			mov bp,sp
			
			mov bx,[bp+4]		;indice de la cadena 
			mov si,[bp+6]		;desde donde quiero borrar
			mov cx,[bp+8]		;num caracteres a borrar 
			push cx 
			push si 			    ;valor desde donde se empezaran a borrar los caracteres 
			
			cmp byte ptr [si],00h
			je ret_AX_1				;verificamos si el valor de SI es un null si lo es entonces es un valor mayor
			
			remplazar:				;esto esta para ingresar ceros en la cadena simulando que la borra
									;creo que ya es inecesario dejarlo pero lo dejare ya que me ayudo a dejar en la 
									;posicion necesaria un apuntador 
			mov byte ptr [si],'0'	;movemos desde la posicio a borrar el caracter de '*'
			inc si 
			loop remplazar
			
			pop bx					;toma el valor desde donde se removieron los valores 
cambio:		cmp byte ptr [bx],00h	;comparamos el caracer con el null 
			je salir_cambio
			mov al,byte ptr [si]	;movemos el caracter apuntado accualmente por si a AL 
			mov byte ptr [bx],al	;movemos ese caracter almacenado en AL a la posicion apunada por BX 
			inc bx					;incrementamos en 1 BX 
			inc si 					;incrementamos en 1 SI
			jmp cambio
			
salir_cambio:
			pop cx 
			mov ax,cx				;movemos el numero de caracteres boramos 
			jmp fin
			ret_AX_1:				;retornamos un -1 si la posicion de borrado es mayor a la cadena 
			mov ax,0ffh				
			fin:
			pop bp
			ret
		_my_erase endp
		
		_my_substr proc
		push bp 
		mov bp,sp
		
		mov si,[bp+4]				;fuente
		mov bx,[bp+6]				;destino
		mov di,[bp+8]				;posicion 
		mov cx,[bp+10]				;n veces 
		push cx 					;guardamos el valor de cx 
		cmp byte ptr [di],00h
		je fallo
copiar: 
		mov al,byte ptr [di]		;copiamos la letra que esta el la posicion esperada 
		inc di						;incrementamos para estar en la proxima letra a copiar
		mov byte ptr [bx],al		;movemos la letra copiada a ala cadena donde queremos que se aloje 
		inc bx 						;incrementamos la cadena en 1
		loop copiar 
									
		mov byte ptr [bx],00h		;le ponemos el valor null a la cadena resultante 
									;ya que fue toda copiada exitosamente.
		pop ax 
		jmp fin2 
		fallo: 
		mov ax,0ffh					;retornamos un -1 si la posicion esta fuera del rango de la cadena 
		fin2:
		
		pop bp
		ret 
		_my_substr endp 
	end 