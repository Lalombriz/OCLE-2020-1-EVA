#include <stdio.h>
extern int ConjeturaDeCollatz(int x);

int a = 17, iter;
int main(void)
{
	iter = ConjeturaDeCollatz(a);
	printf("Se hicieron %d iteraciones para el numero %d", iter,a);
}