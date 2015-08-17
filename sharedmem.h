struct sharedmemory {
  char* addr[MAXPAGESHM]; //shared memory address
  int refcount; //quantity of references
  int size; //size required
};

struct {
  struct sharedmemory sharedmemory[MAXSHM];
  struct spinlock lock;
  unsigned short quantity; //quantity of actives espaces of shared memory
} shmtable;