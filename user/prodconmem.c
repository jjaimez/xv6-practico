#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  4


void consumer (int sFactory, int sConsumer, char* memConsumer, int pid){

  int i;
  int j = 0;
  while (j<5){    
    semdown(sConsumer);
    semdown(sFactory);
    *memConsumer= ((int)*memConsumer) -1;
    printf(1," valor en celda=%d consumidor= %d \n",*memConsumer,pid); 

    i = 0;
    while (i<5000){ //para demorar un poco la escritura y hacerlo más lento
      i++;
    }
    semup(sFactory);
    j++;
  }   
}


void producer (int sFactory, int sConsumer, char* mem, int pid){
  int i;
  int j = 0; 
  while (j<5){
    i = 0;
    while (i<5000){//hago tiempo
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
  *mem = (int)0; // lo inicio con cero

//creo otro espacio de memoria

//  int k2 = shm_create(1); //creo un espacio de memoria compartido
 // char* mem2= 0;
  //shm_get(k2,&mem2); //obtengo el espacio en el padre
  // *mem2 = (int)17; // lo inicio con cero

for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      char* memH= 0;
      int flag = shm_get(k,&memH);
      if (flag == 0)
        consumer(sFactory,sConsumer,memH,getpid());
      semfree(sFactory);
      semfree(sConsumer);
      if (flag == 0)
        shm_close(k); 

      //le seteo lo que tiene mas 5, así veo que no se rompa nada
      //char* memH2= 0;
      //int flag2 = shm_get(k2,&memH2);
      //if (flag2 == 0){
        //memH2= ((int)*memH2);
       // printf(1," valor en la segunda celda =%d consumidor= %d \n",*memH2,getpid()); 
      //  shm_close(k2); 
     // }

      exit();
    }       
  }  


  for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      char* memH= 0;
      int flag = shm_get(k,&memH);
      if (flag == 0)
        producer(sFactory,sConsumer,memH,getpid());
      semfree(sFactory);
      semfree(sConsumer); 
      if (flag == 0)
        shm_close(k);    

      //le seteo lo que tiene menos 5, así veo que no se rompa nada
   //   char* memH2= 0;
    //  int flag2 = shm_get(k2,&memH2);
     // if (flag2 == 0){
       // *memH2= ((int)*memH2);
     //   printf(1," valor en la segunda celda =%d productor= %d \n",*memH2,getpid()); 
      //  shm_close(k2); 
      //}


      exit();
    }       
  }
 

  for(n=0; n<N*2; n++){
    wait();
  }
  semfree(sFactory);
  semfree(sConsumer);
  shm_close(k);
 // shm_close(k2);
  exit();
}