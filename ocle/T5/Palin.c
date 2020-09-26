#include <stdio.h>

int main(void)
{
	char * msg = "Ingrese una frase:";
	char * str[64];
	char * resSI = "Es palindroma";
	char * resNo = "No es palindroma";
	
	printf("\n%s",msg);
	scanf("%s", str);
	/*Codigo de ensamblador en linea 
	programa que verifica si una palabra es palindroma o no*/
	asm mov ax,0
	asm mov si,0
	asm push ax 
	
	
	nll:
	asm cmp byte ptr [str+si],00h
	asm je verificar 
	asm push [str+si]
	asm inc si
	asm jmp nll
	verificar:
	asm mov si,0
	nxt:
	asm pop ax 
	asm cmp ax,0
	asm je es_p
	asm cmp byte ptr [str+si],al
	asm jne no_Es
	asm inc si
	asm jmp nxt
	es_p:
	printf("\n%s",resSI);
	asm jmp fin
	
	no_Es:
	printf("\n%s",resNo); 
	fin:
	return 0;
}
