#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "rtc.h"


int 
main(int argc, char *argv[]) 
{
  int fd;
  struct rtcdate t;
  fd = open("rtc",O_RDWR);

  if(argc == 1){
    read(fd, &t, sizeof(t));
    printf(0,"BSD: MM:hh:mm:ss: %d:%d:%d:%d: \n", t.month, t.hours, t.minutes, t.seconds);
    printf(0,"MM:hh:mm:ss:  %d%d:%d%d:%d%d:%d%d\n", (t.month & 0xF0) >> 4, t.month & 0x0F,(t.hours & 0xF0) >> 4, t.hours & 0x0F,(t.minutes & 0xF0) >> 4, t.minutes & 0x0F,(t.seconds & 0xF0) >> 4, t.seconds & 0x0F);
  } else {  
    if(argc == 5){
    t.hours = ((( atoi(argv[2]) / 10 ) << 4 ) | (atoi(argv[2])  % 10));
    t.minutes = ((( atoi(argv[3])  / 10 ) << 4 ) | (atoi(argv[3])  % 10));
    t.seconds = ((( atoi(argv[4])  / 10 ) << 4 ) | (atoi(argv[4])  % 10));
    t.month = ((( atoi(argv[1]) / 10 ) << 4 ) | (atoi(argv[1]) % 10));
    write(fd, &t, sizeof(t));
    read(fd, &t, sizeof(t));
    printf(0,"New Time BSD: MM:hh:mm:ss: %d:%d:%d:%d: \n", t.month, t.hours, t.minutes, t.seconds);
    printf(0,"New Time MM:hh:mm:ss:  %d%d:%d%d:%d%d:%d%d\n", (t.month & 0xF0) >> 4, t.month & 0x0F,(t.hours & 0xF0) >> 4, t.hours & 0x0F,(t.minutes & 0xF0) >> 4, t.minutes & 0x0F,(t.seconds & 0xF0) >> 4, t.seconds & 0x0F);
   } else {
    printf(2, "error\n");
    exit();
   }
 }  
  exit();
}

  