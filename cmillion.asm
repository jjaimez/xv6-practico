
_cmillion:     file format elf32-i386


Disassembly of section .text:

00000000 <fibonacci>:
#include "stat.h"
#include "user.h"

int
fibonacci(int n)
{  
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int r = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (n>2){
   d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  11:	7e 1a                	jle    2d <fibonacci+0x2d>
    r = fibonacci(n-1);
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	83 e8 01             	sub    $0x1,%eax
  19:	83 ec 0c             	sub    $0xc,%esp
  1c:	50                   	push   %eax
  1d:	e8 de ff ff ff       	call   0 <fibonacci>
  22:	83 c4 10             	add    $0x10,%esp
  25:	89 45 f4             	mov    %eax,-0xc(%ebp)

    return r;
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	eb 2c                	jmp    59 <fibonacci+0x59>
  } 
  else if (n==2)       
  2d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  31:	75 07                	jne    3a <fibonacci+0x3a>
    return 1;
  33:	b8 01 00 00 00       	mov    $0x1,%eax
  38:	eb 1f                	jmp    59 <fibonacci+0x59>
  else if (n==1)       
  3a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  3e:	75 07                	jne    47 <fibonacci+0x47>
    return 1;
  40:	b8 01 00 00 00       	mov    $0x1,%eax
  45:	eb 12                	jmp    59 <fibonacci+0x59>
  else if (n==0)
  47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  4b:	75 07                	jne    54 <fibonacci+0x54>
    return 0;
  4d:	b8 00 00 00 00       	mov    $0x0,%eax
  52:	eb 05                	jmp    59 <fibonacci+0x59>
  else
    return -1;          
  54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  59:	c9                   	leave  
  5a:	c3                   	ret    

0000005b <main>:

int
main(int argc, char *argv[])
{
  5b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  5f:	83 e4 f0             	and    $0xfffffff0,%esp
  62:	ff 71 fc             	pushl  -0x4(%ecx)
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	51                   	push   %ecx
  69:	83 ec 04             	sub    $0x4,%esp
  fibonacci(1000);
  6c:	83 ec 0c             	sub    $0xc,%esp
  6f:	68 e8 03 00 00       	push   $0x3e8
  74:	e8 87 ff ff ff       	call   0 <fibonacci>
  79:	83 c4 10             	add    $0x10,%esp
  printf(1,"termino \n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 41 08 00 00       	push   $0x841
  84:	6a 01                	push   $0x1
  86:	e8 02 04 00 00       	call   48d <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  exit();
  8e:	e8 55 02 00 00       	call   2e8 <exit>

00000093 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  96:	57                   	push   %edi
  97:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9b:	8b 55 10             	mov    0x10(%ebp),%edx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	89 cb                	mov    %ecx,%ebx
  a3:	89 df                	mov    %ebx,%edi
  a5:	89 d1                	mov    %edx,%ecx
  a7:	fc                   	cld    
  a8:	f3 aa                	rep stos %al,%es:(%edi)
  aa:	89 ca                	mov    %ecx,%edx
  ac:	89 fb                	mov    %edi,%ebx
  ae:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b4:	5b                   	pop    %ebx
  b5:	5f                   	pop    %edi
  b6:	5d                   	pop    %ebp
  b7:	c3                   	ret    

000000b8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c4:	90                   	nop
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	8d 50 01             	lea    0x1(%eax),%edx
  cb:	89 55 08             	mov    %edx,0x8(%ebp)
  ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  d4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d7:	0f b6 12             	movzbl (%edx),%edx
  da:	88 10                	mov    %dl,(%eax)
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 e2                	jne    c5 <strcpy+0xd>
    ;
  return os;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  eb:	eb 08                	jmp    f5 <strcmp+0xd>
    p++, q++;
  ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	84 c0                	test   %al,%al
  fd:	74 10                	je     10f <strcmp+0x27>
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 10             	movzbl (%eax),%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	38 c2                	cmp    %al,%dl
 10d:	74 de                	je     ed <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	0f b6 d0             	movzbl %al,%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	0f b6 c0             	movzbl %al,%eax
 121:	29 c2                	sub    %eax,%edx
 123:	89 d0                	mov    %edx,%eax
}
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strlen>:

uint
strlen(char *s)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 134:	eb 04                	jmp    13a <strlen+0x13>
 136:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	84 c0                	test   %al,%al
 147:	75 ed                	jne    136 <strlen+0xf>
    ;
  return n;
 149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <memset>:

void*
memset(void *dst, int c, uint n)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 151:	8b 45 10             	mov    0x10(%ebp),%eax
 154:	50                   	push   %eax
 155:	ff 75 0c             	pushl  0xc(%ebp)
 158:	ff 75 08             	pushl  0x8(%ebp)
 15b:	e8 33 ff ff ff       	call   93 <stosb>
 160:	83 c4 0c             	add    $0xc,%esp
  return dst;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 174:	eb 14                	jmp    18a <strchr+0x22>
    if(*s == c)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17f:	75 05                	jne    186 <strchr+0x1e>
      return (char*)s;
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	eb 13                	jmp    199 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	84 c0                	test   %al,%al
 192:	75 e2                	jne    176 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 194:	b8 00 00 00 00       	mov    $0x0,%eax
}
 199:	c9                   	leave  
 19a:	c3                   	ret    

0000019b <gets>:

char*
gets(char *buf, int max)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a8:	eb 44                	jmp    1ee <gets+0x53>
    cc = read(0, &c, 1);
 1aa:	83 ec 04             	sub    $0x4,%esp
 1ad:	6a 01                	push   $0x1
 1af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b2:	50                   	push   %eax
 1b3:	6a 00                	push   $0x0
 1b5:	e8 46 01 00 00       	call   300 <read>
 1ba:	83 c4 10             	add    $0x10,%esp
 1bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c4:	7f 02                	jg     1c8 <gets+0x2d>
      break;
 1c6:	eb 31                	jmp    1f9 <gets+0x5e>
    buf[i++] = c;
 1c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cb:	8d 50 01             	lea    0x1(%eax),%edx
 1ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d1:	89 c2                	mov    %eax,%edx
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 c2                	add    %eax,%edx
 1d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	3c 0a                	cmp    $0xa,%al
 1e4:	74 13                	je     1f9 <gets+0x5e>
 1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ea:	3c 0d                	cmp    $0xd,%al
 1ec:	74 0b                	je     1f9 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f1:	83 c0 01             	add    $0x1,%eax
 1f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f7:	7c b1                	jl     1aa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	01 d0                	add    %edx,%eax
 201:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
}
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <stat>:

