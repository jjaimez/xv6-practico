
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 63 02 00 00       	call   279 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ed 02 00 00       	call   311 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 55 02 00 00       	call   281 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	5d                   	pop    %ebp
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8d 50 01             	lea    0x1(%eax),%edx
  64:	89 55 08             	mov    %edx,0x8(%ebp)
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  70:	0f b6 12             	movzbl (%edx),%edx
  73:	88 10                	mov    %dl,(%eax)
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0xd>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  84:	eb 08                	jmp    8e <strcmp+0xd>
    p++, q++;
  86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	84 c0                	test   %al,%al
  96:	74 10                	je     a8 <strcmp+0x27>
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	0f b6 10             	movzbl (%eax),%edx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 00             	movzbl (%eax),%eax
  a4:	38 c2                	cmp    %al,%dl
  a6:	74 de                	je     86 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 d0             	movzbl %al,%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	0f b6 c0             	movzbl %al,%eax
  ba:	29 c2                	sub    %eax,%edx
  bc:	89 d0                	mov    %edx,%eax
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <strlen>:

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cd:	eb 04                	jmp    d3 <strlen+0x13>
  cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	01 d0                	add    %edx,%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	84 c0                	test   %al,%al
  e0:	75 ed                	jne    cf <strlen+0xf>
    ;
  return n;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ea:	8b 45 10             	mov    0x10(%ebp),%eax
  ed:	50                   	push   %eax
  ee:	ff 75 0c             	pushl  0xc(%ebp)
  f1:	ff 75 08             	pushl  0x8(%ebp)
  f4:	e8 33 ff ff ff       	call   2c <stosb>
  f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strchr>:

char*
strchr(const char *s, char c)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 04             	sub    $0x4,%esp
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10d:	eb 14                	jmp    123 <strchr+0x22>
    if(*s == c)
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	3a 45 fc             	cmp    -0x4(%ebp),%al
 118:	75 05                	jne    11f <strchr+0x1e>
      return (char*)s;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	eb 13                	jmp    132 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	84 c0                	test   %al,%al
 12b:	75 e2                	jne    10f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 141:	eb 44                	jmp    187 <gets+0x53>
    cc = read(0, &c, 1);
 143:	83 ec 04             	sub    $0x4,%esp
 146:	6a 01                	push   $0x1
 148:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14b:	50                   	push   %eax
 14c:	6a 00                	push   $0x0
 14e:	e8 46 01 00 00       	call   299 <read>
 153:	83 c4 10             	add    $0x10,%esp
 156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15d:	7f 02                	jg     161 <gets+0x2d>
      break;
 15f:	eb 31                	jmp    192 <gets+0x5e>
    buf[i++] = c;
 161:	8b 45 f4             	mov    -0xc(%ebp),%eax
 164:	8d 50 01             	lea    0x1(%eax),%edx
 167:	89 55 f4             	mov    %edx,-0xc(%ebp)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	01 c2                	add    %eax,%edx
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	3c 0a                	cmp    $0xa,%al
 17d:	74 13                	je     192 <gets+0x5e>
 17f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 0b                	je     192 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 187:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18a:	83 c0 01             	add    $0x1,%eax
 18d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 190:	7c b1                	jl     143 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 192:	8b 55 f4             	mov    -0xc(%ebp),%edx
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	01 d0                	add    %edx,%eax
 19a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a0:	c9                   	leave  
 1a1:	c3                   	ret    

000001a2 <stat>:

int
stat(char *n, struct stat *st)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	6a 00                	push   $0x0
 1ad:	ff 75 08             	pushl  0x8(%ebp)
 1b0:	e8 0c 01 00 00       	call   2c1 <open>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bf:	79 07                	jns    1c8 <stat+0x26>
    return -1;
 1c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c6:	eb 25                	jmp    1ed <stat+0x4b>
  r = fstat(fd, st);
 1c8:	83 ec 08             	sub    $0x8,%esp
 1cb:	ff 75 0c             	pushl  0xc(%ebp)
 1ce:	ff 75 f4             	pushl  -0xc(%ebp)
 1d1:	e8 03 01 00 00       	call   2d9 <fstat>
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1dc:	83 ec 0c             	sub    $0xc,%esp
 1df:	ff 75 f4             	pushl  -0xc(%ebp)
 1e2:	e8 c2 00 00 00       	call   2a9 <close>
 1e7:	83 c4 10             	add    $0x10,%esp
  return r;
 1ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <atoi>:

