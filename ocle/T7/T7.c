#include <stdio.h>
extern int isograma(char *);
char * str ={"dermatoglyphics"};
int c;

int main()
{
	c= isograma(str);
	
	if(c==1){
	printf("%s es isograma\n",str);
	}else if(c==0){
	printf("%s No es isograma\n",str);
	}
}
