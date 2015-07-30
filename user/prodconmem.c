#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  2

/*
void consumer (int sFactory, int sConsumer, int pid, char path[]){
  int i,k,fd;

  int j = 0;
  while (j<5){    
    semdown(sConsumer);
    semdown(sFactory);
    fd = open(path, O_RDWR);  
    read(fd, &k, sizeof(k));
    k--;
    printf(1," k=%d consumer= %d \n",k,pid); 
    fseek(fd,0);
    write(fd, &k, sizeof(k));
    close(fd);
    i = 0;
    while (i<1000){
      i++;
    }
    semup(sFactory);
    j++;
  }   
}


void producer (int sFactory, int sConsumer, int pid, char path[]){
  int i,k,fd;
  int j = 0;
  while (j<5){
    i = 0;
    while (i<100000){
      i++;
    }
    semdown(sFactory);
    fd = open(path, O_RDWR);
    read(fd, &k, sizeof(k));
    k++;
    printf(1," k=%d producer= %d \n",k,pid); 
    fseek(fd,0);
    write(fd, &k, sizeof(k));
    close(fd);
    semup(sFactory);
    semup(sConsumer); 
    j++;
  }         
}
*/


int
main(int argc, char *argv[])
{
  int n,pid;
  int k = shm_create(1);
  char* mem= 0 ;
  shm_get(k,&mem);
  *mem= 17;
  char* mem2=0;
  shm_get(k,&mem2);
  printf(1,"geeet %d \n",*mem2);
  for(n=0; n<1; n++){
    pid = fork(); 
    if(pid == 0){
      char* memFork=0;

      shm_get(k,&memFork);
      printf(1,"geeet %d  \n",*memFork);
      *memFork=3;
      shm_close(k);
        printf(1,"close ");
      exit();
    }
    else{
        for(n=0; n<1; n++){
          wait();
        }
    }       
  }
  
  shm_close(k);
  exit();
}    