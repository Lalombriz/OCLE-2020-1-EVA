#include <stdio.h>
extern int my_substr(char *fuente, char *destino, char *posicion, int cantidad);
extern int my_erase(char *cadena, char *posicion,int cantidad);

char * cad= {"Hola Mundo!!!\n"};
char * cad2= {"Hola Mundo!!!\n"};
char destino[32];
int res;
int main(void)
{
	res = my_erase(cad,cad+6,2);
	printf("Se borraron %d caracteres y la cadena resultante es: %s",res,cad);
	
	res = my_substr(cad2,destino,cad2+2,2);
	printf("Se copiaron %d caracteres y la cadena resultante es: %s",res, destino);
}
