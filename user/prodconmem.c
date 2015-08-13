#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  1


void consumer (int sFactory, int sConsumer, int key, int pid){

  int i;
  char* memConsumer= 0;
  shm_get(key,&memConsumer);
  int j = 0;
  while (j<20){    
    semdown(sConsumer);
    semdown(sFactory);
    *memConsumer= ((int)*memConsumer) -1;
    printf(1," valor en celda=%d consumidor= %d \n",*memConsumer,pid); 

    i = 0;
    while (i<1000){ //para demorar un poco la escritura y hacerlo más lento
      i++;
    }
    semup(sFactory);
    j++;
  }   
}


void producer (int sFactory, int sConsumer, int key, int pid){
  int i;
  int j = 0;
  char* mem=0;
  shm_get(key,&mem);


  while (j<20){
    i = 0;
    while (i<1){//hago tiempo
      i++;
    }
    semdown(sFactory);
    *mem= ((int)*mem)+1;
    printf(1," valor en celda=%d  productor= %d \n",*mem,pid); 
    semup(sFactory);
    semup(sConsumer); 
    j++;
  }    
  
}


/*
int
main(int argc, char *argv[])
{
  int n,pid;
  int k = shm_create(1);
  char* mem= 0;
  shm_get(k,&mem);
  *mem = 17;
  for(n=0; n<1; n++){
    pid = fork(); 
    if(pid == 0){
      char* memFork=0;
      shm_get(k,&memFork);
      printf(1,"leo desde el hijo %d  \n",*memFork);
      *memFork=3;
      printf(1,"modifico desde el hijo %d  \n",*memFork);
      pid = fork(); 
      if(pid == 0){
        char* memFork2=0;
        shm_get(k,&memFork2);
        printf(1,"leo desde el nieto %d  \n",*memFork2);
        *memFork2=6;
        printf(1,"modifico desde el nieto %d  \n",*memFork2);
        shm_close(k);
        exit();
      }else{
          wait();
          printf(1,"leo desde el hijo lo del nieto %d  \n",*memFork);
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
*/

int
main(int argc, char *argv[])
{
int sConsumer,sFactory,pid,n,k; 

  sFactory= semget(-1,1); //creo los semaforos
  sConsumer= semget(-1,0);
  k = shm_create(1); //creo un espacio de memoria compartido
  char* mem= 0;
  shm_get(k,&mem); //obtengo el espacio en el padre
  *mem = (int)10; // lo inicio con cero

for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      consumer(sFactory,sConsumer,k,getpid());
      semfree(sFactory);
      semfree(sConsumer);
      shm_close(k);
      exit();
    }       
  }  


  for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      producer(sFactory,sConsumer,k,getpid());
      semfree(sFactory);
      semfree(sConsumer);
      shm_close(k);
      exit();
    }       
  }
 

  for(n=0; n<N*2; n++){
    wait();
  }
  semfree(sFactory);
  semfree(sConsumer);
  shm_close(k);
  exit();
}