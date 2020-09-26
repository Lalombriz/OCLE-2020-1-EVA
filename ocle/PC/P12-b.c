#include <stdio.h>
char * my_strchr (char * str, char c);


char str[64];
char caracter;
char * pos;
int main (){
	printf("Ingresa una cadena: ");
	scanf("%s", str);
	setbuf(stdin,NULL);
	printf("Ingresa un caracter: ");
	scanf("%c", &caracter);
	
	printf ("\nBuscando el caracter %c en %s...\n",caracter, str);
	pos = my_strchr(str,caracter);
	printf("\n\n\n");
	if(pos == 0){
		
		printf("No esta el caracter esperado para la busqueda..\n");
		
	}else{
	while (pos != 0)
	{
	 printf ("se encontro a partir de %s\n",pos);
	 pos = my_strchr(pos+1,caracter);
	}
	}
printf ("fin de la busqueda");

}