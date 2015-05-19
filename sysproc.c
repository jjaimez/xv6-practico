#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Print a process listing to console. 
int
sys_procstat(void){  
  procdump();
  return 0;
}

//change the priority
int
sys_set_priority(void){
  int priority;
  if(argint(0, &priority) < 0)
    return -1; 
  if (priority<0 || priority>MLF_SIZE-1)
    return -1;   
  proc->priority = priority;
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
  while (i < MAXSEMPROC){
    if (proc->sem[i] == sem_id){
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
    i++;
  }  
  return -1;
}

//decrease the unit value of the semaphore
int
sys_semdown(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -4;
    //acquire(&stable.lock);
  int i = 0;  
  while (i < MAXSEMPROC){
    if (proc->sem[i] == sem_id){
      while(semvalue(sem_id)==0){
        if (semdown(sem_id) == 1){
          //sleep(proc->chan, &stable.lock); //necesito bloquear la tabla del semaforo que 
        }//esta en semaphore.c
      }
      return 0;
    }
    i++;
  }  
  return -1;  
}

//Increase the unit value of the semaphore
int
sys_semup(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -1;
   int i = 0;  
  while (i < MAXSEMPROC){
    if (proc->sem[i] == sem_id){
      if (semup(sem_id) == -1){
        return -1;
      } 
      wakeup(proc->chan);
    }
    i++;
  }  
  return -1;
}


//return the  value of the semaphore
int
sys_semvalue(void){ //int sem_id
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -1;
  int i = 0;  
  while (i < MAXSEMPROC){
    if (proc->sem[i] == sem_id){
      return semvalue(sem_id);
    }
  i++;
  }
  return -1;
}