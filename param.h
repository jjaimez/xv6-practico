#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data sectors in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
#define MLF_SIZE     4   //size of multilevel
#define QUANTUM      3   //quantum
#define MAXSEM       20  // maximum quantity of semaphores in system
#define MAXSEMPROC   5   //  maximum quantity of semaphores per process
#define ALLOCATEDPAGES 30   // allocated pages
