#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  3

//add five in a file
void adder (int s, int pid, char path[]){
  int i,k,fd;
  for(i = 0; i < 5; i++){
    semdown(s);
    fd = open(path, O_RDWR);
    read(fd, &k, sizeof(k)); 
    close(fd);
    k=k+1;
    printf(1," k=%d pid= %d \n",k,pid); 
    fd = open(path, O_RDWR);
    write(fd, &k, sizeof(k));
    close(fd);
    semup(s);   
  }
}

//create N childs and each one call adder
int
main(int argc, char *argv[])
{
int s,pid,n,k,fd; 
  char path[] = "shared";

  s= semget(-1,1);
  k=0;
  fd = open(path, O_CREATE|O_RDWR);
  write(fd, &k, sizeof(k));
  close(fd);
  for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      adder(s,getpid(),path);
      semfree(s);
      exit();
    }       
  }

  for(n=0; n<N; n++){
    wait();
  }
  semfree(s);
  exit();
}