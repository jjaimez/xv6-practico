#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "rtc.h"

int 
main(void)
{
  int fd;
  struct rtcdate t;
    fd = open("rtc",O_RDWR);
    read(fd, &t, sizeof(t));
    printf(0,"BSD: hh:mm:ss: %d:%d:%d \n", t.hours, t.minutes, t.seconds);
  printf(0,"hh:mm:ss:  %d%d:%d%d:%d%d\n", (t.hours & 0xF0) >> 4, t.hours & 0x0F,(t.minutes & 0xF0) >> 4, t.minutes & 0x0F,(t.seconds & 0xF0) >> 4, t.seconds & 0x0F);
  exit();
}
