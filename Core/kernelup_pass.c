//Copyright © 2015 Damian Majchrzak (DamiaX)
//http://damiax.github.io/kernelup/

#include <stdio.h>

void hide(char *text)
{
  int iPrzes = 0, iOile[3] = {3, 1, 2};
  for (int i=0; text[i] != 0; i++)
  {
      text[i] = ( text[i] + iOile[iPrzes] );
      iPrzes ++;
      if(iPrzes == 3 ) iPrzes = 0;
  }                                           
} 

int main(int argc, char *argv[])
{
  hide(argv[1]);
  printf(argv[1]);
 }
