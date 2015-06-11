
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 13 08 00 00       	mov    $0x813,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 15 08 00 00       	mov    $0x815,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 17 08 00 00       	push   $0x817
  4b:	6a 01                	push   $0x1
  4d:	e8 0d 04 00 00       	call   45f <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 55 02 00 00       	call   2ba <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	5b                   	pop    %ebx
  87:	5f                   	pop    %edi
  88:	5d                   	pop    %ebp
  89:	c3                   	ret    

0000008a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  90:	8b 45 08             	mov    0x8(%ebp),%eax
  93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  96:	90                   	nop
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	8d 50 01             	lea    0x1(%eax),%edx
  9d:	89 55 08             	mov    %edx,0x8(%ebp)
  a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  a9:	0f b6 12             	movzbl (%edx),%edx
  ac:	88 10                	mov    %dl,(%eax)
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	84 c0                	test   %al,%al
  b3:	75 e2                	jne    97 <strcpy+0xd>
    ;
  return os;
  b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b8:	c9                   	leave  
  b9:	c3                   	ret    

000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bd:	eb 08                	jmp    c7 <strcmp+0xd>
    p++, q++;
  bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	84 c0                	test   %al,%al
  cf:	74 10                	je     e1 <strcmp+0x27>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	38 c2                	cmp    %al,%dl
  df:	74 de                	je     bf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	0f b6 d0             	movzbl %al,%edx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	29 c2                	sub    %eax,%edx
  f5:	89 d0                	mov    %edx,%eax
}
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    

000000f9 <strlen>:

uint
strlen(char *s)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 106:	eb 04                	jmp    10c <strlen+0x13>
 108:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	01 d0                	add    %edx,%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	75 ed                	jne    108 <strlen+0xf>
    ;
  return n;
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 123:	8b 45 10             	mov    0x10(%ebp),%eax
 126:	50                   	push   %eax
 127:	ff 75 0c             	pushl  0xc(%ebp)
 12a:	ff 75 08             	pushl  0x8(%ebp)
 12d:	e8 33 ff ff ff       	call   65 <stosb>
 132:	83 c4 0c             	add    $0xc,%esp
  return dst;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 04             	sub    $0x4,%esp
 140:	8b 45 0c             	mov    0xc(%ebp),%eax
 143:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 146:	eb 14                	jmp    15c <strchr+0x22>
    if(*s == c)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 151:	75 05                	jne    158 <strchr+0x1e>
      return (char*)s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	eb 13                	jmp    16b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	75 e2                	jne    148 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 166:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <gets>:

char*
gets(char *buf, int max)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
 170:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17a:	eb 44                	jmp    1c0 <gets+0x53>
    cc = read(0, &c, 1);
 17c:	83 ec 04             	sub    $0x4,%esp
 17f:	6a 01                	push   $0x1
 181:	8d 45 ef             	lea    -0x11(%ebp),%eax
 184:	50                   	push   %eax
 185:	6a 00                	push   $0x0
 187:	e8 46 01 00 00       	call   2d2 <read>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 192:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 196:	7f 02                	jg     19a <gets+0x2d>
      break;
 198:	eb 31                	jmp    1cb <gets+0x5e>
    buf[i++] = c;
 19a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19d:	8d 50 01             	lea    0x1(%eax),%edx
 1a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a3:	89 c2                	mov    %eax,%edx
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	01 c2                	add    %eax,%edx
 1aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b4:	3c 0a                	cmp    $0xa,%al
 1b6:	74 13                	je     1cb <gets+0x5e>
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	3c 0d                	cmp    $0xd,%al
 1be:	74 0b                	je     1cb <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	83 c0 01             	add    $0x1,%eax
 1c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c9:	7c b1                	jl     17c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <stat>:

int
stat(char *n, struct stat *st)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	6a 00                	push   $0x0
 1e6:	ff 75 08             	pushl  0x8(%ebp)
 1e9:	e8 0c 01 00 00       	call   2fa <open>
 1ee:	83 c4 10             	add    $0x10,%esp
 1f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f8:	79 07                	jns    201 <stat+0x26>
    return -1;
 1fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ff:	eb 25                	jmp    226 <stat+0x4b>
  r = fstat(fd, st);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 f4             	pushl  -0xc(%ebp)
 20a:	e8 03 01 00 00       	call   312 <fstat>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 215:	83 ec 0c             	sub    $0xc,%esp
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 c2 00 00 00       	call   2e2 <close>
 220:	83 c4 10             	add    $0x10,%esp
  return r;
 223:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <atoi>:

int
atoi(const char *s)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 22e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 235:	eb 25                	jmp    25c <atoi+0x34>
    n = n*10 + *s++ - '0';
 237:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23a:	89 d0                	mov    %edx,%eax
 23c:	c1 e0 02             	shl    $0x2,%eax
 23f:	01 d0                	add    %edx,%eax
 241:	01 c0                	add    %eax,%eax
 243:	89 c1                	mov    %eax,%ecx
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 08             	mov    %edx,0x8(%ebp)
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	0f be c0             	movsbl %al,%eax
 254:	01 c8                	add    %ecx,%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	3c 2f                	cmp    $0x2f,%al
 264:	7e 0a                	jle    270 <atoi+0x48>
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 39                	cmp    $0x39,%al
 26e:	7e c7                	jle    237 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 287:	eb 17                	jmp    2a0 <memmove+0x2b>
    *dst++ = *src++;
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28c:	8d 50 01             	lea    0x1(%eax),%edx
 28f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 292:	8b 55 f8             	mov    -0x8(%ebp),%edx
 295:	8d 4a 01             	lea    0x1(%edx),%ecx
 298:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29b:	0f b6 12             	movzbl (%edx),%edx
 29e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a0:	8b 45 10             	mov    0x10(%ebp),%eax
 2a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a6:	89 55 10             	mov    %edx,0x10(%ebp)
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7f dc                	jg     289 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b2:	b8 01 00 00 00       	mov    $0x1,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <exit>:
SYSCALL(exit)
 2ba:	b8 02 00 00 00       	mov    $0x2,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <wait>:
SYSCALL(wait)
 2c2:	b8 03 00 00 00       	mov    $0x3,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <pipe>:
SYSCALL(pipe)
 2ca:	b8 04 00 00 00       	mov    $0x4,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <read>:
SYSCALL(read)
 2d2:	b8 05 00 00 00       	mov    $0x5,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <write>:
SYSCALL(write)
 2da:	b8 10 00 00 00       	mov    $0x10,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <close>:
SYSCALL(close)
 2e2:	b8 15 00 00 00       	mov    $0x15,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <kill>:
SYSCALL(kill)
 2ea:	b8 06 00 00 00       	mov    $0x6,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exec>:
SYSCALL(exec)
 2f2:	b8 07 00 00 00       	mov    $0x7,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <open>:
SYSCALL(open)
 2fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mknod>:
SYSCALL(mknod)
 302:	b8 11 00 00 00       	mov    $0x11,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <unlink>:
SYSCALL(unlink)
 30a:	b8 12 00 00 00       	mov    $0x12,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <fstat>:
SYSCALL(fstat)
 312:	b8 08 00 00 00       	mov    $0x8,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <link>:
SYSCALL(link)
 31a:	b8 13 00 00 00       	mov    $0x13,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <mkdir>:
SYSCALL(mkdir)
 322:	b8 14 00 00 00       	mov    $0x14,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <chdir>:
SYSCALL(chdir)
 32a:	b8 09 00 00 00       	mov    $0x9,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <dup>:
SYSCALL(dup)
 332:	b8 0a 00 00 00       	mov    $0xa,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getpid>:
SYSCALL(getpid)
 33a:	b8 0b 00 00 00       	mov    $0xb,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sbrk>:
SYSCALL(sbrk)
 342:	b8 0c 00 00 00       	mov    $0xc,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sleep>:
SYSCALL(sleep)
 34a:	b8 0d 00 00 00       	mov    $0xd,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <uptime>:
SYSCALL(uptime)
 352:	b8 0e 00 00 00       	mov    $0xe,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <procstat>:
SYSCALL(procstat)
 35a:	b8 16 00 00 00       	mov    $0x16,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <set_priority>:
SYSCALL(set_priority)
 362:	b8 17 00 00 00       	mov    $0x17,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <semget>:
SYSCALL(semget)
 36a:	b8 18 00 00 00       	mov    $0x18,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <semfree>:
SYSCALL(semfree)
 372:	b8 19 00 00 00       	mov    $0x19,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <semdown>:
SYSCALL(semdown)
 37a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <semup>:
 382:	b8 1b 00 00 00       	mov    $0x1b,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 18             	sub    $0x18,%esp
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 396:	83 ec 04             	sub    $0x4,%esp
 399:	6a 01                	push   $0x1
 39b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39e:	50                   	push   %eax
 39f:	ff 75 08             	pushl  0x8(%ebp)
 3a2:	e8 33 ff ff ff       	call   2da <write>
 3a7:	83 c4 10             	add    $0x10,%esp
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	53                   	push   %ebx
 3b0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ba:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3be:	74 17                	je     3d7 <printint+0x2b>
 3c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c4:	79 11                	jns    3d7 <printint+0x2b>
    neg = 1;
 3c6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	f7 d8                	neg    %eax
 3d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d5:	eb 06                	jmp    3dd <printint+0x31>
  } else {
    x = xx;
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e7:	8d 41 01             	lea    0x1(%ecx),%eax
 3ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f3:	ba 00 00 00 00       	mov    $0x0,%edx
 3f8:	f7 f3                	div    %ebx
 3fa:	89 d0                	mov    %edx,%eax
 3fc:	0f b6 80 70 0a 00 00 	movzbl 0xa70(%eax),%eax
 403:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 407:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40d:	ba 00 00 00 00       	mov    $0x0,%edx
 412:	f7 f3                	div    %ebx
 414:	89 45 ec             	mov    %eax,-0x14(%ebp)
 417:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41b:	75 c7                	jne    3e4 <printint+0x38>
  if(neg)
 41d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 421:	74 0e                	je     431 <printint+0x85>
    buf[i++] = '-';
 423:	8b 45 f4             	mov    -0xc(%ebp),%eax
 426:	8d 50 01             	lea    0x1(%eax),%edx
 429:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 431:	eb 1d                	jmp    450 <printint+0xa4>
    putc(fd, buf[i]);
 433:	8d 55 dc             	lea    -0x24(%ebp),%edx
 436:	8b 45 f4             	mov    -0xc(%ebp),%eax
 439:	01 d0                	add    %edx,%eax
 43b:	0f b6 00             	movzbl (%eax),%eax
 43e:	0f be c0             	movsbl %al,%eax
 441:	83 ec 08             	sub    $0x8,%esp
 444:	50                   	push   %eax
 445:	ff 75 08             	pushl  0x8(%ebp)
 448:	e8 3d ff ff ff       	call   38a <putc>
 44d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 450:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 458:	79 d9                	jns    433 <printint+0x87>
    putc(fd, buf[i]);
}
 45a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 465:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46c:	8d 45 0c             	lea    0xc(%ebp),%eax
 46f:	83 c0 04             	add    $0x4,%eax
 472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47c:	e9 59 01 00 00       	jmp    5da <printf+0x17b>
    c = fmt[i] & 0xff;
 481:	8b 55 0c             	mov    0xc(%ebp),%edx
 484:	8b 45 f0             	mov    -0x10(%ebp),%eax
 487:	01 d0                	add    %edx,%eax
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	25 ff 00 00 00       	and    $0xff,%eax
 494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49b:	75 2c                	jne    4c9 <printf+0x6a>
      if(c == '%'){
 49d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a1:	75 0c                	jne    4af <printf+0x50>
        state = '%';
 4a3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4aa:	e9 27 01 00 00       	jmp    5d6 <printf+0x177>
      } else {
        putc(fd, c);
 4af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 c9 fe ff ff       	call   38a <putc>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	e9 0d 01 00 00       	jmp    5d6 <printf+0x177>
      }
    } else if(state == '%'){
 4c9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cd:	0f 85 03 01 00 00    	jne    5d6 <printf+0x177>
      if(c == 'd'){
 4d3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d7:	75 1e                	jne    4f7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dc:	8b 00                	mov    (%eax),%eax
 4de:	6a 01                	push   $0x1
 4e0:	6a 0a                	push   $0xa
 4e2:	50                   	push   %eax
 4e3:	ff 75 08             	pushl  0x8(%ebp)
 4e6:	e8 c1 fe ff ff       	call   3ac <printint>
 4eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f2:	e9 d8 00 00 00       	jmp    5cf <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fb:	74 06                	je     503 <printf+0xa4>
 4fd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 501:	75 1e                	jne    521 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 503:	8b 45 e8             	mov    -0x18(%ebp),%eax
 506:	8b 00                	mov    (%eax),%eax
 508:	6a 00                	push   $0x0
 50a:	6a 10                	push   $0x10
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 97 fe ff ff       	call   3ac <printint>
 515:	83 c4 10             	add    $0x10,%esp
        ap++;
 518:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51c:	e9 ae 00 00 00       	jmp    5cf <printf+0x170>
      } else if(c == 's'){
 521:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 525:	75 43                	jne    56a <printf+0x10b>
        s = (char*)*ap;
 527:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	75 07                	jne    540 <printf+0xe1>
          s = "(null)";
 539:	c7 45 f4 1c 08 00 00 	movl   $0x81c,-0xc(%ebp)
        while(*s != 0){
 540:	eb 1c                	jmp    55e <printf+0xff>
          putc(fd, *s);
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	83 ec 08             	sub    $0x8,%esp
 54e:	50                   	push   %eax
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 33 fe ff ff       	call   38a <putc>
 557:	83 c4 10             	add    $0x10,%esp
          s++;
 55a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	0f b6 00             	movzbl (%eax),%eax
 564:	84 c0                	test   %al,%al
 566:	75 da                	jne    542 <printf+0xe3>
 568:	eb 65                	jmp    5cf <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56e:	75 1d                	jne    58d <printf+0x12e>
        putc(fd, *ap);
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 06 fe ff ff       	call   38a <putc>
 584:	83 c4 10             	add    $0x10,%esp
        ap++;
 587:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58b:	eb 42                	jmp    5cf <printf+0x170>
      } else if(c == '%'){
 58d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 591:	75 17                	jne    5aa <printf+0x14b>
        putc(fd, c);
 593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	83 ec 08             	sub    $0x8,%esp
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 e5 fd ff ff       	call   38a <putc>
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	eb 25                	jmp    5cf <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5aa:	83 ec 08             	sub    $0x8,%esp
 5ad:	6a 25                	push   $0x25
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 d3 fd ff ff       	call   38a <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 be fd ff ff       	call   38a <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5da:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	84 c0                	test   %al,%al
 5e7:	0f 85 94 fe ff ff    	jne    481 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	83 e8 08             	sub    $0x8,%eax
 5fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 603:	89 45 fc             	mov    %eax,-0x4(%ebp)
 606:	eb 24                	jmp    62c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 610:	77 12                	ja     624 <free+0x35>
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 618:	77 24                	ja     63e <free+0x4f>
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 622:	77 1a                	ja     63e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 632:	76 d4                	jbe    608 <free+0x19>
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63c:	76 ca                	jbe    608 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	39 c2                	cmp    %eax,%edx
 657:	75 24                	jne    67d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 50 04             	mov    0x4(%eax),%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	8b 10                	mov    (%eax),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	89 10                	mov    %edx,(%eax)
 67b:	eb 0a                	jmp    687 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 10                	mov    (%eax),%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	01 d0                	add    %edx,%eax
 699:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69c:	75 20                	jne    6be <free+0xcf>
    p->s.size += bp->s.size;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	01 c2                	add    %eax,%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	89 10                	mov    %edx,(%eax)
 6bc:	eb 08                	jmp    6c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6ce:	c9                   	leave  
 6cf:	c3                   	ret    

000006d0 <morecore>:

static Header*
morecore(uint nu)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6dd:	77 07                	ja     6e6 <morecore+0x16>
    nu = 4096;
 6df:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	c1 e0 03             	shl    $0x3,%eax
 6ec:	83 ec 0c             	sub    $0xc,%esp
 6ef:	50                   	push   %eax
 6f0:	e8 4d fc ff ff       	call   342 <sbrk>
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ff:	75 07                	jne    708 <morecore+0x38>
    return 0;
 701:	b8 00 00 00 00       	mov    $0x0,%eax
 706:	eb 26                	jmp    72e <morecore+0x5e>
  hp = (Header*)p;
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 711:	8b 55 08             	mov    0x8(%ebp),%edx
 714:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	83 c0 08             	add    $0x8,%eax
 71d:	83 ec 0c             	sub    $0xc,%esp
 720:	50                   	push   %eax
 721:	e8 c9 fe ff ff       	call   5ef <free>
 726:	83 c4 10             	add    $0x10,%esp
  return freep;
 729:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 72e:	c9                   	leave  
 72f:	c3                   	ret    

00000730 <malloc>:

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	83 c0 07             	add    $0x7,%eax
 73c:	c1 e8 03             	shr    $0x3,%eax
 73f:	83 c0 01             	add    $0x1,%eax
 742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 745:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 74a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 751:	75 23                	jne    776 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 753:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 762:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 767:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 76c:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 773:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 787:	72 4d                	jb     7d6 <malloc+0xa6>
      if(p->s.size == nunits)
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 792:	75 0c                	jne    7a0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	89 10                	mov    %edx,(%eax)
 79e:	eb 26                	jmp    7c6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a9:	89 c2                	mov    %eax,%edx
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	c1 e0 03             	shl    $0x3,%eax
 7ba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	83 c0 08             	add    $0x8,%eax
 7d4:	eb 3b                	jmp    811 <malloc+0xe1>
    }
    if(p == freep)
 7d6:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7db:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7de:	75 1e                	jne    7fe <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7e0:	83 ec 0c             	sub    $0xc,%esp
 7e3:	ff 75 ec             	pushl  -0x14(%ebp)
 7e6:	e8 e5 fe ff ff       	call   6d0 <morecore>
 7eb:	83 c4 10             	add    $0x10,%esp
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f5:	75 07                	jne    7fe <malloc+0xce>
        return 0;
 7f7:	b8 00 00 00 00       	mov    $0x0,%eax
 7fc:	eb 13                	jmp    811 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80c:	e9 6d ff ff ff       	jmp    77e <malloc+0x4e>
}
 811:	c9                   	leave  
 812:	c3                   	ret    