int
atoi(const char *s)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fc:	eb 25                	jmp    223 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 201:	89 d0                	mov    %edx,%eax
 203:	c1 e0 02             	shl    $0x2,%eax
 206:	01 d0                	add    %edx,%eax
 208:	01 c0                	add    %eax,%eax
 20a:	89 c1                	mov    %eax,%ecx
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8d 50 01             	lea    0x1(%eax),%edx
 212:	89 55 08             	mov    %edx,0x8(%ebp)
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	0f be c0             	movsbl %al,%eax
 21b:	01 c8                	add    %ecx,%eax
 21d:	83 e8 30             	sub    $0x30,%eax
 220:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2f                	cmp    $0x2f,%al
 22b:	7e 0a                	jle    237 <atoi+0x48>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 39                	cmp    $0x39,%al
 235:	7e c7                	jle    1fe <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 237:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24e:	eb 17                	jmp    267 <memmove+0x2b>
    *dst++ = *src++;
 250:	8b 45 fc             	mov    -0x4(%ebp),%eax
 253:	8d 50 01             	lea    0x1(%eax),%edx
 256:	89 55 fc             	mov    %edx,-0x4(%ebp)
 259:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25c:	8d 4a 01             	lea    0x1(%edx),%ecx
 25f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 262:	0f b6 12             	movzbl (%edx),%edx
 265:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 267:	8b 45 10             	mov    0x10(%ebp),%eax
 26a:	8d 50 ff             	lea    -0x1(%eax),%edx
 26d:	89 55 10             	mov    %edx,0x10(%ebp)
 270:	85 c0                	test   %eax,%eax
 272:	7f dc                	jg     250 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 279:	b8 01 00 00 00       	mov    $0x1,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <exit>:
SYSCALL(exit)
 281:	b8 02 00 00 00       	mov    $0x2,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <wait>:
SYSCALL(wait)
 289:	b8 03 00 00 00       	mov    $0x3,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <pipe>:
SYSCALL(pipe)
 291:	b8 04 00 00 00       	mov    $0x4,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <read>:
SYSCALL(read)
 299:	b8 05 00 00 00       	mov    $0x5,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <write>:
SYSCALL(write)
 2a1:	b8 10 00 00 00       	mov    $0x10,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <close>:
SYSCALL(close)
 2a9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <kill>:
SYSCALL(kill)
 2b1:	b8 06 00 00 00       	mov    $0x6,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <exec>:
SYSCALL(exec)
 2b9:	b8 07 00 00 00       	mov    $0x7,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <open>:
SYSCALL(open)
 2c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <mknod>:
SYSCALL(mknod)
 2c9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <unlink>:
SYSCALL(unlink)
 2d1:	b8 12 00 00 00       	mov    $0x12,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <fstat>:
SYSCALL(fstat)
 2d9:	b8 08 00 00 00       	mov    $0x8,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <link>:
SYSCALL(link)
 2e1:	b8 13 00 00 00       	mov    $0x13,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <mkdir>:
SYSCALL(mkdir)
 2e9:	b8 14 00 00 00       	mov    $0x14,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <chdir>:
SYSCALL(chdir)
 2f1:	b8 09 00 00 00       	mov    $0x9,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <dup>:
SYSCALL(dup)
 2f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <getpid>:
SYSCALL(getpid)
 301:	b8 0b 00 00 00       	mov    $0xb,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <sbrk>:
SYSCALL(sbrk)
 309:	b8 0c 00 00 00       	mov    $0xc,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <sleep>:
SYSCALL(sleep)
 311:	b8 0d 00 00 00       	mov    $0xd,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <uptime>:
SYSCALL(uptime)
 319:	b8 0e 00 00 00       	mov    $0xe,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <procstat>:
SYSCALL(procstat)
 321:	b8 16 00 00 00       	mov    $0x16,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <set_priority>:
SYSCALL(set_priority)
 329:	b8 17 00 00 00       	mov    $0x17,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <semget>:
SYSCALL(semget)
 331:	b8 18 00 00 00       	mov    $0x18,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <semfree>:
SYSCALL(semfree)
 339:	b8 19 00 00 00       	mov    $0x19,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <semdown>:
SYSCALL(semdown)
 341:	b8 1a 00 00 00       	mov    $0x1a,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <semup>:
 349:	b8 1b 00 00 00       	mov    $0x1b,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 18             	sub    $0x18,%esp
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 35d:	83 ec 04             	sub    $0x4,%esp
 360:	6a 01                	push   $0x1
 362:	8d 45 f4             	lea    -0xc(%ebp),%eax
 365:	50                   	push   %eax
 366:	ff 75 08             	pushl  0x8(%ebp)
 369:	e8 33 ff ff ff       	call   2a1 <write>
 36e:	83 c4 10             	add    $0x10,%esp
}
 371:	c9                   	leave  
 372:	c3                   	ret    

00000373 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	53                   	push   %ebx
 377:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 381:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 385:	74 17                	je     39e <printint+0x2b>
 387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38b:	79 11                	jns    39e <printint+0x2b>
    neg = 1;
 38d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	f7 d8                	neg    %eax
 399:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39c:	eb 06                	jmp    3a4 <printint+0x31>
  } else {
    x = xx;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ae:	8d 41 01             	lea    0x1(%ecx),%eax
 3b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ba:	ba 00 00 00 00       	mov    $0x0,%edx
 3bf:	f7 f3                	div    %ebx
 3c1:	89 d0                	mov    %edx,%eax
 3c3:	0f b6 80 2c 0a 00 00 	movzbl 0xa2c(%eax),%eax
 3ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f3                	div    %ebx
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e2:	75 c7                	jne    3ab <printint+0x38>
  if(neg)
 3e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e8:	74 0e                	je     3f8 <printint+0x85>
    buf[i++] = '-';
 3ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f8:	eb 1d                	jmp    417 <printint+0xa4>
    putc(fd, buf[i]);
 3fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	01 d0                	add    %edx,%eax
 402:	0f b6 00             	movzbl (%eax),%eax
 405:	0f be c0             	movsbl %al,%eax
 408:	83 ec 08             	sub    $0x8,%esp
 40b:	50                   	push   %eax
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 3d ff ff ff       	call   351 <putc>
 414:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 417:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 41b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41f:	79 d9                	jns    3fa <printint+0x87>
    putc(fd, buf[i]);
}
 421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 424:	c9                   	leave  
 425:	c3                   	ret    

