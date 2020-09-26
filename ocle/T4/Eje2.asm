;Factorial.
.MODEL SMALL 
	.STACK 100H
	INCLUDE PROCS.INC
	LOCALS
	.DATA 
	MENS DB 10,13,"PROGRAMA QUE REALIZA EL FACTORIAL DE UN N NUMERO",10,13,0
	MENS2 DB 10,13,"EL FACTORIAL ES:",0
	CAD DB 5 DUP(0)
	.CODE 
		PROGRAMA PROC 
		MOV AX,@DATA
		MOV DS,AX	;INICIO DEL SEGMENTO DE DATOS 
		
		;CODIGO 
		XOR AX,AX	;ASEGURAMOS AX EN 0 
		XOR CX,CX 	;ASEGURAMOS EL VALOR DE CX EN 0
		MOV DX,OFFSET MENS 
		CALL PUTS 
		;INGRESAMOS EL NUMERO EN EL REGISTRO DESEADO QUE ES CX Y LO RETORNARA EN AX
		MOV CX,9
		CALL FACT ;LLAMAMOS LA FUNCION FACTORIAL RECIBE EL VALOR POR CX 
		
		;IMPRESION DEL CARACTER DE FACTORIAL 
		MOV DX,OFFSET MENS2
		CALL PUTS 
		MOV SI,OFFSET CAD
		CALL ITOA
		MOV DX,OFFSET CAD
		CALL PUTS 
		
		MOV AH,04CH	;FINALIZACION DEL PRIGRAMA 
		MOV AL,0
		INT 21H
		
		ENDP
		FACT PROC 
		;PRODEDIMIENTO DEL FACTORIAL.
		;HACEMOS LAS COMPARACIONES PARA EL FACTORIAL
		
		CMP CX,AX	;VERIFICAMOS SI AX ES MENRO A CX SI LO ES OBTIENE EL VALOR DE CX SI NO LO ES NO LO TOMA
		JBE @@INICIA
		MOV AX,CX 
@@INICIA:CMP CX,1	;CASO UNO EN DONDE N=0 SIEMPRE ES 1
		JNE @@CASO_2
		MUL CX 		;MULTIPLICAMOS EL VALOR DE CX POR AX  
		JMP @@FIN 
@@CASO_2:			;CASO 2 DONDE N ES MAYOR A 1 
		
		DEC CX 		;DECREMENTAMOS CX PARA MULTIPLICARLO CON EL VALOR DE AX
		MUL CX 		;MULTIPLICAMOS AX
		CALL FACT
@@FIN:
		
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