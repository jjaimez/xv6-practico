
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 0c             	pushl  0xc(%ebp)
   c:	e8 a0 01 00 00       	call   1b1 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	ff 75 0c             	pushl  0xc(%ebp)
  1b:	ff 75 08             	pushl  0x8(%ebp)
  1e:	e8 6f 03 00 00       	call   392 <write>
  23:	83 c4 10             	add    $0x10,%esp
}
  26:	c9                   	leave  
  27:	c3                   	ret    

00000028 <forktest>:

void
forktest(void)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 44 04 00 00       	push   $0x444
  36:	6a 01                	push   $0x1
  38:	e8 c3 ff ff ff       	call   0 <printf>
  3d:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 2a                	jmp    73 <forktest+0x4b>
    pid = fork();
  49:	e8 1c 03 00 00       	call   36a <fork>
  4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (n==4){
  51:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  55:	75 05                	jne    5c <forktest+0x34>
        procstat();
  57:	e8 b6 03 00 00       	call   412 <procstat>
    }    
    if(pid < 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	79 02                	jns    64 <forktest+0x3c>
      break; 
  62:	eb 18                	jmp    7c <forktest+0x54>
    if(pid == 0)
  64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  68:	75 05                	jne    6f <forktest+0x47>
      exit();
  6a:	e8 03 03 00 00       	call   372 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  73:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  7a:	7e cd                	jle    49 <forktest+0x21>
      break; 
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  7c:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  83:	75 1c                	jne    a1 <forktest+0x79>
    printf(1, "fork claimed to work N times!\n", N);
  85:	83 ec 04             	sub    $0x4,%esp
  88:	68 e8 03 00 00       	push   $0x3e8
  8d:	68 50 04 00 00       	push   $0x450
  92:	6a 01                	push   $0x1
  94:	e8 67 ff ff ff       	call   0 <printf>
  99:	83 c4 10             	add    $0x10,%esp
    exit();
  9c:	e8 d1 02 00 00       	call   372 <exit>
  }
  
  for(; n > 0; n--){
  a1:	eb 24                	jmp    c7 <forktest+0x9f>
    if(wait() < 0){
  a3:	e8 d2 02 00 00       	call   37a <wait>
  a8:	85 c0                	test   %eax,%eax
  aa:	79 17                	jns    c3 <forktest+0x9b>
      printf(1, "wait stopped early\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 6f 04 00 00       	push   $0x46f
  b4:	6a 01                	push   $0x1
  b6:	e8 45 ff ff ff       	call   0 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
      exit();
  be:	e8 af 02 00 00       	call   372 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  cb:	7f d6                	jg     a3 <forktest+0x7b>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  cd:	e8 a8 02 00 00       	call   37a <wait>
  d2:	83 f8 ff             	cmp    $0xffffffff,%eax
  d5:	74 17                	je     ee <forktest+0xc6>
    printf(1, "wait got too many\n");
  d7:	83 ec 08             	sub    $0x8,%esp
  da:	68 83 04 00 00       	push   $0x483
  df:	6a 01                	push   $0x1
  e1:	e8 1a ff ff ff       	call   0 <printf>
  e6:	83 c4 10             	add    $0x10,%esp
    exit();
  e9:	e8 84 02 00 00       	call   372 <exit>
  }
  
  printf(1, "fork test OK\n");
  ee:	83 ec 08             	sub    $0x8,%esp
  f1:	68 96 04 00 00       	push   $0x496
  f6:	6a 01                	push   $0x1
  f8:	e8 03 ff ff ff       	call   0 <printf>
  fd:	83 c4 10             	add    $0x10,%esp
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <main>:

int
main(void)
{
 102:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	ff 71 fc             	pushl  -0x4(%ecx)
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	51                   	push   %ecx
 110:	83 ec 04             	sub    $0x4,%esp
  forktest();
 113:	e8 10 ff ff ff       	call   28 <forktest>
  exit();
 118:	e8 55 02 00 00       	call   372 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 08             	mov    %edx,0x8(%ebp)
 158:	8b 55 0c             	mov    0xc(%ebp),%edx
 15b:	8d 4a 01             	lea    0x1(%edx),%ecx
 15e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	88 10                	mov    %dl,(%eax)
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 e2                	jne    14f <strcpy+0xd>
    ;
  return os;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0xd>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x27>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 ed                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1db:	8b 45 10             	mov    0x10(%ebp),%eax
 1de:	50                   	push   %eax
 1df:	ff 75 0c             	pushl  0xc(%ebp)
 1e2:	ff 75 08             	pushl  0x8(%ebp)
 1e5:	e8 33 ff ff ff       	call   11d <stosb>
 1ea:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 04             	sub    $0x4,%esp
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fe:	eb 14                	jmp    214 <strchr+0x22>
    if(*s == c)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3a 45 fc             	cmp    -0x4(%ebp),%al
 209:	75 05                	jne    210 <strchr+0x1e>
      return (char*)s;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	eb 13                	jmp    223 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 232:	eb 44                	jmp    278 <gets+0x53>
    cc = read(0, &c, 1);
 234:	83 ec 04             	sub    $0x4,%esp
 237:	6a 01                	push   $0x1
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	50                   	push   %eax
 23d:	6a 00                	push   $0x0
 23f:	e8 46 01 00 00       	call   38a <read>
 244:	83 c4 10             	add    $0x10,%esp
 247:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24e:	7f 02                	jg     252 <gets+0x2d>
      break;
 250:	eb 31                	jmp    283 <gets+0x5e>
    buf[i++] = c;
 252:	8b 45 f4             	mov    -0xc(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25b:	89 c2                	mov    %eax,%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	01 c2                	add    %eax,%edx
 262:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 266:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 268:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26c:	3c 0a                	cmp    $0xa,%al
 26e:	74 13                	je     283 <gets+0x5e>
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0d                	cmp    $0xd,%al
 276:	74 0b                	je     283 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 278:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27b:	83 c0 01             	add    $0x1,%eax
 27e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 281:	7c b1                	jl     234 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 283:	8b 55 f4             	mov    -0xc(%ebp),%edx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	01 d0                	add    %edx,%eax
 28b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <stat>:

int
stat(char *n, struct stat *st)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	6a 00                	push   $0x0
 29e:	ff 75 08             	pushl  0x8(%ebp)
 2a1:	e8 0c 01 00 00       	call   3b2 <open>
 2a6:	83 c4 10             	add    $0x10,%esp
 2a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b0:	79 07                	jns    2b9 <stat+0x26>
    return -1;
 2b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b7:	eb 25                	jmp    2de <stat+0x4b>
  r = fstat(fd, st);
 2b9:	83 ec 08             	sub    $0x8,%esp
 2bc:	ff 75 0c             	pushl  0xc(%ebp)
 2bf:	ff 75 f4             	pushl  -0xc(%ebp)
 2c2:	e8 03 01 00 00       	call   3ca <fstat>
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 c2 00 00 00       	call   39a <close>
 2d8:	83 c4 10             	add    $0x10,%esp
  return r;
 2db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2de:	c9                   	leave  
 2df:	c3                   	ret    

000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ed:	eb 25                	jmp    314 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f2:	89 d0                	mov    %edx,%eax
 2f4:	c1 e0 02             	shl    $0x2,%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	01 c0                	add    %eax,%eax
 2fb:	89 c1                	mov    %eax,%ecx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	8d 50 01             	lea    0x1(%eax),%edx
 303:	89 55 08             	mov    %edx,0x8(%ebp)
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	0f be c0             	movsbl %al,%eax
 30c:	01 c8                	add    %ecx,%eax
 30e:	83 e8 30             	sub    $0x30,%eax
 311:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	3c 2f                	cmp    $0x2f,%al
 31c:	7e 0a                	jle    328 <atoi+0x48>
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 00             	movzbl (%eax),%eax
 324:	3c 39                	cmp    $0x39,%al
 326:	7e c7                	jle    2ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 328:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32b:	c9                   	leave  
 32c:	c3                   	ret    

0000032d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 33f:	eb 17                	jmp    358 <memmove+0x2b>
    *dst++ = *src++;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34d:	8d 4a 01             	lea    0x1(%edx),%ecx
 350:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 353:	0f b6 12             	movzbl (%edx),%edx
 356:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 358:	8b 45 10             	mov    0x10(%ebp),%eax
 35b:	8d 50 ff             	lea    -0x1(%eax),%edx
 35e:	89 55 10             	mov    %edx,0x10(%ebp)
 361:	85 c0                	test   %eax,%eax
 363:	7f dc                	jg     341 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exit>:
SYSCALL(exit)
 372:	b8 02 00 00 00       	mov    $0x2,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <wait>:
SYSCALL(wait)
 37a:	b8 03 00 00 00       	mov    $0x3,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <pipe>:
SYSCALL(pipe)
 382:	b8 04 00 00 00       	mov    $0x4,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <read>:
SYSCALL(read)
 38a:	b8 05 00 00 00       	mov    $0x5,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <write>:
SYSCALL(write)
 392:	b8 10 00 00 00       	mov    $0x10,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <close>:
SYSCALL(close)
 39a:	b8 15 00 00 00       	mov    $0x15,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <kill>:
SYSCALL(kill)
 3a2:	b8 06 00 00 00       	mov    $0x6,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <exec>:
SYSCALL(exec)
 3aa:	b8 07 00 00 00       	mov    $0x7,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <open>:
SYSCALL(open)
 3b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mknod>:
SYSCALL(mknod)
 3ba:	b8 11 00 00 00       	mov    $0x11,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <unlink>:
SYSCALL(unlink)
 3c2:	b8 12 00 00 00       	mov    $0x12,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <fstat>:
SYSCALL(fstat)
 3ca:	b8 08 00 00 00       	mov    $0x8,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <link>:
SYSCALL(link)
 3d2:	b8 13 00 00 00       	mov    $0x13,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mkdir>:
SYSCALL(mkdir)
 3da:	b8 14 00 00 00       	mov    $0x14,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <chdir>:
SYSCALL(chdir)
 3e2:	b8 09 00 00 00       	mov    $0x9,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <dup>:
SYSCALL(dup)
 3ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getpid>:
SYSCALL(getpid)
 3f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <sbrk>:
SYSCALL(sbrk)
 3fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sleep>:
SYSCALL(sleep)
 402:	b8 0d 00 00 00       	mov    $0xd,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <uptime>:
SYSCALL(uptime)
 40a:	b8 0e 00 00 00       	mov    $0xe,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <procstat>:
SYSCALL(procstat)
 412:	b8 16 00 00 00       	mov    $0x16,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <set_priority>:
SYSCALL(set_priority)
 41a:	b8 17 00 00 00       	mov    $0x17,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <semget>:
SYSCALL(semget)
 422:	b8 18 00 00 00       	mov    $0x18,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <semfree>:
SYSCALL(semfree)
 42a:	b8 19 00 00 00       	mov    $0x19,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <semdown>:
SYSCALL(semdown)
 432:	b8 1a 00 00 00       	mov    $0x1a,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <semup>:
 43a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    
