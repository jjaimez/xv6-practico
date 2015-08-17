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
	if (shmtable.quantity == MAXSHM || ((((int) (size-1) / PGSIZE) ) +1 > MAXPAGESHM) ){
    release(&shmtable.lock);
    return -1;
  }
  int i = 0;
  while (i<MAXSHM){
    if (shmtable.sharedmemory[i].refcount == 0){
      int j = 0;
      shmtable.sharedmemory[i].size = (((int) (size-1) / PGSIZE) ) +1;      
      while ( size > 0){
        shmtable.sharedmemory[i].addr[j] = kalloc();        
        memset(shmtable.sharedmemory[i].addr[j], 0, PGSIZE);
        size -= PGSIZE;
        j++;
      }      
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
	if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == 0){
    release(&shmtable.lock);
    return -1;
  } 
  int i = 0;
  while (i<MAXSHMPROC && proc->shmem[i] != key){
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
  unmappages(proc->pgdir, proc->shmref[i], (shmtable.sharedmemory[key].size)*PGSIZE, shmtable.sharedmemory[key].refcount);     
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
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount==MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  }  
  int i = 0;
  while (i<MAXSHMPROC && proc->shmem[i] != -1 ){
    i++;
  }
  if (i == MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  } else {
    shmtable.sharedmemory[key].refcount++;
    proc->shmem[i]=key;
    proc->shmemquantity++;
    int j = 0;
    for (;j<shmtable.sharedmemory[key].size;j++)
      mappages(proc->pgdir, (char*)proc->lastaddr+(j*PGSIZE), PGSIZE, v2p(shmtable.sharedmemory[key].addr[0]), PTE_W|PTE_U,PTE_PON);       
    proc->shmref[i] = (char*)proc->lastaddr;
    *addr = (char*)proc->lastaddr;
    proc->lastaddr = (char*)proc->lastaddr+(j*PGSIZE);   
    release(&shmtable.lock);
    return 0;
  }   
}
