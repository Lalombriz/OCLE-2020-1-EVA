#include <stdio.h>

extern int my_strcmp(char *str1,char *str2);

char str1 [32];
char str2 [32];
int res;
int main(void)
{
	printf("Ingresa una cadena: ");
	scanf("%s", str1);
	printf("Ingresa otra cadena: ");
	scanf("%s", str2);
	res = my_strcmp(str1, str2);
	if(res < 0)
	 printf("La primer cadena es menor");
	else if(res > 0)
	 printf("La primer cadena es mayor");
	else
	 printf("Las cadenas son iguales");
}