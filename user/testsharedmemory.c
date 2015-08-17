#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  10
#define NUMBERS 10


void addNumber (int semaphore, char* memIndex,char* memArray, int pid){

  int i=0;
  int j = 0;
  while (j<NUMBERS){    
    semdown(semaphore);
    i=((uint)*memIndex);
    //printf(1,"i= %d pid= %d\n",i,pid );
    *(memArray+i) =i; 
 	  *memIndex+= 1;
 	  i = 0;
    while (i<50000){//Writing delayed
      i++;
    }
    semup(semaphore);
    j++;
  }   
}

int
main(int argc, char *argv[])
{

int semaphore,pid,n,keyIndex, keyArray; 


  semaphore= semget(-1,1); // init  semaphore
  keyIndex = shm_create(1); //init  shared memory
  char* index= 0;
  shm_get(keyIndex,&index); //get a shared memory 
  *index = (int)0; // init with 0 the shared memory

  keyArray = shm_create(5000); //shared memory with two pages 
  char* array= 0;
  shm_get(keyArray,&array); 

	for(n=0; n<N; n++){
		pid = fork(); 
    if(pid == 0){
    	char* indexFork= 0;
	    char* arrayFork= 0;
	   	int flagIndex = shm_get(keyIndex,&indexFork);
	   	int flagArray = shm_get(keyArray,&arrayFork);
	   	if (flagIndex == 0 && flagArray == 0 ) {
	     	addNumber(semaphore,indexFork,arrayFork,getpid());
	   		semfree(semaphore);
       	shm_close(keyIndex); 
       	shm_close(keyArray); 
	   		exit();
	  	}
	  } 
	} 
  for(n=0; n<N*2; n++){
    wait();
  }
  for (n=0; n<NUMBERS*N;  n ++){
    printf(1,"n= %d  array= %d  \n", n , *(array+n) );
  }
  printf(1,"%s\n","load the array with 8192 numbers (two pages)" );
  for (n=0; n<8192; n ++){
    *(array+n) = 4;
  }
  printf(1,"%s\n", "reading the 6 last numbers");
  for (n=8186; n<8192; n ++){
    printf(1,"array= %d  \n",*(array+n) ); 
  }
  printf(1,"%s\n", "reading the 6 last numbers, catch the trap in the 7 number ");
  for (n=8186; n<8193; n ++){
    printf(1,"array= %d  \n",*(array+n) ); 
  }
  semfree(semaphore);
  shm_close(keyIndex);
  shm_close(keyArray);
  exit();     
} 
