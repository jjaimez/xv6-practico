
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
  if(fork()==0){
    recursive(250);
    printf(1,"finish 1 \n");
    exit();
  } else {
  wait();
  recursive(250);
  printf(1,"finish 2 \n");
  printf(1,"the next execution maybe not work (trap 14) \n");
  recursive(500);
  printf(1,"finish 3 \n");
  exit();
  }
}
