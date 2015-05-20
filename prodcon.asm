
_prodcon:     file format elf32-i386


Disassembly of section .text:

00000000 <consumer>:
#include "fcntl.h"

#define N  2


void consumer (int sFactory, int sConsumer, int pid, char path[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int i,k,fd;

  int j = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while (j<5){    
   d:	e9 cd 00 00 00       	jmp    df <consumer+0xdf>
    semdown(sConsumer);
  12:	83 ec 0c             	sub    $0xc,%esp
  15:	ff 75 0c             	pushl  0xc(%ebp)
  18:	e8 42 06 00 00       	call   65f <semdown>
  1d:	83 c4 10             	add    $0x10,%esp
    semdown(sFactory);
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	ff 75 08             	pushl  0x8(%ebp)
  26:	e8 34 06 00 00       	call   65f <semdown>
  2b:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);  
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	6a 02                	push   $0x2
  33:	ff 75 14             	pushl  0x14(%ebp)
  36:	e8 a4 05 00 00       	call   5df <open>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    read(fd, &k, sizeof(k));
  41:	83 ec 04             	sub    $0x4,%esp
  44:	6a 04                	push   $0x4
  46:	8d 45 e8             	lea    -0x18(%ebp),%eax
  49:	50                   	push   %eax
  4a:	ff 75 ec             	pushl  -0x14(%ebp)
  4d:	e8 65 05 00 00       	call   5b7 <read>
  52:	83 c4 10             	add    $0x10,%esp
    close(fd); 
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	ff 75 ec             	pushl  -0x14(%ebp)
  5b:	e8 67 05 00 00       	call   5c7 <close>
  60:	83 c4 10             	add    $0x10,%esp
    k--;
  63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  66:	83 e8 01             	sub    $0x1,%eax
  69:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1," k=%d consumer= %d \n",k,pid); 
  6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6f:	ff 75 10             	pushl  0x10(%ebp)
  72:	50                   	push   %eax
  73:	68 f8 0a 00 00       	push   $0xaf8
  78:	6a 01                	push   $0x1
  7a:	e8 c5 06 00 00       	call   744 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);
  82:	83 ec 08             	sub    $0x8,%esp
  85:	6a 02                	push   $0x2
  87:	ff 75 14             	pushl  0x14(%ebp)
  8a:	e8 50 05 00 00       	call   5df <open>
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 45 ec             	mov    %eax,-0x14(%ebp)
    write(fd, &k, sizeof(k));
  95:	83 ec 04             	sub    $0x4,%esp
  98:	6a 04                	push   $0x4
  9a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  9d:	50                   	push   %eax
  9e:	ff 75 ec             	pushl  -0x14(%ebp)
  a1:	e8 19 05 00 00       	call   5bf <write>
  a6:	83 c4 10             	add    $0x10,%esp
    close(fd);
  a9:	83 ec 0c             	sub    $0xc,%esp
  ac:	ff 75 ec             	pushl  -0x14(%ebp)
  af:	e8 13 05 00 00       	call   5c7 <close>
  b4:	83 c4 10             	add    $0x10,%esp
    i = 0;
  b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i<1000){
  be:	eb 04                	jmp    c4 <consumer+0xc4>
      i++;
  c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    printf(1," k=%d consumer= %d \n",k,pid); 
    fd = open(path, O_RDWR);
    write(fd, &k, sizeof(k));
    close(fd);
    i = 0;
    while (i<1000){
  c4:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  cb:	7e f3                	jle    c0 <consumer+0xc0>
      i++;
    }
    semup(sFactory);
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	ff 75 08             	pushl  0x8(%ebp)
  d3:	e8 8f 05 00 00       	call   667 <semup>
  d8:	83 c4 10             	add    $0x10,%esp
    j++;
  db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

void consumer (int sFactory, int sConsumer, int pid, char path[]){
  int i,k,fd;

  int j = 0;
  while (j<5){    
  df:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  e3:	0f 8e 29 ff ff ff    	jle    12 <consumer+0x12>
      i++;
    }
    semup(sFactory);
    j++;
  }   
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <producer>:


void producer (int sFactory, int sConsumer, int pid, char path[]){
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 ec 18             	sub    $0x18,%esp
  int i,k,fd;
  int j = 0;
  f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while (j<5){
  f8:	e9 cd 00 00 00       	jmp    1ca <producer+0xdf>
    i = 0;
  fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i<100000){
 104:	eb 04                	jmp    10a <producer+0x1f>
      i++;
 106:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
void producer (int sFactory, int sConsumer, int pid, char path[]){
  int i,k,fd;
  int j = 0;
  while (j<5){
    i = 0;
    while (i<100000){
 10a:	81 7d f4 9f 86 01 00 	cmpl   $0x1869f,-0xc(%ebp)
 111:	7e f3                	jle    106 <producer+0x1b>
      i++;
    }
    semdown(sFactory);
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	ff 75 08             	pushl  0x8(%ebp)
 119:	e8 41 05 00 00       	call   65f <semdown>
 11e:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);
 121:	83 ec 08             	sub    $0x8,%esp
 124:	6a 02                	push   $0x2
 126:	ff 75 14             	pushl  0x14(%ebp)
 129:	e8 b1 04 00 00       	call   5df <open>
 12e:	83 c4 10             	add    $0x10,%esp
 131:	89 45 ec             	mov    %eax,-0x14(%ebp)
    read(fd, &k, sizeof(k)); 
 134:	83 ec 04             	sub    $0x4,%esp
 137:	6a 04                	push   $0x4
 139:	8d 45 e8             	lea    -0x18(%ebp),%eax
 13c:	50                   	push   %eax
 13d:	ff 75 ec             	pushl  -0x14(%ebp)
 140:	e8 72 04 00 00       	call   5b7 <read>
 145:	83 c4 10             	add    $0x10,%esp
    close(fd);
 148:	83 ec 0c             	sub    $0xc,%esp
 14b:	ff 75 ec             	pushl  -0x14(%ebp)
 14e:	e8 74 04 00 00       	call   5c7 <close>
 153:	83 c4 10             	add    $0x10,%esp
    k++;
 156:	8b 45 e8             	mov    -0x18(%ebp),%eax
 159:	83 c0 01             	add    $0x1,%eax
 15c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1," k=%d producer= %d \n",k,pid); 
 15f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 162:	ff 75 10             	pushl  0x10(%ebp)
 165:	50                   	push   %eax
 166:	68 0d 0b 00 00       	push   $0xb0d
 16b:	6a 01                	push   $0x1
 16d:	e8 d2 05 00 00       	call   744 <printf>
 172:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);
 175:	83 ec 08             	sub    $0x8,%esp
 178:	6a 02                	push   $0x2
 17a:	ff 75 14             	pushl  0x14(%ebp)
 17d:	e8 5d 04 00 00       	call   5df <open>
 182:	83 c4 10             	add    $0x10,%esp
 185:	89 45 ec             	mov    %eax,-0x14(%ebp)
    write(fd, &k, sizeof(k));
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	6a 04                	push   $0x4
 18d:	8d 45 e8             	lea    -0x18(%ebp),%eax
 190:	50                   	push   %eax
 191:	ff 75 ec             	pushl  -0x14(%ebp)
 194:	e8 26 04 00 00       	call   5bf <write>
 199:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19c:	83 ec 0c             	sub    $0xc,%esp
 19f:	ff 75 ec             	pushl  -0x14(%ebp)
 1a2:	e8 20 04 00 00       	call   5c7 <close>
 1a7:	83 c4 10             	add    $0x10,%esp
    semup(sFactory);
 1aa:	83 ec 0c             	sub    $0xc,%esp
 1ad:	ff 75 08             	pushl  0x8(%ebp)
 1b0:	e8 b2 04 00 00       	call   667 <semup>
 1b5:	83 c4 10             	add    $0x10,%esp
    semup(sConsumer); 
 1b8:	83 ec 0c             	sub    $0xc,%esp
 1bb:	ff 75 0c             	pushl  0xc(%ebp)
 1be:	e8 a4 04 00 00       	call   667 <semup>
 1c3:	83 c4 10             	add    $0x10,%esp
    j++;
 1c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)


void producer (int sFactory, int sConsumer, int pid, char path[]){
  int i,k,fd;
  int j = 0;
  while (j<5){
 1ca:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 1ce:	0f 8e 29 ff ff ff    	jle    fd <producer+0x12>
    close(fd);
    semup(sFactory);
    semup(sConsumer); 
    j++;
  }         
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <main>:



int
main(int argc, char *argv[])
{
 1d6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1da:	83 e4 f0             	and    $0xfffffff0,%esp
 1dd:	ff 71 fc             	pushl  -0x4(%ecx)
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	51                   	push   %ecx
 1e4:	83 ec 24             	sub    $0x24,%esp
int sConsumer,sFactory,pid,n,k,fd; 
  char path[] = "factory";
 1e7:	c7 45 d8 66 61 63 74 	movl   $0x74636166,-0x28(%ebp)
 1ee:	c7 45 dc 6f 72 79 00 	movl   $0x79726f,-0x24(%ebp)

  sFactory= semget(-1,1);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 01                	push   $0x1
 1fa:	6a ff                	push   $0xffffffff
 1fc:	e8 4e 04 00 00       	call   64f <semget>
 201:	83 c4 10             	add    $0x10,%esp
 204:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sConsumer= semget(-1,0);
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	6a 00                	push   $0x0
 20c:	6a ff                	push   $0xffffffff
 20e:	e8 3c 04 00 00       	call   64f <semget>
 213:	83 c4 10             	add    $0x10,%esp
 216:	89 45 ec             	mov    %eax,-0x14(%ebp)
  k=0;
 219:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  fd = open(path, O_CREATE|O_RDWR);
 220:	83 ec 08             	sub    $0x8,%esp
 223:	68 02 02 00 00       	push   $0x202
 228:	8d 45 d8             	lea    -0x28(%ebp),%eax
 22b:	50                   	push   %eax
 22c:	e8 ae 03 00 00       	call   5df <open>
 231:	83 c4 10             	add    $0x10,%esp
 234:	89 45 e8             	mov    %eax,-0x18(%ebp)
  write(fd, &k, sizeof(k));
 237:	83 ec 04             	sub    $0x4,%esp
 23a:	6a 04                	push   $0x4
 23c:	8d 45 e0             	lea    -0x20(%ebp),%eax
 23f:	50                   	push   %eax
 240:	ff 75 e8             	pushl  -0x18(%ebp)
 243:	e8 77 03 00 00       	call   5bf <write>
 248:	83 c4 10             	add    $0x10,%esp
  close(fd);
 24b:	83 ec 0c             	sub    $0xc,%esp
 24e:	ff 75 e8             	pushl  -0x18(%ebp)
 251:	e8 71 03 00 00       	call   5c7 <close>
 256:	83 c4 10             	add    $0x10,%esp

for(n=0; n<N; n++){
 259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 260:	eb 4d                	jmp    2af <main+0xd9>
    pid = fork(); 
 262:	e8 30 03 00 00       	call   597 <fork>
 267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid == 0){
 26a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 26e:	75 3b                	jne    2ab <main+0xd5>
      consumer(sFactory,sConsumer,getpid(),path);
 270:	e8 aa 03 00 00       	call   61f <getpid>
 275:	89 c2                	mov    %eax,%edx
 277:	8d 45 d8             	lea    -0x28(%ebp),%eax
 27a:	50                   	push   %eax
 27b:	52                   	push   %edx
 27c:	ff 75 ec             	pushl  -0x14(%ebp)
 27f:	ff 75 f0             	pushl  -0x10(%ebp)
 282:	e8 79 fd ff ff       	call   0 <consumer>
 287:	83 c4 10             	add    $0x10,%esp
      semfree(sFactory);
 28a:	83 ec 0c             	sub    $0xc,%esp
 28d:	ff 75 f0             	pushl  -0x10(%ebp)
 290:	e8 c2 03 00 00       	call   657 <semfree>
 295:	83 c4 10             	add    $0x10,%esp
      semfree(sConsumer);
 298:	83 ec 0c             	sub    $0xc,%esp
 29b:	ff 75 ec             	pushl  -0x14(%ebp)
 29e:	e8 b4 03 00 00       	call   657 <semfree>
 2a3:	83 c4 10             	add    $0x10,%esp
      exit();
 2a6:	e8 f4 02 00 00       	call   59f <exit>
  k=0;
  fd = open(path, O_CREATE|O_RDWR);
  write(fd, &k, sizeof(k));
  close(fd);

for(n=0; n<N; n++){
 2ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2af:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 2b3:	7e ad                	jle    262 <main+0x8c>
      exit();
    }       
  }  


  for(n=0; n<N; n++){
 2b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2bc:	eb 4d                	jmp    30b <main+0x135>
    pid = fork(); 
 2be:	e8 d4 02 00 00       	call   597 <fork>
 2c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid == 0){
 2c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 2ca:	75 3b                	jne    307 <main+0x131>
      producer(sFactory,sConsumer,getpid(),path);
 2cc:	e8 4e 03 00 00       	call   61f <getpid>
 2d1:	89 c2                	mov    %eax,%edx
 2d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
 2d6:	50                   	push   %eax
 2d7:	52                   	push   %edx
 2d8:	ff 75 ec             	pushl  -0x14(%ebp)
 2db:	ff 75 f0             	pushl  -0x10(%ebp)
 2de:	e8 08 fe ff ff       	call   eb <producer>
 2e3:	83 c4 10             	add    $0x10,%esp
      semfree(sFactory);
 2e6:	83 ec 0c             	sub    $0xc,%esp
 2e9:	ff 75 f0             	pushl  -0x10(%ebp)
 2ec:	e8 66 03 00 00       	call   657 <semfree>
 2f1:	83 c4 10             	add    $0x10,%esp
      semfree(sConsumer);
 2f4:	83 ec 0c             	sub    $0xc,%esp
 2f7:	ff 75 ec             	pushl  -0x14(%ebp)
 2fa:	e8 58 03 00 00       	call   657 <semfree>
 2ff:	83 c4 10             	add    $0x10,%esp
      exit();
 302:	e8 98 02 00 00       	call   59f <exit>
      exit();
    }       
  }  


  for(n=0; n<N; n++){
 307:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 30b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 30f:	7e ad                	jle    2be <main+0xe8>
      exit();
    }       
  }
 

  for(n=0; n<N*2; n++){
 311:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 318:	eb 09                	jmp    323 <main+0x14d>
    wait();
 31a:	e8 88 02 00 00       	call   5a7 <wait>
      exit();
    }       
  }
 

  for(n=0; n<N*2; n++){
 31f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 323:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
 327:	7e f1                	jle    31a <main+0x144>
    wait();
  }
  semfree(sFactory);
 329:	83 ec 0c             	sub    $0xc,%esp
 32c:	ff 75 f0             	pushl  -0x10(%ebp)
 32f:	e8 23 03 00 00       	call   657 <semfree>
 334:	83 c4 10             	add    $0x10,%esp
  semfree(sConsumer);
 337:	83 ec 0c             	sub    $0xc,%esp
 33a:	ff 75 ec             	pushl  -0x14(%ebp)
 33d:	e8 15 03 00 00       	call   657 <semfree>
 342:	83 c4 10             	add    $0x10,%esp
  exit();
 345:	e8 55 02 00 00       	call   59f <exit>

