
_semaphoreexample:     file format elf32-i386


Disassembly of section .text:

00000000 <adder>:
#include "fcntl.h"

#define N  3

//add five in a file
void adder (int s, int pid, char path[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int i,k,fd;
  for(i = 0; i < 5; i++){
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	e9 a9 00 00 00       	jmp    bb <adder+0xbb>
    semdown(s);
  12:	83 ec 0c             	sub    $0xc,%esp
  15:	ff 75 08             	pushl  0x8(%ebp)
  18:	e8 ac 04 00 00       	call   4c9 <semdown>
  1d:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);
  20:	83 ec 08             	sub    $0x8,%esp
  23:	6a 02                	push   $0x2
  25:	ff 75 10             	pushl  0x10(%ebp)
  28:	e8 1c 04 00 00       	call   449 <open>
  2d:	83 c4 10             	add    $0x10,%esp
  30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    read(fd, &k, sizeof(k)); 
  33:	83 ec 04             	sub    $0x4,%esp
  36:	6a 04                	push   $0x4
  38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  3b:	50                   	push   %eax
  3c:	ff 75 f0             	pushl  -0x10(%ebp)
  3f:	e8 dd 03 00 00       	call   421 <read>
  44:	83 c4 10             	add    $0x10,%esp
    close(fd);
  47:	83 ec 0c             	sub    $0xc,%esp
  4a:	ff 75 f0             	pushl  -0x10(%ebp)
  4d:	e8 df 03 00 00       	call   431 <close>
  52:	83 c4 10             	add    $0x10,%esp
    k=k+1;
  55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  58:	83 c0 01             	add    $0x1,%eax
  5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(1," k=%d pid= %d \n",k,pid); 
  5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  61:	ff 75 0c             	pushl  0xc(%ebp)
  64:	50                   	push   %eax
  65:	68 62 09 00 00       	push   $0x962
  6a:	6a 01                	push   $0x1
  6c:	e8 3d 05 00 00       	call   5ae <printf>
  71:	83 c4 10             	add    $0x10,%esp
    fd = open(path, O_RDWR);
  74:	83 ec 08             	sub    $0x8,%esp
  77:	6a 02                	push   $0x2
  79:	ff 75 10             	pushl  0x10(%ebp)
  7c:	e8 c8 03 00 00       	call   449 <open>
  81:	83 c4 10             	add    $0x10,%esp
  84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    write(fd, &k, sizeof(k));
  87:	83 ec 04             	sub    $0x4,%esp
  8a:	6a 04                	push   $0x4
  8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8f:	50                   	push   %eax
  90:	ff 75 f0             	pushl  -0x10(%ebp)
  93:	e8 91 03 00 00       	call   429 <write>
  98:	83 c4 10             	add    $0x10,%esp
    close(fd);
  9b:	83 ec 0c             	sub    $0xc,%esp
  9e:	ff 75 f0             	pushl  -0x10(%ebp)
  a1:	e8 8b 03 00 00       	call   431 <close>
  a6:	83 c4 10             	add    $0x10,%esp
    semup(s);   
  a9:	83 ec 0c             	sub    $0xc,%esp
  ac:	ff 75 08             	pushl  0x8(%ebp)
  af:	e8 1d 04 00 00       	call   4d1 <semup>
  b4:	83 c4 10             	add    $0x10,%esp
#define N  3

//add five in a file
void adder (int s, int pid, char path[]){
  int i,k,fd;
  for(i = 0; i < 5; i++){
  b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  bb:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  bf:	0f 8e 4d ff ff ff    	jle    12 <adder+0x12>
    fd = open(path, O_RDWR);
    write(fd, &k, sizeof(k));
    close(fd);
    semup(s);   
  }
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <main>:

//create N childs and each one call adder
int
main(int argc, char *argv[])
{
  c7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  cb:	83 e4 f0             	and    $0xfffffff0,%esp
  ce:	ff 71 fc             	pushl  -0x4(%ecx)
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	51                   	push   %ecx
  d5:	83 ec 24             	sub    $0x24,%esp
int s,pid,n,k,fd; 
  char path[] = "shared";
  d8:	c7 45 dd 73 68 61 72 	movl   $0x72616873,-0x23(%ebp)
  df:	66 c7 45 e1 65 64    	movw   $0x6465,-0x1f(%ebp)
  e5:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)

  s= semget(-1,1);
  e9:	83 ec 08             	sub    $0x8,%esp
  ec:	6a 01                	push   $0x1
  ee:	6a ff                	push   $0xffffffff
  f0:	e8 c4 03 00 00       	call   4b9 <semget>
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  k=0;
  fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  fd = open(path, O_CREATE|O_RDWR);
 102:	83 ec 08             	sub    $0x8,%esp
 105:	68 02 02 00 00       	push   $0x202
 10a:	8d 45 dd             	lea    -0x23(%ebp),%eax
 10d:	50                   	push   %eax
 10e:	e8 36 03 00 00       	call   449 <open>
 113:	83 c4 10             	add    $0x10,%esp
 116:	89 45 ec             	mov    %eax,-0x14(%ebp)
  write(fd, &k, sizeof(k));
 119:	83 ec 04             	sub    $0x4,%esp
 11c:	6a 04                	push   $0x4
 11e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 121:	50                   	push   %eax
 122:	ff 75 ec             	pushl  -0x14(%ebp)
 125:	e8 ff 02 00 00       	call   429 <write>
 12a:	83 c4 10             	add    $0x10,%esp
  close(fd);
 12d:	83 ec 0c             	sub    $0xc,%esp
 130:	ff 75 ec             	pushl  -0x14(%ebp)
 133:	e8 f9 02 00 00       	call   431 <close>
 138:	83 c4 10             	add    $0x10,%esp
  for(n=0; n<N; n++){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 3f                	jmp    183 <main+0xbc>
    pid = fork(); 
 144:	e8 b8 02 00 00       	call   401 <fork>
 149:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid == 0){
 14c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 150:	75 2d                	jne    17f <main+0xb8>
      adder(s,getpid(),path);
 152:	e8 32 03 00 00       	call   489 <getpid>
 157:	89 c2                	mov    %eax,%edx
 159:	83 ec 04             	sub    $0x4,%esp
 15c:	8d 45 dd             	lea    -0x23(%ebp),%eax
 15f:	50                   	push   %eax
 160:	52                   	push   %edx
 161:	ff 75 f0             	pushl  -0x10(%ebp)
 164:	e8 97 fe ff ff       	call   0 <adder>
 169:	83 c4 10             	add    $0x10,%esp
      semfree(s);
 16c:	83 ec 0c             	sub    $0xc,%esp
 16f:	ff 75 f0             	pushl  -0x10(%ebp)
 172:	e8 4a 03 00 00       	call   4c1 <semfree>
 177:	83 c4 10             	add    $0x10,%esp
      exit();
 17a:	e8 8a 02 00 00       	call   409 <exit>
  s= semget(-1,1);
  k=0;
  fd = open(path, O_CREATE|O_RDWR);
  write(fd, &k, sizeof(k));
  close(fd);
  for(n=0; n<N; n++){
 17f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 183:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 187:	7e bb                	jle    144 <main+0x7d>
      semfree(s);
      exit();
    }       
  }

  for(n=0; n<N; n++){
 189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 190:	eb 09                	jmp    19b <main+0xd4>
    wait();
 192:	e8 7a 02 00 00       	call   411 <wait>
      semfree(s);
      exit();
    }       
  }

  for(n=0; n<N; n++){
 197:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 19b:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 19f:	7e f1                	jle    192 <main+0xcb>
    wait();
  }
  semfree(s);
 1a1:	83 ec 0c             	sub    $0xc,%esp
 1a4:	ff 75 f0             	pushl  -0x10(%ebp)
 1a7:	e8 15 03 00 00       	call   4c1 <semfree>
 1ac:	83 c4 10             	add    $0x10,%esp
  exit();
 1af:	e8 55 02 00 00       	call   409 <exit>

000001b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bc:	8b 55 10             	mov    0x10(%ebp),%edx
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	89 cb                	mov    %ecx,%ebx
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	89 d1                	mov    %edx,%ecx
 1c8:	fc                   	cld    
 1c9:	f3 aa                	rep stos %al,%es:(%edi)
 1cb:	89 ca                	mov    %ecx,%edx
 1cd:	89 fb                	mov    %edi,%ebx
 1cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d5:	5b                   	pop    %ebx
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e5:	90                   	nop
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	8d 50 01             	lea    0x1(%eax),%edx
 1ec:	89 55 08             	mov    %edx,0x8(%ebp)
 1ef:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f2:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f8:	0f b6 12             	movzbl (%edx),%edx
 1fb:	88 10                	mov    %dl,(%eax)
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	84 c0                	test   %al,%al
 202:	75 e2                	jne    1e6 <strcpy+0xd>
    ;
  return os;
 204:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20c:	eb 08                	jmp    216 <strcmp+0xd>
    p++, q++;
 20e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 212:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	84 c0                	test   %al,%al
 21e:	74 10                	je     230 <strcmp+0x27>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 10             	movzbl (%eax),%edx
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	38 c2                	cmp    %al,%dl
 22e:	74 de                	je     20e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	0f b6 d0             	movzbl %al,%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	0f b6 c0             	movzbl %al,%eax
 242:	29 c2                	sub    %eax,%edx
 244:	89 d0                	mov    %edx,%eax
}
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    

00000248 <strlen>:

uint
strlen(char *s)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 255:	eb 04                	jmp    25b <strlen+0x13>
 257:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	01 d0                	add    %edx,%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	84 c0                	test   %al,%al
 268:	75 ed                	jne    257 <strlen+0xf>
    ;
  return n;
 26a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26d:	c9                   	leave  
 26e:	c3                   	ret    

0000026f <memset>:

void*
memset(void *dst, int c, uint n)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 272:	8b 45 10             	mov    0x10(%ebp),%eax
 275:	50                   	push   %eax
 276:	ff 75 0c             	pushl  0xc(%ebp)
 279:	ff 75 08             	pushl  0x8(%ebp)
 27c:	e8 33 ff ff ff       	call   1b4 <stosb>
 281:	83 c4 0c             	add    $0xc,%esp
  return dst;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <strchr>:

char*
strchr(const char *s, char c)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 04             	sub    $0x4,%esp
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 295:	eb 14                	jmp    2ab <strchr+0x22>
    if(*s == c)
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a0:	75 05                	jne    2a7 <strchr+0x1e>
      return (char*)s;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	eb 13                	jmp    2ba <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	0f b6 00             	movzbl (%eax),%eax
 2b1:	84 c0                	test   %al,%al
 2b3:	75 e2                	jne    297 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <gets>:

char*
gets(char *buf, int max)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2c9:	eb 44                	jmp    30f <gets+0x53>
    cc = read(0, &c, 1);
 2cb:	83 ec 04             	sub    $0x4,%esp
 2ce:	6a 01                	push   $0x1
 2d0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2d3:	50                   	push   %eax
 2d4:	6a 00                	push   $0x0
 2d6:	e8 46 01 00 00       	call   421 <read>
 2db:	83 c4 10             	add    $0x10,%esp
 2de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2e5:	7f 02                	jg     2e9 <gets+0x2d>
      break;
 2e7:	eb 31                	jmp    31a <gets+0x5e>
    buf[i++] = c;
 2e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ec:	8d 50 01             	lea    0x1(%eax),%edx
 2ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2f2:	89 c2                	mov    %eax,%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	01 c2                	add    %eax,%edx
 2f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2fd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 303:	3c 0a                	cmp    $0xa,%al
 305:	74 13                	je     31a <gets+0x5e>
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0d                	cmp    $0xd,%al
 30d:	74 0b                	je     31a <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 312:	83 c0 01             	add    $0x1,%eax
 315:	3b 45 0c             	cmp    0xc(%ebp),%eax
 318:	7c b1                	jl     2cb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 31a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	01 d0                	add    %edx,%eax
 322:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <stat>:

int
stat(char *n, struct stat *st)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 330:	83 ec 08             	sub    $0x8,%esp
 333:	6a 00                	push   $0x0
 335:	ff 75 08             	pushl  0x8(%ebp)
 338:	e8 0c 01 00 00       	call   449 <open>
 33d:	83 c4 10             	add    $0x10,%esp
 340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 347:	79 07                	jns    350 <stat+0x26>
    return -1;
 349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 34e:	eb 25                	jmp    375 <stat+0x4b>
  r = fstat(fd, st);
 350:	83 ec 08             	sub    $0x8,%esp
 353:	ff 75 0c             	pushl  0xc(%ebp)
 356:	ff 75 f4             	pushl  -0xc(%ebp)
 359:	e8 03 01 00 00       	call   461 <fstat>
 35e:	83 c4 10             	add    $0x10,%esp
 361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 364:	83 ec 0c             	sub    $0xc,%esp
 367:	ff 75 f4             	pushl  -0xc(%ebp)
 36a:	e8 c2 00 00 00       	call   431 <close>
 36f:	83 c4 10             	add    $0x10,%esp
  return r;
 372:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <atoi>:

int
atoi(const char *s)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 37d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 384:	eb 25                	jmp    3ab <atoi+0x34>
    n = n*10 + *s++ - '0';
 386:	8b 55 fc             	mov    -0x4(%ebp),%edx
 389:	89 d0                	mov    %edx,%eax
 38b:	c1 e0 02             	shl    $0x2,%eax
 38e:	01 d0                	add    %edx,%eax
 390:	01 c0                	add    %eax,%eax
 392:	89 c1                	mov    %eax,%ecx
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	8d 50 01             	lea    0x1(%eax),%edx
 39a:	89 55 08             	mov    %edx,0x8(%ebp)
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	0f be c0             	movsbl %al,%eax
 3a3:	01 c8                	add    %ecx,%eax
 3a5:	83 e8 30             	sub    $0x30,%eax
 3a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 00             	movzbl (%eax),%eax
 3b1:	3c 2f                	cmp    $0x2f,%al
 3b3:	7e 0a                	jle    3bf <atoi+0x48>
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	3c 39                	cmp    $0x39,%al
 3bd:	7e c7                	jle    386 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3d6:	eb 17                	jmp    3ef <memmove+0x2b>
    *dst++ = *src++;
 3d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3db:	8d 50 01             	lea    0x1(%eax),%edx
 3de:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e4:	8d 4a 01             	lea    0x1(%edx),%ecx
 3e7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3ea:	0f b6 12             	movzbl (%edx),%edx
 3ed:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ef:	8b 45 10             	mov    0x10(%ebp),%eax
 3f2:	8d 50 ff             	lea    -0x1(%eax),%edx
 3f5:	89 55 10             	mov    %edx,0x10(%ebp)
 3f8:	85 c0                	test   %eax,%eax
 3fa:	7f dc                	jg     3d8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 401:	b8 01 00 00 00       	mov    $0x1,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <exit>:
SYSCALL(exit)
 409:	b8 02 00 00 00       	mov    $0x2,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <wait>:
SYSCALL(wait)
 411:	b8 03 00 00 00       	mov    $0x3,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <pipe>:
SYSCALL(pipe)
 419:	b8 04 00 00 00       	mov    $0x4,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <read>:
SYSCALL(read)
 421:	b8 05 00 00 00       	mov    $0x5,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <write>:
SYSCALL(write)
 429:	b8 10 00 00 00       	mov    $0x10,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <close>:
SYSCALL(close)
 431:	b8 15 00 00 00       	mov    $0x15,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <kill>:
SYSCALL(kill)
 439:	b8 06 00 00 00       	mov    $0x6,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <exec>:
SYSCALL(exec)
 441:	b8 07 00 00 00       	mov    $0x7,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <open>:
SYSCALL(open)
 449:	b8 0f 00 00 00       	mov    $0xf,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <mknod>:
SYSCALL(mknod)
 451:	b8 11 00 00 00       	mov    $0x11,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <unlink>:
SYSCALL(unlink)
 459:	b8 12 00 00 00       	mov    $0x12,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <fstat>:
SYSCALL(fstat)
 461:	b8 08 00 00 00       	mov    $0x8,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <link>:
SYSCALL(link)
 469:	b8 13 00 00 00       	mov    $0x13,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <mkdir>:
SYSCALL(mkdir)
 471:	b8 14 00 00 00       	mov    $0x14,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <chdir>:
SYSCALL(chdir)
 479:	b8 09 00 00 00       	mov    $0x9,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <dup>:
SYSCALL(dup)
 481:	b8 0a 00 00 00       	mov    $0xa,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <getpid>:
SYSCALL(getpid)
 489:	b8 0b 00 00 00       	mov    $0xb,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <sbrk>:
SYSCALL(sbrk)
 491:	b8 0c 00 00 00       	mov    $0xc,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <sleep>:
SYSCALL(sleep)
 499:	b8 0d 00 00 00       	mov    $0xd,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <uptime>:
SYSCALL(uptime)
 4a1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <procstat>:
SYSCALL(procstat)
 4a9:	b8 16 00 00 00       	mov    $0x16,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <set_priority>:
SYSCALL(set_priority)
 4b1:	b8 17 00 00 00       	mov    $0x17,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <semget>:
SYSCALL(semget)
 4b9:	b8 18 00 00 00       	mov    $0x18,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <semfree>:
SYSCALL(semfree)
 4c1:	b8 19 00 00 00       	mov    $0x19,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <semdown>:
SYSCALL(semdown)
 4c9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <semup>:
 4d1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
 4dc:	83 ec 18             	sub    $0x18,%esp
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e5:	83 ec 04             	sub    $0x4,%esp
 4e8:	6a 01                	push   $0x1
 4ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ed:	50                   	push   %eax
 4ee:	ff 75 08             	pushl  0x8(%ebp)
 4f1:	e8 33 ff ff ff       	call   429 <write>
 4f6:	83 c4 10             	add    $0x10,%esp
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	53                   	push   %ebx
 4ff:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 509:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 50d:	74 17                	je     526 <printint+0x2b>
 50f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 513:	79 11                	jns    526 <printint+0x2b>
    neg = 1;
 515:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	f7 d8                	neg    %eax
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
 524:	eb 06                	jmp    52c <printint+0x31>
  } else {
    x = xx;
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 52c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 533:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 536:	8d 41 01             	lea    0x1(%ecx),%eax
 539:	89 45 f4             	mov    %eax,-0xc(%ebp)
 53c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 53f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 542:	ba 00 00 00 00       	mov    $0x0,%edx
 547:	f7 f3                	div    %ebx
 549:	89 d0                	mov    %edx,%eax
 54b:	0f b6 80 e4 0b 00 00 	movzbl 0xbe4(%eax),%eax
 552:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 556:	8b 5d 10             	mov    0x10(%ebp),%ebx
 559:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55c:	ba 00 00 00 00       	mov    $0x0,%edx
 561:	f7 f3                	div    %ebx
 563:	89 45 ec             	mov    %eax,-0x14(%ebp)
 566:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56a:	75 c7                	jne    533 <printint+0x38>
  if(neg)
 56c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 570:	74 0e                	je     580 <printint+0x85>
    buf[i++] = '-';
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	8d 50 01             	lea    0x1(%eax),%edx
 578:	89 55 f4             	mov    %edx,-0xc(%ebp)
 57b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 580:	eb 1d                	jmp    59f <printint+0xa4>
    putc(fd, buf[i]);
 582:	8d 55 dc             	lea    -0x24(%ebp),%edx
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	01 d0                	add    %edx,%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 3d ff ff ff       	call   4d9 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 59f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a7:	79 d9                	jns    582 <printint+0x87>
    putc(fd, buf[i]);
}
 5a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ac:	c9                   	leave  
 5ad:	c3                   	ret    

