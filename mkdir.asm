
_mkdir:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: mkdir files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 3e 08 00 00       	push   $0x83e
  21:	6a 02                	push   $0x2
  23:	e8 62 04 00 00       	call   48a <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 b5 02 00 00       	call   2e5 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(mkdir(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 fa 02 00 00       	call   34d <mkdir>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 55 08 00 00       	push   $0x855
  74:	6a 02                	push   $0x2
  76:	e8 0f 04 00 00       	call   48a <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 55 02 00 00       	call   2e5 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	88 10                	mov    %dl,(%eax)
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 08                	jmp    f2 <strcmp+0xd>
    p++, q++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 10                	je     10c <strcmp+0x27>
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	38 c2                	cmp    %al,%dl
 10a:	74 de                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 d0             	movzbl %al,%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	29 c2                	sub    %eax,%edx
 120:	89 d0                	mov    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 131:	eb 04                	jmp    137 <strlen+0x13>
 133:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 137:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 ed                	jne    133 <strlen+0xf>
    ;
  return n;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <memset>:

void*
memset(void *dst, int c, uint n)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14e:	8b 45 10             	mov    0x10(%ebp),%eax
 151:	50                   	push   %eax
 152:	ff 75 0c             	pushl  0xc(%ebp)
 155:	ff 75 08             	pushl  0x8(%ebp)
 158:	e8 33 ff ff ff       	call   90 <stosb>
 15d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 14                	jmp    187 <strchr+0x22>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1e>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 13                	jmp    196 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 44                	jmp    1eb <gets+0x53>
    cc = read(0, &c, 1);
 1a7:	83 ec 04             	sub    $0x4,%esp
 1aa:	6a 01                	push   $0x1
 1ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1af:	50                   	push   %eax
 1b0:	6a 00                	push   $0x0
 1b2:	e8 46 01 00 00       	call   2fd <read>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7f 02                	jg     1c5 <gets+0x2d>
      break;
 1c3:	eb 31                	jmp    1f6 <gets+0x5e>
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	8d 50 01             	lea    0x1(%eax),%edx
 1cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 13                	je     1f6 <gets+0x5e>
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0b                	je     1f6 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f4:	7c b1                	jl     1a7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 0c 01 00 00       	call   325 <open>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 223:	79 07                	jns    22c <stat+0x26>
    return -1;
 225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22a:	eb 25                	jmp    251 <stat+0x4b>
  r = fstat(fd, st);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 0c             	pushl  0xc(%ebp)
 232:	ff 75 f4             	pushl  -0xc(%ebp)
 235:	e8 03 01 00 00       	call   33d <fstat>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 c2 00 00 00       	call   30d <close>
 24b:	83 c4 10             	add    $0x10,%esp
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 25                	jmp    287 <atoi+0x34>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	01 c0                	add    %eax,%eax
 26e:	89 c1                	mov    %eax,%ecx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f be c0             	movsbl %al,%eax
 27f:	01 c8                	add    %ecx,%eax
 281:	83 e8 30             	sub    $0x30,%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 2f                	cmp    $0x2f,%al
 28f:	7e 0a                	jle    29b <atoi+0x48>
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 39                	cmp    $0x39,%al
 299:	7e c7                	jle    262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b2:	eb 17                	jmp    2cb <memmove+0x2b>
    *dst++ = *src++;
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c6:	0f b6 12             	movzbl (%edx),%edx
 2c9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cb:	8b 45 10             	mov    0x10(%ebp),%eax
 2ce:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d1:	89 55 10             	mov    %edx,0x10(%ebp)
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7f dc                	jg     2b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dd:	b8 01 00 00 00       	mov    $0x1,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <exit>:
SYSCALL(exit)
 2e5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <wait>:
SYSCALL(wait)
 2ed:	b8 03 00 00 00       	mov    $0x3,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <pipe>:
SYSCALL(pipe)
 2f5:	b8 04 00 00 00       	mov    $0x4,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <read>:
SYSCALL(read)
 2fd:	b8 05 00 00 00       	mov    $0x5,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <write>:
SYSCALL(write)
 305:	b8 10 00 00 00       	mov    $0x10,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <close>:
SYSCALL(close)
 30d:	b8 15 00 00 00       	mov    $0x15,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <kill>:
SYSCALL(kill)
 315:	b8 06 00 00 00       	mov    $0x6,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exec>:
SYSCALL(exec)
 31d:	b8 07 00 00 00       	mov    $0x7,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <open>:
SYSCALL(open)
 325:	b8 0f 00 00 00       	mov    $0xf,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mknod>:
SYSCALL(mknod)
 32d:	b8 11 00 00 00       	mov    $0x11,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <unlink>:
SYSCALL(unlink)
 335:	b8 12 00 00 00       	mov    $0x12,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <fstat>:
SYSCALL(fstat)
 33d:	b8 08 00 00 00       	mov    $0x8,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <link>:
SYSCALL(link)
 345:	b8 13 00 00 00       	mov    $0x13,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mkdir>:
SYSCALL(mkdir)
 34d:	b8 14 00 00 00       	mov    $0x14,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <chdir>:
SYSCALL(chdir)
 355:	b8 09 00 00 00       	mov    $0x9,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <dup>:
SYSCALL(dup)
 35d:	b8 0a 00 00 00       	mov    $0xa,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <getpid>:
SYSCALL(getpid)
 365:	b8 0b 00 00 00       	mov    $0xb,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sbrk>:
SYSCALL(sbrk)
 36d:	b8 0c 00 00 00       	mov    $0xc,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <sleep>:
SYSCALL(sleep)
 375:	b8 0d 00 00 00       	mov    $0xd,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <uptime>:
SYSCALL(uptime)
 37d:	b8 0e 00 00 00       	mov    $0xe,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <procstat>:
SYSCALL(procstat)
 385:	b8 16 00 00 00       	mov    $0x16,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <set_priority>:
SYSCALL(set_priority)
 38d:	b8 17 00 00 00       	mov    $0x17,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <semget>:
SYSCALL(semget)
 395:	b8 18 00 00 00       	mov    $0x18,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <semfree>:
SYSCALL(semfree)
 39d:	b8 19 00 00 00       	mov    $0x19,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <semdown>:
SYSCALL(semdown)
 3a5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <semup>:
 3ad:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 18             	sub    $0x18,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c1:	83 ec 04             	sub    $0x4,%esp
 3c4:	6a 01                	push   $0x1
 3c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c9:	50                   	push   %eax
 3ca:	ff 75 08             	pushl  0x8(%ebp)
 3cd:	e8 33 ff ff ff       	call   305 <write>
 3d2:	83 c4 10             	add    $0x10,%esp
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	53                   	push   %ebx
 3db:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e9:	74 17                	je     402 <printint+0x2b>
 3eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ef:	79 11                	jns    402 <printint+0x2b>
    neg = 1;
 3f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	f7 d8                	neg    %eax
 3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 400:	eb 06                	jmp    408 <printint+0x31>
  } else {
    x = xx;
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 408:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 412:	8d 41 01             	lea    0x1(%ecx),%eax
 415:	89 45 f4             	mov    %eax,-0xc(%ebp)
 418:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41e:	ba 00 00 00 00       	mov    $0x0,%edx
 423:	f7 f3                	div    %ebx
 425:	89 d0                	mov    %edx,%eax
 427:	0f b6 80 c4 0a 00 00 	movzbl 0xac4(%eax),%eax
 42e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 432:	8b 5d 10             	mov    0x10(%ebp),%ebx
 435:	8b 45 ec             	mov    -0x14(%ebp),%eax
 438:	ba 00 00 00 00       	mov    $0x0,%edx
 43d:	f7 f3                	div    %ebx
 43f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 442:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 446:	75 c7                	jne    40f <printint+0x38>
  if(neg)
 448:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44c:	74 0e                	je     45c <printint+0x85>
    buf[i++] = '-';
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	8d 50 01             	lea    0x1(%eax),%edx
 454:	89 55 f4             	mov    %edx,-0xc(%ebp)
 457:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45c:	eb 1d                	jmp    47b <printint+0xa4>
    putc(fd, buf[i]);
 45e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	83 ec 08             	sub    $0x8,%esp
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 3d ff ff ff       	call   3b5 <putc>
 478:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 483:	79 d9                	jns    45e <printint+0x87>
    putc(fd, buf[i]);
}
 485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 488:	c9                   	leave  
 489:	c3                   	ret    

0000048a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 490:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 497:	8d 45 0c             	lea    0xc(%ebp),%eax
 49a:	83 c0 04             	add    $0x4,%eax
 49d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a7:	e9 59 01 00 00       	jmp    605 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 4af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	0f b6 00             	movzbl (%eax),%eax
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	25 ff 00 00 00       	and    $0xff,%eax
 4bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c6:	75 2c                	jne    4f4 <printf+0x6a>
      if(c == '%'){
 4c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4cc:	75 0c                	jne    4da <printf+0x50>
        state = '%';
 4ce:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d5:	e9 27 01 00 00       	jmp    601 <printf+0x177>
      } else {
        putc(fd, c);
 4da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4dd:	0f be c0             	movsbl %al,%eax
 4e0:	83 ec 08             	sub    $0x8,%esp
 4e3:	50                   	push   %eax
 4e4:	ff 75 08             	pushl  0x8(%ebp)
 4e7:	e8 c9 fe ff ff       	call   3b5 <putc>
 4ec:	83 c4 10             	add    $0x10,%esp
 4ef:	e9 0d 01 00 00       	jmp    601 <printf+0x177>
      }
    } else if(state == '%'){
 4f4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f8:	0f 85 03 01 00 00    	jne    601 <printf+0x177>
      if(c == 'd'){
 4fe:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 502:	75 1e                	jne    522 <printf+0x98>
        printint(fd, *ap, 10, 1);
 504:	8b 45 e8             	mov    -0x18(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	6a 01                	push   $0x1
 50b:	6a 0a                	push   $0xa
 50d:	50                   	push   %eax
 50e:	ff 75 08             	pushl  0x8(%ebp)
 511:	e8 c1 fe ff ff       	call   3d7 <printint>
 516:	83 c4 10             	add    $0x10,%esp
        ap++;
 519:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51d:	e9 d8 00 00 00       	jmp    5fa <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 522:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 526:	74 06                	je     52e <printf+0xa4>
 528:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52c:	75 1e                	jne    54c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 531:	8b 00                	mov    (%eax),%eax
 533:	6a 00                	push   $0x0
 535:	6a 10                	push   $0x10
 537:	50                   	push   %eax
 538:	ff 75 08             	pushl  0x8(%ebp)
 53b:	e8 97 fe ff ff       	call   3d7 <printint>
 540:	83 c4 10             	add    $0x10,%esp
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 547:	e9 ae 00 00 00       	jmp    5fa <printf+0x170>
      } else if(c == 's'){
 54c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 550:	75 43                	jne    595 <printf+0x10b>
        s = (char*)*ap;
 552:	8b 45 e8             	mov    -0x18(%ebp),%eax
 555:	8b 00                	mov    (%eax),%eax
 557:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	75 07                	jne    56b <printf+0xe1>
          s = "(null)";
 564:	c7 45 f4 71 08 00 00 	movl   $0x871,-0xc(%ebp)
        while(*s != 0){
 56b:	eb 1c                	jmp    589 <printf+0xff>
          putc(fd, *s);
 56d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	83 ec 08             	sub    $0x8,%esp
 579:	50                   	push   %eax
 57a:	ff 75 08             	pushl  0x8(%ebp)
 57d:	e8 33 fe ff ff       	call   3b5 <putc>
 582:	83 c4 10             	add    $0x10,%esp
          s++;
 585:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	84 c0                	test   %al,%al
 591:	75 da                	jne    56d <printf+0xe3>
 593:	eb 65                	jmp    5fa <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 595:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 599:	75 1d                	jne    5b8 <printf+0x12e>
        putc(fd, *ap);
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	83 ec 08             	sub    $0x8,%esp
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 06 fe ff ff       	call   3b5 <putc>
 5af:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	eb 42                	jmp    5fa <printf+0x170>
      } else if(c == '%'){
 5b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bc:	75 17                	jne    5d5 <printf+0x14b>
        putc(fd, c);
 5be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c1:	0f be c0             	movsbl %al,%eax
 5c4:	83 ec 08             	sub    $0x8,%esp
 5c7:	50                   	push   %eax
 5c8:	ff 75 08             	pushl  0x8(%ebp)
 5cb:	e8 e5 fd ff ff       	call   3b5 <putc>
 5d0:	83 c4 10             	add    $0x10,%esp
 5d3:	eb 25                	jmp    5fa <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d5:	83 ec 08             	sub    $0x8,%esp
 5d8:	6a 25                	push   $0x25
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 d3 fd ff ff       	call   3b5 <putc>
 5e2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e8:	0f be c0             	movsbl %al,%eax
 5eb:	83 ec 08             	sub    $0x8,%esp
 5ee:	50                   	push   %eax
 5ef:	ff 75 08             	pushl  0x8(%ebp)
 5f2:	e8 be fd ff ff       	call   3b5 <putc>
 5f7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 601:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 605:	8b 55 0c             	mov    0xc(%ebp),%edx
 608:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60b:	01 d0                	add    %edx,%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	84 c0                	test   %al,%al
 612:	0f 85 94 fe ff ff    	jne    4ac <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 618:	c9                   	leave  
 619:	c3                   	ret    

0000061a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	83 e8 08             	sub    $0x8,%eax
 626:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 629:	a1 e0 0a 00 00       	mov    0xae0,%eax
 62e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 631:	eb 24                	jmp    657 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	77 12                	ja     64f <free+0x35>
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 643:	77 24                	ja     669 <free+0x4f>
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64d:	77 1a                	ja     669 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65d:	76 d4                	jbe    633 <free+0x19>
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 667:	76 ca                	jbe    633 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	01 c2                	add    %eax,%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	39 c2                	cmp    %eax,%edx
 682:	75 24                	jne    6a8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	8b 50 04             	mov    0x4(%eax),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	8b 10                	mov    (%eax),%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	89 10                	mov    %edx,(%eax)
 6a6:	eb 0a                	jmp    6b2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 10                	mov    (%eax),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	01 d0                	add    %edx,%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	75 20                	jne    6e9 <free+0xcf>
    p->s.size += bp->s.size;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 08                	jmp    6f1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <morecore>:

static Header*
morecore(uint nu)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 701:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 708:	77 07                	ja     711 <morecore+0x16>
    nu = 4096;
 70a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	c1 e0 03             	shl    $0x3,%eax
 717:	83 ec 0c             	sub    $0xc,%esp
 71a:	50                   	push   %eax
 71b:	e8 4d fc ff ff       	call   36d <sbrk>
 720:	83 c4 10             	add    $0x10,%esp
 723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 726:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72a:	75 07                	jne    733 <morecore+0x38>
    return 0;
 72c:	b8 00 00 00 00       	mov    $0x0,%eax
 731:	eb 26                	jmp    759 <morecore+0x5e>
  hp = (Header*)p;
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	8b 55 08             	mov    0x8(%ebp),%edx
 73f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	83 c0 08             	add    $0x8,%eax
 748:	83 ec 0c             	sub    $0xc,%esp
 74b:	50                   	push   %eax
 74c:	e8 c9 fe ff ff       	call   61a <free>
 751:	83 c4 10             	add    $0x10,%esp
  return freep;
 754:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 759:	c9                   	leave  
 75a:	c3                   	ret    

0000075b <malloc>:

void*
malloc(uint nbytes)
{
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	83 c0 07             	add    $0x7,%eax
 767:	c1 e8 03             	shr    $0x3,%eax
 76a:	83 c0 01             	add    $0x1,%eax
 76d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 770:	a1 e0 0a 00 00       	mov    0xae0,%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
 778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77c:	75 23                	jne    7a1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77e:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	a3 e0 0a 00 00       	mov    %eax,0xae0
 78d:	a1 e0 0a 00 00       	mov    0xae0,%eax
 792:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 797:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 79e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b2:	72 4d                	jb     801 <malloc+0xa6>
      if(p->s.size == nunits)
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bd:	75 0c                	jne    7cb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 26                	jmp    7f1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d4:	89 c2                	mov    %eax,%edx
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	c1 e0 03             	shl    $0x3,%eax
 7e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	eb 3b                	jmp    83c <malloc+0xe1>
    }
    if(p == freep)
 801:	a1 e0 0a 00 00       	mov    0xae0,%eax
 806:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 809:	75 1e                	jne    829 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	ff 75 ec             	pushl  -0x14(%ebp)
 811:	e8 e5 fe ff ff       	call   6fb <morecore>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 820:	75 07                	jne    829 <malloc+0xce>
        return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 13                	jmp    83c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 837:	e9 6d ff ff ff       	jmp    7a9 <malloc+0x4e>
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    
