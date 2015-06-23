#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"


#define RTC_PORT(x)     (unsigned short)(0x70 + (x))
#define RTC_SECONDS	0
#define RTC_MINUTES	2
#define RTC_HOURS	4
#define RTC_WEEKDAY 6

static unsigned char get_rtc(unsigned char addr)
{
    unsigned char val;

    val = inb(RTC_PORT(addr));;
    //outb(RTC_PORT(1),val);

    return val;
}

static int rtcread(struct inode *ip, char *dst, int n)
{
    //struct time t;
    
    /* Get the current time from RTC */

    get_rtc(RTC_SECONDS);
        
    //((struct time *)dst) = t;

    return 0;
}

void
rtcinit(void)
{
    //devsw[RTC].write = rtcwrite;
    devsw[RTC].read = rtcread;
}



