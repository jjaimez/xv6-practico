
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 ad 00 00 00       	jmp    bf <grep+0xbf>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 4a                	jmp    6b <grep+0x6b>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	pushl  -0x10(%ebp)
  2d:	ff 75 08             	pushl  0x8(%ebp)
  30:	e8 9b 01 00 00       	call   1d0 <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 26                	je     62 <grep+0x62>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	83 c0 01             	add    $0x1,%eax
  48:	89 c2                	mov    %eax,%edx
  4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4d:	29 c2                	sub    %eax,%edx
  4f:	89 d0                	mov    %edx,%eax
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	ff 75 f0             	pushl  -0x10(%ebp)
  58:	6a 01                	push   $0x1
  5a:	e8 42 05 00 00       	call   5a1 <write>
  5f:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  65:	83 c0 01             	add    $0x1,%eax
  68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	6a 0a                	push   $0xa
  70:	ff 75 f0             	pushl  -0x10(%ebp)
  73:	e8 89 03 00 00       	call   401 <strchr>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  82:	75 9d                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  84:	81 7d f0 40 0e 00 00 	cmpl   $0xe40,-0x10(%ebp)
  8b:	75 07                	jne    94 <grep+0x94>
      m = 0;
  8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	7e 25                	jle    bf <grep+0xbf>
      m -= p - buf;
  9a:	ba 40 0e 00 00       	mov    $0xe40,%edx
  9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a2:	29 c2                	sub    %eax,%edx
  a4:	89 d0                	mov    %edx,%eax
  a6:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  a9:	83 ec 04             	sub    $0x4,%esp
  ac:	ff 75 f4             	pushl  -0xc(%ebp)
  af:	ff 75 f0             	pushl  -0x10(%ebp)
  b2:	68 40 0e 00 00       	push   $0xe40
  b7:	e8 80 04 00 00       	call   53c <memmove>
  bc:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c2:	ba 00 04 00 00       	mov    $0x400,%edx
  c7:	29 c2                	sub    %eax,%edx
  c9:	89 d0                	mov    %edx,%eax
  cb:	89 c2                	mov    %eax,%edx
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	05 40 0e 00 00       	add    $0xe40,%eax
  d5:	83 ec 04             	sub    $0x4,%esp
  d8:	52                   	push   %edx
  d9:	50                   	push   %eax
  da:	ff 75 0c             	pushl  0xc(%ebp)
  dd:	e8 b7 04 00 00       	call   599 <read>
  e2:	83 c4 10             	add    $0x10,%esp
  e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ec:	0f 8f 20 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <main>:

int
main(int argc, char *argv[])
{
  f4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f8:	83 e4 f0             	and    $0xfffffff0,%esp
  fb:	ff 71 fc             	pushl  -0x4(%ecx)
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	53                   	push   %ebx
 102:	51                   	push   %ecx
 103:	83 ec 10             	sub    $0x10,%esp
 106:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 108:	83 3b 01             	cmpl   $0x1,(%ebx)
 10b:	7f 17                	jg     124 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10d:	83 ec 08             	sub    $0x8,%esp
 110:	68 dc 0a 00 00       	push   $0xadc
 115:	6a 02                	push   $0x2
 117:	e8 0a 06 00 00       	call   726 <printf>
 11c:	83 c4 10             	add    $0x10,%esp
    exit();
 11f:	e8 5d 04 00 00       	call   581 <exit>
  }
  pattern = argv[1];
 124:	8b 43 04             	mov    0x4(%ebx),%eax
 127:	8b 40 04             	mov    0x4(%eax),%eax
 12a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 12d:	83 3b 02             	cmpl   $0x2,(%ebx)
 130:	7f 15                	jg     147 <main+0x53>
    grep(pattern, 0);
 132:	83 ec 08             	sub    $0x8,%esp
 135:	6a 00                	push   $0x0
 137:	ff 75 f0             	pushl  -0x10(%ebp)
 13a:	e8 c1 fe ff ff       	call   0 <grep>
 13f:	83 c4 10             	add    $0x10,%esp
    exit();
 142:	e8 3a 04 00 00       	call   581 <exit>
  }

  for(i = 2; i < argc; i++){
 147:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 14e:	eb 74                	jmp    1c4 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 150:	8b 45 f4             	mov    -0xc(%ebp),%eax
 153:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15a:	8b 43 04             	mov    0x4(%ebx),%eax
 15d:	01 d0                	add    %edx,%eax
 15f:	8b 00                	mov    (%eax),%eax
 161:	83 ec 08             	sub    $0x8,%esp
 164:	6a 00                	push   $0x0
 166:	50                   	push   %eax
 167:	e8 55 04 00 00       	call   5c1 <open>
 16c:	83 c4 10             	add    $0x10,%esp
 16f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 172:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 176:	79 29                	jns    1a1 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 178:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 182:	8b 43 04             	mov    0x4(%ebx),%eax
 185:	01 d0                	add    %edx,%eax
 187:	8b 00                	mov    (%eax),%eax
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	50                   	push   %eax
 18d:	68 fc 0a 00 00       	push   $0xafc
 192:	6a 01                	push   $0x1
 194:	e8 8d 05 00 00       	call   726 <printf>
 199:	83 c4 10             	add    $0x10,%esp
      exit();
 19c:	e8 e0 03 00 00       	call   581 <exit>
    }
    grep(pattern, fd);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	ff 75 ec             	pushl  -0x14(%ebp)
 1a7:	ff 75 f0             	pushl  -0x10(%ebp)
 1aa:	e8 51 fe ff ff       	call   0 <grep>
 1af:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b2:	83 ec 0c             	sub    $0xc,%esp
 1b5:	ff 75 ec             	pushl  -0x14(%ebp)
 1b8:	e8 ec 03 00 00       	call   5a9 <close>
 1bd:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	3b 03                	cmp    (%ebx),%eax
 1c9:	7c 85                	jl     150 <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1cb:	e8 b1 03 00 00       	call   581 <exit>

000001d0 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	3c 5e                	cmp    $0x5e,%al
 1de:	75 17                	jne    1f7 <match+0x27>
    return matchhere(re+1, text);
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	83 c0 01             	add    $0x1,%eax
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	ff 75 0c             	pushl  0xc(%ebp)
 1ec:	50                   	push   %eax
 1ed:	e8 38 00 00 00       	call   22a <matchhere>
 1f2:	83 c4 10             	add    $0x10,%esp
 1f5:	eb 31                	jmp    228 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	ff 75 0c             	pushl  0xc(%ebp)
 1fd:	ff 75 08             	pushl  0x8(%ebp)
 200:	e8 25 00 00 00       	call   22a <matchhere>
 205:	83 c4 10             	add    $0x10,%esp
 208:	85 c0                	test   %eax,%eax
 20a:	74 07                	je     213 <match+0x43>
      return 1;
 20c:	b8 01 00 00 00       	mov    $0x1,%eax
 211:	eb 15                	jmp    228 <match+0x58>
  }while(*text++ != '\0');
 213:	8b 45 0c             	mov    0xc(%ebp),%eax
 216:	8d 50 01             	lea    0x1(%eax),%edx
 219:	89 55 0c             	mov    %edx,0xc(%ebp)
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 d4                	jne    1f7 <match+0x27>
  return 0;
 223:	b8 00 00 00 00       	mov    $0x0,%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	75 0a                	jne    244 <matchhere+0x1a>
    return 1;
 23a:	b8 01 00 00 00       	mov    $0x1,%eax
 23f:	e9 99 00 00 00       	jmp    2dd <matchhere+0xb3>
  if(re[1] == '*')
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	83 c0 01             	add    $0x1,%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 2a                	cmp    $0x2a,%al
 24f:	75 21                	jne    272 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	8d 50 02             	lea    0x2(%eax),%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	0f be c0             	movsbl %al,%eax
 260:	83 ec 04             	sub    $0x4,%esp
 263:	ff 75 0c             	pushl  0xc(%ebp)
 266:	52                   	push   %edx
 267:	50                   	push   %eax
 268:	e8 72 00 00 00       	call   2df <matchstar>
 26d:	83 c4 10             	add    $0x10,%esp
 270:	eb 6b                	jmp    2dd <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 24                	cmp    $0x24,%al
 27a:	75 1d                	jne    299 <matchhere+0x6f>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	84 c0                	test   %al,%al
 287:	75 10                	jne    299 <matchhere+0x6f>
    return *text == '\0';
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	0f 94 c0             	sete   %al
 294:	0f b6 c0             	movzbl %al,%eax
 297:	eb 44                	jmp    2dd <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	84 c0                	test   %al,%al
 2a1:	74 35                	je     2d8 <matchhere+0xae>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 2e                	cmp    $0x2e,%al
 2ab:	74 10                	je     2bd <matchhere+0x93>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 10             	movzbl (%eax),%edx
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	38 c2                	cmp    %al,%dl
 2bb:	75 1b                	jne    2d8 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	8d 50 01             	lea    0x1(%eax),%edx
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	83 c0 01             	add    $0x1,%eax
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	52                   	push   %edx
 2cd:	50                   	push   %eax
 2ce:	e8 57 ff ff ff       	call   22a <matchhere>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	eb 05                	jmp    2dd <matchhere+0xb3>
  return 0;
 2d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	ff 75 10             	pushl  0x10(%ebp)
 2eb:	ff 75 0c             	pushl  0xc(%ebp)
 2ee:	e8 37 ff ff ff       	call   22a <matchhere>
 2f3:	83 c4 10             	add    $0x10,%esp
 2f6:	85 c0                	test   %eax,%eax
 2f8:	74 07                	je     301 <matchstar+0x22>
      return 1;
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	eb 29                	jmp    32a <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 301:	8b 45 10             	mov    0x10(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	84 c0                	test   %al,%al
 309:	74 1a                	je     325 <matchstar+0x46>
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	8d 50 01             	lea    0x1(%eax),%edx
 311:	89 55 10             	mov    %edx,0x10(%ebp)
 314:	0f b6 00             	movzbl (%eax),%eax
 317:	0f be c0             	movsbl %al,%eax
 31a:	3b 45 08             	cmp    0x8(%ebp),%eax
 31d:	74 c6                	je     2e5 <matchstar+0x6>
 31f:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 323:	74 c0                	je     2e5 <matchstar+0x6>
  return 0;
 325:	b8 00 00 00 00       	mov    $0x0,%eax
}
 32a:	c9                   	leave  
 32b:	c3                   	ret    