000005ae <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5bb:	8d 45 0c             	lea    0xc(%ebp),%eax
 5be:	83 c0 04             	add    $0x4,%eax
 5c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5cb:	e9 59 01 00 00       	jmp    729 <printf+0x17b>
    c = fmt[i] & 0xff;
 5d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d6:	01 d0                	add    %edx,%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	25 ff 00 00 00       	and    $0xff,%eax
 5e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ea:	75 2c                	jne    618 <printf+0x6a>
      if(c == '%'){
 5ec:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f0:	75 0c                	jne    5fe <printf+0x50>
        state = '%';
 5f2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f9:	e9 27 01 00 00       	jmp    725 <printf+0x177>
      } else {
        putc(fd, c);
 5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	83 ec 08             	sub    $0x8,%esp
 607:	50                   	push   %eax
 608:	ff 75 08             	pushl  0x8(%ebp)
 60b:	e8 c9 fe ff ff       	call   4d9 <putc>
 610:	83 c4 10             	add    $0x10,%esp
 613:	e9 0d 01 00 00       	jmp    725 <printf+0x177>
      }
    } else if(state == '%'){
 618:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 61c:	0f 85 03 01 00 00    	jne    725 <printf+0x177>
      if(c == 'd'){
 622:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 626:	75 1e                	jne    646 <printf+0x98>
        printint(fd, *ap, 10, 1);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	6a 01                	push   $0x1
 62f:	6a 0a                	push   $0xa
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 c1 fe ff ff       	call   4fb <printint>
 63a:	83 c4 10             	add    $0x10,%esp
        ap++;
 63d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 641:	e9 d8 00 00 00       	jmp    71e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 646:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64a:	74 06                	je     652 <printf+0xa4>
 64c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 650:	75 1e                	jne    670 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 652:	8b 45 e8             	mov    -0x18(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	6a 00                	push   $0x0
 659:	6a 10                	push   $0x10
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 97 fe ff ff       	call   4fb <printint>
 664:	83 c4 10             	add    $0x10,%esp
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	e9 ae 00 00 00       	jmp    71e <printf+0x170>
      } else if(c == 's'){
 670:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 674:	75 43                	jne    6b9 <printf+0x10b>
        s = (char*)*ap;
 676:	8b 45 e8             	mov    -0x18(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 67e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 686:	75 07                	jne    68f <printf+0xe1>
          s = "(null)";
 688:	c7 45 f4 72 09 00 00 	movl   $0x972,-0xc(%ebp)
        while(*s != 0){
 68f:	eb 1c                	jmp    6ad <printf+0xff>
          putc(fd, *s);
 691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 694:	0f b6 00             	movzbl (%eax),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	83 ec 08             	sub    $0x8,%esp
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 33 fe ff ff       	call   4d9 <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
          s++;
 6a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b0:	0f b6 00             	movzbl (%eax),%eax
 6b3:	84 c0                	test   %al,%al
 6b5:	75 da                	jne    691 <printf+0xe3>
 6b7:	eb 65                	jmp    71e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6bd:	75 1d                	jne    6dc <printf+0x12e>
        putc(fd, *ap);
 6bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	0f be c0             	movsbl %al,%eax
 6c7:	83 ec 08             	sub    $0x8,%esp
 6ca:	50                   	push   %eax
 6cb:	ff 75 08             	pushl  0x8(%ebp)
 6ce:	e8 06 fe ff ff       	call   4d9 <putc>
 6d3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6da:	eb 42                	jmp    71e <printf+0x170>
      } else if(c == '%'){
 6dc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e0:	75 17                	jne    6f9 <printf+0x14b>
        putc(fd, c);
 6e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	83 ec 08             	sub    $0x8,%esp
 6eb:	50                   	push   %eax
 6ec:	ff 75 08             	pushl  0x8(%ebp)
 6ef:	e8 e5 fd ff ff       	call   4d9 <putc>
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	eb 25                	jmp    71e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	6a 25                	push   $0x25
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 d3 fd ff ff       	call   4d9 <putc>
 706:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70c:	0f be c0             	movsbl %al,%eax
 70f:	83 ec 08             	sub    $0x8,%esp
 712:	50                   	push   %eax
 713:	ff 75 08             	pushl  0x8(%ebp)
 716:	e8 be fd ff ff       	call   4d9 <putc>
 71b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 71e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 725:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 729:	8b 55 0c             	mov    0xc(%ebp),%edx
 72c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72f:	01 d0                	add    %edx,%eax
 731:	0f b6 00             	movzbl (%eax),%eax
 734:	84 c0                	test   %al,%al
 736:	0f 85 94 fe ff ff    	jne    5d0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 73c:	c9                   	leave  
 73d:	c3                   	ret    

0000073e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	83 e8 08             	sub    $0x8,%eax
 74a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74d:	a1 00 0c 00 00       	mov    0xc00,%eax
 752:	89 45 fc             	mov    %eax,-0x4(%ebp)
 755:	eb 24                	jmp    77b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75f:	77 12                	ja     773 <free+0x35>
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 767:	77 24                	ja     78d <free+0x4f>
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 771:	77 1a                	ja     78d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	76 d4                	jbe    757 <free+0x19>
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	76 ca                	jbe    757 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	01 c2                	add    %eax,%edx
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	39 c2                	cmp    %eax,%edx
 7a6:	75 24                	jne    7cc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ab:	8b 50 04             	mov    0x4(%eax),%edx
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	01 c2                	add    %eax,%edx
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
 7ca:	eb 0a                	jmp    7d6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 10                	mov    (%eax),%edx
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 40 04             	mov    0x4(%eax),%eax
 7dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	01 d0                	add    %edx,%eax
 7e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7eb:	75 20                	jne    80d <free+0xcf>
    p->s.size += bp->s.size;
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 50 04             	mov    0x4(%eax),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	01 c2                	add    %eax,%edx
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	8b 10                	mov    (%eax),%edx
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	89 10                	mov    %edx,(%eax)
 80b:	eb 08                	jmp    815 <free+0xd7>
  } else
    p->s.ptr = bp;
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8b 55 f8             	mov    -0x8(%ebp),%edx
 813:	89 10                	mov    %edx,(%eax)
  freep = p;
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	a3 00 0c 00 00       	mov    %eax,0xc00
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <morecore>:

static Header*
morecore(uint nu)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 825:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 82c:	77 07                	ja     835 <morecore+0x16>
    nu = 4096;
 82e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	c1 e0 03             	shl    $0x3,%eax
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	50                   	push   %eax
 83f:	e8 4d fc ff ff       	call   491 <sbrk>
 844:	83 c4 10             	add    $0x10,%esp
 847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 84a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 84e:	75 07                	jne    857 <morecore+0x38>
    return 0;
 850:	b8 00 00 00 00       	mov    $0x0,%eax
 855:	eb 26                	jmp    87d <morecore+0x5e>
  hp = (Header*)p;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	8b 55 08             	mov    0x8(%ebp),%edx
 863:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 866:	8b 45 f0             	mov    -0x10(%ebp),%eax
 869:	83 c0 08             	add    $0x8,%eax
 86c:	83 ec 0c             	sub    $0xc,%esp
 86f:	50                   	push   %eax
 870:	e8 c9 fe ff ff       	call   73e <free>
 875:	83 c4 10             	add    $0x10,%esp
  return freep;
 878:	a1 00 0c 00 00       	mov    0xc00,%eax
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    

0000087f <malloc>:

void*
malloc(uint nbytes)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	83 c0 07             	add    $0x7,%eax
 88b:	c1 e8 03             	shr    $0x3,%eax
 88e:	83 c0 01             	add    $0x1,%eax
 891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 894:	a1 00 0c 00 00       	mov    0xc00,%eax
 899:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a0:	75 23                	jne    8c5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8a2:	c7 45 f0 f8 0b 00 00 	movl   $0xbf8,-0x10(%ebp)
 8a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ac:	a3 00 0c 00 00       	mov    %eax,0xc00
 8b1:	a1 00 0c 00 00       	mov    0xc00,%eax
 8b6:	a3 f8 0b 00 00       	mov    %eax,0xbf8
    base.s.size = 0;
 8bb:	c7 05 fc 0b 00 00 00 	movl   $0x0,0xbfc
 8c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d6:	72 4d                	jb     925 <malloc+0xa6>
      if(p->s.size == nunits)
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e1:	75 0c                	jne    8ef <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 10                	mov    (%eax),%edx
 8e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8eb:	89 10                	mov    %edx,(%eax)
 8ed:	eb 26                	jmp    915 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8b 40 04             	mov    0x4(%eax),%eax
 8f5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8f8:	89 c2                	mov    %eax,%edx
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	c1 e0 03             	shl    $0x3,%eax
 909:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 912:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 915:	8b 45 f0             	mov    -0x10(%ebp),%eax
 918:	a3 00 0c 00 00       	mov    %eax,0xc00
      return (void*)(p + 1);
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	83 c0 08             	add    $0x8,%eax
 923:	eb 3b                	jmp    960 <malloc+0xe1>
    }
    if(p == freep)
 925:	a1 00 0c 00 00       	mov    0xc00,%eax
 92a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 92d:	75 1e                	jne    94d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 92f:	83 ec 0c             	sub    $0xc,%esp
 932:	ff 75 ec             	pushl  -0x14(%ebp)
 935:	e8 e5 fe ff ff       	call   81f <morecore>
 93a:	83 c4 10             	add    $0x10,%esp
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 940:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 944:	75 07                	jne    94d <malloc+0xce>
        return 0;
 946:	b8 00 00 00 00       	mov    $0x0,%eax
 94b:	eb 13                	jmp    960 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	89 45 f0             	mov    %eax,-0x10(%ebp)
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 95b:	e9 6d ff ff ff       	jmp    8cd <malloc+0x4e>
}
 960:	c9                   	leave  
 961:	c3                   	ret    