0000034a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	57                   	push   %edi
 34e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 352:	8b 55 10             	mov    0x10(%ebp),%edx
 355:	8b 45 0c             	mov    0xc(%ebp),%eax
 358:	89 cb                	mov    %ecx,%ebx
 35a:	89 df                	mov    %ebx,%edi
 35c:	89 d1                	mov    %edx,%ecx
 35e:	fc                   	cld    
 35f:	f3 aa                	rep stos %al,%es:(%edi)
 361:	89 ca                	mov    %ecx,%edx
 363:	89 fb                	mov    %edi,%ebx
 365:	89 5d 08             	mov    %ebx,0x8(%ebp)
 368:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 36b:	5b                   	pop    %ebx
 36c:	5f                   	pop    %edi
 36d:	5d                   	pop    %ebp
 36e:	c3                   	ret    

0000036f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 37b:	90                   	nop
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	8d 50 01             	lea    0x1(%eax),%edx
 382:	89 55 08             	mov    %edx,0x8(%ebp)
 385:	8b 55 0c             	mov    0xc(%ebp),%edx
 388:	8d 4a 01             	lea    0x1(%edx),%ecx
 38b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38e:	0f b6 12             	movzbl (%edx),%edx
 391:	88 10                	mov    %dl,(%eax)
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	84 c0                	test   %al,%al
 398:	75 e2                	jne    37c <strcpy+0xd>
    ;
  return os;
 39a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3a2:	eb 08                	jmp    3ac <strcmp+0xd>
    p++, q++;
 3a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	84 c0                	test   %al,%al
 3b4:	74 10                	je     3c6 <strcmp+0x27>
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 10             	movzbl (%eax),%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	38 c2                	cmp    %al,%dl
 3c4:	74 de                	je     3a4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	0f b6 d0             	movzbl %al,%edx
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	0f b6 c0             	movzbl %al,%eax
 3d8:	29 c2                	sub    %eax,%edx
 3da:	89 d0                	mov    %edx,%eax
}
 3dc:	5d                   	pop    %ebp
 3dd:	c3                   	ret    