0000032c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	57                   	push   %edi
 330:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 331:	8b 4d 08             	mov    0x8(%ebp),%ecx
 334:	8b 55 10             	mov    0x10(%ebp),%edx
 337:	8b 45 0c             	mov    0xc(%ebp),%eax
 33a:	89 cb                	mov    %ecx,%ebx
 33c:	89 df                	mov    %ebx,%edi
 33e:	89 d1                	mov    %edx,%ecx
 340:	fc                   	cld    
 341:	f3 aa                	rep stos %al,%es:(%edi)
 343:	89 ca                	mov    %ecx,%edx
 345:	89 fb                	mov    %edi,%ebx
 347:	89 5d 08             	mov    %ebx,0x8(%ebp)
 34a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34d:	5b                   	pop    %ebx
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    

00000351 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35d:	90                   	nop
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 50 01             	lea    0x1(%eax),%edx
 364:	89 55 08             	mov    %edx,0x8(%ebp)
 367:	8b 55 0c             	mov    0xc(%ebp),%edx
 36a:	8d 4a 01             	lea    0x1(%edx),%ecx
 36d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	84 c0                	test   %al,%al
 37a:	75 e2                	jne    35e <strcpy+0xd>
    ;
  return os;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 384:	eb 08                	jmp    38e <strcmp+0xd>
    p++, q++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	74 10                	je     3a8 <strcmp+0x27>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 10             	movzbl (%eax),%edx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	38 c2                	cmp    %al,%dl
 3a6:	74 de                	je     386 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 d0             	movzbl %al,%edx
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	0f b6 c0             	movzbl %al,%eax
 3ba:	29 c2                	sub    %eax,%edx
 3bc:	89 d0                	mov    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cd:	eb 04                	jmp    3d3 <strlen+0x13>
 3cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	84 c0                	test   %al,%al
 3e0:	75 ed                	jne    3cf <strlen+0xf>
    ;
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ea:	8b 45 10             	mov    0x10(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 0c             	pushl  0xc(%ebp)
 3f1:	ff 75 08             	pushl  0x8(%ebp)
 3f4:	e8 33 ff ff ff       	call   32c <stosb>
 3f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <strchr>:

char*
strchr(const char *s, char c)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	83 ec 04             	sub    $0x4,%esp
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 40d:	eb 14                	jmp    423 <strchr+0x22>
    if(*s == c)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	3a 45 fc             	cmp    -0x4(%ebp),%al
 418:	75 05                	jne    41f <strchr+0x1e>
      return (char*)s;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	eb 13                	jmp    432 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 41f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 e2                	jne    40f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 44                	jmp    487 <gets+0x53>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 46 01 00 00       	call   599 <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7f 02                	jg     461 <gets+0x2d>
      break;
 45f:	eb 31                	jmp    492 <gets+0x5e>
    buf[i++] = c;
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	8d 50 01             	lea    0x1(%eax),%edx
 467:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46a:	89 c2                	mov    %eax,%edx
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	01 c2                	add    %eax,%edx
 471:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 475:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 477:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47b:	3c 0a                	cmp    $0xa,%al
 47d:	74 13                	je     492 <gets+0x5e>
 47f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 483:	3c 0d                	cmp    $0xd,%al
 485:	74 0b                	je     492 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 487:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48a:	83 c0 01             	add    $0x1,%eax
 48d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 490:	7c b1                	jl     443 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 492:	8b 55 f4             	mov    -0xc(%ebp),%edx
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	01 d0                	add    %edx,%eax
 49a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <stat>:

int
stat(char *n, struct stat *st)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a8:	83 ec 08             	sub    $0x8,%esp
 4ab:	6a 00                	push   $0x0
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 0c 01 00 00       	call   5c1 <open>
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bf:	79 07                	jns    4c8 <stat+0x26>
    return -1;
 4c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c6:	eb 25                	jmp    4ed <stat+0x4b>
  r = fstat(fd, st);
 4c8:	83 ec 08             	sub    $0x8,%esp
 4cb:	ff 75 0c             	pushl  0xc(%ebp)
 4ce:	ff 75 f4             	pushl  -0xc(%ebp)
 4d1:	e8 03 01 00 00       	call   5d9 <fstat>
 4d6:	83 c4 10             	add    $0x10,%esp
 4d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4dc:	83 ec 0c             	sub    $0xc,%esp
 4df:	ff 75 f4             	pushl  -0xc(%ebp)
 4e2:	e8 c2 00 00 00       	call   5a9 <close>
 4e7:	83 c4 10             	add    $0x10,%esp
  return r;
 4ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <atoi>:

int
atoi(const char *s)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4fc:	eb 25                	jmp    523 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 501:	89 d0                	mov    %edx,%eax
 503:	c1 e0 02             	shl    $0x2,%eax
 506:	01 d0                	add    %edx,%eax
 508:	01 c0                	add    %eax,%eax
 50a:	89 c1                	mov    %eax,%ecx
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	8d 50 01             	lea    0x1(%eax),%edx
 512:	89 55 08             	mov    %edx,0x8(%ebp)
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	01 c8                	add    %ecx,%eax
 51d:	83 e8 30             	sub    $0x30,%eax
 520:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	0f b6 00             	movzbl (%eax),%eax
 529:	3c 2f                	cmp    $0x2f,%al
 52b:	7e 0a                	jle    537 <atoi+0x48>
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	3c 39                	cmp    $0x39,%al
 535:	7e c7                	jle    4fe <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 537:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53a:	c9                   	leave  
 53b:	c3                   	ret    

0000053c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54e:	eb 17                	jmp    567 <memmove+0x2b>
    *dst++ = *src++;
 550:	8b 45 fc             	mov    -0x4(%ebp),%eax
 553:	8d 50 01             	lea    0x1(%eax),%edx
 556:	89 55 fc             	mov    %edx,-0x4(%ebp)
 559:	8b 55 f8             	mov    -0x8(%ebp),%edx
 55c:	8d 4a 01             	lea    0x1(%edx),%ecx
 55f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 562:	0f b6 12             	movzbl (%edx),%edx
 565:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 567:	8b 45 10             	mov    0x10(%ebp),%eax
 56a:	8d 50 ff             	lea    -0x1(%eax),%edx
 56d:	89 55 10             	mov    %edx,0x10(%ebp)
 570:	85 c0                	test   %eax,%eax
 572:	7f dc                	jg     550 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 574:	8b 45 08             	mov    0x8(%ebp),%eax
}
 577:	c9                   	leave  
 578:	c3                   	ret    

