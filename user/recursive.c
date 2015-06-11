//recursive fibonacci

#include "types.h"
#include "stat.h"
#include "user.h"


int
recursive(int n)
{  
  int r = 0;
  if (n>1){
    r = recursive(n-1) ;
    return r;
  } 
  else
    return 1;         
}

int
main(int argc, char *argv[])
{
  recursive(250);
  printf(1,"finish 1 \n");
  printf(1,"the next execution maybe not work (trap 14) \n");
  recursive(300);
  exit();
}