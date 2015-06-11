
_cmillion:     file format elf32-i386


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
  procstat(); //print all process (this process ends with priority 3)
  27:	e8 fa 02 00 00       	call   326 <procstat>
  exit();
  2c:	e8 55 02 00 00       	call   286 <exit>

00000031 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	57                   	push   %edi
  35:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 55 10             	mov    0x10(%ebp),%edx
  3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  3f:	89 cb                	mov    %ecx,%ebx
  41:	89 df                	mov    %ebx,%edi
  43:	89 d1                	mov    %edx,%ecx
  45:	fc                   	cld    
  46:	f3 aa                	rep stos %al,%es:(%edi)
  48:	89 ca                	mov    %ecx,%edx
  4a:	89 fb                	mov    %edi,%ebx
  4c:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  52:	5b                   	pop    %ebx
  53:	5f                   	pop    %edi
  54:	5d                   	pop    %ebp
  55:	c3                   	ret    

00000056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  56:	55                   	push   %ebp
  57:	89 e5                	mov    %esp,%ebp
  59:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  62:	90                   	nop
  63:	8b 45 08             	mov    0x8(%ebp),%eax
  66:	8d 50 01             	lea    0x1(%eax),%edx
  69:	89 55 08             	mov    %edx,0x8(%ebp)
  6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  75:	0f b6 12             	movzbl (%edx),%edx
  78:	88 10                	mov    %dl,(%eax)
  7a:	0f b6 00             	movzbl (%eax),%eax
  7d:	84 c0                	test   %al,%al
  7f:	75 e2                	jne    63 <strcpy+0xd>
    ;
  return os;
  81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  89:	eb 08                	jmp    93 <strcmp+0xd>
    p++, q++;
  8b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 00             	movzbl (%eax),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 10                	je     ad <strcmp+0x27>
  9d:	8b 45 08             	mov    0x8(%ebp),%eax
  a0:	0f b6 10             	movzbl (%eax),%edx
  a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	38 c2                	cmp    %al,%dl
  ab:	74 de                	je     8b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ad:	8b 45 08             	mov    0x8(%ebp),%eax
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	0f b6 d0             	movzbl %al,%edx
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	0f b6 c0             	movzbl %al,%eax
  bf:	29 c2                	sub    %eax,%edx
  c1:	89 d0                	mov    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d2:	eb 04                	jmp    d8 <strlen+0x13>
  d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	01 d0                	add    %edx,%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	84 c0                	test   %al,%al
  e5:	75 ed                	jne    d4 <strlen+0xf>
    ;
  return n;
  e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ea:	c9                   	leave  
  eb:	c3                   	ret    

000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ef:	8b 45 10             	mov    0x10(%ebp),%eax
  f2:	50                   	push   %eax
  f3:	ff 75 0c             	pushl  0xc(%ebp)
  f6:	ff 75 08             	pushl  0x8(%ebp)
  f9:	e8 33 ff ff ff       	call   31 <stosb>
  fe:	83 c4 0c             	add    $0xc,%esp
  return dst;
 101:	8b 45 08             	mov    0x8(%ebp),%eax
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 112:	eb 14                	jmp    128 <strchr+0x22>
    if(*s == c)
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11d:	75 05                	jne    124 <strchr+0x1e>
      return (char*)s;
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	eb 13                	jmp    137 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	84 c0                	test   %al,%al
 130:	75 e2                	jne    114 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 132:	b8 00 00 00 00       	mov    $0x0,%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <gets>:

char*
gets(char *buf, int max)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 146:	eb 44                	jmp    18c <gets+0x53>
    cc = read(0, &c, 1);
 148:	83 ec 04             	sub    $0x4,%esp
 14b:	6a 01                	push   $0x1
 14d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 150:	50                   	push   %eax
 151:	6a 00                	push   $0x0
 153:	e8 46 01 00 00       	call   29e <read>
 158:	83 c4 10             	add    $0x10,%esp
 15b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 162:	7f 02                	jg     166 <gets+0x2d>
      break;
 164:	eb 31                	jmp    197 <gets+0x5e>
    buf[i++] = c;
 166:	8b 45 f4             	mov    -0xc(%ebp),%eax
 169:	8d 50 01             	lea    0x1(%eax),%edx
 16c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 16f:	89 c2                	mov    %eax,%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 c2                	add    %eax,%edx
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 17c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 13                	je     197 <gets+0x5e>
 184:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0b                	je     197 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18f:	83 c0 01             	add    $0x1,%eax
 192:	3b 45 0c             	cmp    0xc(%ebp),%eax
 195:	7c b1                	jl     148 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 197:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	01 d0                	add    %edx,%eax
 19f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a5:	c9                   	leave  
 1a6:	c3                   	ret    