00000579 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 579:	b8 01 00 00 00       	mov    $0x1,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <exit>:
SYSCALL(exit)
 581:	b8 02 00 00 00       	mov    $0x2,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <wait>:
SYSCALL(wait)
 589:	b8 03 00 00 00       	mov    $0x3,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <pipe>:
SYSCALL(pipe)
 591:	b8 04 00 00 00       	mov    $0x4,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <read>:
SYSCALL(read)
 599:	b8 05 00 00 00       	mov    $0x5,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <write>:
SYSCALL(write)
 5a1:	b8 10 00 00 00       	mov    $0x10,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <close>:
SYSCALL(close)
 5a9:	b8 15 00 00 00       	mov    $0x15,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <kill>:
SYSCALL(kill)
 5b1:	b8 06 00 00 00       	mov    $0x6,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <exec>:
SYSCALL(exec)
 5b9:	b8 07 00 00 00       	mov    $0x7,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <open>:
SYSCALL(open)
 5c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <mknod>:
SYSCALL(mknod)
 5c9:	b8 11 00 00 00       	mov    $0x11,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <unlink>:
SYSCALL(unlink)
 5d1:	b8 12 00 00 00       	mov    $0x12,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <fstat>:
SYSCALL(fstat)
 5d9:	b8 08 00 00 00       	mov    $0x8,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <link>:
SYSCALL(link)
 5e1:	b8 13 00 00 00       	mov    $0x13,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <mkdir>:
SYSCALL(mkdir)
 5e9:	b8 14 00 00 00       	mov    $0x14,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <chdir>:
SYSCALL(chdir)
 5f1:	b8 09 00 00 00       	mov    $0x9,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <dup>:
SYSCALL(dup)
 5f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <getpid>:
SYSCALL(getpid)
 601:	b8 0b 00 00 00       	mov    $0xb,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <sbrk>:
SYSCALL(sbrk)
 609:	b8 0c 00 00 00       	mov    $0xc,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <sleep>:
SYSCALL(sleep)
 611:	b8 0d 00 00 00       	mov    $0xd,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <uptime>:
SYSCALL(uptime)
 619:	b8 0e 00 00 00       	mov    $0xe,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <procstat>:
SYSCALL(procstat)
 621:	b8 16 00 00 00       	mov    $0x16,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <set_priority>:
SYSCALL(set_priority)
 629:	b8 17 00 00 00       	mov    $0x17,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <semget>:
SYSCALL(semget)
 631:	b8 18 00 00 00       	mov    $0x18,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <semfree>:
SYSCALL(semfree)
 639:	b8 19 00 00 00       	mov    $0x19,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <semdown>:
SYSCALL(semdown)
 641:	b8 1a 00 00 00       	mov    $0x1a,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <semup>:
 649:	b8 1b 00 00 00       	mov    $0x1b,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 651:	55                   	push   %ebp
 652:	89 e5                	mov    %esp,%ebp
 654:	83 ec 18             	sub    $0x18,%esp
 657:	8b 45 0c             	mov    0xc(%ebp),%eax
 65a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 65d:	83 ec 04             	sub    $0x4,%esp
 660:	6a 01                	push   $0x1
 662:	8d 45 f4             	lea    -0xc(%ebp),%eax
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 33 ff ff ff       	call   5a1 <write>
 66e:	83 c4 10             	add    $0x10,%esp
}
 671:	c9                   	leave  
 672:	c3                   	ret    

