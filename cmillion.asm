
_cmillion:     file format elf32-i386


Disassembly of section .text:

00000000 <fibonacci>:



int
fibonacci(int n)
{  
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  int r = 0;
   7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (n>2){
   e:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  12:	7e 30                	jle    44 <fibonacci+0x44>
    r = fibonacci(n-1) + fibonacci(n-2);
  14:	8b 45 08             	mov    0x8(%ebp),%eax
  17:	83 e8 01             	sub    $0x1,%eax
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	50                   	push   %eax
  1e:	e8 dd ff ff ff       	call   0 <fibonacci>
  23:	83 c4 10             	add    $0x10,%esp
  26:	89 c3                	mov    %eax,%ebx
  28:	8b 45 08             	mov    0x8(%ebp),%eax
  2b:	83 e8 02             	sub    $0x2,%eax
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	50                   	push   %eax
  32:	e8 c9 ff ff ff       	call   0 <fibonacci>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	01 d8                	add    %ebx,%eax
  3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return r;
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	eb 2c                	jmp    70 <fibonacci+0x70>
  } 
  else if (n==2)       
  44:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  48:	75 07                	jne    51 <fibonacci+0x51>
    return 1;
  4a:	b8 01 00 00 00       	mov    $0x1,%eax
  4f:	eb 1f                	jmp    70 <fibonacci+0x70>
  else if (n==1)       
  51:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  55:	75 07                	jne    5e <fibonacci+0x5e>
    return 1;
  57:	b8 01 00 00 00       	mov    $0x1,%eax
  5c:	eb 12                	jmp    70 <fibonacci+0x70>
  else if (n==0)
  5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  62:	75 07                	jne    6b <fibonacci+0x6b>
    return 0;
  64:	b8 00 00 00 00       	mov    $0x0,%eax
  69:	eb 05                	jmp    70 <fibonacci+0x70>
  else
    return -1;          
  6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  73:	c9                   	leave  
  74:	c3                   	ret    

00000075 <main>:

int
main(int argc, char *argv[])
{
  75:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  79:	83 e4 f0             	and    $0xfffffff0,%esp
  7c:	ff 71 fc             	pushl  -0x4(%ecx)
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  82:	51                   	push   %ecx
  83:	83 ec 04             	sub    $0x4,%esp
  fibonacci(100);
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	6a 64                	push   $0x64
  8b:	e8 70 ff ff ff       	call   0 <fibonacci>
  90:	83 c4 10             	add    $0x10,%esp
  printf(1,"termino \n");
  93:	83 ec 08             	sub    $0x8,%esp
  96:	68 58 08 00 00       	push   $0x858
  9b:	6a 01                	push   $0x1
  9d:	e8 02 04 00 00       	call   4a4 <printf>
  a2:	83 c4 10             	add    $0x10,%esp
  exit();
  a5:	e8 55 02 00 00       	call   2ff <exit>

000000aa <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  aa:	55                   	push   %ebp
  ab:	89 e5                	mov    %esp,%ebp
  ad:	57                   	push   %edi
  ae:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b2:	8b 55 10             	mov    0x10(%ebp),%edx
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	89 cb                	mov    %ecx,%ebx
  ba:	89 df                	mov    %ebx,%edi
  bc:	89 d1                	mov    %edx,%ecx
  be:	fc                   	cld    
  bf:	f3 aa                	rep stos %al,%es:(%edi)
  c1:	89 ca                	mov    %ecx,%edx
  c3:	89 fb                	mov    %edi,%ebx
  c5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  cb:	5b                   	pop    %ebx
  cc:	5f                   	pop    %edi
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  db:	90                   	nop
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	8d 50 01             	lea    0x1(%eax),%edx
  e2:	89 55 08             	mov    %edx,0x8(%ebp)
  e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  eb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ee:	0f b6 12             	movzbl (%edx),%edx
  f1:	88 10                	mov    %dl,(%eax)
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	84 c0                	test   %al,%al
  f8:	75 e2                	jne    dc <strcpy+0xd>
    ;
  return os;
  fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fd:	c9                   	leave  
  fe:	c3                   	ret    

000000ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 102:	eb 08                	jmp    10c <strcmp+0xd>
    p++, q++;
 104:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 108:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	84 c0                	test   %al,%al
 114:	74 10                	je     126 <strcmp+0x27>
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	0f b6 10             	movzbl (%eax),%edx
 11c:	8b 45 0c             	mov    0xc(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	38 c2                	cmp    %al,%dl
 124:	74 de                	je     104 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	0f b6 d0             	movzbl %al,%edx
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	0f b6 c0             	movzbl %al,%eax
 138:	29 c2                	sub    %eax,%edx
 13a:	89 d0                	mov    %edx,%eax
}
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    

0000013e <strlen>:

uint
strlen(char *s)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14b:	eb 04                	jmp    151 <strlen+0x13>
 14d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 151:	8b 55 fc             	mov    -0x4(%ebp),%edx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	01 d0                	add    %edx,%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 ed                	jne    14d <strlen+0xf>
    ;
  return n;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <memset>:

void*
memset(void *dst, int c, uint n)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 168:	8b 45 10             	mov    0x10(%ebp),%eax
 16b:	50                   	push   %eax
 16c:	ff 75 0c             	pushl  0xc(%ebp)
 16f:	ff 75 08             	pushl  0x8(%ebp)
 172:	e8 33 ff ff ff       	call   aa <stosb>
 177:	83 c4 0c             	add    $0xc,%esp
  return dst;
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17d:	c9                   	leave  
 17e:	c3                   	ret    

0000017f <strchr>:

char*
strchr(const char *s, char c)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	83 ec 04             	sub    $0x4,%esp
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18b:	eb 14                	jmp    1a1 <strchr+0x22>
    if(*s == c)
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	3a 45 fc             	cmp    -0x4(%ebp),%al
 196:	75 05                	jne    19d <strchr+0x1e>
      return (char*)s;
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	eb 13                	jmp    1b0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	84 c0                	test   %al,%al
 1a9:	75 e2                	jne    18d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b0:	c9                   	leave  
 1b1:	c3                   	ret    

000001b2 <gets>:

char*
gets(char *buf, int max)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1bf:	eb 44                	jmp    205 <gets+0x53>
    cc = read(0, &c, 1);
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	6a 01                	push   $0x1
 1c6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c9:	50                   	push   %eax
 1ca:	6a 00                	push   $0x0
 1cc:	e8 46 01 00 00       	call   317 <read>
 1d1:	83 c4 10             	add    $0x10,%esp
 1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1db:	7f 02                	jg     1df <gets+0x2d>
      break;
 1dd:	eb 31                	jmp    210 <gets+0x5e>
    buf[i++] = c;
 1df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e2:	8d 50 01             	lea    0x1(%eax),%edx
 1e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e8:	89 c2                	mov    %eax,%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 c2                	add    %eax,%edx
 1ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f9:	3c 0a                	cmp    $0xa,%al
 1fb:	74 13                	je     210 <gets+0x5e>
 1fd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 201:	3c 0d                	cmp    $0xd,%al
 203:	74 0b                	je     210 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 205:	8b 45 f4             	mov    -0xc(%ebp),%eax
 208:	83 c0 01             	add    $0x1,%eax
 20b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20e:	7c b1                	jl     1c1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 210:	8b 55 f4             	mov    -0xc(%ebp),%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	01 d0                	add    %edx,%eax
 218:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	83 ec 08             	sub    $0x8,%esp
 229:	6a 00                	push   $0x0
 22b:	ff 75 08             	pushl  0x8(%ebp)
 22e:	e8 0c 01 00 00       	call   33f <open>
 233:	83 c4 10             	add    $0x10,%esp
 236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23d:	79 07                	jns    246 <stat+0x26>
    return -1;
 23f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 244:	eb 25                	jmp    26b <stat+0x4b>
  r = fstat(fd, st);
 246:	83 ec 08             	sub    $0x8,%esp
 249:	ff 75 0c             	pushl  0xc(%ebp)
 24c:	ff 75 f4             	pushl  -0xc(%ebp)
 24f:	e8 03 01 00 00       	call   357 <fstat>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25a:	83 ec 0c             	sub    $0xc,%esp
 25d:	ff 75 f4             	pushl  -0xc(%ebp)
 260:	e8 c2 00 00 00       	call   327 <close>
 265:	83 c4 10             	add    $0x10,%esp
  return r;
 268:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <atoi>:

int
atoi(const char *s)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 27a:	eb 25                	jmp    2a1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 27c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27f:	89 d0                	mov    %edx,%eax
 281:	c1 e0 02             	shl    $0x2,%eax
 284:	01 d0                	add    %edx,%eax
 286:	01 c0                	add    %eax,%eax
 288:	89 c1                	mov    %eax,%ecx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	8d 50 01             	lea    0x1(%eax),%edx
 290:	89 55 08             	mov    %edx,0x8(%ebp)
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	0f be c0             	movsbl %al,%eax
 299:	01 c8                	add    %ecx,%eax
 29b:	83 e8 30             	sub    $0x30,%eax
 29e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3c 2f                	cmp    $0x2f,%al
 2a9:	7e 0a                	jle    2b5 <atoi+0x48>
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	0f b6 00             	movzbl (%eax),%eax
 2b1:	3c 39                	cmp    $0x39,%al
 2b3:	7e c7                	jle    27c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2cc:	eb 17                	jmp    2e5 <memmove+0x2b>
    *dst++ = *src++;
 2ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d1:	8d 50 01             	lea    0x1(%eax),%edx
 2d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2da:	8d 4a 01             	lea    0x1(%edx),%ecx
 2dd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e0:	0f b6 12             	movzbl (%edx),%edx
 2e3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e5:	8b 45 10             	mov    0x10(%ebp),%eax
 2e8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2eb:	89 55 10             	mov    %edx,0x10(%ebp)
 2ee:	85 c0                	test   %eax,%eax
 2f0:	7f dc                	jg     2ce <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f5:	c9                   	leave  
 2f6:	c3                   	ret    

000002f7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f7:	b8 01 00 00 00       	mov    $0x1,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exit>:
SYSCALL(exit)
 2ff:	b8 02 00 00 00       	mov    $0x2,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <wait>:
SYSCALL(wait)
 307:	b8 03 00 00 00       	mov    $0x3,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <pipe>:
SYSCALL(pipe)
 30f:	b8 04 00 00 00       	mov    $0x4,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <read>:
SYSCALL(read)
 317:	b8 05 00 00 00       	mov    $0x5,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <write>:
SYSCALL(write)
 31f:	b8 10 00 00 00       	mov    $0x10,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <close>:
SYSCALL(close)
 327:	b8 15 00 00 00       	mov    $0x15,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <kill>:
SYSCALL(kill)
 32f:	b8 06 00 00 00       	mov    $0x6,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <exec>:
SYSCALL(exec)
 337:	b8 07 00 00 00       	mov    $0x7,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <open>:
SYSCALL(open)
 33f:	b8 0f 00 00 00       	mov    $0xf,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <mknod>:
SYSCALL(mknod)
 347:	b8 11 00 00 00       	mov    $0x11,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <unlink>:
SYSCALL(unlink)
 34f:	b8 12 00 00 00       	mov    $0x12,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <fstat>:
SYSCALL(fstat)
 357:	b8 08 00 00 00       	mov    $0x8,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <link>:
SYSCALL(link)
 35f:	b8 13 00 00 00       	mov    $0x13,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <mkdir>:
SYSCALL(mkdir)
 367:	b8 14 00 00 00       	mov    $0x14,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <chdir>:
SYSCALL(chdir)
 36f:	b8 09 00 00 00       	mov    $0x9,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <dup>:
SYSCALL(dup)
 377:	b8 0a 00 00 00       	mov    $0xa,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <getpid>:
SYSCALL(getpid)
 37f:	b8 0b 00 00 00       	mov    $0xb,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <sbrk>:
SYSCALL(sbrk)
 387:	b8 0c 00 00 00       	mov    $0xc,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <sleep>:
SYSCALL(sleep)
 38f:	b8 0d 00 00 00       	mov    $0xd,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <uptime>:
SYSCALL(uptime)
 397:	b8 0e 00 00 00       	mov    $0xe,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <procstat>:
SYSCALL(procstat)
 39f:	b8 16 00 00 00       	mov    $0x16,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <set_priority>:
SYSCALL(set_priority)
 3a7:	b8 17 00 00 00       	mov    $0x17,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <semget>:
SYSCALL(semget)
 3af:	b8 18 00 00 00       	mov    $0x18,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <semfree>:
SYSCALL(semfree)
 3b7:	b8 19 00 00 00       	mov    $0x19,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <semdown>:
SYSCALL(semdown)
 3bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <semup>:
 3c7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 18             	sub    $0x18,%esp
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3db:	83 ec 04             	sub    $0x4,%esp
 3de:	6a 01                	push   $0x1
 3e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e3:	50                   	push   %eax
 3e4:	ff 75 08             	pushl  0x8(%ebp)
 3e7:	e8 33 ff ff ff       	call   31f <write>
 3ec:	83 c4 10             	add    $0x10,%esp
}
 3ef:	c9                   	leave  
 3f0:	c3                   	ret    

000003f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f1:	55                   	push   %ebp
 3f2:	89 e5                	mov    %esp,%ebp
 3f4:	53                   	push   %ebx
 3f5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 403:	74 17                	je     41c <printint+0x2b>
 405:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 409:	79 11                	jns    41c <printint+0x2b>
    neg = 1;
 40b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	f7 d8                	neg    %eax
 417:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41a:	eb 06                	jmp    422 <printint+0x31>
  } else {
    x = xx;
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 429:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42c:	8d 41 01             	lea    0x1(%ecx),%eax
 42f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 432:	8b 5d 10             	mov    0x10(%ebp),%ebx
 435:	8b 45 ec             	mov    -0x14(%ebp),%eax
 438:	ba 00 00 00 00       	mov    $0x0,%edx
 43d:	f7 f3                	div    %ebx
 43f:	89 d0                	mov    %edx,%eax
 441:	0f b6 80 d8 0a 00 00 	movzbl 0xad8(%eax),%eax
 448:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 452:	ba 00 00 00 00       	mov    $0x0,%edx
 457:	f7 f3                	div    %ebx
 459:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 460:	75 c7                	jne    429 <printint+0x38>
  if(neg)
 462:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 466:	74 0e                	je     476 <printint+0x85>
    buf[i++] = '-';
 468:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46b:	8d 50 01             	lea    0x1(%eax),%edx
 46e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 471:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 476:	eb 1d                	jmp    495 <printint+0xa4>
    putc(fd, buf[i]);
 478:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	01 d0                	add    %edx,%eax
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	0f be c0             	movsbl %al,%eax
 486:	83 ec 08             	sub    $0x8,%esp
 489:	50                   	push   %eax
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 3d ff ff ff       	call   3cf <putc>
 492:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 495:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49d:	79 d9                	jns    478 <printint+0x87>
    putc(fd, buf[i]);
}
 49f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b4:	83 c0 04             	add    $0x4,%eax
 4b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c1:	e9 59 01 00 00       	jmp    61f <printf+0x17b>
    c = fmt[i] & 0xff;
 4c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	25 ff 00 00 00       	and    $0xff,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e0:	75 2c                	jne    50e <printf+0x6a>
      if(c == '%'){
 4e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e6:	75 0c                	jne    4f4 <printf+0x50>
        state = '%';
 4e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ef:	e9 27 01 00 00       	jmp    61b <printf+0x177>
      } else {
        putc(fd, c);
 4f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	83 ec 08             	sub    $0x8,%esp
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 c9 fe ff ff       	call   3cf <putc>
 506:	83 c4 10             	add    $0x10,%esp
 509:	e9 0d 01 00 00       	jmp    61b <printf+0x177>
      }
    } else if(state == '%'){
 50e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 512:	0f 85 03 01 00 00    	jne    61b <printf+0x177>
      if(c == 'd'){
 518:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0x98>
        printint(fd, *ap, 10, 1);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 01                	push   $0x1
 525:	6a 0a                	push   $0xa
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 c1 fe ff ff       	call   3f1 <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 d8 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 540:	74 06                	je     548 <printf+0xa4>
 542:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 546:	75 1e                	jne    566 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	6a 00                	push   $0x0
 54f:	6a 10                	push   $0x10
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	e8 97 fe ff ff       	call   3f1 <printint>
 55a:	83 c4 10             	add    $0x10,%esp
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 561:	e9 ae 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 's'){
 566:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56a:	75 43                	jne    5af <printf+0x10b>
        s = (char*)*ap;
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57c:	75 07                	jne    585 <printf+0xe1>
          s = "(null)";
 57e:	c7 45 f4 62 08 00 00 	movl   $0x862,-0xc(%ebp)
        while(*s != 0){
 585:	eb 1c                	jmp    5a3 <printf+0xff>
          putc(fd, *s);
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 33 fe ff ff       	call   3cf <putc>
 59c:	83 c4 10             	add    $0x10,%esp
          s++;
 59f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	84 c0                	test   %al,%al
 5ab:	75 da                	jne    587 <printf+0xe3>
 5ad:	eb 65                	jmp    614 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b3:	75 1d                	jne    5d2 <printf+0x12e>
        putc(fd, *ap);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 06 fe ff ff       	call   3cf <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d0:	eb 42                	jmp    614 <printf+0x170>
      } else if(c == '%'){
 5d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d6:	75 17                	jne    5ef <printf+0x14b>
        putc(fd, c);
 5d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	83 ec 08             	sub    $0x8,%esp
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 e5 fd ff ff       	call   3cf <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
 5ed:	eb 25                	jmp    614 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	6a 25                	push   $0x25
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 d3 fd ff ff       	call   3cf <putc>
 5fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 602:	0f be c0             	movsbl %al,%eax
 605:	83 ec 08             	sub    $0x8,%esp
 608:	50                   	push   %eax
 609:	ff 75 08             	pushl  0x8(%ebp)
 60c:	e8 be fd ff ff       	call   3cf <putc>
 611:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61f:	8b 55 0c             	mov    0xc(%ebp),%edx
 622:	8b 45 f0             	mov    -0x10(%ebp),%eax
 625:	01 d0                	add    %edx,%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	0f 85 94 fe ff ff    	jne    4c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 632:	c9                   	leave  
 633:	c3                   	ret    

00000634 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	83 e8 08             	sub    $0x8,%eax
 640:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 648:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64b:	eb 24                	jmp    671 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	77 12                	ja     669 <free+0x35>
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65d:	77 24                	ja     683 <free+0x4f>
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 667:	77 1a                	ja     683 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 677:	76 d4                	jbe    64d <free+0x19>
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 681:	76 ca                	jbe    64d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	01 c2                	add    %eax,%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	39 c2                	cmp    %eax,%edx
 69c:	75 24                	jne    6c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	8b 40 04             	mov    0x4(%eax),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
 6c0:	eb 0a                	jmp    6cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	01 d0                	add    %edx,%eax
 6de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e1:	75 20                	jne    703 <free+0xcf>
    p->s.size += bp->s.size;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 50 04             	mov    0x4(%eax),%edx
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	8b 40 04             	mov    0x4(%eax),%eax
 6ef:	01 c2                	add    %eax,%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 10                	mov    (%eax),%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	89 10                	mov    %edx,(%eax)
 701:	eb 08                	jmp    70b <free+0xd7>
  } else
    p->s.ptr = bp;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 55 f8             	mov    -0x8(%ebp),%edx
 709:	89 10                	mov    %edx,(%eax)
  freep = p;
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	a3 f4 0a 00 00       	mov    %eax,0xaf4
}
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <morecore>:

static Header*
morecore(uint nu)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 722:	77 07                	ja     72b <morecore+0x16>
    nu = 4096;
 724:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	c1 e0 03             	shl    $0x3,%eax
 731:	83 ec 0c             	sub    $0xc,%esp
 734:	50                   	push   %eax
 735:	e8 4d fc ff ff       	call   387 <sbrk>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 740:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 744:	75 07                	jne    74d <morecore+0x38>
    return 0;
 746:	b8 00 00 00 00       	mov    $0x0,%eax
 74b:	eb 26                	jmp    773 <morecore+0x5e>
  hp = (Header*)p;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	8b 55 08             	mov    0x8(%ebp),%edx
 759:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	83 c0 08             	add    $0x8,%eax
 762:	83 ec 0c             	sub    $0xc,%esp
 765:	50                   	push   %eax
 766:	e8 c9 fe ff ff       	call   634 <free>
 76b:	83 c4 10             	add    $0x10,%esp
  return freep;
 76e:	a1 f4 0a 00 00       	mov    0xaf4,%eax
}
 773:	c9                   	leave  
 774:	c3                   	ret    

