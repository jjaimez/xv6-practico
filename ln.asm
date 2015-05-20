
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 22 08 00 00       	push   $0x822
  1e:	6a 02                	push   $0x2
  20:	e8 49 04 00 00       	call   46e <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9c 02 00 00       	call   2c9 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e2 02 00 00       	call   329 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 35 08 00 00       	push   $0x835
  65:	6a 02                	push   $0x2
  67:	e8 02 04 00 00       	call   46e <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 55 02 00 00       	call   2c9 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	5b                   	pop    %ebx
  96:	5f                   	pop    %edi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a5:	90                   	nop
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	8d 50 01             	lea    0x1(%eax),%edx
  ac:	89 55 08             	mov    %edx,0x8(%ebp)
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b8:	0f b6 12             	movzbl (%edx),%edx
  bb:	88 10                	mov    %dl,(%eax)
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	84 c0                	test   %al,%al
  c2:	75 e2                	jne    a6 <strcpy+0xd>
    ;
  return os;
  c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c7:	c9                   	leave  
  c8:	c3                   	ret    

000000c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cc:	eb 08                	jmp    d6 <strcmp+0xd>
    p++, q++;
  ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	74 10                	je     f0 <strcmp+0x27>
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 10             	movzbl (%eax),%edx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	38 c2                	cmp    %al,%dl
  ee:	74 de                	je     ce <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 d0             	movzbl %al,%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	0f b6 c0             	movzbl %al,%eax
 102:	29 c2                	sub    %eax,%edx
 104:	89 d0                	mov    %edx,%eax
}
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    

00000108 <strlen>:

uint
strlen(char *s)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 115:	eb 04                	jmp    11b <strlen+0x13>
 117:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	01 d0                	add    %edx,%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 ed                	jne    117 <strlen+0xf>
    ;
  return n;
 12a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <memset>:

void*
memset(void *dst, int c, uint n)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 132:	8b 45 10             	mov    0x10(%ebp),%eax
 135:	50                   	push   %eax
 136:	ff 75 0c             	pushl  0xc(%ebp)
 139:	ff 75 08             	pushl  0x8(%ebp)
 13c:	e8 33 ff ff ff       	call   74 <stosb>
 141:	83 c4 0c             	add    $0xc,%esp
  return dst;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
}
 147:	c9                   	leave  
 148:	c3                   	ret    

00000149 <strchr>:

char*
strchr(const char *s, char c)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 155:	eb 14                	jmp    16b <strchr+0x22>
    if(*s == c)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 160:	75 05                	jne    167 <strchr+0x1e>
      return (char*)s;
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	eb 13                	jmp    17a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 167:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	84 c0                	test   %al,%al
 173:	75 e2                	jne    157 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 175:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 189:	eb 44                	jmp    1cf <gets+0x53>
    cc = read(0, &c, 1);
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	50                   	push   %eax
 194:	6a 00                	push   $0x0
 196:	e8 46 01 00 00       	call   2e1 <read>
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a5:	7f 02                	jg     1a9 <gets+0x2d>
      break;
 1a7:	eb 31                	jmp    1da <gets+0x5e>
    buf[i++] = c;
 1a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ac:	8d 50 01             	lea    0x1(%eax),%edx
 1af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b2:	89 c2                	mov    %eax,%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 c2                	add    %eax,%edx
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0a                	cmp    $0xa,%al
 1c5:	74 13                	je     1da <gets+0x5e>
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	3c 0d                	cmp    $0xd,%al
 1cd:	74 0b                	je     1da <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	83 c0 01             	add    $0x1,%eax
 1d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d8:	7c b1                	jl     18b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <procstat>:
SYSCALL(procstat)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <set_priority>:
SYSCALL(set_priority)
 371:	b8 17 00 00 00       	mov    $0x17,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <semget>:
SYSCALL(semget)
 379:	b8 18 00 00 00       	mov    $0x18,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <semfree>:
SYSCALL(semfree)
 381:	b8 19 00 00 00       	mov    $0x19,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <semdown>:
SYSCALL(semdown)
 389:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <semup>:
 391:	b8 1b 00 00 00       	mov    $0x1b,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	83 ec 18             	sub    $0x18,%esp
 39f:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a5:	83 ec 04             	sub    $0x4,%esp
 3a8:	6a 01                	push   $0x1
 3aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ad:	50                   	push   %eax
 3ae:	ff 75 08             	pushl  0x8(%ebp)
 3b1:	e8 33 ff ff ff       	call   2e9 <write>
 3b6:	83 c4 10             	add    $0x10,%esp
}
 3b9:	c9                   	leave  
 3ba:	c3                   	ret    

000003bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	53                   	push   %ebx
 3bf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cd:	74 17                	je     3e6 <printint+0x2b>
 3cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d3:	79 11                	jns    3e6 <printint+0x2b>
    neg = 1;
 3d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	f7 d8                	neg    %eax
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e4:	eb 06                	jmp    3ec <printint+0x31>
  } else {
    x = xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f6:	8d 41 01             	lea    0x1(%ecx),%eax
 3f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 f3                	div    %ebx
 409:	89 d0                	mov    %edx,%eax
 40b:	0f b6 80 9c 0a 00 00 	movzbl 0xa9c(%eax),%eax
 412:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 416:	8b 5d 10             	mov    0x10(%ebp),%ebx
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f3                	div    %ebx
 423:	89 45 ec             	mov    %eax,-0x14(%ebp)
 426:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42a:	75 c7                	jne    3f3 <printint+0x38>
  if(neg)
 42c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 430:	74 0e                	je     440 <printint+0x85>
    buf[i++] = '-';
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	8d 50 01             	lea    0x1(%eax),%edx
 438:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 440:	eb 1d                	jmp    45f <printint+0xa4>
    putc(fd, buf[i]);
 442:	8d 55 dc             	lea    -0x24(%ebp),%edx
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	01 d0                	add    %edx,%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	0f be c0             	movsbl %al,%eax
 450:	83 ec 08             	sub    $0x8,%esp
 453:	50                   	push   %eax
 454:	ff 75 08             	pushl  0x8(%ebp)
 457:	e8 3d ff ff ff       	call   399 <putc>
 45c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 467:	79 d9                	jns    442 <printint+0x87>
    putc(fd, buf[i]);
}
 469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 46c:	c9                   	leave  
 46d:	c3                   	ret    

