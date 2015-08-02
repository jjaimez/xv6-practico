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
	if (shmtable.quantity == MAXSHM)
    return -1;
  int i = 0;
  while (i<MAXSEM){
    if (shmtable.sharedmemory[i].refcount == 0){
      *shmtable.sharedmemory[i].addr = kalloc();
      memset(*shmtable.sharedmemory[i].addr, 0, PGSIZE);
      shmtable.sharedmemory[i].refcount = 1;
      shmtable.quantity++;
      return i;
    } else
      ++i;    
  }  
  return -1;  

}

/*Descripción: Libera el bloque de memoria obtenido previa-
mente.
Parámetros: key es el identicador (descriptor) del bloque de
memoria a liberar.
Retorno: -1 en caso de error ( key inválida). Cero en otro caso.*/
int
shm_close(int key){
	if (shmtable.sharedmemory[key].refcount == 0 || key < 0 || key > MAXSHM)
    return -1;
  shmtable.sharedmemory[key].refcount--;
  int i;
  for (i=0; i<proc->shmemquantity-1;i++){
    proc->shmem[i] = proc->shmem[i+1];
  }
  proc->shmemquantity--;
  if (shmtable.sharedmemory[key].refcount == 0)
    shmtable.quantity--;
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
  if (shmtable.sharedmemory[key].refcount == 0 || key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount==MAXSHMPROC )
    return -1;
  addr = shmtable.sharedmemory[key].addr;
  shmtable.sharedmemory[key].refcount++;
  shmtable.quantity++;
  proc->shmem[proc->shmemquantity]=key;
  proc->shmemquantity++;

  return 0;  
}
