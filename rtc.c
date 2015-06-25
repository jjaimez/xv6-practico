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
#include "rtc.h"


#define RTC_PORT(x)     (unsigned short)(0x70 + (x))
#define RTC_SECONDS	0
#define RTC_MINUTES	2
#define RTC_HOURS	4
#define RTC_MONTH   8
static unsigned char get_rtc(unsigned char addr)
{
    unsigned char val;

    outb(RTC_PORT(0),addr);
    val=inb(RTC_PORT(1));

    return val;
}


static int rtcread(struct inode *ip, char *dst, int n)
{
    struct rtcdate t;
    
    /* Get the current time from RTC */
    unsigned char seconds;
    unsigned char minutes;
    unsigned char hours;
    unsigned char month;

    seconds =get_rtc(RTC_SECONDS);
    minutes =get_rtc(RTC_MINUTES);
    hours =get_rtc(RTC_HOURS);
    month = get_rtc(RTC_MONTH);
    t.seconds = seconds;
    t.minutes = minutes;
    t.hours = hours;
    t.month = month;
    *((struct rtcdate *)dst) = t;

    return sizeof(t);    
}

int rtcwrite(struct inode *f, char *dst, int n)
{
    struct rtcdate t;
    t = *((struct rtcdate *)dst);
    
    outb(RTC_PORT(0),RTC_MINUTES);  
    outb(RTC_PORT(1),t.minutes);
    outb(RTC_PORT(0),RTC_HOURS);  
    outb(RTC_PORT(1),t.hours);
    outb(RTC_PORT(0),RTC_SECONDS);  
    outb(RTC_PORT(1),t.seconds);
    outb(RTC_PORT(0),RTC_MONTH);  
    outb(RTC_PORT(1),t.month);
    
    
    return sizeof(t);    
}

void
rtcinit(void)
{
    devsw[RTC].read = rtcread;
    devsw[RTC].write = rtcwrite;
}