int
stat(char *n, struct stat *st)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	6a 00                	push   $0x0
 214:	ff 75 08             	pushl  0x8(%ebp)
 217:	e8 0c 01 00 00       	call   328 <open>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 226:	79 07                	jns    22f <stat+0x26>
    return -1;
 228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22d:	eb 25                	jmp    254 <stat+0x4b>
  r = fstat(fd, st);
 22f:	83 ec 08             	sub    $0x8,%esp
 232:	ff 75 0c             	pushl  0xc(%ebp)
 235:	ff 75 f4             	pushl  -0xc(%ebp)
 238:	e8 03 01 00 00       	call   340 <fstat>
 23d:	83 c4 10             	add    $0x10,%esp
 240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 243:	83 ec 0c             	sub    $0xc,%esp
 246:	ff 75 f4             	pushl  -0xc(%ebp)
 249:	e8 c2 00 00 00       	call   310 <close>
 24e:	83 c4 10             	add    $0x10,%esp
  return r;
 251:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <atoi>:

int
atoi(const char *s)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 263:	eb 25                	jmp    28a <atoi+0x34>
    n = n*10 + *s++ - '0';
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	89 d0                	mov    %edx,%eax
 26a:	c1 e0 02             	shl    $0x2,%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	01 c0                	add    %eax,%eax
 271:	89 c1                	mov    %eax,%ecx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	8d 50 01             	lea    0x1(%eax),%edx
 279:	89 55 08             	mov    %edx,0x8(%ebp)
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	0f be c0             	movsbl %al,%eax
 282:	01 c8                	add    %ecx,%eax
 284:	83 e8 30             	sub    $0x30,%eax
 287:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	3c 2f                	cmp    $0x2f,%al
 292:	7e 0a                	jle    29e <atoi+0x48>
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	3c 39                	cmp    $0x39,%al
 29c:	7e c7                	jle    265 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2af:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b5:	eb 17                	jmp    2ce <memmove+0x2b>
    *dst++ = *src++;
 2b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ba:	8d 50 01             	lea    0x1(%eax),%edx
 2bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c9:	0f b6 12             	movzbl (%edx),%edx
 2cc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	8b 45 10             	mov    0x10(%ebp),%eax
 2d1:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d4:	89 55 10             	mov    %edx,0x10(%ebp)
 2d7:	85 c0                	test   %eax,%eax
 2d9:	7f dc                	jg     2b7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2de:	c9                   	leave  
 2df:	c3                   	ret    

