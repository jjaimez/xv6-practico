#include "types.h"
#include "stat.h"
#include "user.h"

#define N  2

int s; 
static int k;

void task(int *k) {
  int i,j;
  for (i=0; i<100; i++)
    for (j=0; j<100; j++){
	  semdown(s);
      k++;
	  semup(s);
	}
}


int
main(int argc, char *argv[])
{
   int  pid, n; 
   s = semget(-1,1);

	for(n=0; n<N; n++){
    pid = fork(); 
    if(pid < 0){
    	task(&k);
    }  
    if(pid == 0)
      exit();
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1,"%d", k);	

  exit();
}