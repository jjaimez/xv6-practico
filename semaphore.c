#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "semaphore.h"


/*Create or obtain a descriptor of a semaphore.
parameters:
if Sem_id == -1, create a new one.
Return: semaphore identifier obtained or created, otherwise return a negative value indicating error. 
-1: Sem_id > 0  the semaphore is not in use.
-3: Sem_id = -1  no more semaphores available in the system*/
int semget(int sem_id, int init_value){
  if (sem_id == -1){
    if (stable.quantity == MAXSEM){
      return -3;
    }
    int i = 0;
    while (i<MAXSEM){
      if (stable.semaphore[i].refcount == 0){
        stable.semaphore[i].value = init_value;
        stable.semaphore[i].refcount = 1;
        stable.quantity++;
        return i;
      } else
        ++i;    
    }
    return -3;
  } else {
    if (stable.semaphore[sem_id].refcount == 0)
      return -1;
    stable.semaphore[sem_id].refcount++;      
    return 0;
  }  
}


/*Releases the semaphore.
Return -1 on error (not semaphore obtained by the process). Zero otherwise*/
int semfree(int sem_id){
  if (stable.semaphore[sem_id].refcount == 0)
    return -1;
  acquire(&stable.lock);
  stable.semaphore[sem_id].refcount--;
  if (stable.semaphore[sem_id].refcount == 0)
    stable.quantity--;
  release(&stable.lock);
  return 0;
}

//decrease the unit value of the semaphore
int semdown(int sem_id){
  stable.semaphore[sem_id].value--;
  return 0;
}

//Increase the unit value of the semaphore
int semup(int sem_id){
  if (stable.semaphore[sem_id].refcount == 0)
    return -1;
  acquire(&stable.lock);
  stable.semaphore[sem_id].value++;
  release(&stable.lock);
  return 0;
}