000002e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exit>:
SYSCALL(exit)
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait>:
SYSCALL(wait)
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <pipe>:
SYSCALL(pipe)
 2f8:	b8 04 00 00 00       	mov    $0x4,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <read>:
SYSCALL(read)
 300:	b8 05 00 00 00       	mov    $0x5,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <write>:
SYSCALL(write)
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <close>:
SYSCALL(close)
 310:	b8 15 00 00 00       	mov    $0x15,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <kill>:
SYSCALL(kill)
 318:	b8 06 00 00 00       	mov    $0x6,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <exec>:
SYSCALL(exec)
 320:	b8 07 00 00 00       	mov    $0x7,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <open>:
SYSCALL(open)
 328:	b8 0f 00 00 00       	mov    $0xf,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mknod>:
SYSCALL(mknod)
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <unlink>:
SYSCALL(unlink)
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <fstat>:
SYSCALL(fstat)
 340:	b8 08 00 00 00       	mov    $0x8,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <link>:
SYSCALL(link)
 348:	b8 13 00 00 00       	mov    $0x13,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <mkdir>:
SYSCALL(mkdir)
 350:	b8 14 00 00 00       	mov    $0x14,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <chdir>:
SYSCALL(chdir)
 358:	b8 09 00 00 00       	mov    $0x9,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <dup>:
SYSCALL(dup)
 360:	b8 0a 00 00 00       	mov    $0xa,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getpid>:
SYSCALL(getpid)
 368:	b8 0b 00 00 00       	mov    $0xb,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sbrk>:
SYSCALL(sbrk)
 370:	b8 0c 00 00 00       	mov    $0xc,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <sleep>:
SYSCALL(sleep)
 378:	b8 0d 00 00 00       	mov    $0xd,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <uptime>:
SYSCALL(uptime)
 380:	b8 0e 00 00 00       	mov    $0xe,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <procstat>:
SYSCALL(procstat)
 388:	b8 16 00 00 00       	mov    $0x16,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <set_priority>:
SYSCALL(set_priority)
 390:	b8 17 00 00 00       	mov    $0x17,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <semget>:
SYSCALL(semget)
 398:	b8 18 00 00 00       	mov    $0x18,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <semfree>:
SYSCALL(semfree)
 3a0:	b8 19 00 00 00       	mov    $0x19,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <semdown>:
SYSCALL(semdown)
 3a8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <semup>:
 3b0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	83 ec 18             	sub    $0x18,%esp
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c4:	83 ec 04             	sub    $0x4,%esp
 3c7:	6a 01                	push   $0x1
 3c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3cc:	50                   	push   %eax
 3cd:	ff 75 08             	pushl  0x8(%ebp)
 3d0:	e8 33 ff ff ff       	call   308 <write>
 3d5:	83 c4 10             	add    $0x10,%esp
}
 3d8:	c9                   	leave  
 3d9:	c3                   	ret    

