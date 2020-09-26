.MODEL SMALL 
	.STACK 100H
	INCLUDE PROCS.INC 
	LOCALS
.DATA
	mens_ascii db "AL desplegado en ASCII:",0
	mens_bin db "AL desplegado en Binario:",0
	mens_dec db "AL desplegado en Decimal:",0
	mens_hex db "AL desplegado en Hexadecimal:",0
	mens     db "probando la funcion atoi   ",0
	num db "1234",0
	mens2 db "AX=1234 y en HEX AX=04D2",0
	mens3 db "Programa que detecta si un numero Almacenado en AX es Automorfico:",0
	mens4 db "Es automorfico",0
	mens5 db "No es automorfico",0
	new_line db 10,13,0
.CODE 
	Principal PROC 
		mov ax,@data
		mov ds,ax
		call clrscr
		
		mov ax,94ah
		mov bx,8
		call printNumBase
		
		;mov dx,offset mens3
		;call puts
		;mov dx,offset new_line
		;call puts 
		;mov dx,44
		;call esAutomorfico
		;cmp ax,1
		;jne @@fin 
		;mov dx,offset mens4
		;call puts 
		;@@fin:
		;mov dx,offset mens
		;call puts 
		;mov bx,offset num		;mandamos el offset de la cadena por BX
		;call atoi 				;llamamos la funcion atoi
		;cmp ax,1234				;comparamos el dato convertido a decimal con atoi
		;jne @@FIN				;si el dato no es el mismo que el de la cadena se termina el programa
		;mov dx,offset mens2		;caso contrario imprime que el dato si es igual
		;call puts 
		
		;mov dx,offset new_line
		;call puts
		
		;mov al,92h				;dato a desplegar
		;mov dx,offset mens_ascii
		;call puts
		;call putchar			;imprime AL en ASCII
		
		;mov dx,offset new_line
		;call puts
		
		;mov dx,offset mens_bin
		;call puts 
		;call printBin			;imprime en binario
		
		;mov dx,offset new_line
		;call puts
		
		;mov dx,offset mens_dec
		;call puts 
		;call printDec			;despliega AL en decimal
		
		;mov dx,offset new_line 
		;call puts
		
		;mov dx,offset mens_hex
		;call puts
		;call printHex			;despliega AL en Hexadecimal
		;@@FIN:
		
		mov ah,04ch
		mov al,0
		int 21h
		ret 
		ENDP
	;-----procedimientos------
;Procedimineto que recibe una palabra dada en AX y la base a convertir en BX
	printNumBase PROC
		push ax 
		push bx 
		push cx	
		push dx	 
 				
		mov cx,0 
		mov dx,0
@@while:cmp ax,0
		je @@end_while
		div bx 		;dividimos el numero con la base ingresada 
		push dx 	;guardamos el resuduo a la pula
		inc cx 		;incrementamos cx para hacer uso de un loop
		xor dx,dx	;ponemos en cero dx 
		jmp @@while 
@@end_while: 
@@nxt: 
		pop dx 		;sacamos el residuo de la pila 
		add dx,30h	;ajustamos a ascii
		cmp dx,'9' 	;comparamos el numero con un 9 
		jbe @@print ;
		add dx,7h	;si es mayor a 9 lo ajusta para imprimir las letras correspondientes a HEX
@@print:mov al,dl	;mandamos el dato a desplegar al registro al 
		call putchar;
		loop @@nxt
		
		pop dx
		pop cx
		pop bx
		pop ax
		ret 
	ENDP
;*************************************************************
;procedimiento que detecta si un numero es automorfico recibe una palabra en DX  
;si lo ex AX retorna 1 si no lo es 0
	esAutomorfico PROC 
		push bx
		push cx 	;salvamos registros a utilizar 
		xor ax,ax	;aseguramos el registro AX en cero 
		xor bx,bx	;aseguramos BX en cero
		mov ax,dx 	;movemos el valor de DX a AX 
		mov bx,dx 	;respaldamos el dato de DX en BX 
		mov cx,10 	;movemos un 10 al registro para hacer diviciones de 10
		cmp ax,9	;comparamos el numero ingresado que sea menor que 9 para poder hacer diviciones de 10
		ja @@nxt	;si esta arriba es que ax es mayor a 9
		mul ax 		;elevamos el numero almacenado en ax^2
		div cx 		;dividimos el numero por 10 
		cmp bx,dx	;comparamos el residuo que esta en DX con BX si es igual sigue el pricedimiento 
		jne @@no_es 
		mov ax,1	;es amorfico 
		jmp @@si_es
