//recursive fibonacci

#include "types.h"
#include "stat.h"
#include "user.h"


int
fibonacci(int n)
{  
  int r = 0;
  if (n>2){
    r = fibonacci(n-1) + fibonacci(n-2);
    return r;
  } 
  else if (n==2)       
    return 1;
  else if (n==1)       
    return 1;
  else if (n==0)
    return 0;
  else
    return -1;          
}

int
main(int argc, char *argv[])
{
  fibonacci(30);
  printf(1,"termino \n");
  exit();
}