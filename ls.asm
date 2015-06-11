
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c8 03 00 00       	call   3da <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 94 03 00 00       	call   3da <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7c 03 00 00       	call   3da <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 fc 0d 00 00       	push   $0xdfc
  6d:	e8 e4 04 00 00       	call   556 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5a 03 00 00       	call   3da <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 43 03 00 00       	call   3da <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 fc 0d 00 00       	add    $0xdfc,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 56 03 00 00       	call   401 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 fc 0d 00 00       	mov    $0xdfc,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 0a 05 00 00       	call   5db <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 f4 0a 00 00       	push   $0xaf4
  e8:	6a 02                	push   $0x2
  ea:	e8 51 06 00 00       	call   740 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 ea 04 00 00       	call   5f3 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 08 0b 00 00       	push   $0xb08
 11b:	6a 02                	push   $0x2
 11d:	e8 1e 06 00 00       	call   740 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 93 04 00 00       	call   5c3 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 1c 0b 00 00       	push   $0xb1c
 17e:	6a 01                	push   $0x1
 180:	e8 bb 05 00 00       	call   740 <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 42 02 00 00       	call   3da <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 29 0b 00 00       	push   $0xb29
 1ad:	6a 01                	push   $0x1
 1af:	e8 8c 05 00 00       	call   740 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9d 01 00 00       	call   36b <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fa 01 00 00       	call   3da <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 2d 03 00 00       	call   556 <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 71 02 00 00       	call   4bc <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 08 0b 00 00       	push   $0xb08
 261:	6a 01                	push   $0x1
 263:	e8 d8 04 00 00       	call   740 <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 1c 0b 00 00       	push   $0xb1c
 2a1:	6a 01                	push   $0x1
 2a3:	e8 98 04 00 00       	call   740 <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 f4 02 00 00       	call   5b3 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 ec 02 00 00       	call   5c3 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 3c 0b 00 00       	push   $0xb3c
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 8b 02 00 00       	call   59b <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 55 02 00 00       	call   59b <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	5b                   	pop    %ebx
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 377:	90                   	nop
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 08             	mov    %edx,0x8(%ebp)
 381:	8b 55 0c             	mov    0xc(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	84 c0                	test   %al,%al
 394:	75 e2                	jne    378 <strcpy+0xd>
    ;
  return os;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39e:	eb 08                	jmp    3a8 <strcmp+0xd>
    p++, q++;
 3a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	84 c0                	test   %al,%al
 3b0:	74 10                	je     3c2 <strcmp+0x27>
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	0f b6 10             	movzbl (%eax),%edx
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	38 c2                	cmp    %al,%dl
 3c0:	74 de                	je     3a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	0f b6 d0             	movzbl %al,%edx
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	0f b6 c0             	movzbl %al,%eax
 3d4:	29 c2                	sub    %eax,%edx
 3d6:	89 d0                	mov    %edx,%eax
}
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    

000003da <strlen>:

