#include <stdio.h>
int main()
{
    char cad[12];
    printf("programa en ensamblador en liinea que verifica una direccion MAC valida...\n")
    printf("Cpature una direccion mac con el siguiente formato...\n");
    printf("xx:xx:xx:xx:xx:xx\n")
    scanf("%s",cad);
    

    asm mov dx,offset cad 
    asm call isMaac 
    

    asm cmp ah,1
    asm jne noomac 
    printf("Es una direccion mac valida");
    asm jmp endd 
    asm noomac: 
    printf("No es una direccion mac valida ");
    asm jmp endd2
    asm isMaac proc 
    asm push dx 
    asm push si
    asm push cx

    asm xor cx,cx
    asm mov si,dx
    asm add dx,2 

    asm push si 
    asm @@cuenta: 

    asm cmp byte ptr[si],0
    asm je @@fincad 
    asm inc cx 
    asm inc si
    asm jmp @@cuenta 

    asm @@fincad:
    asm cmp cx,17 
    asm jne @@noMac 

    asm xor cx,cx  

    asm @@checkCad: 
    asm cmp byte ptr[si],0
    asm je @@endCheckCad
    asm inc cx

    asm cmp cx,3
    asm jne @@chekChar 
    asm xor cx,cx
    asm cmp si,dx 
    asm jne @@contnue 
    asm al,[si]
    asm cmp al,':'
    asm je @@next 
    asm cmp al,'-'
    asm  jne @@noMac 
    asm jmp @@next 
    asm @@contnue: 
    asm cmp byte ptr [si],al
    asm jne @@noMac 
    asm jne @@next 
    asm @@checkChar:
    asm cmp byte ptr [si],'0'
    asm jb @@noMac 
    asm cmp byte ptr [si],'9'
    asm jbe @@next 
    asm cmp byte ptr [si],'A'
    asm jb @@noMac
    asm byte ptr [si],'F'
    asm jbe @@next 
    asm byte ptr [si],'a'
    asm jb @@noMac 
    asm byte ptr [si],'f'
    asm ja @@noMac 
    asm next: inc si 
    asm jmp @@checkCad 
    asm @@endCheckCad:

    asm @@isMac: 
    asm mov ah,1
    asm jmp salida
    asm @@noMac: 
    asm mov ah,0
    asm @@salida:
    asm pop cx
    asm pop si 
    asm pop dx  
    asm ret 
    asm end

    asm endd: 
    asm endd2
    return 0;
}