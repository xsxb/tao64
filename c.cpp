#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//extern "C" namespace prevents "name mangling" by the C++ compiler
extern "C"
{
	void asmMain(void);
	char *getTitle(void);
	int readLine(char *dest, int maxLen); //C++ function for the asm language program call
};

int readLine(char *dest, int maxLen)
{
	char *result = fgets(dest, maxLen, stdin);
	if(result != NULL)
	{
		//Remove \n
		int len = strlen(result);
		if(len > 0)
		{
			dest[len - 1] = 0;
		}
		return len;
	}
	return -1; //error
}

int main(void)
{
	try
	{
		char *title = getTitle();
		
		printf("Calling %s:\n", title);
		asmMain();
		printf("%s terminated\n", title);
	}
	catch(...)
	{
		printf
		(
			"Exception occured during program execition\n"
			"Abnormal program termination.\n"
		);
	}
}