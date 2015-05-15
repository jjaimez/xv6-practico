//Count ten million

#include "types.h"
#include "stat.h"
#include "user.h"



int
main(int argc, char *argv[])
{
    int i = 0;
    while (i<10000000){
        i++;
    }
    set_priority(0); // change its priority
    procstat(); //print all process (this process ends whit priority 0 or 1)
    exit();
}