00000775 <malloc>:

void*
malloc(uint nbytes)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
 77e:	83 c0 07             	add    $0x7,%eax
 781:	c1 e8 03             	shr    $0x3,%eax
 784:	83 c0 01             	add    $0x1,%eax
 787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78a:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 78f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 796:	75 23                	jne    7bb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 798:	c7 45 f0 ec 0a 00 00 	movl   $0xaec,-0x10(%ebp)
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	a3 f4 0a 00 00       	mov    %eax,0xaf4
 7a7:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 7ac:	a3 ec 0a 00 00       	mov    %eax,0xaec
    base.s.size = 0;
 7b1:	c7 05 f0 0a 00 00 00 	movl   $0x0,0xaf0
 7b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cc:	72 4d                	jb     81b <malloc+0xa6>
      if(p->s.size == nunits)
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d7:	75 0c                	jne    7e5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 26                	jmp    80b <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ee:	89 c2                	mov    %eax,%edx
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	c1 e0 03             	shl    $0x3,%eax
 7ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 55 ec             	mov    -0x14(%ebp),%edx
 808:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	a3 f4 0a 00 00       	mov    %eax,0xaf4
      return (void*)(p + 1);
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	83 c0 08             	add    $0x8,%eax
 819:	eb 3b                	jmp    856 <malloc+0xe1>
    }
    if(p == freep)
 81b:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 820:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 823:	75 1e                	jne    843 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 825:	83 ec 0c             	sub    $0xc,%esp
 828:	ff 75 ec             	pushl  -0x14(%ebp)
 82b:	e8 e5 fe ff ff       	call   715 <morecore>
 830:	83 c4 10             	add    $0x10,%esp
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
 836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83a:	75 07                	jne    843 <malloc+0xce>
        return 0;
 83c:	b8 00 00 00 00       	mov    $0x0,%eax
 841:	eb 13                	jmp    856 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 45 f0             	mov    %eax,-0x10(%ebp)
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 851:	e9 6d ff ff ff       	jmp    7c3 <malloc+0x4e>
}
 856:	c9                   	leave  
 857:	c3                   	ret    
