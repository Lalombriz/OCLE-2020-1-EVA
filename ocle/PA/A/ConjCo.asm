DOSSEG 
	.model small
	.code 
		public _ConjeturaDeCollatz
		
		_ConjeturaDeCollatz proc 
			push bp
			mov bp,sp
			mov ax,[bp+4]		;recibinmos el numero
			
			
			xor bx,bx
			mov cx,0			;ierador 
			mov bl,2			;verificador de numeros pares 
			mov bh,3			;multipicar 
			
			
	verificar:					;volvemos a verificar si tenemos un 1
			cmp al,1			;verificamos si el valor que tenemos es 1 
			je conjetura_end
			inc cx 
			xor ah,ah 			;limpiamos el valor del residuo
			push ax 
			div bl 				;dividimos el numero entre 2 para verificar que sea par 
			cmp ah,0			;verificamos si el numero es par 
			jne impar 			;si no es par realizamos otra operacion
			pop ax 				;si es par recuperamos el dato 
			div bl 				;dividimos el numero par entre 2
			jmp verificar 		;y lo volvemos a verificar 
	impar:
			pop ax 				;recuperamos el numero que es impar 
			mul bh				;muliplicamos el valor de al por 3 
			add al,1
			jmp verificar
			
			conjetura_end:
			
			mov ax,cx
			
			pop bp 
			ret 
		_ConjeturaDeCollatz endp 
	end