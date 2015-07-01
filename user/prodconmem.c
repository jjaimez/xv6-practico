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

  
 int k = shm_create(1);
  void ** mem = 0 ;
  shm_get(k,*mem);


  exit();
}    