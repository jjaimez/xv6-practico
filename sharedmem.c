#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sharedmem.h"

// size tamaño del bloque de memoria requerido.
//Retorno: Identicador del bloque creado ( key ≥ 0 )
int
shm_create(int size){
  acquire(&shmtable.lock);
	if (shmtable.quantity == MAXSHM){
    release(&shmtable.lock);
    return -1;
  }
  int i = 0;
  while (i<MAXSHM){
    if (shmtable.sharedmemory[i].refcount == 0){
      shmtable.sharedmemory[i].addr = kalloc();
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE);
      shmtable.sharedmemory[i].refcount = 1;
      shmtable.quantity++;
      release(&shmtable.lock);
      return i;
    } else
      ++i;    
  }  
  release(&shmtable.lock);  
  return -1;  

}

/*Descripción: Libera el bloque de memoria obtenido previa-
mente.
Parámetros: key es el identicador (descriptor) del bloque de
memoria a liberar.
Retorno: -1 en caso de error ( key inválida). Cero en otro caso.*/
int
shm_close(int key){
  acquire(&shmtable.lock);
	if (shmtable.sharedmemory[key].refcount == 0 || key < 0 || key > MAXSHM){
    release(&shmtable.lock);
    return -1;
  } 
  int i = 0;
  while (proc->shmem[i] != key && i<MAXSHMPROC){
    i++;
  }
  if (i == MAXSHMPROC){
    release(&shmtable.lock);
    return -1;
  }
  shmtable.sharedmemory[key].refcount--;
  proc->shmem[i] = -1;
  proc->shmemquantity--;
  if (shmtable.sharedmemory[key].refcount == 0)
    shmtable.quantity--;    
  unmappages(proc->pgdir, (char*)proc->sz+((i+1)*PGSIZE), PGSIZE, shmtable.sharedmemory[key].refcount);     
  release(&shmtable.lock);
  return 0;  
}

/*Descripción: Obtiene la dirección (en el parámetro de salida
addr ) del bloque de memoria asociado a key .
Parámetros:
◦ key es el identicador (descriptor) del bloque de memoria.
◦ addr es la dirección de un puntero en donde se almacena
la dirección del bloque de memoria (dirección lógica del
proceso).
Retorno: -1 en caso de error ( key inválida).*/
int
shm_get(int key, char** addr){
  acquire(&shmtable.lock);
  if (shmtable.sharedmemory[key].refcount == 0 || key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount==MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  }  
  //cprintf("addr %x \n" ,addr);
  //cprintf("addr* %x\n",*addr);
  //cprintf("addr& %x\n",&addr);
  shmtable.sharedmemory[key].refcount++;
  int i = 0;
  while (proc->shmem[i] != -1 && i<MAXSHMPROC){
    i++;
  }
  cprintf("proc->shmem[i]= %d i= %d , key= %d \n",proc->shmem[i],i,key);
  if (i == MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  } else {
    proc->shmem[i]=key;
    proc->shmemquantity++;
    mappages(proc->pgdir, (char*)proc->sz+((i+1)*PGSIZE), PGSIZE, v2p(shmtable.sharedmemory[key].addr), PTE_W|PTE_U,PTE_PON); 
    *addr = (char*)proc->sz+((i+1)*PGSIZE);
    //cprintf("addr %x\n",*addr);
    release(&shmtable.lock);
    return 0;
  }   
}
