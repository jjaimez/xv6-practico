struct sharedmemory {
  char** addr;
  int refcount;
};

struct {
  struct sharedmemory sharedmemory[MAXSHM];
  struct spinlock lock;
  unsigned short quantity; //quantity of actives espaces of shared memory
} shmtable;