
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 80 0c 00 00       	add    $0xc80,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 80 0c 00 00       	add    $0xc80,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 6a 09 00 00       	push   $0x96a
  59:	e8 33 02 00 00       	call   291 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 80 0c 00 00       	push   $0xc80
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 89 03 00 00       	call   429 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 70 09 00 00       	push   $0x970
  be:	6a 01                	push   $0x1
  c0:	e8 f1 04 00 00       	call   5b6 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 44 03 00 00       	call   411 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 80 09 00 00       	push   $0x980
  e1:	6a 01                	push   $0x1
  e3:	e8 ce 04 00 00       	call   5b6 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	c9                   	leave  
  ec:	c3                   	ret    

000000ed <main>:

int
main(int argc, char *argv[])
{
  ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f1:	83 e4 f0             	and    $0xfffffff0,%esp
  f4:	ff 71 fc             	pushl  -0x4(%ecx)
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	53                   	push   %ebx
  fb:	51                   	push   %ecx
  fc:	83 ec 10             	sub    $0x10,%esp
  ff:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 101:	83 3b 01             	cmpl   $0x1,(%ebx)
 104:	7f 17                	jg     11d <main+0x30>
    wc(0, "");
 106:	83 ec 08             	sub    $0x8,%esp
 109:	68 8d 09 00 00       	push   $0x98d
 10e:	6a 00                	push   $0x0
 110:	e8 eb fe ff ff       	call   0 <wc>
 115:	83 c4 10             	add    $0x10,%esp
    exit();
 118:	e8 f4 02 00 00       	call   411 <exit>
  }

  for(i = 1; i < argc; i++){
 11d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 124:	e9 83 00 00 00       	jmp    1ac <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 129:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 133:	8b 43 04             	mov    0x4(%ebx),%eax
 136:	01 d0                	add    %edx,%eax
 138:	8b 00                	mov    (%eax),%eax
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	6a 00                	push   $0x0
 13f:	50                   	push   %eax
 140:	e8 0c 03 00 00       	call   451 <open>
 145:	83 c4 10             	add    $0x10,%esp
 148:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14f:	79 29                	jns    17a <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 151:	8b 45 f4             	mov    -0xc(%ebp),%eax
 154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15b:	8b 43 04             	mov    0x4(%ebx),%eax
 15e:	01 d0                	add    %edx,%eax
 160:	8b 00                	mov    (%eax),%eax
 162:	83 ec 04             	sub    $0x4,%esp
 165:	50                   	push   %eax
 166:	68 8e 09 00 00       	push   $0x98e
 16b:	6a 01                	push   $0x1
 16d:	e8 44 04 00 00       	call   5b6 <printf>
 172:	83 c4 10             	add    $0x10,%esp
      exit();
 175:	e8 97 02 00 00       	call   411 <exit>
    }
    wc(fd, argv[i]);
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 184:	8b 43 04             	mov    0x4(%ebx),%eax
 187:	01 d0                	add    %edx,%eax
 189:	8b 00                	mov    (%eax),%eax
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	50                   	push   %eax
 18f:	ff 75 f0             	pushl  -0x10(%ebp)
 192:	e8 69 fe ff ff       	call   0 <wc>
 197:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19a:	83 ec 0c             	sub    $0xc,%esp
 19d:	ff 75 f0             	pushl  -0x10(%ebp)
 1a0:	e8 94 02 00 00       	call   439 <close>
 1a5:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1af:	3b 03                	cmp    (%ebx),%eax
 1b1:	0f 8c 72 ff ff ff    	jl     129 <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b7:	e8 55 02 00 00       	call   411 <exit>