000003da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	53                   	push   %ebx
 3de:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ec:	74 17                	je     405 <printint+0x2b>
 3ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f2:	79 11                	jns    405 <printint+0x2b>
    neg = 1;
 3f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	f7 d8                	neg    %eax
 400:	89 45 ec             	mov    %eax,-0x14(%ebp)
 403:	eb 06                	jmp    40b <printint+0x31>
  } else {
    x = xx;
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 412:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 415:	8d 41 01             	lea    0x1(%ecx),%eax
 418:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 421:	ba 00 00 00 00       	mov    $0x0,%edx
 426:	f7 f3                	div    %ebx
 428:	89 d0                	mov    %edx,%eax
 42a:	0f b6 80 bc 0a 00 00 	movzbl 0xabc(%eax),%eax
 431:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 435:	8b 5d 10             	mov    0x10(%ebp),%ebx
 438:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43b:	ba 00 00 00 00       	mov    $0x0,%edx
 440:	f7 f3                	div    %ebx
 442:	89 45 ec             	mov    %eax,-0x14(%ebp)
 445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 449:	75 c7                	jne    412 <printint+0x38>
  if(neg)
 44b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44f:	74 0e                	je     45f <printint+0x85>
    buf[i++] = '-';
 451:	8b 45 f4             	mov    -0xc(%ebp),%eax
 454:	8d 50 01             	lea    0x1(%eax),%edx
 457:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45f:	eb 1d                	jmp    47e <printint+0xa4>
    putc(fd, buf[i]);
 461:	8d 55 dc             	lea    -0x24(%ebp),%edx
 464:	8b 45 f4             	mov    -0xc(%ebp),%eax
 467:	01 d0                	add    %edx,%eax
 469:	0f b6 00             	movzbl (%eax),%eax
 46c:	0f be c0             	movsbl %al,%eax
 46f:	83 ec 08             	sub    $0x8,%esp
 472:	50                   	push   %eax
 473:	ff 75 08             	pushl  0x8(%ebp)
 476:	e8 3d ff ff ff       	call   3b8 <putc>
 47b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 486:	79 d9                	jns    461 <printint+0x87>
    putc(fd, buf[i]);
}
 488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 493:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49a:	8d 45 0c             	lea    0xc(%ebp),%eax
 49d:	83 c0 04             	add    $0x4,%eax
 4a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4aa:	e9 59 01 00 00       	jmp    608 <printf+0x17b>
    c = fmt[i] & 0xff;
 4af:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	25 ff 00 00 00       	and    $0xff,%eax
 4c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c9:	75 2c                	jne    4f7 <printf+0x6a>
      if(c == '%'){
 4cb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4cf:	75 0c                	jne    4dd <printf+0x50>
        state = '%';
 4d1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d8:	e9 27 01 00 00       	jmp    604 <printf+0x177>
      } else {
        putc(fd, c);
 4dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e0:	0f be c0             	movsbl %al,%eax
 4e3:	83 ec 08             	sub    $0x8,%esp
 4e6:	50                   	push   %eax
 4e7:	ff 75 08             	pushl  0x8(%ebp)
 4ea:	e8 c9 fe ff ff       	call   3b8 <putc>
 4ef:	83 c4 10             	add    $0x10,%esp
 4f2:	e9 0d 01 00 00       	jmp    604 <printf+0x177>
      }
    } else if(state == '%'){
 4f7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fb:	0f 85 03 01 00 00    	jne    604 <printf+0x177>
      if(c == 'd'){
 501:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 505:	75 1e                	jne    525 <printf+0x98>
        printint(fd, *ap, 10, 1);
 507:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50a:	8b 00                	mov    (%eax),%eax
 50c:	6a 01                	push   $0x1
 50e:	6a 0a                	push   $0xa
 510:	50                   	push   %eax
 511:	ff 75 08             	pushl  0x8(%ebp)
 514:	e8 c1 fe ff ff       	call   3da <printint>
 519:	83 c4 10             	add    $0x10,%esp
        ap++;
 51c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 520:	e9 d8 00 00 00       	jmp    5fd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 525:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 529:	74 06                	je     531 <printf+0xa4>
 52b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52f:	75 1e                	jne    54f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	6a 00                	push   $0x0
 538:	6a 10                	push   $0x10
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 97 fe ff ff       	call   3da <printint>
 543:	83 c4 10             	add    $0x10,%esp
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	e9 ae 00 00 00       	jmp    5fd <printf+0x170>
      } else if(c == 's'){
 54f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 553:	75 43                	jne    598 <printf+0x10b>
        s = (char*)*ap;
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 565:	75 07                	jne    56e <printf+0xe1>
          s = "(null)";
 567:	c7 45 f4 4b 08 00 00 	movl   $0x84b,-0xc(%ebp)
        while(*s != 0){
 56e:	eb 1c                	jmp    58c <printf+0xff>
          putc(fd, *s);
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 33 fe ff ff       	call   3b8 <putc>
 585:	83 c4 10             	add    $0x10,%esp
          s++;
 588:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	84 c0                	test   %al,%al
 594:	75 da                	jne    570 <printf+0xe3>
 596:	eb 65                	jmp    5fd <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 598:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59c:	75 1d                	jne    5bb <printf+0x12e>
        putc(fd, *ap);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 06 fe ff ff       	call   3b8 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b9:	eb 42                	jmp    5fd <printf+0x170>
      } else if(c == '%'){
 5bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bf:	75 17                	jne    5d8 <printf+0x14b>
        putc(fd, c);
 5c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	50                   	push   %eax
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 e5 fd ff ff       	call   3b8 <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
 5d6:	eb 25                	jmp    5fd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	6a 25                	push   $0x25
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 d3 fd ff ff       	call   3b8 <putc>
 5e5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 be fd ff ff       	call   3b8 <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 604:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	84 c0                	test   %al,%al
 615:	0f 85 94 fe ff ff    	jne    4af <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61b:	c9                   	leave  
 61c:	c3                   	ret    

0000061d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61d:	55                   	push   %ebp
 61e:	89 e5                	mov    %esp,%ebp
 620:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	83 e8 08             	sub    $0x8,%eax
 629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	a1 d8 0a 00 00       	mov    0xad8,%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	eb 24                	jmp    65a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63e:	77 12                	ja     652 <free+0x35>
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 646:	77 24                	ja     66c <free+0x4f>
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 650:	77 1a                	ja     66c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	76 d4                	jbe    636 <free+0x19>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	76 ca                	jbe    636 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 c2                	cmp    %eax,%edx
 685:	75 24                	jne    6ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	01 c2                	add    %eax,%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 0a                	jmp    6b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	01 d0                	add    %edx,%eax
 6c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ca:	75 20                	jne    6ec <free+0xcf>
    p->s.size += bp->s.size;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 50 04             	mov    0x4(%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 10                	mov    (%eax),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 10                	mov    %edx,(%eax)
 6ea:	eb 08                	jmp    6f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	a3 d8 0a 00 00       	mov    %eax,0xad8
}
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <morecore>:

static Header*
morecore(uint nu)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 704:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70b:	77 07                	ja     714 <morecore+0x16>
    nu = 4096;
 70d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	c1 e0 03             	shl    $0x3,%eax
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	50                   	push   %eax
 71e:	e8 4d fc ff ff       	call   370 <sbrk>
 723:	83 c4 10             	add    $0x10,%esp
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 729:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72d:	75 07                	jne    736 <morecore+0x38>
    return 0;
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	eb 26                	jmp    75c <morecore+0x5e>
  hp = (Header*)p;
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	8b 55 08             	mov    0x8(%ebp),%edx
 742:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	83 c0 08             	add    $0x8,%eax
 74b:	83 ec 0c             	sub    $0xc,%esp
 74e:	50                   	push   %eax
 74f:	e8 c9 fe ff ff       	call   61d <free>
 754:	83 c4 10             	add    $0x10,%esp
  return freep;
 757:	a1 d8 0a 00 00       	mov    0xad8,%eax
}
 75c:	c9                   	leave  
 75d:	c3                   	ret    

0000075e <malloc>:

void*
malloc(uint nbytes)
{
 75e:	55                   	push   %ebp
 75f:	89 e5                	mov    %esp,%ebp
 761:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	83 c0 07             	add    $0x7,%eax
 76a:	c1 e8 03             	shr    $0x3,%eax
 76d:	83 c0 01             	add    $0x1,%eax
 770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 773:	a1 d8 0a 00 00       	mov    0xad8,%eax
 778:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77f:	75 23                	jne    7a4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 781:	c7 45 f0 d0 0a 00 00 	movl   $0xad0,-0x10(%ebp)
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	a3 d8 0a 00 00       	mov    %eax,0xad8
 790:	a1 d8 0a 00 00       	mov    0xad8,%eax
 795:	a3 d0 0a 00 00       	mov    %eax,0xad0
    base.s.size = 0;
 79a:	c7 05 d4 0a 00 00 00 	movl   $0x0,0xad4
 7a1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b5:	72 4d                	jb     804 <malloc+0xa6>
      if(p->s.size == nunits)
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c0:	75 0c                	jne    7ce <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
 7cc:	eb 26                	jmp    7f4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d7:	89 c2                	mov    %eax,%edx
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	c1 e0 03             	shl    $0x3,%eax
 7e8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 d8 0a 00 00       	mov    %eax,0xad8
      return (void*)(p + 1);
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	83 c0 08             	add    $0x8,%eax
 802:	eb 3b                	jmp    83f <malloc+0xe1>
    }
    if(p == freep)
 804:	a1 d8 0a 00 00       	mov    0xad8,%eax
 809:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80c:	75 1e                	jne    82c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80e:	83 ec 0c             	sub    $0xc,%esp
 811:	ff 75 ec             	pushl  -0x14(%ebp)
 814:	e8 e5 fe ff ff       	call   6fe <morecore>
 819:	83 c4 10             	add    $0x10,%esp
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 823:	75 07                	jne    82c <malloc+0xce>
        return 0;
 825:	b8 00 00 00 00       	mov    $0x0,%eax
 82a:	eb 13                	jmp    83f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 00                	mov    (%eax),%eax
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83a:	e9 6d ff ff ff       	jmp    7ac <malloc+0x4e>
}
 83f:	c9                   	leave  
 840:	c3                   	ret    