000003de <strlen>:

uint
strlen(char *s)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3eb:	eb 04                	jmp    3f1 <strlen+0x13>
 3ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	01 d0                	add    %edx,%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	84 c0                	test   %al,%al
 3fe:	75 ed                	jne    3ed <strlen+0xf>
    ;
  return n;
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <memset>:

void*
memset(void *dst, int c, uint n)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 408:	8b 45 10             	mov    0x10(%ebp),%eax
 40b:	50                   	push   %eax
 40c:	ff 75 0c             	pushl  0xc(%ebp)
 40f:	ff 75 08             	pushl  0x8(%ebp)
 412:	e8 33 ff ff ff       	call   34a <stosb>
 417:	83 c4 0c             	add    $0xc,%esp
  return dst;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41d:	c9                   	leave  
 41e:	c3                   	ret    

0000041f <strchr>:

char*
strchr(const char *s, char c)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	83 ec 04             	sub    $0x4,%esp
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 42b:	eb 14                	jmp    441 <strchr+0x22>
    if(*s == c)
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	3a 45 fc             	cmp    -0x4(%ebp),%al
 436:	75 05                	jne    43d <strchr+0x1e>
      return (char*)s;
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	eb 13                	jmp    450 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	84 c0                	test   %al,%al
 449:	75 e2                	jne    42d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 44b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <gets>:

char*
gets(char *buf, int max)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 458:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45f:	eb 44                	jmp    4a5 <gets+0x53>
    cc = read(0, &c, 1);
 461:	83 ec 04             	sub    $0x4,%esp
 464:	6a 01                	push   $0x1
 466:	8d 45 ef             	lea    -0x11(%ebp),%eax
 469:	50                   	push   %eax
 46a:	6a 00                	push   $0x0
 46c:	e8 46 01 00 00       	call   5b7 <read>
 471:	83 c4 10             	add    $0x10,%esp
 474:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47b:	7f 02                	jg     47f <gets+0x2d>
      break;
 47d:	eb 31                	jmp    4b0 <gets+0x5e>
    buf[i++] = c;
 47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 482:	8d 50 01             	lea    0x1(%eax),%edx
 485:	89 55 f4             	mov    %edx,-0xc(%ebp)
 488:	89 c2                	mov    %eax,%edx
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	01 c2                	add    %eax,%edx
 48f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 493:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 495:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 499:	3c 0a                	cmp    $0xa,%al
 49b:	74 13                	je     4b0 <gets+0x5e>
 49d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a1:	3c 0d                	cmp    $0xd,%al
 4a3:	74 0b                	je     4b0 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a8:	83 c0 01             	add    $0x1,%eax
 4ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4ae:	7c b1                	jl     461 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	01 d0                	add    %edx,%eax
 4b8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4be:	c9                   	leave  
 4bf:	c3                   	ret    

000004c0 <stat>:

int
stat(char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c6:	83 ec 08             	sub    $0x8,%esp
 4c9:	6a 00                	push   $0x0
 4cb:	ff 75 08             	pushl  0x8(%ebp)
 4ce:	e8 0c 01 00 00       	call   5df <open>
 4d3:	83 c4 10             	add    $0x10,%esp
 4d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4dd:	79 07                	jns    4e6 <stat+0x26>
    return -1;
 4df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e4:	eb 25                	jmp    50b <stat+0x4b>
  r = fstat(fd, st);
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	ff 75 0c             	pushl  0xc(%ebp)
 4ec:	ff 75 f4             	pushl  -0xc(%ebp)
 4ef:	e8 03 01 00 00       	call   5f7 <fstat>
 4f4:	83 c4 10             	add    $0x10,%esp
 4f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4fa:	83 ec 0c             	sub    $0xc,%esp
 4fd:	ff 75 f4             	pushl  -0xc(%ebp)
 500:	e8 c2 00 00 00       	call   5c7 <close>
 505:	83 c4 10             	add    $0x10,%esp
  return r;
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 50b:	c9                   	leave  
 50c:	c3                   	ret    

0000050d <atoi>:

int
atoi(const char *s)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 513:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 51a:	eb 25                	jmp    541 <atoi+0x34>
    n = n*10 + *s++ - '0';
 51c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51f:	89 d0                	mov    %edx,%eax
 521:	c1 e0 02             	shl    $0x2,%eax
 524:	01 d0                	add    %edx,%eax
 526:	01 c0                	add    %eax,%eax
 528:	89 c1                	mov    %eax,%ecx
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	8d 50 01             	lea    0x1(%eax),%edx
 530:	89 55 08             	mov    %edx,0x8(%ebp)
 533:	0f b6 00             	movzbl (%eax),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	01 c8                	add    %ecx,%eax
 53b:	83 e8 30             	sub    $0x30,%eax
 53e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	3c 2f                	cmp    $0x2f,%al
 549:	7e 0a                	jle    555 <atoi+0x48>
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	3c 39                	cmp    $0x39,%al
 553:	7e c7                	jle    51c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 555:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 558:	c9                   	leave  
 559:	c3                   	ret    

0000055a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55a:	55                   	push   %ebp
 55b:	89 e5                	mov    %esp,%ebp
 55d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 566:	8b 45 0c             	mov    0xc(%ebp),%eax
 569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 56c:	eb 17                	jmp    585 <memmove+0x2b>
    *dst++ = *src++;
 56e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 571:	8d 50 01             	lea    0x1(%eax),%edx
 574:	89 55 fc             	mov    %edx,-0x4(%ebp)
 577:	8b 55 f8             	mov    -0x8(%ebp),%edx
 57a:	8d 4a 01             	lea    0x1(%edx),%ecx
 57d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 580:	0f b6 12             	movzbl (%edx),%edx
 583:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 585:	8b 45 10             	mov    0x10(%ebp),%eax
 588:	8d 50 ff             	lea    -0x1(%eax),%edx
 58b:	89 55 10             	mov    %edx,0x10(%ebp)
 58e:	85 c0                	test   %eax,%eax
 590:	7f dc                	jg     56e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 592:	8b 45 08             	mov    0x8(%ebp),%eax
}
 595:	c9                   	leave  
 596:	c3                   	ret    

00000597 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 597:	b8 01 00 00 00       	mov    $0x1,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <exit>:
SYSCALL(exit)
 59f:	b8 02 00 00 00       	mov    $0x2,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <wait>:
SYSCALL(wait)
 5a7:	b8 03 00 00 00       	mov    $0x3,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <pipe>:
SYSCALL(pipe)
 5af:	b8 04 00 00 00       	mov    $0x4,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <read>:
SYSCALL(read)
 5b7:	b8 05 00 00 00       	mov    $0x5,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <write>:
SYSCALL(write)
 5bf:	b8 10 00 00 00       	mov    $0x10,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <close>:
SYSCALL(close)
 5c7:	b8 15 00 00 00       	mov    $0x15,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <kill>:
SYSCALL(kill)
 5cf:	b8 06 00 00 00       	mov    $0x6,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <exec>:
SYSCALL(exec)
 5d7:	b8 07 00 00 00       	mov    $0x7,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <open>:
SYSCALL(open)
 5df:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <mknod>:
SYSCALL(mknod)
 5e7:	b8 11 00 00 00       	mov    $0x11,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <unlink>:
SYSCALL(unlink)
 5ef:	b8 12 00 00 00       	mov    $0x12,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <fstat>:
SYSCALL(fstat)
 5f7:	b8 08 00 00 00       	mov    $0x8,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <link>:
SYSCALL(link)
 5ff:	b8 13 00 00 00       	mov    $0x13,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <mkdir>:
SYSCALL(mkdir)
 607:	b8 14 00 00 00       	mov    $0x14,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <chdir>:
SYSCALL(chdir)
 60f:	b8 09 00 00 00       	mov    $0x9,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <dup>:
SYSCALL(dup)
 617:	b8 0a 00 00 00       	mov    $0xa,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <getpid>:
SYSCALL(getpid)
 61f:	b8 0b 00 00 00       	mov    $0xb,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <sbrk>:
SYSCALL(sbrk)
 627:	b8 0c 00 00 00       	mov    $0xc,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <sleep>:
SYSCALL(sleep)
 62f:	b8 0d 00 00 00       	mov    $0xd,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <uptime>:
SYSCALL(uptime)
 637:	b8 0e 00 00 00       	mov    $0xe,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <procstat>:
SYSCALL(procstat)
 63f:	b8 16 00 00 00       	mov    $0x16,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <set_priority>:
SYSCALL(set_priority)
 647:	b8 17 00 00 00       	mov    $0x17,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <semget>:
SYSCALL(semget)
 64f:	b8 18 00 00 00       	mov    $0x18,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <semfree>:
SYSCALL(semfree)
 657:	b8 19 00 00 00       	mov    $0x19,%eax
 65c:	cd 40                	int    $0x40
 65e:	c3                   	ret    

0000065f <semdown>:
SYSCALL(semdown)
 65f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 664:	cd 40                	int    $0x40
 666:	c3                   	ret    

00000667 <semup>:
 667:	b8 1b 00 00 00       	mov    $0x1b,%eax
 66c:	cd 40                	int    $0x40
 66e:	c3                   	ret    

0000066f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 66f:	55                   	push   %ebp
 670:	89 e5                	mov    %esp,%ebp
 672:	83 ec 18             	sub    $0x18,%esp
 675:	8b 45 0c             	mov    0xc(%ebp),%eax
 678:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 67b:	83 ec 04             	sub    $0x4,%esp
 67e:	6a 01                	push   $0x1
 680:	8d 45 f4             	lea    -0xc(%ebp),%eax
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 33 ff ff ff       	call   5bf <write>
 68c:	83 c4 10             	add    $0x10,%esp
}
 68f:	c9                   	leave  
 690:	c3                   	ret    

00000691 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 691:	55                   	push   %ebp
 692:	89 e5                	mov    %esp,%ebp
 694:	53                   	push   %ebx
 695:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 698:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 69f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a3:	74 17                	je     6bc <printint+0x2b>
 6a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a9:	79 11                	jns    6bc <printint+0x2b>
    neg = 1;
 6ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b5:	f7 d8                	neg    %eax
 6b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ba:	eb 06                	jmp    6c2 <printint+0x31>
  } else {
    x = xx;
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6cc:	8d 41 01             	lea    0x1(%ecx),%eax
 6cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d8:	ba 00 00 00 00       	mov    $0x0,%edx
 6dd:	f7 f3                	div    %ebx
 6df:	89 d0                	mov    %edx,%eax
 6e1:	0f b6 80 b4 0d 00 00 	movzbl 0xdb4(%eax),%eax
 6e8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f2:	ba 00 00 00 00       	mov    $0x0,%edx
 6f7:	f7 f3                	div    %ebx
 6f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 700:	75 c7                	jne    6c9 <printint+0x38>
  if(neg)
 702:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 706:	74 0e                	je     716 <printint+0x85>
    buf[i++] = '-';
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	8d 50 01             	lea    0x1(%eax),%edx
 70e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 711:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 716:	eb 1d                	jmp    735 <printint+0xa4>
    putc(fd, buf[i]);
 718:	8d 55 dc             	lea    -0x24(%ebp),%edx
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	0f b6 00             	movzbl (%eax),%eax
 723:	0f be c0             	movsbl %al,%eax
 726:	83 ec 08             	sub    $0x8,%esp
 729:	50                   	push   %eax
 72a:	ff 75 08             	pushl  0x8(%ebp)
 72d:	e8 3d ff ff ff       	call   66f <putc>
 732:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 735:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73d:	79 d9                	jns    718 <printint+0x87>
    putc(fd, buf[i]);
}
 73f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 742:	c9                   	leave  
 743:	c3                   	ret    

