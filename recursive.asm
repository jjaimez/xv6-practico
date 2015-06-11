
_recursive:     file format elf32-i386


Disassembly of section .text:

00000000 <recursive>:
#include "user.h"


int
recursive(int n)
{  
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int r = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (n>1){
   d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  11:	7e 1a                	jle    2d <recursive+0x2d>
    r = recursive(n-1) ;
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	83 e8 01             	sub    $0x1,%eax
  19:	83 ec 0c             	sub    $0xc,%esp
  1c:	50                   	push   %eax
  1d:	e8 de ff ff ff       	call   0 <recursive>
  22:	83 c4 10             	add    $0x10,%esp
  25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return r;
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	eb 05                	jmp    32 <recursive+0x32>
  } 
  else
    return 1;         
  2d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  32:	c9                   	leave  
  33:	c3                   	ret    

00000034 <main>:

int
main(int argc, char *argv[])
{
  34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  38:	83 e4 f0             	and    $0xfffffff0,%esp
  3b:	ff 71 fc             	pushl  -0x4(%ecx)
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	51                   	push   %ecx
  42:	83 ec 04             	sub    $0x4,%esp
  if(fork()==0){
  45:	e8 c6 02 00 00       	call   310 <fork>
  4a:	85 c0                	test   %eax,%eax
  4c:	75 27                	jne    75 <main+0x41>
    recursive(250);
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	68 fa 00 00 00       	push   $0xfa
  56:	e8 a5 ff ff ff       	call   0 <recursive>
  5b:	83 c4 10             	add    $0x10,%esp
    printf(1,"finish 1 \n");
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	68 74 08 00 00       	push   $0x874
  66:	6a 01                	push   $0x1
  68:	e8 50 04 00 00       	call   4bd <printf>
  6d:	83 c4 10             	add    $0x10,%esp
    exit();
  70:	e8 a3 02 00 00       	call   318 <exit>
  } else {
  wait();
  75:	e8 a6 02 00 00       	call   320 <wait>
  recursive(250);
  7a:	83 ec 0c             	sub    $0xc,%esp
  7d:	68 fa 00 00 00       	push   $0xfa
  82:	e8 79 ff ff ff       	call   0 <recursive>
  87:	83 c4 10             	add    $0x10,%esp
  printf(1,"finish 1 \n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 74 08 00 00       	push   $0x874
  92:	6a 01                	push   $0x1
  94:	e8 24 04 00 00       	call   4bd <printf>
  99:	83 c4 10             	add    $0x10,%esp
  printf(1,"the next execution maybe not work (trap 14) \n");
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	68 80 08 00 00       	push   $0x880
  a4:	6a 01                	push   $0x1
  a6:	e8 12 04 00 00       	call   4bd <printf>
  ab:	83 c4 10             	add    $0x10,%esp
  recursive(300);
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	68 2c 01 00 00       	push   $0x12c
  b6:	e8 45 ff ff ff       	call   0 <recursive>
  bb:	83 c4 10             	add    $0x10,%esp
  exit();
  be:	e8 55 02 00 00       	call   318 <exit>

000000c3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  c6:	57                   	push   %edi
  c7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cb:	8b 55 10             	mov    0x10(%ebp),%edx
  ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  d1:	89 cb                	mov    %ecx,%ebx
  d3:	89 df                	mov    %ebx,%edi
  d5:	89 d1                	mov    %edx,%ecx
  d7:	fc                   	cld    
  d8:	f3 aa                	rep stos %al,%es:(%edi)
  da:	89 ca                	mov    %ecx,%edx
  dc:	89 fb                	mov    %edi,%ebx
  de:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e4:	5b                   	pop    %ebx
  e5:	5f                   	pop    %edi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f4:	90                   	nop
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8d 50 01             	lea    0x1(%eax),%edx
  fb:	89 55 08             	mov    %edx,0x8(%ebp)
  fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 101:	8d 4a 01             	lea    0x1(%edx),%ecx
 104:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 107:	0f b6 12             	movzbl (%edx),%edx
 10a:	88 10                	mov    %dl,(%eax)
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	75 e2                	jne    f5 <strcpy+0xd>
    ;
  return os;
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11b:	eb 08                	jmp    125 <strcmp+0xd>
    p++, q++;
 11d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 121:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	74 10                	je     13f <strcmp+0x27>
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 10             	movzbl (%eax),%edx
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	38 c2                	cmp    %al,%dl
 13d:	74 de                	je     11d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	0f b6 d0             	movzbl %al,%edx
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	0f b6 c0             	movzbl %al,%eax
 151:	29 c2                	sub    %eax,%edx
 153:	89 d0                	mov    %edx,%eax
}
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <strlen>:

uint
strlen(char *s)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 164:	eb 04                	jmp    16a <strlen+0x13>
 166:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	84 c0                	test   %al,%al
 177:	75 ed                	jne    166 <strlen+0xf>
    ;
  return n;
 179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 181:	8b 45 10             	mov    0x10(%ebp),%eax
 184:	50                   	push   %eax
 185:	ff 75 0c             	pushl  0xc(%ebp)
 188:	ff 75 08             	pushl  0x8(%ebp)
 18b:	e8 33 ff ff ff       	call   c3 <stosb>
 190:	83 c4 0c             	add    $0xc,%esp
  return dst;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a4:	eb 14                	jmp    1ba <strchr+0x22>
    if(*s == c)
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1af:	75 05                	jne    1b6 <strchr+0x1e>
      return (char*)s;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	eb 13                	jmp    1c9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	84 c0                	test   %al,%al
 1c2:	75 e2                	jne    1a6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <gets>:

char*
gets(char *buf, int max)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d8:	eb 44                	jmp    21e <gets+0x53>
    cc = read(0, &c, 1);
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	6a 01                	push   $0x1
 1df:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e2:	50                   	push   %eax
 1e3:	6a 00                	push   $0x0
 1e5:	e8 46 01 00 00       	call   330 <read>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f4:	7f 02                	jg     1f8 <gets+0x2d>
      break;
 1f6:	eb 31                	jmp    229 <gets+0x5e>
    buf[i++] = c;
 1f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 201:	89 c2                	mov    %eax,%edx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	01 c2                	add    %eax,%edx
 208:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 212:	3c 0a                	cmp    $0xa,%al
 214:	74 13                	je     229 <gets+0x5e>
 216:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21a:	3c 0d                	cmp    $0xd,%al
 21c:	74 0b                	je     229 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	83 c0 01             	add    $0x1,%eax
 224:	3b 45 0c             	cmp    0xc(%ebp),%eax
 227:	7c b1                	jl     1da <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 229:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	01 d0                	add    %edx,%eax
 231:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <stat>:

int
stat(char *n, struct stat *st)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	6a 00                	push   $0x0
 244:	ff 75 08             	pushl  0x8(%ebp)
 247:	e8 0c 01 00 00       	call   358 <open>
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 256:	79 07                	jns    25f <stat+0x26>
    return -1;
 258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25d:	eb 25                	jmp    284 <stat+0x4b>
  r = fstat(fd, st);
 25f:	83 ec 08             	sub    $0x8,%esp
 262:	ff 75 0c             	pushl  0xc(%ebp)
 265:	ff 75 f4             	pushl  -0xc(%ebp)
 268:	e8 03 01 00 00       	call   370 <fstat>
 26d:	83 c4 10             	add    $0x10,%esp
 270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 273:	83 ec 0c             	sub    $0xc,%esp
 276:	ff 75 f4             	pushl  -0xc(%ebp)
 279:	e8 c2 00 00 00       	call   340 <close>
 27e:	83 c4 10             	add    $0x10,%esp
  return r;
 281:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <atoi>:

int
atoi(const char *s)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 28c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 293:	eb 25                	jmp    2ba <atoi+0x34>
    n = n*10 + *s++ - '0';
 295:	8b 55 fc             	mov    -0x4(%ebp),%edx
 298:	89 d0                	mov    %edx,%eax
 29a:	c1 e0 02             	shl    $0x2,%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	01 c0                	add    %eax,%eax
 2a1:	89 c1                	mov    %eax,%ecx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	0f be c0             	movsbl %al,%eax
 2b2:	01 c8                	add    %ecx,%eax
 2b4:	83 e8 30             	sub    $0x30,%eax
 2b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	3c 2f                	cmp    $0x2f,%al
 2c2:	7e 0a                	jle    2ce <atoi+0x48>
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	3c 39                	cmp    $0x39,%al
 2cc:	7e c7                	jle    295 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2df:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2e5:	eb 17                	jmp    2fe <memmove+0x2b>
    *dst++ = *src++;
 2e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ea:	8d 50 01             	lea    0x1(%eax),%edx
 2ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2f6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f9:	0f b6 12             	movzbl (%edx),%edx
 2fc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
 301:	8d 50 ff             	lea    -0x1(%eax),%edx
 304:	89 55 10             	mov    %edx,0x10(%ebp)
 307:	85 c0                	test   %eax,%eax
 309:	7f dc                	jg     2e7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 310:	b8 01 00 00 00       	mov    $0x1,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exit>:
SYSCALL(exit)
 318:	b8 02 00 00 00       	mov    $0x2,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <wait>:
SYSCALL(wait)
 320:	b8 03 00 00 00       	mov    $0x3,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <pipe>:
SYSCALL(pipe)
 328:	b8 04 00 00 00       	mov    $0x4,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <read>:
SYSCALL(read)
 330:	b8 05 00 00 00       	mov    $0x5,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <write>:
SYSCALL(write)
 338:	b8 10 00 00 00       	mov    $0x10,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <close>:
SYSCALL(close)
 340:	b8 15 00 00 00       	mov    $0x15,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <kill>:
SYSCALL(kill)
 348:	b8 06 00 00 00       	mov    $0x6,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <exec>:
SYSCALL(exec)
 350:	b8 07 00 00 00       	mov    $0x7,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <open>:
SYSCALL(open)
 358:	b8 0f 00 00 00       	mov    $0xf,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mknod>:
SYSCALL(mknod)
 360:	b8 11 00 00 00       	mov    $0x11,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <unlink>:
SYSCALL(unlink)
 368:	b8 12 00 00 00       	mov    $0x12,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <fstat>:
SYSCALL(fstat)
 370:	b8 08 00 00 00       	mov    $0x8,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <link>:
SYSCALL(link)
 378:	b8 13 00 00 00       	mov    $0x13,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <mkdir>:
SYSCALL(mkdir)
 380:	b8 14 00 00 00       	mov    $0x14,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <chdir>:
SYSCALL(chdir)
 388:	b8 09 00 00 00       	mov    $0x9,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <dup>:
SYSCALL(dup)
 390:	b8 0a 00 00 00       	mov    $0xa,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <getpid>:
SYSCALL(getpid)
 398:	b8 0b 00 00 00       	mov    $0xb,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <sbrk>:
SYSCALL(sbrk)
 3a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <sleep>:
SYSCALL(sleep)
 3a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <uptime>:
SYSCALL(uptime)
 3b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <procstat>:
SYSCALL(procstat)
 3b8:	b8 16 00 00 00       	mov    $0x16,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <set_priority>:
SYSCALL(set_priority)
 3c0:	b8 17 00 00 00       	mov    $0x17,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <semget>:
SYSCALL(semget)
 3c8:	b8 18 00 00 00       	mov    $0x18,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <semfree>:
SYSCALL(semfree)
 3d0:	b8 19 00 00 00       	mov    $0x19,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <semdown>:
SYSCALL(semdown)
 3d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <semup>:
 3e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 18             	sub    $0x18,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f4:	83 ec 04             	sub    $0x4,%esp
 3f7:	6a 01                	push   $0x1
 3f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fc:	50                   	push   %eax
 3fd:	ff 75 08             	pushl  0x8(%ebp)
 400:	e8 33 ff ff ff       	call   338 <write>
 405:	83 c4 10             	add    $0x10,%esp
}
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	53                   	push   %ebx
 40e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 418:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41c:	74 17                	je     435 <printint+0x2b>
 41e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 422:	79 11                	jns    435 <printint+0x2b>
    neg = 1;
 424:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	f7 d8                	neg    %eax
 430:	89 45 ec             	mov    %eax,-0x14(%ebp)
 433:	eb 06                	jmp    43b <printint+0x31>
  } else {
    x = xx;
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 442:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 445:	8d 41 01             	lea    0x1(%ecx),%eax
 448:	89 45 f4             	mov    %eax,-0xc(%ebp)
 44b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f3                	div    %ebx
 458:	89 d0                	mov    %edx,%eax
 45a:	0f b6 80 20 0b 00 00 	movzbl 0xb20(%eax),%eax
 461:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 465:	8b 5d 10             	mov    0x10(%ebp),%ebx
 468:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46b:	ba 00 00 00 00       	mov    $0x0,%edx
 470:	f7 f3                	div    %ebx
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 c7                	jne    442 <printint+0x38>
  if(neg)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	74 0e                	je     48f <printint+0x85>
    buf[i++] = '-';
 481:	8b 45 f4             	mov    -0xc(%ebp),%eax
 484:	8d 50 01             	lea    0x1(%eax),%edx
 487:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48f:	eb 1d                	jmp    4ae <printint+0xa4>
    putc(fd, buf[i]);
 491:	8d 55 dc             	lea    -0x24(%ebp),%edx
 494:	8b 45 f4             	mov    -0xc(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	0f be c0             	movsbl %al,%eax
 49f:	83 ec 08             	sub    $0x8,%esp
 4a2:	50                   	push   %eax
 4a3:	ff 75 08             	pushl  0x8(%ebp)
 4a6:	e8 3d ff ff ff       	call   3e8 <putc>
 4ab:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ae:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b6:	79 d9                	jns    491 <printint+0x87>
    putc(fd, buf[i]);
}
 4b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4bb:	c9                   	leave  
 4bc:	c3                   	ret    

000004bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bd:	55                   	push   %ebp
 4be:	89 e5                	mov    %esp,%ebp
 4c0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cd:	83 c0 04             	add    $0x4,%eax
 4d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4da:	e9 59 01 00 00       	jmp    638 <printf+0x17b>
    c = fmt[i] & 0xff;
 4df:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	25 ff 00 00 00       	and    $0xff,%eax
 4f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f9:	75 2c                	jne    527 <printf+0x6a>
      if(c == '%'){
 4fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ff:	75 0c                	jne    50d <printf+0x50>
        state = '%';
 501:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 508:	e9 27 01 00 00       	jmp    634 <printf+0x177>
      } else {
        putc(fd, c);
 50d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	83 ec 08             	sub    $0x8,%esp
 516:	50                   	push   %eax
 517:	ff 75 08             	pushl  0x8(%ebp)
 51a:	e8 c9 fe ff ff       	call   3e8 <putc>
 51f:	83 c4 10             	add    $0x10,%esp
 522:	e9 0d 01 00 00       	jmp    634 <printf+0x177>
      }
    } else if(state == '%'){
 527:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52b:	0f 85 03 01 00 00    	jne    634 <printf+0x177>
      if(c == 'd'){
 531:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 535:	75 1e                	jne    555 <printf+0x98>
        printint(fd, *ap, 10, 1);
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	6a 01                	push   $0x1
 53e:	6a 0a                	push   $0xa
 540:	50                   	push   %eax
 541:	ff 75 08             	pushl  0x8(%ebp)
 544:	e8 c1 fe ff ff       	call   40a <printint>
 549:	83 c4 10             	add    $0x10,%esp
        ap++;
 54c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 550:	e9 d8 00 00 00       	jmp    62d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 555:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 559:	74 06                	je     561 <printf+0xa4>
 55b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55f:	75 1e                	jne    57f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 561:	8b 45 e8             	mov    -0x18(%ebp),%eax
 564:	8b 00                	mov    (%eax),%eax
 566:	6a 00                	push   $0x0
 568:	6a 10                	push   $0x10
 56a:	50                   	push   %eax
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 97 fe ff ff       	call   40a <printint>
 573:	83 c4 10             	add    $0x10,%esp
        ap++;
 576:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57a:	e9 ae 00 00 00       	jmp    62d <printf+0x170>
      } else if(c == 's'){
 57f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 583:	75 43                	jne    5c8 <printf+0x10b>
        s = (char*)*ap;
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 595:	75 07                	jne    59e <printf+0xe1>
          s = "(null)";
 597:	c7 45 f4 ae 08 00 00 	movl   $0x8ae,-0xc(%ebp)
        while(*s != 0){
 59e:	eb 1c                	jmp    5bc <printf+0xff>
          putc(fd, *s);
 5a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a3:	0f b6 00             	movzbl (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 33 fe ff ff       	call   3e8 <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
          s++;
 5b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	0f b6 00             	movzbl (%eax),%eax
 5c2:	84 c0                	test   %al,%al
 5c4:	75 da                	jne    5a0 <printf+0xe3>
 5c6:	eb 65                	jmp    62d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5cc:	75 1d                	jne    5eb <printf+0x12e>
        putc(fd, *ap);
 5ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d1:	8b 00                	mov    (%eax),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	83 ec 08             	sub    $0x8,%esp
 5d9:	50                   	push   %eax
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 06 fe ff ff       	call   3e8 <putc>
 5e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e9:	eb 42                	jmp    62d <printf+0x170>
      } else if(c == '%'){
 5eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ef:	75 17                	jne    608 <printf+0x14b>
        putc(fd, c);
 5f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	83 ec 08             	sub    $0x8,%esp
 5fa:	50                   	push   %eax
 5fb:	ff 75 08             	pushl  0x8(%ebp)
 5fe:	e8 e5 fd ff ff       	call   3e8 <putc>
 603:	83 c4 10             	add    $0x10,%esp
 606:	eb 25                	jmp    62d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	6a 25                	push   $0x25
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 d3 fd ff ff       	call   3e8 <putc>
 615:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	83 ec 08             	sub    $0x8,%esp
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	e8 be fd ff ff       	call   3e8 <putc>
 62a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 634:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 638:	8b 55 0c             	mov    0xc(%ebp),%edx
 63b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63e:	01 d0                	add    %edx,%eax
 640:	0f b6 00             	movzbl (%eax),%eax
 643:	84 c0                	test   %al,%al
 645:	0f 85 94 fe ff ff    	jne    4df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 64b:	c9                   	leave  
 64c:	c3                   	ret    

0000064d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	83 e8 08             	sub    $0x8,%eax
 659:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
 664:	eb 24                	jmp    68a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66e:	77 12                	ja     682 <free+0x35>
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 676:	77 24                	ja     69c <free+0x4f>
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 680:	77 1a                	ja     69c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	76 d4                	jbe    666 <free+0x19>
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69a:	76 ca                	jbe    666 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	39 c2                	cmp    %eax,%edx
 6b5:	75 24                	jne    6db <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 0a                	jmp    6e5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	01 d0                	add    %edx,%eax
 6f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fa:	75 20                	jne    71c <free+0xcf>
    p->s.size += bp->s.size;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 50 04             	mov    0x4(%eax),%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	8b 10                	mov    (%eax),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	89 10                	mov    %edx,(%eax)
 71a:	eb 08                	jmp    724 <free+0xd7>
  } else
    p->s.ptr = bp;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 722:	89 10                	mov    %edx,(%eax)
  freep = p;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	a3 3c 0b 00 00       	mov    %eax,0xb3c
}
 72c:	c9                   	leave  
 72d:	c3                   	ret    

0000072e <morecore>:

static Header*
morecore(uint nu)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 734:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73b:	77 07                	ja     744 <morecore+0x16>
    nu = 4096;
 73d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	c1 e0 03             	shl    $0x3,%eax
 74a:	83 ec 0c             	sub    $0xc,%esp
 74d:	50                   	push   %eax
 74e:	e8 4d fc ff ff       	call   3a0 <sbrk>
 753:	83 c4 10             	add    $0x10,%esp
 756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 759:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 75d:	75 07                	jne    766 <morecore+0x38>
    return 0;
 75f:	b8 00 00 00 00       	mov    $0x0,%eax
 764:	eb 26                	jmp    78c <morecore+0x5e>
  hp = (Header*)p;
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	8b 55 08             	mov    0x8(%ebp),%edx
 772:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	83 c0 08             	add    $0x8,%eax
 77b:	83 ec 0c             	sub    $0xc,%esp
 77e:	50                   	push   %eax
 77f:	e8 c9 fe ff ff       	call   64d <free>
 784:	83 c4 10             	add    $0x10,%esp
  return freep;
 787:	a1 3c 0b 00 00       	mov    0xb3c,%eax
}
 78c:	c9                   	leave  
 78d:	c3                   	ret    

0000078e <malloc>:

void*
malloc(uint nbytes)
{
 78e:	55                   	push   %ebp
 78f:	89 e5                	mov    %esp,%ebp
 791:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	83 c0 07             	add    $0x7,%eax
 79a:	c1 e8 03             	shr    $0x3,%eax
 79d:	83 c0 01             	add    $0x1,%eax
 7a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a3:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 7a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7af:	75 23                	jne    7d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b1:	c7 45 f0 34 0b 00 00 	movl   $0xb34,-0x10(%ebp)
 7b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bb:	a3 3c 0b 00 00       	mov    %eax,0xb3c
 7c0:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 7c5:	a3 34 0b 00 00       	mov    %eax,0xb34
    base.s.size = 0;
 7ca:	c7 05 38 0b 00 00 00 	movl   $0x0,0xb38
 7d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e5:	72 4d                	jb     834 <malloc+0xa6>
      if(p->s.size == nunits)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f0:	75 0c                	jne    7fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 10                	mov    (%eax),%edx
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	89 10                	mov    %edx,(%eax)
 7fc:	eb 26                	jmp    824 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	2b 45 ec             	sub    -0x14(%ebp),%eax
 807:	89 c2                	mov    %eax,%edx
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	c1 e0 03             	shl    $0x3,%eax
 818:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 821:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	a3 3c 0b 00 00       	mov    %eax,0xb3c
      return (void*)(p + 1);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	83 c0 08             	add    $0x8,%eax
 832:	eb 3b                	jmp    86f <malloc+0xe1>
    }
    if(p == freep)
 834:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 839:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 83c:	75 1e                	jne    85c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 83e:	83 ec 0c             	sub    $0xc,%esp
 841:	ff 75 ec             	pushl  -0x14(%ebp)
 844:	e8 e5 fe ff ff       	call   72e <morecore>
 849:	83 c4 10             	add    $0x10,%esp
 84c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 853:	75 07                	jne    85c <malloc+0xce>
        return 0;
 855:	b8 00 00 00 00       	mov    $0x0,%eax
 85a:	eb 13                	jmp    86f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 86a:	e9 6d ff ff ff       	jmp    7dc <malloc+0x4e>
}
 86f:	c9                   	leave  
 870:	c3                   	ret    
