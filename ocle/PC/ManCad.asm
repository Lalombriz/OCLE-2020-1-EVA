DOSSEG 
	.model small
	.code 
		public _my_erase 
		public _my_substr
		public _my_strcmp
		public _my_strchr
		
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
		
;**************************************************	
;compara que dos cadenas lexicograficamente 

		_my_strcmp proc
			push bp 
			mov bp,sp
			mov si,[bp+4]	;str1
			mov di,[bp+6]	;str2
			mov bx,0
			mov cx,0	;inicializamos registros en 0
			
			;primero recibe el valor de la cadena 1
			call suma_ASCII
			mov cx,ax 	;movemos el valor de la cadena 1 en cx
			
			mov si,di 	;movemos la cadena que tenemos en DI a SI 
			call suma_ASCII
			;recibimos el valor en el registro AX 
			
			cmp cx,ax 		;comparmos las cadenas 1 con la 2 
			jz	iguales 	;si el valor es cero es que las cadenas son iguales 
			cmp cx,ax 
			ja 	cad1_mayor	;salta si la cadena 1 es mayor 
			cmp cx,ax
			jb cad2_mayor
			
	cad2_mayor:	
			mov ax,-1 		;si ninguna de las condiciones de salto se cumplen 
			jmp @@fin 
	cad1_mayor:
			mov ax,1
			jmp @@fin 
	iguales:
			mov ax,0
			
			@@fin:
			pop bp 
			ret 
		_my_strcmp endp
						
						;recibe una cadena en SI y retorna el valor en AX 
		suma_ASCII proc ;procedimineto para sacar el valor ascii total de una cadena 
		push si			
		push bx 
		push cx ;salvamos registros 
		
		mov bx,0
		mov cx,0
		mov ax,0
		
nxt:	cmp byte ptr [si+bx],00h
		je salir 
		mov ax,[si+bx] ;movemos el valor apuntado por [si+bx]
		add cx,ax 		;sumamos los valores ascii
		inc bx 
		jmp nxt
		
		salir: 
		mov ax,cx 		;retornamos el valor en AX 
		
		pop cx ;recuperamos registros 
		pop bx 
		pop si 
		ret
		endp 
		
;**************************************************		
		_my_strchr proc
		push bp 
		mov bp,sp
		mov si,[bp+4]	;str1
		mov ax,[bp+6]	;caracter 
		mov bx,0		;inicializamos bx en 0
		
buscar:	cmp byte ptr [si+bx],00h	;verificamos si llegamos al final
		je no_esta 					;si es NULL no esta la letra
		cmp byte ptr [si+bx],al		;movemos un caracter a al
		je retornar					;si lo encuentra retorna
		inc bx 						;incrementamos la siguiente pos
		jmp buscar 					
	no_esta:
		mov ax,0					;retornamos un 0
		jmp bye
	retornar:
		add si,bx					;sumamos el offset de BX
		mov ax,si;retornamos la direccion donde se encontro el valor 
		bye:
		pop bp 			
		ret
		_my_strchr endp
	end 