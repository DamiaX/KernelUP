#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int i;

int main (int argc, char *argv[])
{
if ( system("kernelup -k -n") != 0 ) 
{
return 1;
}
for( i = 1; i <= 2; )
{
sleep (3600);
if ( system("kernelup -k -n") != 0 ) 
{
return 1;
}
	return 0;
}
