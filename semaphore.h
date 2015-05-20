struct semaphore {
  int value;
  int refcount;
};

struct {
  struct semaphore semaphore[MAXSEM];
  struct spinlock lock;
  unsigned short quantity; //quantity of actives semaphores
} stable;