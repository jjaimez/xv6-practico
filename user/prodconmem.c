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
   char* mem= 0;
  shm_get(k,&mem);
 
  

  *mem = 17;
  
 printf(1,"leo desde el padre la memoria %x \n",(uint)&mem);


  for(n=0; n<1; n++){
    pid = fork(); 
    if(pid == 0){
       char* memFork=0;
      shm_get(k,&memFork);
    // printf(1,"leo desde el hijo %d  \n",*memFork);
      *memFork=3;
      //printf(1,"modifico desde el hijo %d  \n",*memFork);
      pid = fork(); 
      if(pid == 0){
        char* memFork2=0;
        shm_get(k,&memFork2);
        //printf(1,"leo desde el nieto %d  \n",*memFork2);
        *memFork2=6;
        //printf(1,"modifico desde el nieto %d  \n",*memFork2);
        shm_close(k);
        exit();
      }else{
          wait();
          //printf(1,"leo desde el hijo lo del nieto %d  \n",*memFork);
          shm_close(k);
      exit();
        
    }       
      
    }
    else{
        for(n=0; n<1; n++){
          wait();
        }
    }       
  }
  printf(1,"leo desde el padre %d  \n",*mem);
  shm_close(k);
  exit();
}    