uint
strlen(char *s)
{
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e7:	eb 04                	jmp    3ed <strlen+0x13>
 3e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	01 d0                	add    %edx,%eax
 3f5:	0f b6 00             	movzbl (%eax),%eax
 3f8:	84 c0                	test   %al,%al
 3fa:	75 ed                	jne    3e9 <strlen+0xf>
    ;
  return n;
 3fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <memset>:

void*
memset(void *dst, int c, uint n)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 404:	8b 45 10             	mov    0x10(%ebp),%eax
 407:	50                   	push   %eax
 408:	ff 75 0c             	pushl  0xc(%ebp)
 40b:	ff 75 08             	pushl  0x8(%ebp)
 40e:	e8 33 ff ff ff       	call   346 <stosb>
 413:	83 c4 0c             	add    $0xc,%esp
  return dst;
 416:	8b 45 08             	mov    0x8(%ebp),%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <strchr>:

char*
strchr(const char *s, char c)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 04             	sub    $0x4,%esp
 421:	8b 45 0c             	mov    0xc(%ebp),%eax
 424:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 427:	eb 14                	jmp    43d <strchr+0x22>
    if(*s == c)
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 432:	75 05                	jne    439 <strchr+0x1e>
      return (char*)s;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	eb 13                	jmp    44c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 439:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	84 c0                	test   %al,%al
 445:	75 e2                	jne    429 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 447:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <gets>:

char*
gets(char *buf, int max)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45b:	eb 44                	jmp    4a1 <gets+0x53>
    cc = read(0, &c, 1);
 45d:	83 ec 04             	sub    $0x4,%esp
 460:	6a 01                	push   $0x1
 462:	8d 45 ef             	lea    -0x11(%ebp),%eax
 465:	50                   	push   %eax
 466:	6a 00                	push   $0x0
 468:	e8 46 01 00 00       	call   5b3 <read>
 46d:	83 c4 10             	add    $0x10,%esp
 470:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 477:	7f 02                	jg     47b <gets+0x2d>
      break;
 479:	eb 31                	jmp    4ac <gets+0x5e>
    buf[i++] = c;
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	8d 50 01             	lea    0x1(%eax),%edx
 481:	89 55 f4             	mov    %edx,-0xc(%ebp)
 484:	89 c2                	mov    %eax,%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	01 c2                	add    %eax,%edx
 48b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 491:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 495:	3c 0a                	cmp    $0xa,%al
 497:	74 13                	je     4ac <gets+0x5e>
 499:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49d:	3c 0d                	cmp    $0xd,%al
 49f:	74 0b                	je     4ac <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a4:	83 c0 01             	add    $0x1,%eax
 4a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4aa:	7c b1                	jl     45d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    

000004bc <stat>:

int
stat(char *n, struct stat *st)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c2:	83 ec 08             	sub    $0x8,%esp
 4c5:	6a 00                	push   $0x0
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 0c 01 00 00       	call   5db <open>
 4cf:	83 c4 10             	add    $0x10,%esp
 4d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d9:	79 07                	jns    4e2 <stat+0x26>
    return -1;
 4db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e0:	eb 25                	jmp    507 <stat+0x4b>
  r = fstat(fd, st);
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	ff 75 0c             	pushl  0xc(%ebp)
 4e8:	ff 75 f4             	pushl  -0xc(%ebp)
 4eb:	e8 03 01 00 00       	call   5f3 <fstat>
 4f0:	83 c4 10             	add    $0x10,%esp
 4f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f6:	83 ec 0c             	sub    $0xc,%esp
 4f9:	ff 75 f4             	pushl  -0xc(%ebp)
 4fc:	e8 c2 00 00 00       	call   5c3 <close>
 501:	83 c4 10             	add    $0x10,%esp
  return r;
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <atoi>:

int
atoi(const char *s)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 516:	eb 25                	jmp    53d <atoi+0x34>
    n = n*10 + *s++ - '0';
 518:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51b:	89 d0                	mov    %edx,%eax
 51d:	c1 e0 02             	shl    $0x2,%eax
 520:	01 d0                	add    %edx,%eax
 522:	01 c0                	add    %eax,%eax
 524:	89 c1                	mov    %eax,%ecx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 55 08             	mov    %edx,0x8(%ebp)
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	01 c8                	add    %ecx,%eax
 537:	83 e8 30             	sub    $0x30,%eax
 53a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	3c 2f                	cmp    $0x2f,%al
 545:	7e 0a                	jle    551 <atoi+0x48>
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	3c 39                	cmp    $0x39,%al
 54f:	7e c7                	jle    518 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 554:	c9                   	leave  
 555:	c3                   	ret    

00000556 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 562:	8b 45 0c             	mov    0xc(%ebp),%eax
 565:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 568:	eb 17                	jmp    581 <memmove+0x2b>
    *dst++ = *src++;
 56a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56d:	8d 50 01             	lea    0x1(%eax),%edx
 570:	89 55 fc             	mov    %edx,-0x4(%ebp)
 573:	8b 55 f8             	mov    -0x8(%ebp),%edx
 576:	8d 4a 01             	lea    0x1(%edx),%ecx
 579:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 57c:	0f b6 12             	movzbl (%edx),%edx
 57f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 581:	8b 45 10             	mov    0x10(%ebp),%eax
 584:	8d 50 ff             	lea    -0x1(%eax),%edx
 587:	89 55 10             	mov    %edx,0x10(%ebp)
 58a:	85 c0                	test   %eax,%eax
 58c:	7f dc                	jg     56a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 591:	c9                   	leave  
 592:	c3                   	ret    

00000593 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 593:	b8 01 00 00 00       	mov    $0x1,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <exit>:
SYSCALL(exit)
 59b:	b8 02 00 00 00       	mov    $0x2,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <wait>:
SYSCALL(wait)
 5a3:	b8 03 00 00 00       	mov    $0x3,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <pipe>:
SYSCALL(pipe)
 5ab:	b8 04 00 00 00       	mov    $0x4,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <read>:
SYSCALL(read)
 5b3:	b8 05 00 00 00       	mov    $0x5,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <write>:
SYSCALL(write)
 5bb:	b8 10 00 00 00       	mov    $0x10,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <close>:
SYSCALL(close)
 5c3:	b8 15 00 00 00       	mov    $0x15,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <kill>:
SYSCALL(kill)
 5cb:	b8 06 00 00 00       	mov    $0x6,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <exec>:
SYSCALL(exec)
 5d3:	b8 07 00 00 00       	mov    $0x7,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <open>:
SYSCALL(open)
 5db:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <mknod>:
SYSCALL(mknod)
 5e3:	b8 11 00 00 00       	mov    $0x11,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <unlink>:
SYSCALL(unlink)
 5eb:	b8 12 00 00 00       	mov    $0x12,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <fstat>:
SYSCALL(fstat)
 5f3:	b8 08 00 00 00       	mov    $0x8,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <link>:
SYSCALL(link)
 5fb:	b8 13 00 00 00       	mov    $0x13,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <mkdir>:
SYSCALL(mkdir)
 603:	b8 14 00 00 00       	mov    $0x14,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <chdir>:
SYSCALL(chdir)
 60b:	b8 09 00 00 00       	mov    $0x9,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <dup>:
SYSCALL(dup)
 613:	b8 0a 00 00 00       	mov    $0xa,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getpid>:
SYSCALL(getpid)
 61b:	b8 0b 00 00 00       	mov    $0xb,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <sbrk>:
SYSCALL(sbrk)
 623:	b8 0c 00 00 00       	mov    $0xc,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sleep>:
SYSCALL(sleep)
 62b:	b8 0d 00 00 00       	mov    $0xd,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <uptime>:
SYSCALL(uptime)
 633:	b8 0e 00 00 00       	mov    $0xe,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <procstat>:
SYSCALL(procstat)
 63b:	b8 16 00 00 00       	mov    $0x16,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <set_priority>:
SYSCALL(set_priority)
 643:	b8 17 00 00 00       	mov    $0x17,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <semget>:
SYSCALL(semget)
 64b:	b8 18 00 00 00       	mov    $0x18,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <semfree>:
SYSCALL(semfree)
 653:	b8 19 00 00 00       	mov    $0x19,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <semdown>:
SYSCALL(semdown)
 65b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <semup>:
 663:	b8 1b 00 00 00       	mov    $0x1b,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 66b:	55                   	push   %ebp
 66c:	89 e5                	mov    %esp,%ebp
 66e:	83 ec 18             	sub    $0x18,%esp
 671:	8b 45 0c             	mov    0xc(%ebp),%eax
 674:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 677:	83 ec 04             	sub    $0x4,%esp
 67a:	6a 01                	push   $0x1
 67c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 67f:	50                   	push   %eax
 680:	ff 75 08             	pushl  0x8(%ebp)
 683:	e8 33 ff ff ff       	call   5bb <write>
 688:	83 c4 10             	add    $0x10,%esp
}
 68b:	c9                   	leave  
 68c:	c3                   	ret    