000001bc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c4:	8b 55 10             	mov    0x10(%ebp),%edx
 1c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ca:	89 cb                	mov    %ecx,%ebx
 1cc:	89 df                	mov    %ebx,%edi
 1ce:	89 d1                	mov    %edx,%ecx
 1d0:	fc                   	cld    
 1d1:	f3 aa                	rep stos %al,%es:(%edi)
 1d3:	89 ca                	mov    %ecx,%edx
 1d5:	89 fb                	mov    %edi,%ebx
 1d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1da:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1dd:	5b                   	pop    %ebx
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ed:	90                   	nop
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	8d 50 01             	lea    0x1(%eax),%edx
 1f4:	89 55 08             	mov    %edx,0x8(%ebp)
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fa:	8d 4a 01             	lea    0x1(%edx),%ecx
 1fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 200:	0f b6 12             	movzbl (%edx),%edx
 203:	88 10                	mov    %dl,(%eax)
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	84 c0                	test   %al,%al
 20a:	75 e2                	jne    1ee <strcpy+0xd>
    ;
  return os;
 20c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 214:	eb 08                	jmp    21e <strcmp+0xd>
    p++, q++;
 216:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	74 10                	je     238 <strcmp+0x27>
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 10             	movzbl (%eax),%edx
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	38 c2                	cmp    %al,%dl
 236:	74 de                	je     216 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 d0             	movzbl %al,%edx
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	0f b6 c0             	movzbl %al,%eax
 24a:	29 c2                	sub    %eax,%edx
 24c:	89 d0                	mov    %edx,%eax
}
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    

00000250 <strlen>:

uint
strlen(char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 256:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25d:	eb 04                	jmp    263 <strlen+0x13>
 25f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 263:	8b 55 fc             	mov    -0x4(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 d0                	add    %edx,%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	84 c0                	test   %al,%al
 270:	75 ed                	jne    25f <strlen+0xf>
    ;
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memset>:

void*
memset(void *dst, int c, uint n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27a:	8b 45 10             	mov    0x10(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	ff 75 0c             	pushl  0xc(%ebp)
 281:	ff 75 08             	pushl  0x8(%ebp)
 284:	e8 33 ff ff ff       	call   1bc <stosb>
 289:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <strchr>:

char*
strchr(const char *s, char c)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 04             	sub    $0x4,%esp
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29d:	eb 14                	jmp    2b3 <strchr+0x22>
    if(*s == c)
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a8:	75 05                	jne    2af <strchr+0x1e>
      return (char*)s;
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	eb 13                	jmp    2c2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	84 c0                	test   %al,%al
 2bb:	75 e2                	jne    29f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <gets>:

char*
gets(char *buf, int max)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d1:	eb 44                	jmp    317 <gets+0x53>
    cc = read(0, &c, 1);
 2d3:	83 ec 04             	sub    $0x4,%esp
 2d6:	6a 01                	push   $0x1
 2d8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2db:	50                   	push   %eax
 2dc:	6a 00                	push   $0x0
 2de:	e8 46 01 00 00       	call   429 <read>
 2e3:	83 c4 10             	add    $0x10,%esp
 2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ed:	7f 02                	jg     2f1 <gets+0x2d>
      break;
 2ef:	eb 31                	jmp    322 <gets+0x5e>
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 13                	je     322 <gets+0x5e>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0b                	je     322 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b1                	jl     2d3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 322:	8b 55 f4             	mov    -0xc(%ebp),%edx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	01 d0                	add    %edx,%eax
 32a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <stat>:

int
stat(char *n, struct stat *st)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	6a 00                	push   $0x0
 33d:	ff 75 08             	pushl  0x8(%ebp)
 340:	e8 0c 01 00 00       	call   451 <open>
 345:	83 c4 10             	add    $0x10,%esp
 348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 34f:	79 07                	jns    358 <stat+0x26>
    return -1;
 351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 356:	eb 25                	jmp    37d <stat+0x4b>
  r = fstat(fd, st);
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	ff 75 0c             	pushl  0xc(%ebp)
 35e:	ff 75 f4             	pushl  -0xc(%ebp)
 361:	e8 03 01 00 00       	call   469 <fstat>
 366:	83 c4 10             	add    $0x10,%esp
 369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36c:	83 ec 0c             	sub    $0xc,%esp
 36f:	ff 75 f4             	pushl  -0xc(%ebp)
 372:	e8 c2 00 00 00       	call   439 <close>
 377:	83 c4 10             	add    $0x10,%esp
  return r;
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 37d:	c9                   	leave  
 37e:	c3                   	ret    

0000037f <atoi>:

int
atoi(const char *s)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38c:	eb 25                	jmp    3b3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 391:	89 d0                	mov    %edx,%eax
 393:	c1 e0 02             	shl    $0x2,%eax
 396:	01 d0                	add    %edx,%eax
 398:	01 c0                	add    %eax,%eax
 39a:	89 c1                	mov    %eax,%ecx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	8d 50 01             	lea    0x1(%eax),%edx
 3a2:	89 55 08             	mov    %edx,0x8(%ebp)
 3a5:	0f b6 00             	movzbl (%eax),%eax
 3a8:	0f be c0             	movsbl %al,%eax
 3ab:	01 c8                	add    %ecx,%eax
 3ad:	83 e8 30             	sub    $0x30,%eax
 3b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	3c 2f                	cmp    $0x2f,%al
 3bb:	7e 0a                	jle    3c7 <atoi+0x48>
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 39                	cmp    $0x39,%al
 3c5:	7e c7                	jle    38e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3de:	eb 17                	jmp    3f7 <memmove+0x2b>
    *dst++ = *src++;
 3e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e3:	8d 50 01             	lea    0x1(%eax),%edx
 3e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ec:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ef:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f2:	0f b6 12             	movzbl (%edx),%edx
 3f5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f7:	8b 45 10             	mov    0x10(%ebp),%eax
 3fa:	8d 50 ff             	lea    -0x1(%eax),%edx
 3fd:	89 55 10             	mov    %edx,0x10(%ebp)
 400:	85 c0                	test   %eax,%eax
 402:	7f dc                	jg     3e0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 404:	8b 45 08             	mov    0x8(%ebp),%eax
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 409:	b8 01 00 00 00       	mov    $0x1,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <exit>:
SYSCALL(exit)
 411:	b8 02 00 00 00       	mov    $0x2,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <wait>:
SYSCALL(wait)
 419:	b8 03 00 00 00       	mov    $0x3,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <pipe>:
SYSCALL(pipe)
 421:	b8 04 00 00 00       	mov    $0x4,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <read>:
SYSCALL(read)
 429:	b8 05 00 00 00       	mov    $0x5,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <write>:
SYSCALL(write)
 431:	b8 10 00 00 00       	mov    $0x10,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <close>:
SYSCALL(close)
 439:	b8 15 00 00 00       	mov    $0x15,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <kill>:
SYSCALL(kill)
 441:	b8 06 00 00 00       	mov    $0x6,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <exec>:
SYSCALL(exec)
 449:	b8 07 00 00 00       	mov    $0x7,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <open>:
SYSCALL(open)
 451:	b8 0f 00 00 00       	mov    $0xf,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <mknod>:
SYSCALL(mknod)
 459:	b8 11 00 00 00       	mov    $0x11,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <unlink>:
SYSCALL(unlink)
 461:	b8 12 00 00 00       	mov    $0x12,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <fstat>:
SYSCALL(fstat)
 469:	b8 08 00 00 00       	mov    $0x8,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <link>:
SYSCALL(link)
 471:	b8 13 00 00 00       	mov    $0x13,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <mkdir>:
SYSCALL(mkdir)
 479:	b8 14 00 00 00       	mov    $0x14,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <chdir>:
SYSCALL(chdir)
 481:	b8 09 00 00 00       	mov    $0x9,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <dup>:
SYSCALL(dup)
 489:	b8 0a 00 00 00       	mov    $0xa,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <getpid>:
SYSCALL(getpid)
 491:	b8 0b 00 00 00       	mov    $0xb,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <sbrk>:
SYSCALL(sbrk)
 499:	b8 0c 00 00 00       	mov    $0xc,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <sleep>:
SYSCALL(sleep)
 4a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <uptime>:
SYSCALL(uptime)
 4a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <procstat>:
SYSCALL(procstat)
 4b1:	b8 16 00 00 00       	mov    $0x16,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <set_priority>:
SYSCALL(set_priority)
 4b9:	b8 17 00 00 00       	mov    $0x17,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <semget>:
SYSCALL(semget)
 4c1:	b8 18 00 00 00       	mov    $0x18,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <semfree>:
SYSCALL(semfree)
 4c9:	b8 19 00 00 00       	mov    $0x19,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <semdown>:
SYSCALL(semdown)
 4d1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <semup>:
 4d9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	83 ec 18             	sub    $0x18,%esp
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	6a 01                	push   $0x1
 4f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f5:	50                   	push   %eax
 4f6:	ff 75 08             	pushl  0x8(%ebp)
 4f9:	e8 33 ff ff ff       	call   431 <write>
 4fe:	83 c4 10             	add    $0x10,%esp
}
 501:	c9                   	leave  
 502:	c3                   	ret    

00000503 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 503:	55                   	push   %ebp
 504:	89 e5                	mov    %esp,%ebp
 506:	53                   	push   %ebx
 507:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 50a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 511:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 515:	74 17                	je     52e <printint+0x2b>
 517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51b:	79 11                	jns    52e <printint+0x2b>
    neg = 1;
 51d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 524:	8b 45 0c             	mov    0xc(%ebp),%eax
 527:	f7 d8                	neg    %eax
 529:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52c:	eb 06                	jmp    534 <printint+0x31>
  } else {
    x = xx;
 52e:	8b 45 0c             	mov    0xc(%ebp),%eax
 531:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 53b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 53e:	8d 41 01             	lea    0x1(%ecx),%eax
 541:	89 45 f4             	mov    %eax,-0xc(%ebp)
 544:	8b 5d 10             	mov    0x10(%ebp),%ebx
 547:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54a:	ba 00 00 00 00       	mov    $0x0,%edx
 54f:	f7 f3                	div    %ebx
 551:	89 d0                	mov    %edx,%eax
 553:	0f b6 80 18 0c 00 00 	movzbl 0xc18(%eax),%eax
 55a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 55e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 561:	8b 45 ec             	mov    -0x14(%ebp),%eax
 564:	ba 00 00 00 00       	mov    $0x0,%edx
 569:	f7 f3                	div    %ebx
 56b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 572:	75 c7                	jne    53b <printint+0x38>
  if(neg)
 574:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 578:	74 0e                	je     588 <printint+0x85>
    buf[i++] = '-';
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	8d 50 01             	lea    0x1(%eax),%edx
 580:	89 55 f4             	mov    %edx,-0xc(%ebp)
 583:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 588:	eb 1d                	jmp    5a7 <printint+0xa4>
    putc(fd, buf[i]);
 58a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 58d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 590:	01 d0                	add    %edx,%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	83 ec 08             	sub    $0x8,%esp
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 3d ff ff ff       	call   4e1 <putc>
 5a4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5af:	79 d9                	jns    58a <printint+0x87>
    putc(fd, buf[i]);
}
 5b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    

000005b6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c3:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c6:	83 c0 04             	add    $0x4,%eax
 5c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d3:	e9 59 01 00 00       	jmp    731 <printf+0x17b>
    c = fmt[i] & 0xff;
 5d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5de:	01 d0                	add    %edx,%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	25 ff 00 00 00       	and    $0xff,%eax
 5eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f2:	75 2c                	jne    620 <printf+0x6a>
      if(c == '%'){
 5f4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f8:	75 0c                	jne    606 <printf+0x50>
        state = '%';
 5fa:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 601:	e9 27 01 00 00       	jmp    72d <printf+0x177>
      } else {
        putc(fd, c);
 606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 609:	0f be c0             	movsbl %al,%eax
 60c:	83 ec 08             	sub    $0x8,%esp
 60f:	50                   	push   %eax
 610:	ff 75 08             	pushl  0x8(%ebp)
 613:	e8 c9 fe ff ff       	call   4e1 <putc>
 618:	83 c4 10             	add    $0x10,%esp
 61b:	e9 0d 01 00 00       	jmp    72d <printf+0x177>
      }
    } else if(state == '%'){
 620:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 624:	0f 85 03 01 00 00    	jne    72d <printf+0x177>
      if(c == 'd'){
 62a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 62e:	75 1e                	jne    64e <printf+0x98>
        printint(fd, *ap, 10, 1);
 630:	8b 45 e8             	mov    -0x18(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	6a 01                	push   $0x1
 637:	6a 0a                	push   $0xa
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 c1 fe ff ff       	call   503 <printint>
 642:	83 c4 10             	add    $0x10,%esp
        ap++;
 645:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 649:	e9 d8 00 00 00       	jmp    726 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 64e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 652:	74 06                	je     65a <printf+0xa4>
 654:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 658:	75 1e                	jne    678 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	6a 00                	push   $0x0
 661:	6a 10                	push   $0x10
 663:	50                   	push   %eax
 664:	ff 75 08             	pushl  0x8(%ebp)
 667:	e8 97 fe ff ff       	call   503 <printint>
 66c:	83 c4 10             	add    $0x10,%esp
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 673:	e9 ae 00 00 00       	jmp    726 <printf+0x170>
      } else if(c == 's'){
 678:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 67c:	75 43                	jne    6c1 <printf+0x10b>
        s = (char*)*ap;
 67e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 686:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 68e:	75 07                	jne    697 <printf+0xe1>
          s = "(null)";
 690:	c7 45 f4 a2 09 00 00 	movl   $0x9a2,-0xc(%ebp)
        while(*s != 0){
 697:	eb 1c                	jmp    6b5 <printf+0xff>
          putc(fd, *s);
 699:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69c:	0f b6 00             	movzbl (%eax),%eax
 69f:	0f be c0             	movsbl %al,%eax
 6a2:	83 ec 08             	sub    $0x8,%esp
 6a5:	50                   	push   %eax
 6a6:	ff 75 08             	pushl  0x8(%ebp)
 6a9:	e8 33 fe ff ff       	call   4e1 <putc>
 6ae:	83 c4 10             	add    $0x10,%esp
          s++;
 6b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	84 c0                	test   %al,%al
 6bd:	75 da                	jne    699 <printf+0xe3>
 6bf:	eb 65                	jmp    726 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c5:	75 1d                	jne    6e4 <printf+0x12e>
        putc(fd, *ap);
 6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	83 ec 08             	sub    $0x8,%esp
 6d2:	50                   	push   %eax
 6d3:	ff 75 08             	pushl  0x8(%ebp)
 6d6:	e8 06 fe ff ff       	call   4e1 <putc>
 6db:	83 c4 10             	add    $0x10,%esp
        ap++;
 6de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e2:	eb 42                	jmp    726 <printf+0x170>
      } else if(c == '%'){
 6e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e8:	75 17                	jne    701 <printf+0x14b>
        putc(fd, c);
 6ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ed:	0f be c0             	movsbl %al,%eax
 6f0:	83 ec 08             	sub    $0x8,%esp
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 e5 fd ff ff       	call   4e1 <putc>
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	eb 25                	jmp    726 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 701:	83 ec 08             	sub    $0x8,%esp
 704:	6a 25                	push   $0x25
 706:	ff 75 08             	pushl  0x8(%ebp)
 709:	e8 d3 fd ff ff       	call   4e1 <putc>
 70e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 714:	0f be c0             	movsbl %al,%eax
 717:	83 ec 08             	sub    $0x8,%esp
 71a:	50                   	push   %eax
 71b:	ff 75 08             	pushl  0x8(%ebp)
 71e:	e8 be fd ff ff       	call   4e1 <putc>
 723:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 726:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 72d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 731:	8b 55 0c             	mov    0xc(%ebp),%edx
 734:	8b 45 f0             	mov    -0x10(%ebp),%eax
 737:	01 d0                	add    %edx,%eax
 739:	0f b6 00             	movzbl (%eax),%eax
 73c:	84 c0                	test   %al,%al
 73e:	0f 85 94 fe ff ff    	jne    5d8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	83 e8 08             	sub    $0x8,%eax
 752:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 755:	a1 48 0c 00 00       	mov    0xc48,%eax
 75a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75d:	eb 24                	jmp    783 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 767:	77 12                	ja     77b <free+0x35>
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76f:	77 24                	ja     795 <free+0x4f>
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	77 1a                	ja     795 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	89 45 fc             	mov    %eax,-0x4(%ebp)
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 789:	76 d4                	jbe    75f <free+0x19>
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 793:	76 ca                	jbe    75f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	01 c2                	add    %eax,%edx
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	39 c2                	cmp    %eax,%edx
 7ae:	75 24                	jne    7d4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	8b 50 04             	mov    0x4(%eax),%edx
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	01 c2                	add    %eax,%edx
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 0a                	jmp    7de <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 10                	mov    (%eax),%edx
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	01 d0                	add    %edx,%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	75 20                	jne    815 <free+0xcf>
    p->s.size += bp->s.size;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 50 04             	mov    0x4(%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	01 c2                	add    %eax,%edx
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 10                	mov    (%eax),%edx
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	89 10                	mov    %edx,(%eax)
 813:	eb 08                	jmp    81d <free+0xd7>
  } else
    p->s.ptr = bp;
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81b:	89 10                	mov    %edx,(%eax)
  freep = p;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 825:	c9                   	leave  
 826:	c3                   	ret    

00000827 <morecore>:

static Header*
morecore(uint nu)
{
 827:	55                   	push   %ebp
 828:	89 e5                	mov    %esp,%ebp
 82a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 82d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 834:	77 07                	ja     83d <morecore+0x16>
    nu = 4096;
 836:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	c1 e0 03             	shl    $0x3,%eax
 843:	83 ec 0c             	sub    $0xc,%esp
 846:	50                   	push   %eax
 847:	e8 4d fc ff ff       	call   499 <sbrk>
 84c:	83 c4 10             	add    $0x10,%esp
 84f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 852:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 856:	75 07                	jne    85f <morecore+0x38>
    return 0;
 858:	b8 00 00 00 00       	mov    $0x0,%eax
 85d:	eb 26                	jmp    885 <morecore+0x5e>
  hp = (Header*)p;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	8b 55 08             	mov    0x8(%ebp),%edx
 86b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	83 c0 08             	add    $0x8,%eax
 874:	83 ec 0c             	sub    $0xc,%esp
 877:	50                   	push   %eax
 878:	e8 c9 fe ff ff       	call   746 <free>
 87d:	83 c4 10             	add    $0x10,%esp
  return freep;
 880:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <malloc>:

void*
malloc(uint nbytes)
{
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	83 c0 07             	add    $0x7,%eax
 893:	c1 e8 03             	shr    $0x3,%eax
 896:	83 c0 01             	add    $0x1,%eax
 899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89c:	a1 48 0c 00 00       	mov    0xc48,%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a8:	75 23                	jne    8cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8aa:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 48 0c 00 00       	mov    %eax,0xc48
 8b9:	a1 48 0c 00 00       	mov    0xc48,%eax
 8be:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8c3:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8de:	72 4d                	jb     92d <malloc+0xa6>
      if(p->s.size == nunits)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e9:	75 0c                	jne    8f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 26                	jmp    91d <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 900:	89 c2                	mov    %eax,%edx
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	eb 3b                	jmp    968 <malloc+0xe1>
    }
    if(p == freep)
 92d:	a1 48 0c 00 00       	mov    0xc48,%eax
 932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 935:	75 1e                	jne    955 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 937:	83 ec 0c             	sub    $0xc,%esp
 93a:	ff 75 ec             	pushl  -0x14(%ebp)
 93d:	e8 e5 fe ff ff       	call   827 <morecore>
 942:	83 c4 10             	add    $0x10,%esp
 945:	89 45 f4             	mov    %eax,-0xc(%ebp)
 948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94c:	75 07                	jne    955 <malloc+0xce>
        return 0;
 94e:	b8 00 00 00 00       	mov    $0x0,%eax
 953:	eb 13                	jmp    968 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 963:	e9 6d ff ff ff       	jmp    8d5 <malloc+0x4e>
}
 968:	c9                   	leave  
 969:	c3                   	ret    