@@nxt:   cmp ax,99	;comparamos el numero con 99 para dividirlo entre 100 si es menor se divide entre 100
		ja @@nxt1	;si no es verificamos el numero con millares
		mov cx,100	;movemos un 100 a cx para dividirlo 
		mul ax		;elevamos ax^2
		div cx		;dividimos el numero entre 100
		cmp bx,dx 	;comparamo el numero original con el residuo 
		jne @@no_es	;si no es igual mandamos un 0 por AX 
		mov ax,1	;si lo es mandamos un 1 
		jmp @@si_es
@@nxt1:	cmp ax,999	;comparamos el numero con 999 para dividirlo entre 1000 si es menor se divide 
		ja @@nxt2
		mov cx,1000	;movemos a cx 1000
		mul ax		;elevamos ax^2
		div cx		;lo dividimos entre 1000
		cmp bx,dx	;comparamos si el numero anteriomente ungresado es igual a el resuduo 
		jne @@no_es
		mov ax,1
		jmp @@si_es
@@nxt2:	cmp ax,9999
		ja @@no_es	;brincamos direcctamente a no es por que nuestro procesado nos limita a dos bytes
		mul ax		;se eleva al AX^2 y como resulta a una multiplicacion de 16 bits nos de un num de 32 DX-AX
		and ax,2400
		or ax,24A0h
		;limitamos esta parte a que solo acepte como automorfico el numero 9376 ya que seria el limite aceptado 
		;por el x8086
		cmp ax,bx 	;siendo AX el que almacena los 4 bits menos significativos del numero 
		jne @@no_es	;si no es igual mandamos un 0 
		mov ax,1
		jmp @@si_es	; si es igual sale un 1
		
		
@@no_es:	
		mov ax,0	;si no es amorfico se retorna un cero 
@@si_es:		
		pop cx
		pop bx
		ret
	ENDP
;*************************************************************
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
;*********************************************
	
	printBin PROC
		push ax		;salvamos el registro a utilizar
		push cx
		mov cx,8	;inicializamos el conteo en 8
		mov ah,al 	;AH sera el registro a desplegar
@@nxt:  mov al,'0'	;prepara AL para imprimir ASCII
		shl ah,1	;Pasar el MSB de AH a la bandera de acarreo
		adc al,0		;sumar a AL el valor del acarreo
		call putchar
		loop @@nxt	;continuar con el proximo bit 
		pop cx		;recuperamos los registros utilizados
		pop ax
		ret
		ENDP
;**********************************************

	printDec PROC
		push ax		;registros a utilizar
		push bx
		push cx
		push dx
		mov cx,3	;iniciamos el conteo a 3 (cent-dec-unida)
		mov bx,100	;iniciar con centenas
		mov ah,0	;asegurar AH = AL
@@nxt:	mov dx,0	;asegurar DX=0 para usar div reg16
		div bx 		;dividir DX:AX entre BX
		add al,'0'	;convertir el cociente a ASCII
		call putchar;desplegamos digito en pantalla 
		mov ax,dx	;pasar residuo (DX) a AX
		push ax 	;salvar temporalmente AX
		mov dx,0	;Ajustar divisor para nuevo digito 
		mov ax,bx 	;La idea es:
		mov bx,10 	;			BX = BX/10
		div bx		;
		mov bx,ax	;pasar el cociente al BX par nuevo digito
		pop ax		;recuperar AX
		loop @@nxt	;proximo digito
		pop dx
		pop cx
		pop bx
		pop ax
		ret
		ENDP
;****************************************************
	printHex PROC 
		push ax 	;salvar registros a utilizar
		push bx 
		push cx
		mov ah,0	;asegurar AX = AL
		mov bl,16	;
		div bl 		;dividir AX/16 --> cociente en AL y residuo AH
		mov cx,2	;para imprimir dos digitos Hex 
@@nxt:  cmp al,10	;verificar si el cociente de al es 10
        jb @@print 
		add al,7
@@print:add al,30h	;si es menos a 10 sumar 30h de lo contrario 37h
		call putchar
		mov al,ah	;pasa el resuduo (AH) a AL para imprimirlo
		loop @@nxt 	;proximo digito 
		pop cx
		pop bx
		pop ax		;recuperar registros utilizados 
		ret
		ENDP
	end
		