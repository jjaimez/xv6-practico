#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "semaphore.h"

//private: true if semaphore belongs to proc
static int 
belong(int sem_id){
	int i = 0;
	while (i < MAXSEMPROC){
    if (proc->sem[i] == sem_id){
      return 1;
    }
    i++;
	}
	return 0;
}

//Create or obtain a descriptor of a semaphore.
int
sys_semget(void){ //int sem_id, int init_value
  if (proc->squantity == MAXSEMPROC){
    return -2;
  } else {
    int sem_id;
    if(argint(0, &sem_id) < 0)
      return -4;  
    int init_value;
    if(argint(1, &init_value) < 0)
      return -4;    
    int ret = semget(sem_id, init_value);
    if (ret>-1){ 
      proc->sem[proc->squantity] = ret;
      proc->squantity++;
    }
    return ret;
  }  
}

//Releases the semaphore.
int
sys_semfree(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
    return -4;
  int i = 0;
  if (belong(sem_id)){
    if (semfree(sem_id) == -1){
      return -1;
    } else {
      for (i=i; i<proc->squantity-1;i++){
        proc->sem[i] = proc->sem[i+1];
      }
      proc->squantity--;
      return 0;
    }
  }
  return -1;
}

//decrease the unit value of the semaphore
int
sys_semdown(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -4;  
  if (belong(sem_id)){
  		acquire(&stable.lock);
      while(stable.semaphore[sem_id].value == 0)
      	sleep(proc->chan, &stable.lock);
      semdown(sem_id);
      release(&stable.lock);
      return 0;
   }
  return -1;  
}

//Increase the unit value of the semaphore
int
sys_semup(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -1;
  if (belong(sem_id)){  	
    if (semup(sem_id) == -1)
      return -1;
  } 
  wakeup(proc->chan);
  return -1;
}



