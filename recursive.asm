
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
  45:	e8 d8 02 00 00       	call   322 <fork>
  4a:	85 c0                	test   %eax,%eax
  4c:	75 27                	jne    75 <main+0x41>
    recursive(250);
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	68 fa 00 00 00       	push   $0xfa
  56:	e8 a5 ff ff ff       	call   0 <recursive>
  5b:	83 c4 10             	add    $0x10,%esp
    printf(1,"finish 1 \n");
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	68 84 08 00 00       	push   $0x884
  66:	6a 01                	push   $0x1
  68:	e8 62 04 00 00       	call   4cf <printf>
  6d:	83 c4 10             	add    $0x10,%esp
    exit();
  70:	e8 b5 02 00 00       	call   32a <exit>
  } else {
  wait();
  75:	e8 b8 02 00 00       	call   332 <wait>
  recursive(250);
  7a:	83 ec 0c             	sub    $0xc,%esp
  7d:	68 fa 00 00 00       	push   $0xfa
  82:	e8 79 ff ff ff       	call   0 <recursive>
  87:	83 c4 10             	add    $0x10,%esp
  printf(1,"finish 2 \n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 8f 08 00 00       	push   $0x88f
  92:	6a 01                	push   $0x1
  94:	e8 36 04 00 00       	call   4cf <printf>
  99:	83 c4 10             	add    $0x10,%esp
  printf(1,"the next execution maybe not work (trap 14) \n");
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	68 9c 08 00 00       	push   $0x89c
  a4:	6a 01                	push   $0x1
  a6:	e8 24 04 00 00       	call   4cf <printf>
  ab:	83 c4 10             	add    $0x10,%esp
  recursive(500);
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	68 f4 01 00 00       	push   $0x1f4
  b6:	e8 45 ff ff ff       	call   0 <recursive>
  bb:	83 c4 10             	add    $0x10,%esp
  printf(1,"finish 3 \n");
  be:	83 ec 08             	sub    $0x8,%esp
  c1:	68 ca 08 00 00       	push   $0x8ca
  c6:	6a 01                	push   $0x1
  c8:	e8 02 04 00 00       	call   4cf <printf>
  cd:	83 c4 10             	add    $0x10,%esp
  exit();
  d0:	e8 55 02 00 00       	call   32a <exit>

000000d5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	57                   	push   %edi
  d9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  dd:	8b 55 10             	mov    0x10(%ebp),%edx
  e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  e3:	89 cb                	mov    %ecx,%ebx
  e5:	89 df                	mov    %ebx,%edi
  e7:	89 d1                	mov    %edx,%ecx
  e9:	fc                   	cld    
  ea:	f3 aa                	rep stos %al,%es:(%edi)
  ec:	89 ca                	mov    %ecx,%edx
  ee:	89 fb                	mov    %edi,%ebx
  f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f6:	5b                   	pop    %ebx
  f7:	5f                   	pop    %edi
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 106:	90                   	nop
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8d 50 01             	lea    0x1(%eax),%edx
 10d:	89 55 08             	mov    %edx,0x8(%ebp)
 110:	8b 55 0c             	mov    0xc(%ebp),%edx
 113:	8d 4a 01             	lea    0x1(%edx),%ecx
 116:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 119:	0f b6 12             	movzbl (%edx),%edx
 11c:	88 10                	mov    %dl,(%eax)
 11e:	0f b6 00             	movzbl (%eax),%eax
 121:	84 c0                	test   %al,%al
 123:	75 e2                	jne    107 <strcpy+0xd>
    ;
  return os;
 125:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 128:	c9                   	leave  
 129:	c3                   	ret    

0000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12d:	eb 08                	jmp    137 <strcmp+0xd>
    p++, q++;
 12f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 133:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	84 c0                	test   %al,%al
 13f:	74 10                	je     151 <strcmp+0x27>
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 10             	movzbl (%eax),%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	0f b6 00             	movzbl (%eax),%eax
 14d:	38 c2                	cmp    %al,%dl
 14f:	74 de                	je     12f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	0f b6 d0             	movzbl %al,%edx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	0f b6 c0             	movzbl %al,%eax
 163:	29 c2                	sub    %eax,%edx
 165:	89 d0                	mov    %edx,%eax
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    

00000169 <strlen>:

uint
strlen(char *s)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 16f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 176:	eb 04                	jmp    17c <strlen+0x13>
 178:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 17c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	01 d0                	add    %edx,%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 ed                	jne    178 <strlen+0xf>
    ;
  return n;
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 193:	8b 45 10             	mov    0x10(%ebp),%eax
 196:	50                   	push   %eax
 197:	ff 75 0c             	pushl  0xc(%ebp)
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	e8 33 ff ff ff       	call   d5 <stosb>
 1a2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a8:	c9                   	leave  
 1a9:	c3                   	ret    

000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	83 ec 04             	sub    $0x4,%esp
 1b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b6:	eb 14                	jmp    1cc <strchr+0x22>
    if(*s == c)
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c1:	75 05                	jne    1c8 <strchr+0x1e>
      return (char*)s;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	eb 13                	jmp    1db <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	84 c0                	test   %al,%al
 1d4:	75 e2                	jne    1b8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <gets>:

char*
gets(char *buf, int max)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ea:	eb 44                	jmp    230 <gets+0x53>
    cc = read(0, &c, 1);
 1ec:	83 ec 04             	sub    $0x4,%esp
 1ef:	6a 01                	push   $0x1
 1f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f4:	50                   	push   %eax
 1f5:	6a 00                	push   $0x0
 1f7:	e8 46 01 00 00       	call   342 <read>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 206:	7f 02                	jg     20a <gets+0x2d>
      break;
 208:	eb 31                	jmp    23b <gets+0x5e>
    buf[i++] = c;
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 f4             	mov    %edx,-0xc(%ebp)
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 13                	je     23b <gets+0x5e>
 228:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22c:	3c 0d                	cmp    $0xd,%al
 22e:	74 0b                	je     23b <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	83 c0 01             	add    $0x1,%eax
 236:	3b 45 0c             	cmp    0xc(%ebp),%eax
 239:	7c b1                	jl     1ec <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 d0                	add    %edx,%eax
 243:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 246:	8b 45 08             	mov    0x8(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <stat>:

int
stat(char *n, struct stat *st)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 251:	83 ec 08             	sub    $0x8,%esp
 254:	6a 00                	push   $0x0
 256:	ff 75 08             	pushl  0x8(%ebp)
 259:	e8 0c 01 00 00       	call   36a <open>
 25e:	83 c4 10             	add    $0x10,%esp
 261:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 268:	79 07                	jns    271 <stat+0x26>
    return -1;
 26a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26f:	eb 25                	jmp    296 <stat+0x4b>
  r = fstat(fd, st);
 271:	83 ec 08             	sub    $0x8,%esp
 274:	ff 75 0c             	pushl  0xc(%ebp)
 277:	ff 75 f4             	pushl  -0xc(%ebp)
 27a:	e8 03 01 00 00       	call   382 <fstat>
 27f:	83 c4 10             	add    $0x10,%esp
 282:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 285:	83 ec 0c             	sub    $0xc,%esp
 288:	ff 75 f4             	pushl  -0xc(%ebp)
 28b:	e8 c2 00 00 00       	call   352 <close>
 290:	83 c4 10             	add    $0x10,%esp
  return r;
 293:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <atoi>:

int
atoi(const char *s)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a5:	eb 25                	jmp    2cc <atoi+0x34>
    n = n*10 + *s++ - '0';
 2a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2aa:	89 d0                	mov    %edx,%eax
 2ac:	c1 e0 02             	shl    $0x2,%eax
 2af:	01 d0                	add    %edx,%eax
 2b1:	01 c0                	add    %eax,%eax
 2b3:	89 c1                	mov    %eax,%ecx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	8d 50 01             	lea    0x1(%eax),%edx
 2bb:	89 55 08             	mov    %edx,0x8(%ebp)
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	0f be c0             	movsbl %al,%eax
 2c4:	01 c8                	add    %ecx,%eax
 2c6:	83 e8 30             	sub    $0x30,%eax
 2c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 2f                	cmp    $0x2f,%al
 2d4:	7e 0a                	jle    2e0 <atoi+0x48>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	3c 39                	cmp    $0x39,%al
 2de:	7e c7                	jle    2a7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f7:	eb 17                	jmp    310 <memmove+0x2b>
    *dst++ = *src++;
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fc:	8d 50 01             	lea    0x1(%eax),%edx
 2ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
 302:	8b 55 f8             	mov    -0x8(%ebp),%edx
 305:	8d 4a 01             	lea    0x1(%edx),%ecx
 308:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30b:	0f b6 12             	movzbl (%edx),%edx
 30e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 310:	8b 45 10             	mov    0x10(%ebp),%eax
 313:	8d 50 ff             	lea    -0x1(%eax),%edx
 316:	89 55 10             	mov    %edx,0x10(%ebp)
 319:	85 c0                	test   %eax,%eax
 31b:	7f dc                	jg     2f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 322:	b8 01 00 00 00       	mov    $0x1,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exit>:
SYSCALL(exit)
 32a:	b8 02 00 00 00       	mov    $0x2,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <wait>:
SYSCALL(wait)
 332:	b8 03 00 00 00       	mov    $0x3,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <pipe>:
SYSCALL(pipe)
 33a:	b8 04 00 00 00       	mov    $0x4,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <read>:
SYSCALL(read)
 342:	b8 05 00 00 00       	mov    $0x5,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <write>:
SYSCALL(write)
 34a:	b8 10 00 00 00       	mov    $0x10,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <close>:
SYSCALL(close)
 352:	b8 15 00 00 00       	mov    $0x15,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <kill>:
SYSCALL(kill)
 35a:	b8 06 00 00 00       	mov    $0x6,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <exec>:
SYSCALL(exec)
 362:	b8 07 00 00 00       	mov    $0x7,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <open>:
SYSCALL(open)
 36a:	b8 0f 00 00 00       	mov    $0xf,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <mknod>:
SYSCALL(mknod)
 372:	b8 11 00 00 00       	mov    $0x11,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <unlink>:
SYSCALL(unlink)
 37a:	b8 12 00 00 00       	mov    $0x12,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <fstat>:
SYSCALL(fstat)
 382:	b8 08 00 00 00       	mov    $0x8,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <link>:
SYSCALL(link)
 38a:	b8 13 00 00 00       	mov    $0x13,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <mkdir>:
SYSCALL(mkdir)
 392:	b8 14 00 00 00       	mov    $0x14,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <chdir>:
SYSCALL(chdir)
 39a:	b8 09 00 00 00       	mov    $0x9,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <dup>:
SYSCALL(dup)
 3a2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <getpid>:
SYSCALL(getpid)
 3aa:	b8 0b 00 00 00       	mov    $0xb,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <sbrk>:
SYSCALL(sbrk)
 3b2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sleep>:
SYSCALL(sleep)
 3ba:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <uptime>:
SYSCALL(uptime)
 3c2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <procstat>:
SYSCALL(procstat)
 3ca:	b8 16 00 00 00       	mov    $0x16,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <set_priority>:
SYSCALL(set_priority)
 3d2:	b8 17 00 00 00       	mov    $0x17,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <semget>:
SYSCALL(semget)
 3da:	b8 18 00 00 00       	mov    $0x18,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <semfree>:
SYSCALL(semfree)
 3e2:	b8 19 00 00 00       	mov    $0x19,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <semdown>:
SYSCALL(semdown)
 3ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <semup>:
 3f2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 18             	sub    $0x18,%esp
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 406:	83 ec 04             	sub    $0x4,%esp
 409:	6a 01                	push   $0x1
 40b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40e:	50                   	push   %eax
 40f:	ff 75 08             	pushl  0x8(%ebp)
 412:	e8 33 ff ff ff       	call   34a <write>
 417:	83 c4 10             	add    $0x10,%esp
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	53                   	push   %ebx
 420:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42e:	74 17                	je     447 <printint+0x2b>
 430:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 434:	79 11                	jns    447 <printint+0x2b>
    neg = 1;
 436:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	f7 d8                	neg    %eax
 442:	89 45 ec             	mov    %eax,-0x14(%ebp)
 445:	eb 06                	jmp    44d <printint+0x31>
  } else {
    x = xx;
 447:	8b 45 0c             	mov    0xc(%ebp),%eax
 44a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 454:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 457:	8d 41 01             	lea    0x1(%ecx),%eax
 45a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 460:	8b 45 ec             	mov    -0x14(%ebp),%eax
 463:	ba 00 00 00 00       	mov    $0x0,%edx
 468:	f7 f3                	div    %ebx
 46a:	89 d0                	mov    %edx,%eax
 46c:	0f b6 80 44 0b 00 00 	movzbl 0xb44(%eax),%eax
 473:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 477:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47d:	ba 00 00 00 00       	mov    $0x0,%edx
 482:	f7 f3                	div    %ebx
 484:	89 45 ec             	mov    %eax,-0x14(%ebp)
 487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48b:	75 c7                	jne    454 <printint+0x38>
  if(neg)
 48d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 491:	74 0e                	je     4a1 <printint+0x85>
    buf[i++] = '-';
 493:	8b 45 f4             	mov    -0xc(%ebp),%eax
 496:	8d 50 01             	lea    0x1(%eax),%edx
 499:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a1:	eb 1d                	jmp    4c0 <printint+0xa4>
    putc(fd, buf[i]);
 4a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	01 d0                	add    %edx,%eax
 4ab:	0f b6 00             	movzbl (%eax),%eax
 4ae:	0f be c0             	movsbl %al,%eax
 4b1:	83 ec 08             	sub    $0x8,%esp
 4b4:	50                   	push   %eax
 4b5:	ff 75 08             	pushl  0x8(%ebp)
 4b8:	e8 3d ff ff ff       	call   3fa <putc>
 4bd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c8:	79 d9                	jns    4a3 <printint+0x87>
    putc(fd, buf[i]);
}
 4ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cd:	c9                   	leave  
 4ce:	c3                   	ret    

000004cf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4dc:	8d 45 0c             	lea    0xc(%ebp),%eax
 4df:	83 c0 04             	add    $0x4,%eax
 4e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ec:	e9 59 01 00 00       	jmp    64a <printf+0x17b>
    c = fmt[i] & 0xff;
 4f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	0f b6 00             	movzbl (%eax),%eax
 4fc:	0f be c0             	movsbl %al,%eax
 4ff:	25 ff 00 00 00       	and    $0xff,%eax
 504:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 507:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50b:	75 2c                	jne    539 <printf+0x6a>
      if(c == '%'){
 50d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 511:	75 0c                	jne    51f <printf+0x50>
        state = '%';
 513:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51a:	e9 27 01 00 00       	jmp    646 <printf+0x177>
      } else {
        putc(fd, c);
 51f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 522:	0f be c0             	movsbl %al,%eax
 525:	83 ec 08             	sub    $0x8,%esp
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 c9 fe ff ff       	call   3fa <putc>
 531:	83 c4 10             	add    $0x10,%esp
 534:	e9 0d 01 00 00       	jmp    646 <printf+0x177>
      }
    } else if(state == '%'){
 539:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 53d:	0f 85 03 01 00 00    	jne    646 <printf+0x177>
      if(c == 'd'){
 543:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 547:	75 1e                	jne    567 <printf+0x98>
        printint(fd, *ap, 10, 1);
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	6a 01                	push   $0x1
 550:	6a 0a                	push   $0xa
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 c1 fe ff ff       	call   41c <printint>
 55b:	83 c4 10             	add    $0x10,%esp
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 562:	e9 d8 00 00 00       	jmp    63f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 567:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56b:	74 06                	je     573 <printf+0xa4>
 56d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 571:	75 1e                	jne    591 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 573:	8b 45 e8             	mov    -0x18(%ebp),%eax
 576:	8b 00                	mov    (%eax),%eax
 578:	6a 00                	push   $0x0
 57a:	6a 10                	push   $0x10
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 97 fe ff ff       	call   41c <printint>
 585:	83 c4 10             	add    $0x10,%esp
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58c:	e9 ae 00 00 00       	jmp    63f <printf+0x170>
      } else if(c == 's'){
 591:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 595:	75 43                	jne    5da <printf+0x10b>
        s = (char*)*ap;
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 59f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a7:	75 07                	jne    5b0 <printf+0xe1>
          s = "(null)";
 5a9:	c7 45 f4 d5 08 00 00 	movl   $0x8d5,-0xc(%ebp)
        while(*s != 0){
 5b0:	eb 1c                	jmp    5ce <printf+0xff>
          putc(fd, *s);
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	0f b6 00             	movzbl (%eax),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 33 fe ff ff       	call   3fa <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
          s++;
 5ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d1:	0f b6 00             	movzbl (%eax),%eax
 5d4:	84 c0                	test   %al,%al
 5d6:	75 da                	jne    5b2 <printf+0xe3>
 5d8:	eb 65                	jmp    63f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5da:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5de:	75 1d                	jne    5fd <printf+0x12e>
        putc(fd, *ap);
 5e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e3:	8b 00                	mov    (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	83 ec 08             	sub    $0x8,%esp
 5eb:	50                   	push   %eax
 5ec:	ff 75 08             	pushl  0x8(%ebp)
 5ef:	e8 06 fe ff ff       	call   3fa <putc>
 5f4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fb:	eb 42                	jmp    63f <printf+0x170>
      } else if(c == '%'){
 5fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 601:	75 17                	jne    61a <printf+0x14b>
        putc(fd, c);
 603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	83 ec 08             	sub    $0x8,%esp
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 e5 fd ff ff       	call   3fa <putc>
 615:	83 c4 10             	add    $0x10,%esp
 618:	eb 25                	jmp    63f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	6a 25                	push   $0x25
 61f:	ff 75 08             	pushl  0x8(%ebp)
 622:	e8 d3 fd ff ff       	call   3fa <putc>
 627:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	83 ec 08             	sub    $0x8,%esp
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 be fd ff ff       	call   3fa <putc>
 63c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 63f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 646:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64a:	8b 55 0c             	mov    0xc(%ebp),%edx
 64d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 650:	01 d0                	add    %edx,%eax
 652:	0f b6 00             	movzbl (%eax),%eax
 655:	84 c0                	test   %al,%al
 657:	0f 85 94 fe ff ff    	jne    4f1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65d:	c9                   	leave  
 65e:	c3                   	ret    

0000065f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65f:	55                   	push   %ebp
 660:	89 e5                	mov    %esp,%ebp
 662:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	83 e8 08             	sub    $0x8,%eax
 66b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	a1 60 0b 00 00       	mov    0xb60,%eax
 673:	89 45 fc             	mov    %eax,-0x4(%ebp)
 676:	eb 24                	jmp    69c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	77 12                	ja     694 <free+0x35>
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 688:	77 24                	ja     6ae <free+0x4f>
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 692:	77 1a                	ja     6ae <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a2:	76 d4                	jbe    678 <free+0x19>
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ac:	76 ca                	jbe    678 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	8b 40 04             	mov    0x4(%eax),%eax
 6b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	01 c2                	add    %eax,%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	39 c2                	cmp    %eax,%edx
 6c7:	75 24                	jne    6ed <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	01 c2                	add    %eax,%edx
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	8b 10                	mov    (%eax),%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 10                	mov    %edx,(%eax)
 6eb:	eb 0a                	jmp    6f7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	01 d0                	add    %edx,%eax
 709:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70c:	75 20                	jne    72e <free+0xcf>
    p->s.size += bp->s.size;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 50 04             	mov    0x4(%eax),%edx
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	8b 40 04             	mov    0x4(%eax),%eax
 71a:	01 c2                	add    %eax,%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
 72c:	eb 08                	jmp    736 <free+0xd7>
  } else
    p->s.ptr = bp;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 55 f8             	mov    -0x8(%ebp),%edx
 734:	89 10                	mov    %edx,(%eax)
  freep = p;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <morecore>:

static Header*
morecore(uint nu)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 746:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74d:	77 07                	ja     756 <morecore+0x16>
    nu = 4096;
 74f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 756:	8b 45 08             	mov    0x8(%ebp),%eax
 759:	c1 e0 03             	shl    $0x3,%eax
 75c:	83 ec 0c             	sub    $0xc,%esp
 75f:	50                   	push   %eax
 760:	e8 4d fc ff ff       	call   3b2 <sbrk>
 765:	83 c4 10             	add    $0x10,%esp
 768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76f:	75 07                	jne    778 <morecore+0x38>
    return 0;
 771:	b8 00 00 00 00       	mov    $0x0,%eax
 776:	eb 26                	jmp    79e <morecore+0x5e>
  hp = (Header*)p;
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	8b 55 08             	mov    0x8(%ebp),%edx
 784:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	50                   	push   %eax
 791:	e8 c9 fe ff ff       	call   65f <free>
 796:	83 c4 10             	add    $0x10,%esp
  return freep;
 799:	a1 60 0b 00 00       	mov    0xb60,%eax
}
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <malloc>:

void*
malloc(uint nbytes)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	8b 45 08             	mov    0x8(%ebp),%eax
 7a9:	83 c0 07             	add    $0x7,%eax
 7ac:	c1 e8 03             	shr    $0x3,%eax
 7af:	83 c0 01             	add    $0x1,%eax
 7b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b5:	a1 60 0b 00 00       	mov    0xb60,%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c1:	75 23                	jne    7e6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c3:	c7 45 f0 58 0b 00 00 	movl   $0xb58,-0x10(%ebp)
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	a3 60 0b 00 00       	mov    %eax,0xb60
 7d2:	a1 60 0b 00 00       	mov    0xb60,%eax
 7d7:	a3 58 0b 00 00       	mov    %eax,0xb58
    base.s.size = 0;
 7dc:	c7 05 5c 0b 00 00 00 	movl   $0x0,0xb5c
 7e3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f7:	72 4d                	jb     846 <malloc+0xa6>
      if(p->s.size == nunits)
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 802:	75 0c                	jne    810 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 10                	mov    (%eax),%edx
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	89 10                	mov    %edx,(%eax)
 80e:	eb 26                	jmp    836 <malloc+0x96>
      else {
        p->s.size -= nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	2b 45 ec             	sub    -0x14(%ebp),%eax
 819:	89 c2                	mov    %eax,%edx
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	c1 e0 03             	shl    $0x3,%eax
 82a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 55 ec             	mov    -0x14(%ebp),%edx
 833:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	a3 60 0b 00 00       	mov    %eax,0xb60
      return (void*)(p + 1);
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	83 c0 08             	add    $0x8,%eax
 844:	eb 3b                	jmp    881 <malloc+0xe1>
    }
    if(p == freep)
 846:	a1 60 0b 00 00       	mov    0xb60,%eax
 84b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84e:	75 1e                	jne    86e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	ff 75 ec             	pushl  -0x14(%ebp)
 856:	e8 e5 fe ff ff       	call   740 <morecore>
 85b:	83 c4 10             	add    $0x10,%esp
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 865:	75 07                	jne    86e <malloc+0xce>
        return 0;
 867:	b8 00 00 00 00       	mov    $0x0,%eax
 86c:	eb 13                	jmp    881 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87c:	e9 6d ff ff ff       	jmp    7ee <malloc+0x4e>
}
 881:	c9                   	leave  
 882:	c3                   	ret    
