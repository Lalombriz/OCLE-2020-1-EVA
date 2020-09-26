#include <stdio.h>

int main ( void )
	{
		char * msg1 = "Ingresa un numero:";
		char * msg2 = "Ingresa una base:";
		char * msg3 = "El numero en la base elegida es:";
		int numero;
		int base;
		printf("\n%s", msg1);
		scanf("%d", &numero);
		printf("%s", msg2);
		scanf("%d", &base);
		printf("\n%s", msg3);
		
		/* Codigo en ensamblador en linea */
		/*Codigo que recibe una palabra dada en AX y la base a convertir en BX*/
 		asm mov ax,numero 	/*le mandamos al registro ax el numero*/
		asm mov bx,base		/*le mandamos al registro bx la base*/
		
		asm mov cx,0 
		asm mov dx,0
 whil:
		asm cmp ax,0
		asm je end_whil
		asm div bx 		/*dividimos el numero con la base ingresada */
		asm push dx 	/*;guardamos el resuduo a la pila*/
		asm inc cx 		/*;incrementamos cx para hacer uso de un loop*/
		asm xor dx,dx	/*;ponemos en cero dx*/
		asm jmp whil 
 end_whil: 
 nxt: 
		asm pop dx 		/*;sacamos el residuo de la pila*/ 
		asm add dx,30h	/*;ajustamos a ascii*/
		asm cmp dx,'9' 	/*;comparamos el numero con un 9 */
		asm jbe print 
		asm add dx,7h	/*;si es mayor a 9 lo ajusta para imprimir las letras correspondientes a HEX*/
 print:
		asm mov al,dl	/*;mandamos el dato a desplegar al registro al*/
		asm mov ah,02h;
		asm int 21h
		asm loop nxt
		
		return 0;
	}
