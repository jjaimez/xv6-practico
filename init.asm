
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 b0 08 00 00       	push   $0x8b0
  1b:	e8 74 03 00 00       	call   394 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 b0 08 00 00       	push   $0x8b0
  33:	e8 64 03 00 00       	call   39c <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 b0 08 00 00       	push   $0x8b0
  45:	e8 4a 03 00 00       	call   394 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 75 03 00 00       	call   3cc <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 68 03 00 00       	call   3cc <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 b8 08 00 00       	push   $0x8b8
  6f:	6a 01                	push   $0x1
  71:	e8 83 04 00 00       	call   4f9 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 ce 02 00 00       	call   34c <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 cb 08 00 00       	push   $0x8cb
  8f:	6a 01                	push   $0x1
  91:	e8 63 04 00 00       	call   4f9 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 b6 02 00 00       	call   354 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 2c                	jne    d0 <main+0xd0>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 4c 0b 00 00       	push   $0xb4c
  ac:	68 ad 08 00 00       	push   $0x8ad
  b1:	e8 d6 02 00 00       	call   38c <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 de 08 00 00       	push   $0x8de
  c1:	6a 01                	push   $0x1
  c3:	e8 31 04 00 00       	call   4f9 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 84 02 00 00       	call   354 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  d0:	eb 12                	jmp    e4 <main+0xe4>
      printf(1, "zombie!\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 f4 08 00 00       	push   $0x8f4
  da:	6a 01                	push   $0x1
  dc:	e8 18 04 00 00       	call   4f9 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e4:	e8 73 02 00 00       	call   35c <wait>
  e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f0:	78 08                	js     fa <main+0xfa>
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  f8:	75 d8                	jne    d2 <main+0xd2>
      printf(1, "zombie!\n");
  }
  fa:	e9 68 ff ff ff       	jmp    67 <main+0x67>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	5b                   	pop    %ebx
 121:	5f                   	pop    %edi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 130:	90                   	nop
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 50 01             	lea    0x1(%eax),%edx
 137:	89 55 08             	mov    %edx,0x8(%ebp)
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
 13d:	8d 4a 01             	lea    0x1(%edx),%ecx
 140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	88 10                	mov    %dl,(%eax)
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 e2                	jne    131 <strcpy+0xd>
    ;
  return os;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 157:	eb 08                	jmp    161 <strcmp+0xd>
    p++, q++;
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	74 10                	je     17b <strcmp+0x27>
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 10             	movzbl (%eax),%edx
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	38 c2                	cmp    %al,%dl
 179:	74 de                	je     159 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	0f b6 d0             	movzbl %al,%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	0f b6 c0             	movzbl %al,%eax
 18d:	29 c2                	sub    %eax,%edx
 18f:	89 d0                	mov    %edx,%eax
}
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a0:	eb 04                	jmp    1a6 <strlen+0x13>
 1a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 ed                	jne    1a2 <strlen+0xf>
    ;
  return n;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1bd:	8b 45 10             	mov    0x10(%ebp),%eax
 1c0:	50                   	push   %eax
 1c1:	ff 75 0c             	pushl  0xc(%ebp)
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 33 ff ff ff       	call   ff <stosb>
 1cc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e0:	eb 14                	jmp    1f6 <strchr+0x22>
    if(*s == c)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1eb:	75 05                	jne    1f2 <strchr+0x1e>
      return (char*)s;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	eb 13                	jmp    205 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	75 e2                	jne    1e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 214:	eb 44                	jmp    25a <gets+0x53>
    cc = read(0, &c, 1);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 01                	push   $0x1
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	6a 00                	push   $0x0
 221:	e8 46 01 00 00       	call   36c <read>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 230:	7f 02                	jg     234 <gets+0x2d>
      break;
 232:	eb 31                	jmp    265 <gets+0x5e>
    buf[i++] = c;
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23d:	89 c2                	mov    %eax,%edx
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	01 c2                	add    %eax,%edx
 244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 248:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24e:	3c 0a                	cmp    $0xa,%al
 250:	74 13                	je     265 <gets+0x5e>
 252:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 256:	3c 0d                	cmp    $0xd,%al
 258:	74 0b                	je     265 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	83 c0 01             	add    $0x1,%eax
 260:	3b 45 0c             	cmp    0xc(%ebp),%eax
 263:	7c b1                	jl     216 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 265:	8b 55 f4             	mov    -0xc(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <stat>:

int
stat(char *n, struct stat *st)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27b:	83 ec 08             	sub    $0x8,%esp
 27e:	6a 00                	push   $0x0
 280:	ff 75 08             	pushl  0x8(%ebp)
 283:	e8 0c 01 00 00       	call   394 <open>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 292:	79 07                	jns    29b <stat+0x26>
    return -1;
 294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 299:	eb 25                	jmp    2c0 <stat+0x4b>
  r = fstat(fd, st);
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	ff 75 0c             	pushl  0xc(%ebp)
 2a1:	ff 75 f4             	pushl  -0xc(%ebp)
 2a4:	e8 03 01 00 00       	call   3ac <fstat>
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2af:	83 ec 0c             	sub    $0xc,%esp
 2b2:	ff 75 f4             	pushl  -0xc(%ebp)
 2b5:	e8 c2 00 00 00       	call   37c <close>
 2ba:	83 c4 10             	add    $0x10,%esp
  return r;
 2bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <atoi>:

int
atoi(const char *s)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cf:	eb 25                	jmp    2f6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d4:	89 d0                	mov    %edx,%eax
 2d6:	c1 e0 02             	shl    $0x2,%eax
 2d9:	01 d0                	add    %edx,%eax
 2db:	01 c0                	add    %eax,%eax
 2dd:	89 c1                	mov    %eax,%ecx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 08             	mov    %edx,0x8(%ebp)
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	0f be c0             	movsbl %al,%eax
 2ee:	01 c8                	add    %ecx,%eax
 2f0:	83 e8 30             	sub    $0x30,%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2f                	cmp    $0x2f,%al
 2fe:	7e 0a                	jle    30a <atoi+0x48>
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	3c 39                	cmp    $0x39,%al
 308:	7e c7                	jle    2d1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 321:	eb 17                	jmp    33a <memmove+0x2b>
    *dst++ = *src++;
 323:	8b 45 fc             	mov    -0x4(%ebp),%eax
 326:	8d 50 01             	lea    0x1(%eax),%edx
 329:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32f:	8d 4a 01             	lea    0x1(%edx),%ecx
 332:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 335:	0f b6 12             	movzbl (%edx),%edx
 338:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33a:	8b 45 10             	mov    0x10(%ebp),%eax
 33d:	8d 50 ff             	lea    -0x1(%eax),%edx
 340:	89 55 10             	mov    %edx,0x10(%ebp)
 343:	85 c0                	test   %eax,%eax
 345:	7f dc                	jg     323 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34c:	b8 01 00 00 00       	mov    $0x1,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <exit>:
SYSCALL(exit)
 354:	b8 02 00 00 00       	mov    $0x2,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <wait>:
SYSCALL(wait)
 35c:	b8 03 00 00 00       	mov    $0x3,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <pipe>:
SYSCALL(pipe)
 364:	b8 04 00 00 00       	mov    $0x4,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <read>:
SYSCALL(read)
 36c:	b8 05 00 00 00       	mov    $0x5,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <write>:
SYSCALL(write)
 374:	b8 10 00 00 00       	mov    $0x10,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <close>:
SYSCALL(close)
 37c:	b8 15 00 00 00       	mov    $0x15,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <kill>:
SYSCALL(kill)
 384:	b8 06 00 00 00       	mov    $0x6,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exec>:
SYSCALL(exec)
 38c:	b8 07 00 00 00       	mov    $0x7,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <open>:
SYSCALL(open)
 394:	b8 0f 00 00 00       	mov    $0xf,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mknod>:
SYSCALL(mknod)
 39c:	b8 11 00 00 00       	mov    $0x11,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <unlink>:
SYSCALL(unlink)
 3a4:	b8 12 00 00 00       	mov    $0x12,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <fstat>:
SYSCALL(fstat)
 3ac:	b8 08 00 00 00       	mov    $0x8,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <link>:
SYSCALL(link)
 3b4:	b8 13 00 00 00       	mov    $0x13,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mkdir>:
SYSCALL(mkdir)
 3bc:	b8 14 00 00 00       	mov    $0x14,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <chdir>:
SYSCALL(chdir)
 3c4:	b8 09 00 00 00       	mov    $0x9,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <dup>:
SYSCALL(dup)
 3cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <getpid>:
SYSCALL(getpid)
 3d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <sbrk>:
SYSCALL(sbrk)
 3dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <sleep>:
SYSCALL(sleep)
 3e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <uptime>:
SYSCALL(uptime)
 3ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <procstat>:
SYSCALL(procstat)
 3f4:	b8 16 00 00 00       	mov    $0x16,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <set_priority>:
SYSCALL(set_priority)
 3fc:	b8 17 00 00 00       	mov    $0x17,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <semget>:
SYSCALL(semget)
 404:	b8 18 00 00 00       	mov    $0x18,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <semfree>:
SYSCALL(semfree)
 40c:	b8 19 00 00 00       	mov    $0x19,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <semdown>:
SYSCALL(semdown)
 414:	b8 1a 00 00 00       	mov    $0x1a,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <semup>:
 41c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 18             	sub    $0x18,%esp
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 430:	83 ec 04             	sub    $0x4,%esp
 433:	6a 01                	push   $0x1
 435:	8d 45 f4             	lea    -0xc(%ebp),%eax
 438:	50                   	push   %eax
 439:	ff 75 08             	pushl  0x8(%ebp)
 43c:	e8 33 ff ff ff       	call   374 <write>
 441:	83 c4 10             	add    $0x10,%esp
}
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	53                   	push   %ebx
 44a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 454:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 458:	74 17                	je     471 <printint+0x2b>
 45a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45e:	79 11                	jns    471 <printint+0x2b>
    neg = 1;
 460:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	f7 d8                	neg    %eax
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46f:	eb 06                	jmp    477 <printint+0x31>
  } else {
    x = xx;
 471:	8b 45 0c             	mov    0xc(%ebp),%eax
 474:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 477:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 481:	8d 41 01             	lea    0x1(%ecx),%eax
 484:	89 45 f4             	mov    %eax,-0xc(%ebp)
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 d0                	mov    %edx,%eax
 496:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 49d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a7:	ba 00 00 00 00       	mov    $0x0,%edx
 4ac:	f7 f3                	div    %ebx
 4ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b5:	75 c7                	jne    47e <printint+0x38>
  if(neg)
 4b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bb:	74 0e                	je     4cb <printint+0x85>
    buf[i++] = '-';
 4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4cb:	eb 1d                	jmp    4ea <printint+0xa4>
    putc(fd, buf[i]);
 4cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d3:	01 d0                	add    %edx,%eax
 4d5:	0f b6 00             	movzbl (%eax),%eax
 4d8:	0f be c0             	movsbl %al,%eax
 4db:	83 ec 08             	sub    $0x8,%esp
 4de:	50                   	push   %eax
 4df:	ff 75 08             	pushl  0x8(%ebp)
 4e2:	e8 3d ff ff ff       	call   424 <putc>
 4e7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f2:	79 d9                	jns    4cd <printint+0x87>
    putc(fd, buf[i]);
}
 4f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f7:	c9                   	leave  
 4f8:	c3                   	ret    

