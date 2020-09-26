.MODEL SMALL
	.STACK 100H
	INCLUDE PROCS.INC 
	LOCALS
	.DATA 
		mens db "--------------------",10,13,"     RELOJ     ",10,13,"--------------------",10,13,0
		sep db ":",0
		tics db  0
		flagSeg db 0
		segundos db 0
		minutos db 0
		horas db 0
		
	.CODE 
	PRINCIPAL PROC 
	MOV AX,@DATA
	MOV DS,AX
	
	call setISR
	call init_clock
	
	@@nxt:
	cmp byte ptr[flagSeg],1
	jne @@end_if
	call updateClock
	call printClock
	mov byte ptr[flagSeg],0
@@end_if:
	jmp @@nxt
	MOV AH,04CH
	MOV AL,0
	INT 21H
	RET 
	ENDP
	
	convert_num proc	;procedimiento que me convierte los numeros 
	push ax				
	push dx
	push cx
	xor ah,ah
	mov cl,10 			;movemos un 10 a cx para usarlo para dividir 
	div cl				;dividimos entre 10 el numero 
	add al,30h			;le sumamos 30 para ajustar el numero a su valor real 
	call putchar		;lo imprimimos 
	xchg al,ah 			;intercambiamos los valores 
	add al,30h			;lo ajustamos otra vez 
	call putchar		;se vuelve a imprimir 
	
	pop cx
	pop dx
	pop ax
	ret
	endp
	
	init_clock proc		;procedimiento para inicializar mis variables en 0
	mov byte ptr [segundos],50 	;hice una prueba de que si se reiniciara el reloj y si lo hizo
	mov byte ptr [minutos],59
	mov byte ptr [horas],23
	ret
	endp
	
	printClock proc		;procedimiento para imprimir el reloj digital
	call clrscr
	mov dx,offset mens
	call puts
	mov al,[horas]
	call convert_num 	;desplegamos horas
	mov dx,offset sep	;mandamos direccion del separador 
	call puts			;desplegamos separados 
	mov al,[minutos]
	call convert_num	;desplegamos minutos
	call puts 			;desplegamos separador 
	mov al,[segundos]
	call convert_num
	ret
	endp

	updateClock proc			;funcion para actualizar el reloj 
	cmp byte ptr [flagSeg],1	;bandera que verifica si hay segundos
		jne @@else_if
		inc byte ptr[segundos]
@@else_if:cmp byte ptr [segundos],60
		  jne @@else_if2
		  mov byte ptr [segundos],0
		  inc byte ptr [minutos]
@@else_if2:cmp byte ptr [minutos],60
		  jne @@else_if3
		  mov byte ptr [minutos],0 
		  inc byte ptr [horas]
@@else_if3:cmp byte ptr [horas],24
		  jne @@end_if 
		  mov byte ptr [horas],0
@@end_if:
	ret
	endp
	
	setISR proc
		push ds
		push ax
		mov ax,0
		mov ds,ax 
		mov bx,1ch
		shl bx,1
		shl bx,1	;hacemos corrimientos para multiplicar por 4
		mov word ptr [bx],offset updateax	;colocamos en el vector de interrupciones nuestro ISR
		mov word ptr [bx+2],cs
		pop ax
		pop ds
		ret
	endp

	updateax proc	;este nos sirve para contar los tics que se necesitan para contar un segundo 
		cmp byte ptr[tics],18 ;lo comparamos con 18 tics ya que son los que se ocupan para 1 segundo 
		jne @@end_if
		mov byte ptr[tics],0h	;limpiamos la variable tics ya que tenemos 1 segundo
		mov byte ptr[flagSeg],1	;si ya paso un segundo retornamos un 1 
@@end_if:inc byte ptr[tics]		;sirve para incrementar la variable tics para contar los segundos 
		iret
	endp
	
END