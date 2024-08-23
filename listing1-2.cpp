#include <stdio.h>

extern "C"
{
void asmFunc(void);
};

int main(void)
{
	printf("Calling asmMain:\n");
	asmFunc();
	printf("Returned from asmMain\n");}