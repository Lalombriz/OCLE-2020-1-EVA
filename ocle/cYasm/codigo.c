#include <stdio.h>
extern int shr_s(int32_t dato);
int main()
{
int32_t result=0;
int32_t numero=0;
printf("Ingrese un numero:");
scanf("%d",&numero);
result=shr_s(numero);

printf("nuemro resultante: [%d]",result);



}