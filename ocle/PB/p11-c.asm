.model small 
	.stack 100h
	include procs.inc 
	locals
	.data
	mens db 10,13,"Archivo escrito",0
	AECHIVO_2 DB 30 DUP(0)		;NOMBRE DEL ARCHIVO A ABRIR, Y TEXTO A ESCRIBIR 
	
	.code
	main proc 
	mov ax,@data
	mov ds,ax
	
	mov si,offset AECHIVO_2 
	call parametros			;MANDAMOS LA CADENA DONDE VAMOS ALMACENAR LOS APRAMETROS
	
	mov si,0				;INICIALIZAMOS EL INDICE EN 0
com:cmp byte ptr [AECHIVO_2+si+12],0
	je @@nxt 
	inc si 					;CONTEO DE BYTES A ESCRIBIR 
	jmp com					;CALCULAMOS EL NUMERO DE BYTES QUE SE VAN A ESCRIBR 
@@nxt:
							;obtenemos la cantidad de bytes a escribir 
	;**************FUNCIONES DE ARCHVOS****************************************
	MOV AL,1h				;ACCESO SOLO A ESCRITURA
	MOV DX,OFFSET AECHIVO_2	;ABRIMOS LA CANEDA QUE INGRESAMOS 
	CALL ABRIR_ARCHIVO		;ABRIMOS EL ARCHIVO 
	MOV BX,AX 				;MOVEMOS EL HANDLE
	MOV CX,SI				;CANTIDAD DE CARACTERES A ESCRIBIR 
	MOV DX,OFFSET [AECHIVO_2+12];ACCEDEMOS A LA CADENA QUE GRABAREMOS EN EL ARCHIVO 
	CALL ESCRIBIR_ARCHIVO	;ESCRIBIMOS EL ARCHIVO 
	CALL CERRAR_ARCHIVO		;CERRAMOS EL ARCHIVO
	;***********************ARCHIVO ESCRITO Y CERRADO**********************
	
	MOV DX,OFFSET MENS		;IMPRIMIMOS UN MENSAJE DE QUE SE GRABO EL TEXTO
	CALL PUTS 
	mov ah,04ch
	mov al,0
	int 21h 
	endp

	;PROCEDIMINETO PARA CAPTURA DE CARACTERES DESDE LA CONSOLA 
	parametros proc
		push ax				;salvo registros a utilizar
		push di				;
		push si				;
		push bx				;
		
		mov ah,62h			;ejecutamos el servicio 62h para la obtencion de parametros
		int 21h				;
		mov di,82h			;movemos al registro di el valor 82 donde inician los parametros
		mov ah,0dh			;movemos un enter a ah
		mov bl,20h 			;movemos un espacio al bl
@@while:cmp ES:[DI],ah		;comparamos ES:[DI] con el enter
		je @@fin			;si es igual entonces termina el ciclo
		mov al,ES:[DI]		;movemos la letra hacia el registro al
		mov [si],al			;enviamos a la cadena en si la letra de al
		cmp byte ptr [si],bl
		je @@par
		continuar: 			;contnuamos con el ciclo 
		inc si				;incrementamos si para apuntar a la siguiente direccion
		inc di				;incrementamos di para apuntar a la siguiente direccion
		jmp @@while
		
@@par: 	
		mov byte ptr [si],0
		jmp continuar			;nos sirve para separar los parametros 
		
@@fin:	mov byte ptr[si],0	;movemos un 0 al final ya que asi terminan las cadenas
		pop bx				;volvemos a poner los registros como estaban
		pop si				;
		pop di				;
		pop ax				;
		endp
	;***********************************************************
	
	;**********PROCEDIMIENTO PARA ARCHIVOS EN ENSAMBLADOR*******
	ABRIR_ARCHIVO PROC 
	MOV AH,3DH	;LLAMADA PARA LA LECTURA DE UN FICHERO 
	;MOV AL,0h	;ACCESO SOLO A LECTURA 
	INT 21H 	;INTERRUPCION QUE ACTIVA EL SERVICIO DE ARCHIVOS 
				;SI SE EJECUTA CORRECTAMENTE FLAG CF=0
				;AX = HANDLE O MANEJADOR DEL ARCHIVO
	RET 
	ENDP 
;***********************************************************	
	CERRAR_ARCHIVO PROC
	MOV AH,3EH	;CIERRE DE ARCHIVO 
	INT 21H
	ENDP 
;***********************************************************	
	LEER_ARCHIVO PROC
	;PARAMETROS  QUE RECIBE 
	;BX=HANDLE 
	;CX=NUMERO DE BYTES A LEER
	;DS:DX= DESPLAZAMIENTO DEL BUFFER DONDE SE VAN A TOMAR LOS VALORES A LEER 
	MOV AH,3FH	;SERVICIO DE LECTURA DE ARCHIVO
	INT 21H		;INTERRUPCION DE EJECUCION
	;SI SE EJECUTO CORRECTAMENTE 
	;FLAG CF=0 Y EN AX=BYTES TRANSFERIDOS 
	;SI NO SE EJECUTA CORRECTAMENTE
	;FLAG CF=1 Y EN AX=CODIGO DE ERROR
	ret
	ENDP 
;***********************************************************	
	ESCRIBIR_ARCHIVO PROC
	;PARAMETROS QUE RECIBE 
	;BX=HANDLE 
	;CX=NUMERO DE BYTES A ESCRIBIR 
	;DS:DX=DESPLAZAMIENTO DEL BUFFER DONDE SE VAN A TOMAR LOS VALORES A ESCRIBIR  
	MOV AH,40H	;SERVICIO DE ESCRITURA A ARCHIVO 
	
	INT 21H		;INTERRUPCION DEL SISTEMA QUE LA HABILITA
				;SI SE EJECUTO CORRECTAMENTE 
				;FLAG CF=0 Y EN AX=BYTES TRANSFERIDOS 
				;SI NO SE EJECUTA CORRECTAMENTE
				;FLAG CF=1 Y EN AX=CODIGO DE ERROR
	ret
	ENDP
	;atoi recibe una cadena en bx y retorna el entero en AX
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
