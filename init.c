#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int i;

int main (int argc, char *argv[])
{
system("kernelup -k -n");
for( i = 1; i <= 2; )
{
sleep (3600);
system("kernelup -k -n");
}
	return 0;
}