00000673 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	53                   	push   %ebx
 677:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 67a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 681:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 685:	74 17                	je     69e <printint+0x2b>
 687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 68b:	79 11                	jns    69e <printint+0x2b>
    neg = 1;
 68d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 694:	8b 45 0c             	mov    0xc(%ebp),%eax
 697:	f7 d8                	neg    %eax
 699:	89 45 ec             	mov    %eax,-0x14(%ebp)
 69c:	eb 06                	jmp    6a4 <printint+0x31>
  } else {
    x = xx;
 69e:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6ae:	8d 41 01             	lea    0x1(%ecx),%eax
 6b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ba:	ba 00 00 00 00       	mov    $0x0,%edx
 6bf:	f7 f3                	div    %ebx
 6c1:	89 d0                	mov    %edx,%eax
 6c3:	0f b6 80 e8 0d 00 00 	movzbl 0xde8(%eax),%eax
 6ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d4:	ba 00 00 00 00       	mov    $0x0,%edx
 6d9:	f7 f3                	div    %ebx
 6db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e2:	75 c7                	jne    6ab <printint+0x38>
  if(neg)
 6e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e8:	74 0e                	je     6f8 <printint+0x85>
    buf[i++] = '-';
 6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ed:	8d 50 01             	lea    0x1(%eax),%edx
 6f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6f8:	eb 1d                	jmp    717 <printint+0xa4>
    putc(fd, buf[i]);
 6fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	01 d0                	add    %edx,%eax
 702:	0f b6 00             	movzbl (%eax),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	50                   	push   %eax
 70c:	ff 75 08             	pushl  0x8(%ebp)
 70f:	e8 3d ff ff ff       	call   651 <putc>
 714:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 717:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 71b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71f:	79 d9                	jns    6fa <printint+0x87>
    putc(fd, buf[i]);
}
 721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 724:	c9                   	leave  
 725:	c3                   	ret    