0000068d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
 690:	53                   	push   %ebx
 691:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 694:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 69b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 69f:	74 17                	je     6b8 <printint+0x2b>
 6a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a5:	79 11                	jns    6b8 <printint+0x2b>
    neg = 1;
 6a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b1:	f7 d8                	neg    %eax
 6b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b6:	eb 06                	jmp    6be <printint+0x31>
  } else {
    x = xx;
 6b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6c8:	8d 41 01             	lea    0x1(%ecx),%eax
 6cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d4:	ba 00 00 00 00       	mov    $0x0,%edx
 6d9:	f7 f3                	div    %ebx
 6db:	89 d0                	mov    %edx,%eax
 6dd:	0f b6 80 e8 0d 00 00 	movzbl 0xde8(%eax),%eax
 6e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ee:	ba 00 00 00 00       	mov    $0x0,%edx
 6f3:	f7 f3                	div    %ebx
 6f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fc:	75 c7                	jne    6c5 <printint+0x38>
  if(neg)
 6fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 702:	74 0e                	je     712 <printint+0x85>
    buf[i++] = '-';
 704:	8b 45 f4             	mov    -0xc(%ebp),%eax
 707:	8d 50 01             	lea    0x1(%eax),%edx
 70a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 70d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 712:	eb 1d                	jmp    731 <printint+0xa4>
    putc(fd, buf[i]);
 714:	8d 55 dc             	lea    -0x24(%ebp),%edx
 717:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71a:	01 d0                	add    %edx,%eax
 71c:	0f b6 00             	movzbl (%eax),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 3d ff ff ff       	call   66b <putc>
 72e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 731:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 739:	79 d9                	jns    714 <printint+0x87>
    putc(fd, buf[i]);
}
 73b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 746:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 74d:	8d 45 0c             	lea    0xc(%ebp),%eax
 750:	83 c0 04             	add    $0x4,%eax
 753:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 75d:	e9 59 01 00 00       	jmp    8bb <printf+0x17b>
    c = fmt[i] & 0xff;
 762:	8b 55 0c             	mov    0xc(%ebp),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	01 d0                	add    %edx,%eax
 76a:	0f b6 00             	movzbl (%eax),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	25 ff 00 00 00       	and    $0xff,%eax
 775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 77c:	75 2c                	jne    7aa <printf+0x6a>
      if(c == '%'){
 77e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 782:	75 0c                	jne    790 <printf+0x50>
        state = '%';
 784:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 78b:	e9 27 01 00 00       	jmp    8b7 <printf+0x177>
      } else {
        putc(fd, c);
 790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 793:	0f be c0             	movsbl %al,%eax
 796:	83 ec 08             	sub    $0x8,%esp
 799:	50                   	push   %eax
 79a:	ff 75 08             	pushl  0x8(%ebp)
 79d:	e8 c9 fe ff ff       	call   66b <putc>
 7a2:	83 c4 10             	add    $0x10,%esp
 7a5:	e9 0d 01 00 00       	jmp    8b7 <printf+0x177>
      }
    } else if(state == '%'){
 7aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ae:	0f 85 03 01 00 00    	jne    8b7 <printf+0x177>
      if(c == 'd'){
 7b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b8:	75 1e                	jne    7d8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	6a 01                	push   $0x1
 7c1:	6a 0a                	push   $0xa
 7c3:	50                   	push   %eax
 7c4:	ff 75 08             	pushl  0x8(%ebp)
 7c7:	e8 c1 fe ff ff       	call   68d <printint>
 7cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d3:	e9 d8 00 00 00       	jmp    8b0 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7d8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7dc:	74 06                	je     7e4 <printf+0xa4>
 7de:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7e2:	75 1e                	jne    802 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	6a 00                	push   $0x0
 7eb:	6a 10                	push   $0x10
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	pushl  0x8(%ebp)
 7f1:	e8 97 fe ff ff       	call   68d <printint>
 7f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fd:	e9 ae 00 00 00       	jmp    8b0 <printf+0x170>
      } else if(c == 's'){
 802:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 806:	75 43                	jne    84b <printf+0x10b>
        s = (char*)*ap;
 808:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 810:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 818:	75 07                	jne    821 <printf+0xe1>
          s = "(null)";
 81a:	c7 45 f4 3e 0b 00 00 	movl   $0xb3e,-0xc(%ebp)
        while(*s != 0){
 821:	eb 1c                	jmp    83f <printf+0xff>
          putc(fd, *s);
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	0f b6 00             	movzbl (%eax),%eax
 829:	0f be c0             	movsbl %al,%eax
 82c:	83 ec 08             	sub    $0x8,%esp
 82f:	50                   	push   %eax
 830:	ff 75 08             	pushl  0x8(%ebp)
 833:	e8 33 fe ff ff       	call   66b <putc>
 838:	83 c4 10             	add    $0x10,%esp
          s++;
 83b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	0f b6 00             	movzbl (%eax),%eax
 845:	84 c0                	test   %al,%al
 847:	75 da                	jne    823 <printf+0xe3>
 849:	eb 65                	jmp    8b0 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 84b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 84f:	75 1d                	jne    86e <printf+0x12e>
        putc(fd, *ap);
 851:	8b 45 e8             	mov    -0x18(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	0f be c0             	movsbl %al,%eax
 859:	83 ec 08             	sub    $0x8,%esp
 85c:	50                   	push   %eax
 85d:	ff 75 08             	pushl  0x8(%ebp)
 860:	e8 06 fe ff ff       	call   66b <putc>
 865:	83 c4 10             	add    $0x10,%esp
        ap++;
 868:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 86c:	eb 42                	jmp    8b0 <printf+0x170>
      } else if(c == '%'){
 86e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 872:	75 17                	jne    88b <printf+0x14b>
        putc(fd, c);
 874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 877:	0f be c0             	movsbl %al,%eax
 87a:	83 ec 08             	sub    $0x8,%esp
 87d:	50                   	push   %eax
 87e:	ff 75 08             	pushl  0x8(%ebp)
 881:	e8 e5 fd ff ff       	call   66b <putc>
 886:	83 c4 10             	add    $0x10,%esp
 889:	eb 25                	jmp    8b0 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 88b:	83 ec 08             	sub    $0x8,%esp
 88e:	6a 25                	push   $0x25
 890:	ff 75 08             	pushl  0x8(%ebp)
 893:	e8 d3 fd ff ff       	call   66b <putc>
 898:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 89b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89e:	0f be c0             	movsbl %al,%eax
 8a1:	83 ec 08             	sub    $0x8,%esp
 8a4:	50                   	push   %eax
 8a5:	ff 75 08             	pushl  0x8(%ebp)
 8a8:	e8 be fd ff ff       	call   66b <putc>
 8ad:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	01 d0                	add    %edx,%eax
 8c3:	0f b6 00             	movzbl (%eax),%eax
 8c6:	84 c0                	test   %al,%al
 8c8:	0f 85 94 fe ff ff    	jne    762 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8ce:	c9                   	leave  
 8cf:	c3                   	ret    

000008d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d6:	8b 45 08             	mov    0x8(%ebp),%eax
 8d9:	83 e8 08             	sub    $0x8,%eax
 8dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8df:	a1 14 0e 00 00       	mov    0xe14,%eax
 8e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e7:	eb 24                	jmp    90d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	8b 00                	mov    (%eax),%eax
 8ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f1:	77 12                	ja     905 <free+0x35>
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f9:	77 24                	ja     91f <free+0x4f>
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 903:	77 1a                	ja     91f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 913:	76 d4                	jbe    8e9 <free+0x19>
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91d:	76 ca                	jbe    8e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92f:	01 c2                	add    %eax,%edx
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	39 c2                	cmp    %eax,%edx
 938:	75 24                	jne    95e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	8b 50 04             	mov    0x4(%eax),%edx
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	01 c2                	add    %eax,%edx
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8b 00                	mov    (%eax),%eax
 955:	8b 10                	mov    (%eax),%edx
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	89 10                	mov    %edx,(%eax)
 95c:	eb 0a                	jmp    968 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	8b 10                	mov    (%eax),%edx
 963:	8b 45 f8             	mov    -0x8(%ebp),%eax
 966:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	01 d0                	add    %edx,%eax
 97a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97d:	75 20                	jne    99f <free+0xcf>
    p->s.size += bp->s.size;
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	8b 50 04             	mov    0x4(%eax),%edx
 985:	8b 45 f8             	mov    -0x8(%ebp),%eax
 988:	8b 40 04             	mov    0x4(%eax),%eax
 98b:	01 c2                	add    %eax,%edx
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99b:	89 10                	mov    %edx,(%eax)
 99d:	eb 08                	jmp    9a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	a3 14 0e 00 00       	mov    %eax,0xe14
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <morecore>:

static Header*
morecore(uint nu)
{
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
 9b4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9be:	77 07                	ja     9c7 <morecore+0x16>
    nu = 4096;
 9c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	c1 e0 03             	shl    $0x3,%eax
 9cd:	83 ec 0c             	sub    $0xc,%esp
 9d0:	50                   	push   %eax
 9d1:	e8 4d fc ff ff       	call   623 <sbrk>
 9d6:	83 c4 10             	add    $0x10,%esp
 9d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9e0:	75 07                	jne    9e9 <morecore+0x38>
    return 0;
 9e2:	b8 00 00 00 00       	mov    $0x0,%eax
 9e7:	eb 26                	jmp    a0f <morecore+0x5e>
  hp = (Header*)p;
 9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f2:	8b 55 08             	mov    0x8(%ebp),%edx
 9f5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fb:	83 c0 08             	add    $0x8,%eax
 9fe:	83 ec 0c             	sub    $0xc,%esp
 a01:	50                   	push   %eax
 a02:	e8 c9 fe ff ff       	call   8d0 <free>
 a07:	83 c4 10             	add    $0x10,%esp
  return freep;
 a0a:	a1 14 0e 00 00       	mov    0xe14,%eax
}
 a0f:	c9                   	leave  
 a10:	c3                   	ret    

00000a11 <malloc>:

void*
malloc(uint nbytes)
{
 a11:	55                   	push   %ebp
 a12:	89 e5                	mov    %esp,%ebp
 a14:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a17:	8b 45 08             	mov    0x8(%ebp),%eax
 a1a:	83 c0 07             	add    $0x7,%eax
 a1d:	c1 e8 03             	shr    $0x3,%eax
 a20:	83 c0 01             	add    $0x1,%eax
 a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a26:	a1 14 0e 00 00       	mov    0xe14,%eax
 a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a32:	75 23                	jne    a57 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a34:	c7 45 f0 0c 0e 00 00 	movl   $0xe0c,-0x10(%ebp)
 a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3e:	a3 14 0e 00 00       	mov    %eax,0xe14
 a43:	a1 14 0e 00 00       	mov    0xe14,%eax
 a48:	a3 0c 0e 00 00       	mov    %eax,0xe0c
    base.s.size = 0;
 a4d:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
 a54:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5a:	8b 00                	mov    (%eax),%eax
 a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 40 04             	mov    0x4(%eax),%eax
 a65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a68:	72 4d                	jb     ab7 <malloc+0xa6>
      if(p->s.size == nunits)
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a73:	75 0c                	jne    a81 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	8b 10                	mov    (%eax),%edx
 a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7d:	89 10                	mov    %edx,(%eax)
 a7f:	eb 26                	jmp    aa7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a84:	8b 40 04             	mov    0x4(%eax),%eax
 a87:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a8a:	89 c2                	mov    %eax,%edx
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a95:	8b 40 04             	mov    0x4(%eax),%eax
 a98:	c1 e0 03             	shl    $0x3,%eax
 a9b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaa:	a3 14 0e 00 00       	mov    %eax,0xe14
      return (void*)(p + 1);
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	83 c0 08             	add    $0x8,%eax
 ab5:	eb 3b                	jmp    af2 <malloc+0xe1>
    }
    if(p == freep)
 ab7:	a1 14 0e 00 00       	mov    0xe14,%eax
 abc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 abf:	75 1e                	jne    adf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ac1:	83 ec 0c             	sub    $0xc,%esp
 ac4:	ff 75 ec             	pushl  -0x14(%ebp)
 ac7:	e8 e5 fe ff ff       	call   9b1 <morecore>
 acc:	83 c4 10             	add    $0x10,%esp
 acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad6:	75 07                	jne    adf <malloc+0xce>
        return 0;
 ad8:	b8 00 00 00 00       	mov    $0x0,%eax
 add:	eb 13                	jmp    af2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	8b 00                	mov    (%eax),%eax
 aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aed:	e9 6d ff ff ff       	jmp    a5f <malloc+0x4e>
}
 af2:	c9                   	leave  
 af3:	c3                   	ret    