000004f9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f9:	55                   	push   %ebp
 4fa:	89 e5                	mov    %esp,%ebp
 4fc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 506:	8d 45 0c             	lea    0xc(%ebp),%eax
 509:	83 c0 04             	add    $0x4,%eax
 50c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 516:	e9 59 01 00 00       	jmp    674 <printf+0x17b>
    c = fmt[i] & 0xff;
 51b:	8b 55 0c             	mov    0xc(%ebp),%edx
 51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 521:	01 d0                	add    %edx,%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	0f be c0             	movsbl %al,%eax
 529:	25 ff 00 00 00       	and    $0xff,%eax
 52e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 531:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 535:	75 2c                	jne    563 <printf+0x6a>
      if(c == '%'){
 537:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53b:	75 0c                	jne    549 <printf+0x50>
        state = '%';
 53d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 544:	e9 27 01 00 00       	jmp    670 <printf+0x177>
      } else {
        putc(fd, c);
 549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	83 ec 08             	sub    $0x8,%esp
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 c9 fe ff ff       	call   424 <putc>
 55b:	83 c4 10             	add    $0x10,%esp
 55e:	e9 0d 01 00 00       	jmp    670 <printf+0x177>
      }
    } else if(state == '%'){
 563:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 567:	0f 85 03 01 00 00    	jne    670 <printf+0x177>
      if(c == 'd'){
 56d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 571:	75 1e                	jne    591 <printf+0x98>
        printint(fd, *ap, 10, 1);
 573:	8b 45 e8             	mov    -0x18(%ebp),%eax
 576:	8b 00                	mov    (%eax),%eax
 578:	6a 01                	push   $0x1
 57a:	6a 0a                	push   $0xa
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 c1 fe ff ff       	call   446 <printint>
 585:	83 c4 10             	add    $0x10,%esp
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58c:	e9 d8 00 00 00       	jmp    669 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 591:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 595:	74 06                	je     59d <printf+0xa4>
 597:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59b:	75 1e                	jne    5bb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	6a 00                	push   $0x0
 5a4:	6a 10                	push   $0x10
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 97 fe ff ff       	call   446 <printint>
 5af:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	e9 ae 00 00 00       	jmp    669 <printf+0x170>
      } else if(c == 's'){
 5bb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bf:	75 43                	jne    604 <printf+0x10b>
        s = (char*)*ap;
 5c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d1:	75 07                	jne    5da <printf+0xe1>
          s = "(null)";
 5d3:	c7 45 f4 fd 08 00 00 	movl   $0x8fd,-0xc(%ebp)
        while(*s != 0){
 5da:	eb 1c                	jmp    5f8 <printf+0xff>
          putc(fd, *s);
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	0f be c0             	movsbl %al,%eax
 5e5:	83 ec 08             	sub    $0x8,%esp
 5e8:	50                   	push   %eax
 5e9:	ff 75 08             	pushl  0x8(%ebp)
 5ec:	e8 33 fe ff ff       	call   424 <putc>
 5f1:	83 c4 10             	add    $0x10,%esp
          s++;
 5f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	84 c0                	test   %al,%al
 600:	75 da                	jne    5dc <printf+0xe3>
 602:	eb 65                	jmp    669 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 604:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 608:	75 1d                	jne    627 <printf+0x12e>
        putc(fd, *ap);
 60a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	83 ec 08             	sub    $0x8,%esp
 615:	50                   	push   %eax
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 06 fe ff ff       	call   424 <putc>
 61e:	83 c4 10             	add    $0x10,%esp
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 625:	eb 42                	jmp    669 <printf+0x170>
      } else if(c == '%'){
 627:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62b:	75 17                	jne    644 <printf+0x14b>
        putc(fd, c);
 62d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	83 ec 08             	sub    $0x8,%esp
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 e5 fd ff ff       	call   424 <putc>
 63f:	83 c4 10             	add    $0x10,%esp
 642:	eb 25                	jmp    669 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 644:	83 ec 08             	sub    $0x8,%esp
 647:	6a 25                	push   $0x25
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 d3 fd ff ff       	call   424 <putc>
 651:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 657:	0f be c0             	movsbl %al,%eax
 65a:	83 ec 08             	sub    $0x8,%esp
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 be fd ff ff       	call   424 <putc>
 666:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 670:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 674:	8b 55 0c             	mov    0xc(%ebp),%edx
 677:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67a:	01 d0                	add    %edx,%eax
 67c:	0f b6 00             	movzbl (%eax),%eax
 67f:	84 c0                	test   %al,%al
 681:	0f 85 94 fe ff ff    	jne    51b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 687:	c9                   	leave  
 688:	c3                   	ret    

00000689 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 689:	55                   	push   %ebp
 68a:	89 e5                	mov    %esp,%ebp
 68c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	83 e8 08             	sub    $0x8,%eax
 695:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 698:	a1 70 0b 00 00       	mov    0xb70,%eax
 69d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a0:	eb 24                	jmp    6c6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6aa:	77 12                	ja     6be <free+0x35>
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b2:	77 24                	ja     6d8 <free+0x4f>
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bc:	77 1a                	ja     6d8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cc:	76 d4                	jbe    6a2 <free+0x19>
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d6:	76 ca                	jbe    6a2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	01 c2                	add    %eax,%edx
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	39 c2                	cmp    %eax,%edx
 6f1:	75 24                	jne    717 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	8b 50 04             	mov    0x4(%eax),%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	01 c2                	add    %eax,%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	8b 10                	mov    (%eax),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	89 10                	mov    %edx,(%eax)
 715:	eb 0a                	jmp    721 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 10                	mov    (%eax),%edx
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	01 d0                	add    %edx,%eax
 733:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 736:	75 20                	jne    758 <free+0xcf>
    p->s.size += bp->s.size;
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 50 04             	mov    0x4(%eax),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	8b 10                	mov    (%eax),%edx
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	89 10                	mov    %edx,(%eax)
 756:	eb 08                	jmp    760 <free+0xd7>
  } else
    p->s.ptr = bp;
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75e:	89 10                	mov    %edx,(%eax)
  freep = p;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 768:	c9                   	leave  
 769:	c3                   	ret    

0000076a <morecore>:

static Header*
morecore(uint nu)
{
 76a:	55                   	push   %ebp
 76b:	89 e5                	mov    %esp,%ebp
 76d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 770:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 777:	77 07                	ja     780 <morecore+0x16>
    nu = 4096;
 779:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	c1 e0 03             	shl    $0x3,%eax
 786:	83 ec 0c             	sub    $0xc,%esp
 789:	50                   	push   %eax
 78a:	e8 4d fc ff ff       	call   3dc <sbrk>
 78f:	83 c4 10             	add    $0x10,%esp
 792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 795:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 799:	75 07                	jne    7a2 <morecore+0x38>
    return 0;
 79b:	b8 00 00 00 00       	mov    $0x0,%eax
 7a0:	eb 26                	jmp    7c8 <morecore+0x5e>
  hp = (Header*)p;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	8b 55 08             	mov    0x8(%ebp),%edx
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	83 ec 0c             	sub    $0xc,%esp
 7ba:	50                   	push   %eax
 7bb:	e8 c9 fe ff ff       	call   689 <free>
 7c0:	83 c4 10             	add    $0x10,%esp
  return freep;
 7c3:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    

000007ca <malloc>:

void*
malloc(uint nbytes)
{
 7ca:	55                   	push   %ebp
 7cb:	89 e5                	mov    %esp,%ebp
 7cd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	83 c0 07             	add    $0x7,%eax
 7d6:	c1 e8 03             	shr    $0x3,%eax
 7d9:	83 c0 01             	add    $0x1,%eax
 7dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7df:	a1 70 0b 00 00       	mov    0xb70,%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7eb:	75 23                	jne    810 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ed:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 70 0b 00 00       	mov    %eax,0xb70
 7fc:	a1 70 0b 00 00       	mov    0xb70,%eax
 801:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 806:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 80d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 821:	72 4d                	jb     870 <malloc+0xa6>
      if(p->s.size == nunits)
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82c:	75 0c                	jne    83a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 10                	mov    (%eax),%edx
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	89 10                	mov    %edx,(%eax)
 838:	eb 26                	jmp    860 <malloc+0x96>
      else {
        p->s.size -= nunits;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 40 04             	mov    0x4(%eax),%eax
 840:	2b 45 ec             	sub    -0x14(%ebp),%eax
 843:	89 c2                	mov    %eax,%edx
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	c1 e0 03             	shl    $0x3,%eax
 854:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	83 c0 08             	add    $0x8,%eax
 86e:	eb 3b                	jmp    8ab <malloc+0xe1>
    }
    if(p == freep)
 870:	a1 70 0b 00 00       	mov    0xb70,%eax
 875:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 878:	75 1e                	jne    898 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 87a:	83 ec 0c             	sub    $0xc,%esp
 87d:	ff 75 ec             	pushl  -0x14(%ebp)
 880:	e8 e5 fe ff ff       	call   76a <morecore>
 885:	83 c4 10             	add    $0x10,%esp
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88f:	75 07                	jne    898 <malloc+0xce>
        return 0;
 891:	b8 00 00 00 00       	mov    $0x0,%eax
 896:	eb 13                	jmp    8ab <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	8b 00                	mov    (%eax),%eax
 8a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a6:	e9 6d ff ff ff       	jmp    818 <malloc+0x4e>
}
 8ab:	c9                   	leave  
 8ac:	c3                   	ret    