000001a7 <stat>:

int
stat(char *n, struct stat *st)
{
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	6a 00                	push   $0x0
 1b2:	ff 75 08             	pushl  0x8(%ebp)
 1b5:	e8 0c 01 00 00       	call   2c6 <open>
 1ba:	83 c4 10             	add    $0x10,%esp
 1bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c4:	79 07                	jns    1cd <stat+0x26>
    return -1;
 1c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cb:	eb 25                	jmp    1f2 <stat+0x4b>
  r = fstat(fd, st);
 1cd:	83 ec 08             	sub    $0x8,%esp
 1d0:	ff 75 0c             	pushl  0xc(%ebp)
 1d3:	ff 75 f4             	pushl  -0xc(%ebp)
 1d6:	e8 03 01 00 00       	call   2de <fstat>
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e1:	83 ec 0c             	sub    $0xc,%esp
 1e4:	ff 75 f4             	pushl  -0xc(%ebp)
 1e7:	e8 c2 00 00 00       	call   2ae <close>
 1ec:	83 c4 10             	add    $0x10,%esp
  return r;
 1ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 201:	eb 25                	jmp    228 <atoi+0x34>
    n = n*10 + *s++ - '0';
 203:	8b 55 fc             	mov    -0x4(%ebp),%edx
 206:	89 d0                	mov    %edx,%eax
 208:	c1 e0 02             	shl    $0x2,%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	01 c0                	add    %eax,%eax
 20f:	89 c1                	mov    %eax,%ecx
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	8d 50 01             	lea    0x1(%eax),%edx
 217:	89 55 08             	mov    %edx,0x8(%ebp)
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	0f be c0             	movsbl %al,%eax
 220:	01 c8                	add    %ecx,%eax
 222:	83 e8 30             	sub    $0x30,%eax
 225:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3c 2f                	cmp    $0x2f,%al
 230:	7e 0a                	jle    23c <atoi+0x48>
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	0f b6 00             	movzbl (%eax),%eax
 238:	3c 39                	cmp    $0x39,%al
 23a:	7e c7                	jle    203 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 23c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23f:	c9                   	leave  
 240:	c3                   	ret    

00000241 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
 244:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24d:	8b 45 0c             	mov    0xc(%ebp),%eax
 250:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 253:	eb 17                	jmp    26c <memmove+0x2b>
    *dst++ = *src++;
 255:	8b 45 fc             	mov    -0x4(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 261:	8d 4a 01             	lea    0x1(%edx),%ecx
 264:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 267:	0f b6 12             	movzbl (%edx),%edx
 26a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26c:	8b 45 10             	mov    0x10(%ebp),%eax
 26f:	8d 50 ff             	lea    -0x1(%eax),%edx
 272:	89 55 10             	mov    %edx,0x10(%ebp)
 275:	85 c0                	test   %eax,%eax
 277:	7f dc                	jg     255 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 279:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27e:	b8 01 00 00 00       	mov    $0x1,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <exit>:
SYSCALL(exit)
 286:	b8 02 00 00 00       	mov    $0x2,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <wait>:
SYSCALL(wait)
 28e:	b8 03 00 00 00       	mov    $0x3,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <pipe>:
SYSCALL(pipe)
 296:	b8 04 00 00 00       	mov    $0x4,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <read>:
SYSCALL(read)
 29e:	b8 05 00 00 00       	mov    $0x5,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <write>:
SYSCALL(write)
 2a6:	b8 10 00 00 00       	mov    $0x10,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <close>:
SYSCALL(close)
 2ae:	b8 15 00 00 00       	mov    $0x15,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <kill>:
SYSCALL(kill)
 2b6:	b8 06 00 00 00       	mov    $0x6,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <exec>:
SYSCALL(exec)
 2be:	b8 07 00 00 00       	mov    $0x7,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <open>:
SYSCALL(open)
 2c6:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <mknod>:
SYSCALL(mknod)
 2ce:	b8 11 00 00 00       	mov    $0x11,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <unlink>:
SYSCALL(unlink)
 2d6:	b8 12 00 00 00       	mov    $0x12,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <fstat>:
SYSCALL(fstat)
 2de:	b8 08 00 00 00       	mov    $0x8,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <link>:
SYSCALL(link)
 2e6:	b8 13 00 00 00       	mov    $0x13,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <mkdir>:
SYSCALL(mkdir)
 2ee:	b8 14 00 00 00       	mov    $0x14,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <chdir>:
SYSCALL(chdir)
 2f6:	b8 09 00 00 00       	mov    $0x9,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <dup>:
SYSCALL(dup)
 2fe:	b8 0a 00 00 00       	mov    $0xa,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <getpid>:
SYSCALL(getpid)
 306:	b8 0b 00 00 00       	mov    $0xb,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <sbrk>:
SYSCALL(sbrk)
 30e:	b8 0c 00 00 00       	mov    $0xc,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <sleep>:
SYSCALL(sleep)
 316:	b8 0d 00 00 00       	mov    $0xd,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <uptime>:
SYSCALL(uptime)
 31e:	b8 0e 00 00 00       	mov    $0xe,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <procstat>:
SYSCALL(procstat)
 326:	b8 16 00 00 00       	mov    $0x16,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <set_priority>:
SYSCALL(set_priority)
 32e:	b8 17 00 00 00       	mov    $0x17,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <semget>:
SYSCALL(semget)
 336:	b8 18 00 00 00       	mov    $0x18,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <semfree>:
SYSCALL(semfree)
 33e:	b8 19 00 00 00       	mov    $0x19,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <semdown>:
SYSCALL(semdown)
 346:	b8 1a 00 00 00       	mov    $0x1a,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <semup>:
 34e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 18             	sub    $0x18,%esp
 35c:	8b 45 0c             	mov    0xc(%ebp),%eax
 35f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 362:	83 ec 04             	sub    $0x4,%esp
 365:	6a 01                	push   $0x1
 367:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36a:	50                   	push   %eax
 36b:	ff 75 08             	pushl  0x8(%ebp)
 36e:	e8 33 ff ff ff       	call   2a6 <write>
 373:	83 c4 10             	add    $0x10,%esp
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	53                   	push   %ebx
 37c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 386:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38a:	74 17                	je     3a3 <printint+0x2b>
 38c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 390:	79 11                	jns    3a3 <printint+0x2b>
    neg = 1;
 392:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 399:	8b 45 0c             	mov    0xc(%ebp),%eax
 39c:	f7 d8                	neg    %eax
 39e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a1:	eb 06                	jmp    3a9 <printint+0x31>
  } else {
    x = xx;
 3a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b3:	8d 41 01             	lea    0x1(%ecx),%eax
 3b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bf:	ba 00 00 00 00       	mov    $0x0,%edx
 3c4:	f7 f3                	div    %ebx
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	0f b6 80 30 0a 00 00 	movzbl 0xa30(%eax),%eax
 3cf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d9:	ba 00 00 00 00       	mov    $0x0,%edx
 3de:	f7 f3                	div    %ebx
 3e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e7:	75 c7                	jne    3b0 <printint+0x38>
  if(neg)
 3e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ed:	74 0e                	je     3fd <printint+0x85>
    buf[i++] = '-';
 3ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f2:	8d 50 01             	lea    0x1(%eax),%edx
 3f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3fd:	eb 1d                	jmp    41c <printint+0xa4>
    putc(fd, buf[i]);
 3ff:	8d 55 dc             	lea    -0x24(%ebp),%edx
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	01 d0                	add    %edx,%eax
 407:	0f b6 00             	movzbl (%eax),%eax
 40a:	0f be c0             	movsbl %al,%eax
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	50                   	push   %eax
 411:	ff 75 08             	pushl  0x8(%ebp)
 414:	e8 3d ff ff ff       	call   356 <putc>
 419:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 424:	79 d9                	jns    3ff <printint+0x87>
    putc(fd, buf[i]);
}
 426:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 431:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 438:	8d 45 0c             	lea    0xc(%ebp),%eax
 43b:	83 c0 04             	add    $0x4,%eax
 43e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 441:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 448:	e9 59 01 00 00       	jmp    5a6 <printf+0x17b>
    c = fmt[i] & 0xff;
 44d:	8b 55 0c             	mov    0xc(%ebp),%edx
 450:	8b 45 f0             	mov    -0x10(%ebp),%eax
 453:	01 d0                	add    %edx,%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	0f be c0             	movsbl %al,%eax
 45b:	25 ff 00 00 00       	and    $0xff,%eax
 460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 463:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 467:	75 2c                	jne    495 <printf+0x6a>
      if(c == '%'){
 469:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46d:	75 0c                	jne    47b <printf+0x50>
        state = '%';
 46f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 476:	e9 27 01 00 00       	jmp    5a2 <printf+0x177>
      } else {
        putc(fd, c);
 47b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47e:	0f be c0             	movsbl %al,%eax
 481:	83 ec 08             	sub    $0x8,%esp
 484:	50                   	push   %eax
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 c9 fe ff ff       	call   356 <putc>
 48d:	83 c4 10             	add    $0x10,%esp
 490:	e9 0d 01 00 00       	jmp    5a2 <printf+0x177>
      }
    } else if(state == '%'){
 495:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 499:	0f 85 03 01 00 00    	jne    5a2 <printf+0x177>
      if(c == 'd'){
 49f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a3:	75 1e                	jne    4c3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a8:	8b 00                	mov    (%eax),%eax
 4aa:	6a 01                	push   $0x1
 4ac:	6a 0a                	push   $0xa
 4ae:	50                   	push   %eax
 4af:	ff 75 08             	pushl  0x8(%ebp)
 4b2:	e8 c1 fe ff ff       	call   378 <printint>
 4b7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4be:	e9 d8 00 00 00       	jmp    59b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c7:	74 06                	je     4cf <printf+0xa4>
 4c9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4cd:	75 1e                	jne    4ed <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d2:	8b 00                	mov    (%eax),%eax
 4d4:	6a 00                	push   $0x0
 4d6:	6a 10                	push   $0x10
 4d8:	50                   	push   %eax
 4d9:	ff 75 08             	pushl  0x8(%ebp)
 4dc:	e8 97 fe ff ff       	call   378 <printint>
 4e1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e8:	e9 ae 00 00 00       	jmp    59b <printf+0x170>
      } else if(c == 's'){
 4ed:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f1:	75 43                	jne    536 <printf+0x10b>
        s = (char*)*ap;
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 503:	75 07                	jne    50c <printf+0xe1>
          s = "(null)";
 505:	c7 45 f4 df 07 00 00 	movl   $0x7df,-0xc(%ebp)
        while(*s != 0){
 50c:	eb 1c                	jmp    52a <printf+0xff>
          putc(fd, *s);
 50e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	0f be c0             	movsbl %al,%eax
 517:	83 ec 08             	sub    $0x8,%esp
 51a:	50                   	push   %eax
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 33 fe ff ff       	call   356 <putc>
 523:	83 c4 10             	add    $0x10,%esp
          s++;
 526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	0f b6 00             	movzbl (%eax),%eax
 530:	84 c0                	test   %al,%al
 532:	75 da                	jne    50e <printf+0xe3>
 534:	eb 65                	jmp    59b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 536:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 53a:	75 1d                	jne    559 <printf+0x12e>
        putc(fd, *ap);
 53c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	83 ec 08             	sub    $0x8,%esp
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 06 fe ff ff       	call   356 <putc>
 550:	83 c4 10             	add    $0x10,%esp
        ap++;
 553:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 557:	eb 42                	jmp    59b <printf+0x170>
      } else if(c == '%'){
 559:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55d:	75 17                	jne    576 <printf+0x14b>
        putc(fd, c);
 55f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 e5 fd ff ff       	call   356 <putc>
 571:	83 c4 10             	add    $0x10,%esp
 574:	eb 25                	jmp    59b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 576:	83 ec 08             	sub    $0x8,%esp
 579:	6a 25                	push   $0x25
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 d3 fd ff ff       	call   356 <putc>
 583:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	50                   	push   %eax
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 be fd ff ff       	call   356 <putc>
 598:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 59b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ac:	01 d0                	add    %edx,%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	84 c0                	test   %al,%al
 5b3:	0f 85 94 fe ff ff    	jne    44d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	83 e8 08             	sub    $0x8,%eax
 5c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 5cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d2:	eb 24                	jmp    5f8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d7:	8b 00                	mov    (%eax),%eax
 5d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dc:	77 12                	ja     5f0 <free+0x35>
 5de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e4:	77 24                	ja     60a <free+0x4f>
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ee:	77 1a                	ja     60a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fe:	76 d4                	jbe    5d4 <free+0x19>
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 608:	76 ca                	jbe    5d4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	8b 40 04             	mov    0x4(%eax),%eax
 610:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 617:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61a:	01 c2                	add    %eax,%edx
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	39 c2                	cmp    %eax,%edx
 623:	75 24                	jne    649 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	8b 50 04             	mov    0x4(%eax),%edx
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	8b 40 04             	mov    0x4(%eax),%eax
 633:	01 c2                	add    %eax,%edx
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	8b 10                	mov    (%eax),%edx
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	89 10                	mov    %edx,(%eax)
 647:	eb 0a                	jmp    653 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	01 d0                	add    %edx,%eax
 665:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 668:	75 20                	jne    68a <free+0xcf>
    p->s.size += bp->s.size;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	01 c2                	add    %eax,%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 10                	mov    (%eax),%edx
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	89 10                	mov    %edx,(%eax)
 688:	eb 08                	jmp    692 <free+0xd7>
  } else
    p->s.ptr = bp;
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 690:	89 10                	mov    %edx,(%eax)
  freep = p;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	a3 4c 0a 00 00       	mov    %eax,0xa4c
}
 69a:	c9                   	leave  
 69b:	c3                   	ret    

0000069c <morecore>:

static Header*
morecore(uint nu)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a9:	77 07                	ja     6b2 <morecore+0x16>
    nu = 4096;
 6ab:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	c1 e0 03             	shl    $0x3,%eax
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	50                   	push   %eax
 6bc:	e8 4d fc ff ff       	call   30e <sbrk>
 6c1:	83 c4 10             	add    $0x10,%esp
 6c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6c7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cb:	75 07                	jne    6d4 <morecore+0x38>
    return 0;
 6cd:	b8 00 00 00 00       	mov    $0x0,%eax
 6d2:	eb 26                	jmp    6fa <morecore+0x5e>
  hp = (Header*)p;
 6d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dd:	8b 55 08             	mov    0x8(%ebp),%edx
 6e0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e6:	83 c0 08             	add    $0x8,%eax
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	50                   	push   %eax
 6ed:	e8 c9 fe ff ff       	call   5bb <free>
 6f2:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f5:	a1 4c 0a 00 00       	mov    0xa4c,%eax
}
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <malloc>:

void*
malloc(uint nbytes)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	83 c0 07             	add    $0x7,%eax
 708:	c1 e8 03             	shr    $0x3,%eax
 70b:	83 c0 01             	add    $0x1,%eax
 70e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 711:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 716:	89 45 f0             	mov    %eax,-0x10(%ebp)
 719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71d:	75 23                	jne    742 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 71f:	c7 45 f0 44 0a 00 00 	movl   $0xa44,-0x10(%ebp)
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	a3 4c 0a 00 00       	mov    %eax,0xa4c
 72e:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 733:	a3 44 0a 00 00       	mov    %eax,0xa44
    base.s.size = 0;
 738:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 73f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 753:	72 4d                	jb     7a2 <malloc+0xa6>
      if(p->s.size == nunits)
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75e:	75 0c                	jne    76c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8b 10                	mov    (%eax),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	89 10                	mov    %edx,(%eax)
 76a:	eb 26                	jmp    792 <malloc+0x96>
      else {
        p->s.size -= nunits;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	2b 45 ec             	sub    -0x14(%ebp),%eax
 775:	89 c2                	mov    %eax,%edx
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	c1 e0 03             	shl    $0x3,%eax
 786:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	a3 4c 0a 00 00       	mov    %eax,0xa4c
      return (void*)(p + 1);
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	83 c0 08             	add    $0x8,%eax
 7a0:	eb 3b                	jmp    7dd <malloc+0xe1>
    }
    if(p == freep)
 7a2:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 7a7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7aa:	75 1e                	jne    7ca <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	ff 75 ec             	pushl  -0x14(%ebp)
 7b2:	e8 e5 fe ff ff       	call   69c <morecore>
 7b7:	83 c4 10             	add    $0x10,%esp
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <malloc+0xce>
        return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 13                	jmp    7dd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d8:	e9 6d ff ff ff       	jmp    74a <malloc+0x4e>
}
 7dd:	c9                   	leave  
 7de:	c3                   	ret    
