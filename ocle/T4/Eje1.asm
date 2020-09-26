;Fibonacci 
;retorna en AN el n-esimo termino de la secuencia de fibonacci
;donde n es indicado por AX 

.MODEL SMALL 
	.STACK 100H
	INCLUDE PROCS.INC 
	LOCALS
	.DATA 
	MENS DB 10,13,"SERIE DE FIBONACCI EN ENSAMBLADOR.",0
	MENS2 DB 10,13,"FIBONACCI:",0
	CAD DB 6 DUP(0)
	.CODE 
	PROGRAMA PROC 
	MOV AX,@DATA
	MOV DS,AX	;INICIALIZACION DEL SEGMENTO DE DATOS.
	
	

	XOR AX,AX 	;ASEGURAMOS EL REGISTRO EN 0 YA QUE LO USAREMOS CON FIB
	MOV DX,OFFSET MENS
	CALL PUTS
	
	MOV AX,25	;DATO QUE SE MANDA A FIBONACCI 
	CALL FIB
	
	MOV DX,OFFSET MENS2 ;MENSAJE 2
	CALL PUTS 
	MOV SI,OFFSET CAD 	;CONVERTIMOS EL DATO DE AX A CADENA 
	CALL ITOA 
	MOV DX,OFFSET CAD 	;LO IMPRIMIMOS 
	CALL PUTS 
	
	MOV AH,04CH	;FINALIZACION DEL PROGRAMA.
	MOV AL,0
	INT 21H
	ENDP 
	
	FIB PROC
		;RECIBE EN AX EL NUMERO DE FIBONACCI QUE SE QUIERE OBTENER Y LO REGRESA EN AX 

		CMP AX,1 
		JNL @@NO_B
		;CASO BASE
		MOV AX, 1
		RET

		@@NO_B:
		; RECURSION 
		PUSH BX
		PUSH CX
		;HACEMOS UNA COPIA DEL VALOR DE FIBONACCI EN BX 
		MOV BX, AX
		;HACEMOS EL FIB DE (N-1)
		ADD AX,-1	;LE RESTAMOS 1 AL FIB 
		CALL FIB
		;SALVAMOS EL VALOR EN CX 
		MOV CX,AX
		;HACEMOS EL FIB(N-2)
		MOV AX,BX
		ADD AX, -2	;LE RESTAMOS 2 AL FIB 
		CALL FIB
		; EN AX TENEMOS EL FIB(N-2)
		; LE SUMAMOS EL FIB(N-1) Y RETORNAMOS EL RESULTADO 
		; en AX.
		ADD AX,CX
		POP CX
		POP BX

	RET 
	ENDP

;PROCEDIMINETO DEL ITOA RECIBE EL DATO PR AX 
		itoa proc
		push ax		;salvamos registros
		push dx
		push bx
		push si
		push cx
		
		xor bx,bx	;limpiamos el registro BX
		xor dx,dx	;limpiamos el registro DX
		mov cx,0	;movemos el 0 a CX
		mov bx,10	;movemos el 10 decimal a BX
@@nxt:	div bx		;dividimos DX-AX/BX
		push dx		;el residuo lo enviamos a la pila
		mov dx,0	;limpiamos el registro DX
		inc cx		;incrementamos CX para llevar el conteno de unidades, decenas, centenas, etc
		cmp ax,0h	;verificamos si el cociente es 0, si lo es ya no hay dato que convertir
		jne @@nxt	;saltamos a la etiqueta nxt
		
@@fin:	pop bx		;hacemos pop del ultimo dato que seria el mas significativo en decimal
		add bx,30h	;le sumamos 30h para convertirlo en ASCII
		mov [si],bl	;movemos el byte de BL al segmento de memoria DS:SI
		inc si		;incrementamos para apuntar a la siguiente direccion de la cadena
		loop @@fin	;se ejecutara loop hasta que llegue CX a 0
		mov byte ptr[si],0	;movemos en la ultima localidad el valor 0 para indicar que termina la cadena
		
		pop cx
		pop si
		pop bx
		pop dx
		pop ax
		ret
		endp	
	
END