00000744 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 751:	8d 45 0c             	lea    0xc(%ebp),%eax
 754:	83 c0 04             	add    $0x4,%eax
 757:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 75a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 761:	e9 59 01 00 00       	jmp    8bf <printf+0x17b>
    c = fmt[i] & 0xff;
 766:	8b 55 0c             	mov    0xc(%ebp),%edx
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	01 d0                	add    %edx,%eax
 76e:	0f b6 00             	movzbl (%eax),%eax
 771:	0f be c0             	movsbl %al,%eax
 774:	25 ff 00 00 00       	and    $0xff,%eax
 779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 77c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 780:	75 2c                	jne    7ae <printf+0x6a>
      if(c == '%'){
 782:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 786:	75 0c                	jne    794 <printf+0x50>
        state = '%';
 788:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 78f:	e9 27 01 00 00       	jmp    8bb <printf+0x177>
      } else {
        putc(fd, c);
 794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 797:	0f be c0             	movsbl %al,%eax
 79a:	83 ec 08             	sub    $0x8,%esp
 79d:	50                   	push   %eax
 79e:	ff 75 08             	pushl  0x8(%ebp)
 7a1:	e8 c9 fe ff ff       	call   66f <putc>
 7a6:	83 c4 10             	add    $0x10,%esp
 7a9:	e9 0d 01 00 00       	jmp    8bb <printf+0x177>
      }
    } else if(state == '%'){
 7ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7b2:	0f 85 03 01 00 00    	jne    8bb <printf+0x177>
      if(c == 'd'){
 7b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7bc:	75 1e                	jne    7dc <printf+0x98>
        printint(fd, *ap, 10, 1);
 7be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	6a 01                	push   $0x1
 7c5:	6a 0a                	push   $0xa
 7c7:	50                   	push   %eax
 7c8:	ff 75 08             	pushl  0x8(%ebp)
 7cb:	e8 c1 fe ff ff       	call   691 <printint>
 7d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d7:	e9 d8 00 00 00       	jmp    8b4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7dc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e0:	74 06                	je     7e8 <printf+0xa4>
 7e2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7e6:	75 1e                	jne    806 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	6a 00                	push   $0x0
 7ef:	6a 10                	push   $0x10
 7f1:	50                   	push   %eax
 7f2:	ff 75 08             	pushl  0x8(%ebp)
 7f5:	e8 97 fe ff ff       	call   691 <printint>
 7fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 7fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 801:	e9 ae 00 00 00       	jmp    8b4 <printf+0x170>
      } else if(c == 's'){
 806:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 80a:	75 43                	jne    84f <printf+0x10b>
        s = (char*)*ap;
 80c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 814:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81c:	75 07                	jne    825 <printf+0xe1>
          s = "(null)";
 81e:	c7 45 f4 22 0b 00 00 	movl   $0xb22,-0xc(%ebp)
        while(*s != 0){
 825:	eb 1c                	jmp    843 <printf+0xff>
          putc(fd, *s);
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	0f b6 00             	movzbl (%eax),%eax
 82d:	0f be c0             	movsbl %al,%eax
 830:	83 ec 08             	sub    $0x8,%esp
 833:	50                   	push   %eax
 834:	ff 75 08             	pushl  0x8(%ebp)
 837:	e8 33 fe ff ff       	call   66f <putc>
 83c:	83 c4 10             	add    $0x10,%esp
          s++;
 83f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	0f b6 00             	movzbl (%eax),%eax
 849:	84 c0                	test   %al,%al
 84b:	75 da                	jne    827 <printf+0xe3>
 84d:	eb 65                	jmp    8b4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 84f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 853:	75 1d                	jne    872 <printf+0x12e>
        putc(fd, *ap);
 855:	8b 45 e8             	mov    -0x18(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	0f be c0             	movsbl %al,%eax
 85d:	83 ec 08             	sub    $0x8,%esp
 860:	50                   	push   %eax
 861:	ff 75 08             	pushl  0x8(%ebp)
 864:	e8 06 fe ff ff       	call   66f <putc>
 869:	83 c4 10             	add    $0x10,%esp
        ap++;
 86c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 870:	eb 42                	jmp    8b4 <printf+0x170>
      } else if(c == '%'){
 872:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 876:	75 17                	jne    88f <printf+0x14b>
        putc(fd, c);
 878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87b:	0f be c0             	movsbl %al,%eax
 87e:	83 ec 08             	sub    $0x8,%esp
 881:	50                   	push   %eax
 882:	ff 75 08             	pushl  0x8(%ebp)
 885:	e8 e5 fd ff ff       	call   66f <putc>
 88a:	83 c4 10             	add    $0x10,%esp
 88d:	eb 25                	jmp    8b4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 88f:	83 ec 08             	sub    $0x8,%esp
 892:	6a 25                	push   $0x25
 894:	ff 75 08             	pushl  0x8(%ebp)
 897:	e8 d3 fd ff ff       	call   66f <putc>
 89c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 89f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a2:	0f be c0             	movsbl %al,%eax
 8a5:	83 ec 08             	sub    $0x8,%esp
 8a8:	50                   	push   %eax
 8a9:	ff 75 08             	pushl  0x8(%ebp)
 8ac:	e8 be fd ff ff       	call   66f <putc>
 8b1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8bb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c5:	01 d0                	add    %edx,%eax
 8c7:	0f b6 00             	movzbl (%eax),%eax
 8ca:	84 c0                	test   %al,%al
 8cc:	0f 85 94 fe ff ff    	jne    766 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8d2:	c9                   	leave  
 8d3:	c3                   	ret    

000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	55                   	push   %ebp
 8d5:	89 e5                	mov    %esp,%ebp
 8d7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	8b 45 08             	mov    0x8(%ebp),%eax
 8dd:	83 e8 08             	sub    $0x8,%eax
 8e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e3:	a1 d0 0d 00 00       	mov    0xdd0,%eax
 8e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8eb:	eb 24                	jmp    911 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f5:	77 12                	ja     909 <free+0x35>
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fd:	77 24                	ja     923 <free+0x4f>
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	8b 00                	mov    (%eax),%eax
 904:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 907:	77 1a                	ja     923 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 00                	mov    (%eax),%eax
 90e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 917:	76 d4                	jbe    8ed <free+0x19>
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 921:	76 ca                	jbe    8ed <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	01 c2                	add    %eax,%edx
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	39 c2                	cmp    %eax,%edx
 93c:	75 24                	jne    962 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 93e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 941:	8b 50 04             	mov    0x4(%eax),%edx
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	01 c2                	add    %eax,%edx
 94e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 951:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	8b 10                	mov    (%eax),%edx
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	89 10                	mov    %edx,(%eax)
 960:	eb 0a                	jmp    96c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 10                	mov    (%eax),%edx
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 96c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96f:	8b 40 04             	mov    0x4(%eax),%eax
 972:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	01 d0                	add    %edx,%eax
 97e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 981:	75 20                	jne    9a3 <free+0xcf>
    p->s.size += bp->s.size;
 983:	8b 45 fc             	mov    -0x4(%ebp),%eax
 986:	8b 50 04             	mov    0x4(%eax),%edx
 989:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98c:	8b 40 04             	mov    0x4(%eax),%eax
 98f:	01 c2                	add    %eax,%edx
 991:	8b 45 fc             	mov    -0x4(%ebp),%eax
 994:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	8b 10                	mov    (%eax),%edx
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	89 10                	mov    %edx,(%eax)
 9a1:	eb 08                	jmp    9ab <free+0xd7>
  } else
    p->s.ptr = bp;
 9a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9a9:	89 10                	mov    %edx,(%eax)
  freep = p;
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	a3 d0 0d 00 00       	mov    %eax,0xdd0
}
 9b3:	c9                   	leave  
 9b4:	c3                   	ret    

000009b5 <morecore>:

static Header*
morecore(uint nu)
{
 9b5:	55                   	push   %ebp
 9b6:	89 e5                	mov    %esp,%ebp
 9b8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9bb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9c2:	77 07                	ja     9cb <morecore+0x16>
    nu = 4096;
 9c4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	c1 e0 03             	shl    $0x3,%eax
 9d1:	83 ec 0c             	sub    $0xc,%esp
 9d4:	50                   	push   %eax
 9d5:	e8 4d fc ff ff       	call   627 <sbrk>
 9da:	83 c4 10             	add    $0x10,%esp
 9dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9e4:	75 07                	jne    9ed <morecore+0x38>
    return 0;
 9e6:	b8 00 00 00 00       	mov    $0x0,%eax
 9eb:	eb 26                	jmp    a13 <morecore+0x5e>
  hp = (Header*)p;
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f6:	8b 55 08             	mov    0x8(%ebp),%edx
 9f9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ff:	83 c0 08             	add    $0x8,%eax
 a02:	83 ec 0c             	sub    $0xc,%esp
 a05:	50                   	push   %eax
 a06:	e8 c9 fe ff ff       	call   8d4 <free>
 a0b:	83 c4 10             	add    $0x10,%esp
  return freep;
 a0e:	a1 d0 0d 00 00       	mov    0xdd0,%eax
}
 a13:	c9                   	leave  
 a14:	c3                   	ret    

00000a15 <malloc>:

void*
malloc(uint nbytes)
{
 a15:	55                   	push   %ebp
 a16:	89 e5                	mov    %esp,%ebp
 a18:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a1b:	8b 45 08             	mov    0x8(%ebp),%eax
 a1e:	83 c0 07             	add    $0x7,%eax
 a21:	c1 e8 03             	shr    $0x3,%eax
 a24:	83 c0 01             	add    $0x1,%eax
 a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a2a:	a1 d0 0d 00 00       	mov    0xdd0,%eax
 a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a36:	75 23                	jne    a5b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a38:	c7 45 f0 c8 0d 00 00 	movl   $0xdc8,-0x10(%ebp)
 a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a42:	a3 d0 0d 00 00       	mov    %eax,0xdd0
 a47:	a1 d0 0d 00 00       	mov    0xdd0,%eax
 a4c:	a3 c8 0d 00 00       	mov    %eax,0xdc8
    base.s.size = 0;
 a51:	c7 05 cc 0d 00 00 00 	movl   $0x0,0xdcc
 a58:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5e:	8b 00                	mov    (%eax),%eax
 a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a66:	8b 40 04             	mov    0x4(%eax),%eax
 a69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a6c:	72 4d                	jb     abb <malloc+0xa6>
      if(p->s.size == nunits)
 a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a71:	8b 40 04             	mov    0x4(%eax),%eax
 a74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a77:	75 0c                	jne    a85 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7c:	8b 10                	mov    (%eax),%edx
 a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a81:	89 10                	mov    %edx,(%eax)
 a83:	eb 26                	jmp    aab <malloc+0x96>
      else {
        p->s.size -= nunits;
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 40 04             	mov    0x4(%eax),%eax
 a8b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a8e:	89 c2                	mov    %eax,%edx
 a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a93:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a99:	8b 40 04             	mov    0x4(%eax),%eax
 a9c:	c1 e0 03             	shl    $0x3,%eax
 a9f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aae:	a3 d0 0d 00 00       	mov    %eax,0xdd0
      return (void*)(p + 1);
 ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab6:	83 c0 08             	add    $0x8,%eax
 ab9:	eb 3b                	jmp    af6 <malloc+0xe1>
    }
    if(p == freep)
 abb:	a1 d0 0d 00 00       	mov    0xdd0,%eax
 ac0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ac3:	75 1e                	jne    ae3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ac5:	83 ec 0c             	sub    $0xc,%esp
 ac8:	ff 75 ec             	pushl  -0x14(%ebp)
 acb:	e8 e5 fe ff ff       	call   9b5 <morecore>
 ad0:	83 c4 10             	add    $0x10,%esp
 ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ada:	75 07                	jne    ae3 <malloc+0xce>
        return 0;
 adc:	b8 00 00 00 00       	mov    $0x0,%eax
 ae1:	eb 13                	jmp    af6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aec:	8b 00                	mov    (%eax),%eax
 aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 af1:	e9 6d ff ff ff       	jmp    a63 <malloc+0x4e>
}
 af6:	c9                   	leave  
 af7:	c3                   	ret    
