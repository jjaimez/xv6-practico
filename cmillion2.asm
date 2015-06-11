
_cmillion2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
    int i = 0;
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i<10000000){
  18:	eb 04                	jmp    1e <main+0x1e>
        i++;
  1a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

int
main(int argc, char *argv[])
{
    int i = 0;
    while (i<10000000){
  1e:	81 7d f4 7f 96 98 00 	cmpl   $0x98967f,-0xc(%ebp)
  25:	7e f3                	jle    1a <main+0x1a>
        i++;
    }
    set_priority(0); // change its priority
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	6a 00                	push   $0x0
  2c:	e8 0a 03 00 00       	call   33b <set_priority>
  31:	83 c4 10             	add    $0x10,%esp
    procstat(); //print all process (this process ends whit priority 0 or 1)
  34:	e8 fa 02 00 00       	call   333 <procstat>
    exit();
  39:	e8 55 02 00 00       	call   293 <exit>

0000003e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	57                   	push   %edi
  42:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  46:	8b 55 10             	mov    0x10(%ebp),%edx
  49:	8b 45 0c             	mov    0xc(%ebp),%eax
  4c:	89 cb                	mov    %ecx,%ebx
  4e:	89 df                	mov    %ebx,%edi
  50:	89 d1                	mov    %edx,%ecx
  52:	fc                   	cld    
  53:	f3 aa                	rep stos %al,%es:(%edi)
  55:	89 ca                	mov    %ecx,%edx
  57:	89 fb                	mov    %edi,%ebx
  59:	89 5d 08             	mov    %ebx,0x8(%ebp)
  5c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  5f:	5b                   	pop    %ebx
  60:	5f                   	pop    %edi
  61:	5d                   	pop    %ebp
  62:	c3                   	ret    

00000063 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  69:	8b 45 08             	mov    0x8(%ebp),%eax
  6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  6f:	90                   	nop
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	8d 50 01             	lea    0x1(%eax),%edx
  76:	89 55 08             	mov    %edx,0x8(%ebp)
  79:	8b 55 0c             	mov    0xc(%ebp),%edx
  7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  7f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  82:	0f b6 12             	movzbl (%edx),%edx
  85:	88 10                	mov    %dl,(%eax)
  87:	0f b6 00             	movzbl (%eax),%eax
  8a:	84 c0                	test   %al,%al
  8c:	75 e2                	jne    70 <strcpy+0xd>
    ;
  return os;
  8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  91:	c9                   	leave  
  92:	c3                   	ret    

00000093 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  96:	eb 08                	jmp    a0 <strcmp+0xd>
    p++, q++;
  98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  9c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	84 c0                	test   %al,%al
  a8:	74 10                	je     ba <strcmp+0x27>
  aa:	8b 45 08             	mov    0x8(%ebp),%eax
  ad:	0f b6 10             	movzbl (%eax),%edx
  b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	38 c2                	cmp    %al,%dl
  b8:	74 de                	je     98 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	0f b6 d0             	movzbl %al,%edx
  c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	0f b6 c0             	movzbl %al,%eax
  cc:	29 c2                	sub    %eax,%edx
  ce:	89 d0                	mov    %edx,%eax
}
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    

000000d2 <strlen>:

uint
strlen(char *s)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  df:	eb 04                	jmp    e5 <strlen+0x13>
  e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	84 c0                	test   %al,%al
  f2:	75 ed                	jne    e1 <strlen+0xf>
    ;
  return n;
  f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f7:	c9                   	leave  
  f8:	c3                   	ret    

000000f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  fc:	8b 45 10             	mov    0x10(%ebp),%eax
  ff:	50                   	push   %eax
 100:	ff 75 0c             	pushl  0xc(%ebp)
 103:	ff 75 08             	pushl  0x8(%ebp)
 106:	e8 33 ff ff ff       	call   3e <stosb>
 10b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 111:	c9                   	leave  
 112:	c3                   	ret    

00000113 <strchr>:

char*
strchr(const char *s, char c)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 04             	sub    $0x4,%esp
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 11f:	eb 14                	jmp    135 <strchr+0x22>
    if(*s == c)
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	3a 45 fc             	cmp    -0x4(%ebp),%al
 12a:	75 05                	jne    131 <strchr+0x1e>
      return (char*)s;
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	eb 13                	jmp    144 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	84 c0                	test   %al,%al
 13d:	75 e2                	jne    121 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 13f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <gets>:

char*
gets(char *buf, int max)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 153:	eb 44                	jmp    199 <gets+0x53>
    cc = read(0, &c, 1);
 155:	83 ec 04             	sub    $0x4,%esp
 158:	6a 01                	push   $0x1
 15a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 15d:	50                   	push   %eax
 15e:	6a 00                	push   $0x0
 160:	e8 46 01 00 00       	call   2ab <read>
 165:	83 c4 10             	add    $0x10,%esp
 168:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 16b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16f:	7f 02                	jg     173 <gets+0x2d>
      break;
 171:	eb 31                	jmp    1a4 <gets+0x5e>
    buf[i++] = c;
 173:	8b 45 f4             	mov    -0xc(%ebp),%eax
 176:	8d 50 01             	lea    0x1(%eax),%edx
 179:	89 55 f4             	mov    %edx,-0xc(%ebp)
 17c:	89 c2                	mov    %eax,%edx
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	01 c2                	add    %eax,%edx
 183:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 187:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	3c 0a                	cmp    $0xa,%al
 18f:	74 13                	je     1a4 <gets+0x5e>
 191:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 195:	3c 0d                	cmp    $0xd,%al
 197:	74 0b                	je     1a4 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a2:	7c b1                	jl     155 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	01 d0                	add    %edx,%eax
 1ac:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b2:	c9                   	leave  
 1b3:	c3                   	ret    

000001b4 <stat>:

int
stat(char *n, struct stat *st)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	6a 00                	push   $0x0
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	e8 0c 01 00 00       	call   2d3 <open>
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d1:	79 07                	jns    1da <stat+0x26>
    return -1;
 1d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d8:	eb 25                	jmp    1ff <stat+0x4b>
  r = fstat(fd, st);
 1da:	83 ec 08             	sub    $0x8,%esp
 1dd:	ff 75 0c             	pushl  0xc(%ebp)
 1e0:	ff 75 f4             	pushl  -0xc(%ebp)
 1e3:	e8 03 01 00 00       	call   2eb <fstat>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ee:	83 ec 0c             	sub    $0xc,%esp
 1f1:	ff 75 f4             	pushl  -0xc(%ebp)
 1f4:	e8 c2 00 00 00       	call   2bb <close>
 1f9:	83 c4 10             	add    $0x10,%esp
  return r;
 1fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <atoi>:

int
atoi(const char *s)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 20e:	eb 25                	jmp    235 <atoi+0x34>
    n = n*10 + *s++ - '0';
 210:	8b 55 fc             	mov    -0x4(%ebp),%edx
 213:	89 d0                	mov    %edx,%eax
 215:	c1 e0 02             	shl    $0x2,%eax
 218:	01 d0                	add    %edx,%eax
 21a:	01 c0                	add    %eax,%eax
 21c:	89 c1                	mov    %eax,%ecx
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	8d 50 01             	lea    0x1(%eax),%edx
 224:	89 55 08             	mov    %edx,0x8(%ebp)
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	0f be c0             	movsbl %al,%eax
 22d:	01 c8                	add    %ecx,%eax
 22f:	83 e8 30             	sub    $0x30,%eax
 232:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 00             	movzbl (%eax),%eax
 23b:	3c 2f                	cmp    $0x2f,%al
 23d:	7e 0a                	jle    249 <atoi+0x48>
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	3c 39                	cmp    $0x39,%al
 247:	7e c7                	jle    210 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 260:	eb 17                	jmp    279 <memmove+0x2b>
    *dst++ = *src++;
 262:	8b 45 fc             	mov    -0x4(%ebp),%eax
 265:	8d 50 01             	lea    0x1(%eax),%edx
 268:	89 55 fc             	mov    %edx,-0x4(%ebp)
 26b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 26e:	8d 4a 01             	lea    0x1(%edx),%ecx
 271:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 274:	0f b6 12             	movzbl (%edx),%edx
 277:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 279:	8b 45 10             	mov    0x10(%ebp),%eax
 27c:	8d 50 ff             	lea    -0x1(%eax),%edx
 27f:	89 55 10             	mov    %edx,0x10(%ebp)
 282:	85 c0                	test   %eax,%eax
 284:	7f dc                	jg     262 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 286:	8b 45 08             	mov    0x8(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <exit>:
SYSCALL(exit)
 293:	b8 02 00 00 00       	mov    $0x2,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <wait>:
SYSCALL(wait)
 29b:	b8 03 00 00 00       	mov    $0x3,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <pipe>:
SYSCALL(pipe)
 2a3:	b8 04 00 00 00       	mov    $0x4,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <read>:
SYSCALL(read)
 2ab:	b8 05 00 00 00       	mov    $0x5,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <write>:
SYSCALL(write)
 2b3:	b8 10 00 00 00       	mov    $0x10,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <close>:
SYSCALL(close)
 2bb:	b8 15 00 00 00       	mov    $0x15,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <kill>:
SYSCALL(kill)
 2c3:	b8 06 00 00 00       	mov    $0x6,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exec>:
SYSCALL(exec)
 2cb:	b8 07 00 00 00       	mov    $0x7,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <open>:
SYSCALL(open)
 2d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mknod>:
SYSCALL(mknod)
 2db:	b8 11 00 00 00       	mov    $0x11,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <unlink>:
SYSCALL(unlink)
 2e3:	b8 12 00 00 00       	mov    $0x12,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <fstat>:
SYSCALL(fstat)
 2eb:	b8 08 00 00 00       	mov    $0x8,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <link>:
SYSCALL(link)
 2f3:	b8 13 00 00 00       	mov    $0x13,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mkdir>:
SYSCALL(mkdir)
 2fb:	b8 14 00 00 00       	mov    $0x14,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <chdir>:
SYSCALL(chdir)
 303:	b8 09 00 00 00       	mov    $0x9,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <dup>:
SYSCALL(dup)
 30b:	b8 0a 00 00 00       	mov    $0xa,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <getpid>:
SYSCALL(getpid)
 313:	b8 0b 00 00 00       	mov    $0xb,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sbrk>:
SYSCALL(sbrk)
 31b:	b8 0c 00 00 00       	mov    $0xc,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <sleep>:
SYSCALL(sleep)
 323:	b8 0d 00 00 00       	mov    $0xd,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <uptime>:
SYSCALL(uptime)
 32b:	b8 0e 00 00 00       	mov    $0xe,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <procstat>:
SYSCALL(procstat)
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <set_priority>:
SYSCALL(set_priority)
 33b:	b8 17 00 00 00       	mov    $0x17,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <semget>:
SYSCALL(semget)
 343:	b8 18 00 00 00       	mov    $0x18,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <semfree>:
SYSCALL(semfree)
 34b:	b8 19 00 00 00       	mov    $0x19,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <semdown>:
SYSCALL(semdown)
 353:	b8 1a 00 00 00       	mov    $0x1a,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <semup>:
 35b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	83 ec 18             	sub    $0x18,%esp
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36f:	83 ec 04             	sub    $0x4,%esp
 372:	6a 01                	push   $0x1
 374:	8d 45 f4             	lea    -0xc(%ebp),%eax
 377:	50                   	push   %eax
 378:	ff 75 08             	pushl  0x8(%ebp)
 37b:	e8 33 ff ff ff       	call   2b3 <write>
 380:	83 c4 10             	add    $0x10,%esp
}
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	53                   	push   %ebx
 389:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 393:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 397:	74 17                	je     3b0 <printint+0x2b>
 399:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39d:	79 11                	jns    3b0 <printint+0x2b>
    neg = 1;
 39f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	f7 d8                	neg    %eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ae:	eb 06                	jmp    3b6 <printint+0x31>
  } else {
    x = xx;
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c0:	8d 41 01             	lea    0x1(%ecx),%eax
 3c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cc:	ba 00 00 00 00       	mov    $0x0,%edx
 3d1:	f7 f3                	div    %ebx
 3d3:	89 d0                	mov    %edx,%eax
 3d5:	0f b6 80 3c 0a 00 00 	movzbl 0xa3c(%eax),%eax
 3dc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 f3                	div    %ebx
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f4:	75 c7                	jne    3bd <printint+0x38>
  if(neg)
 3f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fa:	74 0e                	je     40a <printint+0x85>
    buf[i++] = '-';
 3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ff:	8d 50 01             	lea    0x1(%eax),%edx
 402:	89 55 f4             	mov    %edx,-0xc(%ebp)
 405:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40a:	eb 1d                	jmp    429 <printint+0xa4>
    putc(fd, buf[i]);
 40c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	01 d0                	add    %edx,%eax
 414:	0f b6 00             	movzbl (%eax),%eax
 417:	0f be c0             	movsbl %al,%eax
 41a:	83 ec 08             	sub    $0x8,%esp
 41d:	50                   	push   %eax
 41e:	ff 75 08             	pushl  0x8(%ebp)
 421:	e8 3d ff ff ff       	call   363 <putc>
 426:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 429:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 431:	79 d9                	jns    40c <printint+0x87>
    putc(fd, buf[i]);
}
 433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 445:	8d 45 0c             	lea    0xc(%ebp),%eax
 448:	83 c0 04             	add    $0x4,%eax
 44b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 455:	e9 59 01 00 00       	jmp    5b3 <printf+0x17b>
    c = fmt[i] & 0xff;
 45a:	8b 55 0c             	mov    0xc(%ebp),%edx
 45d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 460:	01 d0                	add    %edx,%eax
 462:	0f b6 00             	movzbl (%eax),%eax
 465:	0f be c0             	movsbl %al,%eax
 468:	25 ff 00 00 00       	and    $0xff,%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 474:	75 2c                	jne    4a2 <printf+0x6a>
      if(c == '%'){
 476:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47a:	75 0c                	jne    488 <printf+0x50>
        state = '%';
 47c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 483:	e9 27 01 00 00       	jmp    5af <printf+0x177>
      } else {
        putc(fd, c);
 488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48b:	0f be c0             	movsbl %al,%eax
 48e:	83 ec 08             	sub    $0x8,%esp
 491:	50                   	push   %eax
 492:	ff 75 08             	pushl  0x8(%ebp)
 495:	e8 c9 fe ff ff       	call   363 <putc>
 49a:	83 c4 10             	add    $0x10,%esp
 49d:	e9 0d 01 00 00       	jmp    5af <printf+0x177>
      }
    } else if(state == '%'){
 4a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a6:	0f 85 03 01 00 00    	jne    5af <printf+0x177>
      if(c == 'd'){
 4ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b0:	75 1e                	jne    4d0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b5:	8b 00                	mov    (%eax),%eax
 4b7:	6a 01                	push   $0x1
 4b9:	6a 0a                	push   $0xa
 4bb:	50                   	push   %eax
 4bc:	ff 75 08             	pushl  0x8(%ebp)
 4bf:	e8 c1 fe ff ff       	call   385 <printint>
 4c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cb:	e9 d8 00 00 00       	jmp    5a8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d4:	74 06                	je     4dc <printf+0xa4>
 4d6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4da:	75 1e                	jne    4fa <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	6a 00                	push   $0x0
 4e3:	6a 10                	push   $0x10
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 97 fe ff ff       	call   385 <printint>
 4ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f5:	e9 ae 00 00 00       	jmp    5a8 <printf+0x170>
      } else if(c == 's'){
 4fa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4fe:	75 43                	jne    543 <printf+0x10b>
        s = (char*)*ap;
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 510:	75 07                	jne    519 <printf+0xe1>
          s = "(null)";
 512:	c7 45 f4 ec 07 00 00 	movl   $0x7ec,-0xc(%ebp)
        while(*s != 0){
 519:	eb 1c                	jmp    537 <printf+0xff>
          putc(fd, *s);
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	0f be c0             	movsbl %al,%eax
 524:	83 ec 08             	sub    $0x8,%esp
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 33 fe ff ff       	call   363 <putc>
 530:	83 c4 10             	add    $0x10,%esp
          s++;
 533:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	84 c0                	test   %al,%al
 53f:	75 da                	jne    51b <printf+0xe3>
 541:	eb 65                	jmp    5a8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 543:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 547:	75 1d                	jne    566 <printf+0x12e>
        putc(fd, *ap);
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	0f be c0             	movsbl %al,%eax
 551:	83 ec 08             	sub    $0x8,%esp
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 06 fe ff ff       	call   363 <putc>
 55d:	83 c4 10             	add    $0x10,%esp
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	eb 42                	jmp    5a8 <printf+0x170>
      } else if(c == '%'){
 566:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56a:	75 17                	jne    583 <printf+0x14b>
        putc(fd, c);
 56c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	83 ec 08             	sub    $0x8,%esp
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 e5 fd ff ff       	call   363 <putc>
 57e:	83 c4 10             	add    $0x10,%esp
 581:	eb 25                	jmp    5a8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 583:	83 ec 08             	sub    $0x8,%esp
 586:	6a 25                	push   $0x25
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 d3 fd ff ff       	call   363 <putc>
 590:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	83 ec 08             	sub    $0x8,%esp
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 be fd ff ff       	call   363 <putc>
 5a5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	84 c0                	test   %al,%al
 5c0:	0f 85 94 fe ff ff    	jne    45a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c6:	c9                   	leave  
 5c7:	c3                   	ret    

000005c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	83 e8 08             	sub    $0x8,%eax
 5d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d7:	a1 58 0a 00 00       	mov    0xa58,%eax
 5dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5df:	eb 24                	jmp    605 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e9:	77 12                	ja     5fd <free+0x35>
 5eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f1:	77 24                	ja     617 <free+0x4f>
 5f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fb:	77 1a                	ja     617 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	89 45 fc             	mov    %eax,-0x4(%ebp)
 605:	8b 45 f8             	mov    -0x8(%ebp),%eax
 608:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60b:	76 d4                	jbe    5e1 <free+0x19>
 60d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 615:	76 ca                	jbe    5e1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 617:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61a:	8b 40 04             	mov    0x4(%eax),%eax
 61d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	01 c2                	add    %eax,%edx
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	39 c2                	cmp    %eax,%edx
 630:	75 24                	jne    656 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	8b 40 04             	mov    0x4(%eax),%eax
 640:	01 c2                	add    %eax,%edx
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	8b 10                	mov    (%eax),%edx
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	89 10                	mov    %edx,(%eax)
 654:	eb 0a                	jmp    660 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 10                	mov    (%eax),%edx
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 40 04             	mov    0x4(%eax),%eax
 666:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	01 d0                	add    %edx,%eax
 672:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 675:	75 20                	jne    697 <free+0xcf>
    p->s.size += bp->s.size;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 50 04             	mov    0x4(%eax),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	8b 40 04             	mov    0x4(%eax),%eax
 683:	01 c2                	add    %eax,%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 10                	mov    (%eax),%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	89 10                	mov    %edx,(%eax)
 695:	eb 08                	jmp    69f <free+0xd7>
  } else
    p->s.ptr = bp;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 69d:	89 10                	mov    %edx,(%eax)
  freep = p;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	a3 58 0a 00 00       	mov    %eax,0xa58
}
 6a7:	c9                   	leave  
 6a8:	c3                   	ret    

000006a9 <morecore>:

static Header*
morecore(uint nu)
{
 6a9:	55                   	push   %ebp
 6aa:	89 e5                	mov    %esp,%ebp
 6ac:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6af:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b6:	77 07                	ja     6bf <morecore+0x16>
    nu = 4096;
 6b8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	c1 e0 03             	shl    $0x3,%eax
 6c5:	83 ec 0c             	sub    $0xc,%esp
 6c8:	50                   	push   %eax
 6c9:	e8 4d fc ff ff       	call   31b <sbrk>
 6ce:	83 c4 10             	add    $0x10,%esp
 6d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d8:	75 07                	jne    6e1 <morecore+0x38>
    return 0;
 6da:	b8 00 00 00 00       	mov    $0x0,%eax
 6df:	eb 26                	jmp    707 <morecore+0x5e>
  hp = (Header*)p;
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	8b 55 08             	mov    0x8(%ebp),%edx
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f3:	83 c0 08             	add    $0x8,%eax
 6f6:	83 ec 0c             	sub    $0xc,%esp
 6f9:	50                   	push   %eax
 6fa:	e8 c9 fe ff ff       	call   5c8 <free>
 6ff:	83 c4 10             	add    $0x10,%esp
  return freep;
 702:	a1 58 0a 00 00       	mov    0xa58,%eax
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <malloc>:

void*
malloc(uint nbytes)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	83 c0 07             	add    $0x7,%eax
 715:	c1 e8 03             	shr    $0x3,%eax
 718:	83 c0 01             	add    $0x1,%eax
 71b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 71e:	a1 58 0a 00 00       	mov    0xa58,%eax
 723:	89 45 f0             	mov    %eax,-0x10(%ebp)
 726:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72a:	75 23                	jne    74f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 72c:	c7 45 f0 50 0a 00 00 	movl   $0xa50,-0x10(%ebp)
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	a3 58 0a 00 00       	mov    %eax,0xa58
 73b:	a1 58 0a 00 00       	mov    0xa58,%eax
 740:	a3 50 0a 00 00       	mov    %eax,0xa50
    base.s.size = 0;
 745:	c7 05 54 0a 00 00 00 	movl   $0x0,0xa54
 74c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 760:	72 4d                	jb     7af <malloc+0xa6>
      if(p->s.size == nunits)
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76b:	75 0c                	jne    779 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 10                	mov    (%eax),%edx
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	89 10                	mov    %edx,(%eax)
 777:	eb 26                	jmp    79f <malloc+0x96>
      else {
        p->s.size -= nunits;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 782:	89 c2                	mov    %eax,%edx
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	c1 e0 03             	shl    $0x3,%eax
 793:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 55 ec             	mov    -0x14(%ebp),%edx
 79c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	a3 58 0a 00 00       	mov    %eax,0xa58
      return (void*)(p + 1);
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	83 c0 08             	add    $0x8,%eax
 7ad:	eb 3b                	jmp    7ea <malloc+0xe1>
    }
    if(p == freep)
 7af:	a1 58 0a 00 00       	mov    0xa58,%eax
 7b4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b7:	75 1e                	jne    7d7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b9:	83 ec 0c             	sub    $0xc,%esp
 7bc:	ff 75 ec             	pushl  -0x14(%ebp)
 7bf:	e8 e5 fe ff ff       	call   6a9 <morecore>
 7c4:	83 c4 10             	add    $0x10,%esp
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ce:	75 07                	jne    7d7 <malloc+0xce>
        return 0;
 7d0:	b8 00 00 00 00       	mov    $0x0,%eax
 7d5:	eb 13                	jmp    7ea <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e5:	e9 6d ff ff ff       	jmp    757 <malloc+0x4e>
}
 7ea:	c9                   	leave  
 7eb:	c3                   	ret    
