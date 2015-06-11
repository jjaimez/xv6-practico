//Count ten million	

#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int i = 0;
  while (i<10000000){
    i++;
  }
  procstat(); //print all process (this process ends with priority 3)
  exit();
  }