00000426 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 426:	55                   	push   %ebp
 427:	89 e5                	mov    %esp,%ebp
 429:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 42c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 433:	8d 45 0c             	lea    0xc(%ebp),%eax
 436:	83 c0 04             	add    $0x4,%eax
 439:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 43c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 443:	e9 59 01 00 00       	jmp    5a1 <printf+0x17b>
    c = fmt[i] & 0xff;
 448:	8b 55 0c             	mov    0xc(%ebp),%edx
 44b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	0f be c0             	movsbl %al,%eax
 456:	25 ff 00 00 00       	and    $0xff,%eax
 45b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 45e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 462:	75 2c                	jne    490 <printf+0x6a>
      if(c == '%'){
 464:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 468:	75 0c                	jne    476 <printf+0x50>
        state = '%';
 46a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 471:	e9 27 01 00 00       	jmp    59d <printf+0x177>
      } else {
        putc(fd, c);
 476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 479:	0f be c0             	movsbl %al,%eax
 47c:	83 ec 08             	sub    $0x8,%esp
 47f:	50                   	push   %eax
 480:	ff 75 08             	pushl  0x8(%ebp)
 483:	e8 c9 fe ff ff       	call   351 <putc>
 488:	83 c4 10             	add    $0x10,%esp
 48b:	e9 0d 01 00 00       	jmp    59d <printf+0x177>
      }
    } else if(state == '%'){
 490:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 494:	0f 85 03 01 00 00    	jne    59d <printf+0x177>
      if(c == 'd'){
 49a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 49e:	75 1e                	jne    4be <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a3:	8b 00                	mov    (%eax),%eax
 4a5:	6a 01                	push   $0x1
 4a7:	6a 0a                	push   $0xa
 4a9:	50                   	push   %eax
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 c1 fe ff ff       	call   373 <printint>
 4b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b9:	e9 d8 00 00 00       	jmp    596 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4be:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c2:	74 06                	je     4ca <printf+0xa4>
 4c4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c8:	75 1e                	jne    4e8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cd:	8b 00                	mov    (%eax),%eax
 4cf:	6a 00                	push   $0x0
 4d1:	6a 10                	push   $0x10
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 97 fe ff ff       	call   373 <printint>
 4dc:	83 c4 10             	add    $0x10,%esp
        ap++;
 4df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e3:	e9 ae 00 00 00       	jmp    596 <printf+0x170>
      } else if(c == 's'){
 4e8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ec:	75 43                	jne    531 <printf+0x10b>
        s = (char*)*ap;
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fe:	75 07                	jne    507 <printf+0xe1>
          s = "(null)";
 500:	c7 45 f4 da 07 00 00 	movl   $0x7da,-0xc(%ebp)
        while(*s != 0){
 507:	eb 1c                	jmp    525 <printf+0xff>
          putc(fd, *s);
 509:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	83 ec 08             	sub    $0x8,%esp
 515:	50                   	push   %eax
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 33 fe ff ff       	call   351 <putc>
 51e:	83 c4 10             	add    $0x10,%esp
          s++;
 521:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 525:	8b 45 f4             	mov    -0xc(%ebp),%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	84 c0                	test   %al,%al
 52d:	75 da                	jne    509 <printf+0xe3>
 52f:	eb 65                	jmp    596 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 531:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 535:	75 1d                	jne    554 <printf+0x12e>
        putc(fd, *ap);
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	83 ec 08             	sub    $0x8,%esp
 542:	50                   	push   %eax
 543:	ff 75 08             	pushl  0x8(%ebp)
 546:	e8 06 fe ff ff       	call   351 <putc>
 54b:	83 c4 10             	add    $0x10,%esp
        ap++;
 54e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 552:	eb 42                	jmp    596 <printf+0x170>
      } else if(c == '%'){
 554:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 558:	75 17                	jne    571 <printf+0x14b>
        putc(fd, c);
 55a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	83 ec 08             	sub    $0x8,%esp
 563:	50                   	push   %eax
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 e5 fd ff ff       	call   351 <putc>
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	eb 25                	jmp    596 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 571:	83 ec 08             	sub    $0x8,%esp
 574:	6a 25                	push   $0x25
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 d3 fd ff ff       	call   351 <putc>
 57e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	50                   	push   %eax
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 be fd ff ff       	call   351 <putc>
 593:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 596:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a7:	01 d0                	add    %edx,%eax
 5a9:	0f b6 00             	movzbl (%eax),%eax
 5ac:	84 c0                	test   %al,%al
 5ae:	0f 85 94 fe ff ff    	jne    448 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    

000005b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	83 e8 08             	sub    $0x8,%eax
 5c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c5:	a1 48 0a 00 00       	mov    0xa48,%eax
 5ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5cd:	eb 24                	jmp    5f3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d7:	77 12                	ja     5eb <free+0x35>
 5d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5df:	77 24                	ja     605 <free+0x4f>
 5e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e9:	77 1a                	ja     605 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f9:	76 d4                	jbe    5cf <free+0x19>
 5fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 603:	76 ca                	jbe    5cf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 605:	8b 45 f8             	mov    -0x8(%ebp),%eax
 608:	8b 40 04             	mov    0x4(%eax),%eax
 60b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	01 c2                	add    %eax,%edx
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	39 c2                	cmp    %eax,%edx
 61e:	75 24                	jne    644 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 620:	8b 45 f8             	mov    -0x8(%ebp),%eax
 623:	8b 50 04             	mov    0x4(%eax),%edx
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	8b 40 04             	mov    0x4(%eax),%eax
 62e:	01 c2                	add    %eax,%edx
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	8b 10                	mov    (%eax),%edx
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	89 10                	mov    %edx,(%eax)
 642:	eb 0a                	jmp    64e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 10                	mov    (%eax),%edx
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 40 04             	mov    0x4(%eax),%eax
 654:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	01 d0                	add    %edx,%eax
 660:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 663:	75 20                	jne    685 <free+0xcf>
    p->s.size += bp->s.size;
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 50 04             	mov    0x4(%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	01 c2                	add    %eax,%edx
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	89 10                	mov    %edx,(%eax)
 683:	eb 08                	jmp    68d <free+0xd7>
  } else
    p->s.ptr = bp;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 55 f8             	mov    -0x8(%ebp),%edx
 68b:	89 10                	mov    %edx,(%eax)
  freep = p;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <morecore>:

static Header*
morecore(uint nu)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 69d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a4:	77 07                	ja     6ad <morecore+0x16>
    nu = 4096;
 6a6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	c1 e0 03             	shl    $0x3,%eax
 6b3:	83 ec 0c             	sub    $0xc,%esp
 6b6:	50                   	push   %eax
 6b7:	e8 4d fc ff ff       	call   309 <sbrk>
 6bc:	83 c4 10             	add    $0x10,%esp
 6bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6c6:	75 07                	jne    6cf <morecore+0x38>
    return 0;
 6c8:	b8 00 00 00 00       	mov    $0x0,%eax
 6cd:	eb 26                	jmp    6f5 <morecore+0x5e>
  hp = (Header*)p;
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	8b 55 08             	mov    0x8(%ebp),%edx
 6db:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	83 c0 08             	add    $0x8,%eax
 6e4:	83 ec 0c             	sub    $0xc,%esp
 6e7:	50                   	push   %eax
 6e8:	e8 c9 fe ff ff       	call   5b6 <free>
 6ed:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f0:	a1 48 0a 00 00       	mov    0xa48,%eax
}
 6f5:	c9                   	leave  
 6f6:	c3                   	ret    

000006f7 <malloc>:

void*
malloc(uint nbytes)
{
 6f7:	55                   	push   %ebp
 6f8:	89 e5                	mov    %esp,%ebp
 6fa:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	83 c0 07             	add    $0x7,%eax
 703:	c1 e8 03             	shr    $0x3,%eax
 706:	83 c0 01             	add    $0x1,%eax
 709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 70c:	a1 48 0a 00 00       	mov    0xa48,%eax
 711:	89 45 f0             	mov    %eax,-0x10(%ebp)
 714:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 718:	75 23                	jne    73d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 71a:	c7 45 f0 40 0a 00 00 	movl   $0xa40,-0x10(%ebp)
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	a3 48 0a 00 00       	mov    %eax,0xa48
 729:	a1 48 0a 00 00       	mov    0xa48,%eax
 72e:	a3 40 0a 00 00       	mov    %eax,0xa40
    base.s.size = 0;
 733:	c7 05 44 0a 00 00 00 	movl   $0x0,0xa44
 73a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 745:	8b 45 f4             	mov    -0xc(%ebp),%eax
 748:	8b 40 04             	mov    0x4(%eax),%eax
 74b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74e:	72 4d                	jb     79d <malloc+0xa6>
      if(p->s.size == nunits)
 750:	8b 45 f4             	mov    -0xc(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 759:	75 0c                	jne    767 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	8b 10                	mov    (%eax),%edx
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	89 10                	mov    %edx,(%eax)
 765:	eb 26                	jmp    78d <malloc+0x96>
      else {
        p->s.size -= nunits;
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 770:	89 c2                	mov    %eax,%edx
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	c1 e0 03             	shl    $0x3,%eax
 781:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	a3 48 0a 00 00       	mov    %eax,0xa48
      return (void*)(p + 1);
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	83 c0 08             	add    $0x8,%eax
 79b:	eb 3b                	jmp    7d8 <malloc+0xe1>
    }
    if(p == freep)
 79d:	a1 48 0a 00 00       	mov    0xa48,%eax
 7a2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7a5:	75 1e                	jne    7c5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7a7:	83 ec 0c             	sub    $0xc,%esp
 7aa:	ff 75 ec             	pushl  -0x14(%ebp)
 7ad:	e8 e5 fe ff ff       	call   697 <morecore>
 7b2:	83 c4 10             	add    $0x10,%esp
 7b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7bc:	75 07                	jne    7c5 <malloc+0xce>
        return 0;
 7be:	b8 00 00 00 00       	mov    $0x0,%eax
 7c3:	eb 13                	jmp    7d8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d3:	e9 6d ff ff ff       	jmp    745 <malloc+0x4e>
}
 7d8:	c9                   	leave  
 7d9:	c3                   	ret    