00000726 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 726:	55                   	push   %ebp
 727:	89 e5                	mov    %esp,%ebp
 729:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 72c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 733:	8d 45 0c             	lea    0xc(%ebp),%eax
 736:	83 c0 04             	add    $0x4,%eax
 739:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 73c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 743:	e9 59 01 00 00       	jmp    8a1 <printf+0x17b>
    c = fmt[i] & 0xff;
 748:	8b 55 0c             	mov    0xc(%ebp),%edx
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	01 d0                	add    %edx,%eax
 750:	0f b6 00             	movzbl (%eax),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	25 ff 00 00 00       	and    $0xff,%eax
 75b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 75e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 762:	75 2c                	jne    790 <printf+0x6a>
      if(c == '%'){
 764:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 768:	75 0c                	jne    776 <printf+0x50>
        state = '%';
 76a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 771:	e9 27 01 00 00       	jmp    89d <printf+0x177>
      } else {
        putc(fd, c);
 776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 779:	0f be c0             	movsbl %al,%eax
 77c:	83 ec 08             	sub    $0x8,%esp
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 c9 fe ff ff       	call   651 <putc>
 788:	83 c4 10             	add    $0x10,%esp
 78b:	e9 0d 01 00 00       	jmp    89d <printf+0x177>
      }
    } else if(state == '%'){
 790:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 794:	0f 85 03 01 00 00    	jne    89d <printf+0x177>
      if(c == 'd'){
 79a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 79e:	75 1e                	jne    7be <printf+0x98>
        printint(fd, *ap, 10, 1);
 7a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	6a 01                	push   $0x1
 7a7:	6a 0a                	push   $0xa
 7a9:	50                   	push   %eax
 7aa:	ff 75 08             	pushl  0x8(%ebp)
 7ad:	e8 c1 fe ff ff       	call   673 <printint>
 7b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b9:	e9 d8 00 00 00       	jmp    896 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7be:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7c2:	74 06                	je     7ca <printf+0xa4>
 7c4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7c8:	75 1e                	jne    7e8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	6a 00                	push   $0x0
 7d1:	6a 10                	push   $0x10
 7d3:	50                   	push   %eax
 7d4:	ff 75 08             	pushl  0x8(%ebp)
 7d7:	e8 97 fe ff ff       	call   673 <printint>
 7dc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e3:	e9 ae 00 00 00       	jmp    896 <printf+0x170>
      } else if(c == 's'){
 7e8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7ec:	75 43                	jne    831 <printf+0x10b>
        s = (char*)*ap;
 7ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fe:	75 07                	jne    807 <printf+0xe1>
          s = "(null)";
 800:	c7 45 f4 12 0b 00 00 	movl   $0xb12,-0xc(%ebp)
        while(*s != 0){
 807:	eb 1c                	jmp    825 <printf+0xff>
          putc(fd, *s);
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	0f b6 00             	movzbl (%eax),%eax
 80f:	0f be c0             	movsbl %al,%eax
 812:	83 ec 08             	sub    $0x8,%esp
 815:	50                   	push   %eax
 816:	ff 75 08             	pushl  0x8(%ebp)
 819:	e8 33 fe ff ff       	call   651 <putc>
 81e:	83 c4 10             	add    $0x10,%esp
          s++;
 821:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	0f b6 00             	movzbl (%eax),%eax
 82b:	84 c0                	test   %al,%al
 82d:	75 da                	jne    809 <printf+0xe3>
 82f:	eb 65                	jmp    896 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 831:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 835:	75 1d                	jne    854 <printf+0x12e>
        putc(fd, *ap);
 837:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	0f be c0             	movsbl %al,%eax
 83f:	83 ec 08             	sub    $0x8,%esp
 842:	50                   	push   %eax
 843:	ff 75 08             	pushl  0x8(%ebp)
 846:	e8 06 fe ff ff       	call   651 <putc>
 84b:	83 c4 10             	add    $0x10,%esp
        ap++;
 84e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 852:	eb 42                	jmp    896 <printf+0x170>
      } else if(c == '%'){
 854:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 858:	75 17                	jne    871 <printf+0x14b>
        putc(fd, c);
 85a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85d:	0f be c0             	movsbl %al,%eax
 860:	83 ec 08             	sub    $0x8,%esp
 863:	50                   	push   %eax
 864:	ff 75 08             	pushl  0x8(%ebp)
 867:	e8 e5 fd ff ff       	call   651 <putc>
 86c:	83 c4 10             	add    $0x10,%esp
 86f:	eb 25                	jmp    896 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 871:	83 ec 08             	sub    $0x8,%esp
 874:	6a 25                	push   $0x25
 876:	ff 75 08             	pushl  0x8(%ebp)
 879:	e8 d3 fd ff ff       	call   651 <putc>
 87e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 884:	0f be c0             	movsbl %al,%eax
 887:	83 ec 08             	sub    $0x8,%esp
 88a:	50                   	push   %eax
 88b:	ff 75 08             	pushl  0x8(%ebp)
 88e:	e8 be fd ff ff       	call   651 <putc>
 893:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 896:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 89d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	01 d0                	add    %edx,%eax
 8a9:	0f b6 00             	movzbl (%eax),%eax
 8ac:	84 c0                	test   %al,%al
 8ae:	0f 85 94 fe ff ff    	jne    748 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    

000008b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b6:	55                   	push   %ebp
 8b7:	89 e5                	mov    %esp,%ebp
 8b9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8bc:	8b 45 08             	mov    0x8(%ebp),%eax
 8bf:	83 e8 08             	sub    $0x8,%eax
 8c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c5:	a1 08 0e 00 00       	mov    0xe08,%eax
 8ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8cd:	eb 24                	jmp    8f3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d7:	77 12                	ja     8eb <free+0x35>
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8df:	77 24                	ja     905 <free+0x4f>
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e9:	77 1a                	ja     905 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f9:	76 d4                	jbe    8cf <free+0x19>
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 903:	76 ca                	jbe    8cf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	8b 40 04             	mov    0x4(%eax),%eax
 90b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	01 c2                	add    %eax,%edx
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	39 c2                	cmp    %eax,%edx
 91e:	75 24                	jne    944 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	8b 50 04             	mov    0x4(%eax),%edx
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	8b 00                	mov    (%eax),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	01 c2                	add    %eax,%edx
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	8b 10                	mov    (%eax),%edx
 93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 940:	89 10                	mov    %edx,(%eax)
 942:	eb 0a                	jmp    94e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 10                	mov    (%eax),%edx
 949:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8b 40 04             	mov    0x4(%eax),%eax
 954:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95e:	01 d0                	add    %edx,%eax
 960:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 963:	75 20                	jne    985 <free+0xcf>
    p->s.size += bp->s.size;
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 50 04             	mov    0x4(%eax),%edx
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	8b 40 04             	mov    0x4(%eax),%eax
 971:	01 c2                	add    %eax,%edx
 973:	8b 45 fc             	mov    -0x4(%ebp),%eax
 976:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 979:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97c:	8b 10                	mov    (%eax),%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	89 10                	mov    %edx,(%eax)
 983:	eb 08                	jmp    98d <free+0xd7>
  } else
    p->s.ptr = bp;
 985:	8b 45 fc             	mov    -0x4(%ebp),%eax
 988:	8b 55 f8             	mov    -0x8(%ebp),%edx
 98b:	89 10                	mov    %edx,(%eax)
  freep = p;
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 995:	c9                   	leave  
 996:	c3                   	ret    

00000997 <morecore>:

static Header*
morecore(uint nu)
{
 997:	55                   	push   %ebp
 998:	89 e5                	mov    %esp,%ebp
 99a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 99d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9a4:	77 07                	ja     9ad <morecore+0x16>
    nu = 4096;
 9a6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9ad:	8b 45 08             	mov    0x8(%ebp),%eax
 9b0:	c1 e0 03             	shl    $0x3,%eax
 9b3:	83 ec 0c             	sub    $0xc,%esp
 9b6:	50                   	push   %eax
 9b7:	e8 4d fc ff ff       	call   609 <sbrk>
 9bc:	83 c4 10             	add    $0x10,%esp
 9bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9c6:	75 07                	jne    9cf <morecore+0x38>
    return 0;
 9c8:	b8 00 00 00 00       	mov    $0x0,%eax
 9cd:	eb 26                	jmp    9f5 <morecore+0x5e>
  hp = (Header*)p;
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d8:	8b 55 08             	mov    0x8(%ebp),%edx
 9db:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	83 c0 08             	add    $0x8,%eax
 9e4:	83 ec 0c             	sub    $0xc,%esp
 9e7:	50                   	push   %eax
 9e8:	e8 c9 fe ff ff       	call   8b6 <free>
 9ed:	83 c4 10             	add    $0x10,%esp
  return freep;
 9f0:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 9f5:	c9                   	leave  
 9f6:	c3                   	ret    

000009f7 <malloc>:

void*
malloc(uint nbytes)
{
 9f7:	55                   	push   %ebp
 9f8:	89 e5                	mov    %esp,%ebp
 9fa:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	83 c0 07             	add    $0x7,%eax
 a03:	c1 e8 03             	shr    $0x3,%eax
 a06:	83 c0 01             	add    $0x1,%eax
 a09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a0c:	a1 08 0e 00 00       	mov    0xe08,%eax
 a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a18:	75 23                	jne    a3d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a1a:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a24:	a3 08 0e 00 00       	mov    %eax,0xe08
 a29:	a1 08 0e 00 00       	mov    0xe08,%eax
 a2e:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a33:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a3a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a40:	8b 00                	mov    (%eax),%eax
 a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8b 40 04             	mov    0x4(%eax),%eax
 a4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4e:	72 4d                	jb     a9d <malloc+0xa6>
      if(p->s.size == nunits)
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 40 04             	mov    0x4(%eax),%eax
 a56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a59:	75 0c                	jne    a67 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 10                	mov    (%eax),%edx
 a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a63:	89 10                	mov    %edx,(%eax)
 a65:	eb 26                	jmp    a8d <malloc+0x96>
      else {
        p->s.size -= nunits;
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8b 40 04             	mov    0x4(%eax),%eax
 a6d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a70:	89 c2                	mov    %eax,%edx
 a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a75:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	8b 40 04             	mov    0x4(%eax),%eax
 a7e:	c1 e0 03             	shl    $0x3,%eax
 a81:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a8a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a90:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a98:	83 c0 08             	add    $0x8,%eax
 a9b:	eb 3b                	jmp    ad8 <malloc+0xe1>
    }
    if(p == freep)
 a9d:	a1 08 0e 00 00       	mov    0xe08,%eax
 aa2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aa5:	75 1e                	jne    ac5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 aa7:	83 ec 0c             	sub    $0xc,%esp
 aaa:	ff 75 ec             	pushl  -0x14(%ebp)
 aad:	e8 e5 fe ff ff       	call   997 <morecore>
 ab2:	83 c4 10             	add    $0x10,%esp
 ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 abc:	75 07                	jne    ac5 <malloc+0xce>
        return 0;
 abe:	b8 00 00 00 00       	mov    $0x0,%eax
 ac3:	eb 13                	jmp    ad8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	8b 00                	mov    (%eax),%eax
 ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ad3:	e9 6d ff ff ff       	jmp    a45 <malloc+0x4e>
}
 ad8:	c9                   	leave  
 ad9:	c3                   	ret    