0000046e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47b:	8d 45 0c             	lea    0xc(%ebp),%eax
 47e:	83 c0 04             	add    $0x4,%eax
 481:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48b:	e9 59 01 00 00       	jmp    5e9 <printf+0x17b>
    c = fmt[i] & 0xff;
 490:	8b 55 0c             	mov    0xc(%ebp),%edx
 493:	8b 45 f0             	mov    -0x10(%ebp),%eax
 496:	01 d0                	add    %edx,%eax
 498:	0f b6 00             	movzbl (%eax),%eax
 49b:	0f be c0             	movsbl %al,%eax
 49e:	25 ff 00 00 00       	and    $0xff,%eax
 4a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4aa:	75 2c                	jne    4d8 <printf+0x6a>
      if(c == '%'){
 4ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b0:	75 0c                	jne    4be <printf+0x50>
        state = '%';
 4b2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b9:	e9 27 01 00 00       	jmp    5e5 <printf+0x177>
      } else {
        putc(fd, c);
 4be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c1:	0f be c0             	movsbl %al,%eax
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 c9 fe ff ff       	call   399 <putc>
 4d0:	83 c4 10             	add    $0x10,%esp
 4d3:	e9 0d 01 00 00       	jmp    5e5 <printf+0x177>
      }
    } else if(state == '%'){
 4d8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4dc:	0f 85 03 01 00 00    	jne    5e5 <printf+0x177>
      if(c == 'd'){
 4e2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e6:	75 1e                	jne    506 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	6a 01                	push   $0x1
 4ef:	6a 0a                	push   $0xa
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	e8 c1 fe ff ff       	call   3bb <printint>
 4fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 501:	e9 d8 00 00 00       	jmp    5de <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 506:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50a:	74 06                	je     512 <printf+0xa4>
 50c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 510:	75 1e                	jne    530 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 512:	8b 45 e8             	mov    -0x18(%ebp),%eax
 515:	8b 00                	mov    (%eax),%eax
 517:	6a 00                	push   $0x0
 519:	6a 10                	push   $0x10
 51b:	50                   	push   %eax
 51c:	ff 75 08             	pushl  0x8(%ebp)
 51f:	e8 97 fe ff ff       	call   3bb <printint>
 524:	83 c4 10             	add    $0x10,%esp
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52b:	e9 ae 00 00 00       	jmp    5de <printf+0x170>
      } else if(c == 's'){
 530:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 534:	75 43                	jne    579 <printf+0x10b>
        s = (char*)*ap;
 536:	8b 45 e8             	mov    -0x18(%ebp),%eax
 539:	8b 00                	mov    (%eax),%eax
 53b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 546:	75 07                	jne    54f <printf+0xe1>
          s = "(null)";
 548:	c7 45 f4 49 08 00 00 	movl   $0x849,-0xc(%ebp)
        while(*s != 0){
 54f:	eb 1c                	jmp    56d <printf+0xff>
          putc(fd, *s);
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	83 ec 08             	sub    $0x8,%esp
 55d:	50                   	push   %eax
 55e:	ff 75 08             	pushl  0x8(%ebp)
 561:	e8 33 fe ff ff       	call   399 <putc>
 566:	83 c4 10             	add    $0x10,%esp
          s++;
 569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	84 c0                	test   %al,%al
 575:	75 da                	jne    551 <printf+0xe3>
 577:	eb 65                	jmp    5de <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 579:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57d:	75 1d                	jne    59c <printf+0x12e>
        putc(fd, *ap);
 57f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	50                   	push   %eax
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 06 fe ff ff       	call   399 <putc>
 593:	83 c4 10             	add    $0x10,%esp
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59a:	eb 42                	jmp    5de <printf+0x170>
      } else if(c == '%'){
 59c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a0:	75 17                	jne    5b9 <printf+0x14b>
        putc(fd, c);
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	83 ec 08             	sub    $0x8,%esp
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 e5 fd ff ff       	call   399 <putc>
 5b4:	83 c4 10             	add    $0x10,%esp
 5b7:	eb 25                	jmp    5de <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	6a 25                	push   $0x25
 5be:	ff 75 08             	pushl  0x8(%ebp)
 5c1:	e8 d3 fd ff ff       	call   399 <putc>
 5c6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cc:	0f be c0             	movsbl %al,%eax
 5cf:	83 ec 08             	sub    $0x8,%esp
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 be fd ff ff       	call   399 <putc>
 5db:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ef:	01 d0                	add    %edx,%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	84 c0                	test   %al,%al
 5f6:	0f 85 94 fe ff ff    	jne    490 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5fc:	c9                   	leave  
 5fd:	c3                   	ret    

000005fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fe:	55                   	push   %ebp
 5ff:	89 e5                	mov    %esp,%ebp
 601:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	83 e8 08             	sub    $0x8,%eax
 60a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60d:	a1 b8 0a 00 00       	mov    0xab8,%eax
 612:	89 45 fc             	mov    %eax,-0x4(%ebp)
 615:	eb 24                	jmp    63b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61f:	77 12                	ja     633 <free+0x35>
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 627:	77 24                	ja     64d <free+0x4f>
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 631:	77 1a                	ja     64d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	76 d4                	jbe    617 <free+0x19>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	76 ca                	jbe    617 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	8b 40 04             	mov    0x4(%eax),%eax
 653:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	01 c2                	add    %eax,%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	39 c2                	cmp    %eax,%edx
 666:	75 24                	jne    68c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	8b 50 04             	mov    0x4(%eax),%edx
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	01 c2                	add    %eax,%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	8b 10                	mov    (%eax),%edx
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	89 10                	mov    %edx,(%eax)
 68a:	eb 0a                	jmp    696 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 10                	mov    (%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 40 04             	mov    0x4(%eax),%eax
 69c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	01 d0                	add    %edx,%eax
 6a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ab:	75 20                	jne    6cd <free+0xcf>
    p->s.size += bp->s.size;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 50 04             	mov    0x4(%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	01 c2                	add    %eax,%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 10                	mov    (%eax),%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	89 10                	mov    %edx,(%eax)
 6cb:	eb 08                	jmp    6d5 <free+0xd7>
  } else
    p->s.ptr = bp;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 6dd:	c9                   	leave  
 6de:	c3                   	ret    

000006df <morecore>:

static Header*
morecore(uint nu)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ec:	77 07                	ja     6f5 <morecore+0x16>
    nu = 4096;
 6ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	c1 e0 03             	shl    $0x3,%eax
 6fb:	83 ec 0c             	sub    $0xc,%esp
 6fe:	50                   	push   %eax
 6ff:	e8 4d fc ff ff       	call   351 <sbrk>
 704:	83 c4 10             	add    $0x10,%esp
 707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 70e:	75 07                	jne    717 <morecore+0x38>
    return 0;
 710:	b8 00 00 00 00       	mov    $0x0,%eax
 715:	eb 26                	jmp    73d <morecore+0x5e>
  hp = (Header*)p;
 717:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	8b 55 08             	mov    0x8(%ebp),%edx
 723:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	83 c0 08             	add    $0x8,%eax
 72c:	83 ec 0c             	sub    $0xc,%esp
 72f:	50                   	push   %eax
 730:	e8 c9 fe ff ff       	call   5fe <free>
 735:	83 c4 10             	add    $0x10,%esp
  return freep;
 738:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <malloc>:

void*
malloc(uint nbytes)
{
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	83 c0 07             	add    $0x7,%eax
 74b:	c1 e8 03             	shr    $0x3,%eax
 74e:	83 c0 01             	add    $0x1,%eax
 751:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 754:	a1 b8 0a 00 00       	mov    0xab8,%eax
 759:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 760:	75 23                	jne    785 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 762:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	a3 b8 0a 00 00       	mov    %eax,0xab8
 771:	a1 b8 0a 00 00       	mov    0xab8,%eax
 776:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 77b:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 782:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 796:	72 4d                	jb     7e5 <malloc+0xa6>
      if(p->s.size == nunits)
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a1:	75 0c                	jne    7af <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	89 10                	mov    %edx,(%eax)
 7ad:	eb 26                	jmp    7d5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b8:	89 c2                	mov    %eax,%edx
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	83 c0 08             	add    $0x8,%eax
 7e3:	eb 3b                	jmp    820 <malloc+0xe1>
    }
    if(p == freep)
 7e5:	a1 b8 0a 00 00       	mov    0xab8,%eax
 7ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ed:	75 1e                	jne    80d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ef:	83 ec 0c             	sub    $0xc,%esp
 7f2:	ff 75 ec             	pushl  -0x14(%ebp)
 7f5:	e8 e5 fe ff ff       	call   6df <morecore>
 7fa:	83 c4 10             	add    $0x10,%esp
 7fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 804:	75 07                	jne    80d <malloc+0xce>
        return 0;
 806:	b8 00 00 00 00       	mov    $0x0,%eax
 80b:	eb 13                	jmp    820 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	89 45 f0             	mov    %eax,-0x10(%ebp)
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 81b:	e9 6d ff ff ff       	jmp    78d <malloc+0x4e>
}
 820:	c9                   	leave  
 821:	c3                   	ret    
