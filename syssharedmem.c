#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sharedmem.h"
#include "elf.h"


int
sys_shm_create(void){
  int size;
  if(argint(0, &size) < 0)
    return -1;
  int k = shm_create(size);
  return k;
}

int
sys_shm_get(void){//int key, void ** addr
  int k;
  int mem = 0;  
  if (proc->shmemquantity >= MAXSHMPROC)
    return -1;
  if(argint(0, &k) < 0)
    return -1;
  argint(1,&mem); 
      cprintf(" %x\n", mem);
  if (!shm_get(k,(char**)mem)){
   // cprintf(" %x\n", *mem);
   // cprintf("solo %x\n", mem);
   // cprintf("& %x\n", &mem);    
    return 0;
  }
  return -1;
}

int
sys_shm_close(void){
  int k;
  if(argint(0, &k) < 0)
    return -1;
  if (!shm_close(k)){    
    return 0;
  }
  return -1;
}