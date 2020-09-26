extern void myputchar( char x);

char * str = {"Hola Mundo!!\n"};

void main (void)
{
	while(*str)
	{
		myputchar(*str++);
	}
	getchar();
}