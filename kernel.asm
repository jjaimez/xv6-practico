
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 80 d6 10 80       	mov    $0x8010d680,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a1 37 10 80       	mov    $0x801037a1,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 c0 8c 10 80       	push   $0x80108cc0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 57 53 00 00       	call   801053a3 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 d6 10 80       	push   $0x8010d680
801000bf:	e8 00 53 00 00       	call   801053c4 <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 94 15 11 80       	mov    0x80111594,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 d6 10 80       	push   $0x8010d680
8010010a:	e8 1b 53 00 00       	call   8010542a <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 d6 10 80       	push   $0x8010d680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 a6 4d 00 00       	call   80104ed0 <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 90 15 11 80       	mov    0x80111590,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 d6 10 80       	push   $0x8010d680
80100186:	e8 9f 52 00 00       	call   8010542a <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 c7 8c 10 80       	push   $0x80108cc7
801001ad:	e8 aa 03 00 00       	call   8010055c <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 4c 26 00 00       	call   80102831 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 d8 8c 10 80       	push   $0x80108cd8
80100207:	e8 50 03 00 00       	call   8010055c <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 0b 26 00 00       	call   80102831 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 df 8c 10 80       	push   $0x80108cdf
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 d6 10 80       	push   $0x8010d680
80100252:	e8 6d 51 00 00       	call   801053c4 <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 94 15 11 80    	mov    0x80111594,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 94 15 11 80       	mov    0x80111594,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 38 4d 00 00       	call   80104ff3 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 d6 10 80       	push   $0x8010d680
801002c6:	e8 5f 51 00 00       	call   8010542a <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100300:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100304:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030e:	fa                   	cli    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
80100314:	53                   	push   %ebx
80100315:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031c:	74 1c                	je     8010033a <printint+0x29>
8010031e:	8b 45 08             	mov    0x8(%ebp),%eax
80100321:	c1 e8 1f             	shr    $0x1f,%eax
80100324:	0f b6 c0             	movzbl %al,%eax
80100327:	89 45 10             	mov    %eax,0x10(%ebp)
8010032a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032e:	74 0a                	je     8010033a <printint+0x29>
    x = -xx;
80100330:	8b 45 08             	mov    0x8(%ebp),%eax
80100333:	f7 d8                	neg    %eax
80100335:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100338:	eb 06                	jmp    80100340 <printint+0x2f>
  else
    x = xx;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100347:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034a:	8d 41 01             	lea    0x1(%ecx),%eax
8010034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f3                	div    %ebx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100366:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100370:	ba 00 00 00 00       	mov    $0x0,%edx
80100375:	f7 f3                	div    %ebx
80100377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010037e:	75 c7                	jne    80100347 <printint+0x36>

  if(sign)
80100380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100384:	74 0e                	je     80100394 <printint+0x83>
    buf[i++] = '-';
80100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100389:	8d 50 01             	lea    0x1(%eax),%edx
8010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100394:	eb 1a                	jmp    801003b0 <printint+0x9f>
    consputc(buf[i]);
80100396:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039c:	01 d0                	add    %edx,%eax
8010039e:	0f b6 00             	movzbl (%eax),%eax
801003a1:	0f be c0             	movsbl %al,%eax
801003a4:	83 ec 0c             	sub    $0xc,%esp
801003a7:	50                   	push   %eax
801003a8:	e8 be 03 00 00       	call   8010076b <consputc>
801003ad:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 dc                	jns    80100396 <printint+0x85>
    consputc(buf[i]);
}
801003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003bd:	c9                   	leave  
801003be:	c3                   	ret    

801003bf <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003bf:	55                   	push   %ebp
801003c0:	89 e5                	mov    %esp,%ebp
801003c2:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c5:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d1:	74 10                	je     801003e3 <cprintf+0x24>
    acquire(&cons.lock);
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 e0 c5 10 80       	push   $0x8010c5e0
801003db:	e8 e4 4f 00 00       	call   801053c4 <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 e6 8c 10 80       	push   $0x80108ce6
801003f2:	e8 65 01 00 00       	call   8010055c <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f7:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100404:	e9 1b 01 00 00       	jmp    80100524 <cprintf+0x165>
    if(c != '%'){
80100409:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040d:	74 13                	je     80100422 <cprintf+0x63>
      consputc(c);
8010040f:	83 ec 0c             	sub    $0xc,%esp
80100412:	ff 75 e4             	pushl  -0x1c(%ebp)
80100415:	e8 51 03 00 00       	call   8010076b <consputc>
8010041a:	83 c4 10             	add    $0x10,%esp
      continue;
8010041d:	e9 fe 00 00 00       	jmp    80100520 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100422:	8b 55 08             	mov    0x8(%ebp),%edx
80100425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042c:	01 d0                	add    %edx,%eax
8010042e:	0f b6 00             	movzbl (%eax),%eax
80100431:	0f be c0             	movsbl %al,%eax
80100434:	25 ff 00 00 00       	and    $0xff,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100440:	75 05                	jne    80100447 <cprintf+0x88>
      break;
80100442:	e9 fd 00 00 00       	jmp    80100544 <cprintf+0x185>
    switch(c){
80100447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044a:	83 f8 70             	cmp    $0x70,%eax
8010044d:	74 47                	je     80100496 <cprintf+0xd7>
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	7f 13                	jg     80100467 <cprintf+0xa8>
80100454:	83 f8 25             	cmp    $0x25,%eax
80100457:	0f 84 98 00 00 00    	je     801004f5 <cprintf+0x136>
8010045d:	83 f8 64             	cmp    $0x64,%eax
80100460:	74 14                	je     80100476 <cprintf+0xb7>
80100462:	e9 9d 00 00 00       	jmp    80100504 <cprintf+0x145>
80100467:	83 f8 73             	cmp    $0x73,%eax
8010046a:	74 47                	je     801004b3 <cprintf+0xf4>
8010046c:	83 f8 78             	cmp    $0x78,%eax
8010046f:	74 25                	je     80100496 <cprintf+0xd7>
80100471:	e9 8e 00 00 00       	jmp    80100504 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100479:	8d 50 04             	lea    0x4(%eax),%edx
8010047c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010047f:	8b 00                	mov    (%eax),%eax
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 83 fe ff ff       	call   80100311 <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8a 00 00 00       	jmp    80100520 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	83 ec 04             	sub    $0x4,%esp
801004a4:	6a 00                	push   $0x0
801004a6:	6a 10                	push   $0x10
801004a8:	50                   	push   %eax
801004a9:	e8 63 fe ff ff       	call   80100311 <printint>
801004ae:	83 c4 10             	add    $0x10,%esp
      break;
801004b1:	eb 6d                	jmp    80100520 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b6:	8d 50 04             	lea    0x4(%eax),%edx
801004b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bc:	8b 00                	mov    (%eax),%eax
801004be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c5:	75 07                	jne    801004ce <cprintf+0x10f>
        s = "(null)";
801004c7:	c7 45 ec ef 8c 10 80 	movl   $0x80108cef,-0x14(%ebp)
      for(; *s; s++)
801004ce:	eb 19                	jmp    801004e9 <cprintf+0x12a>
        consputc(*s);
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 89 02 00 00       	call   8010076b <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ec:	0f b6 00             	movzbl (%eax),%eax
801004ef:	84 c0                	test   %al,%al
801004f1:	75 dd                	jne    801004d0 <cprintf+0x111>
        consputc(*s);
      break;
801004f3:	eb 2b                	jmp    80100520 <cprintf+0x161>
    case '%':
      consputc('%');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 25                	push   $0x25
801004fa:	e8 6c 02 00 00       	call   8010076b <consputc>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	eb 1c                	jmp    80100520 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100504:	83 ec 0c             	sub    $0xc,%esp
80100507:	6a 25                	push   $0x25
80100509:	e8 5d 02 00 00       	call   8010076b <consputc>
8010050e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100511:	83 ec 0c             	sub    $0xc,%esp
80100514:	ff 75 e4             	pushl  -0x1c(%ebp)
80100517:	e8 4f 02 00 00       	call   8010076b <consputc>
8010051c:	83 c4 10             	add    $0x10,%esp
      break;
8010051f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	01 d0                	add    %edx,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c5 fe ff ff    	jne    80100409 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
80100544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100548:	74 10                	je     8010055a <cprintf+0x19b>
    release(&cons.lock);
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100552:	e8 d3 4e 00 00       	call   8010542a <release>
80100557:	83 c4 10             	add    $0x10,%esp
}
8010055a:	c9                   	leave  
8010055b:	c3                   	ret    

8010055c <panic>:

void
panic(char *s)
{
8010055c:	55                   	push   %ebp
8010055d:	89 e5                	mov    %esp,%ebp
8010055f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100562:	e8 a4 fd ff ff       	call   8010030b <cli>
  cons.locking = 0;
80100567:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010056e:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100571:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100577:	0f b6 00             	movzbl (%eax),%eax
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	83 ec 08             	sub    $0x8,%esp
80100580:	50                   	push   %eax
80100581:	68 f6 8c 10 80       	push   $0x80108cf6
80100586:	e8 34 fe ff ff       	call   801003bf <cprintf>
8010058b:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
8010058e:	8b 45 08             	mov    0x8(%ebp),%eax
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	50                   	push   %eax
80100595:	e8 25 fe ff ff       	call   801003bf <cprintf>
8010059a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	68 05 8d 10 80       	push   $0x80108d05
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 be 4e 00 00       	call   8010547b <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 07 8d 10 80       	push   $0x80108d07
801005d9:	e8 e1 fd ff ff       	call   801003bf <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e9:	7e de                	jle    801005c9 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005eb:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005f2:	00 00 00 
  for(;;)
    ;
801005f5:	eb fe                	jmp    801005f5 <panic+0x99>

801005f7 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fd:	6a 0e                	push   $0xe
801005ff:	68 d4 03 00 00       	push   $0x3d4
80100604:	e8 e4 fc ff ff       	call   801002ed <outb>
80100609:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060c:	68 d5 03 00 00       	push   $0x3d5
80100611:	e8 ba fc ff ff       	call   801002d0 <inb>
80100616:	83 c4 04             	add    $0x4,%esp
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	c1 e0 08             	shl    $0x8,%eax
8010061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100622:	6a 0f                	push   $0xf
80100624:	68 d4 03 00 00       	push   $0x3d4
80100629:	e8 bf fc ff ff       	call   801002ed <outb>
8010062e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100631:	68 d5 03 00 00       	push   $0x3d5
80100636:	e8 95 fc ff ff       	call   801002d0 <inb>
8010063b:	83 c4 04             	add    $0x4,%esp
8010063e:	0f b6 c0             	movzbl %al,%eax
80100641:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 30                	jne    8010067a <cgaputc+0x83>
    pos += 80 - pos%80;
8010064a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010064d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100652:	89 c8                	mov    %ecx,%eax
80100654:	f7 ea                	imul   %edx
80100656:	c1 fa 05             	sar    $0x5,%edx
80100659:	89 c8                	mov    %ecx,%eax
8010065b:	c1 f8 1f             	sar    $0x1f,%eax
8010065e:	29 c2                	sub    %eax,%edx
80100660:	89 d0                	mov    %edx,%eax
80100662:	c1 e0 02             	shl    $0x2,%eax
80100665:	01 d0                	add    %edx,%eax
80100667:	c1 e0 04             	shl    $0x4,%eax
8010066a:	29 c1                	sub    %eax,%ecx
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	b8 50 00 00 00       	mov    $0x50,%eax
80100673:	29 d0                	sub    %edx,%eax
80100675:	01 45 f4             	add    %eax,-0xc(%ebp)
80100678:	eb 34                	jmp    801006ae <cgaputc+0xb7>
  else if(c == BACKSPACE){
8010067a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100681:	75 0c                	jne    8010068f <cgaputc+0x98>
    if(pos > 0) --pos;
80100683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100687:	7e 25                	jle    801006ae <cgaputc+0xb7>
80100689:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010068d:	eb 1f                	jmp    801006ae <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068f:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100698:	8d 50 01             	lea    0x1(%eax),%edx
8010069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069e:	01 c0                	add    %eax,%eax
801006a0:	01 c8                	add    %ecx,%eax
801006a2:	8b 55 08             	mov    0x8(%ebp),%edx
801006a5:	0f b6 d2             	movzbl %dl,%edx
801006a8:	80 ce 07             	or     $0x7,%dh
801006ab:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006ae:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006b5:	7e 4c                	jle    80100703 <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b7:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c7:	83 ec 04             	sub    $0x4,%esp
801006ca:	68 60 0e 00 00       	push   $0xe60
801006cf:	52                   	push   %edx
801006d0:	50                   	push   %eax
801006d1:	e8 09 50 00 00       	call   801056df <memmove>
801006d6:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006d9:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006dd:	b8 80 07 00 00       	mov    $0x780,%eax
801006e2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e5:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006f0:	01 c9                	add    %ecx,%ecx
801006f2:	01 c8                	add    %ecx,%eax
801006f4:	83 ec 04             	sub    $0x4,%esp
801006f7:	52                   	push   %edx
801006f8:	6a 00                	push   $0x0
801006fa:	50                   	push   %eax
801006fb:	e8 20 4f 00 00       	call   80105620 <memset>
80100700:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100703:	83 ec 08             	sub    $0x8,%esp
80100706:	6a 0e                	push   $0xe
80100708:	68 d4 03 00 00       	push   $0x3d4
8010070d:	e8 db fb ff ff       	call   801002ed <outb>
80100712:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100718:	c1 f8 08             	sar    $0x8,%eax
8010071b:	0f b6 c0             	movzbl %al,%eax
8010071e:	83 ec 08             	sub    $0x8,%esp
80100721:	50                   	push   %eax
80100722:	68 d5 03 00 00       	push   $0x3d5
80100727:	e8 c1 fb ff ff       	call   801002ed <outb>
8010072c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010072f:	83 ec 08             	sub    $0x8,%esp
80100732:	6a 0f                	push   $0xf
80100734:	68 d4 03 00 00       	push   $0x3d4
80100739:	e8 af fb ff ff       	call   801002ed <outb>
8010073e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 98 fb ff ff       	call   801002ed <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100758:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100760:	01 d2                	add    %edx,%edx
80100762:	01 d0                	add    %edx,%eax
80100764:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100769:	c9                   	leave  
8010076a:	c3                   	ret    

8010076b <consputc>:

void
consputc(int c)
{
8010076b:	55                   	push   %ebp
8010076c:	89 e5                	mov    %esp,%ebp
8010076e:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100771:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100776:	85 c0                	test   %eax,%eax
80100778:	74 07                	je     80100781 <consputc+0x16>
    cli();
8010077a:	e8 8c fb ff ff       	call   8010030b <cli>
    for(;;)
      ;
8010077f:	eb fe                	jmp    8010077f <consputc+0x14>
  }

  if(c == BACKSPACE){
80100781:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100788:	75 29                	jne    801007b3 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078a:	83 ec 0c             	sub    $0xc,%esp
8010078d:	6a 08                	push   $0x8
8010078f:	e8 ef 6b 00 00       	call   80107383 <uartputc>
80100794:	83 c4 10             	add    $0x10,%esp
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	6a 20                	push   $0x20
8010079c:	e8 e2 6b 00 00       	call   80107383 <uartputc>
801007a1:	83 c4 10             	add    $0x10,%esp
801007a4:	83 ec 0c             	sub    $0xc,%esp
801007a7:	6a 08                	push   $0x8
801007a9:	e8 d5 6b 00 00       	call   80107383 <uartputc>
801007ae:	83 c4 10             	add    $0x10,%esp
801007b1:	eb 0e                	jmp    801007c1 <consputc+0x56>
  } else
    uartputc(c);
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 08             	pushl  0x8(%ebp)
801007b9:	e8 c5 6b 00 00       	call   80107383 <uartputc>
801007be:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007c1:	83 ec 0c             	sub    $0xc,%esp
801007c4:	ff 75 08             	pushl  0x8(%ebp)
801007c7:	e8 2b fe ff ff       	call   801005f7 <cgaputc>
801007cc:	83 c4 10             	add    $0x10,%esp
}
801007cf:	c9                   	leave  
801007d0:	c3                   	ret    

801007d1 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d1:	55                   	push   %ebp
801007d2:	89 e5                	mov    %esp,%ebp
801007d4:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007d7:	83 ec 0c             	sub    $0xc,%esp
801007da:	68 c0 17 11 80       	push   $0x801117c0
801007df:	e8 e0 4b 00 00       	call   801053c4 <acquire>
801007e4:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007e7:	e9 43 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    switch(c){
801007ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	74 1e                	je     80100812 <consoleintr+0x41>
801007f4:	83 f8 10             	cmp    $0x10,%eax
801007f7:	7f 0a                	jg     80100803 <consoleintr+0x32>
801007f9:	83 f8 08             	cmp    $0x8,%eax
801007fc:	74 67                	je     80100865 <consoleintr+0x94>
801007fe:	e9 93 00 00 00       	jmp    80100896 <consoleintr+0xc5>
80100803:	83 f8 15             	cmp    $0x15,%eax
80100806:	74 31                	je     80100839 <consoleintr+0x68>
80100808:	83 f8 7f             	cmp    $0x7f,%eax
8010080b:	74 58                	je     80100865 <consoleintr+0x94>
8010080d:	e9 84 00 00 00       	jmp    80100896 <consoleintr+0xc5>
    case C('P'):  // Process listing.
      procdump();
80100812:	e8 b1 48 00 00       	call   801050c8 <procdump>
      break;
80100817:	e9 13 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010081c:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100821:	83 e8 01             	sub    $0x1,%eax
80100824:	a3 7c 18 11 80       	mov    %eax,0x8011187c
        consputc(BACKSPACE);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 00 01 00 00       	push   $0x100
80100831:	e8 35 ff ff ff       	call   8010076b <consputc>
80100836:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100839:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
8010083f:	a1 78 18 11 80       	mov    0x80111878,%eax
80100844:	39 c2                	cmp    %eax,%edx
80100846:	74 18                	je     80100860 <consoleintr+0x8f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 7c 18 11 80       	mov    0x8011187c,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	05 c0 17 11 80       	add    $0x801117c0,%eax
80100858:	0f b6 40 34          	movzbl 0x34(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085c:	3c 0a                	cmp    $0xa,%al
8010085e:	75 bc                	jne    8010081c <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100860:	e9 ca 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100865:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
8010086b:	a1 78 18 11 80       	mov    0x80111878,%eax
80100870:	39 c2                	cmp    %eax,%edx
80100872:	74 1d                	je     80100891 <consoleintr+0xc0>
        input.e--;
80100874:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100879:	83 e8 01             	sub    $0x1,%eax
8010087c:	a3 7c 18 11 80       	mov    %eax,0x8011187c
        consputc(BACKSPACE);
80100881:	83 ec 0c             	sub    $0xc,%esp
80100884:	68 00 01 00 00       	push   $0x100
80100889:	e8 dd fe ff ff       	call   8010076b <consputc>
8010088e:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100891:	e9 99 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010089a:	0f 84 8e 00 00 00    	je     8010092e <consoleintr+0x15d>
801008a0:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
801008a6:	a1 74 18 11 80       	mov    0x80111874,%eax
801008ab:	29 c2                	sub    %eax,%edx
801008ad:	89 d0                	mov    %edx,%eax
801008af:	83 f8 7f             	cmp    $0x7f,%eax
801008b2:	77 7a                	ja     8010092e <consoleintr+0x15d>
        c = (c == '\r') ? '\n' : c;
801008b4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008b8:	74 05                	je     801008bf <consoleintr+0xee>
801008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bd:	eb 05                	jmp    801008c4 <consoleintr+0xf3>
801008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c7:	a1 7c 18 11 80       	mov    0x8011187c,%eax
801008cc:	8d 50 01             	lea    0x1(%eax),%edx
801008cf:	89 15 7c 18 11 80    	mov    %edx,0x8011187c
801008d5:	83 e0 7f             	and    $0x7f,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008dd:	89 c1                	mov    %eax,%ecx
801008df:	8d 82 c0 17 11 80    	lea    -0x7feee840(%edx),%eax
801008e5:	88 48 34             	mov    %cl,0x34(%eax)
        consputc(c);
801008e8:	83 ec 0c             	sub    $0xc,%esp
801008eb:	ff 75 f4             	pushl  -0xc(%ebp)
801008ee:	e8 78 fe ff ff       	call   8010076b <consputc>
801008f3:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008fa:	74 18                	je     80100914 <consoleintr+0x143>
801008fc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100900:	74 12                	je     80100914 <consoleintr+0x143>
80100902:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100907:	8b 15 74 18 11 80    	mov    0x80111874,%edx
8010090d:	83 ea 80             	sub    $0xffffff80,%edx
80100910:	39 d0                	cmp    %edx,%eax
80100912:	75 1a                	jne    8010092e <consoleintr+0x15d>
          input.w = input.e;
80100914:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100919:	a3 78 18 11 80       	mov    %eax,0x80111878
          wakeup(&input.r);
8010091e:	83 ec 0c             	sub    $0xc,%esp
80100921:	68 74 18 11 80       	push   $0x80111874
80100926:	e8 c8 46 00 00       	call   80104ff3 <wakeup>
8010092b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010092e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010092f:	8b 45 08             	mov    0x8(%ebp),%eax
80100932:	ff d0                	call   *%eax
80100934:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010093b:	0f 89 ab fe ff ff    	jns    801007ec <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100941:	83 ec 0c             	sub    $0xc,%esp
80100944:	68 c0 17 11 80       	push   $0x801117c0
80100949:	e8 dc 4a 00 00       	call   8010542a <release>
8010094e:	83 c4 10             	add    $0x10,%esp
}
80100951:	c9                   	leave  
80100952:	c3                   	ret    

80100953 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100953:	55                   	push   %ebp
80100954:	89 e5                	mov    %esp,%ebp
80100956:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100959:	83 ec 0c             	sub    $0xc,%esp
8010095c:	ff 75 08             	pushl  0x8(%ebp)
8010095f:	e8 bd 10 00 00       	call   80101a21 <iunlock>
80100964:	83 c4 10             	add    $0x10,%esp
  target = n;
80100967:	8b 45 10             	mov    0x10(%ebp),%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010096d:	83 ec 0c             	sub    $0xc,%esp
80100970:	68 c0 17 11 80       	push   $0x801117c0
80100975:	e8 4a 4a 00 00       	call   801053c4 <acquire>
8010097a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
8010097d:	e9 b4 00 00 00       	jmp    80100a36 <consoleread+0xe3>
    while(input.r == input.w){
80100982:	eb 4a                	jmp    801009ce <consoleread+0x7b>
      if(proc->killed){
80100984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010098a:	8b 40 24             	mov    0x24(%eax),%eax
8010098d:	85 c0                	test   %eax,%eax
8010098f:	74 28                	je     801009b9 <consoleread+0x66>
        release(&input.lock);
80100991:	83 ec 0c             	sub    $0xc,%esp
80100994:	68 c0 17 11 80       	push   $0x801117c0
80100999:	e8 8c 4a 00 00       	call   8010542a <release>
8010099e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009a1:	83 ec 0c             	sub    $0xc,%esp
801009a4:	ff 75 08             	pushl  0x8(%ebp)
801009a7:	e8 1e 0f 00 00       	call   801018ca <ilock>
801009ac:	83 c4 10             	add    $0x10,%esp
        return -1;
801009af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009b4:	e9 af 00 00 00       	jmp    80100a68 <consoleread+0x115>
      }
      sleep(&input.r, &input.lock);
801009b9:	83 ec 08             	sub    $0x8,%esp
801009bc:	68 c0 17 11 80       	push   $0x801117c0
801009c1:	68 74 18 11 80       	push   $0x80111874
801009c6:	e8 05 45 00 00       	call   80104ed0 <sleep>
801009cb:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009ce:	8b 15 74 18 11 80    	mov    0x80111874,%edx
801009d4:	a1 78 18 11 80       	mov    0x80111878,%eax
801009d9:	39 c2                	cmp    %eax,%edx
801009db:	74 a7                	je     80100984 <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009dd:	a1 74 18 11 80       	mov    0x80111874,%eax
801009e2:	8d 50 01             	lea    0x1(%eax),%edx
801009e5:	89 15 74 18 11 80    	mov    %edx,0x80111874
801009eb:	83 e0 7f             	and    $0x7f,%eax
801009ee:	05 c0 17 11 80       	add    $0x801117c0,%eax
801009f3:	0f b6 40 34          	movzbl 0x34(%eax),%eax
801009f7:	0f be c0             	movsbl %al,%eax
801009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009fd:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a01:	75 19                	jne    80100a1c <consoleread+0xc9>
      if(n < target){
80100a03:	8b 45 10             	mov    0x10(%ebp),%eax
80100a06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a09:	73 0f                	jae    80100a1a <consoleread+0xc7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a0b:	a1 74 18 11 80       	mov    0x80111874,%eax
80100a10:	83 e8 01             	sub    $0x1,%eax
80100a13:	a3 74 18 11 80       	mov    %eax,0x80111874
      }
      break;
80100a18:	eb 26                	jmp    80100a40 <consoleread+0xed>
80100a1a:	eb 24                	jmp    80100a40 <consoleread+0xed>
    }
    *dst++ = c;
80100a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a1f:	8d 50 01             	lea    0x1(%eax),%edx
80100a22:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a28:	88 10                	mov    %dl,(%eax)
    --n;
80100a2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a2e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a32:	75 02                	jne    80100a36 <consoleread+0xe3>
      break;
80100a34:	eb 0a                	jmp    80100a40 <consoleread+0xed>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3a:	0f 8f 42 ff ff ff    	jg     80100982 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	68 c0 17 11 80       	push   $0x801117c0
80100a48:	e8 dd 49 00 00       	call   8010542a <release>
80100a4d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a50:	83 ec 0c             	sub    $0xc,%esp
80100a53:	ff 75 08             	pushl  0x8(%ebp)
80100a56:	e8 6f 0e 00 00       	call   801018ca <ilock>
80100a5b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a5e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a64:	29 c2                	sub    %eax,%edx
80100a66:	89 d0                	mov    %edx,%eax
}
80100a68:	c9                   	leave  
80100a69:	c3                   	ret    

80100a6a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a6a:	55                   	push   %ebp
80100a6b:	89 e5                	mov    %esp,%ebp
80100a6d:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	ff 75 08             	pushl  0x8(%ebp)
80100a76:	e8 a6 0f 00 00       	call   80101a21 <iunlock>
80100a7b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a86:	e8 39 49 00 00       	call   801053c4 <acquire>
80100a8b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 21                	jmp    80100ab8 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	83 ec 0c             	sub    $0xc,%esp
80100aab:	50                   	push   %eax
80100aac:	e8 ba fc ff ff       	call   8010076b <consputc>
80100ab1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100abb:	3b 45 10             	cmp    0x10(%ebp),%eax
80100abe:	7c d7                	jl     80100a97 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ac8:	e8 5d 49 00 00       	call   8010542a <release>
80100acd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	ff 75 08             	pushl  0x8(%ebp)
80100ad6:	e8 ef 0d 00 00       	call   801018ca <ilock>
80100adb:	83 c4 10             	add    $0x10,%esp

  return n;
80100ade:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae1:	c9                   	leave  
80100ae2:	c3                   	ret    

80100ae3 <consoleinit>:

void
consoleinit(void)
{
80100ae3:	55                   	push   %ebp
80100ae4:	89 e5                	mov    %esp,%ebp
80100ae6:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ae9:	83 ec 08             	sub    $0x8,%esp
80100aec:	68 0b 8d 10 80       	push   $0x80108d0b
80100af1:	68 e0 c5 10 80       	push   $0x8010c5e0
80100af6:	e8 a8 48 00 00       	call   801053a3 <initlock>
80100afb:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100afe:	83 ec 08             	sub    $0x8,%esp
80100b01:	68 13 8d 10 80       	push   $0x80108d13
80100b06:	68 c0 17 11 80       	push   $0x801117c0
80100b0b:	e8 93 48 00 00       	call   801053a3 <initlock>
80100b10:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b13:	c7 05 4c 22 11 80 6a 	movl   $0x80100a6a,0x8011224c
80100b1a:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b1d:	c7 05 48 22 11 80 53 	movl   $0x80100953,0x80112248
80100b24:	09 10 80 
  cons.locking = 1;
80100b27:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b2e:	00 00 00 

  picenable(IRQ_KBD);
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	6a 01                	push   $0x1
80100b36:	e8 00 33 00 00       	call   80103e3b <picenable>
80100b3b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b3e:	83 ec 08             	sub    $0x8,%esp
80100b41:	6a 00                	push   $0x0
80100b43:	6a 01                	push   $0x1
80100b45:	e8 b0 1e 00 00       	call   801029fa <ioapicenable>
80100b4a:	83 c4 10             	add    $0x10,%esp
}
80100b4d:	c9                   	leave  
80100b4e:	c3                   	ret    

80100b4f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b4f:	55                   	push   %ebp
80100b50:	89 e5                	mov    %esp,%ebp
80100b52:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b58:	e8 05 29 00 00       	call   80103462 <begin_op>
  if((ip = namei(path)) == 0){
80100b5d:	83 ec 0c             	sub    $0xc,%esp
80100b60:	ff 75 08             	pushl  0x8(%ebp)
80100b63:	e8 25 19 00 00       	call   8010248d <namei>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b72:	75 0f                	jne    80100b83 <exec+0x34>
    end_op();
80100b74:	e8 77 29 00 00       	call   801034f0 <end_op>
    return -1;
80100b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b7e:	e9 a9 03 00 00       	jmp    80100f2c <exec+0x3dd>
  }
  ilock(ip);
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	ff 75 d8             	pushl  -0x28(%ebp)
80100b89:	e8 3c 0d 00 00       	call   801018ca <ilock>
80100b8e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b98:	6a 34                	push   $0x34
80100b9a:	6a 00                	push   $0x0
80100b9c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba2:	50                   	push   %eax
80100ba3:	ff 75 d8             	pushl  -0x28(%ebp)
80100ba6:	e8 81 12 00 00       	call   80101e2c <readi>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	83 f8 33             	cmp    $0x33,%eax
80100bb1:	77 05                	ja     80100bb8 <exec+0x69>
    goto bad;
80100bb3:	e9 42 03 00 00       	jmp    80100efa <exec+0x3ab>
  if(elf.magic != ELF_MAGIC)
80100bb8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbe:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc3:	74 05                	je     80100bca <exec+0x7b>
    goto bad;
80100bc5:	e9 30 03 00 00       	jmp    80100efa <exec+0x3ab>

  if((pgdir = setupkvm()) == 0)
80100bca:	e8 eb 78 00 00       	call   801084ba <setupkvm>
80100bcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bd6:	75 05                	jne    80100bdd <exec+0x8e>
    goto bad;
80100bd8:	e9 1d 03 00 00       	jmp    80100efa <exec+0x3ab>

  // Load program into memory.
  sz = 0;
80100bdd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100beb:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf4:	e9 ae 00 00 00       	jmp    80100ca7 <exec+0x158>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	50                   	push   %eax
80100bff:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c05:	50                   	push   %eax
80100c06:	ff 75 d8             	pushl  -0x28(%ebp)
80100c09:	e8 1e 12 00 00       	call   80101e2c <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 20             	cmp    $0x20,%eax
80100c14:	74 05                	je     80100c1b <exec+0xcc>
      goto bad;
80100c16:	e9 df 02 00 00       	jmp    80100efa <exec+0x3ab>
    if(ph.type != ELF_PROG_LOAD)
80100c1b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c21:	83 f8 01             	cmp    $0x1,%eax
80100c24:	74 02                	je     80100c28 <exec+0xd9>
      continue;
80100c26:	eb 72                	jmp    80100c9a <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c28:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c34:	39 c2                	cmp    %eax,%edx
80100c36:	73 05                	jae    80100c3d <exec+0xee>
      goto bad;
80100c38:	e9 bd 02 00 00       	jmp    80100efa <exec+0x3ab>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 03 7c 00 00       	call   8010885d <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	75 05                	jne    80100c6b <exec+0x11c>
      goto bad;
80100c66:	e9 8f 02 00 00       	jmp    80100efa <exec+0x3ab>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6b:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c77:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	52                   	push   %edx
80100c81:	50                   	push   %eax
80100c82:	ff 75 d8             	pushl  -0x28(%ebp)
80100c85:	51                   	push   %ecx
80100c86:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c89:	e8 f8 7a 00 00       	call   80108786 <loaduvm>
80100c8e:	83 c4 20             	add    $0x20,%esp
80100c91:	85 c0                	test   %eax,%eax
80100c93:	79 05                	jns    80100c9a <exec+0x14b>
      goto bad;
80100c95:	e9 60 02 00 00       	jmp    80100efa <exec+0x3ab>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca1:	83 c0 20             	add    $0x20,%eax
80100ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca7:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cae:	0f b7 c0             	movzwl %ax,%eax
80100cb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb4:	0f 8f 3f ff ff ff    	jg     80100bf9 <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cba:	83 ec 0c             	sub    $0xc,%esp
80100cbd:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc0:	e8 bc 0e 00 00       	call   80101b81 <iunlockput>
80100cc5:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc8:	e8 23 28 00 00       	call   801034f0 <end_op>
  ip = 0;
80100ccd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  //allocate one page and leave a space to grow the stack and detect stack overflow
  sz = PGROUNDUP(sz);   
80100cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd7:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz + MAXPAGES*PGSIZE, sz + (MAXPAGES +1)*PGSIZE)) == 0)
80100ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce7:	8d 90 00 40 00 00    	lea    0x4000(%eax),%edx
80100ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf0:	05 00 30 00 00       	add    $0x3000,%eax
80100cf5:	83 ec 04             	sub    $0x4,%esp
80100cf8:	52                   	push   %edx
80100cf9:	50                   	push   %eax
80100cfa:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cfd:	e8 5b 7b 00 00       	call   8010885d <allocuvm>
80100d02:	83 c4 10             	add    $0x10,%esp
80100d05:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d0c:	75 05                	jne    80100d13 <exec+0x1c4>
    goto bad;
80100d0e:	e9 e7 01 00 00       	jmp    80100efa <exec+0x3ab>
  //clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
80100d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d16:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d20:	e9 98 00 00 00       	jmp    80100dbd <exec+0x26e>
    if(argc >= MAXARG)
80100d25:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d29:	76 05                	jbe    80100d30 <exec+0x1e1>
      goto bad;
80100d2b:	e9 ca 01 00 00       	jmp    80100efa <exec+0x3ab>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3d:	01 d0                	add    %edx,%eax
80100d3f:	8b 00                	mov    (%eax),%eax
80100d41:	83 ec 0c             	sub    $0xc,%esp
80100d44:	50                   	push   %eax
80100d45:	e8 25 4b 00 00       	call   8010586f <strlen>
80100d4a:	83 c4 10             	add    $0x10,%esp
80100d4d:	89 c2                	mov    %eax,%edx
80100d4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d52:	29 d0                	sub    %edx,%eax
80100d54:	83 e8 01             	sub    $0x1,%eax
80100d57:	83 e0 fc             	and    $0xfffffffc,%eax
80100d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6a:	01 d0                	add    %edx,%eax
80100d6c:	8b 00                	mov    (%eax),%eax
80100d6e:	83 ec 0c             	sub    $0xc,%esp
80100d71:	50                   	push   %eax
80100d72:	e8 f8 4a 00 00       	call   8010586f <strlen>
80100d77:	83 c4 10             	add    $0x10,%esp
80100d7a:	83 c0 01             	add    $0x1,%eax
80100d7d:	89 c1                	mov    %eax,%ecx
80100d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d89:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d8c:	01 d0                	add    %edx,%eax
80100d8e:	8b 00                	mov    (%eax),%eax
80100d90:	51                   	push   %ecx
80100d91:	50                   	push   %eax
80100d92:	ff 75 dc             	pushl  -0x24(%ebp)
80100d95:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d98:	e8 82 7e 00 00       	call   80108c1f <copyout>
80100d9d:	83 c4 10             	add    $0x10,%esp
80100da0:	85 c0                	test   %eax,%eax
80100da2:	79 05                	jns    80100da9 <exec+0x25a>
      goto bad;
80100da4:	e9 51 01 00 00       	jmp    80100efa <exec+0x3ab>
    ustack[3+argc] = sp;
80100da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dac:	8d 50 03             	lea    0x3(%eax),%edx
80100daf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db2:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  //clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dca:	01 d0                	add    %edx,%eax
80100dcc:	8b 00                	mov    (%eax),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	0f 85 4f ff ff ff    	jne    80100d25 <exec+0x1d6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	83 c0 03             	add    $0x3,%eax
80100ddc:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100de3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100de7:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dee:	ff ff ff 
  ustack[1] = argc;
80100df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df4:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0a:	29 d0                	sub    %edx,%eax
80100e0c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e15:	83 c0 04             	add    $0x4,%eax
80100e18:	c1 e0 02             	shl    $0x2,%eax
80100e1b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e21:	83 c0 04             	add    $0x4,%eax
80100e24:	c1 e0 02             	shl    $0x2,%eax
80100e27:	50                   	push   %eax
80100e28:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e2e:	50                   	push   %eax
80100e2f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e32:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e35:	e8 e5 7d 00 00       	call   80108c1f <copyout>
80100e3a:	83 c4 10             	add    $0x10,%esp
80100e3d:	85 c0                	test   %eax,%eax
80100e3f:	79 05                	jns    80100e46 <exec+0x2f7>
    goto bad;
80100e41:	e9 b4 00 00 00       	jmp    80100efa <exec+0x3ab>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e46:	8b 45 08             	mov    0x8(%ebp),%eax
80100e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e52:	eb 17                	jmp    80100e6b <exec+0x31c>
    if(*s == '/')
80100e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e57:	0f b6 00             	movzbl (%eax),%eax
80100e5a:	3c 2f                	cmp    $0x2f,%al
80100e5c:	75 09                	jne    80100e67 <exec+0x318>
      last = s+1;
80100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e61:	83 c0 01             	add    $0x1,%eax
80100e64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6e:	0f b6 00             	movzbl (%eax),%eax
80100e71:	84 c0                	test   %al,%al
80100e73:	75 df                	jne    80100e54 <exec+0x305>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7b:	83 c0 6c             	add    $0x6c,%eax
80100e7e:	83 ec 04             	sub    $0x4,%esp
80100e81:	6a 10                	push   $0x10
80100e83:	ff 75 f0             	pushl  -0x10(%ebp)
80100e86:	50                   	push   %eax
80100e87:	e8 99 49 00 00       	call   80105825 <safestrcpy>
80100e8c:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e95:	8b 40 04             	mov    0x4(%eax),%eax
80100e98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ea4:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ea7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ead:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100eb0:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb8:	8b 40 18             	mov    0x18(%eax),%eax
80100ebb:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ec1:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ec4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eca:	8b 40 18             	mov    0x18(%eax),%eax
80100ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ed0:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ed3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed9:	83 ec 0c             	sub    $0xc,%esp
80100edc:	50                   	push   %eax
80100edd:	e8 bd 76 00 00       	call   8010859f <switchuvm>
80100ee2:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 d0             	pushl  -0x30(%ebp)
80100eeb:	e8 f3 7a 00 00       	call   801089e3 <freevm>
80100ef0:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ef3:	b8 00 00 00 00       	mov    $0x0,%eax
80100ef8:	eb 32                	jmp    80100f2c <exec+0x3dd>

 bad:
  if(pgdir)
80100efa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100efe:	74 0e                	je     80100f0e <exec+0x3bf>
    freevm(pgdir);
80100f00:	83 ec 0c             	sub    $0xc,%esp
80100f03:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f06:	e8 d8 7a 00 00       	call   801089e3 <freevm>
80100f0b:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f12:	74 13                	je     80100f27 <exec+0x3d8>
    iunlockput(ip);
80100f14:	83 ec 0c             	sub    $0xc,%esp
80100f17:	ff 75 d8             	pushl  -0x28(%ebp)
80100f1a:	e8 62 0c 00 00       	call   80101b81 <iunlockput>
80100f1f:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f22:	e8 c9 25 00 00       	call   801034f0 <end_op>
  }
  return -1;
80100f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2c:	c9                   	leave  
80100f2d:	c3                   	ret    

80100f2e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f2e:	55                   	push   %ebp
80100f2f:	89 e5                	mov    %esp,%ebp
80100f31:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f34:	83 ec 08             	sub    $0x8,%esp
80100f37:	68 19 8d 10 80       	push   $0x80108d19
80100f3c:	68 80 18 11 80       	push   $0x80111880
80100f41:	e8 5d 44 00 00       	call   801053a3 <initlock>
80100f46:	83 c4 10             	add    $0x10,%esp
}
80100f49:	c9                   	leave  
80100f4a:	c3                   	ret    

80100f4b <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f4b:	55                   	push   %ebp
80100f4c:	89 e5                	mov    %esp,%ebp
80100f4e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
80100f54:	68 80 18 11 80       	push   $0x80111880
80100f59:	e8 66 44 00 00       	call   801053c4 <acquire>
80100f5e:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f61:	c7 45 f4 b4 18 11 80 	movl   $0x801118b4,-0xc(%ebp)
80100f68:	eb 2d                	jmp    80100f97 <filealloc+0x4c>
    if(f->ref == 0){
80100f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6d:	8b 40 04             	mov    0x4(%eax),%eax
80100f70:	85 c0                	test   %eax,%eax
80100f72:	75 1f                	jne    80100f93 <filealloc+0x48>
      f->ref = 1;
80100f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f77:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f7e:	83 ec 0c             	sub    $0xc,%esp
80100f81:	68 80 18 11 80       	push   $0x80111880
80100f86:	e8 9f 44 00 00       	call   8010542a <release>
80100f8b:	83 c4 10             	add    $0x10,%esp
      return f;
80100f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f91:	eb 22                	jmp    80100fb5 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f93:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f97:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
80100f9e:	72 ca                	jb     80100f6a <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
80100fa3:	68 80 18 11 80       	push   $0x80111880
80100fa8:	e8 7d 44 00 00       	call   8010542a <release>
80100fad:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fb5:	c9                   	leave  
80100fb6:	c3                   	ret    

80100fb7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fb7:	55                   	push   %ebp
80100fb8:	89 e5                	mov    %esp,%ebp
80100fba:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fbd:	83 ec 0c             	sub    $0xc,%esp
80100fc0:	68 80 18 11 80       	push   $0x80111880
80100fc5:	e8 fa 43 00 00       	call   801053c4 <acquire>
80100fca:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd0:	8b 40 04             	mov    0x4(%eax),%eax
80100fd3:	85 c0                	test   %eax,%eax
80100fd5:	7f 0d                	jg     80100fe4 <filedup+0x2d>
    panic("filedup");
80100fd7:	83 ec 0c             	sub    $0xc,%esp
80100fda:	68 20 8d 10 80       	push   $0x80108d20
80100fdf:	e8 78 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe7:	8b 40 04             	mov    0x4(%eax),%eax
80100fea:	8d 50 01             	lea    0x1(%eax),%edx
80100fed:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100ff3:	83 ec 0c             	sub    $0xc,%esp
80100ff6:	68 80 18 11 80       	push   $0x80111880
80100ffb:	e8 2a 44 00 00       	call   8010542a <release>
80101000:	83 c4 10             	add    $0x10,%esp
  return f;
80101003:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101006:	c9                   	leave  
80101007:	c3                   	ret    

80101008 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101008:	55                   	push   %ebp
80101009:	89 e5                	mov    %esp,%ebp
8010100b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010100e:	83 ec 0c             	sub    $0xc,%esp
80101011:	68 80 18 11 80       	push   $0x80111880
80101016:	e8 a9 43 00 00       	call   801053c4 <acquire>
8010101b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010101e:	8b 45 08             	mov    0x8(%ebp),%eax
80101021:	8b 40 04             	mov    0x4(%eax),%eax
80101024:	85 c0                	test   %eax,%eax
80101026:	7f 0d                	jg     80101035 <fileclose+0x2d>
    panic("fileclose");
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	68 28 8d 10 80       	push   $0x80108d28
80101030:	e8 27 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
80101035:	8b 45 08             	mov    0x8(%ebp),%eax
80101038:	8b 40 04             	mov    0x4(%eax),%eax
8010103b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010103e:	8b 45 08             	mov    0x8(%ebp),%eax
80101041:	89 50 04             	mov    %edx,0x4(%eax)
80101044:	8b 45 08             	mov    0x8(%ebp),%eax
80101047:	8b 40 04             	mov    0x4(%eax),%eax
8010104a:	85 c0                	test   %eax,%eax
8010104c:	7e 15                	jle    80101063 <fileclose+0x5b>
    release(&ftable.lock);
8010104e:	83 ec 0c             	sub    $0xc,%esp
80101051:	68 80 18 11 80       	push   $0x80111880
80101056:	e8 cf 43 00 00       	call   8010542a <release>
8010105b:	83 c4 10             	add    $0x10,%esp
8010105e:	e9 8b 00 00 00       	jmp    801010ee <fileclose+0xe6>
    return;
  }
  ff = *f;
80101063:	8b 45 08             	mov    0x8(%ebp),%eax
80101066:	8b 10                	mov    (%eax),%edx
80101068:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010106b:	8b 50 04             	mov    0x4(%eax),%edx
8010106e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101071:	8b 50 08             	mov    0x8(%eax),%edx
80101074:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101077:	8b 50 0c             	mov    0xc(%eax),%edx
8010107a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010107d:	8b 50 10             	mov    0x10(%eax),%edx
80101080:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101083:	8b 40 14             	mov    0x14(%eax),%eax
80101086:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101089:	8b 45 08             	mov    0x8(%ebp),%eax
8010108c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101093:	8b 45 08             	mov    0x8(%ebp),%eax
80101096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	68 80 18 11 80       	push   $0x80111880
801010a4:	e8 81 43 00 00       	call   8010542a <release>
801010a9:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010af:	83 f8 01             	cmp    $0x1,%eax
801010b2:	75 19                	jne    801010cd <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010b8:	0f be d0             	movsbl %al,%edx
801010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010be:	83 ec 08             	sub    $0x8,%esp
801010c1:	52                   	push   %edx
801010c2:	50                   	push   %eax
801010c3:	e8 da 2f 00 00       	call   801040a2 <pipeclose>
801010c8:	83 c4 10             	add    $0x10,%esp
801010cb:	eb 21                	jmp    801010ee <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d0:	83 f8 02             	cmp    $0x2,%eax
801010d3:	75 19                	jne    801010ee <fileclose+0xe6>
    begin_op();
801010d5:	e8 88 23 00 00       	call   80103462 <begin_op>
    iput(ff.ip);
801010da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010dd:	83 ec 0c             	sub    $0xc,%esp
801010e0:	50                   	push   %eax
801010e1:	e8 ac 09 00 00       	call   80101a92 <iput>
801010e6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010e9:	e8 02 24 00 00       	call   801034f0 <end_op>
  }
}
801010ee:	c9                   	leave  
801010ef:	c3                   	ret    

801010f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801010f6:	8b 45 08             	mov    0x8(%ebp),%eax
801010f9:	8b 00                	mov    (%eax),%eax
801010fb:	83 f8 02             	cmp    $0x2,%eax
801010fe:	75 40                	jne    80101140 <filestat+0x50>
    ilock(f->ip);
80101100:	8b 45 08             	mov    0x8(%ebp),%eax
80101103:	8b 40 10             	mov    0x10(%eax),%eax
80101106:	83 ec 0c             	sub    $0xc,%esp
80101109:	50                   	push   %eax
8010110a:	e8 bb 07 00 00       	call   801018ca <ilock>
8010110f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101112:	8b 45 08             	mov    0x8(%ebp),%eax
80101115:	8b 40 10             	mov    0x10(%eax),%eax
80101118:	83 ec 08             	sub    $0x8,%esp
8010111b:	ff 75 0c             	pushl  0xc(%ebp)
8010111e:	50                   	push   %eax
8010111f:	e8 c3 0c 00 00       	call   80101de7 <stati>
80101124:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101127:	8b 45 08             	mov    0x8(%ebp),%eax
8010112a:	8b 40 10             	mov    0x10(%eax),%eax
8010112d:	83 ec 0c             	sub    $0xc,%esp
80101130:	50                   	push   %eax
80101131:	e8 eb 08 00 00       	call   80101a21 <iunlock>
80101136:	83 c4 10             	add    $0x10,%esp
    return 0;
80101139:	b8 00 00 00 00       	mov    $0x0,%eax
8010113e:	eb 05                	jmp    80101145 <filestat+0x55>
  }
  return -1;
80101140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101145:	c9                   	leave  
80101146:	c3                   	ret    

80101147 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101147:	55                   	push   %ebp
80101148:	89 e5                	mov    %esp,%ebp
8010114a:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101154:	84 c0                	test   %al,%al
80101156:	75 0a                	jne    80101162 <fileread+0x1b>
    return -1;
80101158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010115d:	e9 9b 00 00 00       	jmp    801011fd <fileread+0xb6>
  if(f->type == FD_PIPE)
80101162:	8b 45 08             	mov    0x8(%ebp),%eax
80101165:	8b 00                	mov    (%eax),%eax
80101167:	83 f8 01             	cmp    $0x1,%eax
8010116a:	75 1a                	jne    80101186 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010116c:	8b 45 08             	mov    0x8(%ebp),%eax
8010116f:	8b 40 0c             	mov    0xc(%eax),%eax
80101172:	83 ec 04             	sub    $0x4,%esp
80101175:	ff 75 10             	pushl  0x10(%ebp)
80101178:	ff 75 0c             	pushl  0xc(%ebp)
8010117b:	50                   	push   %eax
8010117c:	e8 ce 30 00 00       	call   8010424f <piperead>
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	eb 77                	jmp    801011fd <fileread+0xb6>
  if(f->type == FD_INODE){
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	8b 00                	mov    (%eax),%eax
8010118b:	83 f8 02             	cmp    $0x2,%eax
8010118e:	75 60                	jne    801011f0 <fileread+0xa9>
    ilock(f->ip);
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 40 10             	mov    0x10(%eax),%eax
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	50                   	push   %eax
8010119a:	e8 2b 07 00 00       	call   801018ca <ilock>
8010119f:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 50 14             	mov    0x14(%eax),%edx
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8b 40 10             	mov    0x10(%eax),%eax
801011b1:	51                   	push   %ecx
801011b2:	52                   	push   %edx
801011b3:	ff 75 0c             	pushl  0xc(%ebp)
801011b6:	50                   	push   %eax
801011b7:	e8 70 0c 00 00       	call   80101e2c <readi>
801011bc:	83 c4 10             	add    $0x10,%esp
801011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011c6:	7e 11                	jle    801011d9 <fileread+0x92>
      f->off += r;
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 50 14             	mov    0x14(%eax),%edx
801011ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d1:	01 c2                	add    %eax,%edx
801011d3:	8b 45 08             	mov    0x8(%ebp),%eax
801011d6:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	50                   	push   %eax
801011e3:	e8 39 08 00 00       	call   80101a21 <iunlock>
801011e8:	83 c4 10             	add    $0x10,%esp
    return r;
801011eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ee:	eb 0d                	jmp    801011fd <fileread+0xb6>
  }
  panic("fileread");
801011f0:	83 ec 0c             	sub    $0xc,%esp
801011f3:	68 32 8d 10 80       	push   $0x80108d32
801011f8:	e8 5f f3 ff ff       	call   8010055c <panic>
}
801011fd:	c9                   	leave  
801011fe:	c3                   	ret    

801011ff <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011ff:	55                   	push   %ebp
80101200:	89 e5                	mov    %esp,%ebp
80101202:	53                   	push   %ebx
80101203:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101206:	8b 45 08             	mov    0x8(%ebp),%eax
80101209:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010120d:	84 c0                	test   %al,%al
8010120f:	75 0a                	jne    8010121b <filewrite+0x1c>
    return -1;
80101211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101216:	e9 1a 01 00 00       	jmp    80101335 <filewrite+0x136>
  if(f->type == FD_PIPE)
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 00                	mov    (%eax),%eax
80101220:	83 f8 01             	cmp    $0x1,%eax
80101223:	75 1d                	jne    80101242 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101225:	8b 45 08             	mov    0x8(%ebp),%eax
80101228:	8b 40 0c             	mov    0xc(%eax),%eax
8010122b:	83 ec 04             	sub    $0x4,%esp
8010122e:	ff 75 10             	pushl  0x10(%ebp)
80101231:	ff 75 0c             	pushl  0xc(%ebp)
80101234:	50                   	push   %eax
80101235:	e8 11 2f 00 00       	call   8010414b <pipewrite>
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	e9 f3 00 00 00       	jmp    80101335 <filewrite+0x136>
  if(f->type == FD_INODE){
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 00                	mov    (%eax),%eax
80101247:	83 f8 02             	cmp    $0x2,%eax
8010124a:	0f 85 d8 00 00 00    	jne    80101328 <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101250:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010125e:	e9 a5 00 00 00       	jmp    80101308 <filewrite+0x109>
      int n1 = n - i;
80101263:	8b 45 10             	mov    0x10(%ebp),%eax
80101266:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101269:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010126c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010126f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101272:	7e 06                	jle    8010127a <filewrite+0x7b>
        n1 = max;
80101274:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101277:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010127a:	e8 e3 21 00 00       	call   80103462 <begin_op>
      ilock(f->ip);
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 40 10             	mov    0x10(%eax),%eax
80101285:	83 ec 0c             	sub    $0xc,%esp
80101288:	50                   	push   %eax
80101289:	e8 3c 06 00 00       	call   801018ca <ilock>
8010128e:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101291:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101294:	8b 45 08             	mov    0x8(%ebp),%eax
80101297:	8b 50 14             	mov    0x14(%eax),%edx
8010129a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010129d:	8b 45 0c             	mov    0xc(%ebp),%eax
801012a0:	01 c3                	add    %eax,%ebx
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 40 10             	mov    0x10(%eax),%eax
801012a8:	51                   	push   %ecx
801012a9:	52                   	push   %edx
801012aa:	53                   	push   %ebx
801012ab:	50                   	push   %eax
801012ac:	e8 dc 0c 00 00       	call   80101f8d <writei>
801012b1:	83 c4 10             	add    $0x10,%esp
801012b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012bb:	7e 11                	jle    801012ce <filewrite+0xcf>
        f->off += r;
801012bd:	8b 45 08             	mov    0x8(%ebp),%eax
801012c0:	8b 50 14             	mov    0x14(%eax),%edx
801012c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012c6:	01 c2                	add    %eax,%edx
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012ce:	8b 45 08             	mov    0x8(%ebp),%eax
801012d1:	8b 40 10             	mov    0x10(%eax),%eax
801012d4:	83 ec 0c             	sub    $0xc,%esp
801012d7:	50                   	push   %eax
801012d8:	e8 44 07 00 00       	call   80101a21 <iunlock>
801012dd:	83 c4 10             	add    $0x10,%esp
      end_op();
801012e0:	e8 0b 22 00 00       	call   801034f0 <end_op>

      if(r < 0)
801012e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012e9:	79 02                	jns    801012ed <filewrite+0xee>
        break;
801012eb:	eb 27                	jmp    80101314 <filewrite+0x115>
      if(r != n1)
801012ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012f3:	74 0d                	je     80101302 <filewrite+0x103>
        panic("short filewrite");
801012f5:	83 ec 0c             	sub    $0xc,%esp
801012f8:	68 3b 8d 10 80       	push   $0x80108d3b
801012fd:	e8 5a f2 ff ff       	call   8010055c <panic>
      i += r;
80101302:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101305:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010130b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010130e:	0f 8c 4f ff ff ff    	jl     80101263 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101317:	3b 45 10             	cmp    0x10(%ebp),%eax
8010131a:	75 05                	jne    80101321 <filewrite+0x122>
8010131c:	8b 45 10             	mov    0x10(%ebp),%eax
8010131f:	eb 14                	jmp    80101335 <filewrite+0x136>
80101321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101326:	eb 0d                	jmp    80101335 <filewrite+0x136>
  }
  panic("filewrite");
80101328:	83 ec 0c             	sub    $0xc,%esp
8010132b:	68 4b 8d 10 80       	push   $0x80108d4b
80101330:	e8 27 f2 ff ff       	call   8010055c <panic>
}
80101335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101338:	c9                   	leave  
80101339:	c3                   	ret    

8010133a <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010133a:	55                   	push   %ebp
8010133b:	89 e5                	mov    %esp,%ebp
8010133d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101340:	8b 45 08             	mov    0x8(%ebp),%eax
80101343:	83 ec 08             	sub    $0x8,%esp
80101346:	6a 01                	push   $0x1
80101348:	50                   	push   %eax
80101349:	e8 66 ee ff ff       	call   801001b4 <bread>
8010134e:	83 c4 10             	add    $0x10,%esp
80101351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101357:	83 c0 18             	add    $0x18,%eax
8010135a:	83 ec 04             	sub    $0x4,%esp
8010135d:	6a 10                	push   $0x10
8010135f:	50                   	push   %eax
80101360:	ff 75 0c             	pushl  0xc(%ebp)
80101363:	e8 77 43 00 00       	call   801056df <memmove>
80101368:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010136b:	83 ec 0c             	sub    $0xc,%esp
8010136e:	ff 75 f4             	pushl  -0xc(%ebp)
80101371:	e8 b5 ee ff ff       	call   8010022b <brelse>
80101376:	83 c4 10             	add    $0x10,%esp
}
80101379:	c9                   	leave  
8010137a:	c3                   	ret    

8010137b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010137b:	55                   	push   %ebp
8010137c:	89 e5                	mov    %esp,%ebp
8010137e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101381:	8b 55 0c             	mov    0xc(%ebp),%edx
80101384:	8b 45 08             	mov    0x8(%ebp),%eax
80101387:	83 ec 08             	sub    $0x8,%esp
8010138a:	52                   	push   %edx
8010138b:	50                   	push   %eax
8010138c:	e8 23 ee ff ff       	call   801001b4 <bread>
80101391:	83 c4 10             	add    $0x10,%esp
80101394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139a:	83 c0 18             	add    $0x18,%eax
8010139d:	83 ec 04             	sub    $0x4,%esp
801013a0:	68 00 02 00 00       	push   $0x200
801013a5:	6a 00                	push   $0x0
801013a7:	50                   	push   %eax
801013a8:	e8 73 42 00 00       	call   80105620 <memset>
801013ad:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013b0:	83 ec 0c             	sub    $0xc,%esp
801013b3:	ff 75 f4             	pushl  -0xc(%ebp)
801013b6:	e8 de 22 00 00       	call   80103699 <log_write>
801013bb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013be:	83 ec 0c             	sub    $0xc,%esp
801013c1:	ff 75 f4             	pushl  -0xc(%ebp)
801013c4:	e8 62 ee ff ff       	call   8010022b <brelse>
801013c9:	83 c4 10             	add    $0x10,%esp
}
801013cc:	c9                   	leave  
801013cd:	c3                   	ret    

801013ce <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013ce:	55                   	push   %ebp
801013cf:	89 e5                	mov    %esp,%ebp
801013d1:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	83 ec 08             	sub    $0x8,%esp
801013e1:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013e4:	52                   	push   %edx
801013e5:	50                   	push   %eax
801013e6:	e8 4f ff ff ff       	call   8010133a <readsb>
801013eb:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801013ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013f5:	e9 0c 01 00 00       	jmp    80101506 <balloc+0x138>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fd:	99                   	cltd   
801013fe:	c1 ea 14             	shr    $0x14,%edx
80101401:	01 d0                	add    %edx,%eax
80101403:	c1 f8 0c             	sar    $0xc,%eax
80101406:	89 c2                	mov    %eax,%edx
80101408:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010140b:	c1 e8 03             	shr    $0x3,%eax
8010140e:	01 d0                	add    %edx,%eax
80101410:	83 c0 03             	add    $0x3,%eax
80101413:	83 ec 08             	sub    $0x8,%esp
80101416:	50                   	push   %eax
80101417:	ff 75 08             	pushl  0x8(%ebp)
8010141a:	e8 95 ed ff ff       	call   801001b4 <bread>
8010141f:	83 c4 10             	add    $0x10,%esp
80101422:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010142c:	e9 a2 00 00 00       	jmp    801014d3 <balloc+0x105>
      m = 1 << (bi % 8);
80101431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101434:	99                   	cltd   
80101435:	c1 ea 1d             	shr    $0x1d,%edx
80101438:	01 d0                	add    %edx,%eax
8010143a:	83 e0 07             	and    $0x7,%eax
8010143d:	29 d0                	sub    %edx,%eax
8010143f:	ba 01 00 00 00       	mov    $0x1,%edx
80101444:	89 c1                	mov    %eax,%ecx
80101446:	d3 e2                	shl    %cl,%edx
80101448:	89 d0                	mov    %edx,%eax
8010144a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101450:	99                   	cltd   
80101451:	c1 ea 1d             	shr    $0x1d,%edx
80101454:	01 d0                	add    %edx,%eax
80101456:	c1 f8 03             	sar    $0x3,%eax
80101459:	89 c2                	mov    %eax,%edx
8010145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101463:	0f b6 c0             	movzbl %al,%eax
80101466:	23 45 e8             	and    -0x18(%ebp),%eax
80101469:	85 c0                	test   %eax,%eax
8010146b:	75 62                	jne    801014cf <balloc+0x101>
        bp->data[bi/8] |= m;  // Mark block in use.
8010146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101470:	99                   	cltd   
80101471:	c1 ea 1d             	shr    $0x1d,%edx
80101474:	01 d0                	add    %edx,%eax
80101476:	c1 f8 03             	sar    $0x3,%eax
80101479:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010147c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101481:	89 d1                	mov    %edx,%ecx
80101483:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101486:	09 ca                	or     %ecx,%edx
80101488:	89 d1                	mov    %edx,%ecx
8010148a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010148d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	ff 75 ec             	pushl  -0x14(%ebp)
80101497:	e8 fd 21 00 00       	call   80103699 <log_write>
8010149c:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010149f:	83 ec 0c             	sub    $0xc,%esp
801014a2:	ff 75 ec             	pushl  -0x14(%ebp)
801014a5:	e8 81 ed ff ff       	call   8010022b <brelse>
801014aa:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b3:	01 c2                	add    %eax,%edx
801014b5:	8b 45 08             	mov    0x8(%ebp),%eax
801014b8:	83 ec 08             	sub    $0x8,%esp
801014bb:	52                   	push   %edx
801014bc:	50                   	push   %eax
801014bd:	e8 b9 fe ff ff       	call   8010137b <bzero>
801014c2:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014cb:	01 d0                	add    %edx,%eax
801014cd:	eb 52                	jmp    80101521 <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014d3:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014da:	7f 15                	jg     801014f1 <balloc+0x123>
801014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e2:	01 d0                	add    %edx,%eax
801014e4:	89 c2                	mov    %eax,%edx
801014e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e9:	39 c2                	cmp    %eax,%edx
801014eb:	0f 82 40 ff ff ff    	jb     80101431 <balloc+0x63>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	ff 75 ec             	pushl  -0x14(%ebp)
801014f7:	e8 2f ed ff ff       	call   8010022b <brelse>
801014fc:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101506:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101509:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010150c:	39 c2                	cmp    %eax,%edx
8010150e:	0f 82 e6 fe ff ff    	jb     801013fa <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101514:	83 ec 0c             	sub    $0xc,%esp
80101517:	68 55 8d 10 80       	push   $0x80108d55
8010151c:	e8 3b f0 ff ff       	call   8010055c <panic>
}
80101521:	c9                   	leave  
80101522:	c3                   	ret    

80101523 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101523:	55                   	push   %ebp
80101524:	89 e5                	mov    %esp,%ebp
80101526:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101529:	83 ec 08             	sub    $0x8,%esp
8010152c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010152f:	50                   	push   %eax
80101530:	ff 75 08             	pushl  0x8(%ebp)
80101533:	e8 02 fe ff ff       	call   8010133a <readsb>
80101538:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010153b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010153e:	c1 e8 0c             	shr    $0xc,%eax
80101541:	89 c2                	mov    %eax,%edx
80101543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101546:	c1 e8 03             	shr    $0x3,%eax
80101549:	01 d0                	add    %edx,%eax
8010154b:	8d 50 03             	lea    0x3(%eax),%edx
8010154e:	8b 45 08             	mov    0x8(%ebp),%eax
80101551:	83 ec 08             	sub    $0x8,%esp
80101554:	52                   	push   %edx
80101555:	50                   	push   %eax
80101556:	e8 59 ec ff ff       	call   801001b4 <bread>
8010155b:	83 c4 10             	add    $0x10,%esp
8010155e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101561:	8b 45 0c             	mov    0xc(%ebp),%eax
80101564:	25 ff 0f 00 00       	and    $0xfff,%eax
80101569:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156f:	99                   	cltd   
80101570:	c1 ea 1d             	shr    $0x1d,%edx
80101573:	01 d0                	add    %edx,%eax
80101575:	83 e0 07             	and    $0x7,%eax
80101578:	29 d0                	sub    %edx,%eax
8010157a:	ba 01 00 00 00       	mov    $0x1,%edx
8010157f:	89 c1                	mov    %eax,%ecx
80101581:	d3 e2                	shl    %cl,%edx
80101583:	89 d0                	mov    %edx,%eax
80101585:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158b:	99                   	cltd   
8010158c:	c1 ea 1d             	shr    $0x1d,%edx
8010158f:	01 d0                	add    %edx,%eax
80101591:	c1 f8 03             	sar    $0x3,%eax
80101594:	89 c2                	mov    %eax,%edx
80101596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101599:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010159e:	0f b6 c0             	movzbl %al,%eax
801015a1:	23 45 ec             	and    -0x14(%ebp),%eax
801015a4:	85 c0                	test   %eax,%eax
801015a6:	75 0d                	jne    801015b5 <bfree+0x92>
    panic("freeing free block");
801015a8:	83 ec 0c             	sub    $0xc,%esp
801015ab:	68 6b 8d 10 80       	push   $0x80108d6b
801015b0:	e8 a7 ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b8:	99                   	cltd   
801015b9:	c1 ea 1d             	shr    $0x1d,%edx
801015bc:	01 d0                	add    %edx,%eax
801015be:	c1 f8 03             	sar    $0x3,%eax
801015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c4:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015c9:	89 d1                	mov    %edx,%ecx
801015cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015ce:	f7 d2                	not    %edx
801015d0:	21 ca                	and    %ecx,%edx
801015d2:	89 d1                	mov    %edx,%ecx
801015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015db:	83 ec 0c             	sub    $0xc,%esp
801015de:	ff 75 f4             	pushl  -0xc(%ebp)
801015e1:	e8 b3 20 00 00       	call   80103699 <log_write>
801015e6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015e9:	83 ec 0c             	sub    $0xc,%esp
801015ec:	ff 75 f4             	pushl  -0xc(%ebp)
801015ef:	e8 37 ec ff ff       	call   8010022b <brelse>
801015f4:	83 c4 10             	add    $0x10,%esp
}
801015f7:	c9                   	leave  
801015f8:	c3                   	ret    

801015f9 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015f9:	55                   	push   %ebp
801015fa:	89 e5                	mov    %esp,%ebp
801015fc:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	68 7e 8d 10 80       	push   $0x80108d7e
80101607:	68 c0 22 11 80       	push   $0x801122c0
8010160c:	e8 92 3d 00 00       	call   801053a3 <initlock>
80101611:	83 c4 10             	add    $0x10,%esp
}
80101614:	c9                   	leave  
80101615:	c3                   	ret    

80101616 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101616:	55                   	push   %ebp
80101617:	89 e5                	mov    %esp,%ebp
80101619:	83 ec 38             	sub    $0x38,%esp
8010161c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010161f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101623:	8b 45 08             	mov    0x8(%ebp),%eax
80101626:	83 ec 08             	sub    $0x8,%esp
80101629:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010162c:	52                   	push   %edx
8010162d:	50                   	push   %eax
8010162e:	e8 07 fd ff ff       	call   8010133a <readsb>
80101633:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101636:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010163d:	e9 98 00 00 00       	jmp    801016da <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101645:	c1 e8 03             	shr    $0x3,%eax
80101648:	83 c0 02             	add    $0x2,%eax
8010164b:	83 ec 08             	sub    $0x8,%esp
8010164e:	50                   	push   %eax
8010164f:	ff 75 08             	pushl  0x8(%ebp)
80101652:	e8 5d eb ff ff       	call   801001b4 <bread>
80101657:	83 c4 10             	add    $0x10,%esp
8010165a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101660:	8d 50 18             	lea    0x18(%eax),%edx
80101663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101666:	83 e0 07             	and    $0x7,%eax
80101669:	c1 e0 06             	shl    $0x6,%eax
8010166c:	01 d0                	add    %edx,%eax
8010166e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101671:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101674:	0f b7 00             	movzwl (%eax),%eax
80101677:	66 85 c0             	test   %ax,%ax
8010167a:	75 4c                	jne    801016c8 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
8010167c:	83 ec 04             	sub    $0x4,%esp
8010167f:	6a 40                	push   $0x40
80101681:	6a 00                	push   $0x0
80101683:	ff 75 ec             	pushl  -0x14(%ebp)
80101686:	e8 95 3f 00 00       	call   80105620 <memset>
8010168b:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010168e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101691:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101695:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101698:	83 ec 0c             	sub    $0xc,%esp
8010169b:	ff 75 f0             	pushl  -0x10(%ebp)
8010169e:	e8 f6 1f 00 00       	call   80103699 <log_write>
801016a3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016a6:	83 ec 0c             	sub    $0xc,%esp
801016a9:	ff 75 f0             	pushl  -0x10(%ebp)
801016ac:	e8 7a eb ff ff       	call   8010022b <brelse>
801016b1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b7:	83 ec 08             	sub    $0x8,%esp
801016ba:	50                   	push   %eax
801016bb:	ff 75 08             	pushl  0x8(%ebp)
801016be:	e8 ee 00 00 00       	call   801017b1 <iget>
801016c3:	83 c4 10             	add    $0x10,%esp
801016c6:	eb 2d                	jmp    801016f5 <ialloc+0xdf>
    }
    brelse(bp);
801016c8:	83 ec 0c             	sub    $0xc,%esp
801016cb:	ff 75 f0             	pushl  -0x10(%ebp)
801016ce:	e8 58 eb ff ff       	call   8010022b <brelse>
801016d3:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016e0:	39 c2                	cmp    %eax,%edx
801016e2:	0f 82 5a ff ff ff    	jb     80101642 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016e8:	83 ec 0c             	sub    $0xc,%esp
801016eb:	68 85 8d 10 80       	push   $0x80108d85
801016f0:	e8 67 ee ff ff       	call   8010055c <panic>
}
801016f5:	c9                   	leave  
801016f6:	c3                   	ret    

801016f7 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016f7:	55                   	push   %ebp
801016f8:	89 e5                	mov    %esp,%ebp
801016fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	8b 40 04             	mov    0x4(%eax),%eax
80101703:	c1 e8 03             	shr    $0x3,%eax
80101706:	8d 50 02             	lea    0x2(%eax),%edx
80101709:	8b 45 08             	mov    0x8(%ebp),%eax
8010170c:	8b 00                	mov    (%eax),%eax
8010170e:	83 ec 08             	sub    $0x8,%esp
80101711:	52                   	push   %edx
80101712:	50                   	push   %eax
80101713:	e8 9c ea ff ff       	call   801001b4 <bread>
80101718:	83 c4 10             	add    $0x10,%esp
8010171b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101721:	8d 50 18             	lea    0x18(%eax),%edx
80101724:	8b 45 08             	mov    0x8(%ebp),%eax
80101727:	8b 40 04             	mov    0x4(%eax),%eax
8010172a:	83 e0 07             	and    $0x7,%eax
8010172d:	c1 e0 06             	shl    $0x6,%eax
80101730:	01 d0                	add    %edx,%eax
80101732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101735:	8b 45 08             	mov    0x8(%ebp),%eax
80101738:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010173c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101742:	8b 45 08             	mov    0x8(%ebp),%eax
80101745:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101749:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101750:	8b 45 08             	mov    0x8(%ebp),%eax
80101753:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101757:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010175e:	8b 45 08             	mov    0x8(%ebp),%eax
80101761:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101765:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101768:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010176c:	8b 45 08             	mov    0x8(%ebp),%eax
8010176f:	8b 50 18             	mov    0x18(%eax),%edx
80101772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101775:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101778:	8b 45 08             	mov    0x8(%ebp),%eax
8010177b:	8d 50 1c             	lea    0x1c(%eax),%edx
8010177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101781:	83 c0 0c             	add    $0xc,%eax
80101784:	83 ec 04             	sub    $0x4,%esp
80101787:	6a 34                	push   $0x34
80101789:	52                   	push   %edx
8010178a:	50                   	push   %eax
8010178b:	e8 4f 3f 00 00       	call   801056df <memmove>
80101790:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101793:	83 ec 0c             	sub    $0xc,%esp
80101796:	ff 75 f4             	pushl  -0xc(%ebp)
80101799:	e8 fb 1e 00 00       	call   80103699 <log_write>
8010179e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	ff 75 f4             	pushl  -0xc(%ebp)
801017a7:	e8 7f ea ff ff       	call   8010022b <brelse>
801017ac:	83 c4 10             	add    $0x10,%esp
}
801017af:	c9                   	leave  
801017b0:	c3                   	ret    

801017b1 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017b1:	55                   	push   %ebp
801017b2:	89 e5                	mov    %esp,%ebp
801017b4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017b7:	83 ec 0c             	sub    $0xc,%esp
801017ba:	68 c0 22 11 80       	push   $0x801122c0
801017bf:	e8 00 3c 00 00       	call   801053c4 <acquire>
801017c4:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801017c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ce:	c7 45 f4 f4 22 11 80 	movl   $0x801122f4,-0xc(%ebp)
801017d5:	eb 5d                	jmp    80101834 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017da:	8b 40 08             	mov    0x8(%eax),%eax
801017dd:	85 c0                	test   %eax,%eax
801017df:	7e 39                	jle    8010181a <iget+0x69>
801017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e4:	8b 00                	mov    (%eax),%eax
801017e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801017e9:	75 2f                	jne    8010181a <iget+0x69>
801017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ee:	8b 40 04             	mov    0x4(%eax),%eax
801017f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017f4:	75 24                	jne    8010181a <iget+0x69>
      ip->ref++;
801017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f9:	8b 40 08             	mov    0x8(%eax),%eax
801017fc:	8d 50 01             	lea    0x1(%eax),%edx
801017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101802:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101805:	83 ec 0c             	sub    $0xc,%esp
80101808:	68 c0 22 11 80       	push   $0x801122c0
8010180d:	e8 18 3c 00 00       	call   8010542a <release>
80101812:	83 c4 10             	add    $0x10,%esp
      return ip;
80101815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101818:	eb 74                	jmp    8010188e <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010181a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010181e:	75 10                	jne    80101830 <iget+0x7f>
80101820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101823:	8b 40 08             	mov    0x8(%eax),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	75 06                	jne    80101830 <iget+0x7f>
      empty = ip;
8010182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101830:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101834:	81 7d f4 94 32 11 80 	cmpl   $0x80113294,-0xc(%ebp)
8010183b:	72 9a                	jb     801017d7 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010183d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101841:	75 0d                	jne    80101850 <iget+0x9f>
    panic("iget: no inodes");
80101843:	83 ec 0c             	sub    $0xc,%esp
80101846:	68 97 8d 10 80       	push   $0x80108d97
8010184b:	e8 0c ed ff ff       	call   8010055c <panic>

  ip = empty;
80101850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101859:	8b 55 08             	mov    0x8(%ebp),%edx
8010185c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101861:	8b 55 0c             	mov    0xc(%ebp),%edx
80101864:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101874:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010187b:	83 ec 0c             	sub    $0xc,%esp
8010187e:	68 c0 22 11 80       	push   $0x801122c0
80101883:	e8 a2 3b 00 00       	call   8010542a <release>
80101888:	83 c4 10             	add    $0x10,%esp

  return ip;
8010188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010188e:	c9                   	leave  
8010188f:	c3                   	ret    

80101890 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	68 c0 22 11 80       	push   $0x801122c0
8010189e:	e8 21 3b 00 00       	call   801053c4 <acquire>
801018a3:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018a6:	8b 45 08             	mov    0x8(%ebp),%eax
801018a9:	8b 40 08             	mov    0x8(%eax),%eax
801018ac:	8d 50 01             	lea    0x1(%eax),%edx
801018af:	8b 45 08             	mov    0x8(%ebp),%eax
801018b2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018b5:	83 ec 0c             	sub    $0xc,%esp
801018b8:	68 c0 22 11 80       	push   $0x801122c0
801018bd:	e8 68 3b 00 00       	call   8010542a <release>
801018c2:	83 c4 10             	add    $0x10,%esp
  return ip;
801018c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018c8:	c9                   	leave  
801018c9:	c3                   	ret    

801018ca <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018ca:	55                   	push   %ebp
801018cb:	89 e5                	mov    %esp,%ebp
801018cd:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018d4:	74 0a                	je     801018e0 <ilock+0x16>
801018d6:	8b 45 08             	mov    0x8(%ebp),%eax
801018d9:	8b 40 08             	mov    0x8(%eax),%eax
801018dc:	85 c0                	test   %eax,%eax
801018de:	7f 0d                	jg     801018ed <ilock+0x23>
    panic("ilock");
801018e0:	83 ec 0c             	sub    $0xc,%esp
801018e3:	68 a7 8d 10 80       	push   $0x80108da7
801018e8:	e8 6f ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
801018ed:	83 ec 0c             	sub    $0xc,%esp
801018f0:	68 c0 22 11 80       	push   $0x801122c0
801018f5:	e8 ca 3a 00 00       	call   801053c4 <acquire>
801018fa:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801018fd:	eb 13                	jmp    80101912 <ilock+0x48>
    sleep(ip, &icache.lock);
801018ff:	83 ec 08             	sub    $0x8,%esp
80101902:	68 c0 22 11 80       	push   $0x801122c0
80101907:	ff 75 08             	pushl  0x8(%ebp)
8010190a:	e8 c1 35 00 00       	call   80104ed0 <sleep>
8010190f:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101912:	8b 45 08             	mov    0x8(%ebp),%eax
80101915:	8b 40 0c             	mov    0xc(%eax),%eax
80101918:	83 e0 01             	and    $0x1,%eax
8010191b:	85 c0                	test   %eax,%eax
8010191d:	75 e0                	jne    801018ff <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010191f:	8b 45 08             	mov    0x8(%ebp),%eax
80101922:	8b 40 0c             	mov    0xc(%eax),%eax
80101925:	83 c8 01             	or     $0x1,%eax
80101928:	89 c2                	mov    %eax,%edx
8010192a:	8b 45 08             	mov    0x8(%ebp),%eax
8010192d:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 c0 22 11 80       	push   $0x801122c0
80101938:	e8 ed 3a 00 00       	call   8010542a <release>
8010193d:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	8b 40 0c             	mov    0xc(%eax),%eax
80101946:	83 e0 02             	and    $0x2,%eax
80101949:	85 c0                	test   %eax,%eax
8010194b:	0f 85 ce 00 00 00    	jne    80101a1f <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	8b 40 04             	mov    0x4(%eax),%eax
80101957:	c1 e8 03             	shr    $0x3,%eax
8010195a:	8d 50 02             	lea    0x2(%eax),%edx
8010195d:	8b 45 08             	mov    0x8(%ebp),%eax
80101960:	8b 00                	mov    (%eax),%eax
80101962:	83 ec 08             	sub    $0x8,%esp
80101965:	52                   	push   %edx
80101966:	50                   	push   %eax
80101967:	e8 48 e8 ff ff       	call   801001b4 <bread>
8010196c:	83 c4 10             	add    $0x10,%esp
8010196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101975:	8d 50 18             	lea    0x18(%eax),%edx
80101978:	8b 45 08             	mov    0x8(%ebp),%eax
8010197b:	8b 40 04             	mov    0x4(%eax),%eax
8010197e:	83 e0 07             	and    $0x7,%eax
80101981:	c1 e0 06             	shl    $0x6,%eax
80101984:	01 d0                	add    %edx,%eax
80101986:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198c:	0f b7 10             	movzwl (%eax),%edx
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101996:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101999:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010199d:	8b 45 08             	mov    0x8(%ebp),%eax
801019a0:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a7:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019ab:	8b 45 08             	mov    0x8(%ebp),%eax
801019ae:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c3:	8b 50 08             	mov    0x8(%eax),%edx
801019c6:	8b 45 08             	mov    0x8(%ebp),%eax
801019c9:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cf:	8d 50 0c             	lea    0xc(%eax),%edx
801019d2:	8b 45 08             	mov    0x8(%ebp),%eax
801019d5:	83 c0 1c             	add    $0x1c,%eax
801019d8:	83 ec 04             	sub    $0x4,%esp
801019db:	6a 34                	push   $0x34
801019dd:	52                   	push   %edx
801019de:	50                   	push   %eax
801019df:	e8 fb 3c 00 00       	call   801056df <memmove>
801019e4:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	ff 75 f4             	pushl  -0xc(%ebp)
801019ed:	e8 39 e8 ff ff       	call   8010022b <brelse>
801019f2:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	8b 40 0c             	mov    0xc(%eax),%eax
801019fb:	83 c8 02             	or     $0x2,%eax
801019fe:	89 c2                	mov    %eax,%edx
80101a00:	8b 45 08             	mov    0x8(%ebp),%eax
80101a03:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a0d:	66 85 c0             	test   %ax,%ax
80101a10:	75 0d                	jne    80101a1f <ilock+0x155>
      panic("ilock: no type");
80101a12:	83 ec 0c             	sub    $0xc,%esp
80101a15:	68 ad 8d 10 80       	push   $0x80108dad
80101a1a:	e8 3d eb ff ff       	call   8010055c <panic>
  }
}
80101a1f:	c9                   	leave  
80101a20:	c3                   	ret    

80101a21 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a21:	55                   	push   %ebp
80101a22:	89 e5                	mov    %esp,%ebp
80101a24:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a2b:	74 17                	je     80101a44 <iunlock+0x23>
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 0c             	mov    0xc(%eax),%eax
80101a33:	83 e0 01             	and    $0x1,%eax
80101a36:	85 c0                	test   %eax,%eax
80101a38:	74 0a                	je     80101a44 <iunlock+0x23>
80101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3d:	8b 40 08             	mov    0x8(%eax),%eax
80101a40:	85 c0                	test   %eax,%eax
80101a42:	7f 0d                	jg     80101a51 <iunlock+0x30>
    panic("iunlock");
80101a44:	83 ec 0c             	sub    $0xc,%esp
80101a47:	68 bc 8d 10 80       	push   $0x80108dbc
80101a4c:	e8 0b eb ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101a51:	83 ec 0c             	sub    $0xc,%esp
80101a54:	68 c0 22 11 80       	push   $0x801122c0
80101a59:	e8 66 39 00 00       	call   801053c4 <acquire>
80101a5e:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a61:	8b 45 08             	mov    0x8(%ebp),%eax
80101a64:	8b 40 0c             	mov    0xc(%eax),%eax
80101a67:	83 e0 fe             	and    $0xfffffffe,%eax
80101a6a:	89 c2                	mov    %eax,%edx
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a72:	83 ec 0c             	sub    $0xc,%esp
80101a75:	ff 75 08             	pushl  0x8(%ebp)
80101a78:	e8 76 35 00 00       	call   80104ff3 <wakeup>
80101a7d:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101a80:	83 ec 0c             	sub    $0xc,%esp
80101a83:	68 c0 22 11 80       	push   $0x801122c0
80101a88:	e8 9d 39 00 00       	call   8010542a <release>
80101a8d:	83 c4 10             	add    $0x10,%esp
}
80101a90:	c9                   	leave  
80101a91:	c3                   	ret    

80101a92 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a92:	55                   	push   %ebp
80101a93:	89 e5                	mov    %esp,%ebp
80101a95:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a98:	83 ec 0c             	sub    $0xc,%esp
80101a9b:	68 c0 22 11 80       	push   $0x801122c0
80101aa0:	e8 1f 39 00 00       	call   801053c4 <acquire>
80101aa5:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	8b 40 08             	mov    0x8(%eax),%eax
80101aae:	83 f8 01             	cmp    $0x1,%eax
80101ab1:	0f 85 a9 00 00 00    	jne    80101b60 <iput+0xce>
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	8b 40 0c             	mov    0xc(%eax),%eax
80101abd:	83 e0 02             	and    $0x2,%eax
80101ac0:	85 c0                	test   %eax,%eax
80101ac2:	0f 84 98 00 00 00    	je     80101b60 <iput+0xce>
80101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80101acb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101acf:	66 85 c0             	test   %ax,%ax
80101ad2:	0f 85 88 00 00 00    	jne    80101b60 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	8b 40 0c             	mov    0xc(%eax),%eax
80101ade:	83 e0 01             	and    $0x1,%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0d                	je     80101af2 <iput+0x60>
      panic("iput busy");
80101ae5:	83 ec 0c             	sub    $0xc,%esp
80101ae8:	68 c4 8d 10 80       	push   $0x80108dc4
80101aed:	e8 6a ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	8b 40 0c             	mov    0xc(%eax),%eax
80101af8:	83 c8 01             	or     $0x1,%eax
80101afb:	89 c2                	mov    %eax,%edx
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b03:	83 ec 0c             	sub    $0xc,%esp
80101b06:	68 c0 22 11 80       	push   $0x801122c0
80101b0b:	e8 1a 39 00 00       	call   8010542a <release>
80101b10:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b13:	83 ec 0c             	sub    $0xc,%esp
80101b16:	ff 75 08             	pushl  0x8(%ebp)
80101b19:	e8 a6 01 00 00       	call   80101cc4 <itrunc>
80101b1e:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b21:	8b 45 08             	mov    0x8(%ebp),%eax
80101b24:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b2a:	83 ec 0c             	sub    $0xc,%esp
80101b2d:	ff 75 08             	pushl  0x8(%ebp)
80101b30:	e8 c2 fb ff ff       	call   801016f7 <iupdate>
80101b35:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b38:	83 ec 0c             	sub    $0xc,%esp
80101b3b:	68 c0 22 11 80       	push   $0x801122c0
80101b40:	e8 7f 38 00 00       	call   801053c4 <acquire>
80101b45:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b48:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b52:	83 ec 0c             	sub    $0xc,%esp
80101b55:	ff 75 08             	pushl  0x8(%ebp)
80101b58:	e8 96 34 00 00       	call   80104ff3 <wakeup>
80101b5d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b60:	8b 45 08             	mov    0x8(%ebp),%eax
80101b63:	8b 40 08             	mov    0x8(%eax),%eax
80101b66:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b6f:	83 ec 0c             	sub    $0xc,%esp
80101b72:	68 c0 22 11 80       	push   $0x801122c0
80101b77:	e8 ae 38 00 00       	call   8010542a <release>
80101b7c:	83 c4 10             	add    $0x10,%esp
}
80101b7f:	c9                   	leave  
80101b80:	c3                   	ret    

80101b81 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b81:	55                   	push   %ebp
80101b82:	89 e5                	mov    %esp,%ebp
80101b84:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	ff 75 08             	pushl  0x8(%ebp)
80101b8d:	e8 8f fe ff ff       	call   80101a21 <iunlock>
80101b92:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 f2 fe ff ff       	call   80101a92 <iput>
80101ba0:	83 c4 10             	add    $0x10,%esp
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    

80101ba5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ba5:	55                   	push   %ebp
80101ba6:	89 e5                	mov    %esp,%ebp
80101ba8:	53                   	push   %ebx
80101ba9:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bac:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bb0:	77 42                	ja     80101bf4 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb8:	83 c2 04             	add    $0x4,%edx
80101bbb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc6:	75 24                	jne    80101bec <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcb:	8b 00                	mov    (%eax),%eax
80101bcd:	83 ec 0c             	sub    $0xc,%esp
80101bd0:	50                   	push   %eax
80101bd1:	e8 f8 f7 ff ff       	call   801013ce <balloc>
80101bd6:	83 c4 10             	add    $0x10,%esp
80101bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101be2:	8d 4a 04             	lea    0x4(%edx),%ecx
80101be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bef:	e9 cb 00 00 00       	jmp    80101cbf <bmap+0x11a>
  }
  bn -= NDIRECT;
80101bf4:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bf8:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bfc:	0f 87 b0 00 00 00    	ja     80101cb2 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0f:	75 1d                	jne    80101c2e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	8b 00                	mov    (%eax),%eax
80101c16:	83 ec 0c             	sub    $0xc,%esp
80101c19:	50                   	push   %eax
80101c1a:	e8 af f7 ff ff       	call   801013ce <balloc>
80101c1f:	83 c4 10             	add    $0x10,%esp
80101c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c31:	8b 00                	mov    (%eax),%eax
80101c33:	83 ec 08             	sub    $0x8,%esp
80101c36:	ff 75 f4             	pushl  -0xc(%ebp)
80101c39:	50                   	push   %eax
80101c3a:	e8 75 e5 ff ff       	call   801001b4 <bread>
80101c3f:	83 c4 10             	add    $0x10,%esp
80101c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c48:	83 c0 18             	add    $0x18,%eax
80101c4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c5b:	01 d0                	add    %edx,%eax
80101c5d:	8b 00                	mov    (%eax),%eax
80101c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c66:	75 37                	jne    80101c9f <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c75:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c78:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7b:	8b 00                	mov    (%eax),%eax
80101c7d:	83 ec 0c             	sub    $0xc,%esp
80101c80:	50                   	push   %eax
80101c81:	e8 48 f7 ff ff       	call   801013ce <balloc>
80101c86:	83 c4 10             	add    $0x10,%esp
80101c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c8f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c91:	83 ec 0c             	sub    $0xc,%esp
80101c94:	ff 75 f0             	pushl  -0x10(%ebp)
80101c97:	e8 fd 19 00 00       	call   80103699 <log_write>
80101c9c:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	ff 75 f0             	pushl  -0x10(%ebp)
80101ca5:	e8 81 e5 ff ff       	call   8010022b <brelse>
80101caa:	83 c4 10             	add    $0x10,%esp
    return addr;
80101cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cb0:	eb 0d                	jmp    80101cbf <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cb2:	83 ec 0c             	sub    $0xc,%esp
80101cb5:	68 ce 8d 10 80       	push   $0x80108dce
80101cba:	e8 9d e8 ff ff       	call   8010055c <panic>
}
80101cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cc2:	c9                   	leave  
80101cc3:	c3                   	ret    

80101cc4 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101cd1:	eb 45                	jmp    80101d18 <itrunc+0x54>
    if(ip->addrs[i]){
80101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd9:	83 c2 04             	add    $0x4,%edx
80101cdc:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ce0:	85 c0                	test   %eax,%eax
80101ce2:	74 30                	je     80101d14 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cea:	83 c2 04             	add    $0x4,%edx
80101ced:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cf1:	8b 55 08             	mov    0x8(%ebp),%edx
80101cf4:	8b 12                	mov    (%edx),%edx
80101cf6:	83 ec 08             	sub    $0x8,%esp
80101cf9:	50                   	push   %eax
80101cfa:	52                   	push   %edx
80101cfb:	e8 23 f8 ff ff       	call   80101523 <bfree>
80101d00:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d03:	8b 45 08             	mov    0x8(%ebp),%eax
80101d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d09:	83 c2 04             	add    $0x4,%edx
80101d0c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d13:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d18:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d1c:	7e b5                	jle    80101cd3 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d21:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d24:	85 c0                	test   %eax,%eax
80101d26:	0f 84 a1 00 00 00    	je     80101dcd <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	8b 00                	mov    (%eax),%eax
80101d37:	83 ec 08             	sub    $0x8,%esp
80101d3a:	52                   	push   %edx
80101d3b:	50                   	push   %eax
80101d3c:	e8 73 e4 ff ff       	call   801001b4 <bread>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d4a:	83 c0 18             	add    $0x18,%eax
80101d4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d57:	eb 3c                	jmp    80101d95 <itrunc+0xd1>
      if(a[j])
80101d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d66:	01 d0                	add    %edx,%eax
80101d68:	8b 00                	mov    (%eax),%eax
80101d6a:	85 c0                	test   %eax,%eax
80101d6c:	74 23                	je     80101d91 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d7b:	01 d0                	add    %edx,%eax
80101d7d:	8b 00                	mov    (%eax),%eax
80101d7f:	8b 55 08             	mov    0x8(%ebp),%edx
80101d82:	8b 12                	mov    (%edx),%edx
80101d84:	83 ec 08             	sub    $0x8,%esp
80101d87:	50                   	push   %eax
80101d88:	52                   	push   %edx
80101d89:	e8 95 f7 ff ff       	call   80101523 <bfree>
80101d8e:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d91:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d98:	83 f8 7f             	cmp    $0x7f,%eax
80101d9b:	76 bc                	jbe    80101d59 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d9d:	83 ec 0c             	sub    $0xc,%esp
80101da0:	ff 75 ec             	pushl  -0x14(%ebp)
80101da3:	e8 83 e4 ff ff       	call   8010022b <brelse>
80101da8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101dab:	8b 45 08             	mov    0x8(%ebp),%eax
80101dae:	8b 40 4c             	mov    0x4c(%eax),%eax
80101db1:	8b 55 08             	mov    0x8(%ebp),%edx
80101db4:	8b 12                	mov    (%edx),%edx
80101db6:	83 ec 08             	sub    $0x8,%esp
80101db9:	50                   	push   %eax
80101dba:	52                   	push   %edx
80101dbb:	e8 63 f7 ff ff       	call   80101523 <bfree>
80101dc0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd0:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	ff 75 08             	pushl  0x8(%ebp)
80101ddd:	e8 15 f9 ff ff       	call   801016f7 <iupdate>
80101de2:	83 c4 10             	add    $0x10,%esp
}
80101de5:	c9                   	leave  
80101de6:	c3                   	ret    

80101de7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101de7:	55                   	push   %ebp
80101de8:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ded:	8b 00                	mov    (%eax),%eax
80101def:	89 c2                	mov    %eax,%edx
80101df1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df4:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101df7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfa:	8b 50 04             	mov    0x4(%eax),%edx
80101dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e00:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e10:	8b 45 08             	mov    0x8(%ebp),%eax
80101e13:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e21:	8b 50 18             	mov    0x18(%eax),%edx
80101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e27:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    

80101e2c <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e2c:	55                   	push   %ebp
80101e2d:	89 e5                	mov    %esp,%ebp
80101e2f:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e32:	8b 45 08             	mov    0x8(%ebp),%eax
80101e35:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e39:	66 83 f8 03          	cmp    $0x3,%ax
80101e3d:	75 5c                	jne    80101e9b <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e46:	66 85 c0             	test   %ax,%ax
80101e49:	78 20                	js     80101e6b <readi+0x3f>
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e52:	66 83 f8 09          	cmp    $0x9,%ax
80101e56:	7f 13                	jg     80101e6b <readi+0x3f>
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e5f:	98                   	cwtl   
80101e60:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101e67:	85 c0                	test   %eax,%eax
80101e69:	75 0a                	jne    80101e75 <readi+0x49>
      return -1;
80101e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e70:	e9 16 01 00 00       	jmp    80101f8b <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e7c:	98                   	cwtl   
80101e7d:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101e84:	8b 55 14             	mov    0x14(%ebp),%edx
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	52                   	push   %edx
80101e8b:	ff 75 0c             	pushl  0xc(%ebp)
80101e8e:	ff 75 08             	pushl  0x8(%ebp)
80101e91:	ff d0                	call   *%eax
80101e93:	83 c4 10             	add    $0x10,%esp
80101e96:	e9 f0 00 00 00       	jmp    80101f8b <readi+0x15f>
  }

  if(off > ip->size || off + n < off)
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 40 18             	mov    0x18(%eax),%eax
80101ea1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ea4:	72 0d                	jb     80101eb3 <readi+0x87>
80101ea6:	8b 55 10             	mov    0x10(%ebp),%edx
80101ea9:	8b 45 14             	mov    0x14(%ebp),%eax
80101eac:	01 d0                	add    %edx,%eax
80101eae:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eb1:	73 0a                	jae    80101ebd <readi+0x91>
    return -1;
80101eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb8:	e9 ce 00 00 00       	jmp    80101f8b <readi+0x15f>
  if(off + n > ip->size)
80101ebd:	8b 55 10             	mov    0x10(%ebp),%edx
80101ec0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ec3:	01 c2                	add    %eax,%edx
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	8b 40 18             	mov    0x18(%eax),%eax
80101ecb:	39 c2                	cmp    %eax,%edx
80101ecd:	76 0c                	jbe    80101edb <readi+0xaf>
    n = ip->size - off;
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	8b 40 18             	mov    0x18(%eax),%eax
80101ed5:	2b 45 10             	sub    0x10(%ebp),%eax
80101ed8:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ee2:	e9 95 00 00 00       	jmp    80101f7c <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ee7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eea:	c1 e8 09             	shr    $0x9,%eax
80101eed:	83 ec 08             	sub    $0x8,%esp
80101ef0:	50                   	push   %eax
80101ef1:	ff 75 08             	pushl  0x8(%ebp)
80101ef4:	e8 ac fc ff ff       	call   80101ba5 <bmap>
80101ef9:	83 c4 10             	add    $0x10,%esp
80101efc:	89 c2                	mov    %eax,%edx
80101efe:	8b 45 08             	mov    0x8(%ebp),%eax
80101f01:	8b 00                	mov    (%eax),%eax
80101f03:	83 ec 08             	sub    $0x8,%esp
80101f06:	52                   	push   %edx
80101f07:	50                   	push   %eax
80101f08:	e8 a7 e2 ff ff       	call   801001b4 <bread>
80101f0d:	83 c4 10             	add    $0x10,%esp
80101f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f13:	8b 45 10             	mov    0x10(%ebp),%eax
80101f16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f1b:	ba 00 02 00 00       	mov    $0x200,%edx
80101f20:	89 d1                	mov    %edx,%ecx
80101f22:	29 c1                	sub    %eax,%ecx
80101f24:	8b 45 14             	mov    0x14(%ebp),%eax
80101f27:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f2a:	89 c2                	mov    %eax,%edx
80101f2c:	89 c8                	mov    %ecx,%eax
80101f2e:	39 d0                	cmp    %edx,%eax
80101f30:	76 02                	jbe    80101f34 <readi+0x108>
80101f32:	89 d0                	mov    %edx,%eax
80101f34:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f37:	8b 45 10             	mov    0x10(%ebp),%eax
80101f3a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f3f:	8d 50 10             	lea    0x10(%eax),%edx
80101f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f45:	01 d0                	add    %edx,%eax
80101f47:	83 c0 08             	add    $0x8,%eax
80101f4a:	83 ec 04             	sub    $0x4,%esp
80101f4d:	ff 75 ec             	pushl  -0x14(%ebp)
80101f50:	50                   	push   %eax
80101f51:	ff 75 0c             	pushl  0xc(%ebp)
80101f54:	e8 86 37 00 00       	call   801056df <memmove>
80101f59:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f5c:	83 ec 0c             	sub    $0xc,%esp
80101f5f:	ff 75 f0             	pushl  -0x10(%ebp)
80101f62:	e8 c4 e2 ff ff       	call   8010022b <brelse>
80101f67:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f6d:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f73:	01 45 10             	add    %eax,0x10(%ebp)
80101f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f79:	01 45 0c             	add    %eax,0xc(%ebp)
80101f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f7f:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f82:	0f 82 5f ff ff ff    	jb     80101ee7 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f88:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f8b:	c9                   	leave  
80101f8c:	c3                   	ret    

80101f8d <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f8d:	55                   	push   %ebp
80101f8e:	89 e5                	mov    %esp,%ebp
80101f90:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f93:	8b 45 08             	mov    0x8(%ebp),%eax
80101f96:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f9a:	66 83 f8 03          	cmp    $0x3,%ax
80101f9e:	75 5c                	jne    80101ffc <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa7:	66 85 c0             	test   %ax,%ax
80101faa:	78 20                	js     80101fcc <writei+0x3f>
80101fac:	8b 45 08             	mov    0x8(%ebp),%eax
80101faf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb3:	66 83 f8 09          	cmp    $0x9,%ax
80101fb7:	7f 13                	jg     80101fcc <writei+0x3f>
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc0:	98                   	cwtl   
80101fc1:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
80101fc8:	85 c0                	test   %eax,%eax
80101fca:	75 0a                	jne    80101fd6 <writei+0x49>
      return -1;
80101fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd1:	e9 47 01 00 00       	jmp    8010211d <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fdd:	98                   	cwtl   
80101fde:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
80101fe5:	8b 55 14             	mov    0x14(%ebp),%edx
80101fe8:	83 ec 04             	sub    $0x4,%esp
80101feb:	52                   	push   %edx
80101fec:	ff 75 0c             	pushl  0xc(%ebp)
80101fef:	ff 75 08             	pushl  0x8(%ebp)
80101ff2:	ff d0                	call   *%eax
80101ff4:	83 c4 10             	add    $0x10,%esp
80101ff7:	e9 21 01 00 00       	jmp    8010211d <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80101ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fff:	8b 40 18             	mov    0x18(%eax),%eax
80102002:	3b 45 10             	cmp    0x10(%ebp),%eax
80102005:	72 0d                	jb     80102014 <writei+0x87>
80102007:	8b 55 10             	mov    0x10(%ebp),%edx
8010200a:	8b 45 14             	mov    0x14(%ebp),%eax
8010200d:	01 d0                	add    %edx,%eax
8010200f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102012:	73 0a                	jae    8010201e <writei+0x91>
    return -1;
80102014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102019:	e9 ff 00 00 00       	jmp    8010211d <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
8010201e:	8b 55 10             	mov    0x10(%ebp),%edx
80102021:	8b 45 14             	mov    0x14(%ebp),%eax
80102024:	01 d0                	add    %edx,%eax
80102026:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010202b:	76 0a                	jbe    80102037 <writei+0xaa>
    return -1;
8010202d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102032:	e9 e6 00 00 00       	jmp    8010211d <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102037:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010203e:	e9 a3 00 00 00       	jmp    801020e6 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102043:	8b 45 10             	mov    0x10(%ebp),%eax
80102046:	c1 e8 09             	shr    $0x9,%eax
80102049:	83 ec 08             	sub    $0x8,%esp
8010204c:	50                   	push   %eax
8010204d:	ff 75 08             	pushl  0x8(%ebp)
80102050:	e8 50 fb ff ff       	call   80101ba5 <bmap>
80102055:	83 c4 10             	add    $0x10,%esp
80102058:	89 c2                	mov    %eax,%edx
8010205a:	8b 45 08             	mov    0x8(%ebp),%eax
8010205d:	8b 00                	mov    (%eax),%eax
8010205f:	83 ec 08             	sub    $0x8,%esp
80102062:	52                   	push   %edx
80102063:	50                   	push   %eax
80102064:	e8 4b e1 ff ff       	call   801001b4 <bread>
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010206f:	8b 45 10             	mov    0x10(%ebp),%eax
80102072:	25 ff 01 00 00       	and    $0x1ff,%eax
80102077:	ba 00 02 00 00       	mov    $0x200,%edx
8010207c:	89 d1                	mov    %edx,%ecx
8010207e:	29 c1                	sub    %eax,%ecx
80102080:	8b 45 14             	mov    0x14(%ebp),%eax
80102083:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102086:	89 c2                	mov    %eax,%edx
80102088:	89 c8                	mov    %ecx,%eax
8010208a:	39 d0                	cmp    %edx,%eax
8010208c:	76 02                	jbe    80102090 <writei+0x103>
8010208e:	89 d0                	mov    %edx,%eax
80102090:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102093:	8b 45 10             	mov    0x10(%ebp),%eax
80102096:	25 ff 01 00 00       	and    $0x1ff,%eax
8010209b:	8d 50 10             	lea    0x10(%eax),%edx
8010209e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020a1:	01 d0                	add    %edx,%eax
801020a3:	83 c0 08             	add    $0x8,%eax
801020a6:	83 ec 04             	sub    $0x4,%esp
801020a9:	ff 75 ec             	pushl  -0x14(%ebp)
801020ac:	ff 75 0c             	pushl  0xc(%ebp)
801020af:	50                   	push   %eax
801020b0:	e8 2a 36 00 00       	call   801056df <memmove>
801020b5:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	ff 75 f0             	pushl  -0x10(%ebp)
801020be:	e8 d6 15 00 00       	call   80103699 <log_write>
801020c3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020c6:	83 ec 0c             	sub    $0xc,%esp
801020c9:	ff 75 f0             	pushl  -0x10(%ebp)
801020cc:	e8 5a e1 ff ff       	call   8010022b <brelse>
801020d1:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020d7:	01 45 f4             	add    %eax,-0xc(%ebp)
801020da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020dd:	01 45 10             	add    %eax,0x10(%ebp)
801020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020e3:	01 45 0c             	add    %eax,0xc(%ebp)
801020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020e9:	3b 45 14             	cmp    0x14(%ebp),%eax
801020ec:	0f 82 51 ff ff ff    	jb     80102043 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020f6:	74 22                	je     8010211a <writei+0x18d>
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	8b 40 18             	mov    0x18(%eax),%eax
801020fe:	3b 45 10             	cmp    0x10(%ebp),%eax
80102101:	73 17                	jae    8010211a <writei+0x18d>
    ip->size = off;
80102103:	8b 45 08             	mov    0x8(%ebp),%eax
80102106:	8b 55 10             	mov    0x10(%ebp),%edx
80102109:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010210c:	83 ec 0c             	sub    $0xc,%esp
8010210f:	ff 75 08             	pushl  0x8(%ebp)
80102112:	e8 e0 f5 ff ff       	call   801016f7 <iupdate>
80102117:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010211a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010211d:	c9                   	leave  
8010211e:	c3                   	ret    

8010211f <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010211f:	55                   	push   %ebp
80102120:	89 e5                	mov    %esp,%ebp
80102122:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102125:	83 ec 04             	sub    $0x4,%esp
80102128:	6a 0e                	push   $0xe
8010212a:	ff 75 0c             	pushl  0xc(%ebp)
8010212d:	ff 75 08             	pushl  0x8(%ebp)
80102130:	e8 42 36 00 00       	call   80105777 <strncmp>
80102135:	83 c4 10             	add    $0x10,%esp
}
80102138:	c9                   	leave  
80102139:	c3                   	ret    

8010213a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010213a:	55                   	push   %ebp
8010213b:	89 e5                	mov    %esp,%ebp
8010213d:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102140:	8b 45 08             	mov    0x8(%ebp),%eax
80102143:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102147:	66 83 f8 01          	cmp    $0x1,%ax
8010214b:	74 0d                	je     8010215a <dirlookup+0x20>
    panic("dirlookup not DIR");
8010214d:	83 ec 0c             	sub    $0xc,%esp
80102150:	68 e1 8d 10 80       	push   $0x80108de1
80102155:	e8 02 e4 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010215a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102161:	eb 7c                	jmp    801021df <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102163:	6a 10                	push   $0x10
80102165:	ff 75 f4             	pushl  -0xc(%ebp)
80102168:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010216b:	50                   	push   %eax
8010216c:	ff 75 08             	pushl  0x8(%ebp)
8010216f:	e8 b8 fc ff ff       	call   80101e2c <readi>
80102174:	83 c4 10             	add    $0x10,%esp
80102177:	83 f8 10             	cmp    $0x10,%eax
8010217a:	74 0d                	je     80102189 <dirlookup+0x4f>
      panic("dirlink read");
8010217c:	83 ec 0c             	sub    $0xc,%esp
8010217f:	68 f3 8d 10 80       	push   $0x80108df3
80102184:	e8 d3 e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
80102189:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010218d:	66 85 c0             	test   %ax,%ax
80102190:	75 02                	jne    80102194 <dirlookup+0x5a>
      continue;
80102192:	eb 47                	jmp    801021db <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
80102194:	83 ec 08             	sub    $0x8,%esp
80102197:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010219a:	83 c0 02             	add    $0x2,%eax
8010219d:	50                   	push   %eax
8010219e:	ff 75 0c             	pushl  0xc(%ebp)
801021a1:	e8 79 ff ff ff       	call   8010211f <namecmp>
801021a6:	83 c4 10             	add    $0x10,%esp
801021a9:	85 c0                	test   %eax,%eax
801021ab:	75 2e                	jne    801021db <dirlookup+0xa1>
      // entry matches path element
      if(poff)
801021ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021b1:	74 08                	je     801021bb <dirlookup+0x81>
        *poff = off;
801021b3:	8b 45 10             	mov    0x10(%ebp),%eax
801021b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021b9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021bb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021bf:	0f b7 c0             	movzwl %ax,%eax
801021c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021c5:	8b 45 08             	mov    0x8(%ebp),%eax
801021c8:	8b 00                	mov    (%eax),%eax
801021ca:	83 ec 08             	sub    $0x8,%esp
801021cd:	ff 75 f0             	pushl  -0x10(%ebp)
801021d0:	50                   	push   %eax
801021d1:	e8 db f5 ff ff       	call   801017b1 <iget>
801021d6:	83 c4 10             	add    $0x10,%esp
801021d9:	eb 18                	jmp    801021f3 <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021db:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021df:	8b 45 08             	mov    0x8(%ebp),%eax
801021e2:	8b 40 18             	mov    0x18(%eax),%eax
801021e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021e8:	0f 87 75 ff ff ff    	ja     80102163 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021f3:	c9                   	leave  
801021f4:	c3                   	ret    

801021f5 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021f5:	55                   	push   %ebp
801021f6:	89 e5                	mov    %esp,%ebp
801021f8:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021fb:	83 ec 04             	sub    $0x4,%esp
801021fe:	6a 00                	push   $0x0
80102200:	ff 75 0c             	pushl  0xc(%ebp)
80102203:	ff 75 08             	pushl  0x8(%ebp)
80102206:	e8 2f ff ff ff       	call   8010213a <dirlookup>
8010220b:	83 c4 10             	add    $0x10,%esp
8010220e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102215:	74 18                	je     8010222f <dirlink+0x3a>
    iput(ip);
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	ff 75 f0             	pushl  -0x10(%ebp)
8010221d:	e8 70 f8 ff ff       	call   80101a92 <iput>
80102222:	83 c4 10             	add    $0x10,%esp
    return -1;
80102225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010222a:	e9 9b 00 00 00       	jmp    801022ca <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102236:	eb 3b                	jmp    80102273 <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010223b:	6a 10                	push   $0x10
8010223d:	50                   	push   %eax
8010223e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102241:	50                   	push   %eax
80102242:	ff 75 08             	pushl  0x8(%ebp)
80102245:	e8 e2 fb ff ff       	call   80101e2c <readi>
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 f8 10             	cmp    $0x10,%eax
80102250:	74 0d                	je     8010225f <dirlink+0x6a>
      panic("dirlink read");
80102252:	83 ec 0c             	sub    $0xc,%esp
80102255:	68 f3 8d 10 80       	push   $0x80108df3
8010225a:	e8 fd e2 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
8010225f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102263:	66 85 c0             	test   %ax,%ax
80102266:	75 02                	jne    8010226a <dirlink+0x75>
      break;
80102268:	eb 16                	jmp    80102280 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010226d:	83 c0 10             	add    $0x10,%eax
80102270:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102273:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	8b 40 18             	mov    0x18(%eax),%eax
8010227c:	39 c2                	cmp    %eax,%edx
8010227e:	72 b8                	jb     80102238 <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102280:	83 ec 04             	sub    $0x4,%esp
80102283:	6a 0e                	push   $0xe
80102285:	ff 75 0c             	pushl  0xc(%ebp)
80102288:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010228b:	83 c0 02             	add    $0x2,%eax
8010228e:	50                   	push   %eax
8010228f:	e8 39 35 00 00       	call   801057cd <strncpy>
80102294:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102297:	8b 45 10             	mov    0x10(%ebp),%eax
8010229a:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a1:	6a 10                	push   $0x10
801022a3:	50                   	push   %eax
801022a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a7:	50                   	push   %eax
801022a8:	ff 75 08             	pushl  0x8(%ebp)
801022ab:	e8 dd fc ff ff       	call   80101f8d <writei>
801022b0:	83 c4 10             	add    $0x10,%esp
801022b3:	83 f8 10             	cmp    $0x10,%eax
801022b6:	74 0d                	je     801022c5 <dirlink+0xd0>
    panic("dirlink");
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	68 00 8e 10 80       	push   $0x80108e00
801022c0:	e8 97 e2 ff ff       	call   8010055c <panic>
  
  return 0;
801022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022ca:	c9                   	leave  
801022cb:	c3                   	ret    

801022cc <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022cc:	55                   	push   %ebp
801022cd:	89 e5                	mov    %esp,%ebp
801022cf:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801022d2:	eb 04                	jmp    801022d8 <skipelem+0xc>
    path++;
801022d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022d8:	8b 45 08             	mov    0x8(%ebp),%eax
801022db:	0f b6 00             	movzbl (%eax),%eax
801022de:	3c 2f                	cmp    $0x2f,%al
801022e0:	74 f2                	je     801022d4 <skipelem+0x8>
    path++;
  if(*path == 0)
801022e2:	8b 45 08             	mov    0x8(%ebp),%eax
801022e5:	0f b6 00             	movzbl (%eax),%eax
801022e8:	84 c0                	test   %al,%al
801022ea:	75 07                	jne    801022f3 <skipelem+0x27>
    return 0;
801022ec:	b8 00 00 00 00       	mov    $0x0,%eax
801022f1:	eb 7b                	jmp    8010236e <skipelem+0xa2>
  s = path;
801022f3:	8b 45 08             	mov    0x8(%ebp),%eax
801022f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022f9:	eb 04                	jmp    801022ff <skipelem+0x33>
    path++;
801022fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102302:	0f b6 00             	movzbl (%eax),%eax
80102305:	3c 2f                	cmp    $0x2f,%al
80102307:	74 0a                	je     80102313 <skipelem+0x47>
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
8010230c:	0f b6 00             	movzbl (%eax),%eax
8010230f:	84 c0                	test   %al,%al
80102311:	75 e8                	jne    801022fb <skipelem+0x2f>
    path++;
  len = path - s;
80102313:	8b 55 08             	mov    0x8(%ebp),%edx
80102316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102319:	29 c2                	sub    %eax,%edx
8010231b:	89 d0                	mov    %edx,%eax
8010231d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102320:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102324:	7e 15                	jle    8010233b <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102326:	83 ec 04             	sub    $0x4,%esp
80102329:	6a 0e                	push   $0xe
8010232b:	ff 75 f4             	pushl  -0xc(%ebp)
8010232e:	ff 75 0c             	pushl  0xc(%ebp)
80102331:	e8 a9 33 00 00       	call   801056df <memmove>
80102336:	83 c4 10             	add    $0x10,%esp
80102339:	eb 20                	jmp    8010235b <skipelem+0x8f>
  else {
    memmove(name, s, len);
8010233b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010233e:	83 ec 04             	sub    $0x4,%esp
80102341:	50                   	push   %eax
80102342:	ff 75 f4             	pushl  -0xc(%ebp)
80102345:	ff 75 0c             	pushl  0xc(%ebp)
80102348:	e8 92 33 00 00       	call   801056df <memmove>
8010234d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102350:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102353:	8b 45 0c             	mov    0xc(%ebp),%eax
80102356:	01 d0                	add    %edx,%eax
80102358:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010235b:	eb 04                	jmp    80102361 <skipelem+0x95>
    path++;
8010235d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102361:	8b 45 08             	mov    0x8(%ebp),%eax
80102364:	0f b6 00             	movzbl (%eax),%eax
80102367:	3c 2f                	cmp    $0x2f,%al
80102369:	74 f2                	je     8010235d <skipelem+0x91>
    path++;
  return path;
8010236b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010236e:	c9                   	leave  
8010236f:	c3                   	ret    

80102370 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
80102379:	0f b6 00             	movzbl (%eax),%eax
8010237c:	3c 2f                	cmp    $0x2f,%al
8010237e:	75 14                	jne    80102394 <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	6a 01                	push   $0x1
80102385:	6a 01                	push   $0x1
80102387:	e8 25 f4 ff ff       	call   801017b1 <iget>
8010238c:	83 c4 10             	add    $0x10,%esp
8010238f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102392:	eb 18                	jmp    801023ac <namex+0x3c>
  else
    ip = idup(proc->cwd);
80102394:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010239a:	8b 40 68             	mov    0x68(%eax),%eax
8010239d:	83 ec 0c             	sub    $0xc,%esp
801023a0:	50                   	push   %eax
801023a1:	e8 ea f4 ff ff       	call   80101890 <idup>
801023a6:	83 c4 10             	add    $0x10,%esp
801023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023ac:	e9 9e 00 00 00       	jmp    8010244f <namex+0xdf>
    ilock(ip);
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	ff 75 f4             	pushl  -0xc(%ebp)
801023b7:	e8 0e f5 ff ff       	call   801018ca <ilock>
801023bc:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023c6:	66 83 f8 01          	cmp    $0x1,%ax
801023ca:	74 18                	je     801023e4 <namex+0x74>
      iunlockput(ip);
801023cc:	83 ec 0c             	sub    $0xc,%esp
801023cf:	ff 75 f4             	pushl  -0xc(%ebp)
801023d2:	e8 aa f7 ff ff       	call   80101b81 <iunlockput>
801023d7:	83 c4 10             	add    $0x10,%esp
      return 0;
801023da:	b8 00 00 00 00       	mov    $0x0,%eax
801023df:	e9 a7 00 00 00       	jmp    8010248b <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
801023e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023e8:	74 20                	je     8010240a <namex+0x9a>
801023ea:	8b 45 08             	mov    0x8(%ebp),%eax
801023ed:	0f b6 00             	movzbl (%eax),%eax
801023f0:	84 c0                	test   %al,%al
801023f2:	75 16                	jne    8010240a <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	ff 75 f4             	pushl  -0xc(%ebp)
801023fa:	e8 22 f6 ff ff       	call   80101a21 <iunlock>
801023ff:	83 c4 10             	add    $0x10,%esp
      return ip;
80102402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102405:	e9 81 00 00 00       	jmp    8010248b <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010240a:	83 ec 04             	sub    $0x4,%esp
8010240d:	6a 00                	push   $0x0
8010240f:	ff 75 10             	pushl  0x10(%ebp)
80102412:	ff 75 f4             	pushl  -0xc(%ebp)
80102415:	e8 20 fd ff ff       	call   8010213a <dirlookup>
8010241a:	83 c4 10             	add    $0x10,%esp
8010241d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102420:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102424:	75 15                	jne    8010243b <namex+0xcb>
      iunlockput(ip);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	ff 75 f4             	pushl  -0xc(%ebp)
8010242c:	e8 50 f7 ff ff       	call   80101b81 <iunlockput>
80102431:	83 c4 10             	add    $0x10,%esp
      return 0;
80102434:	b8 00 00 00 00       	mov    $0x0,%eax
80102439:	eb 50                	jmp    8010248b <namex+0x11b>
    }
    iunlockput(ip);
8010243b:	83 ec 0c             	sub    $0xc,%esp
8010243e:	ff 75 f4             	pushl  -0xc(%ebp)
80102441:	e8 3b f7 ff ff       	call   80101b81 <iunlockput>
80102446:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010244f:	83 ec 08             	sub    $0x8,%esp
80102452:	ff 75 10             	pushl  0x10(%ebp)
80102455:	ff 75 08             	pushl  0x8(%ebp)
80102458:	e8 6f fe ff ff       	call   801022cc <skipelem>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	89 45 08             	mov    %eax,0x8(%ebp)
80102463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102467:	0f 85 44 ff ff ff    	jne    801023b1 <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010246d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102471:	74 15                	je     80102488 <namex+0x118>
    iput(ip);
80102473:	83 ec 0c             	sub    $0xc,%esp
80102476:	ff 75 f4             	pushl  -0xc(%ebp)
80102479:	e8 14 f6 ff ff       	call   80101a92 <iput>
8010247e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102481:	b8 00 00 00 00       	mov    $0x0,%eax
80102486:	eb 03                	jmp    8010248b <namex+0x11b>
  }
  return ip;
80102488:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010248b:	c9                   	leave  
8010248c:	c3                   	ret    

8010248d <namei>:

struct inode*
namei(char *path)
{
8010248d:	55                   	push   %ebp
8010248e:	89 e5                	mov    %esp,%ebp
80102490:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102493:	83 ec 04             	sub    $0x4,%esp
80102496:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102499:	50                   	push   %eax
8010249a:	6a 00                	push   $0x0
8010249c:	ff 75 08             	pushl  0x8(%ebp)
8010249f:	e8 cc fe ff ff       	call   80102370 <namex>
801024a4:	83 c4 10             	add    $0x10,%esp
}
801024a7:	c9                   	leave  
801024a8:	c3                   	ret    

801024a9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024a9:	55                   	push   %ebp
801024aa:	89 e5                	mov    %esp,%ebp
801024ac:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024af:	83 ec 04             	sub    $0x4,%esp
801024b2:	ff 75 0c             	pushl  0xc(%ebp)
801024b5:	6a 01                	push   $0x1
801024b7:	ff 75 08             	pushl  0x8(%ebp)
801024ba:	e8 b1 fe ff ff       	call   80102370 <namex>
801024bf:	83 c4 10             	add    $0x10,%esp
}
801024c2:	c9                   	leave  
801024c3:	c3                   	ret    

801024c4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	83 ec 14             	sub    $0x14,%esp
801024ca:	8b 45 08             	mov    0x8(%ebp),%eax
801024cd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024d1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024d5:	89 c2                	mov    %eax,%edx
801024d7:	ec                   	in     (%dx),%al
801024d8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024db:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024df:	c9                   	leave  
801024e0:	c3                   	ret    

801024e1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024e1:	55                   	push   %ebp
801024e2:	89 e5                	mov    %esp,%ebp
801024e4:	57                   	push   %edi
801024e5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024e6:	8b 55 08             	mov    0x8(%ebp),%edx
801024e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024ec:	8b 45 10             	mov    0x10(%ebp),%eax
801024ef:	89 cb                	mov    %ecx,%ebx
801024f1:	89 df                	mov    %ebx,%edi
801024f3:	89 c1                	mov    %eax,%ecx
801024f5:	fc                   	cld    
801024f6:	f3 6d                	rep insl (%dx),%es:(%edi)
801024f8:	89 c8                	mov    %ecx,%eax
801024fa:	89 fb                	mov    %edi,%ebx
801024fc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024ff:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102502:	5b                   	pop    %ebx
80102503:	5f                   	pop    %edi
80102504:	5d                   	pop    %ebp
80102505:	c3                   	ret    

80102506 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102506:	55                   	push   %ebp
80102507:	89 e5                	mov    %esp,%ebp
80102509:	83 ec 08             	sub    $0x8,%esp
8010250c:	8b 55 08             	mov    0x8(%ebp),%edx
8010250f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102512:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102516:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102519:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010251d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102521:	ee                   	out    %al,(%dx)
}
80102522:	c9                   	leave  
80102523:	c3                   	ret    

80102524 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
80102528:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102529:	8b 55 08             	mov    0x8(%ebp),%edx
8010252c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010252f:	8b 45 10             	mov    0x10(%ebp),%eax
80102532:	89 cb                	mov    %ecx,%ebx
80102534:	89 de                	mov    %ebx,%esi
80102536:	89 c1                	mov    %eax,%ecx
80102538:	fc                   	cld    
80102539:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010253b:	89 c8                	mov    %ecx,%eax
8010253d:	89 f3                	mov    %esi,%ebx
8010253f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102542:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102545:	5b                   	pop    %ebx
80102546:	5e                   	pop    %esi
80102547:	5d                   	pop    %ebp
80102548:	c3                   	ret    

80102549 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102549:	55                   	push   %ebp
8010254a:	89 e5                	mov    %esp,%ebp
8010254c:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010254f:	90                   	nop
80102550:	68 f7 01 00 00       	push   $0x1f7
80102555:	e8 6a ff ff ff       	call   801024c4 <inb>
8010255a:	83 c4 04             	add    $0x4,%esp
8010255d:	0f b6 c0             	movzbl %al,%eax
80102560:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102563:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102566:	25 c0 00 00 00       	and    $0xc0,%eax
8010256b:	83 f8 40             	cmp    $0x40,%eax
8010256e:	75 e0                	jne    80102550 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102570:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102574:	74 11                	je     80102587 <idewait+0x3e>
80102576:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102579:	83 e0 21             	and    $0x21,%eax
8010257c:	85 c0                	test   %eax,%eax
8010257e:	74 07                	je     80102587 <idewait+0x3e>
    return -1;
80102580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102585:	eb 05                	jmp    8010258c <idewait+0x43>
  return 0;
80102587:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010258c:	c9                   	leave  
8010258d:	c3                   	ret    

8010258e <ideinit>:

void
ideinit(void)
{
8010258e:	55                   	push   %ebp
8010258f:	89 e5                	mov    %esp,%ebp
80102591:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102594:	83 ec 08             	sub    $0x8,%esp
80102597:	68 08 8e 10 80       	push   $0x80108e08
8010259c:	68 20 c6 10 80       	push   $0x8010c620
801025a1:	e8 fd 2d 00 00       	call   801053a3 <initlock>
801025a6:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025a9:	83 ec 0c             	sub    $0xc,%esp
801025ac:	6a 0e                	push   $0xe
801025ae:	e8 88 18 00 00       	call   80103e3b <picenable>
801025b3:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025b6:	a1 20 3a 11 80       	mov    0x80113a20,%eax
801025bb:	83 e8 01             	sub    $0x1,%eax
801025be:	83 ec 08             	sub    $0x8,%esp
801025c1:	50                   	push   %eax
801025c2:	6a 0e                	push   $0xe
801025c4:	e8 31 04 00 00       	call   801029fa <ioapicenable>
801025c9:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801025cc:	83 ec 0c             	sub    $0xc,%esp
801025cf:	6a 00                	push   $0x0
801025d1:	e8 73 ff ff ff       	call   80102549 <idewait>
801025d6:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025d9:	83 ec 08             	sub    $0x8,%esp
801025dc:	68 f0 00 00 00       	push   $0xf0
801025e1:	68 f6 01 00 00       	push   $0x1f6
801025e6:	e8 1b ff ff ff       	call   80102506 <outb>
801025eb:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801025ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025f5:	eb 24                	jmp    8010261b <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 f7 01 00 00       	push   $0x1f7
801025ff:	e8 c0 fe ff ff       	call   801024c4 <inb>
80102604:	83 c4 10             	add    $0x10,%esp
80102607:	84 c0                	test   %al,%al
80102609:	74 0c                	je     80102617 <ideinit+0x89>
      havedisk1 = 1;
8010260b:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102612:	00 00 00 
      break;
80102615:	eb 0d                	jmp    80102624 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102617:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010261b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102622:	7e d3                	jle    801025f7 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102624:	83 ec 08             	sub    $0x8,%esp
80102627:	68 e0 00 00 00       	push   $0xe0
8010262c:	68 f6 01 00 00       	push   $0x1f6
80102631:	e8 d0 fe ff ff       	call   80102506 <outb>
80102636:	83 c4 10             	add    $0x10,%esp
}
80102639:	c9                   	leave  
8010263a:	c3                   	ret    

8010263b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010263b:	55                   	push   %ebp
8010263c:	89 e5                	mov    %esp,%ebp
8010263e:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102641:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102645:	75 0d                	jne    80102654 <idestart+0x19>
    panic("idestart");
80102647:	83 ec 0c             	sub    $0xc,%esp
8010264a:	68 0c 8e 10 80       	push   $0x80108e0c
8010264f:	e8 08 df ff ff       	call   8010055c <panic>

  idewait(0);
80102654:	83 ec 0c             	sub    $0xc,%esp
80102657:	6a 00                	push   $0x0
80102659:	e8 eb fe ff ff       	call   80102549 <idewait>
8010265e:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102661:	83 ec 08             	sub    $0x8,%esp
80102664:	6a 00                	push   $0x0
80102666:	68 f6 03 00 00       	push   $0x3f6
8010266b:	e8 96 fe ff ff       	call   80102506 <outb>
80102670:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
80102673:	83 ec 08             	sub    $0x8,%esp
80102676:	6a 01                	push   $0x1
80102678:	68 f2 01 00 00       	push   $0x1f2
8010267d:	e8 84 fe ff ff       	call   80102506 <outb>
80102682:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
80102688:	8b 40 08             	mov    0x8(%eax),%eax
8010268b:	0f b6 c0             	movzbl %al,%eax
8010268e:	83 ec 08             	sub    $0x8,%esp
80102691:	50                   	push   %eax
80102692:	68 f3 01 00 00       	push   $0x1f3
80102697:	e8 6a fe ff ff       	call   80102506 <outb>
8010269c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010269f:	8b 45 08             	mov    0x8(%ebp),%eax
801026a2:	8b 40 08             	mov    0x8(%eax),%eax
801026a5:	c1 e8 08             	shr    $0x8,%eax
801026a8:	0f b6 c0             	movzbl %al,%eax
801026ab:	83 ec 08             	sub    $0x8,%esp
801026ae:	50                   	push   %eax
801026af:	68 f4 01 00 00       	push   $0x1f4
801026b4:	e8 4d fe ff ff       	call   80102506 <outb>
801026b9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026bc:	8b 45 08             	mov    0x8(%ebp),%eax
801026bf:	8b 40 08             	mov    0x8(%eax),%eax
801026c2:	c1 e8 10             	shr    $0x10,%eax
801026c5:	0f b6 c0             	movzbl %al,%eax
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	50                   	push   %eax
801026cc:	68 f5 01 00 00       	push   $0x1f5
801026d1:	e8 30 fe ff ff       	call   80102506 <outb>
801026d6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
801026dc:	8b 40 04             	mov    0x4(%eax),%eax
801026df:	83 e0 01             	and    $0x1,%eax
801026e2:	c1 e0 04             	shl    $0x4,%eax
801026e5:	89 c2                	mov    %eax,%edx
801026e7:	8b 45 08             	mov    0x8(%ebp),%eax
801026ea:	8b 40 08             	mov    0x8(%eax),%eax
801026ed:	c1 e8 18             	shr    $0x18,%eax
801026f0:	83 e0 0f             	and    $0xf,%eax
801026f3:	09 d0                	or     %edx,%eax
801026f5:	83 c8 e0             	or     $0xffffffe0,%eax
801026f8:	0f b6 c0             	movzbl %al,%eax
801026fb:	83 ec 08             	sub    $0x8,%esp
801026fe:	50                   	push   %eax
801026ff:	68 f6 01 00 00       	push   $0x1f6
80102704:	e8 fd fd ff ff       	call   80102506 <outb>
80102709:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010270c:	8b 45 08             	mov    0x8(%ebp),%eax
8010270f:	8b 00                	mov    (%eax),%eax
80102711:	83 e0 04             	and    $0x4,%eax
80102714:	85 c0                	test   %eax,%eax
80102716:	74 30                	je     80102748 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102718:	83 ec 08             	sub    $0x8,%esp
8010271b:	6a 30                	push   $0x30
8010271d:	68 f7 01 00 00       	push   $0x1f7
80102722:	e8 df fd ff ff       	call   80102506 <outb>
80102727:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
8010272a:	8b 45 08             	mov    0x8(%ebp),%eax
8010272d:	83 c0 18             	add    $0x18,%eax
80102730:	83 ec 04             	sub    $0x4,%esp
80102733:	68 80 00 00 00       	push   $0x80
80102738:	50                   	push   %eax
80102739:	68 f0 01 00 00       	push   $0x1f0
8010273e:	e8 e1 fd ff ff       	call   80102524 <outsl>
80102743:	83 c4 10             	add    $0x10,%esp
80102746:	eb 12                	jmp    8010275a <idestart+0x11f>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102748:	83 ec 08             	sub    $0x8,%esp
8010274b:	6a 20                	push   $0x20
8010274d:	68 f7 01 00 00       	push   $0x1f7
80102752:	e8 af fd ff ff       	call   80102506 <outb>
80102757:	83 c4 10             	add    $0x10,%esp
  }
}
8010275a:	c9                   	leave  
8010275b:	c3                   	ret    

8010275c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010275c:	55                   	push   %ebp
8010275d:	89 e5                	mov    %esp,%ebp
8010275f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102762:	83 ec 0c             	sub    $0xc,%esp
80102765:	68 20 c6 10 80       	push   $0x8010c620
8010276a:	e8 55 2c 00 00       	call   801053c4 <acquire>
8010276f:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102772:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102777:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010277e:	75 15                	jne    80102795 <ideintr+0x39>
    release(&idelock);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	68 20 c6 10 80       	push   $0x8010c620
80102788:	e8 9d 2c 00 00       	call   8010542a <release>
8010278d:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102790:	e9 9a 00 00 00       	jmp    8010282f <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102798:	8b 40 14             	mov    0x14(%eax),%eax
8010279b:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a3:	8b 00                	mov    (%eax),%eax
801027a5:	83 e0 04             	and    $0x4,%eax
801027a8:	85 c0                	test   %eax,%eax
801027aa:	75 2d                	jne    801027d9 <ideintr+0x7d>
801027ac:	83 ec 0c             	sub    $0xc,%esp
801027af:	6a 01                	push   $0x1
801027b1:	e8 93 fd ff ff       	call   80102549 <idewait>
801027b6:	83 c4 10             	add    $0x10,%esp
801027b9:	85 c0                	test   %eax,%eax
801027bb:	78 1c                	js     801027d9 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c0:	83 c0 18             	add    $0x18,%eax
801027c3:	83 ec 04             	sub    $0x4,%esp
801027c6:	68 80 00 00 00       	push   $0x80
801027cb:	50                   	push   %eax
801027cc:	68 f0 01 00 00       	push   $0x1f0
801027d1:	e8 0b fd ff ff       	call   801024e1 <insl>
801027d6:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027dc:	8b 00                	mov    (%eax),%eax
801027de:	83 c8 02             	or     $0x2,%eax
801027e1:	89 c2                	mov    %eax,%edx
801027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e6:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027eb:	8b 00                	mov    (%eax),%eax
801027ed:	83 e0 fb             	and    $0xfffffffb,%eax
801027f0:	89 c2                	mov    %eax,%edx
801027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f5:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027f7:	83 ec 0c             	sub    $0xc,%esp
801027fa:	ff 75 f4             	pushl  -0xc(%ebp)
801027fd:	e8 f1 27 00 00       	call   80104ff3 <wakeup>
80102802:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102805:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010280a:	85 c0                	test   %eax,%eax
8010280c:	74 11                	je     8010281f <ideintr+0xc3>
    idestart(idequeue);
8010280e:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102813:	83 ec 0c             	sub    $0xc,%esp
80102816:	50                   	push   %eax
80102817:	e8 1f fe ff ff       	call   8010263b <idestart>
8010281c:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010281f:	83 ec 0c             	sub    $0xc,%esp
80102822:	68 20 c6 10 80       	push   $0x8010c620
80102827:	e8 fe 2b 00 00       	call   8010542a <release>
8010282c:	83 c4 10             	add    $0x10,%esp
}
8010282f:	c9                   	leave  
80102830:	c3                   	ret    

80102831 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102831:	55                   	push   %ebp
80102832:	89 e5                	mov    %esp,%ebp
80102834:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102837:	8b 45 08             	mov    0x8(%ebp),%eax
8010283a:	8b 00                	mov    (%eax),%eax
8010283c:	83 e0 01             	and    $0x1,%eax
8010283f:	85 c0                	test   %eax,%eax
80102841:	75 0d                	jne    80102850 <iderw+0x1f>
    panic("iderw: buf not busy");
80102843:	83 ec 0c             	sub    $0xc,%esp
80102846:	68 15 8e 10 80       	push   $0x80108e15
8010284b:	e8 0c dd ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102850:	8b 45 08             	mov    0x8(%ebp),%eax
80102853:	8b 00                	mov    (%eax),%eax
80102855:	83 e0 06             	and    $0x6,%eax
80102858:	83 f8 02             	cmp    $0x2,%eax
8010285b:	75 0d                	jne    8010286a <iderw+0x39>
    panic("iderw: nothing to do");
8010285d:	83 ec 0c             	sub    $0xc,%esp
80102860:	68 29 8e 10 80       	push   $0x80108e29
80102865:	e8 f2 dc ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
8010286a:	8b 45 08             	mov    0x8(%ebp),%eax
8010286d:	8b 40 04             	mov    0x4(%eax),%eax
80102870:	85 c0                	test   %eax,%eax
80102872:	74 16                	je     8010288a <iderw+0x59>
80102874:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102879:	85 c0                	test   %eax,%eax
8010287b:	75 0d                	jne    8010288a <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010287d:	83 ec 0c             	sub    $0xc,%esp
80102880:	68 3e 8e 10 80       	push   $0x80108e3e
80102885:	e8 d2 dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010288a:	83 ec 0c             	sub    $0xc,%esp
8010288d:	68 20 c6 10 80       	push   $0x8010c620
80102892:	e8 2d 2b 00 00       	call   801053c4 <acquire>
80102897:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010289a:	8b 45 08             	mov    0x8(%ebp),%eax
8010289d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028a4:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801028ab:	eb 0b                	jmp    801028b8 <iderw+0x87>
801028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b0:	8b 00                	mov    (%eax),%eax
801028b2:	83 c0 14             	add    $0x14,%eax
801028b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bb:	8b 00                	mov    (%eax),%eax
801028bd:	85 c0                	test   %eax,%eax
801028bf:	75 ec                	jne    801028ad <iderw+0x7c>
    ;
  *pp = b;
801028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c4:	8b 55 08             	mov    0x8(%ebp),%edx
801028c7:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028c9:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028ce:	3b 45 08             	cmp    0x8(%ebp),%eax
801028d1:	75 0e                	jne    801028e1 <iderw+0xb0>
    idestart(b);
801028d3:	83 ec 0c             	sub    $0xc,%esp
801028d6:	ff 75 08             	pushl  0x8(%ebp)
801028d9:	e8 5d fd ff ff       	call   8010263b <idestart>
801028de:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028e1:	eb 13                	jmp    801028f6 <iderw+0xc5>
    sleep(b, &idelock);
801028e3:	83 ec 08             	sub    $0x8,%esp
801028e6:	68 20 c6 10 80       	push   $0x8010c620
801028eb:	ff 75 08             	pushl  0x8(%ebp)
801028ee:	e8 dd 25 00 00       	call   80104ed0 <sleep>
801028f3:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028f6:	8b 45 08             	mov    0x8(%ebp),%eax
801028f9:	8b 00                	mov    (%eax),%eax
801028fb:	83 e0 06             	and    $0x6,%eax
801028fe:	83 f8 02             	cmp    $0x2,%eax
80102901:	75 e0                	jne    801028e3 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102903:	83 ec 0c             	sub    $0xc,%esp
80102906:	68 20 c6 10 80       	push   $0x8010c620
8010290b:	e8 1a 2b 00 00       	call   8010542a <release>
80102910:	83 c4 10             	add    $0x10,%esp
}
80102913:	c9                   	leave  
80102914:	c3                   	ret    

80102915 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102915:	55                   	push   %ebp
80102916:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102918:	a1 94 32 11 80       	mov    0x80113294,%eax
8010291d:	8b 55 08             	mov    0x8(%ebp),%edx
80102920:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102922:	a1 94 32 11 80       	mov    0x80113294,%eax
80102927:	8b 40 10             	mov    0x10(%eax),%eax
}
8010292a:	5d                   	pop    %ebp
8010292b:	c3                   	ret    

8010292c <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010292c:	55                   	push   %ebp
8010292d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010292f:	a1 94 32 11 80       	mov    0x80113294,%eax
80102934:	8b 55 08             	mov    0x8(%ebp),%edx
80102937:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102939:	a1 94 32 11 80       	mov    0x80113294,%eax
8010293e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102941:	89 50 10             	mov    %edx,0x10(%eax)
}
80102944:	5d                   	pop    %ebp
80102945:	c3                   	ret    

80102946 <ioapicinit>:

void
ioapicinit(void)
{
80102946:	55                   	push   %ebp
80102947:	89 e5                	mov    %esp,%ebp
80102949:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
8010294c:	a1 04 34 11 80       	mov    0x80113404,%eax
80102951:	85 c0                	test   %eax,%eax
80102953:	75 05                	jne    8010295a <ioapicinit+0x14>
    return;
80102955:	e9 9e 00 00 00       	jmp    801029f8 <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
8010295a:	c7 05 94 32 11 80 00 	movl   $0xfec00000,0x80113294
80102961:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102964:	6a 01                	push   $0x1
80102966:	e8 aa ff ff ff       	call   80102915 <ioapicread>
8010296b:	83 c4 04             	add    $0x4,%esp
8010296e:	c1 e8 10             	shr    $0x10,%eax
80102971:	25 ff 00 00 00       	and    $0xff,%eax
80102976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102979:	6a 00                	push   $0x0
8010297b:	e8 95 ff ff ff       	call   80102915 <ioapicread>
80102980:	83 c4 04             	add    $0x4,%esp
80102983:	c1 e8 18             	shr    $0x18,%eax
80102986:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102989:	0f b6 05 00 34 11 80 	movzbl 0x80113400,%eax
80102990:	0f b6 c0             	movzbl %al,%eax
80102993:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102996:	74 10                	je     801029a8 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102998:	83 ec 0c             	sub    $0xc,%esp
8010299b:	68 5c 8e 10 80       	push   $0x80108e5c
801029a0:	e8 1a da ff ff       	call   801003bf <cprintf>
801029a5:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029af:	eb 3f                	jmp    801029f0 <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b4:	83 c0 20             	add    $0x20,%eax
801029b7:	0d 00 00 01 00       	or     $0x10000,%eax
801029bc:	89 c2                	mov    %eax,%edx
801029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c1:	83 c0 08             	add    $0x8,%eax
801029c4:	01 c0                	add    %eax,%eax
801029c6:	83 ec 08             	sub    $0x8,%esp
801029c9:	52                   	push   %edx
801029ca:	50                   	push   %eax
801029cb:	e8 5c ff ff ff       	call   8010292c <ioapicwrite>
801029d0:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d6:	83 c0 08             	add    $0x8,%eax
801029d9:	01 c0                	add    %eax,%eax
801029db:	83 c0 01             	add    $0x1,%eax
801029de:	83 ec 08             	sub    $0x8,%esp
801029e1:	6a 00                	push   $0x0
801029e3:	50                   	push   %eax
801029e4:	e8 43 ff ff ff       	call   8010292c <ioapicwrite>
801029e9:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029f6:	7e b9                	jle    801029b1 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029f8:	c9                   	leave  
801029f9:	c3                   	ret    

801029fa <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029fa:	55                   	push   %ebp
801029fb:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801029fd:	a1 04 34 11 80       	mov    0x80113404,%eax
80102a02:	85 c0                	test   %eax,%eax
80102a04:	75 02                	jne    80102a08 <ioapicenable+0xe>
    return;
80102a06:	eb 37                	jmp    80102a3f <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a08:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0b:	83 c0 20             	add    $0x20,%eax
80102a0e:	89 c2                	mov    %eax,%edx
80102a10:	8b 45 08             	mov    0x8(%ebp),%eax
80102a13:	83 c0 08             	add    $0x8,%eax
80102a16:	01 c0                	add    %eax,%eax
80102a18:	52                   	push   %edx
80102a19:	50                   	push   %eax
80102a1a:	e8 0d ff ff ff       	call   8010292c <ioapicwrite>
80102a1f:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a25:	c1 e0 18             	shl    $0x18,%eax
80102a28:	89 c2                	mov    %eax,%edx
80102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2d:	83 c0 08             	add    $0x8,%eax
80102a30:	01 c0                	add    %eax,%eax
80102a32:	83 c0 01             	add    $0x1,%eax
80102a35:	52                   	push   %edx
80102a36:	50                   	push   %eax
80102a37:	e8 f0 fe ff ff       	call   8010292c <ioapicwrite>
80102a3c:	83 c4 08             	add    $0x8,%esp
}
80102a3f:	c9                   	leave  
80102a40:	c3                   	ret    

80102a41 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a41:	55                   	push   %ebp
80102a42:	89 e5                	mov    %esp,%ebp
80102a44:	8b 45 08             	mov    0x8(%ebp),%eax
80102a47:	05 00 00 00 80       	add    $0x80000000,%eax
80102a4c:	5d                   	pop    %ebp
80102a4d:	c3                   	ret    

80102a4e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a54:	83 ec 08             	sub    $0x8,%esp
80102a57:	68 8e 8e 10 80       	push   $0x80108e8e
80102a5c:	68 a0 32 11 80       	push   $0x801132a0
80102a61:	e8 3d 29 00 00       	call   801053a3 <initlock>
80102a66:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a69:	c7 05 d4 32 11 80 00 	movl   $0x0,0x801132d4
80102a70:	00 00 00 
  freerange(vstart, vend);
80102a73:	83 ec 08             	sub    $0x8,%esp
80102a76:	ff 75 0c             	pushl  0xc(%ebp)
80102a79:	ff 75 08             	pushl  0x8(%ebp)
80102a7c:	e8 28 00 00 00       	call   80102aa9 <freerange>
80102a81:	83 c4 10             	add    $0x10,%esp
}
80102a84:	c9                   	leave  
80102a85:	c3                   	ret    

80102a86 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a86:	55                   	push   %ebp
80102a87:	89 e5                	mov    %esp,%ebp
80102a89:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102a8c:	83 ec 08             	sub    $0x8,%esp
80102a8f:	ff 75 0c             	pushl  0xc(%ebp)
80102a92:	ff 75 08             	pushl  0x8(%ebp)
80102a95:	e8 0f 00 00 00       	call   80102aa9 <freerange>
80102a9a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102a9d:	c7 05 d4 32 11 80 01 	movl   $0x1,0x801132d4
80102aa4:	00 00 00 
}
80102aa7:	c9                   	leave  
80102aa8:	c3                   	ret    

80102aa9 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aa9:	55                   	push   %ebp
80102aaa:	89 e5                	mov    %esp,%ebp
80102aac:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab2:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abf:	eb 15                	jmp    80102ad6 <freerange+0x2d>
    kfree(p);
80102ac1:	83 ec 0c             	sub    $0xc,%esp
80102ac4:	ff 75 f4             	pushl  -0xc(%ebp)
80102ac7:	e8 19 00 00 00       	call   80102ae5 <kfree>
80102acc:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad9:	05 00 10 00 00       	add    $0x1000,%eax
80102ade:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ae1:	76 de                	jbe    80102ac1 <freerange+0x18>
    kfree(p);
}
80102ae3:	c9                   	leave  
80102ae4:	c3                   	ret    

80102ae5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
80102ae8:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80102aee:	25 ff 0f 00 00       	and    $0xfff,%eax
80102af3:	85 c0                	test   %eax,%eax
80102af5:	75 1b                	jne    80102b12 <kfree+0x2d>
80102af7:	81 7d 08 5c 6c 11 80 	cmpl   $0x80116c5c,0x8(%ebp)
80102afe:	72 12                	jb     80102b12 <kfree+0x2d>
80102b00:	ff 75 08             	pushl  0x8(%ebp)
80102b03:	e8 39 ff ff ff       	call   80102a41 <v2p>
80102b08:	83 c4 04             	add    $0x4,%esp
80102b0b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b10:	76 0d                	jbe    80102b1f <kfree+0x3a>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 93 8e 10 80       	push   $0x80108e93
80102b1a:	e8 3d da ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b1f:	83 ec 04             	sub    $0x4,%esp
80102b22:	68 00 10 00 00       	push   $0x1000
80102b27:	6a 01                	push   $0x1
80102b29:	ff 75 08             	pushl  0x8(%ebp)
80102b2c:	e8 ef 2a 00 00       	call   80105620 <memset>
80102b31:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b34:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b39:	85 c0                	test   %eax,%eax
80102b3b:	74 10                	je     80102b4d <kfree+0x68>
    acquire(&kmem.lock);
80102b3d:	83 ec 0c             	sub    $0xc,%esp
80102b40:	68 a0 32 11 80       	push   $0x801132a0
80102b45:	e8 7a 28 00 00       	call   801053c4 <acquire>
80102b4a:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b53:	8b 15 d8 32 11 80    	mov    0x801132d8,%edx
80102b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5c:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b61:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102b66:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	74 10                	je     80102b7f <kfree+0x9a>
    release(&kmem.lock);
80102b6f:	83 ec 0c             	sub    $0xc,%esp
80102b72:	68 a0 32 11 80       	push   $0x801132a0
80102b77:	e8 ae 28 00 00       	call   8010542a <release>
80102b7c:	83 c4 10             	add    $0x10,%esp
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    

80102b81 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b81:	55                   	push   %ebp
80102b82:	89 e5                	mov    %esp,%ebp
80102b84:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102b87:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b8c:	85 c0                	test   %eax,%eax
80102b8e:	74 10                	je     80102ba0 <kalloc+0x1f>
    acquire(&kmem.lock);
80102b90:	83 ec 0c             	sub    $0xc,%esp
80102b93:	68 a0 32 11 80       	push   $0x801132a0
80102b98:	e8 27 28 00 00       	call   801053c4 <acquire>
80102b9d:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102ba0:	a1 d8 32 11 80       	mov    0x801132d8,%eax
80102ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bac:	74 0a                	je     80102bb8 <kalloc+0x37>
    kmem.freelist = r->next;
80102bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb1:	8b 00                	mov    (%eax),%eax
80102bb3:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102bb8:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102bbd:	85 c0                	test   %eax,%eax
80102bbf:	74 10                	je     80102bd1 <kalloc+0x50>
    release(&kmem.lock);
80102bc1:	83 ec 0c             	sub    $0xc,%esp
80102bc4:	68 a0 32 11 80       	push   $0x801132a0
80102bc9:	e8 5c 28 00 00       	call   8010542a <release>
80102bce:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    

80102bd6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bd6:	55                   	push   %ebp
80102bd7:	89 e5                	mov    %esp,%ebp
80102bd9:	83 ec 14             	sub    $0x14,%esp
80102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102be7:	89 c2                	mov    %eax,%edx
80102be9:	ec                   	in     (%dx),%al
80102bea:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102bed:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102bf1:	c9                   	leave  
80102bf2:	c3                   	ret    

80102bf3 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bf3:	55                   	push   %ebp
80102bf4:	89 e5                	mov    %esp,%ebp
80102bf6:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bf9:	6a 64                	push   $0x64
80102bfb:	e8 d6 ff ff ff       	call   80102bd6 <inb>
80102c00:	83 c4 04             	add    $0x4,%esp
80102c03:	0f b6 c0             	movzbl %al,%eax
80102c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0c:	83 e0 01             	and    $0x1,%eax
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	75 0a                	jne    80102c1d <kbdgetc+0x2a>
    return -1;
80102c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c18:	e9 23 01 00 00       	jmp    80102d40 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c1d:	6a 60                	push   $0x60
80102c1f:	e8 b2 ff ff ff       	call   80102bd6 <inb>
80102c24:	83 c4 04             	add    $0x4,%esp
80102c27:	0f b6 c0             	movzbl %al,%eax
80102c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c2d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c34:	75 17                	jne    80102c4d <kbdgetc+0x5a>
    shift |= E0ESC;
80102c36:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c3b:	83 c8 40             	or     $0x40,%eax
80102c3e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c43:	b8 00 00 00 00       	mov    $0x0,%eax
80102c48:	e9 f3 00 00 00       	jmp    80102d40 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c50:	25 80 00 00 00       	and    $0x80,%eax
80102c55:	85 c0                	test   %eax,%eax
80102c57:	74 45                	je     80102c9e <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c59:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c5e:	83 e0 40             	and    $0x40,%eax
80102c61:	85 c0                	test   %eax,%eax
80102c63:	75 08                	jne    80102c6d <kbdgetc+0x7a>
80102c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c68:	83 e0 7f             	and    $0x7f,%eax
80102c6b:	eb 03                	jmp    80102c70 <kbdgetc+0x7d>
80102c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c76:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102c7b:	0f b6 00             	movzbl (%eax),%eax
80102c7e:	83 c8 40             	or     $0x40,%eax
80102c81:	0f b6 c0             	movzbl %al,%eax
80102c84:	f7 d0                	not    %eax
80102c86:	89 c2                	mov    %eax,%edx
80102c88:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c8d:	21 d0                	and    %edx,%eax
80102c8f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c94:	b8 00 00 00 00       	mov    $0x0,%eax
80102c99:	e9 a2 00 00 00       	jmp    80102d40 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102c9e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ca3:	83 e0 40             	and    $0x40,%eax
80102ca6:	85 c0                	test   %eax,%eax
80102ca8:	74 14                	je     80102cbe <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102caa:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cb1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cb6:	83 e0 bf             	and    $0xffffffbf,%eax
80102cb9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc1:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102cc6:	0f b6 00             	movzbl (%eax),%eax
80102cc9:	0f b6 d0             	movzbl %al,%edx
80102ccc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cd1:	09 d0                	or     %edx,%eax
80102cd3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cdb:	05 40 a1 10 80       	add    $0x8010a140,%eax
80102ce0:	0f b6 00             	movzbl (%eax),%eax
80102ce3:	0f b6 d0             	movzbl %al,%edx
80102ce6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ceb:	31 d0                	xor    %edx,%eax
80102ced:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cf2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cf7:	83 e0 03             	and    $0x3,%eax
80102cfa:	8b 14 85 40 a5 10 80 	mov    -0x7fef5ac0(,%eax,4),%edx
80102d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d04:	01 d0                	add    %edx,%eax
80102d06:	0f b6 00             	movzbl (%eax),%eax
80102d09:	0f b6 c0             	movzbl %al,%eax
80102d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d0f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d14:	83 e0 08             	and    $0x8,%eax
80102d17:	85 c0                	test   %eax,%eax
80102d19:	74 22                	je     80102d3d <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d1b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d1f:	76 0c                	jbe    80102d2d <kbdgetc+0x13a>
80102d21:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d25:	77 06                	ja     80102d2d <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d27:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d2b:	eb 10                	jmp    80102d3d <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d2d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d31:	76 0a                	jbe    80102d3d <kbdgetc+0x14a>
80102d33:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d37:	77 04                	ja     80102d3d <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d39:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d40:	c9                   	leave  
80102d41:	c3                   	ret    

80102d42 <kbdintr>:

void
kbdintr(void)
{
80102d42:	55                   	push   %ebp
80102d43:	89 e5                	mov    %esp,%ebp
80102d45:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 f3 2b 10 80       	push   $0x80102bf3
80102d50:	e8 7c da ff ff       	call   801007d1 <consoleintr>
80102d55:	83 c4 10             	add    $0x10,%esp
}
80102d58:	c9                   	leave  
80102d59:	c3                   	ret    

80102d5a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d5a:	55                   	push   %ebp
80102d5b:	89 e5                	mov    %esp,%ebp
80102d5d:	83 ec 14             	sub    $0x14,%esp
80102d60:	8b 45 08             	mov    0x8(%ebp),%eax
80102d63:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d67:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d6b:	89 c2                	mov    %eax,%edx
80102d6d:	ec                   	in     (%dx),%al
80102d6e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d71:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    

80102d77 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d77:	55                   	push   %ebp
80102d78:	89 e5                	mov    %esp,%ebp
80102d7a:	83 ec 08             	sub    $0x8,%esp
80102d7d:	8b 55 08             	mov    0x8(%ebp),%edx
80102d80:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d83:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d87:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d8e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d92:	ee                   	out    %al,(%dx)
}
80102d93:	c9                   	leave  
80102d94:	c3                   	ret    

80102d95 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d95:	55                   	push   %ebp
80102d96:	89 e5                	mov    %esp,%ebp
80102d98:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d9b:	9c                   	pushf  
80102d9c:	58                   	pop    %eax
80102d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102da3:	c9                   	leave  
80102da4:	c3                   	ret    

80102da5 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102da5:	55                   	push   %ebp
80102da6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102da8:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dad:	8b 55 08             	mov    0x8(%ebp),%edx
80102db0:	c1 e2 02             	shl    $0x2,%edx
80102db3:	01 c2                	add    %eax,%edx
80102db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102db8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dba:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dbf:	83 c0 20             	add    $0x20,%eax
80102dc2:	8b 00                	mov    (%eax),%eax
}
80102dc4:	5d                   	pop    %ebp
80102dc5:	c3                   	ret    

80102dc6 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102dc6:	55                   	push   %ebp
80102dc7:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102dc9:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	75 05                	jne    80102dd7 <lapicinit+0x11>
    return;
80102dd2:	e9 09 01 00 00       	jmp    80102ee0 <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dd7:	68 3f 01 00 00       	push   $0x13f
80102ddc:	6a 3c                	push   $0x3c
80102dde:	e8 c2 ff ff ff       	call   80102da5 <lapicw>
80102de3:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102de6:	6a 0b                	push   $0xb
80102de8:	68 f8 00 00 00       	push   $0xf8
80102ded:	e8 b3 ff ff ff       	call   80102da5 <lapicw>
80102df2:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102df5:	68 20 00 02 00       	push   $0x20020
80102dfa:	68 c8 00 00 00       	push   $0xc8
80102dff:	e8 a1 ff ff ff       	call   80102da5 <lapicw>
80102e04:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e07:	68 80 96 98 00       	push   $0x989680
80102e0c:	68 e0 00 00 00       	push   $0xe0
80102e11:	e8 8f ff ff ff       	call   80102da5 <lapicw>
80102e16:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e19:	68 00 00 01 00       	push   $0x10000
80102e1e:	68 d4 00 00 00       	push   $0xd4
80102e23:	e8 7d ff ff ff       	call   80102da5 <lapicw>
80102e28:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e2b:	68 00 00 01 00       	push   $0x10000
80102e30:	68 d8 00 00 00       	push   $0xd8
80102e35:	e8 6b ff ff ff       	call   80102da5 <lapicw>
80102e3a:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e3d:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102e42:	83 c0 30             	add    $0x30,%eax
80102e45:	8b 00                	mov    (%eax),%eax
80102e47:	c1 e8 10             	shr    $0x10,%eax
80102e4a:	0f b6 c0             	movzbl %al,%eax
80102e4d:	83 f8 03             	cmp    $0x3,%eax
80102e50:	76 12                	jbe    80102e64 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102e52:	68 00 00 01 00       	push   $0x10000
80102e57:	68 d0 00 00 00       	push   $0xd0
80102e5c:	e8 44 ff ff ff       	call   80102da5 <lapicw>
80102e61:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e64:	6a 33                	push   $0x33
80102e66:	68 dc 00 00 00       	push   $0xdc
80102e6b:	e8 35 ff ff ff       	call   80102da5 <lapicw>
80102e70:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e73:	6a 00                	push   $0x0
80102e75:	68 a0 00 00 00       	push   $0xa0
80102e7a:	e8 26 ff ff ff       	call   80102da5 <lapicw>
80102e7f:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102e82:	6a 00                	push   $0x0
80102e84:	68 a0 00 00 00       	push   $0xa0
80102e89:	e8 17 ff ff ff       	call   80102da5 <lapicw>
80102e8e:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e91:	6a 00                	push   $0x0
80102e93:	6a 2c                	push   $0x2c
80102e95:	e8 0b ff ff ff       	call   80102da5 <lapicw>
80102e9a:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e9d:	6a 00                	push   $0x0
80102e9f:	68 c4 00 00 00       	push   $0xc4
80102ea4:	e8 fc fe ff ff       	call   80102da5 <lapicw>
80102ea9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102eac:	68 00 85 08 00       	push   $0x88500
80102eb1:	68 c0 00 00 00       	push   $0xc0
80102eb6:	e8 ea fe ff ff       	call   80102da5 <lapicw>
80102ebb:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ebe:	90                   	nop
80102ebf:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102ec4:	05 00 03 00 00       	add    $0x300,%eax
80102ec9:	8b 00                	mov    (%eax),%eax
80102ecb:	25 00 10 00 00       	and    $0x1000,%eax
80102ed0:	85 c0                	test   %eax,%eax
80102ed2:	75 eb                	jne    80102ebf <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ed4:	6a 00                	push   $0x0
80102ed6:	6a 20                	push   $0x20
80102ed8:	e8 c8 fe ff ff       	call   80102da5 <lapicw>
80102edd:	83 c4 08             	add    $0x8,%esp
}
80102ee0:	c9                   	leave  
80102ee1:	c3                   	ret    

80102ee2 <cpunum>:

int
cpunum(void)
{
80102ee2:	55                   	push   %ebp
80102ee3:	89 e5                	mov    %esp,%ebp
80102ee5:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ee8:	e8 a8 fe ff ff       	call   80102d95 <readeflags>
80102eed:	25 00 02 00 00       	and    $0x200,%eax
80102ef2:	85 c0                	test   %eax,%eax
80102ef4:	74 26                	je     80102f1c <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102ef6:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102efb:	8d 50 01             	lea    0x1(%eax),%edx
80102efe:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f04:	85 c0                	test   %eax,%eax
80102f06:	75 14                	jne    80102f1c <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f08:	8b 45 04             	mov    0x4(%ebp),%eax
80102f0b:	83 ec 08             	sub    $0x8,%esp
80102f0e:	50                   	push   %eax
80102f0f:	68 9c 8e 10 80       	push   $0x80108e9c
80102f14:	e8 a6 d4 ff ff       	call   801003bf <cprintf>
80102f19:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f1c:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f21:	85 c0                	test   %eax,%eax
80102f23:	74 0f                	je     80102f34 <cpunum+0x52>
    return lapic[ID]>>24;
80102f25:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f2a:	83 c0 20             	add    $0x20,%eax
80102f2d:	8b 00                	mov    (%eax),%eax
80102f2f:	c1 e8 18             	shr    $0x18,%eax
80102f32:	eb 05                	jmp    80102f39 <cpunum+0x57>
  return 0;
80102f34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f39:	c9                   	leave  
80102f3a:	c3                   	ret    

80102f3b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f3b:	55                   	push   %ebp
80102f3c:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f3e:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f43:	85 c0                	test   %eax,%eax
80102f45:	74 0c                	je     80102f53 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f47:	6a 00                	push   $0x0
80102f49:	6a 2c                	push   $0x2c
80102f4b:	e8 55 fe ff ff       	call   80102da5 <lapicw>
80102f50:	83 c4 08             	add    $0x8,%esp
}
80102f53:	c9                   	leave  
80102f54:	c3                   	ret    

80102f55 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f55:	55                   	push   %ebp
80102f56:	89 e5                	mov    %esp,%ebp
}
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    

80102f5a <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f5a:	55                   	push   %ebp
80102f5b:	89 e5                	mov    %esp,%ebp
80102f5d:	83 ec 14             	sub    $0x14,%esp
80102f60:	8b 45 08             	mov    0x8(%ebp),%eax
80102f63:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f66:	6a 0f                	push   $0xf
80102f68:	6a 70                	push   $0x70
80102f6a:	e8 08 fe ff ff       	call   80102d77 <outb>
80102f6f:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102f72:	6a 0a                	push   $0xa
80102f74:	6a 71                	push   $0x71
80102f76:	e8 fc fd ff ff       	call   80102d77 <outb>
80102f7b:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f7e:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f85:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f88:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f90:	83 c0 02             	add    $0x2,%eax
80102f93:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f96:	c1 ea 04             	shr    $0x4,%edx
80102f99:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f9c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fa0:	c1 e0 18             	shl    $0x18,%eax
80102fa3:	50                   	push   %eax
80102fa4:	68 c4 00 00 00       	push   $0xc4
80102fa9:	e8 f7 fd ff ff       	call   80102da5 <lapicw>
80102fae:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fb1:	68 00 c5 00 00       	push   $0xc500
80102fb6:	68 c0 00 00 00       	push   $0xc0
80102fbb:	e8 e5 fd ff ff       	call   80102da5 <lapicw>
80102fc0:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102fc3:	68 c8 00 00 00       	push   $0xc8
80102fc8:	e8 88 ff ff ff       	call   80102f55 <microdelay>
80102fcd:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102fd0:	68 00 85 00 00       	push   $0x8500
80102fd5:	68 c0 00 00 00       	push   $0xc0
80102fda:	e8 c6 fd ff ff       	call   80102da5 <lapicw>
80102fdf:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fe2:	6a 64                	push   $0x64
80102fe4:	e8 6c ff ff ff       	call   80102f55 <microdelay>
80102fe9:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102ff3:	eb 3d                	jmp    80103032 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80102ff5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102ff9:	c1 e0 18             	shl    $0x18,%eax
80102ffc:	50                   	push   %eax
80102ffd:	68 c4 00 00 00       	push   $0xc4
80103002:	e8 9e fd ff ff       	call   80102da5 <lapicw>
80103007:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010300a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010300d:	c1 e8 0c             	shr    $0xc,%eax
80103010:	80 cc 06             	or     $0x6,%ah
80103013:	50                   	push   %eax
80103014:	68 c0 00 00 00       	push   $0xc0
80103019:	e8 87 fd ff ff       	call   80102da5 <lapicw>
8010301e:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103021:	68 c8 00 00 00       	push   $0xc8
80103026:	e8 2a ff ff ff       	call   80102f55 <microdelay>
8010302b:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010302e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103032:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103036:	7e bd                	jle    80102ff5 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103038:	c9                   	leave  
80103039:	c3                   	ret    

8010303a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010303d:	8b 45 08             	mov    0x8(%ebp),%eax
80103040:	0f b6 c0             	movzbl %al,%eax
80103043:	50                   	push   %eax
80103044:	6a 70                	push   $0x70
80103046:	e8 2c fd ff ff       	call   80102d77 <outb>
8010304b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010304e:	68 c8 00 00 00       	push   $0xc8
80103053:	e8 fd fe ff ff       	call   80102f55 <microdelay>
80103058:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010305b:	6a 71                	push   $0x71
8010305d:	e8 f8 fc ff ff       	call   80102d5a <inb>
80103062:	83 c4 04             	add    $0x4,%esp
80103065:	0f b6 c0             	movzbl %al,%eax
}
80103068:	c9                   	leave  
80103069:	c3                   	ret    

8010306a <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010306d:	6a 00                	push   $0x0
8010306f:	e8 c6 ff ff ff       	call   8010303a <cmos_read>
80103074:	83 c4 04             	add    $0x4,%esp
80103077:	89 c2                	mov    %eax,%edx
80103079:	8b 45 08             	mov    0x8(%ebp),%eax
8010307c:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010307e:	6a 02                	push   $0x2
80103080:	e8 b5 ff ff ff       	call   8010303a <cmos_read>
80103085:	83 c4 04             	add    $0x4,%esp
80103088:	89 c2                	mov    %eax,%edx
8010308a:	8b 45 08             	mov    0x8(%ebp),%eax
8010308d:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103090:	6a 04                	push   $0x4
80103092:	e8 a3 ff ff ff       	call   8010303a <cmos_read>
80103097:	83 c4 04             	add    $0x4,%esp
8010309a:	89 c2                	mov    %eax,%edx
8010309c:	8b 45 08             	mov    0x8(%ebp),%eax
8010309f:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801030a2:	6a 07                	push   $0x7
801030a4:	e8 91 ff ff ff       	call   8010303a <cmos_read>
801030a9:	83 c4 04             	add    $0x4,%esp
801030ac:	89 c2                	mov    %eax,%edx
801030ae:	8b 45 08             	mov    0x8(%ebp),%eax
801030b1:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801030b4:	6a 08                	push   $0x8
801030b6:	e8 7f ff ff ff       	call   8010303a <cmos_read>
801030bb:	83 c4 04             	add    $0x4,%esp
801030be:	89 c2                	mov    %eax,%edx
801030c0:	8b 45 08             	mov    0x8(%ebp),%eax
801030c3:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801030c6:	6a 09                	push   $0x9
801030c8:	e8 6d ff ff ff       	call   8010303a <cmos_read>
801030cd:	83 c4 04             	add    $0x4,%esp
801030d0:	89 c2                	mov    %eax,%edx
801030d2:	8b 45 08             	mov    0x8(%ebp),%eax
801030d5:	89 50 14             	mov    %edx,0x14(%eax)
}
801030d8:	c9                   	leave  
801030d9:	c3                   	ret    

801030da <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030e0:	6a 0b                	push   $0xb
801030e2:	e8 53 ff ff ff       	call   8010303a <cmos_read>
801030e7:	83 c4 04             	add    $0x4,%esp
801030ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f0:	83 e0 04             	and    $0x4,%eax
801030f3:	85 c0                	test   %eax,%eax
801030f5:	0f 94 c0             	sete   %al
801030f8:	0f b6 c0             	movzbl %al,%eax
801030fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030fe:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103101:	50                   	push   %eax
80103102:	e8 63 ff ff ff       	call   8010306a <fill_rtcdate>
80103107:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010310a:	6a 0a                	push   $0xa
8010310c:	e8 29 ff ff ff       	call   8010303a <cmos_read>
80103111:	83 c4 04             	add    $0x4,%esp
80103114:	25 80 00 00 00       	and    $0x80,%eax
80103119:	85 c0                	test   %eax,%eax
8010311b:	74 02                	je     8010311f <cmostime+0x45>
        continue;
8010311d:	eb 32                	jmp    80103151 <cmostime+0x77>
    fill_rtcdate(&t2);
8010311f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103122:	50                   	push   %eax
80103123:	e8 42 ff ff ff       	call   8010306a <fill_rtcdate>
80103128:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010312b:	83 ec 04             	sub    $0x4,%esp
8010312e:	6a 18                	push   $0x18
80103130:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103133:	50                   	push   %eax
80103134:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103137:	50                   	push   %eax
80103138:	e8 4a 25 00 00       	call   80105687 <memcmp>
8010313d:	83 c4 10             	add    $0x10,%esp
80103140:	85 c0                	test   %eax,%eax
80103142:	75 0d                	jne    80103151 <cmostime+0x77>
      break;
80103144:	90                   	nop
  }

  // convert
  if (bcd) {
80103145:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103149:	0f 84 b8 00 00 00    	je     80103207 <cmostime+0x12d>
8010314f:	eb 02                	jmp    80103153 <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103151:	eb ab                	jmp    801030fe <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103153:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103156:	c1 e8 04             	shr    $0x4,%eax
80103159:	89 c2                	mov    %eax,%edx
8010315b:	89 d0                	mov    %edx,%eax
8010315d:	c1 e0 02             	shl    $0x2,%eax
80103160:	01 d0                	add    %edx,%eax
80103162:	01 c0                	add    %eax,%eax
80103164:	89 c2                	mov    %eax,%edx
80103166:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103169:	83 e0 0f             	and    $0xf,%eax
8010316c:	01 d0                	add    %edx,%eax
8010316e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103171:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103174:	c1 e8 04             	shr    $0x4,%eax
80103177:	89 c2                	mov    %eax,%edx
80103179:	89 d0                	mov    %edx,%eax
8010317b:	c1 e0 02             	shl    $0x2,%eax
8010317e:	01 d0                	add    %edx,%eax
80103180:	01 c0                	add    %eax,%eax
80103182:	89 c2                	mov    %eax,%edx
80103184:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103187:	83 e0 0f             	and    $0xf,%eax
8010318a:	01 d0                	add    %edx,%eax
8010318c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010318f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103192:	c1 e8 04             	shr    $0x4,%eax
80103195:	89 c2                	mov    %eax,%edx
80103197:	89 d0                	mov    %edx,%eax
80103199:	c1 e0 02             	shl    $0x2,%eax
8010319c:	01 d0                	add    %edx,%eax
8010319e:	01 c0                	add    %eax,%eax
801031a0:	89 c2                	mov    %eax,%edx
801031a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031a5:	83 e0 0f             	and    $0xf,%eax
801031a8:	01 d0                	add    %edx,%eax
801031aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031b0:	c1 e8 04             	shr    $0x4,%eax
801031b3:	89 c2                	mov    %eax,%edx
801031b5:	89 d0                	mov    %edx,%eax
801031b7:	c1 e0 02             	shl    $0x2,%eax
801031ba:	01 d0                	add    %edx,%eax
801031bc:	01 c0                	add    %eax,%eax
801031be:	89 c2                	mov    %eax,%edx
801031c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031c3:	83 e0 0f             	and    $0xf,%eax
801031c6:	01 d0                	add    %edx,%eax
801031c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031ce:	c1 e8 04             	shr    $0x4,%eax
801031d1:	89 c2                	mov    %eax,%edx
801031d3:	89 d0                	mov    %edx,%eax
801031d5:	c1 e0 02             	shl    $0x2,%eax
801031d8:	01 d0                	add    %edx,%eax
801031da:	01 c0                	add    %eax,%eax
801031dc:	89 c2                	mov    %eax,%edx
801031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031e1:	83 e0 0f             	and    $0xf,%eax
801031e4:	01 d0                	add    %edx,%eax
801031e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ec:	c1 e8 04             	shr    $0x4,%eax
801031ef:	89 c2                	mov    %eax,%edx
801031f1:	89 d0                	mov    %edx,%eax
801031f3:	c1 e0 02             	shl    $0x2,%eax
801031f6:	01 d0                	add    %edx,%eax
801031f8:	01 c0                	add    %eax,%eax
801031fa:	89 c2                	mov    %eax,%edx
801031fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ff:	83 e0 0f             	and    $0xf,%eax
80103202:	01 d0                	add    %edx,%eax
80103204:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103207:	8b 45 08             	mov    0x8(%ebp),%eax
8010320a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010320d:	89 10                	mov    %edx,(%eax)
8010320f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103212:	89 50 04             	mov    %edx,0x4(%eax)
80103215:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103218:	89 50 08             	mov    %edx,0x8(%eax)
8010321b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010321e:	89 50 0c             	mov    %edx,0xc(%eax)
80103221:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103224:	89 50 10             	mov    %edx,0x10(%eax)
80103227:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010322a:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010322d:	8b 45 08             	mov    0x8(%ebp),%eax
80103230:	8b 40 14             	mov    0x14(%eax),%eax
80103233:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103239:	8b 45 08             	mov    0x8(%ebp),%eax
8010323c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010323f:	c9                   	leave  
80103240:	c3                   	ret    

80103241 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103241:	55                   	push   %ebp
80103242:	89 e5                	mov    %esp,%ebp
80103244:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103247:	83 ec 08             	sub    $0x8,%esp
8010324a:	68 c8 8e 10 80       	push   $0x80108ec8
8010324f:	68 00 33 11 80       	push   $0x80113300
80103254:	e8 4a 21 00 00       	call   801053a3 <initlock>
80103259:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
8010325c:	83 ec 08             	sub    $0x8,%esp
8010325f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103262:	50                   	push   %eax
80103263:	6a 01                	push   $0x1
80103265:	e8 d0 e0 ff ff       	call   8010133a <readsb>
8010326a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
8010326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103270:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103273:	29 c2                	sub    %eax,%edx
80103275:	89 d0                	mov    %edx,%eax
80103277:	a3 34 33 11 80       	mov    %eax,0x80113334
  log.size = sb.nlog;
8010327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327f:	a3 38 33 11 80       	mov    %eax,0x80113338
  log.dev = ROOTDEV;
80103284:	c7 05 44 33 11 80 01 	movl   $0x1,0x80113344
8010328b:	00 00 00 
  recover_from_log();
8010328e:	e8 ae 01 00 00       	call   80103441 <recover_from_log>
}
80103293:	c9                   	leave  
80103294:	c3                   	ret    

80103295 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103295:	55                   	push   %ebp
80103296:	89 e5                	mov    %esp,%ebp
80103298:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010329b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032a2:	e9 95 00 00 00       	jmp    8010333c <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032a7:	8b 15 34 33 11 80    	mov    0x80113334,%edx
801032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032b0:	01 d0                	add    %edx,%eax
801032b2:	83 c0 01             	add    $0x1,%eax
801032b5:	89 c2                	mov    %eax,%edx
801032b7:	a1 44 33 11 80       	mov    0x80113344,%eax
801032bc:	83 ec 08             	sub    $0x8,%esp
801032bf:	52                   	push   %edx
801032c0:	50                   	push   %eax
801032c1:	e8 ee ce ff ff       	call   801001b4 <bread>
801032c6:	83 c4 10             	add    $0x10,%esp
801032c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cf:	83 c0 10             	add    $0x10,%eax
801032d2:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
801032d9:	89 c2                	mov    %eax,%edx
801032db:	a1 44 33 11 80       	mov    0x80113344,%eax
801032e0:	83 ec 08             	sub    $0x8,%esp
801032e3:	52                   	push   %edx
801032e4:	50                   	push   %eax
801032e5:	e8 ca ce ff ff       	call   801001b4 <bread>
801032ea:	83 c4 10             	add    $0x10,%esp
801032ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f3:	8d 50 18             	lea    0x18(%eax),%edx
801032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f9:	83 c0 18             	add    $0x18,%eax
801032fc:	83 ec 04             	sub    $0x4,%esp
801032ff:	68 00 02 00 00       	push   $0x200
80103304:	52                   	push   %edx
80103305:	50                   	push   %eax
80103306:	e8 d4 23 00 00       	call   801056df <memmove>
8010330b:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010330e:	83 ec 0c             	sub    $0xc,%esp
80103311:	ff 75 ec             	pushl  -0x14(%ebp)
80103314:	e8 d4 ce ff ff       	call   801001ed <bwrite>
80103319:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010331c:	83 ec 0c             	sub    $0xc,%esp
8010331f:	ff 75 f0             	pushl  -0x10(%ebp)
80103322:	e8 04 cf ff ff       	call   8010022b <brelse>
80103327:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010332a:	83 ec 0c             	sub    $0xc,%esp
8010332d:	ff 75 ec             	pushl  -0x14(%ebp)
80103330:	e8 f6 ce ff ff       	call   8010022b <brelse>
80103335:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103338:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010333c:	a1 48 33 11 80       	mov    0x80113348,%eax
80103341:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103344:	0f 8f 5d ff ff ff    	jg     801032a7 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010334a:	c9                   	leave  
8010334b:	c3                   	ret    

8010334c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010334c:	55                   	push   %ebp
8010334d:	89 e5                	mov    %esp,%ebp
8010334f:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103352:	a1 34 33 11 80       	mov    0x80113334,%eax
80103357:	89 c2                	mov    %eax,%edx
80103359:	a1 44 33 11 80       	mov    0x80113344,%eax
8010335e:	83 ec 08             	sub    $0x8,%esp
80103361:	52                   	push   %edx
80103362:	50                   	push   %eax
80103363:	e8 4c ce ff ff       	call   801001b4 <bread>
80103368:	83 c4 10             	add    $0x10,%esp
8010336b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103371:	83 c0 18             	add    $0x18,%eax
80103374:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103377:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337a:	8b 00                	mov    (%eax),%eax
8010337c:	a3 48 33 11 80       	mov    %eax,0x80113348
  for (i = 0; i < log.lh.n; i++) {
80103381:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103388:	eb 1b                	jmp    801033a5 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
8010338a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103390:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103394:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103397:	83 c2 10             	add    $0x10,%edx
8010339a:	89 04 95 0c 33 11 80 	mov    %eax,-0x7feeccf4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033a5:	a1 48 33 11 80       	mov    0x80113348,%eax
801033aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033ad:	7f db                	jg     8010338a <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033af:	83 ec 0c             	sub    $0xc,%esp
801033b2:	ff 75 f0             	pushl  -0x10(%ebp)
801033b5:	e8 71 ce ff ff       	call   8010022b <brelse>
801033ba:	83 c4 10             	add    $0x10,%esp
}
801033bd:	c9                   	leave  
801033be:	c3                   	ret    

801033bf <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033bf:	55                   	push   %ebp
801033c0:	89 e5                	mov    %esp,%ebp
801033c2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c5:	a1 34 33 11 80       	mov    0x80113334,%eax
801033ca:	89 c2                	mov    %eax,%edx
801033cc:	a1 44 33 11 80       	mov    0x80113344,%eax
801033d1:	83 ec 08             	sub    $0x8,%esp
801033d4:	52                   	push   %edx
801033d5:	50                   	push   %eax
801033d6:	e8 d9 cd ff ff       	call   801001b4 <bread>
801033db:	83 c4 10             	add    $0x10,%esp
801033de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e4:	83 c0 18             	add    $0x18,%eax
801033e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033ea:	8b 15 48 33 11 80    	mov    0x80113348,%edx
801033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033f3:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033fc:	eb 1b                	jmp    80103419 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
801033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103401:	83 c0 10             	add    $0x10,%eax
80103404:	8b 0c 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%ecx
8010340b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010340e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103411:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103415:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103419:	a1 48 33 11 80       	mov    0x80113348,%eax
8010341e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103421:	7f db                	jg     801033fe <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103423:	83 ec 0c             	sub    $0xc,%esp
80103426:	ff 75 f0             	pushl  -0x10(%ebp)
80103429:	e8 bf cd ff ff       	call   801001ed <bwrite>
8010342e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103431:	83 ec 0c             	sub    $0xc,%esp
80103434:	ff 75 f0             	pushl  -0x10(%ebp)
80103437:	e8 ef cd ff ff       	call   8010022b <brelse>
8010343c:	83 c4 10             	add    $0x10,%esp
}
8010343f:	c9                   	leave  
80103440:	c3                   	ret    

80103441 <recover_from_log>:

static void
recover_from_log(void)
{
80103441:	55                   	push   %ebp
80103442:	89 e5                	mov    %esp,%ebp
80103444:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103447:	e8 00 ff ff ff       	call   8010334c <read_head>
  install_trans(); // if committed, copy from log to disk
8010344c:	e8 44 fe ff ff       	call   80103295 <install_trans>
  log.lh.n = 0;
80103451:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
80103458:	00 00 00 
  write_head(); // clear the log
8010345b:	e8 5f ff ff ff       	call   801033bf <write_head>
}
80103460:	c9                   	leave  
80103461:	c3                   	ret    

80103462 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103462:	55                   	push   %ebp
80103463:	89 e5                	mov    %esp,%ebp
80103465:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103468:	83 ec 0c             	sub    $0xc,%esp
8010346b:	68 00 33 11 80       	push   $0x80113300
80103470:	e8 4f 1f 00 00       	call   801053c4 <acquire>
80103475:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103478:	a1 40 33 11 80       	mov    0x80113340,%eax
8010347d:	85 c0                	test   %eax,%eax
8010347f:	74 17                	je     80103498 <begin_op+0x36>
      sleep(&log, &log.lock);
80103481:	83 ec 08             	sub    $0x8,%esp
80103484:	68 00 33 11 80       	push   $0x80113300
80103489:	68 00 33 11 80       	push   $0x80113300
8010348e:	e8 3d 1a 00 00       	call   80104ed0 <sleep>
80103493:	83 c4 10             	add    $0x10,%esp
80103496:	eb 54                	jmp    801034ec <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103498:	8b 0d 48 33 11 80    	mov    0x80113348,%ecx
8010349e:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801034a3:	8d 50 01             	lea    0x1(%eax),%edx
801034a6:	89 d0                	mov    %edx,%eax
801034a8:	c1 e0 02             	shl    $0x2,%eax
801034ab:	01 d0                	add    %edx,%eax
801034ad:	01 c0                	add    %eax,%eax
801034af:	01 c8                	add    %ecx,%eax
801034b1:	83 f8 1e             	cmp    $0x1e,%eax
801034b4:	7e 17                	jle    801034cd <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034b6:	83 ec 08             	sub    $0x8,%esp
801034b9:	68 00 33 11 80       	push   $0x80113300
801034be:	68 00 33 11 80       	push   $0x80113300
801034c3:	e8 08 1a 00 00       	call   80104ed0 <sleep>
801034c8:	83 c4 10             	add    $0x10,%esp
801034cb:	eb 1f                	jmp    801034ec <begin_op+0x8a>
    } else {
      log.outstanding += 1;
801034cd:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801034d2:	83 c0 01             	add    $0x1,%eax
801034d5:	a3 3c 33 11 80       	mov    %eax,0x8011333c
      release(&log.lock);
801034da:	83 ec 0c             	sub    $0xc,%esp
801034dd:	68 00 33 11 80       	push   $0x80113300
801034e2:	e8 43 1f 00 00       	call   8010542a <release>
801034e7:	83 c4 10             	add    $0x10,%esp
      break;
801034ea:	eb 02                	jmp    801034ee <begin_op+0x8c>
    }
  }
801034ec:	eb 8a                	jmp    80103478 <begin_op+0x16>
}
801034ee:	c9                   	leave  
801034ef:	c3                   	ret    

801034f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801034f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034fd:	83 ec 0c             	sub    $0xc,%esp
80103500:	68 00 33 11 80       	push   $0x80113300
80103505:	e8 ba 1e 00 00       	call   801053c4 <acquire>
8010350a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010350d:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103512:	83 e8 01             	sub    $0x1,%eax
80103515:	a3 3c 33 11 80       	mov    %eax,0x8011333c
  if(log.committing)
8010351a:	a1 40 33 11 80       	mov    0x80113340,%eax
8010351f:	85 c0                	test   %eax,%eax
80103521:	74 0d                	je     80103530 <end_op+0x40>
    panic("log.committing");
80103523:	83 ec 0c             	sub    $0xc,%esp
80103526:	68 cc 8e 10 80       	push   $0x80108ecc
8010352b:	e8 2c d0 ff ff       	call   8010055c <panic>
  if(log.outstanding == 0){
80103530:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103535:	85 c0                	test   %eax,%eax
80103537:	75 13                	jne    8010354c <end_op+0x5c>
    do_commit = 1;
80103539:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103540:	c7 05 40 33 11 80 01 	movl   $0x1,0x80113340
80103547:	00 00 00 
8010354a:	eb 10                	jmp    8010355c <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010354c:	83 ec 0c             	sub    $0xc,%esp
8010354f:	68 00 33 11 80       	push   $0x80113300
80103554:	e8 9a 1a 00 00       	call   80104ff3 <wakeup>
80103559:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010355c:	83 ec 0c             	sub    $0xc,%esp
8010355f:	68 00 33 11 80       	push   $0x80113300
80103564:	e8 c1 1e 00 00       	call   8010542a <release>
80103569:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010356c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103570:	74 3f                	je     801035b1 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103572:	e8 f3 00 00 00       	call   8010366a <commit>
    acquire(&log.lock);
80103577:	83 ec 0c             	sub    $0xc,%esp
8010357a:	68 00 33 11 80       	push   $0x80113300
8010357f:	e8 40 1e 00 00       	call   801053c4 <acquire>
80103584:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103587:	c7 05 40 33 11 80 00 	movl   $0x0,0x80113340
8010358e:	00 00 00 
    wakeup(&log);
80103591:	83 ec 0c             	sub    $0xc,%esp
80103594:	68 00 33 11 80       	push   $0x80113300
80103599:	e8 55 1a 00 00       	call   80104ff3 <wakeup>
8010359e:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035a1:	83 ec 0c             	sub    $0xc,%esp
801035a4:	68 00 33 11 80       	push   $0x80113300
801035a9:	e8 7c 1e 00 00       	call   8010542a <release>
801035ae:	83 c4 10             	add    $0x10,%esp
  }
}
801035b1:	c9                   	leave  
801035b2:	c3                   	ret    

801035b3 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035b3:	55                   	push   %ebp
801035b4:	89 e5                	mov    %esp,%ebp
801035b6:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035c0:	e9 95 00 00 00       	jmp    8010365a <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035c5:	8b 15 34 33 11 80    	mov    0x80113334,%edx
801035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ce:	01 d0                	add    %edx,%eax
801035d0:	83 c0 01             	add    $0x1,%eax
801035d3:	89 c2                	mov    %eax,%edx
801035d5:	a1 44 33 11 80       	mov    0x80113344,%eax
801035da:	83 ec 08             	sub    $0x8,%esp
801035dd:	52                   	push   %edx
801035de:	50                   	push   %eax
801035df:	e8 d0 cb ff ff       	call   801001b4 <bread>
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
801035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ed:	83 c0 10             	add    $0x10,%eax
801035f0:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
801035f7:	89 c2                	mov    %eax,%edx
801035f9:	a1 44 33 11 80       	mov    0x80113344,%eax
801035fe:	83 ec 08             	sub    $0x8,%esp
80103601:	52                   	push   %edx
80103602:	50                   	push   %eax
80103603:	e8 ac cb ff ff       	call   801001b4 <bread>
80103608:	83 c4 10             	add    $0x10,%esp
8010360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010360e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103611:	8d 50 18             	lea    0x18(%eax),%edx
80103614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103617:	83 c0 18             	add    $0x18,%eax
8010361a:	83 ec 04             	sub    $0x4,%esp
8010361d:	68 00 02 00 00       	push   $0x200
80103622:	52                   	push   %edx
80103623:	50                   	push   %eax
80103624:	e8 b6 20 00 00       	call   801056df <memmove>
80103629:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010362c:	83 ec 0c             	sub    $0xc,%esp
8010362f:	ff 75 f0             	pushl  -0x10(%ebp)
80103632:	e8 b6 cb ff ff       	call   801001ed <bwrite>
80103637:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	ff 75 ec             	pushl  -0x14(%ebp)
80103640:	e8 e6 cb ff ff       	call   8010022b <brelse>
80103645:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	ff 75 f0             	pushl  -0x10(%ebp)
8010364e:	e8 d8 cb ff ff       	call   8010022b <brelse>
80103653:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103656:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010365a:	a1 48 33 11 80       	mov    0x80113348,%eax
8010365f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103662:	0f 8f 5d ff ff ff    	jg     801035c5 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103668:	c9                   	leave  
80103669:	c3                   	ret    

8010366a <commit>:

static void
commit()
{
8010366a:	55                   	push   %ebp
8010366b:	89 e5                	mov    %esp,%ebp
8010366d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103670:	a1 48 33 11 80       	mov    0x80113348,%eax
80103675:	85 c0                	test   %eax,%eax
80103677:	7e 1e                	jle    80103697 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103679:	e8 35 ff ff ff       	call   801035b3 <write_log>
    write_head();    // Write header to disk -- the real commit
8010367e:	e8 3c fd ff ff       	call   801033bf <write_head>
    install_trans(); // Now install writes to home locations
80103683:	e8 0d fc ff ff       	call   80103295 <install_trans>
    log.lh.n = 0; 
80103688:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
8010368f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103692:	e8 28 fd ff ff       	call   801033bf <write_head>
  }
}
80103697:	c9                   	leave  
80103698:	c3                   	ret    

80103699 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103699:	55                   	push   %ebp
8010369a:	89 e5                	mov    %esp,%ebp
8010369c:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010369f:	a1 48 33 11 80       	mov    0x80113348,%eax
801036a4:	83 f8 1d             	cmp    $0x1d,%eax
801036a7:	7f 12                	jg     801036bb <log_write+0x22>
801036a9:	a1 48 33 11 80       	mov    0x80113348,%eax
801036ae:	8b 15 38 33 11 80    	mov    0x80113338,%edx
801036b4:	83 ea 01             	sub    $0x1,%edx
801036b7:	39 d0                	cmp    %edx,%eax
801036b9:	7c 0d                	jl     801036c8 <log_write+0x2f>
    panic("too big a transaction");
801036bb:	83 ec 0c             	sub    $0xc,%esp
801036be:	68 db 8e 10 80       	push   $0x80108edb
801036c3:	e8 94 ce ff ff       	call   8010055c <panic>
  if (log.outstanding < 1)
801036c8:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801036cd:	85 c0                	test   %eax,%eax
801036cf:	7f 0d                	jg     801036de <log_write+0x45>
    panic("log_write outside of trans");
801036d1:	83 ec 0c             	sub    $0xc,%esp
801036d4:	68 f1 8e 10 80       	push   $0x80108ef1
801036d9:	e8 7e ce ff ff       	call   8010055c <panic>

  acquire(&log.lock);
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	68 00 33 11 80       	push   $0x80113300
801036e6:	e8 d9 1c 00 00       	call   801053c4 <acquire>
801036eb:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801036ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036f5:	eb 1f                	jmp    80103716 <log_write+0x7d>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
801036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036fa:	83 c0 10             	add    $0x10,%eax
801036fd:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
80103704:	89 c2                	mov    %eax,%edx
80103706:	8b 45 08             	mov    0x8(%ebp),%eax
80103709:	8b 40 08             	mov    0x8(%eax),%eax
8010370c:	39 c2                	cmp    %eax,%edx
8010370e:	75 02                	jne    80103712 <log_write+0x79>
      break;
80103710:	eb 0e                	jmp    80103720 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103712:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103716:	a1 48 33 11 80       	mov    0x80113348,%eax
8010371b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010371e:	7f d7                	jg     801036f7 <log_write+0x5e>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
80103720:	8b 45 08             	mov    0x8(%ebp),%eax
80103723:	8b 40 08             	mov    0x8(%eax),%eax
80103726:	89 c2                	mov    %eax,%edx
80103728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010372b:	83 c0 10             	add    $0x10,%eax
8010372e:	89 14 85 0c 33 11 80 	mov    %edx,-0x7feeccf4(,%eax,4)
  if (i == log.lh.n)
80103735:	a1 48 33 11 80       	mov    0x80113348,%eax
8010373a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010373d:	75 0d                	jne    8010374c <log_write+0xb3>
    log.lh.n++;
8010373f:	a1 48 33 11 80       	mov    0x80113348,%eax
80103744:	83 c0 01             	add    $0x1,%eax
80103747:	a3 48 33 11 80       	mov    %eax,0x80113348
  b->flags |= B_DIRTY; // prevent eviction
8010374c:	8b 45 08             	mov    0x8(%ebp),%eax
8010374f:	8b 00                	mov    (%eax),%eax
80103751:	83 c8 04             	or     $0x4,%eax
80103754:	89 c2                	mov    %eax,%edx
80103756:	8b 45 08             	mov    0x8(%ebp),%eax
80103759:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	68 00 33 11 80       	push   $0x80113300
80103763:	e8 c2 1c 00 00       	call   8010542a <release>
80103768:	83 c4 10             	add    $0x10,%esp
}
8010376b:	c9                   	leave  
8010376c:	c3                   	ret    

8010376d <v2p>:
8010376d:	55                   	push   %ebp
8010376e:	89 e5                	mov    %esp,%ebp
80103770:	8b 45 08             	mov    0x8(%ebp),%eax
80103773:	05 00 00 00 80       	add    $0x80000000,%eax
80103778:	5d                   	pop    %ebp
80103779:	c3                   	ret    

8010377a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010377a:	55                   	push   %ebp
8010377b:	89 e5                	mov    %esp,%ebp
8010377d:	8b 45 08             	mov    0x8(%ebp),%eax
80103780:	05 00 00 00 80       	add    $0x80000000,%eax
80103785:	5d                   	pop    %ebp
80103786:	c3                   	ret    

80103787 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103787:	55                   	push   %ebp
80103788:	89 e5                	mov    %esp,%ebp
8010378a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010378d:	8b 55 08             	mov    0x8(%ebp),%edx
80103790:	8b 45 0c             	mov    0xc(%ebp),%eax
80103793:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103796:	f0 87 02             	lock xchg %eax,(%edx)
80103799:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010379c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010379f:	c9                   	leave  
801037a0:	c3                   	ret    

801037a1 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037a1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037a5:	83 e4 f0             	and    $0xfffffff0,%esp
801037a8:	ff 71 fc             	pushl  -0x4(%ecx)
801037ab:	55                   	push   %ebp
801037ac:	89 e5                	mov    %esp,%ebp
801037ae:	51                   	push   %ecx
801037af:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037b2:	83 ec 08             	sub    $0x8,%esp
801037b5:	68 00 00 40 80       	push   $0x80400000
801037ba:	68 5c 6c 11 80       	push   $0x80116c5c
801037bf:	e8 8a f2 ff ff       	call   80102a4e <kinit1>
801037c4:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037c7:	e8 a0 4d 00 00       	call   8010856c <kvmalloc>
  mpinit();        // collect info about this machine
801037cc:	e8 45 04 00 00       	call   80103c16 <mpinit>
  lapicinit();
801037d1:	e8 f0 f5 ff ff       	call   80102dc6 <lapicinit>
  seginit();       // set up segments
801037d6:	e8 52 47 00 00       	call   80107f2d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801037db:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037e1:	0f b6 00             	movzbl (%eax),%eax
801037e4:	0f b6 c0             	movzbl %al,%eax
801037e7:	83 ec 08             	sub    $0x8,%esp
801037ea:	50                   	push   %eax
801037eb:	68 0c 8f 10 80       	push   $0x80108f0c
801037f0:	e8 ca cb ff ff       	call   801003bf <cprintf>
801037f5:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801037f8:	e8 6a 06 00 00       	call   80103e67 <picinit>
  ioapicinit();    // another interrupt controller
801037fd:	e8 44 f1 ff ff       	call   80102946 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103802:	e8 dc d2 ff ff       	call   80100ae3 <consoleinit>
  uartinit();      // serial port
80103807:	e8 84 3a 00 00       	call   80107290 <uartinit>
  pinit();         // process table
8010380c:	e8 55 0b 00 00       	call   80104366 <pinit>
  tvinit();        // trap vectors
80103811:	e8 3d 35 00 00       	call   80106d53 <tvinit>
  binit();         // buffer cache
80103816:	e8 19 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010381b:	e8 0e d7 ff ff       	call   80100f2e <fileinit>
  iinit();         // inode cache
80103820:	e8 d4 dd ff ff       	call   801015f9 <iinit>
  ideinit();       // disk
80103825:	e8 64 ed ff ff       	call   8010258e <ideinit>
  if(!ismp)
8010382a:	a1 04 34 11 80       	mov    0x80113404,%eax
8010382f:	85 c0                	test   %eax,%eax
80103831:	75 05                	jne    80103838 <main+0x97>
    timerinit();   // uniprocessor timer
80103833:	e8 7a 34 00 00       	call   80106cb2 <timerinit>
  startothers();   // start other processors
80103838:	e8 7f 00 00 00       	call   801038bc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010383d:	83 ec 08             	sub    $0x8,%esp
80103840:	68 00 00 00 8e       	push   $0x8e000000
80103845:	68 00 00 40 80       	push   $0x80400000
8010384a:	e8 37 f2 ff ff       	call   80102a86 <kinit2>
8010384f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103852:	e8 91 0d 00 00       	call   801045e8 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103857:	e8 1a 00 00 00       	call   80103876 <mpmain>

8010385c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010385c:	55                   	push   %ebp
8010385d:	89 e5                	mov    %esp,%ebp
8010385f:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103862:	e8 1c 4d 00 00       	call   80108583 <switchkvm>
  seginit();
80103867:	e8 c1 46 00 00       	call   80107f2d <seginit>
  lapicinit();
8010386c:	e8 55 f5 ff ff       	call   80102dc6 <lapicinit>
  mpmain();
80103871:	e8 00 00 00 00       	call   80103876 <mpmain>

80103876 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103876:	55                   	push   %ebp
80103877:	89 e5                	mov    %esp,%ebp
80103879:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010387c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103882:	0f b6 00             	movzbl (%eax),%eax
80103885:	0f b6 c0             	movzbl %al,%eax
80103888:	83 ec 08             	sub    $0x8,%esp
8010388b:	50                   	push   %eax
8010388c:	68 23 8f 10 80       	push   $0x80108f23
80103891:	e8 29 cb ff ff       	call   801003bf <cprintf>
80103896:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103899:	e8 2a 36 00 00       	call   80106ec8 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010389e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038a4:	05 a8 00 00 00       	add    $0xa8,%eax
801038a9:	83 ec 08             	sub    $0x8,%esp
801038ac:	6a 01                	push   $0x1
801038ae:	50                   	push   %eax
801038af:	e8 d3 fe ff ff       	call   80103787 <xchg>
801038b4:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038b7:	e8 ce 13 00 00       	call   80104c8a <scheduler>

801038bc <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038bc:	55                   	push   %ebp
801038bd:	89 e5                	mov    %esp,%ebp
801038bf:	53                   	push   %ebx
801038c0:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038c3:	68 00 70 00 00       	push   $0x7000
801038c8:	e8 ad fe ff ff       	call   8010377a <p2v>
801038cd:	83 c4 04             	add    $0x4,%esp
801038d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038d3:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038d8:	83 ec 04             	sub    $0x4,%esp
801038db:	50                   	push   %eax
801038dc:	68 2c c5 10 80       	push   $0x8010c52c
801038e1:	ff 75 f0             	pushl  -0x10(%ebp)
801038e4:	e8 f6 1d 00 00       	call   801056df <memmove>
801038e9:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801038ec:	c7 45 f4 40 34 11 80 	movl   $0x80113440,-0xc(%ebp)
801038f3:	e9 8f 00 00 00       	jmp    80103987 <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
801038f8:	e8 e5 f5 ff ff       	call   80102ee2 <cpunum>
801038fd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103903:	05 40 34 11 80       	add    $0x80113440,%eax
80103908:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010390b:	75 02                	jne    8010390f <startothers+0x53>
      continue;
8010390d:	eb 71                	jmp    80103980 <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010390f:	e8 6d f2 ff ff       	call   80102b81 <kalloc>
80103914:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391a:	83 e8 04             	sub    $0x4,%eax
8010391d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103920:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103926:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103928:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010392b:	83 e8 08             	sub    $0x8,%eax
8010392e:	c7 00 5c 38 10 80    	movl   $0x8010385c,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103934:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103937:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010393a:	83 ec 0c             	sub    $0xc,%esp
8010393d:	68 00 b0 10 80       	push   $0x8010b000
80103942:	e8 26 fe ff ff       	call   8010376d <v2p>
80103947:	83 c4 10             	add    $0x10,%esp
8010394a:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	ff 75 f0             	pushl  -0x10(%ebp)
80103952:	e8 16 fe ff ff       	call   8010376d <v2p>
80103957:	83 c4 10             	add    $0x10,%esp
8010395a:	89 c2                	mov    %eax,%edx
8010395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010395f:	0f b6 00             	movzbl (%eax),%eax
80103962:	0f b6 c0             	movzbl %al,%eax
80103965:	83 ec 08             	sub    $0x8,%esp
80103968:	52                   	push   %edx
80103969:	50                   	push   %eax
8010396a:	e8 eb f5 ff ff       	call   80102f5a <lapicstartap>
8010396f:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103972:	90                   	nop
80103973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103976:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010397c:	85 c0                	test   %eax,%eax
8010397e:	74 f3                	je     80103973 <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103980:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103987:	a1 20 3a 11 80       	mov    0x80113a20,%eax
8010398c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103992:	05 40 34 11 80       	add    $0x80113440,%eax
80103997:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010399a:	0f 87 58 ff ff ff    	ja     801038f8 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a3:	c9                   	leave  
801039a4:	c3                   	ret    

801039a5 <p2v>:
801039a5:	55                   	push   %ebp
801039a6:	89 e5                	mov    %esp,%ebp
801039a8:	8b 45 08             	mov    0x8(%ebp),%eax
801039ab:	05 00 00 00 80       	add    $0x80000000,%eax
801039b0:	5d                   	pop    %ebp
801039b1:	c3                   	ret    

801039b2 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039b2:	55                   	push   %ebp
801039b3:	89 e5                	mov    %esp,%ebp
801039b5:	83 ec 14             	sub    $0x14,%esp
801039b8:	8b 45 08             	mov    0x8(%ebp),%eax
801039bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039bf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039c3:	89 c2                	mov    %eax,%edx
801039c5:	ec                   	in     (%dx),%al
801039c6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039c9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801039cd:	c9                   	leave  
801039ce:	c3                   	ret    

801039cf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	83 ec 08             	sub    $0x8,%esp
801039d5:	8b 55 08             	mov    0x8(%ebp),%edx
801039d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801039db:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039df:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039e2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039e6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801039ea:	ee                   	out    %al,(%dx)
}
801039eb:	c9                   	leave  
801039ec:	c3                   	ret    

801039ed <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801039ed:	55                   	push   %ebp
801039ee:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801039f0:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801039f5:	89 c2                	mov    %eax,%edx
801039f7:	b8 40 34 11 80       	mov    $0x80113440,%eax
801039fc:	29 c2                	sub    %eax,%edx
801039fe:	89 d0                	mov    %edx,%eax
80103a00:	c1 f8 02             	sar    $0x2,%eax
80103a03:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a09:	5d                   	pop    %ebp
80103a0a:	c3                   	ret    

80103a0b <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a0b:	55                   	push   %ebp
80103a0c:	89 e5                	mov    %esp,%ebp
80103a0e:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a1f:	eb 15                	jmp    80103a36 <sum+0x2b>
    sum += addr[i];
80103a21:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a24:	8b 45 08             	mov    0x8(%ebp),%eax
80103a27:	01 d0                	add    %edx,%eax
80103a29:	0f b6 00             	movzbl (%eax),%eax
80103a2c:	0f b6 c0             	movzbl %al,%eax
80103a2f:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a32:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a39:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a3c:	7c e3                	jl     80103a21 <sum+0x16>
    sum += addr[i];
  return sum;
80103a3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a41:	c9                   	leave  
80103a42:	c3                   	ret    

80103a43 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a43:	55                   	push   %ebp
80103a44:	89 e5                	mov    %esp,%ebp
80103a46:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a49:	ff 75 08             	pushl  0x8(%ebp)
80103a4c:	e8 54 ff ff ff       	call   801039a5 <p2v>
80103a51:	83 c4 04             	add    $0x4,%esp
80103a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a57:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5d:	01 d0                	add    %edx,%eax
80103a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a68:	eb 36                	jmp    80103aa0 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a6a:	83 ec 04             	sub    $0x4,%esp
80103a6d:	6a 04                	push   $0x4
80103a6f:	68 34 8f 10 80       	push   $0x80108f34
80103a74:	ff 75 f4             	pushl  -0xc(%ebp)
80103a77:	e8 0b 1c 00 00       	call   80105687 <memcmp>
80103a7c:	83 c4 10             	add    $0x10,%esp
80103a7f:	85 c0                	test   %eax,%eax
80103a81:	75 19                	jne    80103a9c <mpsearch1+0x59>
80103a83:	83 ec 08             	sub    $0x8,%esp
80103a86:	6a 10                	push   $0x10
80103a88:	ff 75 f4             	pushl  -0xc(%ebp)
80103a8b:	e8 7b ff ff ff       	call   80103a0b <sum>
80103a90:	83 c4 10             	add    $0x10,%esp
80103a93:	84 c0                	test   %al,%al
80103a95:	75 05                	jne    80103a9c <mpsearch1+0x59>
      return (struct mp*)p;
80103a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9a:	eb 11                	jmp    80103aad <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103aa6:	72 c2                	jb     80103a6a <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aad:	c9                   	leave  
80103aae:	c3                   	ret    

80103aaf <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aaf:	55                   	push   %ebp
80103ab0:	89 e5                	mov    %esp,%ebp
80103ab2:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ab5:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abf:	83 c0 0f             	add    $0xf,%eax
80103ac2:	0f b6 00             	movzbl (%eax),%eax
80103ac5:	0f b6 c0             	movzbl %al,%eax
80103ac8:	c1 e0 08             	shl    $0x8,%eax
80103acb:	89 c2                	mov    %eax,%edx
80103acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad0:	83 c0 0e             	add    $0xe,%eax
80103ad3:	0f b6 00             	movzbl (%eax),%eax
80103ad6:	0f b6 c0             	movzbl %al,%eax
80103ad9:	09 d0                	or     %edx,%eax
80103adb:	c1 e0 04             	shl    $0x4,%eax
80103ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ae1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ae5:	74 21                	je     80103b08 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103ae7:	83 ec 08             	sub    $0x8,%esp
80103aea:	68 00 04 00 00       	push   $0x400
80103aef:	ff 75 f0             	pushl  -0x10(%ebp)
80103af2:	e8 4c ff ff ff       	call   80103a43 <mpsearch1>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103afd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b01:	74 51                	je     80103b54 <mpsearch+0xa5>
      return mp;
80103b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b06:	eb 61                	jmp    80103b69 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0b:	83 c0 14             	add    $0x14,%eax
80103b0e:	0f b6 00             	movzbl (%eax),%eax
80103b11:	0f b6 c0             	movzbl %al,%eax
80103b14:	c1 e0 08             	shl    $0x8,%eax
80103b17:	89 c2                	mov    %eax,%edx
80103b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1c:	83 c0 13             	add    $0x13,%eax
80103b1f:	0f b6 00             	movzbl (%eax),%eax
80103b22:	0f b6 c0             	movzbl %al,%eax
80103b25:	09 d0                	or     %edx,%eax
80103b27:	c1 e0 0a             	shl    $0xa,%eax
80103b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b30:	2d 00 04 00 00       	sub    $0x400,%eax
80103b35:	83 ec 08             	sub    $0x8,%esp
80103b38:	68 00 04 00 00       	push   $0x400
80103b3d:	50                   	push   %eax
80103b3e:	e8 00 ff ff ff       	call   80103a43 <mpsearch1>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b4d:	74 05                	je     80103b54 <mpsearch+0xa5>
      return mp;
80103b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b52:	eb 15                	jmp    80103b69 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b54:	83 ec 08             	sub    $0x8,%esp
80103b57:	68 00 00 01 00       	push   $0x10000
80103b5c:	68 00 00 0f 00       	push   $0xf0000
80103b61:	e8 dd fe ff ff       	call   80103a43 <mpsearch1>
80103b66:	83 c4 10             	add    $0x10,%esp
}
80103b69:	c9                   	leave  
80103b6a:	c3                   	ret    

80103b6b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b6b:	55                   	push   %ebp
80103b6c:	89 e5                	mov    %esp,%ebp
80103b6e:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b71:	e8 39 ff ff ff       	call   80103aaf <mpsearch>
80103b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b7d:	74 0a                	je     80103b89 <mpconfig+0x1e>
80103b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b82:	8b 40 04             	mov    0x4(%eax),%eax
80103b85:	85 c0                	test   %eax,%eax
80103b87:	75 0a                	jne    80103b93 <mpconfig+0x28>
    return 0;
80103b89:	b8 00 00 00 00       	mov    $0x0,%eax
80103b8e:	e9 81 00 00 00       	jmp    80103c14 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b96:	8b 40 04             	mov    0x4(%eax),%eax
80103b99:	83 ec 0c             	sub    $0xc,%esp
80103b9c:	50                   	push   %eax
80103b9d:	e8 03 fe ff ff       	call   801039a5 <p2v>
80103ba2:	83 c4 10             	add    $0x10,%esp
80103ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ba8:	83 ec 04             	sub    $0x4,%esp
80103bab:	6a 04                	push   $0x4
80103bad:	68 39 8f 10 80       	push   $0x80108f39
80103bb2:	ff 75 f0             	pushl  -0x10(%ebp)
80103bb5:	e8 cd 1a 00 00       	call   80105687 <memcmp>
80103bba:	83 c4 10             	add    $0x10,%esp
80103bbd:	85 c0                	test   %eax,%eax
80103bbf:	74 07                	je     80103bc8 <mpconfig+0x5d>
    return 0;
80103bc1:	b8 00 00 00 00       	mov    $0x0,%eax
80103bc6:	eb 4c                	jmp    80103c14 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcb:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bcf:	3c 01                	cmp    $0x1,%al
80103bd1:	74 12                	je     80103be5 <mpconfig+0x7a>
80103bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd6:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bda:	3c 04                	cmp    $0x4,%al
80103bdc:	74 07                	je     80103be5 <mpconfig+0x7a>
    return 0;
80103bde:	b8 00 00 00 00       	mov    $0x0,%eax
80103be3:	eb 2f                	jmp    80103c14 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be8:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bec:	0f b7 c0             	movzwl %ax,%eax
80103bef:	83 ec 08             	sub    $0x8,%esp
80103bf2:	50                   	push   %eax
80103bf3:	ff 75 f0             	pushl  -0x10(%ebp)
80103bf6:	e8 10 fe ff ff       	call   80103a0b <sum>
80103bfb:	83 c4 10             	add    $0x10,%esp
80103bfe:	84 c0                	test   %al,%al
80103c00:	74 07                	je     80103c09 <mpconfig+0x9e>
    return 0;
80103c02:	b8 00 00 00 00       	mov    $0x0,%eax
80103c07:	eb 0b                	jmp    80103c14 <mpconfig+0xa9>
  *pmp = mp;
80103c09:	8b 45 08             	mov    0x8(%ebp),%eax
80103c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c0f:	89 10                	mov    %edx,(%eax)
  return conf;
80103c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c14:	c9                   	leave  
80103c15:	c3                   	ret    

80103c16 <mpinit>:

void
mpinit(void)
{
80103c16:	55                   	push   %ebp
80103c17:	89 e5                	mov    %esp,%ebp
80103c19:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c1c:	c7 05 64 c6 10 80 40 	movl   $0x80113440,0x8010c664
80103c23:	34 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c26:	83 ec 0c             	sub    $0xc,%esp
80103c29:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c2c:	50                   	push   %eax
80103c2d:	e8 39 ff ff ff       	call   80103b6b <mpconfig>
80103c32:	83 c4 10             	add    $0x10,%esp
80103c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c3c:	75 05                	jne    80103c43 <mpinit+0x2d>
    return;
80103c3e:	e9 94 01 00 00       	jmp    80103dd7 <mpinit+0x1c1>
  ismp = 1;
80103c43:	c7 05 04 34 11 80 01 	movl   $0x1,0x80113404
80103c4a:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c50:	8b 40 24             	mov    0x24(%eax),%eax
80103c53:	a3 dc 32 11 80       	mov    %eax,0x801132dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c5b:	83 c0 2c             	add    $0x2c,%eax
80103c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c64:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c68:	0f b7 d0             	movzwl %ax,%edx
80103c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6e:	01 d0                	add    %edx,%eax
80103c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c73:	e9 f2 00 00 00       	jmp    80103d6a <mpinit+0x154>
    switch(*p){
80103c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7b:	0f b6 00             	movzbl (%eax),%eax
80103c7e:	0f b6 c0             	movzbl %al,%eax
80103c81:	83 f8 04             	cmp    $0x4,%eax
80103c84:	0f 87 bc 00 00 00    	ja     80103d46 <mpinit+0x130>
80103c8a:	8b 04 85 7c 8f 10 80 	mov    -0x7fef7084(,%eax,4),%eax
80103c91:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c96:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c9c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ca0:	0f b6 d0             	movzbl %al,%edx
80103ca3:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103ca8:	39 c2                	cmp    %eax,%edx
80103caa:	74 2b                	je     80103cd7 <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103caf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cb3:	0f b6 d0             	movzbl %al,%edx
80103cb6:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103cbb:	83 ec 04             	sub    $0x4,%esp
80103cbe:	52                   	push   %edx
80103cbf:	50                   	push   %eax
80103cc0:	68 3e 8f 10 80       	push   $0x80108f3e
80103cc5:	e8 f5 c6 ff ff       	call   801003bf <cprintf>
80103cca:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103ccd:	c7 05 04 34 11 80 00 	movl   $0x0,0x80113404
80103cd4:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cda:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103cde:	0f b6 c0             	movzbl %al,%eax
80103ce1:	83 e0 02             	and    $0x2,%eax
80103ce4:	85 c0                	test   %eax,%eax
80103ce6:	74 15                	je     80103cfd <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103ce8:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103ced:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103cf3:	05 40 34 11 80       	add    $0x80113440,%eax
80103cf8:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103cfd:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103d02:	8b 15 20 3a 11 80    	mov    0x80113a20,%edx
80103d08:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d0e:	05 40 34 11 80       	add    $0x80113440,%eax
80103d13:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d15:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103d1a:	83 c0 01             	add    $0x1,%eax
80103d1d:	a3 20 3a 11 80       	mov    %eax,0x80113a20
      p += sizeof(struct mpproc);
80103d22:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d26:	eb 42                	jmp    80103d6a <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d31:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d35:	a2 00 34 11 80       	mov    %al,0x80113400
      p += sizeof(struct mpioapic);
80103d3a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d3e:	eb 2a                	jmp    80103d6a <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d40:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d44:	eb 24                	jmp    80103d6a <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d49:	0f b6 00             	movzbl (%eax),%eax
80103d4c:	0f b6 c0             	movzbl %al,%eax
80103d4f:	83 ec 08             	sub    $0x8,%esp
80103d52:	50                   	push   %eax
80103d53:	68 5c 8f 10 80       	push   $0x80108f5c
80103d58:	e8 62 c6 ff ff       	call   801003bf <cprintf>
80103d5d:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d60:	c7 05 04 34 11 80 00 	movl   $0x0,0x80113404
80103d67:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d70:	0f 82 02 ff ff ff    	jb     80103c78 <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d76:	a1 04 34 11 80       	mov    0x80113404,%eax
80103d7b:	85 c0                	test   %eax,%eax
80103d7d:	75 1d                	jne    80103d9c <mpinit+0x186>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d7f:	c7 05 20 3a 11 80 01 	movl   $0x1,0x80113a20
80103d86:	00 00 00 
    lapic = 0;
80103d89:	c7 05 dc 32 11 80 00 	movl   $0x0,0x801132dc
80103d90:	00 00 00 
    ioapicid = 0;
80103d93:	c6 05 00 34 11 80 00 	movb   $0x0,0x80113400
    return;
80103d9a:	eb 3b                	jmp    80103dd7 <mpinit+0x1c1>
  }

  if(mp->imcrp){
80103d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d9f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103da3:	84 c0                	test   %al,%al
80103da5:	74 30                	je     80103dd7 <mpinit+0x1c1>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103da7:	83 ec 08             	sub    $0x8,%esp
80103daa:	6a 70                	push   $0x70
80103dac:	6a 22                	push   $0x22
80103dae:	e8 1c fc ff ff       	call   801039cf <outb>
80103db3:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	6a 23                	push   $0x23
80103dbb:	e8 f2 fb ff ff       	call   801039b2 <inb>
80103dc0:	83 c4 10             	add    $0x10,%esp
80103dc3:	83 c8 01             	or     $0x1,%eax
80103dc6:	0f b6 c0             	movzbl %al,%eax
80103dc9:	83 ec 08             	sub    $0x8,%esp
80103dcc:	50                   	push   %eax
80103dcd:	6a 23                	push   $0x23
80103dcf:	e8 fb fb ff ff       	call   801039cf <outb>
80103dd4:	83 c4 10             	add    $0x10,%esp
  }
}
80103dd7:	c9                   	leave  
80103dd8:	c3                   	ret    

80103dd9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dd9:	55                   	push   %ebp
80103dda:	89 e5                	mov    %esp,%ebp
80103ddc:	83 ec 08             	sub    $0x8,%esp
80103ddf:	8b 55 08             	mov    0x8(%ebp),%edx
80103de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103de9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dec:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103df0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103df4:	ee                   	out    %al,(%dx)
}
80103df5:	c9                   	leave  
80103df6:	c3                   	ret    

80103df7 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103df7:	55                   	push   %ebp
80103df8:	89 e5                	mov    %esp,%ebp
80103dfa:	83 ec 04             	sub    $0x4,%esp
80103dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80103e00:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e04:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e08:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e0e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e12:	0f b6 c0             	movzbl %al,%eax
80103e15:	50                   	push   %eax
80103e16:	6a 21                	push   $0x21
80103e18:	e8 bc ff ff ff       	call   80103dd9 <outb>
80103e1d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e20:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e24:	66 c1 e8 08          	shr    $0x8,%ax
80103e28:	0f b6 c0             	movzbl %al,%eax
80103e2b:	50                   	push   %eax
80103e2c:	68 a1 00 00 00       	push   $0xa1
80103e31:	e8 a3 ff ff ff       	call   80103dd9 <outb>
80103e36:	83 c4 08             	add    $0x8,%esp
}
80103e39:	c9                   	leave  
80103e3a:	c3                   	ret    

80103e3b <picenable>:

void
picenable(int irq)
{
80103e3b:	55                   	push   %ebp
80103e3c:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e41:	ba 01 00 00 00       	mov    $0x1,%edx
80103e46:	89 c1                	mov    %eax,%ecx
80103e48:	d3 e2                	shl    %cl,%edx
80103e4a:	89 d0                	mov    %edx,%eax
80103e4c:	f7 d0                	not    %eax
80103e4e:	89 c2                	mov    %eax,%edx
80103e50:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e57:	21 d0                	and    %edx,%eax
80103e59:	0f b7 c0             	movzwl %ax,%eax
80103e5c:	50                   	push   %eax
80103e5d:	e8 95 ff ff ff       	call   80103df7 <picsetmask>
80103e62:	83 c4 04             	add    $0x4,%esp
}
80103e65:	c9                   	leave  
80103e66:	c3                   	ret    

80103e67 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e67:	55                   	push   %ebp
80103e68:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e6a:	68 ff 00 00 00       	push   $0xff
80103e6f:	6a 21                	push   $0x21
80103e71:	e8 63 ff ff ff       	call   80103dd9 <outb>
80103e76:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103e79:	68 ff 00 00 00       	push   $0xff
80103e7e:	68 a1 00 00 00       	push   $0xa1
80103e83:	e8 51 ff ff ff       	call   80103dd9 <outb>
80103e88:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e8b:	6a 11                	push   $0x11
80103e8d:	6a 20                	push   $0x20
80103e8f:	e8 45 ff ff ff       	call   80103dd9 <outb>
80103e94:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e97:	6a 20                	push   $0x20
80103e99:	6a 21                	push   $0x21
80103e9b:	e8 39 ff ff ff       	call   80103dd9 <outb>
80103ea0:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ea3:	6a 04                	push   $0x4
80103ea5:	6a 21                	push   $0x21
80103ea7:	e8 2d ff ff ff       	call   80103dd9 <outb>
80103eac:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103eaf:	6a 03                	push   $0x3
80103eb1:	6a 21                	push   $0x21
80103eb3:	e8 21 ff ff ff       	call   80103dd9 <outb>
80103eb8:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ebb:	6a 11                	push   $0x11
80103ebd:	68 a0 00 00 00       	push   $0xa0
80103ec2:	e8 12 ff ff ff       	call   80103dd9 <outb>
80103ec7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103eca:	6a 28                	push   $0x28
80103ecc:	68 a1 00 00 00       	push   $0xa1
80103ed1:	e8 03 ff ff ff       	call   80103dd9 <outb>
80103ed6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ed9:	6a 02                	push   $0x2
80103edb:	68 a1 00 00 00       	push   $0xa1
80103ee0:	e8 f4 fe ff ff       	call   80103dd9 <outb>
80103ee5:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ee8:	6a 03                	push   $0x3
80103eea:	68 a1 00 00 00       	push   $0xa1
80103eef:	e8 e5 fe ff ff       	call   80103dd9 <outb>
80103ef4:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ef7:	6a 68                	push   $0x68
80103ef9:	6a 20                	push   $0x20
80103efb:	e8 d9 fe ff ff       	call   80103dd9 <outb>
80103f00:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f03:	6a 0a                	push   $0xa
80103f05:	6a 20                	push   $0x20
80103f07:	e8 cd fe ff ff       	call   80103dd9 <outb>
80103f0c:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f0f:	6a 68                	push   $0x68
80103f11:	68 a0 00 00 00       	push   $0xa0
80103f16:	e8 be fe ff ff       	call   80103dd9 <outb>
80103f1b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f1e:	6a 0a                	push   $0xa
80103f20:	68 a0 00 00 00       	push   $0xa0
80103f25:	e8 af fe ff ff       	call   80103dd9 <outb>
80103f2a:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103f2d:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f34:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f38:	74 13                	je     80103f4d <picinit+0xe6>
    picsetmask(irqmask);
80103f3a:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f41:	0f b7 c0             	movzwl %ax,%eax
80103f44:	50                   	push   %eax
80103f45:	e8 ad fe ff ff       	call   80103df7 <picsetmask>
80103f4a:	83 c4 04             	add    $0x4,%esp
}
80103f4d:	c9                   	leave  
80103f4e:	c3                   	ret    

80103f4f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f4f:	55                   	push   %ebp
80103f50:	89 e5                	mov    %esp,%ebp
80103f52:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f65:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f68:	8b 10                	mov    (%eax),%edx
80103f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6d:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f6f:	e8 d7 cf ff ff       	call   80100f4b <filealloc>
80103f74:	89 c2                	mov    %eax,%edx
80103f76:	8b 45 08             	mov    0x8(%ebp),%eax
80103f79:	89 10                	mov    %edx,(%eax)
80103f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7e:	8b 00                	mov    (%eax),%eax
80103f80:	85 c0                	test   %eax,%eax
80103f82:	0f 84 cb 00 00 00    	je     80104053 <pipealloc+0x104>
80103f88:	e8 be cf ff ff       	call   80100f4b <filealloc>
80103f8d:	89 c2                	mov    %eax,%edx
80103f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f92:	89 10                	mov    %edx,(%eax)
80103f94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f97:	8b 00                	mov    (%eax),%eax
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	0f 84 b2 00 00 00    	je     80104053 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fa1:	e8 db eb ff ff       	call   80102b81 <kalloc>
80103fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fad:	75 05                	jne    80103fb4 <pipealloc+0x65>
    goto bad;
80103faf:	e9 9f 00 00 00       	jmp    80104053 <pipealloc+0x104>
  p->readopen = 1;
80103fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fbe:	00 00 00 
  p->writeopen = 1;
80103fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fcb:	00 00 00 
  p->nwrite = 0;
80103fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fd8:	00 00 00 
  p->nread = 0;
80103fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fde:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fe5:	00 00 00 
  initlock(&p->lock, "pipe");
80103fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103feb:	83 ec 08             	sub    $0x8,%esp
80103fee:	68 90 8f 10 80       	push   $0x80108f90
80103ff3:	50                   	push   %eax
80103ff4:	e8 aa 13 00 00       	call   801053a3 <initlock>
80103ff9:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fff:	8b 00                	mov    (%eax),%eax
80104001:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104007:	8b 45 08             	mov    0x8(%ebp),%eax
8010400a:	8b 00                	mov    (%eax),%eax
8010400c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104010:	8b 45 08             	mov    0x8(%ebp),%eax
80104013:	8b 00                	mov    (%eax),%eax
80104015:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104019:	8b 45 08             	mov    0x8(%ebp),%eax
8010401c:	8b 00                	mov    (%eax),%eax
8010401e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104021:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104024:	8b 45 0c             	mov    0xc(%ebp),%eax
80104027:	8b 00                	mov    (%eax),%eax
80104029:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010402f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104032:	8b 00                	mov    (%eax),%eax
80104034:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104038:	8b 45 0c             	mov    0xc(%ebp),%eax
8010403b:	8b 00                	mov    (%eax),%eax
8010403d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104041:	8b 45 0c             	mov    0xc(%ebp),%eax
80104044:	8b 00                	mov    (%eax),%eax
80104046:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104049:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010404c:	b8 00 00 00 00       	mov    $0x0,%eax
80104051:	eb 4d                	jmp    801040a0 <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
80104053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104057:	74 0e                	je     80104067 <pipealloc+0x118>
    kfree((char*)p);
80104059:	83 ec 0c             	sub    $0xc,%esp
8010405c:	ff 75 f4             	pushl  -0xc(%ebp)
8010405f:	e8 81 ea ff ff       	call   80102ae5 <kfree>
80104064:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104067:	8b 45 08             	mov    0x8(%ebp),%eax
8010406a:	8b 00                	mov    (%eax),%eax
8010406c:	85 c0                	test   %eax,%eax
8010406e:	74 11                	je     80104081 <pipealloc+0x132>
    fileclose(*f0);
80104070:	8b 45 08             	mov    0x8(%ebp),%eax
80104073:	8b 00                	mov    (%eax),%eax
80104075:	83 ec 0c             	sub    $0xc,%esp
80104078:	50                   	push   %eax
80104079:	e8 8a cf ff ff       	call   80101008 <fileclose>
8010407e:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104081:	8b 45 0c             	mov    0xc(%ebp),%eax
80104084:	8b 00                	mov    (%eax),%eax
80104086:	85 c0                	test   %eax,%eax
80104088:	74 11                	je     8010409b <pipealloc+0x14c>
    fileclose(*f1);
8010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408d:	8b 00                	mov    (%eax),%eax
8010408f:	83 ec 0c             	sub    $0xc,%esp
80104092:	50                   	push   %eax
80104093:	e8 70 cf ff ff       	call   80101008 <fileclose>
80104098:	83 c4 10             	add    $0x10,%esp
  return -1;
8010409b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040a0:	c9                   	leave  
801040a1:	c3                   	ret    

801040a2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040a2:	55                   	push   %ebp
801040a3:	89 e5                	mov    %esp,%ebp
801040a5:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040a8:	8b 45 08             	mov    0x8(%ebp),%eax
801040ab:	83 ec 0c             	sub    $0xc,%esp
801040ae:	50                   	push   %eax
801040af:	e8 10 13 00 00       	call   801053c4 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  if(writable){
801040b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040bb:	74 23                	je     801040e0 <pipeclose+0x3e>
    p->writeopen = 0;
801040bd:	8b 45 08             	mov    0x8(%ebp),%eax
801040c0:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801040c7:	00 00 00 
    wakeup(&p->nread);
801040ca:	8b 45 08             	mov    0x8(%ebp),%eax
801040cd:	05 34 02 00 00       	add    $0x234,%eax
801040d2:	83 ec 0c             	sub    $0xc,%esp
801040d5:	50                   	push   %eax
801040d6:	e8 18 0f 00 00       	call   80104ff3 <wakeup>
801040db:	83 c4 10             	add    $0x10,%esp
801040de:	eb 21                	jmp    80104101 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801040e0:	8b 45 08             	mov    0x8(%ebp),%eax
801040e3:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040ea:	00 00 00 
    wakeup(&p->nwrite);
801040ed:	8b 45 08             	mov    0x8(%ebp),%eax
801040f0:	05 38 02 00 00       	add    $0x238,%eax
801040f5:	83 ec 0c             	sub    $0xc,%esp
801040f8:	50                   	push   %eax
801040f9:	e8 f5 0e 00 00       	call   80104ff3 <wakeup>
801040fe:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010410a:	85 c0                	test   %eax,%eax
8010410c:	75 2c                	jne    8010413a <pipeclose+0x98>
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104117:	85 c0                	test   %eax,%eax
80104119:	75 1f                	jne    8010413a <pipeclose+0x98>
    release(&p->lock);
8010411b:	8b 45 08             	mov    0x8(%ebp),%eax
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	50                   	push   %eax
80104122:	e8 03 13 00 00       	call   8010542a <release>
80104127:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	ff 75 08             	pushl  0x8(%ebp)
80104130:	e8 b0 e9 ff ff       	call   80102ae5 <kfree>
80104135:	83 c4 10             	add    $0x10,%esp
80104138:	eb 0f                	jmp    80104149 <pipeclose+0xa7>
  } else
    release(&p->lock);
8010413a:	8b 45 08             	mov    0x8(%ebp),%eax
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	50                   	push   %eax
80104141:	e8 e4 12 00 00       	call   8010542a <release>
80104146:	83 c4 10             	add    $0x10,%esp
}
80104149:	c9                   	leave  
8010414a:	c3                   	ret    

8010414b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010414b:	55                   	push   %ebp
8010414c:	89 e5                	mov    %esp,%ebp
8010414e:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	50                   	push   %eax
80104158:	e8 67 12 00 00       	call   801053c4 <acquire>
8010415d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104167:	e9 af 00 00 00       	jmp    8010421b <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010416c:	eb 60                	jmp    801041ce <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
8010416e:	8b 45 08             	mov    0x8(%ebp),%eax
80104171:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104177:	85 c0                	test   %eax,%eax
80104179:	74 0d                	je     80104188 <pipewrite+0x3d>
8010417b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104181:	8b 40 24             	mov    0x24(%eax),%eax
80104184:	85 c0                	test   %eax,%eax
80104186:	74 19                	je     801041a1 <pipewrite+0x56>
        release(&p->lock);
80104188:	8b 45 08             	mov    0x8(%ebp),%eax
8010418b:	83 ec 0c             	sub    $0xc,%esp
8010418e:	50                   	push   %eax
8010418f:	e8 96 12 00 00       	call   8010542a <release>
80104194:	83 c4 10             	add    $0x10,%esp
        return -1;
80104197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419c:	e9 ac 00 00 00       	jmp    8010424d <pipewrite+0x102>
      }
      wakeup(&p->nread);
801041a1:	8b 45 08             	mov    0x8(%ebp),%eax
801041a4:	05 34 02 00 00       	add    $0x234,%eax
801041a9:	83 ec 0c             	sub    $0xc,%esp
801041ac:	50                   	push   %eax
801041ad:	e8 41 0e 00 00       	call   80104ff3 <wakeup>
801041b2:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041b5:	8b 45 08             	mov    0x8(%ebp),%eax
801041b8:	8b 55 08             	mov    0x8(%ebp),%edx
801041bb:	81 c2 38 02 00 00    	add    $0x238,%edx
801041c1:	83 ec 08             	sub    $0x8,%esp
801041c4:	50                   	push   %eax
801041c5:	52                   	push   %edx
801041c6:	e8 05 0d 00 00       	call   80104ed0 <sleep>
801041cb:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041ce:	8b 45 08             	mov    0x8(%ebp),%eax
801041d1:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801041d7:	8b 45 08             	mov    0x8(%ebp),%eax
801041da:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041e0:	05 00 02 00 00       	add    $0x200,%eax
801041e5:	39 c2                	cmp    %eax,%edx
801041e7:	74 85                	je     8010416e <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041e9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ec:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041f2:	8d 48 01             	lea    0x1(%eax),%ecx
801041f5:	8b 55 08             	mov    0x8(%ebp),%edx
801041f8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041fe:	25 ff 01 00 00       	and    $0x1ff,%eax
80104203:	89 c1                	mov    %eax,%ecx
80104205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420b:	01 d0                	add    %edx,%eax
8010420d:	0f b6 10             	movzbl (%eax),%edx
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104217:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421e:	3b 45 10             	cmp    0x10(%ebp),%eax
80104221:	0f 8c 45 ff ff ff    	jl     8010416c <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104227:	8b 45 08             	mov    0x8(%ebp),%eax
8010422a:	05 34 02 00 00       	add    $0x234,%eax
8010422f:	83 ec 0c             	sub    $0xc,%esp
80104232:	50                   	push   %eax
80104233:	e8 bb 0d 00 00       	call   80104ff3 <wakeup>
80104238:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010423b:	8b 45 08             	mov    0x8(%ebp),%eax
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	50                   	push   %eax
80104242:	e8 e3 11 00 00       	call   8010542a <release>
80104247:	83 c4 10             	add    $0x10,%esp
  return n;
8010424a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010424d:	c9                   	leave  
8010424e:	c3                   	ret    

8010424f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010424f:	55                   	push   %ebp
80104250:	89 e5                	mov    %esp,%ebp
80104252:	53                   	push   %ebx
80104253:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104256:	8b 45 08             	mov    0x8(%ebp),%eax
80104259:	83 ec 0c             	sub    $0xc,%esp
8010425c:	50                   	push   %eax
8010425d:	e8 62 11 00 00       	call   801053c4 <acquire>
80104262:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104265:	eb 3f                	jmp    801042a6 <piperead+0x57>
    if(proc->killed){
80104267:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010426d:	8b 40 24             	mov    0x24(%eax),%eax
80104270:	85 c0                	test   %eax,%eax
80104272:	74 19                	je     8010428d <piperead+0x3e>
      release(&p->lock);
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	83 ec 0c             	sub    $0xc,%esp
8010427a:	50                   	push   %eax
8010427b:	e8 aa 11 00 00       	call   8010542a <release>
80104280:	83 c4 10             	add    $0x10,%esp
      return -1;
80104283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104288:	e9 be 00 00 00       	jmp    8010434b <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010428d:	8b 45 08             	mov    0x8(%ebp),%eax
80104290:	8b 55 08             	mov    0x8(%ebp),%edx
80104293:	81 c2 34 02 00 00    	add    $0x234,%edx
80104299:	83 ec 08             	sub    $0x8,%esp
8010429c:	50                   	push   %eax
8010429d:	52                   	push   %edx
8010429e:	e8 2d 0c 00 00       	call   80104ed0 <sleep>
801042a3:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042a6:	8b 45 08             	mov    0x8(%ebp),%eax
801042a9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042af:	8b 45 08             	mov    0x8(%ebp),%eax
801042b2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042b8:	39 c2                	cmp    %eax,%edx
801042ba:	75 0d                	jne    801042c9 <piperead+0x7a>
801042bc:	8b 45 08             	mov    0x8(%ebp),%eax
801042bf:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042c5:	85 c0                	test   %eax,%eax
801042c7:	75 9e                	jne    80104267 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042d0:	eb 4b                	jmp    8010431d <piperead+0xce>
    if(p->nread == p->nwrite)
801042d2:	8b 45 08             	mov    0x8(%ebp),%eax
801042d5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042db:	8b 45 08             	mov    0x8(%ebp),%eax
801042de:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042e4:	39 c2                	cmp    %eax,%edx
801042e6:	75 02                	jne    801042ea <piperead+0x9b>
      break;
801042e8:	eb 3b                	jmp    80104325 <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042f3:	8b 45 08             	mov    0x8(%ebp),%eax
801042f6:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042fc:	8d 48 01             	lea    0x1(%eax),%ecx
801042ff:	8b 55 08             	mov    0x8(%ebp),%edx
80104302:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104308:	25 ff 01 00 00       	and    $0x1ff,%eax
8010430d:	89 c2                	mov    %eax,%edx
8010430f:	8b 45 08             	mov    0x8(%ebp),%eax
80104312:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104317:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104319:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010431d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104320:	3b 45 10             	cmp    0x10(%ebp),%eax
80104323:	7c ad                	jl     801042d2 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
80104328:	05 38 02 00 00       	add    $0x238,%eax
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	50                   	push   %eax
80104331:	e8 bd 0c 00 00       	call   80104ff3 <wakeup>
80104336:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104339:	8b 45 08             	mov    0x8(%ebp),%eax
8010433c:	83 ec 0c             	sub    $0xc,%esp
8010433f:	50                   	push   %eax
80104340:	e8 e5 10 00 00       	call   8010542a <release>
80104345:	83 c4 10             	add    $0x10,%esp
  return i;
80104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010434b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434e:	c9                   	leave  
8010434f:	c3                   	ret    

80104350 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104356:	9c                   	pushf  
80104357:	58                   	pop    %eax
80104358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010435b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010435e:	c9                   	leave  
8010435f:	c3                   	ret    

80104360 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104363:	fb                   	sti    
}
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    

80104366 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104366:	55                   	push   %ebp
80104367:	89 e5                	mov    %esp,%ebp
80104369:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010436c:	83 ec 08             	sub    $0x8,%esp
8010436f:	68 95 8f 10 80       	push   $0x80108f95
80104374:	68 40 3a 11 80       	push   $0x80113a40
80104379:	e8 25 10 00 00       	call   801053a3 <initlock>
8010437e:	83 c4 10             	add    $0x10,%esp
}
80104381:	c9                   	leave  
80104382:	c3                   	ret    

80104383 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104383:	55                   	push   %ebp
80104384:	89 e5                	mov    %esp,%ebp
80104386:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104389:	83 ec 0c             	sub    $0xc,%esp
8010438c:	68 40 3a 11 80       	push   $0x80113a40
80104391:	e8 2e 10 00 00       	call   801053c4 <acquire>
80104396:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104399:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
801043a0:	eb 73                	jmp    80104415 <allocproc+0x92>
    if(p->state == UNUSED)
801043a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a5:	8b 40 0c             	mov    0xc(%eax),%eax
801043a8:	85 c0                	test   %eax,%eax
801043aa:	75 62                	jne    8010440e <allocproc+0x8b>
      goto found;
801043ac:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801043b7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801043bc:	8d 50 01             	lea    0x1(%eax),%edx
801043bf:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801043c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043c8:	89 42 10             	mov    %eax,0x10(%edx)
  p->priority = 0;
801043cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ce:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801043d5:	00 00 00 
  p->next = 0;
801043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043db:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801043e2:	00 00 00 
  release(&ptable.lock);
801043e5:	83 ec 0c             	sub    $0xc,%esp
801043e8:	68 40 3a 11 80       	push   $0x80113a40
801043ed:	e8 38 10 00 00       	call   8010542a <release>
801043f2:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801043f5:	e8 87 e7 ff ff       	call   80102b81 <kalloc>
801043fa:	89 c2                	mov    %eax,%edx
801043fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ff:	89 50 08             	mov    %edx,0x8(%eax)
80104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104405:	8b 40 08             	mov    0x8(%eax),%eax
80104408:	85 c0                	test   %eax,%eax
8010440a:	75 3a                	jne    80104446 <allocproc+0xc3>
8010440c:	eb 27                	jmp    80104435 <allocproc+0xb2>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010440e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104415:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
8010441c:	72 84                	jb     801043a2 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010441e:	83 ec 0c             	sub    $0xc,%esp
80104421:	68 40 3a 11 80       	push   $0x80113a40
80104426:	e8 ff 0f 00 00       	call   8010542a <release>
8010442b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010442e:	b8 00 00 00 00       	mov    $0x0,%eax
80104433:	eb 6e                	jmp    801044a3 <allocproc+0x120>
  p->next = 0;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104438:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010443f:	b8 00 00 00 00       	mov    $0x0,%eax
80104444:	eb 5d                	jmp    801044a3 <allocproc+0x120>
  }
  sp = p->kstack + KSTACKSIZE;
80104446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104449:	8b 40 08             	mov    0x8(%eax),%eax
8010444c:	05 00 10 00 00       	add    $0x1000,%eax
80104451:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104454:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010445e:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104461:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104465:	ba 0e 6d 10 80       	mov    $0x80106d0e,%edx
8010446a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010446d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010446f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104476:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104479:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104482:	83 ec 04             	sub    $0x4,%esp
80104485:	6a 14                	push   $0x14
80104487:	6a 00                	push   $0x0
80104489:	50                   	push   %eax
8010448a:	e8 91 11 00 00       	call   80105620 <memset>
8010448f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104495:	8b 40 1c             	mov    0x1c(%eax),%eax
80104498:	ba a0 4e 10 80       	mov    $0x80104ea0,%edx
8010449d:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044a3:	c9                   	leave  
801044a4:	c3                   	ret    

801044a5 <is_empty>:


//reports if the queue is empty
//1 = true
int is_empty(int i){
801044a5:	55                   	push   %ebp
801044a6:	89 e5                	mov    %esp,%ebp
  return (ptable.mlf[i].first == 0);
801044a8:	8b 45 08             	mov    0x8(%ebp),%eax
801044ab:	05 06 05 00 00       	add    $0x506,%eax
801044b0:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801044b7:	85 c0                	test   %eax,%eax
801044b9:	0f 94 c0             	sete   %al
801044bc:	0f b6 c0             	movzbl %al,%eax
}
801044bf:	5d                   	pop    %ebp
801044c0:	c3                   	ret    

801044c1 <enqueue>:

// enqueue in mlf[priority]
void enqueue(struct proc *p,int priority){
801044c1:	55                   	push   %ebp
801044c2:	89 e5                	mov    %esp,%ebp
  if (!is_empty(priority)){
801044c4:	ff 75 0c             	pushl  0xc(%ebp)
801044c7:	e8 d9 ff ff ff       	call   801044a5 <is_empty>
801044cc:	83 c4 04             	add    $0x4,%esp
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 2d                	jne    80104500 <enqueue+0x3f>
    ptable.mlf[priority].last->next = p;
801044d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d6:	05 06 05 00 00       	add    $0x506,%eax
801044db:	8b 04 c5 48 3a 11 80 	mov    -0x7feec5b8(,%eax,8),%eax
801044e2:	8b 55 08             	mov    0x8(%ebp),%edx
801044e5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    ptable.mlf[priority].last = p;
801044eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ee:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
801044f4:	8b 45 08             	mov    0x8(%ebp),%eax
801044f7:	89 04 d5 48 3a 11 80 	mov    %eax,-0x7feec5b8(,%edx,8)
801044fe:	eb 26                	jmp    80104526 <enqueue+0x65>
  } else {
    ptable.mlf[priority].first = p;
80104500:	8b 45 0c             	mov    0xc(%ebp),%eax
80104503:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
80104509:	8b 45 08             	mov    0x8(%ebp),%eax
8010450c:	89 04 d5 44 3a 11 80 	mov    %eax,-0x7feec5bc(,%edx,8)
    ptable.mlf[priority].last = p;
80104513:	8b 45 0c             	mov    0xc(%ebp),%eax
80104516:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
8010451c:	8b 45 08             	mov    0x8(%ebp),%eax
8010451f:	89 04 d5 48 3a 11 80 	mov    %eax,-0x7feec5b8(,%edx,8)
  }
}
80104526:	c9                   	leave  
80104527:	c3                   	ret    

80104528 <dequeue>:

// dequeue in mlf[priority]
struct proc * dequeue(int priority){
80104528:	55                   	push   %ebp
80104529:	89 e5                	mov    %esp,%ebp
8010452b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = 0;
8010452e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  if (!is_empty(priority)){
80104535:	ff 75 08             	pushl  0x8(%ebp)
80104538:	e8 68 ff ff ff       	call   801044a5 <is_empty>
8010453d:	83 c4 04             	add    $0x4,%esp
80104540:	85 c0                	test   %eax,%eax
80104542:	0f 85 9b 00 00 00    	jne    801045e3 <dequeue+0xbb>
    if (ptable.mlf[priority].first == ptable.mlf[priority].last){ 
80104548:	8b 45 08             	mov    0x8(%ebp),%eax
8010454b:	05 06 05 00 00       	add    $0x506,%eax
80104550:	8b 14 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%edx
80104557:	8b 45 08             	mov    0x8(%ebp),%eax
8010455a:	05 06 05 00 00       	add    $0x506,%eax
8010455f:	8b 04 c5 48 3a 11 80 	mov    -0x7feec5b8(,%eax,8),%eax
80104566:	39 c2                	cmp    %eax,%edx
80104568:	75 3d                	jne    801045a7 <dequeue+0x7f>
      p = ptable.mlf[priority].first;
8010456a:	8b 45 08             	mov    0x8(%ebp),%eax
8010456d:	05 06 05 00 00       	add    $0x506,%eax
80104572:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
80104579:	89 45 fc             	mov    %eax,-0x4(%ebp)
      ptable.mlf[priority].first = 0;
8010457c:	8b 45 08             	mov    0x8(%ebp),%eax
8010457f:	05 06 05 00 00       	add    $0x506,%eax
80104584:	c7 04 c5 44 3a 11 80 	movl   $0x0,-0x7feec5bc(,%eax,8)
8010458b:	00 00 00 00 
      ptable.mlf[priority].last = 0;
8010458f:	8b 45 08             	mov    0x8(%ebp),%eax
80104592:	05 06 05 00 00       	add    $0x506,%eax
80104597:	c7 04 c5 48 3a 11 80 	movl   $0x0,-0x7feec5b8(,%eax,8)
8010459e:	00 00 00 00 
      return p;
801045a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801045a5:	eb 3f                	jmp    801045e6 <dequeue+0xbe>
    } else {
      p = ptable.mlf[priority].first;
801045a7:	8b 45 08             	mov    0x8(%ebp),%eax
801045aa:	05 06 05 00 00       	add    $0x506,%eax
801045af:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801045b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
      ptable.mlf[priority].first = ptable.mlf[priority].first->next;
801045b9:	8b 45 08             	mov    0x8(%ebp),%eax
801045bc:	05 06 05 00 00       	add    $0x506,%eax
801045c1:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801045c8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801045ce:	8b 55 08             	mov    0x8(%ebp),%edx
801045d1:	81 c2 06 05 00 00    	add    $0x506,%edx
801045d7:	89 04 d5 44 3a 11 80 	mov    %eax,-0x7feec5bc(,%edx,8)
      return p;
801045de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801045e1:	eb 03                	jmp    801045e6 <dequeue+0xbe>
    }
  }
  return p;;
801045e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801045e6:	c9                   	leave  
801045e7:	c3                   	ret    

801045e8 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045e8:	55                   	push   %ebp
801045e9:	89 e5                	mov    %esp,%ebp
801045eb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801045ee:	e8 90 fd ff ff       	call   80104383 <allocproc>
801045f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801045f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f9:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
801045fe:	e8 b7 3e 00 00       	call   801084ba <setupkvm>
80104603:	89 c2                	mov    %eax,%edx
80104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104608:	89 50 04             	mov    %edx,0x4(%eax)
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	8b 40 04             	mov    0x4(%eax),%eax
80104611:	85 c0                	test   %eax,%eax
80104613:	75 0d                	jne    80104622 <userinit+0x3a>
    panic("userinit: out of memory?");
80104615:	83 ec 0c             	sub    $0xc,%esp
80104618:	68 9c 8f 10 80       	push   $0x80108f9c
8010461d:	e8 3a bf ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104622:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462a:	8b 40 04             	mov    0x4(%eax),%eax
8010462d:	83 ec 04             	sub    $0x4,%esp
80104630:	52                   	push   %edx
80104631:	68 00 c5 10 80       	push   $0x8010c500
80104636:	50                   	push   %eax
80104637:	e8 d5 40 00 00       	call   80108711 <inituvm>
8010463c:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464b:	8b 40 18             	mov    0x18(%eax),%eax
8010464e:	83 ec 04             	sub    $0x4,%esp
80104651:	6a 4c                	push   $0x4c
80104653:	6a 00                	push   $0x0
80104655:	50                   	push   %eax
80104656:	e8 c5 0f 00 00       	call   80105620 <memset>
8010465b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104661:	8b 40 18             	mov    0x18(%eax),%eax
80104664:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010466a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466d:	8b 40 18             	mov    0x18(%eax),%eax
80104670:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104679:	8b 40 18             	mov    0x18(%eax),%eax
8010467c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010467f:	8b 52 18             	mov    0x18(%edx),%edx
80104682:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104686:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010468a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468d:	8b 40 18             	mov    0x18(%eax),%eax
80104690:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104693:	8b 52 18             	mov    0x18(%edx),%edx
80104696:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010469a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a1:	8b 40 18             	mov    0x18(%eax),%eax
801046a4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ae:	8b 40 18             	mov    0x18(%eax),%eax
801046b1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bb:	8b 40 18             	mov    0x18(%eax),%eax
801046be:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	83 c0 6c             	add    $0x6c,%eax
801046cb:	83 ec 04             	sub    $0x4,%esp
801046ce:	6a 10                	push   $0x10
801046d0:	68 b5 8f 10 80       	push   $0x80108fb5
801046d5:	50                   	push   %eax
801046d6:	e8 4a 11 00 00       	call   80105825 <safestrcpy>
801046db:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	68 be 8f 10 80       	push   $0x80108fbe
801046e6:	e8 a2 dd ff ff       	call   8010248d <namei>
801046eb:	83 c4 10             	add    $0x10,%esp
801046ee:	89 c2                	mov    %eax,%edx
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f3:	89 50 68             	mov    %edx,0x68(%eax)
  p->quantum = 0;
801046f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f9:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  p->state = RUNNABLE;
80104700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104703:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p,p->priority);
8010470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104713:	83 ec 08             	sub    $0x8,%esp
80104716:	50                   	push   %eax
80104717:	ff 75 f4             	pushl  -0xc(%ebp)
8010471a:	e8 a2 fd ff ff       	call   801044c1 <enqueue>
8010471f:	83 c4 10             	add    $0x10,%esp
}
80104722:	c9                   	leave  
80104723:	c3                   	ret    

80104724 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010472a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104730:	8b 00                	mov    (%eax),%eax
80104732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104735:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104739:	7e 31                	jle    8010476c <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010473b:	8b 55 08             	mov    0x8(%ebp),%edx
8010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104741:	01 c2                	add    %eax,%edx
80104743:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104749:	8b 40 04             	mov    0x4(%eax),%eax
8010474c:	83 ec 04             	sub    $0x4,%esp
8010474f:	52                   	push   %edx
80104750:	ff 75 f4             	pushl  -0xc(%ebp)
80104753:	50                   	push   %eax
80104754:	e8 04 41 00 00       	call   8010885d <allocuvm>
80104759:	83 c4 10             	add    $0x10,%esp
8010475c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010475f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104763:	75 3e                	jne    801047a3 <growproc+0x7f>
      return -1;
80104765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476a:	eb 59                	jmp    801047c5 <growproc+0xa1>
  } else if(n < 0){
8010476c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104770:	79 31                	jns    801047a3 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104772:	8b 55 08             	mov    0x8(%ebp),%edx
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	01 c2                	add    %eax,%edx
8010477a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104780:	8b 40 04             	mov    0x4(%eax),%eax
80104783:	83 ec 04             	sub    $0x4,%esp
80104786:	52                   	push   %edx
80104787:	ff 75 f4             	pushl  -0xc(%ebp)
8010478a:	50                   	push   %eax
8010478b:	e8 96 41 00 00       	call   80108926 <deallocuvm>
80104790:	83 c4 10             	add    $0x10,%esp
80104793:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010479a:	75 07                	jne    801047a3 <growproc+0x7f>
      return -1;
8010479c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047a1:	eb 22                	jmp    801047c5 <growproc+0xa1>
  }
  proc->sz = sz;
801047a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ac:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	50                   	push   %eax
801047b8:	e8 e2 3d 00 00       	call   8010859f <switchuvm>
801047bd:	83 c4 10             	add    $0x10,%esp
  return 0;
801047c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047c5:	c9                   	leave  
801047c6:	c3                   	ret    

801047c7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047c7:	55                   	push   %ebp
801047c8:	89 e5                	mov    %esp,%ebp
801047ca:	57                   	push   %edi
801047cb:	56                   	push   %esi
801047cc:	53                   	push   %ebx
801047cd:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801047d0:	e8 ae fb ff ff       	call   80104383 <allocproc>
801047d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801047d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047dc:	75 0a                	jne    801047e8 <fork+0x21>
    return -1;
801047de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047e3:	e9 ee 01 00 00       	jmp    801049d6 <fork+0x20f>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801047e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ee:	8b 10                	mov    (%eax),%edx
801047f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f6:	8b 40 04             	mov    0x4(%eax),%eax
801047f9:	83 ec 08             	sub    $0x8,%esp
801047fc:	52                   	push   %edx
801047fd:	50                   	push   %eax
801047fe:	e8 bf 42 00 00       	call   80108ac2 <copyuvm>
80104803:	83 c4 10             	add    $0x10,%esp
80104806:	89 c2                	mov    %eax,%edx
80104808:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480b:	89 50 04             	mov    %edx,0x4(%eax)
8010480e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104811:	8b 40 04             	mov    0x4(%eax),%eax
80104814:	85 c0                	test   %eax,%eax
80104816:	75 30                	jne    80104848 <fork+0x81>
    kfree(np->kstack);
80104818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481b:	8b 40 08             	mov    0x8(%eax),%eax
8010481e:	83 ec 0c             	sub    $0xc,%esp
80104821:	50                   	push   %eax
80104822:	e8 be e2 ff ff       	call   80102ae5 <kfree>
80104827:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010482a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104834:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104837:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010483e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104843:	e9 8e 01 00 00       	jmp    801049d6 <fork+0x20f>
  }
  np->sz = proc->sz;
80104848:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484e:	8b 10                	mov    (%eax),%edx
80104850:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104853:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104855:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010485c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104862:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104865:	8b 50 18             	mov    0x18(%eax),%edx
80104868:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486e:	8b 40 18             	mov    0x18(%eax),%eax
80104871:	89 c3                	mov    %eax,%ebx
80104873:	b8 13 00 00 00       	mov    $0x13,%eax
80104878:	89 d7                	mov    %edx,%edi
8010487a:	89 de                	mov    %ebx,%esi
8010487c:	89 c1                	mov    %eax,%ecx
8010487e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104880:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104883:	8b 40 18             	mov    0x18(%eax),%eax
80104886:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010488d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104894:	eb 43                	jmp    801048d9 <fork+0x112>
    if(proc->ofile[i])
80104896:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010489f:	83 c2 08             	add    $0x8,%edx
801048a2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048a6:	85 c0                	test   %eax,%eax
801048a8:	74 2b                	je     801048d5 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801048aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048b3:	83 c2 08             	add    $0x8,%edx
801048b6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	50                   	push   %eax
801048be:	e8 f4 c6 ff ff       	call   80100fb7 <filedup>
801048c3:	83 c4 10             	add    $0x10,%esp
801048c6:	89 c1                	mov    %eax,%ecx
801048c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048ce:	83 c2 08             	add    $0x8,%edx
801048d1:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801048d5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048d9:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048dd:	7e b7                	jle    80104896 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801048df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e5:	8b 40 68             	mov    0x68(%eax),%eax
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	50                   	push   %eax
801048ec:	e8 9f cf ff ff       	call   80101890 <idup>
801048f1:	83 c4 10             	add    $0x10,%esp
801048f4:	89 c2                	mov    %eax,%edx
801048f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f9:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801048fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104902:	8d 50 6c             	lea    0x6c(%eax),%edx
80104905:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104908:	83 c0 6c             	add    $0x6c,%eax
8010490b:	83 ec 04             	sub    $0x4,%esp
8010490e:	6a 10                	push   $0x10
80104910:	52                   	push   %edx
80104911:	50                   	push   %eax
80104912:	e8 0e 0f 00 00       	call   80105825 <safestrcpy>
80104917:	83 c4 10             	add    $0x10,%esp
 
  //inherits all the semaphores.
  for(i = 0; i < proc->squantity; i++){
8010491a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104921:	eb 3f                	jmp    80104962 <fork+0x19b>
    np->sem[i] = proc->sem[i];
80104923:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010492c:	83 c2 20             	add    $0x20,%edx
8010492f:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80104933:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104936:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104939:	83 c1 20             	add    $0x20,%ecx
8010493c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
    semget(proc->sem[i],0);
80104940:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104946:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104949:	83 c2 20             	add    $0x20,%edx
8010494c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104950:	83 ec 08             	sub    $0x8,%esp
80104953:	6a 00                	push   $0x0
80104955:	50                   	push   %eax
80104956:	e8 73 08 00 00       	call   801051ce <semget>
8010495b:	83 c4 10             	add    $0x10,%esp
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  //inherits all the semaphores.
  for(i = 0; i < proc->squantity; i++){
8010495e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104962:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104968:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
8010496e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80104971:	7f b0                	jg     80104923 <fork+0x15c>
    np->sem[i] = proc->sem[i];
    semget(proc->sem[i],0);
  }
  np->squantity = proc->squantity;
80104973:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104979:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
8010497f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104982:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)

  pid = np->pid;
80104988:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010498b:	8b 40 10             	mov    0x10(%eax),%eax
8010498e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104991:	83 ec 0c             	sub    $0xc,%esp
80104994:	68 40 3a 11 80       	push   $0x80113a40
80104999:	e8 26 0a 00 00       	call   801053c4 <acquire>
8010499e:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(np,np->priority);
801049ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ae:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801049b4:	83 ec 08             	sub    $0x8,%esp
801049b7:	50                   	push   %eax
801049b8:	ff 75 e0             	pushl  -0x20(%ebp)
801049bb:	e8 01 fb ff ff       	call   801044c1 <enqueue>
801049c0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801049c3:	83 ec 0c             	sub    $0xc,%esp
801049c6:	68 40 3a 11 80       	push   $0x80113a40
801049cb:	e8 5a 0a 00 00       	call   8010542a <release>
801049d0:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801049d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5f                   	pop    %edi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    

801049de <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049de:	55                   	push   %ebp
801049df:	89 e5                	mov    %esp,%ebp
801049e1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049e4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049eb:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049f0:	39 c2                	cmp    %eax,%edx
801049f2:	75 0d                	jne    80104a01 <exit+0x23>
    panic("init exiting");
801049f4:	83 ec 0c             	sub    $0xc,%esp
801049f7:	68 c0 8f 10 80       	push   $0x80108fc0
801049fc:	e8 5b bb ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a08:	eb 48                	jmp    80104a52 <exit+0x74>
    if(proc->ofile[fd]){
80104a0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a13:	83 c2 08             	add    $0x8,%edx
80104a16:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a1a:	85 c0                	test   %eax,%eax
80104a1c:	74 30                	je     80104a4e <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a27:	83 c2 08             	add    $0x8,%edx
80104a2a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a2e:	83 ec 0c             	sub    $0xc,%esp
80104a31:	50                   	push   %eax
80104a32:	e8 d1 c5 ff ff       	call   80101008 <fileclose>
80104a37:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a40:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a43:	83 c2 08             	add    $0x8,%edx
80104a46:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a4d:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a4e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a52:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a56:	7e b2                	jle    80104a0a <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a58:	e8 05 ea ff ff       	call   80103462 <begin_op>
  iput(proc->cwd);
80104a5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a63:	8b 40 68             	mov    0x68(%eax),%eax
80104a66:	83 ec 0c             	sub    $0xc,%esp
80104a69:	50                   	push   %eax
80104a6a:	e8 23 d0 ff ff       	call   80101a92 <iput>
80104a6f:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a72:	e8 79 ea ff ff       	call   801034f0 <end_op>
  proc->cwd = 0;
80104a77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  int i;
  
  //release all the semaphores.
  for(i = 0; i < proc->squantity; i++){   
80104a84:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104a8b:	eb 20                	jmp    80104aad <exit+0xcf>
    semfree(proc->sem[i]);
80104a8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104a96:	83 c2 20             	add    $0x20,%edx
80104a99:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a9d:	83 ec 0c             	sub    $0xc,%esp
80104aa0:	50                   	push   %eax
80104aa1:	e8 d6 07 00 00       	call   8010527c <semfree>
80104aa6:	83 c4 10             	add    $0x10,%esp
  end_op();
  proc->cwd = 0;
  int i;
  
  //release all the semaphores.
  for(i = 0; i < proc->squantity; i++){   
80104aa9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104aad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab3:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80104ab9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104abc:	7f cf                	jg     80104a8d <exit+0xaf>
    semfree(proc->sem[i]);
  }
  proc->squantity = 0;
80104abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac4:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
80104acb:	00 00 00 

  acquire(&ptable.lock);
80104ace:	83 ec 0c             	sub    $0xc,%esp
80104ad1:	68 40 3a 11 80       	push   $0x80113a40
80104ad6:	e8 e9 08 00 00       	call   801053c4 <acquire>
80104adb:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104ade:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae4:	8b 40 14             	mov    0x14(%eax),%eax
80104ae7:	83 ec 0c             	sub    $0xc,%esp
80104aea:	50                   	push   %eax
80104aeb:	e8 8b 04 00 00       	call   80104f7b <wakeup1>
80104af0:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104af3:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104afa:	eb 3f                	jmp    80104b3b <exit+0x15d>
    if(p->parent == proc){
80104afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aff:	8b 50 14             	mov    0x14(%eax),%edx
80104b02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b08:	39 c2                	cmp    %eax,%edx
80104b0a:	75 28                	jne    80104b34 <exit+0x156>
      p->parent = initproc;
80104b0c:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b15:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b1e:	83 f8 05             	cmp    $0x5,%eax
80104b21:	75 11                	jne    80104b34 <exit+0x156>
        wakeup1(initproc);
80104b23:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	50                   	push   %eax
80104b2c:	e8 4a 04 00 00       	call   80104f7b <wakeup1>
80104b31:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b34:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104b3b:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
80104b42:	72 b8                	jb     80104afc <exit+0x11e>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104b44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b51:	e8 09 02 00 00       	call   80104d5f <sched>
  panic("zombie exit");
80104b56:	83 ec 0c             	sub    $0xc,%esp
80104b59:	68 cd 8f 10 80       	push   $0x80108fcd
80104b5e:	e8 f9 b9 ff ff       	call   8010055c <panic>

80104b63 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b63:	55                   	push   %ebp
80104b64:	89 e5                	mov    %esp,%ebp
80104b66:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b69:	83 ec 0c             	sub    $0xc,%esp
80104b6c:	68 40 3a 11 80       	push   $0x80113a40
80104b71:	e8 4e 08 00 00       	call   801053c4 <acquire>
80104b76:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b80:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104b87:	e9 a9 00 00 00       	jmp    80104c35 <wait+0xd2>
      if(p->parent != proc)
80104b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8f:	8b 50 14             	mov    0x14(%eax),%edx
80104b92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b98:	39 c2                	cmp    %eax,%edx
80104b9a:	74 05                	je     80104ba1 <wait+0x3e>
        continue;
80104b9c:	e9 8d 00 00 00       	jmp    80104c2e <wait+0xcb>
      havekids = 1;
80104ba1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bab:	8b 40 0c             	mov    0xc(%eax),%eax
80104bae:	83 f8 05             	cmp    $0x5,%eax
80104bb1:	75 7b                	jne    80104c2e <wait+0xcb>
        // Found one.
        pid = p->pid;
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	8b 40 10             	mov    0x10(%eax),%eax
80104bb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbf:	8b 40 08             	mov    0x8(%eax),%eax
80104bc2:	83 ec 0c             	sub    $0xc,%esp
80104bc5:	50                   	push   %eax
80104bc6:	e8 1a df ff ff       	call   80102ae5 <kfree>
80104bcb:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdb:	8b 40 04             	mov    0x4(%eax),%eax
80104bde:	83 ec 0c             	sub    $0xc,%esp
80104be1:	50                   	push   %eax
80104be2:	e8 fc 3d 00 00       	call   801089e3 <freevm>
80104be7:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c01:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c12:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c19:	83 ec 0c             	sub    $0xc,%esp
80104c1c:	68 40 3a 11 80       	push   $0x80113a40
80104c21:	e8 04 08 00 00       	call   8010542a <release>
80104c26:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c2c:	eb 5a                	jmp    80104c88 <wait+0x125>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c2e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104c35:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
80104c3c:	0f 82 4a ff ff ff    	jb     80104b8c <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c46:	74 0d                	je     80104c55 <wait+0xf2>
80104c48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4e:	8b 40 24             	mov    0x24(%eax),%eax
80104c51:	85 c0                	test   %eax,%eax
80104c53:	74 17                	je     80104c6c <wait+0x109>
      release(&ptable.lock);
80104c55:	83 ec 0c             	sub    $0xc,%esp
80104c58:	68 40 3a 11 80       	push   $0x80113a40
80104c5d:	e8 c8 07 00 00       	call   8010542a <release>
80104c62:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c6a:	eb 1c                	jmp    80104c88 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c72:	83 ec 08             	sub    $0x8,%esp
80104c75:	68 40 3a 11 80       	push   $0x80113a40
80104c7a:	50                   	push   %eax
80104c7b:	e8 50 02 00 00       	call   80104ed0 <sleep>
80104c80:	83 c4 10             	add    $0x10,%esp
  }
80104c83:	e9 f1 fe ff ff       	jmp    80104b79 <wait+0x16>
}
80104c88:	c9                   	leave  
80104c89:	c3                   	ret    

80104c8a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c8a:	55                   	push   %ebp
80104c8b:	89 e5                	mov    %esp,%ebp
80104c8d:	83 ec 18             	sub    $0x18,%esp

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c90:	e8 cb f6 ff ff       	call   80104360 <sti>

    int level = 0;
80104c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    // Loop over process queue looking for process to run.
    acquire(&ptable.lock);
80104c9c:	83 ec 0c             	sub    $0xc,%esp
80104c9f:	68 40 3a 11 80       	push   $0x80113a40
80104ca4:	e8 1b 07 00 00       	call   801053c4 <acquire>
80104ca9:	83 c4 10             	add    $0x10,%esp
      while (level<MLF_SIZE){
80104cac:	e9 8f 00 00 00       	jmp    80104d40 <scheduler+0xb6>
        if (!is_empty(level)){ 
80104cb1:	83 ec 0c             	sub    $0xc,%esp
80104cb4:	ff 75 f4             	pushl  -0xc(%ebp)
80104cb7:	e8 e9 f7 ff ff       	call   801044a5 <is_empty>
80104cbc:	83 c4 10             	add    $0x10,%esp
80104cbf:	85 c0                	test   %eax,%eax
80104cc1:	75 79                	jne    80104d3c <scheduler+0xb2>
          // Switch to chosen process.  It is the process's job
          // to release ptable.lock and then reacquire it
          // before jumping back to us.
          proc = dequeue(level);
80104cc3:	83 ec 0c             	sub    $0xc,%esp
80104cc6:	ff 75 f4             	pushl  -0xc(%ebp)
80104cc9:	e8 5a f8 ff ff       	call   80104528 <dequeue>
80104cce:	83 c4 10             	add    $0x10,%esp
80104cd1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
          switchuvm(proc);
80104cd7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdd:	83 ec 0c             	sub    $0xc,%esp
80104ce0:	50                   	push   %eax
80104ce1:	e8 b9 38 00 00       	call   8010859f <switchuvm>
80104ce6:	83 c4 10             	add    $0x10,%esp
          proc->quantum = 0;
80104ce9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cef:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
          proc->state = RUNNING;
80104cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfc:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
          swtch(&cpu->scheduler, proc->context);
80104d03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d09:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d13:	83 c2 04             	add    $0x4,%edx
80104d16:	83 ec 08             	sub    $0x8,%esp
80104d19:	50                   	push   %eax
80104d1a:	52                   	push   %edx
80104d1b:	e8 76 0b 00 00       	call   80105896 <swtch>
80104d20:	83 c4 10             	add    $0x10,%esp
          switchkvm();          
80104d23:	e8 5b 38 00 00       	call   80108583 <switchkvm>
          // Process is done running for now.
          // It should have changed its p->state before coming back.            
          proc = 0;          
80104d28:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d2f:	00 00 00 00 
          level=0;
80104d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d3a:	eb 04                	jmp    80104d40 <scheduler+0xb6>
        } else {
          level++;
80104d3c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    sti();

    int level = 0;
    // Loop over process queue looking for process to run.
    acquire(&ptable.lock);
      while (level<MLF_SIZE){
80104d40:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104d44:	0f 8e 67 ff ff ff    	jle    80104cb1 <scheduler+0x27>
          level=0;
        } else {
          level++;
        }
      }
    release(&ptable.lock);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	68 40 3a 11 80       	push   $0x80113a40
80104d52:	e8 d3 06 00 00       	call   8010542a <release>
80104d57:	83 c4 10             	add    $0x10,%esp
  }
80104d5a:	e9 31 ff ff ff       	jmp    80104c90 <scheduler+0x6>

80104d5f <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d5f:	55                   	push   %ebp
80104d60:	89 e5                	mov    %esp,%ebp
80104d62:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	68 40 3a 11 80       	push   $0x80113a40
80104d6d:	e8 82 07 00 00       	call   801054f4 <holding>
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	85 c0                	test   %eax,%eax
80104d77:	75 0d                	jne    80104d86 <sched+0x27>
    panic("sched ptable.lock");
80104d79:	83 ec 0c             	sub    $0xc,%esp
80104d7c:	68 d9 8f 10 80       	push   $0x80108fd9
80104d81:	e8 d6 b7 ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
80104d86:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d8c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d92:	83 f8 01             	cmp    $0x1,%eax
80104d95:	74 0d                	je     80104da4 <sched+0x45>
    panic("sched locks");
80104d97:	83 ec 0c             	sub    $0xc,%esp
80104d9a:	68 eb 8f 10 80       	push   $0x80108feb
80104d9f:	e8 b8 b7 ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104da4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104daa:	8b 40 0c             	mov    0xc(%eax),%eax
80104dad:	83 f8 04             	cmp    $0x4,%eax
80104db0:	75 0d                	jne    80104dbf <sched+0x60>
    panic("sched running");
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	68 f7 8f 10 80       	push   $0x80108ff7
80104dba:	e8 9d b7 ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104dbf:	e8 8c f5 ff ff       	call   80104350 <readeflags>
80104dc4:	25 00 02 00 00       	and    $0x200,%eax
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	74 0d                	je     80104dda <sched+0x7b>
    panic("sched interruptible");
80104dcd:	83 ec 0c             	sub    $0xc,%esp
80104dd0:	68 05 90 10 80       	push   $0x80109005
80104dd5:	e8 82 b7 ff ff       	call   8010055c <panic>
  intena = cpu->intena;
80104dda:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104de0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104de9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104def:	8b 40 04             	mov    0x4(%eax),%eax
80104df2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104df9:	83 c2 1c             	add    $0x1c,%edx
80104dfc:	83 ec 08             	sub    $0x8,%esp
80104dff:	50                   	push   %eax
80104e00:	52                   	push   %edx
80104e01:	e8 90 0a 00 00       	call   80105896 <swtch>
80104e06:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e09:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e12:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e18:	c9                   	leave  
80104e19:	c3                   	ret    

80104e1a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e1a:	55                   	push   %ebp
80104e1b:	89 e5                	mov    %esp,%ebp
80104e1d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	68 40 3a 11 80       	push   $0x80113a40
80104e28:	e8 97 05 00 00       	call   801053c4 <acquire>
80104e2d:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e36:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(proc->priority < MLF_SIZE-1){
80104e3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e43:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104e49:	83 f8 02             	cmp    $0x2,%eax
80104e4c:	7f 1c                	jg     80104e6a <yield+0x50>
    proc->priority = proc->priority + 1;
80104e4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e54:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e5b:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
80104e61:	83 c2 01             	add    $0x1,%edx
80104e64:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  enqueue(proc,proc->priority);
80104e6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e70:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7c:	83 ec 08             	sub    $0x8,%esp
80104e7f:	52                   	push   %edx
80104e80:	50                   	push   %eax
80104e81:	e8 3b f6 ff ff       	call   801044c1 <enqueue>
80104e86:	83 c4 10             	add    $0x10,%esp
  sched();
80104e89:	e8 d1 fe ff ff       	call   80104d5f <sched>
  release(&ptable.lock);
80104e8e:	83 ec 0c             	sub    $0xc,%esp
80104e91:	68 40 3a 11 80       	push   $0x80113a40
80104e96:	e8 8f 05 00 00       	call   8010542a <release>
80104e9b:	83 c4 10             	add    $0x10,%esp
}
80104e9e:	c9                   	leave  
80104e9f:	c3                   	ret    

80104ea0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ea6:	83 ec 0c             	sub    $0xc,%esp
80104ea9:	68 40 3a 11 80       	push   $0x80113a40
80104eae:	e8 77 05 00 00       	call   8010542a <release>
80104eb3:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104eb6:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	74 0f                	je     80104ece <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104ebf:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104ec6:	00 00 00 
    initlog();
80104ec9:	e8 73 e3 ff ff       	call   80103241 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104ece:	c9                   	leave  
80104ecf:	c3                   	ret    

80104ed0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104ed6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104edc:	85 c0                	test   %eax,%eax
80104ede:	75 0d                	jne    80104eed <sleep+0x1d>
    panic("sleep");
80104ee0:	83 ec 0c             	sub    $0xc,%esp
80104ee3:	68 19 90 10 80       	push   $0x80109019
80104ee8:	e8 6f b6 ff ff       	call   8010055c <panic>

  if(lk == 0)
80104eed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ef1:	75 0d                	jne    80104f00 <sleep+0x30>
    panic("sleep without lk");
80104ef3:	83 ec 0c             	sub    $0xc,%esp
80104ef6:	68 1f 90 10 80       	push   $0x8010901f
80104efb:	e8 5c b6 ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104f00:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104f07:	74 1e                	je     80104f27 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 40 3a 11 80       	push   $0x80113a40
80104f11:	e8 ae 04 00 00       	call   801053c4 <acquire>
80104f16:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	ff 75 0c             	pushl  0xc(%ebp)
80104f1f:	e8 06 05 00 00       	call   8010542a <release>
80104f24:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104f27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f30:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104f33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f39:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f40:	e8 1a fe ff ff       	call   80104d5f <sched>

  // Tidy up.
  proc->chan = 0;
80104f45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f4b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f52:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104f59:	74 1e                	je     80104f79 <sleep+0xa9>
    release(&ptable.lock);
80104f5b:	83 ec 0c             	sub    $0xc,%esp
80104f5e:	68 40 3a 11 80       	push   $0x80113a40
80104f63:	e8 c2 04 00 00       	call   8010542a <release>
80104f68:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f6b:	83 ec 0c             	sub    $0xc,%esp
80104f6e:	ff 75 0c             	pushl  0xc(%ebp)
80104f71:	e8 4e 04 00 00       	call   801053c4 <acquire>
80104f76:	83 c4 10             	add    $0x10,%esp
  }
}
80104f79:	c9                   	leave  
80104f7a:	c3                   	ret    

80104f7b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f7b:	55                   	push   %ebp
80104f7c:	89 e5                	mov    %esp,%ebp
80104f7e:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f81:	c7 45 fc 74 3a 11 80 	movl   $0x80113a74,-0x4(%ebp)
80104f88:	eb 5e                	jmp    80104fe8 <wakeup1+0x6d>
    if(p->state == SLEEPING && p->chan == chan){
80104f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f8d:	8b 40 0c             	mov    0xc(%eax),%eax
80104f90:	83 f8 02             	cmp    $0x2,%eax
80104f93:	75 4c                	jne    80104fe1 <wakeup1+0x66>
80104f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f98:	8b 40 20             	mov    0x20(%eax),%eax
80104f9b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f9e:	75 41                	jne    80104fe1 <wakeup1+0x66>
      p->state = RUNNABLE;
80104fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fa3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      if(p->priority > 0){
80104faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fad:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fb3:	85 c0                	test   %eax,%eax
80104fb5:	7e 15                	jle    80104fcc <wakeup1+0x51>
        p->priority = p->priority - 1;
80104fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fba:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fc0:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fc6:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      } 
      enqueue(p,p->priority);
80104fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fcf:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fd5:	50                   	push   %eax
80104fd6:	ff 75 fc             	pushl  -0x4(%ebp)
80104fd9:	e8 e3 f4 ff ff       	call   801044c1 <enqueue>
80104fde:	83 c4 08             	add    $0x8,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fe1:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80104fe8:	81 7d fc 74 62 11 80 	cmpl   $0x80116274,-0x4(%ebp)
80104fef:	72 99                	jb     80104f8a <wakeup1+0xf>
        p->priority = p->priority - 1;
      } 
      enqueue(p,p->priority);
    }
  }    
}
80104ff1:	c9                   	leave  
80104ff2:	c3                   	ret    

80104ff3 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ff3:	55                   	push   %ebp
80104ff4:	89 e5                	mov    %esp,%ebp
80104ff6:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	68 40 3a 11 80       	push   $0x80113a40
80105001:	e8 be 03 00 00       	call   801053c4 <acquire>
80105006:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	ff 75 08             	pushl  0x8(%ebp)
8010500f:	e8 67 ff ff ff       	call   80104f7b <wakeup1>
80105014:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105017:	83 ec 0c             	sub    $0xc,%esp
8010501a:	68 40 3a 11 80       	push   $0x80113a40
8010501f:	e8 06 04 00 00       	call   8010542a <release>
80105024:	83 c4 10             	add    $0x10,%esp
}
80105027:	c9                   	leave  
80105028:	c3                   	ret    

80105029 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105029:	55                   	push   %ebp
8010502a:	89 e5                	mov    %esp,%ebp
8010502c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010502f:	83 ec 0c             	sub    $0xc,%esp
80105032:	68 40 3a 11 80       	push   $0x80113a40
80105037:	e8 88 03 00 00       	call   801053c4 <acquire>
8010503c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010503f:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80105046:	eb 60                	jmp    801050a8 <kill+0x7f>
    if(p->pid == pid){
80105048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504b:	8b 40 10             	mov    0x10(%eax),%eax
8010504e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105051:	75 4e                	jne    801050a1 <kill+0x78>
      p->killed = 1;
80105053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105056:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)

      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
8010505d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105060:	8b 40 0c             	mov    0xc(%eax),%eax
80105063:	83 f8 02             	cmp    $0x2,%eax
80105066:	75 22                	jne    8010508a <kill+0x61>
        p->state = RUNNABLE;
80105068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        enqueue(p,p->priority);
80105072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105075:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010507b:	83 ec 08             	sub    $0x8,%esp
8010507e:	50                   	push   %eax
8010507f:	ff 75 f4             	pushl  -0xc(%ebp)
80105082:	e8 3a f4 ff ff       	call   801044c1 <enqueue>
80105087:	83 c4 10             	add    $0x10,%esp
      }
      release(&ptable.lock);
8010508a:	83 ec 0c             	sub    $0xc,%esp
8010508d:	68 40 3a 11 80       	push   $0x80113a40
80105092:	e8 93 03 00 00       	call   8010542a <release>
80105097:	83 c4 10             	add    $0x10,%esp
      return 0;
8010509a:	b8 00 00 00 00       	mov    $0x0,%eax
8010509f:	eb 25                	jmp    801050c6 <kill+0x9d>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050a1:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801050a8:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
801050af:	72 97                	jb     80105048 <kill+0x1f>
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	68 40 3a 11 80       	push   $0x80113a40
801050b9:	e8 6c 03 00 00       	call   8010542a <release>
801050be:	83 c4 10             	add    $0x10,%esp
  return -1;
801050c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c6:	c9                   	leave  
801050c7:	c3                   	ret    

801050c8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801050c8:	55                   	push   %ebp
801050c9:	89 e5                	mov    %esp,%ebp
801050cb:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050ce:	c7 45 f0 74 3a 11 80 	movl   $0x80113a74,-0x10(%ebp)
801050d5:	e9 e5 00 00 00       	jmp    801051bf <procdump+0xf7>
    if(p->state == UNUSED)
801050da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050dd:	8b 40 0c             	mov    0xc(%eax),%eax
801050e0:	85 c0                	test   %eax,%eax
801050e2:	75 05                	jne    801050e9 <procdump+0x21>
      continue;
801050e4:	e9 cf 00 00 00       	jmp    801051b8 <procdump+0xf0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ec:	8b 40 0c             	mov    0xc(%eax),%eax
801050ef:	83 f8 05             	cmp    $0x5,%eax
801050f2:	77 23                	ja     80105117 <procdump+0x4f>
801050f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f7:	8b 40 0c             	mov    0xc(%eax),%eax
801050fa:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105101:	85 c0                	test   %eax,%eax
80105103:	74 12                	je     80105117 <procdump+0x4f>
      state = states[p->state];
80105105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105108:	8b 40 0c             	mov    0xc(%eax),%eax
8010510b:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105112:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105115:	eb 07                	jmp    8010511e <procdump+0x56>
    else
      state = "???";
80105117:	c7 45 ec 30 90 10 80 	movl   $0x80109030,-0x14(%ebp)
    cprintf("%d %s %s priority: %d ", p->pid, state, p->name, p->priority);
8010511e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105121:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105127:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512a:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010512d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105130:	8b 40 10             	mov    0x10(%eax),%eax
80105133:	83 ec 0c             	sub    $0xc,%esp
80105136:	52                   	push   %edx
80105137:	51                   	push   %ecx
80105138:	ff 75 ec             	pushl  -0x14(%ebp)
8010513b:	50                   	push   %eax
8010513c:	68 34 90 10 80       	push   $0x80109034
80105141:	e8 79 b2 ff ff       	call   801003bf <cprintf>
80105146:	83 c4 20             	add    $0x20,%esp
    if(p->state == SLEEPING){
80105149:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010514c:	8b 40 0c             	mov    0xc(%eax),%eax
8010514f:	83 f8 02             	cmp    $0x2,%eax
80105152:	75 54                	jne    801051a8 <procdump+0xe0>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105154:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105157:	8b 40 1c             	mov    0x1c(%eax),%eax
8010515a:	8b 40 0c             	mov    0xc(%eax),%eax
8010515d:	83 c0 08             	add    $0x8,%eax
80105160:	89 c2                	mov    %eax,%edx
80105162:	83 ec 08             	sub    $0x8,%esp
80105165:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105168:	50                   	push   %eax
80105169:	52                   	push   %edx
8010516a:	e8 0c 03 00 00       	call   8010547b <getcallerpcs>
8010516f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105172:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105179:	eb 1c                	jmp    80105197 <procdump+0xcf>
        cprintf(" %p", pc[i]);
8010517b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	68 4b 90 10 80       	push   $0x8010904b
8010518b:	e8 2f b2 ff ff       	call   801003bf <cprintf>
80105190:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s priority: %d ", p->pid, state, p->name, p->priority);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105193:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105197:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010519b:	7f 0b                	jg     801051a8 <procdump+0xe0>
8010519d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801051a4:	85 c0                	test   %eax,%eax
801051a6:	75 d3                	jne    8010517b <procdump+0xb3>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	68 4f 90 10 80       	push   $0x8010904f
801051b0:	e8 0a b2 ff ff       	call   801003bf <cprintf>
801051b5:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051b8:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801051bf:	81 7d f0 74 62 11 80 	cmpl   $0x80116274,-0x10(%ebp)
801051c6:	0f 82 0e ff ff ff    	jb     801050da <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051cc:	c9                   	leave  
801051cd:	c3                   	ret    

801051ce <semget>:
parameters:
if Sem_id == -1, create a new one.
Return: semaphore identifier obtained or created, otherwise return a negative value indicating error. 
-1: Sem_id > 0  the semaphore is not in use.
-3: Sem_id = -1  no more semaphores available in the system*/
int semget(int sem_id, int init_value){
801051ce:	55                   	push   %ebp
801051cf:	89 e5                	mov    %esp,%ebp
801051d1:	83 ec 10             	sub    $0x10,%esp
  if (sem_id == -1){
801051d4:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
801051d8:	75 6f                	jne    80105249 <semget+0x7b>
    if (stable.quantity == MAXSEM){
801051da:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
801051e1:	66 83 f8 14          	cmp    $0x14,%ax
801051e5:	75 0a                	jne    801051f1 <semget+0x23>
      return -3;
801051e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
801051ec:	e9 89 00 00 00       	jmp    8010527a <semget+0xac>
    }
    int i = 0;
801051f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i<MAXSEM){
801051f8:	eb 42                	jmp    8010523c <semget+0x6e>
      if (stable.semaphore[i].refcount == 0){
801051fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051fd:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105204:	85 c0                	test   %eax,%eax
80105206:	75 30                	jne    80105238 <semget+0x6a>
        stable.semaphore[i].value = init_value;
80105208:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010520b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010520e:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
        stable.semaphore[i].refcount = 1;
80105215:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105218:	c7 04 c5 c4 62 11 80 	movl   $0x1,-0x7fee9d3c(,%eax,8)
8010521f:	01 00 00 00 
        stable.quantity++;
80105223:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
8010522a:	83 c0 01             	add    $0x1,%eax
8010522d:	66 a3 94 63 11 80    	mov    %ax,0x80116394
        return i;
80105233:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105236:	eb 42                	jmp    8010527a <semget+0xac>
      } else
        ++i;    
80105238:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  if (sem_id == -1){
    if (stable.quantity == MAXSEM){
      return -3;
    }
    int i = 0;
    while (i<MAXSEM){
8010523c:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
80105240:	7e b8                	jle    801051fa <semget+0x2c>
        stable.quantity++;
        return i;
      } else
        ++i;    
    }
    return -3;
80105242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80105247:	eb 31                	jmp    8010527a <semget+0xac>
  } else {
    if (stable.semaphore[sem_id].refcount == 0)
80105249:	8b 45 08             	mov    0x8(%ebp),%eax
8010524c:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105253:	85 c0                	test   %eax,%eax
80105255:	75 07                	jne    8010525e <semget+0x90>
      return -1;
80105257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525c:	eb 1c                	jmp    8010527a <semget+0xac>
    stable.semaphore[sem_id].refcount++;      
8010525e:	8b 45 08             	mov    0x8(%ebp),%eax
80105261:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105268:	8d 50 01             	lea    0x1(%eax),%edx
8010526b:	8b 45 08             	mov    0x8(%ebp),%eax
8010526e:	89 14 c5 c4 62 11 80 	mov    %edx,-0x7fee9d3c(,%eax,8)
    return 0;
80105275:	b8 00 00 00 00       	mov    $0x0,%eax
  }  
}
8010527a:	c9                   	leave  
8010527b:	c3                   	ret    

8010527c <semfree>:


/*Releases the semaphore.
Return -1 on error (not semaphore obtained by the process). Zero otherwise*/
int semfree(int sem_id){
8010527c:	55                   	push   %ebp
8010527d:	89 e5                	mov    %esp,%ebp
8010527f:	83 ec 08             	sub    $0x8,%esp
  if (stable.semaphore[sem_id].refcount == 0)
80105282:	8b 45 08             	mov    0x8(%ebp),%eax
80105285:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
8010528c:	85 c0                	test   %eax,%eax
8010528e:	75 07                	jne    80105297 <semfree+0x1b>
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105295:	eb 5a                	jmp    801052f1 <semfree+0x75>
  acquire(&stable.lock);
80105297:	83 ec 0c             	sub    $0xc,%esp
8010529a:	68 60 63 11 80       	push   $0x80116360
8010529f:	e8 20 01 00 00       	call   801053c4 <acquire>
801052a4:	83 c4 10             	add    $0x10,%esp
  stable.semaphore[sem_id].refcount--;
801052a7:	8b 45 08             	mov    0x8(%ebp),%eax
801052aa:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
801052b1:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b4:	8b 45 08             	mov    0x8(%ebp),%eax
801052b7:	89 14 c5 c4 62 11 80 	mov    %edx,-0x7fee9d3c(,%eax,8)
  if (stable.semaphore[sem_id].refcount == 0)
801052be:	8b 45 08             	mov    0x8(%ebp),%eax
801052c1:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
801052c8:	85 c0                	test   %eax,%eax
801052ca:	75 10                	jne    801052dc <semfree+0x60>
    stable.quantity--;
801052cc:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
801052d3:	83 e8 01             	sub    $0x1,%eax
801052d6:	66 a3 94 63 11 80    	mov    %ax,0x80116394
  release(&stable.lock);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	68 60 63 11 80       	push   $0x80116360
801052e4:	e8 41 01 00 00       	call   8010542a <release>
801052e9:	83 c4 10             	add    $0x10,%esp
  return 0;
801052ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052f1:	c9                   	leave  
801052f2:	c3                   	ret    

801052f3 <semdown>:

//decrease the unit value of the semaphore
int semdown(int sem_id){
801052f3:	55                   	push   %ebp
801052f4:	89 e5                	mov    %esp,%ebp
  stable.semaphore[sem_id].value--;
801052f6:	8b 45 08             	mov    0x8(%ebp),%eax
801052f9:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80105300:	8d 50 ff             	lea    -0x1(%eax),%edx
80105303:	8b 45 08             	mov    0x8(%ebp),%eax
80105306:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
  return 0;
8010530d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105312:	5d                   	pop    %ebp
80105313:	c3                   	ret    

80105314 <semup>:

//Increase the unit value of the semaphore
int semup(int sem_id){
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	83 ec 08             	sub    $0x8,%esp
  if (stable.semaphore[sem_id].refcount == 0)
8010531a:	8b 45 08             	mov    0x8(%ebp),%eax
8010531d:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105324:	85 c0                	test   %eax,%eax
80105326:	75 07                	jne    8010532f <semup+0x1b>
    return -1;
80105328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532d:	eb 3c                	jmp    8010536b <semup+0x57>
  acquire(&stable.lock);
8010532f:	83 ec 0c             	sub    $0xc,%esp
80105332:	68 60 63 11 80       	push   $0x80116360
80105337:	e8 88 00 00 00       	call   801053c4 <acquire>
8010533c:	83 c4 10             	add    $0x10,%esp
  stable.semaphore[sem_id].value++;
8010533f:	8b 45 08             	mov    0x8(%ebp),%eax
80105342:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80105349:	8d 50 01             	lea    0x1(%eax),%edx
8010534c:	8b 45 08             	mov    0x8(%ebp),%eax
8010534f:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
  release(&stable.lock);
80105356:	83 ec 0c             	sub    $0xc,%esp
80105359:	68 60 63 11 80       	push   $0x80116360
8010535e:	e8 c7 00 00 00       	call   8010542a <release>
80105363:	83 c4 10             	add    $0x10,%esp
  return 0;
80105366:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010536b:	c9                   	leave  
8010536c:	c3                   	ret    

8010536d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010536d:	55                   	push   %ebp
8010536e:	89 e5                	mov    %esp,%ebp
80105370:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105373:	9c                   	pushf  
80105374:	58                   	pop    %eax
80105375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105378:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010537b:	c9                   	leave  
8010537c:	c3                   	ret    

8010537d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010537d:	55                   	push   %ebp
8010537e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105380:	fa                   	cli    
}
80105381:	5d                   	pop    %ebp
80105382:	c3                   	ret    

80105383 <sti>:

static inline void
sti(void)
{
80105383:	55                   	push   %ebp
80105384:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105386:	fb                   	sti    
}
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    

80105389 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105389:	55                   	push   %ebp
8010538a:	89 e5                	mov    %esp,%ebp
8010538c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010538f:	8b 55 08             	mov    0x8(%ebp),%edx
80105392:	8b 45 0c             	mov    0xc(%ebp),%eax
80105395:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105398:	f0 87 02             	lock xchg %eax,(%edx)
8010539b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010539e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    

801053a3 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053a3:	55                   	push   %ebp
801053a4:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801053a6:	8b 45 08             	mov    0x8(%ebp),%eax
801053a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801053ac:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801053af:	8b 45 08             	mov    0x8(%ebp),%eax
801053b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801053b8:	8b 45 08             	mov    0x8(%ebp),%eax
801053bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053c2:	5d                   	pop    %ebp
801053c3:	c3                   	ret    

801053c4 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801053ca:	e8 4f 01 00 00       	call   8010551e <pushcli>
  if(holding(lk))
801053cf:	8b 45 08             	mov    0x8(%ebp),%eax
801053d2:	83 ec 0c             	sub    $0xc,%esp
801053d5:	50                   	push   %eax
801053d6:	e8 19 01 00 00       	call   801054f4 <holding>
801053db:	83 c4 10             	add    $0x10,%esp
801053de:	85 c0                	test   %eax,%eax
801053e0:	74 0d                	je     801053ef <acquire+0x2b>
    panic("acquire");
801053e2:	83 ec 0c             	sub    $0xc,%esp
801053e5:	68 7b 90 10 80       	push   $0x8010907b
801053ea:	e8 6d b1 ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801053ef:	90                   	nop
801053f0:	8b 45 08             	mov    0x8(%ebp),%eax
801053f3:	83 ec 08             	sub    $0x8,%esp
801053f6:	6a 01                	push   $0x1
801053f8:	50                   	push   %eax
801053f9:	e8 8b ff ff ff       	call   80105389 <xchg>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	75 eb                	jne    801053f0 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105405:	8b 45 08             	mov    0x8(%ebp),%eax
80105408:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010540f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105412:	8b 45 08             	mov    0x8(%ebp),%eax
80105415:	83 c0 0c             	add    $0xc,%eax
80105418:	83 ec 08             	sub    $0x8,%esp
8010541b:	50                   	push   %eax
8010541c:	8d 45 08             	lea    0x8(%ebp),%eax
8010541f:	50                   	push   %eax
80105420:	e8 56 00 00 00       	call   8010547b <getcallerpcs>
80105425:	83 c4 10             	add    $0x10,%esp
}
80105428:	c9                   	leave  
80105429:	c3                   	ret    

8010542a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010542a:	55                   	push   %ebp
8010542b:	89 e5                	mov    %esp,%ebp
8010542d:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	ff 75 08             	pushl  0x8(%ebp)
80105436:	e8 b9 00 00 00       	call   801054f4 <holding>
8010543b:	83 c4 10             	add    $0x10,%esp
8010543e:	85 c0                	test   %eax,%eax
80105440:	75 0d                	jne    8010544f <release+0x25>
    panic("release");
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	68 83 90 10 80       	push   $0x80109083
8010544a:	e8 0d b1 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
8010544f:	8b 45 08             	mov    0x8(%ebp),%eax
80105452:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105459:	8b 45 08             	mov    0x8(%ebp),%eax
8010545c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105463:	8b 45 08             	mov    0x8(%ebp),%eax
80105466:	83 ec 08             	sub    $0x8,%esp
80105469:	6a 00                	push   $0x0
8010546b:	50                   	push   %eax
8010546c:	e8 18 ff ff ff       	call   80105389 <xchg>
80105471:	83 c4 10             	add    $0x10,%esp

  popcli();
80105474:	e8 e9 00 00 00       	call   80105562 <popcli>
}
80105479:	c9                   	leave  
8010547a:	c3                   	ret    

8010547b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010547b:	55                   	push   %ebp
8010547c:	89 e5                	mov    %esp,%ebp
8010547e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105481:	8b 45 08             	mov    0x8(%ebp),%eax
80105484:	83 e8 08             	sub    $0x8,%eax
80105487:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010548a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105491:	eb 38                	jmp    801054cb <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105493:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105497:	74 38                	je     801054d1 <getcallerpcs+0x56>
80105499:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801054a0:	76 2f                	jbe    801054d1 <getcallerpcs+0x56>
801054a2:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801054a6:	74 29                	je     801054d1 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801054a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b5:	01 c2                	add    %eax,%edx
801054b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ba:	8b 40 04             	mov    0x4(%eax),%eax
801054bd:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801054bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054c2:	8b 00                	mov    (%eax),%eax
801054c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801054c7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054cb:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054cf:	7e c2                	jle    80105493 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054d1:	eb 19                	jmp    801054ec <getcallerpcs+0x71>
    pcs[i] = 0;
801054d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e0:	01 d0                	add    %edx,%eax
801054e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054e8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054ec:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054f0:	7e e1                	jle    801054d3 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801054f2:	c9                   	leave  
801054f3:	c3                   	ret    

801054f4 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801054f7:	8b 45 08             	mov    0x8(%ebp),%eax
801054fa:	8b 00                	mov    (%eax),%eax
801054fc:	85 c0                	test   %eax,%eax
801054fe:	74 17                	je     80105517 <holding+0x23>
80105500:	8b 45 08             	mov    0x8(%ebp),%eax
80105503:	8b 50 08             	mov    0x8(%eax),%edx
80105506:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010550c:	39 c2                	cmp    %eax,%edx
8010550e:	75 07                	jne    80105517 <holding+0x23>
80105510:	b8 01 00 00 00       	mov    $0x1,%eax
80105515:	eb 05                	jmp    8010551c <holding+0x28>
80105517:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010551c:	5d                   	pop    %ebp
8010551d:	c3                   	ret    

8010551e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010551e:	55                   	push   %ebp
8010551f:	89 e5                	mov    %esp,%ebp
80105521:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105524:	e8 44 fe ff ff       	call   8010536d <readeflags>
80105529:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010552c:	e8 4c fe ff ff       	call   8010537d <cli>
  if(cpu->ncli++ == 0)
80105531:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105538:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010553e:	8d 48 01             	lea    0x1(%eax),%ecx
80105541:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105547:	85 c0                	test   %eax,%eax
80105549:	75 15                	jne    80105560 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010554b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105551:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105554:	81 e2 00 02 00 00    	and    $0x200,%edx
8010555a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105560:	c9                   	leave  
80105561:	c3                   	ret    

80105562 <popcli>:

void
popcli(void)
{
80105562:	55                   	push   %ebp
80105563:	89 e5                	mov    %esp,%ebp
80105565:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105568:	e8 00 fe ff ff       	call   8010536d <readeflags>
8010556d:	25 00 02 00 00       	and    $0x200,%eax
80105572:	85 c0                	test   %eax,%eax
80105574:	74 0d                	je     80105583 <popcli+0x21>
    panic("popcli - interruptible");
80105576:	83 ec 0c             	sub    $0xc,%esp
80105579:	68 8b 90 10 80       	push   $0x8010908b
8010557e:	e8 d9 af ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
80105583:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105589:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010558f:	83 ea 01             	sub    $0x1,%edx
80105592:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105598:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010559e:	85 c0                	test   %eax,%eax
801055a0:	79 0d                	jns    801055af <popcli+0x4d>
    panic("popcli");
801055a2:	83 ec 0c             	sub    $0xc,%esp
801055a5:	68 a2 90 10 80       	push   $0x801090a2
801055aa:	e8 ad af ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
801055af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055b5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055bb:	85 c0                	test   %eax,%eax
801055bd:	75 15                	jne    801055d4 <popcli+0x72>
801055bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055c5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801055cb:	85 c0                	test   %eax,%eax
801055cd:	74 05                	je     801055d4 <popcli+0x72>
    sti();
801055cf:	e8 af fd ff ff       	call   80105383 <sti>
}
801055d4:	c9                   	leave  
801055d5:	c3                   	ret    

801055d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801055d6:	55                   	push   %ebp
801055d7:	89 e5                	mov    %esp,%ebp
801055d9:	57                   	push   %edi
801055da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801055db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055de:	8b 55 10             	mov    0x10(%ebp),%edx
801055e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e4:	89 cb                	mov    %ecx,%ebx
801055e6:	89 df                	mov    %ebx,%edi
801055e8:	89 d1                	mov    %edx,%ecx
801055ea:	fc                   	cld    
801055eb:	f3 aa                	rep stos %al,%es:(%edi)
801055ed:	89 ca                	mov    %ecx,%edx
801055ef:	89 fb                	mov    %edi,%ebx
801055f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801055f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801055f7:	5b                   	pop    %ebx
801055f8:	5f                   	pop    %edi
801055f9:	5d                   	pop    %ebp
801055fa:	c3                   	ret    

801055fb <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801055fb:	55                   	push   %ebp
801055fc:	89 e5                	mov    %esp,%ebp
801055fe:	57                   	push   %edi
801055ff:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105600:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105603:	8b 55 10             	mov    0x10(%ebp),%edx
80105606:	8b 45 0c             	mov    0xc(%ebp),%eax
80105609:	89 cb                	mov    %ecx,%ebx
8010560b:	89 df                	mov    %ebx,%edi
8010560d:	89 d1                	mov    %edx,%ecx
8010560f:	fc                   	cld    
80105610:	f3 ab                	rep stos %eax,%es:(%edi)
80105612:	89 ca                	mov    %ecx,%edx
80105614:	89 fb                	mov    %edi,%ebx
80105616:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105619:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010561c:	5b                   	pop    %ebx
8010561d:	5f                   	pop    %edi
8010561e:	5d                   	pop    %ebp
8010561f:	c3                   	ret    

80105620 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105623:	8b 45 08             	mov    0x8(%ebp),%eax
80105626:	83 e0 03             	and    $0x3,%eax
80105629:	85 c0                	test   %eax,%eax
8010562b:	75 43                	jne    80105670 <memset+0x50>
8010562d:	8b 45 10             	mov    0x10(%ebp),%eax
80105630:	83 e0 03             	and    $0x3,%eax
80105633:	85 c0                	test   %eax,%eax
80105635:	75 39                	jne    80105670 <memset+0x50>
    c &= 0xFF;
80105637:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010563e:	8b 45 10             	mov    0x10(%ebp),%eax
80105641:	c1 e8 02             	shr    $0x2,%eax
80105644:	89 c1                	mov    %eax,%ecx
80105646:	8b 45 0c             	mov    0xc(%ebp),%eax
80105649:	c1 e0 18             	shl    $0x18,%eax
8010564c:	89 c2                	mov    %eax,%edx
8010564e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105651:	c1 e0 10             	shl    $0x10,%eax
80105654:	09 c2                	or     %eax,%edx
80105656:	8b 45 0c             	mov    0xc(%ebp),%eax
80105659:	c1 e0 08             	shl    $0x8,%eax
8010565c:	09 d0                	or     %edx,%eax
8010565e:	0b 45 0c             	or     0xc(%ebp),%eax
80105661:	51                   	push   %ecx
80105662:	50                   	push   %eax
80105663:	ff 75 08             	pushl  0x8(%ebp)
80105666:	e8 90 ff ff ff       	call   801055fb <stosl>
8010566b:	83 c4 0c             	add    $0xc,%esp
8010566e:	eb 12                	jmp    80105682 <memset+0x62>
  } else
    stosb(dst, c, n);
80105670:	8b 45 10             	mov    0x10(%ebp),%eax
80105673:	50                   	push   %eax
80105674:	ff 75 0c             	pushl  0xc(%ebp)
80105677:	ff 75 08             	pushl  0x8(%ebp)
8010567a:	e8 57 ff ff ff       	call   801055d6 <stosb>
8010567f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105682:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105685:	c9                   	leave  
80105686:	c3                   	ret    

80105687 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105687:	55                   	push   %ebp
80105688:	89 e5                	mov    %esp,%ebp
8010568a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010568d:	8b 45 08             	mov    0x8(%ebp),%eax
80105690:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105693:	8b 45 0c             	mov    0xc(%ebp),%eax
80105696:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105699:	eb 30                	jmp    801056cb <memcmp+0x44>
    if(*s1 != *s2)
8010569b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010569e:	0f b6 10             	movzbl (%eax),%edx
801056a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056a4:	0f b6 00             	movzbl (%eax),%eax
801056a7:	38 c2                	cmp    %al,%dl
801056a9:	74 18                	je     801056c3 <memcmp+0x3c>
      return *s1 - *s2;
801056ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ae:	0f b6 00             	movzbl (%eax),%eax
801056b1:	0f b6 d0             	movzbl %al,%edx
801056b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056b7:	0f b6 00             	movzbl (%eax),%eax
801056ba:	0f b6 c0             	movzbl %al,%eax
801056bd:	29 c2                	sub    %eax,%edx
801056bf:	89 d0                	mov    %edx,%eax
801056c1:	eb 1a                	jmp    801056dd <memcmp+0x56>
    s1++, s2++;
801056c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056c7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056cb:	8b 45 10             	mov    0x10(%ebp),%eax
801056ce:	8d 50 ff             	lea    -0x1(%eax),%edx
801056d1:	89 55 10             	mov    %edx,0x10(%ebp)
801056d4:	85 c0                	test   %eax,%eax
801056d6:	75 c3                	jne    8010569b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801056d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056dd:	c9                   	leave  
801056de:	c3                   	ret    

801056df <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056df:	55                   	push   %ebp
801056e0:	89 e5                	mov    %esp,%ebp
801056e2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801056eb:	8b 45 08             	mov    0x8(%ebp),%eax
801056ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801056f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056f7:	73 3d                	jae    80105736 <memmove+0x57>
801056f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056fc:	8b 45 10             	mov    0x10(%ebp),%eax
801056ff:	01 d0                	add    %edx,%eax
80105701:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105704:	76 30                	jbe    80105736 <memmove+0x57>
    s += n;
80105706:	8b 45 10             	mov    0x10(%ebp),%eax
80105709:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010570c:	8b 45 10             	mov    0x10(%ebp),%eax
8010570f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105712:	eb 13                	jmp    80105727 <memmove+0x48>
      *--d = *--s;
80105714:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105718:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010571c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010571f:	0f b6 10             	movzbl (%eax),%edx
80105722:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105725:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105727:	8b 45 10             	mov    0x10(%ebp),%eax
8010572a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010572d:	89 55 10             	mov    %edx,0x10(%ebp)
80105730:	85 c0                	test   %eax,%eax
80105732:	75 e0                	jne    80105714 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105734:	eb 26                	jmp    8010575c <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105736:	eb 17                	jmp    8010574f <memmove+0x70>
      *d++ = *s++;
80105738:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010573b:	8d 50 01             	lea    0x1(%eax),%edx
8010573e:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105741:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105744:	8d 4a 01             	lea    0x1(%edx),%ecx
80105747:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010574a:	0f b6 12             	movzbl (%edx),%edx
8010574d:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010574f:	8b 45 10             	mov    0x10(%ebp),%eax
80105752:	8d 50 ff             	lea    -0x1(%eax),%edx
80105755:	89 55 10             	mov    %edx,0x10(%ebp)
80105758:	85 c0                	test   %eax,%eax
8010575a:	75 dc                	jne    80105738 <memmove+0x59>
      *d++ = *s++;

  return dst;
8010575c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010575f:	c9                   	leave  
80105760:	c3                   	ret    

80105761 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105761:	55                   	push   %ebp
80105762:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105764:	ff 75 10             	pushl  0x10(%ebp)
80105767:	ff 75 0c             	pushl  0xc(%ebp)
8010576a:	ff 75 08             	pushl  0x8(%ebp)
8010576d:	e8 6d ff ff ff       	call   801056df <memmove>
80105772:	83 c4 0c             	add    $0xc,%esp
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    

80105777 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105777:	55                   	push   %ebp
80105778:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010577a:	eb 0c                	jmp    80105788 <strncmp+0x11>
    n--, p++, q++;
8010577c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105780:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105784:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105788:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010578c:	74 1a                	je     801057a8 <strncmp+0x31>
8010578e:	8b 45 08             	mov    0x8(%ebp),%eax
80105791:	0f b6 00             	movzbl (%eax),%eax
80105794:	84 c0                	test   %al,%al
80105796:	74 10                	je     801057a8 <strncmp+0x31>
80105798:	8b 45 08             	mov    0x8(%ebp),%eax
8010579b:	0f b6 10             	movzbl (%eax),%edx
8010579e:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a1:	0f b6 00             	movzbl (%eax),%eax
801057a4:	38 c2                	cmp    %al,%dl
801057a6:	74 d4                	je     8010577c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801057a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057ac:	75 07                	jne    801057b5 <strncmp+0x3e>
    return 0;
801057ae:	b8 00 00 00 00       	mov    $0x0,%eax
801057b3:	eb 16                	jmp    801057cb <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801057b5:	8b 45 08             	mov    0x8(%ebp),%eax
801057b8:	0f b6 00             	movzbl (%eax),%eax
801057bb:	0f b6 d0             	movzbl %al,%edx
801057be:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c1:	0f b6 00             	movzbl (%eax),%eax
801057c4:	0f b6 c0             	movzbl %al,%eax
801057c7:	29 c2                	sub    %eax,%edx
801057c9:	89 d0                	mov    %edx,%eax
}
801057cb:	5d                   	pop    %ebp
801057cc:	c3                   	ret    

801057cd <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057cd:	55                   	push   %ebp
801057ce:	89 e5                	mov    %esp,%ebp
801057d0:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801057d3:	8b 45 08             	mov    0x8(%ebp),%eax
801057d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801057d9:	90                   	nop
801057da:	8b 45 10             	mov    0x10(%ebp),%eax
801057dd:	8d 50 ff             	lea    -0x1(%eax),%edx
801057e0:	89 55 10             	mov    %edx,0x10(%ebp)
801057e3:	85 c0                	test   %eax,%eax
801057e5:	7e 1e                	jle    80105805 <strncpy+0x38>
801057e7:	8b 45 08             	mov    0x8(%ebp),%eax
801057ea:	8d 50 01             	lea    0x1(%eax),%edx
801057ed:	89 55 08             	mov    %edx,0x8(%ebp)
801057f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801057f3:	8d 4a 01             	lea    0x1(%edx),%ecx
801057f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801057f9:	0f b6 12             	movzbl (%edx),%edx
801057fc:	88 10                	mov    %dl,(%eax)
801057fe:	0f b6 00             	movzbl (%eax),%eax
80105801:	84 c0                	test   %al,%al
80105803:	75 d5                	jne    801057da <strncpy+0xd>
    ;
  while(n-- > 0)
80105805:	eb 0c                	jmp    80105813 <strncpy+0x46>
    *s++ = 0;
80105807:	8b 45 08             	mov    0x8(%ebp),%eax
8010580a:	8d 50 01             	lea    0x1(%eax),%edx
8010580d:	89 55 08             	mov    %edx,0x8(%ebp)
80105810:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105813:	8b 45 10             	mov    0x10(%ebp),%eax
80105816:	8d 50 ff             	lea    -0x1(%eax),%edx
80105819:	89 55 10             	mov    %edx,0x10(%ebp)
8010581c:	85 c0                	test   %eax,%eax
8010581e:	7f e7                	jg     80105807 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105820:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105823:	c9                   	leave  
80105824:	c3                   	ret    

80105825 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105825:	55                   	push   %ebp
80105826:	89 e5                	mov    %esp,%ebp
80105828:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010582b:	8b 45 08             	mov    0x8(%ebp),%eax
8010582e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105835:	7f 05                	jg     8010583c <safestrcpy+0x17>
    return os;
80105837:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010583a:	eb 31                	jmp    8010586d <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010583c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105844:	7e 1e                	jle    80105864 <safestrcpy+0x3f>
80105846:	8b 45 08             	mov    0x8(%ebp),%eax
80105849:	8d 50 01             	lea    0x1(%eax),%edx
8010584c:	89 55 08             	mov    %edx,0x8(%ebp)
8010584f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105852:	8d 4a 01             	lea    0x1(%edx),%ecx
80105855:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105858:	0f b6 12             	movzbl (%edx),%edx
8010585b:	88 10                	mov    %dl,(%eax)
8010585d:	0f b6 00             	movzbl (%eax),%eax
80105860:	84 c0                	test   %al,%al
80105862:	75 d8                	jne    8010583c <safestrcpy+0x17>
    ;
  *s = 0;
80105864:	8b 45 08             	mov    0x8(%ebp),%eax
80105867:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010586a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    

8010586f <strlen>:

int
strlen(const char *s)
{
8010586f:	55                   	push   %ebp
80105870:	89 e5                	mov    %esp,%ebp
80105872:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105875:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010587c:	eb 04                	jmp    80105882 <strlen+0x13>
8010587e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105882:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105885:	8b 45 08             	mov    0x8(%ebp),%eax
80105888:	01 d0                	add    %edx,%eax
8010588a:	0f b6 00             	movzbl (%eax),%eax
8010588d:	84 c0                	test   %al,%al
8010588f:	75 ed                	jne    8010587e <strlen+0xf>
    ;
  return n;
80105891:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105894:	c9                   	leave  
80105895:	c3                   	ret    

80105896 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105896:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010589a:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010589e:	55                   	push   %ebp
  pushl %ebx
8010589f:	53                   	push   %ebx
  pushl %esi
801058a0:	56                   	push   %esi
  pushl %edi
801058a1:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058a2:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058a4:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801058a6:	5f                   	pop    %edi
  popl %esi
801058a7:	5e                   	pop    %esi
  popl %ebx
801058a8:	5b                   	pop    %ebx
  popl %ebp
801058a9:	5d                   	pop    %ebp
  ret
801058aa:	c3                   	ret    

801058ab <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058ab:	55                   	push   %ebp
801058ac:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801058ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058b4:	8b 00                	mov    (%eax),%eax
801058b6:	3b 45 08             	cmp    0x8(%ebp),%eax
801058b9:	76 12                	jbe    801058cd <fetchint+0x22>
801058bb:	8b 45 08             	mov    0x8(%ebp),%eax
801058be:	8d 50 04             	lea    0x4(%eax),%edx
801058c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c7:	8b 00                	mov    (%eax),%eax
801058c9:	39 c2                	cmp    %eax,%edx
801058cb:	76 07                	jbe    801058d4 <fetchint+0x29>
    return -1;
801058cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d2:	eb 0f                	jmp    801058e3 <fetchint+0x38>
  *ip = *(int*)(addr);
801058d4:	8b 45 08             	mov    0x8(%ebp),%eax
801058d7:	8b 10                	mov    (%eax),%edx
801058d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058dc:	89 10                	mov    %edx,(%eax)
  return 0;
801058de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e3:	5d                   	pop    %ebp
801058e4:	c3                   	ret    

801058e5 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058e5:	55                   	push   %ebp
801058e6:	89 e5                	mov    %esp,%ebp
801058e8:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801058eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f1:	8b 00                	mov    (%eax),%eax
801058f3:	3b 45 08             	cmp    0x8(%ebp),%eax
801058f6:	77 07                	ja     801058ff <fetchstr+0x1a>
    return -1;
801058f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fd:	eb 46                	jmp    80105945 <fetchstr+0x60>
  *pp = (char*)addr;
801058ff:	8b 55 08             	mov    0x8(%ebp),%edx
80105902:	8b 45 0c             	mov    0xc(%ebp),%eax
80105905:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105907:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010590d:	8b 00                	mov    (%eax),%eax
8010590f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105912:	8b 45 0c             	mov    0xc(%ebp),%eax
80105915:	8b 00                	mov    (%eax),%eax
80105917:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010591a:	eb 1c                	jmp    80105938 <fetchstr+0x53>
    if(*s == 0)
8010591c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010591f:	0f b6 00             	movzbl (%eax),%eax
80105922:	84 c0                	test   %al,%al
80105924:	75 0e                	jne    80105934 <fetchstr+0x4f>
      return s - *pp;
80105926:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592c:	8b 00                	mov    (%eax),%eax
8010592e:	29 c2                	sub    %eax,%edx
80105930:	89 d0                	mov    %edx,%eax
80105932:	eb 11                	jmp    80105945 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105934:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105938:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010593b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010593e:	72 dc                	jb     8010591c <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105945:	c9                   	leave  
80105946:	c3                   	ret    

80105947 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105947:	55                   	push   %ebp
80105948:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010594a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105950:	8b 40 18             	mov    0x18(%eax),%eax
80105953:	8b 40 44             	mov    0x44(%eax),%eax
80105956:	8b 55 08             	mov    0x8(%ebp),%edx
80105959:	c1 e2 02             	shl    $0x2,%edx
8010595c:	01 d0                	add    %edx,%eax
8010595e:	83 c0 04             	add    $0x4,%eax
80105961:	ff 75 0c             	pushl  0xc(%ebp)
80105964:	50                   	push   %eax
80105965:	e8 41 ff ff ff       	call   801058ab <fetchint>
8010596a:	83 c4 08             	add    $0x8,%esp
}
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    

8010596f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010596f:	55                   	push   %ebp
80105970:	89 e5                	mov    %esp,%ebp
80105972:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105975:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105978:	50                   	push   %eax
80105979:	ff 75 08             	pushl  0x8(%ebp)
8010597c:	e8 c6 ff ff ff       	call   80105947 <argint>
80105981:	83 c4 08             	add    $0x8,%esp
80105984:	85 c0                	test   %eax,%eax
80105986:	79 07                	jns    8010598f <argptr+0x20>
    return -1;
80105988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598d:	eb 3d                	jmp    801059cc <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010598f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105992:	89 c2                	mov    %eax,%edx
80105994:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010599a:	8b 00                	mov    (%eax),%eax
8010599c:	39 c2                	cmp    %eax,%edx
8010599e:	73 16                	jae    801059b6 <argptr+0x47>
801059a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059a3:	89 c2                	mov    %eax,%edx
801059a5:	8b 45 10             	mov    0x10(%ebp),%eax
801059a8:	01 c2                	add    %eax,%edx
801059aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b0:	8b 00                	mov    (%eax),%eax
801059b2:	39 c2                	cmp    %eax,%edx
801059b4:	76 07                	jbe    801059bd <argptr+0x4e>
    return -1;
801059b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bb:	eb 0f                	jmp    801059cc <argptr+0x5d>
  *pp = (char*)i;
801059bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059c0:	89 c2                	mov    %eax,%edx
801059c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801059c5:	89 10                	mov    %edx,(%eax)
  return 0;
801059c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059cc:	c9                   	leave  
801059cd:	c3                   	ret    

801059ce <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059ce:	55                   	push   %ebp
801059cf:	89 e5                	mov    %esp,%ebp
801059d1:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801059d4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059d7:	50                   	push   %eax
801059d8:	ff 75 08             	pushl  0x8(%ebp)
801059db:	e8 67 ff ff ff       	call   80105947 <argint>
801059e0:	83 c4 08             	add    $0x8,%esp
801059e3:	85 c0                	test   %eax,%eax
801059e5:	79 07                	jns    801059ee <argstr+0x20>
    return -1;
801059e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ec:	eb 0f                	jmp    801059fd <argstr+0x2f>
  return fetchstr(addr, pp);
801059ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059f1:	ff 75 0c             	pushl  0xc(%ebp)
801059f4:	50                   	push   %eax
801059f5:	e8 eb fe ff ff       	call   801058e5 <fetchstr>
801059fa:	83 c4 08             	add    $0x8,%esp
}
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    

801059ff <syscall>:
[SYS_semup] sys_semup,
};

void
syscall(void)
{
801059ff:	55                   	push   %ebp
80105a00:	89 e5                	mov    %esp,%ebp
80105a02:	53                   	push   %ebx
80105a03:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a0c:	8b 40 18             	mov    0x18(%eax),%eax
80105a0f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a19:	7e 30                	jle    80105a4b <syscall+0x4c>
80105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1e:	83 f8 1b             	cmp    $0x1b,%eax
80105a21:	77 28                	ja     80105a4b <syscall+0x4c>
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a2d:	85 c0                	test   %eax,%eax
80105a2f:	74 1a                	je     80105a4b <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a37:	8b 58 18             	mov    0x18(%eax),%ebx
80105a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a44:	ff d0                	call   *%eax
80105a46:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105a49:	eb 34                	jmp    80105a7f <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a51:	8d 50 6c             	lea    0x6c(%eax),%edx
80105a54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a5a:	8b 40 10             	mov    0x10(%eax),%eax
80105a5d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a60:	52                   	push   %edx
80105a61:	50                   	push   %eax
80105a62:	68 a9 90 10 80       	push   $0x801090a9
80105a67:	e8 53 a9 ff ff       	call   801003bf <cprintf>
80105a6c:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105a6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a75:	8b 40 18             	mov    0x18(%eax),%eax
80105a78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    

80105a84 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105a8a:	83 ec 08             	sub    $0x8,%esp
80105a8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a90:	50                   	push   %eax
80105a91:	ff 75 08             	pushl  0x8(%ebp)
80105a94:	e8 ae fe ff ff       	call   80105947 <argint>
80105a99:	83 c4 10             	add    $0x10,%esp
80105a9c:	85 c0                	test   %eax,%eax
80105a9e:	79 07                	jns    80105aa7 <argfd+0x23>
    return -1;
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa5:	eb 50                	jmp    80105af7 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	78 21                	js     80105acf <argfd+0x4b>
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	83 f8 0f             	cmp    $0xf,%eax
80105ab4:	7f 19                	jg     80105acf <argfd+0x4b>
80105ab6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105abc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105abf:	83 c2 08             	add    $0x8,%edx
80105ac2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105acd:	75 07                	jne    80105ad6 <argfd+0x52>
    return -1;
80105acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad4:	eb 21                	jmp    80105af7 <argfd+0x73>
  if(pfd)
80105ad6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ada:	74 08                	je     80105ae4 <argfd+0x60>
    *pfd = fd;
80105adc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105adf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ae2:	89 10                	mov    %edx,(%eax)
  if(pf)
80105ae4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ae8:	74 08                	je     80105af2 <argfd+0x6e>
    *pf = f;
80105aea:	8b 45 10             	mov    0x10(%ebp),%eax
80105aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105af0:	89 10                	mov    %edx,(%eax)
  return 0;
80105af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105af7:	c9                   	leave  
80105af8:	c3                   	ret    

80105af9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105af9:	55                   	push   %ebp
80105afa:	89 e5                	mov    %esp,%ebp
80105afc:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105aff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b06:	eb 30                	jmp    80105b38 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b11:	83 c2 08             	add    $0x8,%edx
80105b14:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b18:	85 c0                	test   %eax,%eax
80105b1a:	75 18                	jne    80105b34 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b22:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b25:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b28:	8b 55 08             	mov    0x8(%ebp),%edx
80105b2b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b32:	eb 0f                	jmp    80105b43 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b34:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b38:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b3c:	7e ca                	jle    80105b08 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105b3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b43:	c9                   	leave  
80105b44:	c3                   	ret    

80105b45 <sys_dup>:

int
sys_dup(void)
{
80105b45:	55                   	push   %ebp
80105b46:	89 e5                	mov    %esp,%ebp
80105b48:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105b4b:	83 ec 04             	sub    $0x4,%esp
80105b4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b51:	50                   	push   %eax
80105b52:	6a 00                	push   $0x0
80105b54:	6a 00                	push   $0x0
80105b56:	e8 29 ff ff ff       	call   80105a84 <argfd>
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	85 c0                	test   %eax,%eax
80105b60:	79 07                	jns    80105b69 <sys_dup+0x24>
    return -1;
80105b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b67:	eb 31                	jmp    80105b9a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6c:	83 ec 0c             	sub    $0xc,%esp
80105b6f:	50                   	push   %eax
80105b70:	e8 84 ff ff ff       	call   80105af9 <fdalloc>
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b7f:	79 07                	jns    80105b88 <sys_dup+0x43>
    return -1;
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b86:	eb 12                	jmp    80105b9a <sys_dup+0x55>
  filedup(f);
80105b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b8b:	83 ec 0c             	sub    $0xc,%esp
80105b8e:	50                   	push   %eax
80105b8f:	e8 23 b4 ff ff       	call   80100fb7 <filedup>
80105b94:	83 c4 10             	add    $0x10,%esp
  return fd;
80105b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b9a:	c9                   	leave  
80105b9b:	c3                   	ret    

80105b9c <sys_read>:

int
sys_read(void)
{
80105b9c:	55                   	push   %ebp
80105b9d:	89 e5                	mov    %esp,%ebp
80105b9f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ba2:	83 ec 04             	sub    $0x4,%esp
80105ba5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ba8:	50                   	push   %eax
80105ba9:	6a 00                	push   $0x0
80105bab:	6a 00                	push   $0x0
80105bad:	e8 d2 fe ff ff       	call   80105a84 <argfd>
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 2e                	js     80105be7 <sys_read+0x4b>
80105bb9:	83 ec 08             	sub    $0x8,%esp
80105bbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bbf:	50                   	push   %eax
80105bc0:	6a 02                	push   $0x2
80105bc2:	e8 80 fd ff ff       	call   80105947 <argint>
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	78 19                	js     80105be7 <sys_read+0x4b>
80105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd1:	83 ec 04             	sub    $0x4,%esp
80105bd4:	50                   	push   %eax
80105bd5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bd8:	50                   	push   %eax
80105bd9:	6a 01                	push   $0x1
80105bdb:	e8 8f fd ff ff       	call   8010596f <argptr>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	85 c0                	test   %eax,%eax
80105be5:	79 07                	jns    80105bee <sys_read+0x52>
    return -1;
80105be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bec:	eb 17                	jmp    80105c05 <sys_read+0x69>
  return fileread(f, p, n);
80105bee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bf1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf7:	83 ec 04             	sub    $0x4,%esp
80105bfa:	51                   	push   %ecx
80105bfb:	52                   	push   %edx
80105bfc:	50                   	push   %eax
80105bfd:	e8 45 b5 ff ff       	call   80101147 <fileread>
80105c02:	83 c4 10             	add    $0x10,%esp
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    

80105c07 <sys_write>:

int
sys_write(void)
{
80105c07:	55                   	push   %ebp
80105c08:	89 e5                	mov    %esp,%ebp
80105c0a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c0d:	83 ec 04             	sub    $0x4,%esp
80105c10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c13:	50                   	push   %eax
80105c14:	6a 00                	push   $0x0
80105c16:	6a 00                	push   $0x0
80105c18:	e8 67 fe ff ff       	call   80105a84 <argfd>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	78 2e                	js     80105c52 <sys_write+0x4b>
80105c24:	83 ec 08             	sub    $0x8,%esp
80105c27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c2a:	50                   	push   %eax
80105c2b:	6a 02                	push   $0x2
80105c2d:	e8 15 fd ff ff       	call   80105947 <argint>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 19                	js     80105c52 <sys_write+0x4b>
80105c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3c:	83 ec 04             	sub    $0x4,%esp
80105c3f:	50                   	push   %eax
80105c40:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c43:	50                   	push   %eax
80105c44:	6a 01                	push   $0x1
80105c46:	e8 24 fd ff ff       	call   8010596f <argptr>
80105c4b:	83 c4 10             	add    $0x10,%esp
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	79 07                	jns    80105c59 <sys_write+0x52>
    return -1;
80105c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c57:	eb 17                	jmp    80105c70 <sys_write+0x69>
  return filewrite(f, p, n);
80105c59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c62:	83 ec 04             	sub    $0x4,%esp
80105c65:	51                   	push   %ecx
80105c66:	52                   	push   %edx
80105c67:	50                   	push   %eax
80105c68:	e8 92 b5 ff ff       	call   801011ff <filewrite>
80105c6d:	83 c4 10             	add    $0x10,%esp
}
80105c70:	c9                   	leave  
80105c71:	c3                   	ret    

80105c72 <sys_close>:

int
sys_close(void)
{
80105c72:	55                   	push   %ebp
80105c73:	89 e5                	mov    %esp,%ebp
80105c75:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c78:	83 ec 04             	sub    $0x4,%esp
80105c7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c7e:	50                   	push   %eax
80105c7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c82:	50                   	push   %eax
80105c83:	6a 00                	push   $0x0
80105c85:	e8 fa fd ff ff       	call   80105a84 <argfd>
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	79 07                	jns    80105c98 <sys_close+0x26>
    return -1;
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c96:	eb 28                	jmp    80105cc0 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca1:	83 c2 08             	add    $0x8,%edx
80105ca4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cab:	00 
  fileclose(f);
80105cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105caf:	83 ec 0c             	sub    $0xc,%esp
80105cb2:	50                   	push   %eax
80105cb3:	e8 50 b3 ff ff       	call   80101008 <fileclose>
80105cb8:	83 c4 10             	add    $0x10,%esp
  return 0;
80105cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cc0:	c9                   	leave  
80105cc1:	c3                   	ret    

80105cc2 <sys_fstat>:

int
sys_fstat(void)
{
80105cc2:	55                   	push   %ebp
80105cc3:	89 e5                	mov    %esp,%ebp
80105cc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cc8:	83 ec 04             	sub    $0x4,%esp
80105ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cce:	50                   	push   %eax
80105ccf:	6a 00                	push   $0x0
80105cd1:	6a 00                	push   $0x0
80105cd3:	e8 ac fd ff ff       	call   80105a84 <argfd>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	78 17                	js     80105cf6 <sys_fstat+0x34>
80105cdf:	83 ec 04             	sub    $0x4,%esp
80105ce2:	6a 14                	push   $0x14
80105ce4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce7:	50                   	push   %eax
80105ce8:	6a 01                	push   $0x1
80105cea:	e8 80 fc ff ff       	call   8010596f <argptr>
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	85 c0                	test   %eax,%eax
80105cf4:	79 07                	jns    80105cfd <sys_fstat+0x3b>
    return -1;
80105cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfb:	eb 13                	jmp    80105d10 <sys_fstat+0x4e>
  return filestat(f, st);
80105cfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d03:	83 ec 08             	sub    $0x8,%esp
80105d06:	52                   	push   %edx
80105d07:	50                   	push   %eax
80105d08:	e8 e3 b3 ff ff       	call   801010f0 <filestat>
80105d0d:	83 c4 10             	add    $0x10,%esp
}
80105d10:	c9                   	leave  
80105d11:	c3                   	ret    

80105d12 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d12:	55                   	push   %ebp
80105d13:	89 e5                	mov    %esp,%ebp
80105d15:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d18:	83 ec 08             	sub    $0x8,%esp
80105d1b:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d1e:	50                   	push   %eax
80105d1f:	6a 00                	push   $0x0
80105d21:	e8 a8 fc ff ff       	call   801059ce <argstr>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	78 15                	js     80105d42 <sys_link+0x30>
80105d2d:	83 ec 08             	sub    $0x8,%esp
80105d30:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d33:	50                   	push   %eax
80105d34:	6a 01                	push   $0x1
80105d36:	e8 93 fc ff ff       	call   801059ce <argstr>
80105d3b:	83 c4 10             	add    $0x10,%esp
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	79 0a                	jns    80105d4c <sys_link+0x3a>
    return -1;
80105d42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d47:	e9 69 01 00 00       	jmp    80105eb5 <sys_link+0x1a3>

  begin_op();
80105d4c:	e8 11 d7 ff ff       	call   80103462 <begin_op>
  if((ip = namei(old)) == 0){
80105d51:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105d54:	83 ec 0c             	sub    $0xc,%esp
80105d57:	50                   	push   %eax
80105d58:	e8 30 c7 ff ff       	call   8010248d <namei>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d67:	75 0f                	jne    80105d78 <sys_link+0x66>
    end_op();
80105d69:	e8 82 d7 ff ff       	call   801034f0 <end_op>
    return -1;
80105d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d73:	e9 3d 01 00 00       	jmp    80105eb5 <sys_link+0x1a3>
  }

  ilock(ip);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7e:	e8 47 bb ff ff       	call   801018ca <ilock>
80105d83:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d89:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d8d:	66 83 f8 01          	cmp    $0x1,%ax
80105d91:	75 1d                	jne    80105db0 <sys_link+0x9e>
    iunlockput(ip);
80105d93:	83 ec 0c             	sub    $0xc,%esp
80105d96:	ff 75 f4             	pushl  -0xc(%ebp)
80105d99:	e8 e3 bd ff ff       	call   80101b81 <iunlockput>
80105d9e:	83 c4 10             	add    $0x10,%esp
    end_op();
80105da1:	e8 4a d7 ff ff       	call   801034f0 <end_op>
    return -1;
80105da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dab:	e9 05 01 00 00       	jmp    80105eb5 <sys_link+0x1a3>
  }

  ip->nlink++;
80105db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105db7:	83 c0 01             	add    $0x1,%eax
80105dba:	89 c2                	mov    %eax,%edx
80105dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbf:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dc3:	83 ec 0c             	sub    $0xc,%esp
80105dc6:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc9:	e8 29 b9 ff ff       	call   801016f7 <iupdate>
80105dce:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105dd1:	83 ec 0c             	sub    $0xc,%esp
80105dd4:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd7:	e8 45 bc ff ff       	call   80101a21 <iunlock>
80105ddc:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105ddf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105de2:	83 ec 08             	sub    $0x8,%esp
80105de5:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105de8:	52                   	push   %edx
80105de9:	50                   	push   %eax
80105dea:	e8 ba c6 ff ff       	call   801024a9 <nameiparent>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105df9:	75 02                	jne    80105dfd <sys_link+0xeb>
    goto bad;
80105dfb:	eb 71                	jmp    80105e6e <sys_link+0x15c>
  ilock(dp);
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	ff 75 f0             	pushl  -0x10(%ebp)
80105e03:	e8 c2 ba ff ff       	call   801018ca <ilock>
80105e08:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0e:	8b 10                	mov    (%eax),%edx
80105e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e13:	8b 00                	mov    (%eax),%eax
80105e15:	39 c2                	cmp    %eax,%edx
80105e17:	75 1d                	jne    80105e36 <sys_link+0x124>
80105e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1c:	8b 40 04             	mov    0x4(%eax),%eax
80105e1f:	83 ec 04             	sub    $0x4,%esp
80105e22:	50                   	push   %eax
80105e23:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e26:	50                   	push   %eax
80105e27:	ff 75 f0             	pushl  -0x10(%ebp)
80105e2a:	e8 c6 c3 ff ff       	call   801021f5 <dirlink>
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	85 c0                	test   %eax,%eax
80105e34:	79 10                	jns    80105e46 <sys_link+0x134>
    iunlockput(dp);
80105e36:	83 ec 0c             	sub    $0xc,%esp
80105e39:	ff 75 f0             	pushl  -0x10(%ebp)
80105e3c:	e8 40 bd ff ff       	call   80101b81 <iunlockput>
80105e41:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e44:	eb 28                	jmp    80105e6e <sys_link+0x15c>
  }
  iunlockput(dp);
80105e46:	83 ec 0c             	sub    $0xc,%esp
80105e49:	ff 75 f0             	pushl  -0x10(%ebp)
80105e4c:	e8 30 bd ff ff       	call   80101b81 <iunlockput>
80105e51:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5a:	e8 33 bc ff ff       	call   80101a92 <iput>
80105e5f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e62:	e8 89 d6 ff ff       	call   801034f0 <end_op>

  return 0;
80105e67:	b8 00 00 00 00       	mov    $0x0,%eax
80105e6c:	eb 47                	jmp    80105eb5 <sys_link+0x1a3>

bad:
  ilock(ip);
80105e6e:	83 ec 0c             	sub    $0xc,%esp
80105e71:	ff 75 f4             	pushl  -0xc(%ebp)
80105e74:	e8 51 ba ff ff       	call   801018ca <ilock>
80105e79:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e83:	83 e8 01             	sub    $0x1,%eax
80105e86:	89 c2                	mov    %eax,%edx
80105e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e8f:	83 ec 0c             	sub    $0xc,%esp
80105e92:	ff 75 f4             	pushl  -0xc(%ebp)
80105e95:	e8 5d b8 ff ff       	call   801016f7 <iupdate>
80105e9a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105e9d:	83 ec 0c             	sub    $0xc,%esp
80105ea0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea3:	e8 d9 bc ff ff       	call   80101b81 <iunlockput>
80105ea8:	83 c4 10             	add    $0x10,%esp
  end_op();
80105eab:	e8 40 d6 ff ff       	call   801034f0 <end_op>
  return -1;
80105eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    

80105eb7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105eb7:	55                   	push   %ebp
80105eb8:	89 e5                	mov    %esp,%ebp
80105eba:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ebd:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ec4:	eb 40                	jmp    80105f06 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec9:	6a 10                	push   $0x10
80105ecb:	50                   	push   %eax
80105ecc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ecf:	50                   	push   %eax
80105ed0:	ff 75 08             	pushl  0x8(%ebp)
80105ed3:	e8 54 bf ff ff       	call   80101e2c <readi>
80105ed8:	83 c4 10             	add    $0x10,%esp
80105edb:	83 f8 10             	cmp    $0x10,%eax
80105ede:	74 0d                	je     80105eed <isdirempty+0x36>
      panic("isdirempty: readi");
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	68 c5 90 10 80       	push   $0x801090c5
80105ee8:	e8 6f a6 ff ff       	call   8010055c <panic>
    if(de.inum != 0)
80105eed:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105ef1:	66 85 c0             	test   %ax,%ax
80105ef4:	74 07                	je     80105efd <isdirempty+0x46>
      return 0;
80105ef6:	b8 00 00 00 00       	mov    $0x0,%eax
80105efb:	eb 1b                	jmp    80105f18 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f00:	83 c0 10             	add    $0x10,%eax
80105f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f09:	8b 45 08             	mov    0x8(%ebp),%eax
80105f0c:	8b 40 18             	mov    0x18(%eax),%eax
80105f0f:	39 c2                	cmp    %eax,%edx
80105f11:	72 b3                	jb     80105ec6 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f13:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f18:	c9                   	leave  
80105f19:	c3                   	ret    

80105f1a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f1a:	55                   	push   %ebp
80105f1b:	89 e5                	mov    %esp,%ebp
80105f1d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f26:	50                   	push   %eax
80105f27:	6a 00                	push   $0x0
80105f29:	e8 a0 fa ff ff       	call   801059ce <argstr>
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	85 c0                	test   %eax,%eax
80105f33:	79 0a                	jns    80105f3f <sys_unlink+0x25>
    return -1;
80105f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3a:	e9 bc 01 00 00       	jmp    801060fb <sys_unlink+0x1e1>

  begin_op();
80105f3f:	e8 1e d5 ff ff       	call   80103462 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f44:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f47:	83 ec 08             	sub    $0x8,%esp
80105f4a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105f4d:	52                   	push   %edx
80105f4e:	50                   	push   %eax
80105f4f:	e8 55 c5 ff ff       	call   801024a9 <nameiparent>
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f5e:	75 0f                	jne    80105f6f <sys_unlink+0x55>
    end_op();
80105f60:	e8 8b d5 ff ff       	call   801034f0 <end_op>
    return -1;
80105f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6a:	e9 8c 01 00 00       	jmp    801060fb <sys_unlink+0x1e1>
  }

  ilock(dp);
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	ff 75 f4             	pushl  -0xc(%ebp)
80105f75:	e8 50 b9 ff ff       	call   801018ca <ilock>
80105f7a:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f7d:	83 ec 08             	sub    $0x8,%esp
80105f80:	68 d7 90 10 80       	push   $0x801090d7
80105f85:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f88:	50                   	push   %eax
80105f89:	e8 91 c1 ff ff       	call   8010211f <namecmp>
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	85 c0                	test   %eax,%eax
80105f93:	0f 84 4a 01 00 00    	je     801060e3 <sys_unlink+0x1c9>
80105f99:	83 ec 08             	sub    $0x8,%esp
80105f9c:	68 d9 90 10 80       	push   $0x801090d9
80105fa1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fa4:	50                   	push   %eax
80105fa5:	e8 75 c1 ff ff       	call   8010211f <namecmp>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	85 c0                	test   %eax,%eax
80105faf:	0f 84 2e 01 00 00    	je     801060e3 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105fb5:	83 ec 04             	sub    $0x4,%esp
80105fb8:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105fbb:	50                   	push   %eax
80105fbc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fbf:	50                   	push   %eax
80105fc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc3:	e8 72 c1 ff ff       	call   8010213a <dirlookup>
80105fc8:	83 c4 10             	add    $0x10,%esp
80105fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd2:	75 05                	jne    80105fd9 <sys_unlink+0xbf>
    goto bad;
80105fd4:	e9 0a 01 00 00       	jmp    801060e3 <sys_unlink+0x1c9>
  ilock(ip);
80105fd9:	83 ec 0c             	sub    $0xc,%esp
80105fdc:	ff 75 f0             	pushl  -0x10(%ebp)
80105fdf:	e8 e6 b8 ff ff       	call   801018ca <ilock>
80105fe4:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fea:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fee:	66 85 c0             	test   %ax,%ax
80105ff1:	7f 0d                	jg     80106000 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80105ff3:	83 ec 0c             	sub    $0xc,%esp
80105ff6:	68 dc 90 10 80       	push   $0x801090dc
80105ffb:	e8 5c a5 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106003:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106007:	66 83 f8 01          	cmp    $0x1,%ax
8010600b:	75 25                	jne    80106032 <sys_unlink+0x118>
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	ff 75 f0             	pushl  -0x10(%ebp)
80106013:	e8 9f fe ff ff       	call   80105eb7 <isdirempty>
80106018:	83 c4 10             	add    $0x10,%esp
8010601b:	85 c0                	test   %eax,%eax
8010601d:	75 13                	jne    80106032 <sys_unlink+0x118>
    iunlockput(ip);
8010601f:	83 ec 0c             	sub    $0xc,%esp
80106022:	ff 75 f0             	pushl  -0x10(%ebp)
80106025:	e8 57 bb ff ff       	call   80101b81 <iunlockput>
8010602a:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010602d:	e9 b1 00 00 00       	jmp    801060e3 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106032:	83 ec 04             	sub    $0x4,%esp
80106035:	6a 10                	push   $0x10
80106037:	6a 00                	push   $0x0
80106039:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010603c:	50                   	push   %eax
8010603d:	e8 de f5 ff ff       	call   80105620 <memset>
80106042:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106045:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106048:	6a 10                	push   $0x10
8010604a:	50                   	push   %eax
8010604b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010604e:	50                   	push   %eax
8010604f:	ff 75 f4             	pushl  -0xc(%ebp)
80106052:	e8 36 bf ff ff       	call   80101f8d <writei>
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	83 f8 10             	cmp    $0x10,%eax
8010605d:	74 0d                	je     8010606c <sys_unlink+0x152>
    panic("unlink: writei");
8010605f:	83 ec 0c             	sub    $0xc,%esp
80106062:	68 ee 90 10 80       	push   $0x801090ee
80106067:	e8 f0 a4 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
8010606c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106073:	66 83 f8 01          	cmp    $0x1,%ax
80106077:	75 21                	jne    8010609a <sys_unlink+0x180>
    dp->nlink--;
80106079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106080:	83 e8 01             	sub    $0x1,%eax
80106083:	89 c2                	mov    %eax,%edx
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010608c:	83 ec 0c             	sub    $0xc,%esp
8010608f:	ff 75 f4             	pushl  -0xc(%ebp)
80106092:	e8 60 b6 ff ff       	call   801016f7 <iupdate>
80106097:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010609a:	83 ec 0c             	sub    $0xc,%esp
8010609d:	ff 75 f4             	pushl  -0xc(%ebp)
801060a0:	e8 dc ba ff ff       	call   80101b81 <iunlockput>
801060a5:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801060a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ab:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060af:	83 e8 01             	sub    $0x1,%eax
801060b2:	89 c2                	mov    %eax,%edx
801060b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801060bb:	83 ec 0c             	sub    $0xc,%esp
801060be:	ff 75 f0             	pushl  -0x10(%ebp)
801060c1:	e8 31 b6 ff ff       	call   801016f7 <iupdate>
801060c6:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801060c9:	83 ec 0c             	sub    $0xc,%esp
801060cc:	ff 75 f0             	pushl  -0x10(%ebp)
801060cf:	e8 ad ba ff ff       	call   80101b81 <iunlockput>
801060d4:	83 c4 10             	add    $0x10,%esp

  end_op();
801060d7:	e8 14 d4 ff ff       	call   801034f0 <end_op>

  return 0;
801060dc:	b8 00 00 00 00       	mov    $0x0,%eax
801060e1:	eb 18                	jmp    801060fb <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	ff 75 f4             	pushl  -0xc(%ebp)
801060e9:	e8 93 ba ff ff       	call   80101b81 <iunlockput>
801060ee:	83 c4 10             	add    $0x10,%esp
  end_op();
801060f1:	e8 fa d3 ff ff       	call   801034f0 <end_op>
  return -1;
801060f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060fb:	c9                   	leave  
801060fc:	c3                   	ret    

801060fd <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801060fd:	55                   	push   %ebp
801060fe:	89 e5                	mov    %esp,%ebp
80106100:	83 ec 38             	sub    $0x38,%esp
80106103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106106:	8b 55 10             	mov    0x10(%ebp),%edx
80106109:	8b 45 14             	mov    0x14(%ebp),%eax
8010610c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106110:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106114:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106118:	83 ec 08             	sub    $0x8,%esp
8010611b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010611e:	50                   	push   %eax
8010611f:	ff 75 08             	pushl  0x8(%ebp)
80106122:	e8 82 c3 ff ff       	call   801024a9 <nameiparent>
80106127:	83 c4 10             	add    $0x10,%esp
8010612a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010612d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106131:	75 0a                	jne    8010613d <create+0x40>
    return 0;
80106133:	b8 00 00 00 00       	mov    $0x0,%eax
80106138:	e9 90 01 00 00       	jmp    801062cd <create+0x1d0>
  ilock(dp);
8010613d:	83 ec 0c             	sub    $0xc,%esp
80106140:	ff 75 f4             	pushl  -0xc(%ebp)
80106143:	e8 82 b7 ff ff       	call   801018ca <ilock>
80106148:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010614b:	83 ec 04             	sub    $0x4,%esp
8010614e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106151:	50                   	push   %eax
80106152:	8d 45 de             	lea    -0x22(%ebp),%eax
80106155:	50                   	push   %eax
80106156:	ff 75 f4             	pushl  -0xc(%ebp)
80106159:	e8 dc bf ff ff       	call   8010213a <dirlookup>
8010615e:	83 c4 10             	add    $0x10,%esp
80106161:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106168:	74 50                	je     801061ba <create+0xbd>
    iunlockput(dp);
8010616a:	83 ec 0c             	sub    $0xc,%esp
8010616d:	ff 75 f4             	pushl  -0xc(%ebp)
80106170:	e8 0c ba ff ff       	call   80101b81 <iunlockput>
80106175:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	ff 75 f0             	pushl  -0x10(%ebp)
8010617e:	e8 47 b7 ff ff       	call   801018ca <ilock>
80106183:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106186:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010618b:	75 15                	jne    801061a2 <create+0xa5>
8010618d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106190:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106194:	66 83 f8 02          	cmp    $0x2,%ax
80106198:	75 08                	jne    801061a2 <create+0xa5>
      return ip;
8010619a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619d:	e9 2b 01 00 00       	jmp    801062cd <create+0x1d0>
    iunlockput(ip);
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	ff 75 f0             	pushl  -0x10(%ebp)
801061a8:	e8 d4 b9 ff ff       	call   80101b81 <iunlockput>
801061ad:	83 c4 10             	add    $0x10,%esp
    return 0;
801061b0:	b8 00 00 00 00       	mov    $0x0,%eax
801061b5:	e9 13 01 00 00       	jmp    801062cd <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801061ba:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801061be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c1:	8b 00                	mov    (%eax),%eax
801061c3:	83 ec 08             	sub    $0x8,%esp
801061c6:	52                   	push   %edx
801061c7:	50                   	push   %eax
801061c8:	e8 49 b4 ff ff       	call   80101616 <ialloc>
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061d7:	75 0d                	jne    801061e6 <create+0xe9>
    panic("create: ialloc");
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	68 fd 90 10 80       	push   $0x801090fd
801061e1:	e8 76 a3 ff ff       	call   8010055c <panic>

  ilock(ip);
801061e6:	83 ec 0c             	sub    $0xc,%esp
801061e9:	ff 75 f0             	pushl  -0x10(%ebp)
801061ec:	e8 d9 b6 ff ff       	call   801018ca <ilock>
801061f1:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801061f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f7:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801061fb:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801061ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106202:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106206:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010620a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106213:	83 ec 0c             	sub    $0xc,%esp
80106216:	ff 75 f0             	pushl  -0x10(%ebp)
80106219:	e8 d9 b4 ff ff       	call   801016f7 <iupdate>
8010621e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106221:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106226:	75 6a                	jne    80106292 <create+0x195>
    dp->nlink++;  // for ".."
80106228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010622f:	83 c0 01             	add    $0x1,%eax
80106232:	89 c2                	mov    %eax,%edx
80106234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106237:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010623b:	83 ec 0c             	sub    $0xc,%esp
8010623e:	ff 75 f4             	pushl  -0xc(%ebp)
80106241:	e8 b1 b4 ff ff       	call   801016f7 <iupdate>
80106246:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624c:	8b 40 04             	mov    0x4(%eax),%eax
8010624f:	83 ec 04             	sub    $0x4,%esp
80106252:	50                   	push   %eax
80106253:	68 d7 90 10 80       	push   $0x801090d7
80106258:	ff 75 f0             	pushl  -0x10(%ebp)
8010625b:	e8 95 bf ff ff       	call   801021f5 <dirlink>
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	85 c0                	test   %eax,%eax
80106265:	78 1e                	js     80106285 <create+0x188>
80106267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010626a:	8b 40 04             	mov    0x4(%eax),%eax
8010626d:	83 ec 04             	sub    $0x4,%esp
80106270:	50                   	push   %eax
80106271:	68 d9 90 10 80       	push   $0x801090d9
80106276:	ff 75 f0             	pushl  -0x10(%ebp)
80106279:	e8 77 bf ff ff       	call   801021f5 <dirlink>
8010627e:	83 c4 10             	add    $0x10,%esp
80106281:	85 c0                	test   %eax,%eax
80106283:	79 0d                	jns    80106292 <create+0x195>
      panic("create dots");
80106285:	83 ec 0c             	sub    $0xc,%esp
80106288:	68 0c 91 10 80       	push   $0x8010910c
8010628d:	e8 ca a2 ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106292:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106295:	8b 40 04             	mov    0x4(%eax),%eax
80106298:	83 ec 04             	sub    $0x4,%esp
8010629b:	50                   	push   %eax
8010629c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010629f:	50                   	push   %eax
801062a0:	ff 75 f4             	pushl  -0xc(%ebp)
801062a3:	e8 4d bf ff ff       	call   801021f5 <dirlink>
801062a8:	83 c4 10             	add    $0x10,%esp
801062ab:	85 c0                	test   %eax,%eax
801062ad:	79 0d                	jns    801062bc <create+0x1bf>
    panic("create: dirlink");
801062af:	83 ec 0c             	sub    $0xc,%esp
801062b2:	68 18 91 10 80       	push   $0x80109118
801062b7:	e8 a0 a2 ff ff       	call   8010055c <panic>

  iunlockput(dp);
801062bc:	83 ec 0c             	sub    $0xc,%esp
801062bf:	ff 75 f4             	pushl  -0xc(%ebp)
801062c2:	e8 ba b8 ff ff       	call   80101b81 <iunlockput>
801062c7:	83 c4 10             	add    $0x10,%esp

  return ip;
801062ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801062cd:	c9                   	leave  
801062ce:	c3                   	ret    

801062cf <sys_open>:

int
sys_open(void)
{
801062cf:	55                   	push   %ebp
801062d0:	89 e5                	mov    %esp,%ebp
801062d2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801062d5:	83 ec 08             	sub    $0x8,%esp
801062d8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062db:	50                   	push   %eax
801062dc:	6a 00                	push   $0x0
801062de:	e8 eb f6 ff ff       	call   801059ce <argstr>
801062e3:	83 c4 10             	add    $0x10,%esp
801062e6:	85 c0                	test   %eax,%eax
801062e8:	78 15                	js     801062ff <sys_open+0x30>
801062ea:	83 ec 08             	sub    $0x8,%esp
801062ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062f0:	50                   	push   %eax
801062f1:	6a 01                	push   $0x1
801062f3:	e8 4f f6 ff ff       	call   80105947 <argint>
801062f8:	83 c4 10             	add    $0x10,%esp
801062fb:	85 c0                	test   %eax,%eax
801062fd:	79 0a                	jns    80106309 <sys_open+0x3a>
    return -1;
801062ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106304:	e9 61 01 00 00       	jmp    8010646a <sys_open+0x19b>

  begin_op();
80106309:	e8 54 d1 ff ff       	call   80103462 <begin_op>

  if(omode & O_CREATE){
8010630e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106311:	25 00 02 00 00       	and    $0x200,%eax
80106316:	85 c0                	test   %eax,%eax
80106318:	74 2a                	je     80106344 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010631a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010631d:	6a 00                	push   $0x0
8010631f:	6a 00                	push   $0x0
80106321:	6a 02                	push   $0x2
80106323:	50                   	push   %eax
80106324:	e8 d4 fd ff ff       	call   801060fd <create>
80106329:	83 c4 10             	add    $0x10,%esp
8010632c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010632f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106333:	75 75                	jne    801063aa <sys_open+0xdb>
      end_op();
80106335:	e8 b6 d1 ff ff       	call   801034f0 <end_op>
      return -1;
8010633a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633f:	e9 26 01 00 00       	jmp    8010646a <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106344:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106347:	83 ec 0c             	sub    $0xc,%esp
8010634a:	50                   	push   %eax
8010634b:	e8 3d c1 ff ff       	call   8010248d <namei>
80106350:	83 c4 10             	add    $0x10,%esp
80106353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010635a:	75 0f                	jne    8010636b <sys_open+0x9c>
      end_op();
8010635c:	e8 8f d1 ff ff       	call   801034f0 <end_op>
      return -1;
80106361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106366:	e9 ff 00 00 00       	jmp    8010646a <sys_open+0x19b>
    }
    ilock(ip);
8010636b:	83 ec 0c             	sub    $0xc,%esp
8010636e:	ff 75 f4             	pushl  -0xc(%ebp)
80106371:	e8 54 b5 ff ff       	call   801018ca <ilock>
80106376:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106380:	66 83 f8 01          	cmp    $0x1,%ax
80106384:	75 24                	jne    801063aa <sys_open+0xdb>
80106386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106389:	85 c0                	test   %eax,%eax
8010638b:	74 1d                	je     801063aa <sys_open+0xdb>
      iunlockput(ip);
8010638d:	83 ec 0c             	sub    $0xc,%esp
80106390:	ff 75 f4             	pushl  -0xc(%ebp)
80106393:	e8 e9 b7 ff ff       	call   80101b81 <iunlockput>
80106398:	83 c4 10             	add    $0x10,%esp
      end_op();
8010639b:	e8 50 d1 ff ff       	call   801034f0 <end_op>
      return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a5:	e9 c0 00 00 00       	jmp    8010646a <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801063aa:	e8 9c ab ff ff       	call   80100f4b <filealloc>
801063af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063b6:	74 17                	je     801063cf <sys_open+0x100>
801063b8:	83 ec 0c             	sub    $0xc,%esp
801063bb:	ff 75 f0             	pushl  -0x10(%ebp)
801063be:	e8 36 f7 ff ff       	call   80105af9 <fdalloc>
801063c3:	83 c4 10             	add    $0x10,%esp
801063c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801063c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801063cd:	79 2e                	jns    801063fd <sys_open+0x12e>
    if(f)
801063cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063d3:	74 0e                	je     801063e3 <sys_open+0x114>
      fileclose(f);
801063d5:	83 ec 0c             	sub    $0xc,%esp
801063d8:	ff 75 f0             	pushl  -0x10(%ebp)
801063db:	e8 28 ac ff ff       	call   80101008 <fileclose>
801063e0:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063e3:	83 ec 0c             	sub    $0xc,%esp
801063e6:	ff 75 f4             	pushl  -0xc(%ebp)
801063e9:	e8 93 b7 ff ff       	call   80101b81 <iunlockput>
801063ee:	83 c4 10             	add    $0x10,%esp
    end_op();
801063f1:	e8 fa d0 ff ff       	call   801034f0 <end_op>
    return -1;
801063f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fb:	eb 6d                	jmp    8010646a <sys_open+0x19b>
  }
  iunlock(ip);
801063fd:	83 ec 0c             	sub    $0xc,%esp
80106400:	ff 75 f4             	pushl  -0xc(%ebp)
80106403:	e8 19 b6 ff ff       	call   80101a21 <iunlock>
80106408:	83 c4 10             	add    $0x10,%esp
  end_op();
8010640b:	e8 e0 d0 ff ff       	call   801034f0 <end_op>

  f->type = FD_INODE;
80106410:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106413:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106419:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010641c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010641f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106425:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010642c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010642f:	83 e0 01             	and    $0x1,%eax
80106432:	85 c0                	test   %eax,%eax
80106434:	0f 94 c0             	sete   %al
80106437:	89 c2                	mov    %eax,%edx
80106439:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010643f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106442:	83 e0 01             	and    $0x1,%eax
80106445:	85 c0                	test   %eax,%eax
80106447:	75 0a                	jne    80106453 <sys_open+0x184>
80106449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010644c:	83 e0 02             	and    $0x2,%eax
8010644f:	85 c0                	test   %eax,%eax
80106451:	74 07                	je     8010645a <sys_open+0x18b>
80106453:	b8 01 00 00 00       	mov    $0x1,%eax
80106458:	eb 05                	jmp    8010645f <sys_open+0x190>
8010645a:	b8 00 00 00 00       	mov    $0x0,%eax
8010645f:	89 c2                	mov    %eax,%edx
80106461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106464:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106467:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010646a:	c9                   	leave  
8010646b:	c3                   	ret    

8010646c <sys_mkdir>:

int
sys_mkdir(void)
{
8010646c:	55                   	push   %ebp
8010646d:	89 e5                	mov    %esp,%ebp
8010646f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106472:	e8 eb cf ff ff       	call   80103462 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106477:	83 ec 08             	sub    $0x8,%esp
8010647a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010647d:	50                   	push   %eax
8010647e:	6a 00                	push   $0x0
80106480:	e8 49 f5 ff ff       	call   801059ce <argstr>
80106485:	83 c4 10             	add    $0x10,%esp
80106488:	85 c0                	test   %eax,%eax
8010648a:	78 1b                	js     801064a7 <sys_mkdir+0x3b>
8010648c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010648f:	6a 00                	push   $0x0
80106491:	6a 00                	push   $0x0
80106493:	6a 01                	push   $0x1
80106495:	50                   	push   %eax
80106496:	e8 62 fc ff ff       	call   801060fd <create>
8010649b:	83 c4 10             	add    $0x10,%esp
8010649e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064a5:	75 0c                	jne    801064b3 <sys_mkdir+0x47>
    end_op();
801064a7:	e8 44 d0 ff ff       	call   801034f0 <end_op>
    return -1;
801064ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b1:	eb 18                	jmp    801064cb <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801064b3:	83 ec 0c             	sub    $0xc,%esp
801064b6:	ff 75 f4             	pushl  -0xc(%ebp)
801064b9:	e8 c3 b6 ff ff       	call   80101b81 <iunlockput>
801064be:	83 c4 10             	add    $0x10,%esp
  end_op();
801064c1:	e8 2a d0 ff ff       	call   801034f0 <end_op>
  return 0;
801064c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064cb:	c9                   	leave  
801064cc:	c3                   	ret    

801064cd <sys_mknod>:

int
sys_mknod(void)
{
801064cd:	55                   	push   %ebp
801064ce:	89 e5                	mov    %esp,%ebp
801064d0:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801064d3:	e8 8a cf ff ff       	call   80103462 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801064d8:	83 ec 08             	sub    $0x8,%esp
801064db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064de:	50                   	push   %eax
801064df:	6a 00                	push   $0x0
801064e1:	e8 e8 f4 ff ff       	call   801059ce <argstr>
801064e6:	83 c4 10             	add    $0x10,%esp
801064e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064f0:	78 4f                	js     80106541 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801064f2:	83 ec 08             	sub    $0x8,%esp
801064f5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064f8:	50                   	push   %eax
801064f9:	6a 01                	push   $0x1
801064fb:	e8 47 f4 ff ff       	call   80105947 <argint>
80106500:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106503:	85 c0                	test   %eax,%eax
80106505:	78 3a                	js     80106541 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106507:	83 ec 08             	sub    $0x8,%esp
8010650a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010650d:	50                   	push   %eax
8010650e:	6a 02                	push   $0x2
80106510:	e8 32 f4 ff ff       	call   80105947 <argint>
80106515:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106518:	85 c0                	test   %eax,%eax
8010651a:	78 25                	js     80106541 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010651c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010651f:	0f bf c8             	movswl %ax,%ecx
80106522:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106525:	0f bf d0             	movswl %ax,%edx
80106528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010652b:	51                   	push   %ecx
8010652c:	52                   	push   %edx
8010652d:	6a 03                	push   $0x3
8010652f:	50                   	push   %eax
80106530:	e8 c8 fb ff ff       	call   801060fd <create>
80106535:	83 c4 10             	add    $0x10,%esp
80106538:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010653b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010653f:	75 0c                	jne    8010654d <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106541:	e8 aa cf ff ff       	call   801034f0 <end_op>
    return -1;
80106546:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010654b:	eb 18                	jmp    80106565 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010654d:	83 ec 0c             	sub    $0xc,%esp
80106550:	ff 75 f0             	pushl  -0x10(%ebp)
80106553:	e8 29 b6 ff ff       	call   80101b81 <iunlockput>
80106558:	83 c4 10             	add    $0x10,%esp
  end_op();
8010655b:	e8 90 cf ff ff       	call   801034f0 <end_op>
  return 0;
80106560:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106565:	c9                   	leave  
80106566:	c3                   	ret    

80106567 <sys_chdir>:

int
sys_chdir(void)
{
80106567:	55                   	push   %ebp
80106568:	89 e5                	mov    %esp,%ebp
8010656a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010656d:	e8 f0 ce ff ff       	call   80103462 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106572:	83 ec 08             	sub    $0x8,%esp
80106575:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106578:	50                   	push   %eax
80106579:	6a 00                	push   $0x0
8010657b:	e8 4e f4 ff ff       	call   801059ce <argstr>
80106580:	83 c4 10             	add    $0x10,%esp
80106583:	85 c0                	test   %eax,%eax
80106585:	78 18                	js     8010659f <sys_chdir+0x38>
80106587:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010658a:	83 ec 0c             	sub    $0xc,%esp
8010658d:	50                   	push   %eax
8010658e:	e8 fa be ff ff       	call   8010248d <namei>
80106593:	83 c4 10             	add    $0x10,%esp
80106596:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010659d:	75 0c                	jne    801065ab <sys_chdir+0x44>
    end_op();
8010659f:	e8 4c cf ff ff       	call   801034f0 <end_op>
    return -1;
801065a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a9:	eb 6e                	jmp    80106619 <sys_chdir+0xb2>
  }
  ilock(ip);
801065ab:	83 ec 0c             	sub    $0xc,%esp
801065ae:	ff 75 f4             	pushl  -0xc(%ebp)
801065b1:	e8 14 b3 ff ff       	call   801018ca <ilock>
801065b6:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801065b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065c0:	66 83 f8 01          	cmp    $0x1,%ax
801065c4:	74 1a                	je     801065e0 <sys_chdir+0x79>
    iunlockput(ip);
801065c6:	83 ec 0c             	sub    $0xc,%esp
801065c9:	ff 75 f4             	pushl  -0xc(%ebp)
801065cc:	e8 b0 b5 ff ff       	call   80101b81 <iunlockput>
801065d1:	83 c4 10             	add    $0x10,%esp
    end_op();
801065d4:	e8 17 cf ff ff       	call   801034f0 <end_op>
    return -1;
801065d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065de:	eb 39                	jmp    80106619 <sys_chdir+0xb2>
  }
  iunlock(ip);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	ff 75 f4             	pushl  -0xc(%ebp)
801065e6:	e8 36 b4 ff ff       	call   80101a21 <iunlock>
801065eb:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801065ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065f4:	8b 40 68             	mov    0x68(%eax),%eax
801065f7:	83 ec 0c             	sub    $0xc,%esp
801065fa:	50                   	push   %eax
801065fb:	e8 92 b4 ff ff       	call   80101a92 <iput>
80106600:	83 c4 10             	add    $0x10,%esp
  end_op();
80106603:	e8 e8 ce ff ff       	call   801034f0 <end_op>
  proc->cwd = ip;
80106608:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010660e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106611:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106614:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106619:	c9                   	leave  
8010661a:	c3                   	ret    

8010661b <sys_exec>:

int
sys_exec(void)
{
8010661b:	55                   	push   %ebp
8010661c:	89 e5                	mov    %esp,%ebp
8010661e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106624:	83 ec 08             	sub    $0x8,%esp
80106627:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010662a:	50                   	push   %eax
8010662b:	6a 00                	push   $0x0
8010662d:	e8 9c f3 ff ff       	call   801059ce <argstr>
80106632:	83 c4 10             	add    $0x10,%esp
80106635:	85 c0                	test   %eax,%eax
80106637:	78 18                	js     80106651 <sys_exec+0x36>
80106639:	83 ec 08             	sub    $0x8,%esp
8010663c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106642:	50                   	push   %eax
80106643:	6a 01                	push   $0x1
80106645:	e8 fd f2 ff ff       	call   80105947 <argint>
8010664a:	83 c4 10             	add    $0x10,%esp
8010664d:	85 c0                	test   %eax,%eax
8010664f:	79 0a                	jns    8010665b <sys_exec+0x40>
    return -1;
80106651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106656:	e9 c6 00 00 00       	jmp    80106721 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010665b:	83 ec 04             	sub    $0x4,%esp
8010665e:	68 80 00 00 00       	push   $0x80
80106663:	6a 00                	push   $0x0
80106665:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010666b:	50                   	push   %eax
8010666c:	e8 af ef ff ff       	call   80105620 <memset>
80106671:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010667b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667e:	83 f8 1f             	cmp    $0x1f,%eax
80106681:	76 0a                	jbe    8010668d <sys_exec+0x72>
      return -1;
80106683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106688:	e9 94 00 00 00       	jmp    80106721 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010668d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106690:	c1 e0 02             	shl    $0x2,%eax
80106693:	89 c2                	mov    %eax,%edx
80106695:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010669b:	01 c2                	add    %eax,%edx
8010669d:	83 ec 08             	sub    $0x8,%esp
801066a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801066a6:	50                   	push   %eax
801066a7:	52                   	push   %edx
801066a8:	e8 fe f1 ff ff       	call   801058ab <fetchint>
801066ad:	83 c4 10             	add    $0x10,%esp
801066b0:	85 c0                	test   %eax,%eax
801066b2:	79 07                	jns    801066bb <sys_exec+0xa0>
      return -1;
801066b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b9:	eb 66                	jmp    80106721 <sys_exec+0x106>
    if(uarg == 0){
801066bb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801066c1:	85 c0                	test   %eax,%eax
801066c3:	75 27                	jne    801066ec <sys_exec+0xd1>
      argv[i] = 0;
801066c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c8:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801066cf:	00 00 00 00 
      break;
801066d3:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801066d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066d7:	83 ec 08             	sub    $0x8,%esp
801066da:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801066e0:	52                   	push   %edx
801066e1:	50                   	push   %eax
801066e2:	e8 68 a4 ff ff       	call   80100b4f <exec>
801066e7:	83 c4 10             	add    $0x10,%esp
801066ea:	eb 35                	jmp    80106721 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066ec:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066f5:	c1 e2 02             	shl    $0x2,%edx
801066f8:	01 c2                	add    %eax,%edx
801066fa:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106700:	83 ec 08             	sub    $0x8,%esp
80106703:	52                   	push   %edx
80106704:	50                   	push   %eax
80106705:	e8 db f1 ff ff       	call   801058e5 <fetchstr>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	85 c0                	test   %eax,%eax
8010670f:	79 07                	jns    80106718 <sys_exec+0xfd>
      return -1;
80106711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106716:	eb 09                	jmp    80106721 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106718:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010671c:	e9 5a ff ff ff       	jmp    8010667b <sys_exec+0x60>
  return exec(path, argv);
}
80106721:	c9                   	leave  
80106722:	c3                   	ret    

80106723 <sys_pipe>:

int
sys_pipe(void)
{
80106723:	55                   	push   %ebp
80106724:	89 e5                	mov    %esp,%ebp
80106726:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106729:	83 ec 04             	sub    $0x4,%esp
8010672c:	6a 08                	push   $0x8
8010672e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106731:	50                   	push   %eax
80106732:	6a 00                	push   $0x0
80106734:	e8 36 f2 ff ff       	call   8010596f <argptr>
80106739:	83 c4 10             	add    $0x10,%esp
8010673c:	85 c0                	test   %eax,%eax
8010673e:	79 0a                	jns    8010674a <sys_pipe+0x27>
    return -1;
80106740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106745:	e9 af 00 00 00       	jmp    801067f9 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010674a:	83 ec 08             	sub    $0x8,%esp
8010674d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106750:	50                   	push   %eax
80106751:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106754:	50                   	push   %eax
80106755:	e8 f5 d7 ff ff       	call   80103f4f <pipealloc>
8010675a:	83 c4 10             	add    $0x10,%esp
8010675d:	85 c0                	test   %eax,%eax
8010675f:	79 0a                	jns    8010676b <sys_pipe+0x48>
    return -1;
80106761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106766:	e9 8e 00 00 00       	jmp    801067f9 <sys_pipe+0xd6>
  fd0 = -1;
8010676b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106772:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106775:	83 ec 0c             	sub    $0xc,%esp
80106778:	50                   	push   %eax
80106779:	e8 7b f3 ff ff       	call   80105af9 <fdalloc>
8010677e:	83 c4 10             	add    $0x10,%esp
80106781:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106788:	78 18                	js     801067a2 <sys_pipe+0x7f>
8010678a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010678d:	83 ec 0c             	sub    $0xc,%esp
80106790:	50                   	push   %eax
80106791:	e8 63 f3 ff ff       	call   80105af9 <fdalloc>
80106796:	83 c4 10             	add    $0x10,%esp
80106799:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010679c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067a0:	79 3f                	jns    801067e1 <sys_pipe+0xbe>
    if(fd0 >= 0)
801067a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067a6:	78 14                	js     801067bc <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801067a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067b1:	83 c2 08             	add    $0x8,%edx
801067b4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067bb:	00 
    fileclose(rf);
801067bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067bf:	83 ec 0c             	sub    $0xc,%esp
801067c2:	50                   	push   %eax
801067c3:	e8 40 a8 ff ff       	call   80101008 <fileclose>
801067c8:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801067cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ce:	83 ec 0c             	sub    $0xc,%esp
801067d1:	50                   	push   %eax
801067d2:	e8 31 a8 ff ff       	call   80101008 <fileclose>
801067d7:	83 c4 10             	add    $0x10,%esp
    return -1;
801067da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067df:	eb 18                	jmp    801067f9 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801067e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067e7:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801067e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067ec:	8d 50 04             	lea    0x4(%eax),%edx
801067ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067f2:	89 02                	mov    %eax,(%edx)
  return 0;
801067f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067f9:	c9                   	leave  
801067fa:	c3                   	ret    

801067fb <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801067fb:	55                   	push   %ebp
801067fc:	89 e5                	mov    %esp,%ebp
801067fe:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106801:	e8 c1 df ff ff       	call   801047c7 <fork>
}
80106806:	c9                   	leave  
80106807:	c3                   	ret    

80106808 <sys_exit>:

int
sys_exit(void)
{
80106808:	55                   	push   %ebp
80106809:	89 e5                	mov    %esp,%ebp
8010680b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010680e:	e8 cb e1 ff ff       	call   801049de <exit>
  return 0;  // not reached
80106813:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106818:	c9                   	leave  
80106819:	c3                   	ret    

8010681a <sys_wait>:

int
sys_wait(void)
{
8010681a:	55                   	push   %ebp
8010681b:	89 e5                	mov    %esp,%ebp
8010681d:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106820:	e8 3e e3 ff ff       	call   80104b63 <wait>
}
80106825:	c9                   	leave  
80106826:	c3                   	ret    

80106827 <sys_kill>:

int
sys_kill(void)
{
80106827:	55                   	push   %ebp
80106828:	89 e5                	mov    %esp,%ebp
8010682a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010682d:	83 ec 08             	sub    $0x8,%esp
80106830:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106833:	50                   	push   %eax
80106834:	6a 00                	push   $0x0
80106836:	e8 0c f1 ff ff       	call   80105947 <argint>
8010683b:	83 c4 10             	add    $0x10,%esp
8010683e:	85 c0                	test   %eax,%eax
80106840:	79 07                	jns    80106849 <sys_kill+0x22>
    return -1;
80106842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106847:	eb 0f                	jmp    80106858 <sys_kill+0x31>
  return kill(pid);
80106849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684c:	83 ec 0c             	sub    $0xc,%esp
8010684f:	50                   	push   %eax
80106850:	e8 d4 e7 ff ff       	call   80105029 <kill>
80106855:	83 c4 10             	add    $0x10,%esp
}
80106858:	c9                   	leave  
80106859:	c3                   	ret    

8010685a <sys_getpid>:

int
sys_getpid(void)
{
8010685a:	55                   	push   %ebp
8010685b:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010685d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106863:	8b 40 10             	mov    0x10(%eax),%eax
}
80106866:	5d                   	pop    %ebp
80106867:	c3                   	ret    

80106868 <sys_sbrk>:

int
sys_sbrk(void)
{
80106868:	55                   	push   %ebp
80106869:	89 e5                	mov    %esp,%ebp
8010686b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010686e:	83 ec 08             	sub    $0x8,%esp
80106871:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106874:	50                   	push   %eax
80106875:	6a 00                	push   $0x0
80106877:	e8 cb f0 ff ff       	call   80105947 <argint>
8010687c:	83 c4 10             	add    $0x10,%esp
8010687f:	85 c0                	test   %eax,%eax
80106881:	79 07                	jns    8010688a <sys_sbrk+0x22>
    return -1;
80106883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106888:	eb 28                	jmp    801068b2 <sys_sbrk+0x4a>
  addr = proc->sz;
8010688a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106890:	8b 00                	mov    (%eax),%eax
80106892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106898:	83 ec 0c             	sub    $0xc,%esp
8010689b:	50                   	push   %eax
8010689c:	e8 83 de ff ff       	call   80104724 <growproc>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	85 c0                	test   %eax,%eax
801068a6:	79 07                	jns    801068af <sys_sbrk+0x47>
    return -1;
801068a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ad:	eb 03                	jmp    801068b2 <sys_sbrk+0x4a>
  return addr;
801068af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068b2:	c9                   	leave  
801068b3:	c3                   	ret    

801068b4 <sys_sleep>:

int
sys_sleep(void)
{
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801068ba:	83 ec 08             	sub    $0x8,%esp
801068bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068c0:	50                   	push   %eax
801068c1:	6a 00                	push   $0x0
801068c3:	e8 7f f0 ff ff       	call   80105947 <argint>
801068c8:	83 c4 10             	add    $0x10,%esp
801068cb:	85 c0                	test   %eax,%eax
801068cd:	79 07                	jns    801068d6 <sys_sleep+0x22>
    return -1;
801068cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d4:	eb 77                	jmp    8010694d <sys_sleep+0x99>
  acquire(&tickslock);
801068d6:	83 ec 0c             	sub    $0xc,%esp
801068d9:	68 c0 63 11 80       	push   $0x801163c0
801068de:	e8 e1 ea ff ff       	call   801053c4 <acquire>
801068e3:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801068e6:	a1 00 6c 11 80       	mov    0x80116c00,%eax
801068eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801068ee:	eb 39                	jmp    80106929 <sys_sleep+0x75>
    if(proc->killed){
801068f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f6:	8b 40 24             	mov    0x24(%eax),%eax
801068f9:	85 c0                	test   %eax,%eax
801068fb:	74 17                	je     80106914 <sys_sleep+0x60>
      release(&tickslock);
801068fd:	83 ec 0c             	sub    $0xc,%esp
80106900:	68 c0 63 11 80       	push   $0x801163c0
80106905:	e8 20 eb ff ff       	call   8010542a <release>
8010690a:	83 c4 10             	add    $0x10,%esp
      return -1;
8010690d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106912:	eb 39                	jmp    8010694d <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106914:	83 ec 08             	sub    $0x8,%esp
80106917:	68 c0 63 11 80       	push   $0x801163c0
8010691c:	68 00 6c 11 80       	push   $0x80116c00
80106921:	e8 aa e5 ff ff       	call   80104ed0 <sleep>
80106926:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106929:	a1 00 6c 11 80       	mov    0x80116c00,%eax
8010692e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106931:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106934:	39 d0                	cmp    %edx,%eax
80106936:	72 b8                	jb     801068f0 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106938:	83 ec 0c             	sub    $0xc,%esp
8010693b:	68 c0 63 11 80       	push   $0x801163c0
80106940:	e8 e5 ea ff ff       	call   8010542a <release>
80106945:	83 c4 10             	add    $0x10,%esp
  return 0;
80106948:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010694d:	c9                   	leave  
8010694e:	c3                   	ret    

8010694f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010694f:	55                   	push   %ebp
80106950:	89 e5                	mov    %esp,%ebp
80106952:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106955:	83 ec 0c             	sub    $0xc,%esp
80106958:	68 c0 63 11 80       	push   $0x801163c0
8010695d:	e8 62 ea ff ff       	call   801053c4 <acquire>
80106962:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106965:	a1 00 6c 11 80       	mov    0x80116c00,%eax
8010696a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010696d:	83 ec 0c             	sub    $0xc,%esp
80106970:	68 c0 63 11 80       	push   $0x801163c0
80106975:	e8 b0 ea ff ff       	call   8010542a <release>
8010697a:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010697d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106980:	c9                   	leave  
80106981:	c3                   	ret    

80106982 <sys_procstat>:

// Print a process listing to console. 
int
sys_procstat(void){  
80106982:	55                   	push   %ebp
80106983:	89 e5                	mov    %esp,%ebp
80106985:	83 ec 08             	sub    $0x8,%esp
  procdump();
80106988:	e8 3b e7 ff ff       	call   801050c8 <procdump>
  return 0;
8010698d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106992:	c9                   	leave  
80106993:	c3                   	ret    

80106994 <sys_set_priority>:

//change the priority
int
sys_set_priority(void){
80106994:	55                   	push   %ebp
80106995:	89 e5                	mov    %esp,%ebp
80106997:	83 ec 18             	sub    $0x18,%esp
  int priority;
  if(argint(0, &priority) < 0)
8010699a:	83 ec 08             	sub    $0x8,%esp
8010699d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069a0:	50                   	push   %eax
801069a1:	6a 00                	push   $0x0
801069a3:	e8 9f ef ff ff       	call   80105947 <argint>
801069a8:	83 c4 10             	add    $0x10,%esp
801069ab:	85 c0                	test   %eax,%eax
801069ad:	79 07                	jns    801069b6 <sys_set_priority+0x22>
    return -1; 
801069af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b4:	eb 2a                	jmp    801069e0 <sys_set_priority+0x4c>
  if (priority<0 || priority>MLF_SIZE-1)
801069b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069b9:	85 c0                	test   %eax,%eax
801069bb:	78 08                	js     801069c5 <sys_set_priority+0x31>
801069bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c0:	83 f8 03             	cmp    $0x3,%eax
801069c3:	7e 07                	jle    801069cc <sys_set_priority+0x38>
    return -1;   
801069c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ca:	eb 14                	jmp    801069e0 <sys_set_priority+0x4c>
  proc->priority = priority;
801069cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069d5:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
801069db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069e0:	c9                   	leave  
801069e1:	c3                   	ret    

801069e2 <belong>:
#include "spinlock.h"
#include "semaphore.h"

//private: true if semaphore belongs to proc
static int 
belong(int sem_id){
801069e2:	55                   	push   %ebp
801069e3:	89 e5                	mov    %esp,%ebp
801069e5:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
801069e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (i < MAXSEMPROC){
801069ef:	eb 20                	jmp    80106a11 <belong+0x2f>
    if (proc->sem[i] == sem_id){
801069f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069fa:	83 c2 20             	add    $0x20,%edx
801069fd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a01:	3b 45 08             	cmp    0x8(%ebp),%eax
80106a04:	75 07                	jne    80106a0d <belong+0x2b>
      return 1;
80106a06:	b8 01 00 00 00       	mov    $0x1,%eax
80106a0b:	eb 0f                	jmp    80106a1c <belong+0x3a>
    }
    i++;
80106a0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

//private: true if semaphore belongs to proc
static int 
belong(int sem_id){
  int i = 0;
  while (i < MAXSEMPROC){
80106a11:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
80106a15:	7e da                	jle    801069f1 <belong+0xf>
    if (proc->sem[i] == sem_id){
      return 1;
    }
    i++;
  }
  return 0;
80106a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a1c:	c9                   	leave  
80106a1d:	c3                   	ret    

80106a1e <sys_semget>:

//Create or obtain a descriptor of a semaphore.
int
sys_semget(void){ //int sem_id, int init_value
80106a1e:	55                   	push   %ebp
80106a1f:	89 e5                	mov    %esp,%ebp
80106a21:	83 ec 18             	sub    $0x18,%esp
  if (proc->squantity == MAXSEMPROC){
80106a24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a2a:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80106a30:	83 f8 05             	cmp    $0x5,%eax
80106a33:	75 0a                	jne    80106a3f <sys_semget+0x21>
    return -2;
80106a35:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80106a3a:	e9 89 00 00 00       	jmp    80106ac8 <sys_semget+0xaa>
  } else {
    int sem_id;
    if(argint(0, &sem_id) < 0)
80106a3f:	83 ec 08             	sub    $0x8,%esp
80106a42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a45:	50                   	push   %eax
80106a46:	6a 00                	push   $0x0
80106a48:	e8 fa ee ff ff       	call   80105947 <argint>
80106a4d:	83 c4 10             	add    $0x10,%esp
80106a50:	85 c0                	test   %eax,%eax
80106a52:	79 07                	jns    80106a5b <sys_semget+0x3d>
      return -4;  
80106a54:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106a59:	eb 6d                	jmp    80106ac8 <sys_semget+0xaa>
    int init_value;
    if(argint(1, &init_value) < 0)
80106a5b:	83 ec 08             	sub    $0x8,%esp
80106a5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a61:	50                   	push   %eax
80106a62:	6a 01                	push   $0x1
80106a64:	e8 de ee ff ff       	call   80105947 <argint>
80106a69:	83 c4 10             	add    $0x10,%esp
80106a6c:	85 c0                	test   %eax,%eax
80106a6e:	79 07                	jns    80106a77 <sys_semget+0x59>
      return -4;    
80106a70:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106a75:	eb 51                	jmp    80106ac8 <sys_semget+0xaa>
    int ret = semget(sem_id, init_value);
80106a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a7d:	83 ec 08             	sub    $0x8,%esp
80106a80:	52                   	push   %edx
80106a81:	50                   	push   %eax
80106a82:	e8 47 e7 ff ff       	call   801051ce <semget>
80106a87:	83 c4 10             	add    $0x10,%esp
80106a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ret>-1){ 
80106a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a91:	78 32                	js     80106ac5 <sys_semget+0xa7>
      proc->sem[proc->squantity] = ret;
80106a93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a99:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106aa0:	8b 92 9c 00 00 00    	mov    0x9c(%edx),%edx
80106aa6:	8d 4a 20             	lea    0x20(%edx),%ecx
80106aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106aac:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      proc->squantity++;
80106ab0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ab6:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80106abc:	83 c2 01             	add    $0x1,%edx
80106abf:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
    } 
    return ret;
80106ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  }  
}
80106ac8:	c9                   	leave  
80106ac9:	c3                   	ret    

80106aca <sys_semfree>:

//Releases the semaphore.
int
sys_semfree(void){ //int sem_id
80106aca:	55                   	push   %ebp
80106acb:	89 e5                	mov    %esp,%ebp
80106acd:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106ad0:	83 ec 08             	sub    $0x8,%esp
80106ad3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ad6:	50                   	push   %eax
80106ad7:	6a 00                	push   $0x0
80106ad9:	e8 69 ee ff ff       	call   80105947 <argint>
80106ade:	83 c4 10             	add    $0x10,%esp
80106ae1:	85 c0                	test   %eax,%eax
80106ae3:	79 0a                	jns    80106aef <sys_semfree+0x25>
    return -4;
80106ae5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106aea:	e9 94 00 00 00       	jmp    80106b83 <sys_semfree+0xb9>
  int i = 0;
80106aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (belong(sem_id)){
80106af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106af9:	83 ec 0c             	sub    $0xc,%esp
80106afc:	50                   	push   %eax
80106afd:	e8 e0 fe ff ff       	call   801069e2 <belong>
80106b02:	83 c4 10             	add    $0x10,%esp
80106b05:	85 c0                	test   %eax,%eax
80106b07:	74 75                	je     80106b7e <sys_semfree+0xb4>
    if (semfree(sem_id) == -1){
80106b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b0c:	83 ec 0c             	sub    $0xc,%esp
80106b0f:	50                   	push   %eax
80106b10:	e8 67 e7 ff ff       	call   8010527c <semfree>
80106b15:	83 c4 10             	add    $0x10,%esp
80106b18:	83 f8 ff             	cmp    $0xffffffff,%eax
80106b1b:	75 07                	jne    80106b24 <sys_semfree+0x5a>
      return -1;
80106b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b22:	eb 5f                	jmp    80106b83 <sys_semfree+0xb9>
    } else {
      for (i=i; i<proc->squantity-1;i++){
80106b24:	eb 28                	jmp    80106b4e <sys_semfree+0x84>
        proc->sem[i] = proc->sem[i+1];
80106b26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b2c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106b33:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106b36:	83 c1 01             	add    $0x1,%ecx
80106b39:	83 c1 20             	add    $0x20,%ecx
80106b3c:	8b 54 8a 08          	mov    0x8(%edx,%ecx,4),%edx
80106b40:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106b43:	83 c1 20             	add    $0x20,%ecx
80106b46:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
  int i = 0;
  if (belong(sem_id)){
    if (semfree(sem_id) == -1){
      return -1;
    } else {
      for (i=i; i<proc->squantity-1;i++){
80106b4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b54:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80106b5a:	83 e8 01             	sub    $0x1,%eax
80106b5d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106b60:	7f c4                	jg     80106b26 <sys_semfree+0x5c>
        proc->sem[i] = proc->sem[i+1];
      }
      proc->squantity--;
80106b62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b68:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80106b6e:	83 ea 01             	sub    $0x1,%edx
80106b71:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
      return 0;
80106b77:	b8 00 00 00 00       	mov    $0x0,%eax
80106b7c:	eb 05                	jmp    80106b83 <sys_semfree+0xb9>
    }
  }
  return -1;
80106b7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b83:	c9                   	leave  
80106b84:	c3                   	ret    

80106b85 <sys_semdown>:

//decrease the unit value of the semaphore
int
sys_semdown(void){ //int sem_id
80106b85:	55                   	push   %ebp
80106b86:	89 e5                	mov    %esp,%ebp
80106b88:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106b8b:	83 ec 08             	sub    $0x8,%esp
80106b8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b91:	50                   	push   %eax
80106b92:	6a 00                	push   $0x0
80106b94:	e8 ae ed ff ff       	call   80105947 <argint>
80106b99:	83 c4 10             	add    $0x10,%esp
80106b9c:	85 c0                	test   %eax,%eax
80106b9e:	79 07                	jns    80106ba7 <sys_semdown+0x22>
      return -4;  
80106ba0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106ba5:	eb 78                	jmp    80106c1f <sys_semdown+0x9a>
  if (belong(sem_id)){
80106ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	50                   	push   %eax
80106bae:	e8 2f fe ff ff       	call   801069e2 <belong>
80106bb3:	83 c4 10             	add    $0x10,%esp
80106bb6:	85 c0                	test   %eax,%eax
80106bb8:	74 60                	je     80106c1a <sys_semdown+0x95>
    acquire(&stable.lock);
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 60 63 11 80       	push   $0x80116360
80106bc2:	e8 fd e7 ff ff       	call   801053c4 <acquire>
80106bc7:	83 c4 10             	add    $0x10,%esp
    while(stable.semaphore[sem_id].value == 0)
80106bca:	eb 1a                	jmp    80106be6 <sys_semdown+0x61>
      sleep(proc->chan, &stable.lock);
80106bcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd2:	8b 40 20             	mov    0x20(%eax),%eax
80106bd5:	83 ec 08             	sub    $0x8,%esp
80106bd8:	68 60 63 11 80       	push   $0x80116360
80106bdd:	50                   	push   %eax
80106bde:	e8 ed e2 ff ff       	call   80104ed0 <sleep>
80106be3:	83 c4 10             	add    $0x10,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -4;  
  if (belong(sem_id)){
    acquire(&stable.lock);
    while(stable.semaphore[sem_id].value == 0)
80106be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be9:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80106bf0:	85 c0                	test   %eax,%eax
80106bf2:	74 d8                	je     80106bcc <sys_semdown+0x47>
      sleep(proc->chan, &stable.lock);
    semdown(sem_id);
80106bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf7:	83 ec 0c             	sub    $0xc,%esp
80106bfa:	50                   	push   %eax
80106bfb:	e8 f3 e6 ff ff       	call   801052f3 <semdown>
80106c00:	83 c4 10             	add    $0x10,%esp
    release(&stable.lock);
80106c03:	83 ec 0c             	sub    $0xc,%esp
80106c06:	68 60 63 11 80       	push   $0x80116360
80106c0b:	e8 1a e8 ff ff       	call   8010542a <release>
80106c10:	83 c4 10             	add    $0x10,%esp
    return 0;
80106c13:	b8 00 00 00 00       	mov    $0x0,%eax
80106c18:	eb 05                	jmp    80106c1f <sys_semdown+0x9a>
  }
  return -1;  
80106c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c1f:	c9                   	leave  
80106c20:	c3                   	ret    

80106c21 <sys_semup>:

//Increase the unit value of the semaphore
int
sys_semup(void){ //int sem_id
80106c21:	55                   	push   %ebp
80106c22:	89 e5                	mov    %esp,%ebp
80106c24:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106c27:	83 ec 08             	sub    $0x8,%esp
80106c2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c2d:	50                   	push   %eax
80106c2e:	6a 00                	push   $0x0
80106c30:	e8 12 ed ff ff       	call   80105947 <argint>
80106c35:	83 c4 10             	add    $0x10,%esp
80106c38:	85 c0                	test   %eax,%eax
80106c3a:	79 07                	jns    80106c43 <sys_semup+0x22>
      return -1;
80106c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c41:	eb 4f                	jmp    80106c92 <sys_semup+0x71>
  if (belong(sem_id)){    
80106c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c46:	83 ec 0c             	sub    $0xc,%esp
80106c49:	50                   	push   %eax
80106c4a:	e8 93 fd ff ff       	call   801069e2 <belong>
80106c4f:	83 c4 10             	add    $0x10,%esp
80106c52:	85 c0                	test   %eax,%eax
80106c54:	74 37                	je     80106c8d <sys_semup+0x6c>
    if (semup(sem_id) == -1)
80106c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c59:	83 ec 0c             	sub    $0xc,%esp
80106c5c:	50                   	push   %eax
80106c5d:	e8 b2 e6 ff ff       	call   80105314 <semup>
80106c62:	83 c4 10             	add    $0x10,%esp
80106c65:	83 f8 ff             	cmp    $0xffffffff,%eax
80106c68:	75 07                	jne    80106c71 <sys_semup+0x50>
      return -1;
80106c6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6f:	eb 21                	jmp    80106c92 <sys_semup+0x71>
    else {
      wakeup(proc->chan);
80106c71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c77:	8b 40 20             	mov    0x20(%eax),%eax
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	50                   	push   %eax
80106c7e:	e8 70 e3 ff ff       	call   80104ff3 <wakeup>
80106c83:	83 c4 10             	add    $0x10,%esp
      return 0;
80106c86:	b8 00 00 00 00       	mov    $0x0,%eax
80106c8b:	eb 05                	jmp    80106c92 <sys_semup+0x71>
    }
  }   
  return -1;
80106c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c92:	c9                   	leave  
80106c93:	c3                   	ret    

80106c94 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106c94:	55                   	push   %ebp
80106c95:	89 e5                	mov    %esp,%ebp
80106c97:	83 ec 08             	sub    $0x8,%esp
80106c9a:	8b 55 08             	mov    0x8(%ebp),%edx
80106c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ca0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ca4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ca7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106cab:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106caf:	ee                   	out    %al,(%dx)
}
80106cb0:	c9                   	leave  
80106cb1:	c3                   	ret    

80106cb2 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106cb2:	55                   	push   %ebp
80106cb3:	89 e5                	mov    %esp,%ebp
80106cb5:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106cb8:	6a 34                	push   $0x34
80106cba:	6a 43                	push   $0x43
80106cbc:	e8 d3 ff ff ff       	call   80106c94 <outb>
80106cc1:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106cc4:	68 9c 00 00 00       	push   $0x9c
80106cc9:	6a 40                	push   $0x40
80106ccb:	e8 c4 ff ff ff       	call   80106c94 <outb>
80106cd0:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106cd3:	6a 2e                	push   $0x2e
80106cd5:	6a 40                	push   $0x40
80106cd7:	e8 b8 ff ff ff       	call   80106c94 <outb>
80106cdc:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106cdf:	83 ec 0c             	sub    $0xc,%esp
80106ce2:	6a 00                	push   $0x0
80106ce4:	e8 52 d1 ff ff       	call   80103e3b <picenable>
80106ce9:	83 c4 10             	add    $0x10,%esp
}
80106cec:	c9                   	leave  
80106ced:	c3                   	ret    

80106cee <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106cee:	1e                   	push   %ds
  pushl %es
80106cef:	06                   	push   %es
  pushl %fs
80106cf0:	0f a0                	push   %fs
  pushl %gs
80106cf2:	0f a8                	push   %gs
  pushal
80106cf4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106cf5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106cf9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106cfb:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106cfd:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d01:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d03:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d05:	54                   	push   %esp
  call trap
80106d06:	e8 d4 01 00 00       	call   80106edf <trap>
  addl $4, %esp
80106d0b:	83 c4 04             	add    $0x4,%esp

80106d0e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d0e:	61                   	popa   
  popl %gs
80106d0f:	0f a9                	pop    %gs
  popl %fs
80106d11:	0f a1                	pop    %fs
  popl %es
80106d13:	07                   	pop    %es
  popl %ds
80106d14:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d15:	83 c4 08             	add    $0x8,%esp
  iret
80106d18:	cf                   	iret   

80106d19 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d19:	55                   	push   %ebp
80106d1a:	89 e5                	mov    %esp,%ebp
80106d1c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d22:	83 e8 01             	sub    $0x1,%eax
80106d25:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d29:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d30:	8b 45 08             	mov    0x8(%ebp),%eax
80106d33:	c1 e8 10             	shr    $0x10,%eax
80106d36:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106d3a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d3d:	0f 01 18             	lidtl  (%eax)
}
80106d40:	c9                   	leave  
80106d41:	c3                   	ret    

80106d42 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106d42:	55                   	push   %ebp
80106d43:	89 e5                	mov    %esp,%ebp
80106d45:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d48:	0f 20 d0             	mov    %cr2,%eax
80106d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d51:	c9                   	leave  
80106d52:	c3                   	ret    

80106d53 <tvinit>:
uint ticks;
int i=0;

void
tvinit(void)
{
80106d53:	55                   	push   %ebp
80106d54:	89 e5                	mov    %esp,%ebp
80106d56:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d60:	e9 c3 00 00 00       	jmp    80106e28 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d68:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106d6f:	89 c2                	mov    %eax,%edx
80106d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d74:	66 89 14 c5 00 64 11 	mov    %dx,-0x7fee9c00(,%eax,8)
80106d7b:	80 
80106d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d7f:	66 c7 04 c5 02 64 11 	movw   $0x8,-0x7fee9bfe(,%eax,8)
80106d86:	80 08 00 
80106d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d8c:	0f b6 14 c5 04 64 11 	movzbl -0x7fee9bfc(,%eax,8),%edx
80106d93:	80 
80106d94:	83 e2 e0             	and    $0xffffffe0,%edx
80106d97:	88 14 c5 04 64 11 80 	mov    %dl,-0x7fee9bfc(,%eax,8)
80106d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106da1:	0f b6 14 c5 04 64 11 	movzbl -0x7fee9bfc(,%eax,8),%edx
80106da8:	80 
80106da9:	83 e2 1f             	and    $0x1f,%edx
80106dac:	88 14 c5 04 64 11 80 	mov    %dl,-0x7fee9bfc(,%eax,8)
80106db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db6:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dbd:	80 
80106dbe:	83 e2 f0             	and    $0xfffffff0,%edx
80106dc1:	83 ca 0e             	or     $0xe,%edx
80106dc4:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dce:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dd5:	80 
80106dd6:	83 e2 ef             	and    $0xffffffef,%edx
80106dd9:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106de3:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dea:	80 
80106deb:	83 e2 9f             	and    $0xffffff9f,%edx
80106dee:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df8:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dff:	80 
80106e00:	83 ca 80             	or     $0xffffff80,%edx
80106e03:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0d:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106e14:	c1 e8 10             	shr    $0x10,%eax
80106e17:	89 c2                	mov    %eax,%edx
80106e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e1c:	66 89 14 c5 06 64 11 	mov    %dx,-0x7fee9bfa(,%eax,8)
80106e23:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e28:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e2f:	0f 8e 30 ff ff ff    	jle    80106d65 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e35:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106e3a:	66 a3 00 66 11 80    	mov    %ax,0x80116600
80106e40:	66 c7 05 02 66 11 80 	movw   $0x8,0x80116602
80106e47:	08 00 
80106e49:	0f b6 05 04 66 11 80 	movzbl 0x80116604,%eax
80106e50:	83 e0 e0             	and    $0xffffffe0,%eax
80106e53:	a2 04 66 11 80       	mov    %al,0x80116604
80106e58:	0f b6 05 04 66 11 80 	movzbl 0x80116604,%eax
80106e5f:	83 e0 1f             	and    $0x1f,%eax
80106e62:	a2 04 66 11 80       	mov    %al,0x80116604
80106e67:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e6e:	83 c8 0f             	or     $0xf,%eax
80106e71:	a2 05 66 11 80       	mov    %al,0x80116605
80106e76:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e7d:	83 e0 ef             	and    $0xffffffef,%eax
80106e80:	a2 05 66 11 80       	mov    %al,0x80116605
80106e85:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e8c:	83 c8 60             	or     $0x60,%eax
80106e8f:	a2 05 66 11 80       	mov    %al,0x80116605
80106e94:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e9b:	83 c8 80             	or     $0xffffff80,%eax
80106e9e:	a2 05 66 11 80       	mov    %al,0x80116605
80106ea3:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106ea8:	c1 e8 10             	shr    $0x10,%eax
80106eab:	66 a3 06 66 11 80    	mov    %ax,0x80116606
  
  initlock(&tickslock, "time");
80106eb1:	83 ec 08             	sub    $0x8,%esp
80106eb4:	68 28 91 10 80       	push   $0x80109128
80106eb9:	68 c0 63 11 80       	push   $0x801163c0
80106ebe:	e8 e0 e4 ff ff       	call   801053a3 <initlock>
80106ec3:	83 c4 10             	add    $0x10,%esp
}
80106ec6:	c9                   	leave  
80106ec7:	c3                   	ret    

80106ec8 <idtinit>:

void
idtinit(void)
{
80106ec8:	55                   	push   %ebp
80106ec9:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106ecb:	68 00 08 00 00       	push   $0x800
80106ed0:	68 00 64 11 80       	push   $0x80116400
80106ed5:	e8 3f fe ff ff       	call   80106d19 <lidt>
80106eda:	83 c4 08             	add    $0x8,%esp
}
80106edd:	c9                   	leave  
80106ede:	c3                   	ret    

80106edf <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106edf:	55                   	push   %ebp
80106ee0:	89 e5                	mov    %esp,%ebp
80106ee2:	57                   	push   %edi
80106ee3:	56                   	push   %esi
80106ee4:	53                   	push   %ebx
80106ee5:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80106eeb:	8b 40 30             	mov    0x30(%eax),%eax
80106eee:	83 f8 40             	cmp    $0x40,%eax
80106ef1:	75 3f                	jne    80106f32 <trap+0x53>
    if(proc->killed)
80106ef3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ef9:	8b 40 24             	mov    0x24(%eax),%eax
80106efc:	85 c0                	test   %eax,%eax
80106efe:	74 05                	je     80106f05 <trap+0x26>
      exit();
80106f00:	e8 d9 da ff ff       	call   801049de <exit>
    proc->tf = tf;
80106f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f0b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f0e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f11:	e8 e9 ea ff ff       	call   801059ff <syscall>
    if(proc->killed)
80106f16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1c:	8b 40 24             	mov    0x24(%eax),%eax
80106f1f:	85 c0                	test   %eax,%eax
80106f21:	74 0a                	je     80106f2d <trap+0x4e>
      exit();
80106f23:	e8 b6 da ff ff       	call   801049de <exit>
    return;
80106f28:	e9 20 03 00 00       	jmp    8010724d <trap+0x36e>
80106f2d:	e9 1b 03 00 00       	jmp    8010724d <trap+0x36e>
  }

  switch(tf->trapno){
80106f32:	8b 45 08             	mov    0x8(%ebp),%eax
80106f35:	8b 40 30             	mov    0x30(%eax),%eax
80106f38:	83 e8 0e             	sub    $0xe,%eax
80106f3b:	83 f8 31             	cmp    $0x31,%eax
80106f3e:	0f 87 af 01 00 00    	ja     801070f3 <trap+0x214>
80106f44:	8b 04 85 d0 91 10 80 	mov    -0x7fef6e30(,%eax,4),%eax
80106f4b:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106f4d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f53:	0f b6 00             	movzbl (%eax),%eax
80106f56:	84 c0                	test   %al,%al
80106f58:	75 3d                	jne    80106f97 <trap+0xb8>
      acquire(&tickslock);
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	68 c0 63 11 80       	push   $0x801163c0
80106f62:	e8 5d e4 ff ff       	call   801053c4 <acquire>
80106f67:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106f6a:	a1 00 6c 11 80       	mov    0x80116c00,%eax
80106f6f:	83 c0 01             	add    $0x1,%eax
80106f72:	a3 00 6c 11 80       	mov    %eax,0x80116c00
      wakeup(&ticks);
80106f77:	83 ec 0c             	sub    $0xc,%esp
80106f7a:	68 00 6c 11 80       	push   $0x80116c00
80106f7f:	e8 6f e0 ff ff       	call   80104ff3 <wakeup>
80106f84:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106f87:	83 ec 0c             	sub    $0xc,%esp
80106f8a:	68 c0 63 11 80       	push   $0x801163c0
80106f8f:	e8 96 e4 ff ff       	call   8010542a <release>
80106f94:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106f97:	e8 9f bf ff ff       	call   80102f3b <lapiceoi>
    break;
80106f9c:	e9 0b 02 00 00       	jmp    801071ac <trap+0x2cd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106fa1:	e8 b6 b7 ff ff       	call   8010275c <ideintr>
    lapiceoi();
80106fa6:	e8 90 bf ff ff       	call   80102f3b <lapiceoi>
    break;
80106fab:	e9 fc 01 00 00       	jmp    801071ac <trap+0x2cd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106fb0:	e8 8d bd ff ff       	call   80102d42 <kbdintr>
    lapiceoi();
80106fb5:	e8 81 bf ff ff       	call   80102f3b <lapiceoi>
    break;
80106fba:	e9 ed 01 00 00       	jmp    801071ac <trap+0x2cd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106fbf:	e8 66 04 00 00       	call   8010742a <uartintr>
    lapiceoi();
80106fc4:	e8 72 bf ff ff       	call   80102f3b <lapiceoi>
    break;
80106fc9:	e9 de 01 00 00       	jmp    801071ac <trap+0x2cd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fce:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fdb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106fde:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fe4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fe7:	0f b6 c0             	movzbl %al,%eax
80106fea:	51                   	push   %ecx
80106feb:	52                   	push   %edx
80106fec:	50                   	push   %eax
80106fed:	68 30 91 10 80       	push   $0x80109130
80106ff2:	e8 c8 93 ff ff       	call   801003bf <cprintf>
80106ff7:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106ffa:	e8 3c bf ff ff       	call   80102f3b <lapiceoi>
    break;
80106fff:	e9 a8 01 00 00       	jmp    801071ac <trap+0x2cd>
    case T_PGFLT:
      //if rcr2 is lower than the top of page and rcr2 is greater than the top more 32 bits 
      //and rcr2 is between designated size and  the process.
      if (proc && rcr2() >= PGROUNDUP(rcr2())-32  && rcr2() <= proc->sz && rcr2()>= proc->sz- MAXPAGES*PGSIZE )
80107004:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010700a:	85 c0                	test   %eax,%eax
8010700c:	0f 84 81 00 00 00    	je     80107093 <trap+0x1b4>
80107012:	e8 2b fd ff ff       	call   80106d42 <rcr2>
80107017:	89 c3                	mov    %eax,%ebx
80107019:	e8 24 fd ff ff       	call   80106d42 <rcr2>
8010701e:	05 ff 0f 00 00       	add    $0xfff,%eax
80107023:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107028:	83 e8 20             	sub    $0x20,%eax
8010702b:	39 c3                	cmp    %eax,%ebx
8010702d:	72 64                	jb     80107093 <trap+0x1b4>
8010702f:	e8 0e fd ff ff       	call   80106d42 <rcr2>
80107034:	89 c2                	mov    %eax,%edx
80107036:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010703c:	8b 00                	mov    (%eax),%eax
8010703e:	39 c2                	cmp    %eax,%edx
80107040:	77 51                	ja     80107093 <trap+0x1b4>
80107042:	e8 fb fc ff ff       	call   80106d42 <rcr2>
80107047:	89 c2                	mov    %eax,%edx
80107049:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010704f:	8b 00                	mov    (%eax),%eax
80107051:	2d 00 30 00 00       	sub    $0x3000,%eax
80107056:	39 c2                	cmp    %eax,%edx
80107058:	72 39                	jb     80107093 <trap+0x1b4>
        allocuvm(proc->pgdir, PGROUNDDOWN(rcr2()), PGROUNDUP(rcr2()));
8010705a:	e8 e3 fc ff ff       	call   80106d42 <rcr2>
8010705f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107069:	89 c3                	mov    %eax,%ebx
8010706b:	e8 d2 fc ff ff       	call   80106d42 <rcr2>
80107070:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107075:	89 c2                	mov    %eax,%edx
80107077:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010707d:	8b 40 04             	mov    0x4(%eax),%eax
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	53                   	push   %ebx
80107084:	52                   	push   %edx
80107085:	50                   	push   %eax
80107086:	e8 d2 17 00 00       	call   8010885d <allocuvm>
8010708b:	83 c4 10             	add    $0x10,%esp
                "eip 0x%x addr 0x%x--kill proc\n",
                proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
                rcr2());
        proc->killed = 1;
      }
      break;
8010708e:	e9 19 01 00 00       	jmp    801071ac <trap+0x2cd>
      //if rcr2 is lower than the top of page and rcr2 is greater than the top more 32 bits 
      //and rcr2 is between designated size and  the process.
      if (proc && rcr2() >= PGROUNDUP(rcr2())-32  && rcr2() <= proc->sz && rcr2()>= proc->sz- MAXPAGES*PGSIZE )
        allocuvm(proc->pgdir, PGROUNDDOWN(rcr2()), PGROUNDUP(rcr2()));
      else{
        cprintf("pid %d %s: trap %d err %d on cpu %d "
80107093:	e8 aa fc ff ff       	call   80106d42 <rcr2>
80107098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010709b:	8b 45 08             	mov    0x8(%ebp),%eax
8010709e:	8b 70 38             	mov    0x38(%eax),%esi
                "eip 0x%x addr 0x%x--kill proc\n",
                proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070a1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070a7:	0f b6 00             	movzbl (%eax),%eax
      //if rcr2 is lower than the top of page and rcr2 is greater than the top more 32 bits 
      //and rcr2 is between designated size and  the process.
      if (proc && rcr2() >= PGROUNDUP(rcr2())-32  && rcr2() <= proc->sz && rcr2()>= proc->sz- MAXPAGES*PGSIZE )
        allocuvm(proc->pgdir, PGROUNDDOWN(rcr2()), PGROUNDUP(rcr2()));
      else{
        cprintf("pid %d %s: trap %d err %d on cpu %d "
801070aa:	0f b6 d8             	movzbl %al,%ebx
801070ad:	8b 45 08             	mov    0x8(%ebp),%eax
801070b0:	8b 48 34             	mov    0x34(%eax),%ecx
801070b3:	8b 45 08             	mov    0x8(%ebp),%eax
801070b6:	8b 50 30             	mov    0x30(%eax),%edx
                "eip 0x%x addr 0x%x--kill proc\n",
                proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070bf:	8d 78 6c             	lea    0x6c(%eax),%edi
801070c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      //if rcr2 is lower than the top of page and rcr2 is greater than the top more 32 bits 
      //and rcr2 is between designated size and  the process.
      if (proc && rcr2() >= PGROUNDUP(rcr2())-32  && rcr2() <= proc->sz && rcr2()>= proc->sz- MAXPAGES*PGSIZE )
        allocuvm(proc->pgdir, PGROUNDDOWN(rcr2()), PGROUNDUP(rcr2()));
      else{
        cprintf("pid %d %s: trap %d err %d on cpu %d "
801070c8:	8b 40 10             	mov    0x10(%eax),%eax
801070cb:	ff 75 e4             	pushl  -0x1c(%ebp)
801070ce:	56                   	push   %esi
801070cf:	53                   	push   %ebx
801070d0:	51                   	push   %ecx
801070d1:	52                   	push   %edx
801070d2:	57                   	push   %edi
801070d3:	50                   	push   %eax
801070d4:	68 54 91 10 80       	push   $0x80109154
801070d9:	e8 e1 92 ff ff       	call   801003bf <cprintf>
801070de:	83 c4 20             	add    $0x20,%esp
                "eip 0x%x addr 0x%x--kill proc\n",
                proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
                rcr2());
        proc->killed = 1;
801070e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      }
      break;
801070ee:	e9 b9 00 00 00       	jmp    801071ac <trap+0x2cd>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801070f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f9:	85 c0                	test   %eax,%eax
801070fb:	74 11                	je     8010710e <trap+0x22f>
801070fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107100:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107104:	0f b7 c0             	movzwl %ax,%eax
80107107:	83 e0 03             	and    $0x3,%eax
8010710a:	85 c0                	test   %eax,%eax
8010710c:	75 40                	jne    8010714e <trap+0x26f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010710e:	e8 2f fc ff ff       	call   80106d42 <rcr2>
80107113:	89 c3                	mov    %eax,%ebx
80107115:	8b 45 08             	mov    0x8(%ebp),%eax
80107118:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010711b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107121:	0f b6 00             	movzbl (%eax),%eax

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107124:	0f b6 d0             	movzbl %al,%edx
80107127:	8b 45 08             	mov    0x8(%ebp),%eax
8010712a:	8b 40 30             	mov    0x30(%eax),%eax
8010712d:	83 ec 0c             	sub    $0xc,%esp
80107130:	53                   	push   %ebx
80107131:	51                   	push   %ecx
80107132:	52                   	push   %edx
80107133:	50                   	push   %eax
80107134:	68 98 91 10 80       	push   $0x80109198
80107139:	e8 81 92 ff ff       	call   801003bf <cprintf>
8010713e:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107141:	83 ec 0c             	sub    $0xc,%esp
80107144:	68 ca 91 10 80       	push   $0x801091ca
80107149:	e8 0e 94 ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010714e:	e8 ef fb ff ff       	call   80106d42 <rcr2>
80107153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107156:	8b 45 08             	mov    0x8(%ebp),%eax
80107159:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010715c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107162:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107165:	0f b6 d8             	movzbl %al,%ebx
80107168:	8b 45 08             	mov    0x8(%ebp),%eax
8010716b:	8b 48 34             	mov    0x34(%eax),%ecx
8010716e:	8b 45 08             	mov    0x8(%ebp),%eax
80107171:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107174:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010717a:	8d 78 6c             	lea    0x6c(%eax),%edi
8010717d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107183:	8b 40 10             	mov    0x10(%eax),%eax
80107186:	ff 75 e4             	pushl  -0x1c(%ebp)
80107189:	56                   	push   %esi
8010718a:	53                   	push   %ebx
8010718b:	51                   	push   %ecx
8010718c:	52                   	push   %edx
8010718d:	57                   	push   %edi
8010718e:	50                   	push   %eax
8010718f:	68 54 91 10 80       	push   $0x80109154
80107194:	e8 26 92 ff ff       	call   801003bf <cprintf>
80107199:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
             rcr2());
    proc->killed = 1;
8010719c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071a2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801071a9:	eb 01                	jmp    801071ac <trap+0x2cd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801071ab:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071b2:	85 c0                	test   %eax,%eax
801071b4:	74 24                	je     801071da <trap+0x2fb>
801071b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071bc:	8b 40 24             	mov    0x24(%eax),%eax
801071bf:	85 c0                	test   %eax,%eax
801071c1:	74 17                	je     801071da <trap+0x2fb>
801071c3:	8b 45 08             	mov    0x8(%ebp),%eax
801071c6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071ca:	0f b7 c0             	movzwl %ax,%eax
801071cd:	83 e0 03             	and    $0x3,%eax
801071d0:	83 f8 03             	cmp    $0x3,%eax
801071d3:	75 05                	jne    801071da <trap+0x2fb>
    exit();
801071d5:	e8 04 d8 ff ff       	call   801049de <exit>

  // Force process to give up CPU on third clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801071da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071e0:	85 c0                	test   %eax,%eax
801071e2:	74 3b                	je     8010721f <trap+0x340>
801071e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071ea:	8b 40 0c             	mov    0xc(%eax),%eax
801071ed:	83 f8 04             	cmp    $0x4,%eax
801071f0:	75 2d                	jne    8010721f <trap+0x340>
801071f2:	8b 45 08             	mov    0x8(%ebp),%eax
801071f5:	8b 40 30             	mov    0x30(%eax),%eax
801071f8:	83 f8 20             	cmp    $0x20,%eax
801071fb:	75 22                	jne    8010721f <trap+0x340>
    proc->quantum++;   // increases the quantum ticks counter
801071fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107203:	8b 50 7c             	mov    0x7c(%eax),%edx
80107206:	83 c2 01             	add    $0x1,%edx
80107209:	89 50 7c             	mov    %edx,0x7c(%eax)
    if (proc->quantum >= QUANTUM){ 
8010720c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107212:	8b 40 7c             	mov    0x7c(%eax),%eax
80107215:	83 f8 02             	cmp    $0x2,%eax
80107218:	7e 05                	jle    8010721f <trap+0x340>
      yield();
8010721a:	e8 fb db ff ff       	call   80104e1a <yield>
    }
  }   

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010721f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107225:	85 c0                	test   %eax,%eax
80107227:	74 24                	je     8010724d <trap+0x36e>
80107229:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010722f:	8b 40 24             	mov    0x24(%eax),%eax
80107232:	85 c0                	test   %eax,%eax
80107234:	74 17                	je     8010724d <trap+0x36e>
80107236:	8b 45 08             	mov    0x8(%ebp),%eax
80107239:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010723d:	0f b7 c0             	movzwl %ax,%eax
80107240:	83 e0 03             	and    $0x3,%eax
80107243:	83 f8 03             	cmp    $0x3,%eax
80107246:	75 05                	jne    8010724d <trap+0x36e>
    exit();
80107248:	e8 91 d7 ff ff       	call   801049de <exit>
}
8010724d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107250:	5b                   	pop    %ebx
80107251:	5e                   	pop    %esi
80107252:	5f                   	pop    %edi
80107253:	5d                   	pop    %ebp
80107254:	c3                   	ret    

80107255 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107255:	55                   	push   %ebp
80107256:	89 e5                	mov    %esp,%ebp
80107258:	83 ec 14             	sub    $0x14,%esp
8010725b:	8b 45 08             	mov    0x8(%ebp),%eax
8010725e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107262:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107266:	89 c2                	mov    %eax,%edx
80107268:	ec                   	in     (%dx),%al
80107269:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010726c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107270:	c9                   	leave  
80107271:	c3                   	ret    

80107272 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107272:	55                   	push   %ebp
80107273:	89 e5                	mov    %esp,%ebp
80107275:	83 ec 08             	sub    $0x8,%esp
80107278:	8b 55 08             	mov    0x8(%ebp),%edx
8010727b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107282:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107285:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107289:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010728d:	ee                   	out    %al,(%dx)
}
8010728e:	c9                   	leave  
8010728f:	c3                   	ret    

80107290 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107296:	6a 00                	push   $0x0
80107298:	68 fa 03 00 00       	push   $0x3fa
8010729d:	e8 d0 ff ff ff       	call   80107272 <outb>
801072a2:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801072a5:	68 80 00 00 00       	push   $0x80
801072aa:	68 fb 03 00 00       	push   $0x3fb
801072af:	e8 be ff ff ff       	call   80107272 <outb>
801072b4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801072b7:	6a 0c                	push   $0xc
801072b9:	68 f8 03 00 00       	push   $0x3f8
801072be:	e8 af ff ff ff       	call   80107272 <outb>
801072c3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801072c6:	6a 00                	push   $0x0
801072c8:	68 f9 03 00 00       	push   $0x3f9
801072cd:	e8 a0 ff ff ff       	call   80107272 <outb>
801072d2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072d5:	6a 03                	push   $0x3
801072d7:	68 fb 03 00 00       	push   $0x3fb
801072dc:	e8 91 ff ff ff       	call   80107272 <outb>
801072e1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801072e4:	6a 00                	push   $0x0
801072e6:	68 fc 03 00 00       	push   $0x3fc
801072eb:	e8 82 ff ff ff       	call   80107272 <outb>
801072f0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072f3:	6a 01                	push   $0x1
801072f5:	68 f9 03 00 00       	push   $0x3f9
801072fa:	e8 73 ff ff ff       	call   80107272 <outb>
801072ff:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107302:	68 fd 03 00 00       	push   $0x3fd
80107307:	e8 49 ff ff ff       	call   80107255 <inb>
8010730c:	83 c4 04             	add    $0x4,%esp
8010730f:	3c ff                	cmp    $0xff,%al
80107311:	75 02                	jne    80107315 <uartinit+0x85>
    return;
80107313:	eb 6c                	jmp    80107381 <uartinit+0xf1>
  uart = 1;
80107315:	c7 05 70 c6 10 80 01 	movl   $0x1,0x8010c670
8010731c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010731f:	68 fa 03 00 00       	push   $0x3fa
80107324:	e8 2c ff ff ff       	call   80107255 <inb>
80107329:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010732c:	68 f8 03 00 00       	push   $0x3f8
80107331:	e8 1f ff ff ff       	call   80107255 <inb>
80107336:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107339:	83 ec 0c             	sub    $0xc,%esp
8010733c:	6a 04                	push   $0x4
8010733e:	e8 f8 ca ff ff       	call   80103e3b <picenable>
80107343:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107346:	83 ec 08             	sub    $0x8,%esp
80107349:	6a 00                	push   $0x0
8010734b:	6a 04                	push   $0x4
8010734d:	e8 a8 b6 ff ff       	call   801029fa <ioapicenable>
80107352:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107355:	c7 45 f4 98 92 10 80 	movl   $0x80109298,-0xc(%ebp)
8010735c:	eb 19                	jmp    80107377 <uartinit+0xe7>
    uartputc(*p);
8010735e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107361:	0f b6 00             	movzbl (%eax),%eax
80107364:	0f be c0             	movsbl %al,%eax
80107367:	83 ec 0c             	sub    $0xc,%esp
8010736a:	50                   	push   %eax
8010736b:	e8 13 00 00 00       	call   80107383 <uartputc>
80107370:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107373:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737a:	0f b6 00             	movzbl (%eax),%eax
8010737d:	84 c0                	test   %al,%al
8010737f:	75 dd                	jne    8010735e <uartinit+0xce>
    uartputc(*p);
}
80107381:	c9                   	leave  
80107382:	c3                   	ret    

80107383 <uartputc>:

void
uartputc(int c)
{
80107383:	55                   	push   %ebp
80107384:	89 e5                	mov    %esp,%ebp
80107386:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107389:	a1 70 c6 10 80       	mov    0x8010c670,%eax
8010738e:	85 c0                	test   %eax,%eax
80107390:	75 02                	jne    80107394 <uartputc+0x11>
    return;
80107392:	eb 51                	jmp    801073e5 <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010739b:	eb 11                	jmp    801073ae <uartputc+0x2b>
    microdelay(10);
8010739d:	83 ec 0c             	sub    $0xc,%esp
801073a0:	6a 0a                	push   $0xa
801073a2:	e8 ae bb ff ff       	call   80102f55 <microdelay>
801073a7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801073ae:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801073b2:	7f 1a                	jg     801073ce <uartputc+0x4b>
801073b4:	83 ec 0c             	sub    $0xc,%esp
801073b7:	68 fd 03 00 00       	push   $0x3fd
801073bc:	e8 94 fe ff ff       	call   80107255 <inb>
801073c1:	83 c4 10             	add    $0x10,%esp
801073c4:	0f b6 c0             	movzbl %al,%eax
801073c7:	83 e0 20             	and    $0x20,%eax
801073ca:	85 c0                	test   %eax,%eax
801073cc:	74 cf                	je     8010739d <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801073ce:	8b 45 08             	mov    0x8(%ebp),%eax
801073d1:	0f b6 c0             	movzbl %al,%eax
801073d4:	83 ec 08             	sub    $0x8,%esp
801073d7:	50                   	push   %eax
801073d8:	68 f8 03 00 00       	push   $0x3f8
801073dd:	e8 90 fe ff ff       	call   80107272 <outb>
801073e2:	83 c4 10             	add    $0x10,%esp
}
801073e5:	c9                   	leave  
801073e6:	c3                   	ret    

801073e7 <uartgetc>:

static int
uartgetc(void)
{
801073e7:	55                   	push   %ebp
801073e8:	89 e5                	mov    %esp,%ebp
  if(!uart)
801073ea:	a1 70 c6 10 80       	mov    0x8010c670,%eax
801073ef:	85 c0                	test   %eax,%eax
801073f1:	75 07                	jne    801073fa <uartgetc+0x13>
    return -1;
801073f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f8:	eb 2e                	jmp    80107428 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801073fa:	68 fd 03 00 00       	push   $0x3fd
801073ff:	e8 51 fe ff ff       	call   80107255 <inb>
80107404:	83 c4 04             	add    $0x4,%esp
80107407:	0f b6 c0             	movzbl %al,%eax
8010740a:	83 e0 01             	and    $0x1,%eax
8010740d:	85 c0                	test   %eax,%eax
8010740f:	75 07                	jne    80107418 <uartgetc+0x31>
    return -1;
80107411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107416:	eb 10                	jmp    80107428 <uartgetc+0x41>
  return inb(COM1+0);
80107418:	68 f8 03 00 00       	push   $0x3f8
8010741d:	e8 33 fe ff ff       	call   80107255 <inb>
80107422:	83 c4 04             	add    $0x4,%esp
80107425:	0f b6 c0             	movzbl %al,%eax
}
80107428:	c9                   	leave  
80107429:	c3                   	ret    

8010742a <uartintr>:

void
uartintr(void)
{
8010742a:	55                   	push   %ebp
8010742b:	89 e5                	mov    %esp,%ebp
8010742d:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107430:	83 ec 0c             	sub    $0xc,%esp
80107433:	68 e7 73 10 80       	push   $0x801073e7
80107438:	e8 94 93 ff ff       	call   801007d1 <consoleintr>
8010743d:	83 c4 10             	add    $0x10,%esp
}
80107440:	c9                   	leave  
80107441:	c3                   	ret    

80107442 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $0
80107444:	6a 00                	push   $0x0
  jmp alltraps
80107446:	e9 a3 f8 ff ff       	jmp    80106cee <alltraps>

8010744b <vector1>:
.globl vector1
vector1:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $1
8010744d:	6a 01                	push   $0x1
  jmp alltraps
8010744f:	e9 9a f8 ff ff       	jmp    80106cee <alltraps>

80107454 <vector2>:
.globl vector2
vector2:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $2
80107456:	6a 02                	push   $0x2
  jmp alltraps
80107458:	e9 91 f8 ff ff       	jmp    80106cee <alltraps>

8010745d <vector3>:
.globl vector3
vector3:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $3
8010745f:	6a 03                	push   $0x3
  jmp alltraps
80107461:	e9 88 f8 ff ff       	jmp    80106cee <alltraps>

80107466 <vector4>:
.globl vector4
vector4:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $4
80107468:	6a 04                	push   $0x4
  jmp alltraps
8010746a:	e9 7f f8 ff ff       	jmp    80106cee <alltraps>

8010746f <vector5>:
.globl vector5
vector5:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $5
80107471:	6a 05                	push   $0x5
  jmp alltraps
80107473:	e9 76 f8 ff ff       	jmp    80106cee <alltraps>

80107478 <vector6>:
.globl vector6
vector6:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $6
8010747a:	6a 06                	push   $0x6
  jmp alltraps
8010747c:	e9 6d f8 ff ff       	jmp    80106cee <alltraps>

80107481 <vector7>:
.globl vector7
vector7:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $7
80107483:	6a 07                	push   $0x7
  jmp alltraps
80107485:	e9 64 f8 ff ff       	jmp    80106cee <alltraps>

8010748a <vector8>:
.globl vector8
vector8:
  pushl $8
8010748a:	6a 08                	push   $0x8
  jmp alltraps
8010748c:	e9 5d f8 ff ff       	jmp    80106cee <alltraps>

80107491 <vector9>:
.globl vector9
vector9:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $9
80107493:	6a 09                	push   $0x9
  jmp alltraps
80107495:	e9 54 f8 ff ff       	jmp    80106cee <alltraps>

8010749a <vector10>:
.globl vector10
vector10:
  pushl $10
8010749a:	6a 0a                	push   $0xa
  jmp alltraps
8010749c:	e9 4d f8 ff ff       	jmp    80106cee <alltraps>

801074a1 <vector11>:
.globl vector11
vector11:
  pushl $11
801074a1:	6a 0b                	push   $0xb
  jmp alltraps
801074a3:	e9 46 f8 ff ff       	jmp    80106cee <alltraps>

801074a8 <vector12>:
.globl vector12
vector12:
  pushl $12
801074a8:	6a 0c                	push   $0xc
  jmp alltraps
801074aa:	e9 3f f8 ff ff       	jmp    80106cee <alltraps>

801074af <vector13>:
.globl vector13
vector13:
  pushl $13
801074af:	6a 0d                	push   $0xd
  jmp alltraps
801074b1:	e9 38 f8 ff ff       	jmp    80106cee <alltraps>

801074b6 <vector14>:
.globl vector14
vector14:
  pushl $14
801074b6:	6a 0e                	push   $0xe
  jmp alltraps
801074b8:	e9 31 f8 ff ff       	jmp    80106cee <alltraps>

801074bd <vector15>:
.globl vector15
vector15:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $15
801074bf:	6a 0f                	push   $0xf
  jmp alltraps
801074c1:	e9 28 f8 ff ff       	jmp    80106cee <alltraps>

801074c6 <vector16>:
.globl vector16
vector16:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $16
801074c8:	6a 10                	push   $0x10
  jmp alltraps
801074ca:	e9 1f f8 ff ff       	jmp    80106cee <alltraps>

801074cf <vector17>:
.globl vector17
vector17:
  pushl $17
801074cf:	6a 11                	push   $0x11
  jmp alltraps
801074d1:	e9 18 f8 ff ff       	jmp    80106cee <alltraps>

801074d6 <vector18>:
.globl vector18
vector18:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $18
801074d8:	6a 12                	push   $0x12
  jmp alltraps
801074da:	e9 0f f8 ff ff       	jmp    80106cee <alltraps>

801074df <vector19>:
.globl vector19
vector19:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $19
801074e1:	6a 13                	push   $0x13
  jmp alltraps
801074e3:	e9 06 f8 ff ff       	jmp    80106cee <alltraps>

801074e8 <vector20>:
.globl vector20
vector20:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $20
801074ea:	6a 14                	push   $0x14
  jmp alltraps
801074ec:	e9 fd f7 ff ff       	jmp    80106cee <alltraps>

801074f1 <vector21>:
.globl vector21
vector21:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $21
801074f3:	6a 15                	push   $0x15
  jmp alltraps
801074f5:	e9 f4 f7 ff ff       	jmp    80106cee <alltraps>

801074fa <vector22>:
.globl vector22
vector22:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $22
801074fc:	6a 16                	push   $0x16
  jmp alltraps
801074fe:	e9 eb f7 ff ff       	jmp    80106cee <alltraps>

80107503 <vector23>:
.globl vector23
vector23:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $23
80107505:	6a 17                	push   $0x17
  jmp alltraps
80107507:	e9 e2 f7 ff ff       	jmp    80106cee <alltraps>

8010750c <vector24>:
.globl vector24
vector24:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $24
8010750e:	6a 18                	push   $0x18
  jmp alltraps
80107510:	e9 d9 f7 ff ff       	jmp    80106cee <alltraps>

80107515 <vector25>:
.globl vector25
vector25:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $25
80107517:	6a 19                	push   $0x19
  jmp alltraps
80107519:	e9 d0 f7 ff ff       	jmp    80106cee <alltraps>

8010751e <vector26>:
.globl vector26
vector26:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $26
80107520:	6a 1a                	push   $0x1a
  jmp alltraps
80107522:	e9 c7 f7 ff ff       	jmp    80106cee <alltraps>

80107527 <vector27>:
.globl vector27
vector27:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $27
80107529:	6a 1b                	push   $0x1b
  jmp alltraps
8010752b:	e9 be f7 ff ff       	jmp    80106cee <alltraps>

80107530 <vector28>:
.globl vector28
vector28:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $28
80107532:	6a 1c                	push   $0x1c
  jmp alltraps
80107534:	e9 b5 f7 ff ff       	jmp    80106cee <alltraps>

80107539 <vector29>:
.globl vector29
vector29:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $29
8010753b:	6a 1d                	push   $0x1d
  jmp alltraps
8010753d:	e9 ac f7 ff ff       	jmp    80106cee <alltraps>

80107542 <vector30>:
.globl vector30
vector30:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $30
80107544:	6a 1e                	push   $0x1e
  jmp alltraps
80107546:	e9 a3 f7 ff ff       	jmp    80106cee <alltraps>

8010754b <vector31>:
.globl vector31
vector31:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $31
8010754d:	6a 1f                	push   $0x1f
  jmp alltraps
8010754f:	e9 9a f7 ff ff       	jmp    80106cee <alltraps>

80107554 <vector32>:
.globl vector32
vector32:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $32
80107556:	6a 20                	push   $0x20
  jmp alltraps
80107558:	e9 91 f7 ff ff       	jmp    80106cee <alltraps>

8010755d <vector33>:
.globl vector33
vector33:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $33
8010755f:	6a 21                	push   $0x21
  jmp alltraps
80107561:	e9 88 f7 ff ff       	jmp    80106cee <alltraps>

80107566 <vector34>:
.globl vector34
vector34:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $34
80107568:	6a 22                	push   $0x22
  jmp alltraps
8010756a:	e9 7f f7 ff ff       	jmp    80106cee <alltraps>

8010756f <vector35>:
.globl vector35
vector35:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $35
80107571:	6a 23                	push   $0x23
  jmp alltraps
80107573:	e9 76 f7 ff ff       	jmp    80106cee <alltraps>

80107578 <vector36>:
.globl vector36
vector36:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $36
8010757a:	6a 24                	push   $0x24
  jmp alltraps
8010757c:	e9 6d f7 ff ff       	jmp    80106cee <alltraps>

80107581 <vector37>:
.globl vector37
vector37:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $37
80107583:	6a 25                	push   $0x25
  jmp alltraps
80107585:	e9 64 f7 ff ff       	jmp    80106cee <alltraps>

8010758a <vector38>:
.globl vector38
vector38:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $38
8010758c:	6a 26                	push   $0x26
  jmp alltraps
8010758e:	e9 5b f7 ff ff       	jmp    80106cee <alltraps>

80107593 <vector39>:
.globl vector39
vector39:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $39
80107595:	6a 27                	push   $0x27
  jmp alltraps
80107597:	e9 52 f7 ff ff       	jmp    80106cee <alltraps>

8010759c <vector40>:
.globl vector40
vector40:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $40
8010759e:	6a 28                	push   $0x28
  jmp alltraps
801075a0:	e9 49 f7 ff ff       	jmp    80106cee <alltraps>

801075a5 <vector41>:
.globl vector41
vector41:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $41
801075a7:	6a 29                	push   $0x29
  jmp alltraps
801075a9:	e9 40 f7 ff ff       	jmp    80106cee <alltraps>

801075ae <vector42>:
.globl vector42
vector42:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $42
801075b0:	6a 2a                	push   $0x2a
  jmp alltraps
801075b2:	e9 37 f7 ff ff       	jmp    80106cee <alltraps>

801075b7 <vector43>:
.globl vector43
vector43:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $43
801075b9:	6a 2b                	push   $0x2b
  jmp alltraps
801075bb:	e9 2e f7 ff ff       	jmp    80106cee <alltraps>

801075c0 <vector44>:
.globl vector44
vector44:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $44
801075c2:	6a 2c                	push   $0x2c
  jmp alltraps
801075c4:	e9 25 f7 ff ff       	jmp    80106cee <alltraps>

801075c9 <vector45>:
.globl vector45
vector45:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $45
801075cb:	6a 2d                	push   $0x2d
  jmp alltraps
801075cd:	e9 1c f7 ff ff       	jmp    80106cee <alltraps>

801075d2 <vector46>:
.globl vector46
vector46:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $46
801075d4:	6a 2e                	push   $0x2e
  jmp alltraps
801075d6:	e9 13 f7 ff ff       	jmp    80106cee <alltraps>

801075db <vector47>:
.globl vector47
vector47:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $47
801075dd:	6a 2f                	push   $0x2f
  jmp alltraps
801075df:	e9 0a f7 ff ff       	jmp    80106cee <alltraps>

801075e4 <vector48>:
.globl vector48
vector48:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $48
801075e6:	6a 30                	push   $0x30
  jmp alltraps
801075e8:	e9 01 f7 ff ff       	jmp    80106cee <alltraps>

801075ed <vector49>:
.globl vector49
vector49:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $49
801075ef:	6a 31                	push   $0x31
  jmp alltraps
801075f1:	e9 f8 f6 ff ff       	jmp    80106cee <alltraps>

801075f6 <vector50>:
.globl vector50
vector50:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $50
801075f8:	6a 32                	push   $0x32
  jmp alltraps
801075fa:	e9 ef f6 ff ff       	jmp    80106cee <alltraps>

801075ff <vector51>:
.globl vector51
vector51:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $51
80107601:	6a 33                	push   $0x33
  jmp alltraps
80107603:	e9 e6 f6 ff ff       	jmp    80106cee <alltraps>

80107608 <vector52>:
.globl vector52
vector52:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $52
8010760a:	6a 34                	push   $0x34
  jmp alltraps
8010760c:	e9 dd f6 ff ff       	jmp    80106cee <alltraps>

80107611 <vector53>:
.globl vector53
vector53:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $53
80107613:	6a 35                	push   $0x35
  jmp alltraps
80107615:	e9 d4 f6 ff ff       	jmp    80106cee <alltraps>

8010761a <vector54>:
.globl vector54
vector54:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $54
8010761c:	6a 36                	push   $0x36
  jmp alltraps
8010761e:	e9 cb f6 ff ff       	jmp    80106cee <alltraps>

80107623 <vector55>:
.globl vector55
vector55:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $55
80107625:	6a 37                	push   $0x37
  jmp alltraps
80107627:	e9 c2 f6 ff ff       	jmp    80106cee <alltraps>

8010762c <vector56>:
.globl vector56
vector56:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $56
8010762e:	6a 38                	push   $0x38
  jmp alltraps
80107630:	e9 b9 f6 ff ff       	jmp    80106cee <alltraps>

80107635 <vector57>:
.globl vector57
vector57:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $57
80107637:	6a 39                	push   $0x39
  jmp alltraps
80107639:	e9 b0 f6 ff ff       	jmp    80106cee <alltraps>

8010763e <vector58>:
.globl vector58
vector58:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $58
80107640:	6a 3a                	push   $0x3a
  jmp alltraps
80107642:	e9 a7 f6 ff ff       	jmp    80106cee <alltraps>

80107647 <vector59>:
.globl vector59
vector59:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $59
80107649:	6a 3b                	push   $0x3b
  jmp alltraps
8010764b:	e9 9e f6 ff ff       	jmp    80106cee <alltraps>

80107650 <vector60>:
.globl vector60
vector60:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $60
80107652:	6a 3c                	push   $0x3c
  jmp alltraps
80107654:	e9 95 f6 ff ff       	jmp    80106cee <alltraps>

80107659 <vector61>:
.globl vector61
vector61:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $61
8010765b:	6a 3d                	push   $0x3d
  jmp alltraps
8010765d:	e9 8c f6 ff ff       	jmp    80106cee <alltraps>

80107662 <vector62>:
.globl vector62
vector62:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $62
80107664:	6a 3e                	push   $0x3e
  jmp alltraps
80107666:	e9 83 f6 ff ff       	jmp    80106cee <alltraps>

8010766b <vector63>:
.globl vector63
vector63:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $63
8010766d:	6a 3f                	push   $0x3f
  jmp alltraps
8010766f:	e9 7a f6 ff ff       	jmp    80106cee <alltraps>

80107674 <vector64>:
.globl vector64
vector64:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $64
80107676:	6a 40                	push   $0x40
  jmp alltraps
80107678:	e9 71 f6 ff ff       	jmp    80106cee <alltraps>

8010767d <vector65>:
.globl vector65
vector65:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $65
8010767f:	6a 41                	push   $0x41
  jmp alltraps
80107681:	e9 68 f6 ff ff       	jmp    80106cee <alltraps>

80107686 <vector66>:
.globl vector66
vector66:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $66
80107688:	6a 42                	push   $0x42
  jmp alltraps
8010768a:	e9 5f f6 ff ff       	jmp    80106cee <alltraps>

8010768f <vector67>:
.globl vector67
vector67:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $67
80107691:	6a 43                	push   $0x43
  jmp alltraps
80107693:	e9 56 f6 ff ff       	jmp    80106cee <alltraps>

80107698 <vector68>:
.globl vector68
vector68:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $68
8010769a:	6a 44                	push   $0x44
  jmp alltraps
8010769c:	e9 4d f6 ff ff       	jmp    80106cee <alltraps>

801076a1 <vector69>:
.globl vector69
vector69:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $69
801076a3:	6a 45                	push   $0x45
  jmp alltraps
801076a5:	e9 44 f6 ff ff       	jmp    80106cee <alltraps>

801076aa <vector70>:
.globl vector70
vector70:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $70
801076ac:	6a 46                	push   $0x46
  jmp alltraps
801076ae:	e9 3b f6 ff ff       	jmp    80106cee <alltraps>

801076b3 <vector71>:
.globl vector71
vector71:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $71
801076b5:	6a 47                	push   $0x47
  jmp alltraps
801076b7:	e9 32 f6 ff ff       	jmp    80106cee <alltraps>

801076bc <vector72>:
.globl vector72
vector72:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $72
801076be:	6a 48                	push   $0x48
  jmp alltraps
801076c0:	e9 29 f6 ff ff       	jmp    80106cee <alltraps>

801076c5 <vector73>:
.globl vector73
vector73:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $73
801076c7:	6a 49                	push   $0x49
  jmp alltraps
801076c9:	e9 20 f6 ff ff       	jmp    80106cee <alltraps>

801076ce <vector74>:
.globl vector74
vector74:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $74
801076d0:	6a 4a                	push   $0x4a
  jmp alltraps
801076d2:	e9 17 f6 ff ff       	jmp    80106cee <alltraps>

801076d7 <vector75>:
.globl vector75
vector75:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $75
801076d9:	6a 4b                	push   $0x4b
  jmp alltraps
801076db:	e9 0e f6 ff ff       	jmp    80106cee <alltraps>

801076e0 <vector76>:
.globl vector76
vector76:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $76
801076e2:	6a 4c                	push   $0x4c
  jmp alltraps
801076e4:	e9 05 f6 ff ff       	jmp    80106cee <alltraps>

801076e9 <vector77>:
.globl vector77
vector77:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $77
801076eb:	6a 4d                	push   $0x4d
  jmp alltraps
801076ed:	e9 fc f5 ff ff       	jmp    80106cee <alltraps>

801076f2 <vector78>:
.globl vector78
vector78:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $78
801076f4:	6a 4e                	push   $0x4e
  jmp alltraps
801076f6:	e9 f3 f5 ff ff       	jmp    80106cee <alltraps>

801076fb <vector79>:
.globl vector79
vector79:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $79
801076fd:	6a 4f                	push   $0x4f
  jmp alltraps
801076ff:	e9 ea f5 ff ff       	jmp    80106cee <alltraps>

80107704 <vector80>:
.globl vector80
vector80:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $80
80107706:	6a 50                	push   $0x50
  jmp alltraps
80107708:	e9 e1 f5 ff ff       	jmp    80106cee <alltraps>

8010770d <vector81>:
.globl vector81
vector81:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $81
8010770f:	6a 51                	push   $0x51
  jmp alltraps
80107711:	e9 d8 f5 ff ff       	jmp    80106cee <alltraps>

80107716 <vector82>:
.globl vector82
vector82:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $82
80107718:	6a 52                	push   $0x52
  jmp alltraps
8010771a:	e9 cf f5 ff ff       	jmp    80106cee <alltraps>

8010771f <vector83>:
.globl vector83
vector83:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $83
80107721:	6a 53                	push   $0x53
  jmp alltraps
80107723:	e9 c6 f5 ff ff       	jmp    80106cee <alltraps>

80107728 <vector84>:
.globl vector84
vector84:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $84
8010772a:	6a 54                	push   $0x54
  jmp alltraps
8010772c:	e9 bd f5 ff ff       	jmp    80106cee <alltraps>

80107731 <vector85>:
.globl vector85
vector85:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $85
80107733:	6a 55                	push   $0x55
  jmp alltraps
80107735:	e9 b4 f5 ff ff       	jmp    80106cee <alltraps>

8010773a <vector86>:
.globl vector86
vector86:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $86
8010773c:	6a 56                	push   $0x56
  jmp alltraps
8010773e:	e9 ab f5 ff ff       	jmp    80106cee <alltraps>

80107743 <vector87>:
.globl vector87
vector87:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $87
80107745:	6a 57                	push   $0x57
  jmp alltraps
80107747:	e9 a2 f5 ff ff       	jmp    80106cee <alltraps>

8010774c <vector88>:
.globl vector88
vector88:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $88
8010774e:	6a 58                	push   $0x58
  jmp alltraps
80107750:	e9 99 f5 ff ff       	jmp    80106cee <alltraps>

80107755 <vector89>:
.globl vector89
vector89:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $89
80107757:	6a 59                	push   $0x59
  jmp alltraps
80107759:	e9 90 f5 ff ff       	jmp    80106cee <alltraps>

8010775e <vector90>:
.globl vector90
vector90:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $90
80107760:	6a 5a                	push   $0x5a
  jmp alltraps
80107762:	e9 87 f5 ff ff       	jmp    80106cee <alltraps>

80107767 <vector91>:
.globl vector91
vector91:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $91
80107769:	6a 5b                	push   $0x5b
  jmp alltraps
8010776b:	e9 7e f5 ff ff       	jmp    80106cee <alltraps>

80107770 <vector92>:
.globl vector92
vector92:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $92
80107772:	6a 5c                	push   $0x5c
  jmp alltraps
80107774:	e9 75 f5 ff ff       	jmp    80106cee <alltraps>

80107779 <vector93>:
.globl vector93
vector93:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $93
8010777b:	6a 5d                	push   $0x5d
  jmp alltraps
8010777d:	e9 6c f5 ff ff       	jmp    80106cee <alltraps>

80107782 <vector94>:
.globl vector94
vector94:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $94
80107784:	6a 5e                	push   $0x5e
  jmp alltraps
80107786:	e9 63 f5 ff ff       	jmp    80106cee <alltraps>

8010778b <vector95>:
.globl vector95
vector95:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $95
8010778d:	6a 5f                	push   $0x5f
  jmp alltraps
8010778f:	e9 5a f5 ff ff       	jmp    80106cee <alltraps>

80107794 <vector96>:
.globl vector96
vector96:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $96
80107796:	6a 60                	push   $0x60
  jmp alltraps
80107798:	e9 51 f5 ff ff       	jmp    80106cee <alltraps>

8010779d <vector97>:
.globl vector97
vector97:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $97
8010779f:	6a 61                	push   $0x61
  jmp alltraps
801077a1:	e9 48 f5 ff ff       	jmp    80106cee <alltraps>

801077a6 <vector98>:
.globl vector98
vector98:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $98
801077a8:	6a 62                	push   $0x62
  jmp alltraps
801077aa:	e9 3f f5 ff ff       	jmp    80106cee <alltraps>

801077af <vector99>:
.globl vector99
vector99:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $99
801077b1:	6a 63                	push   $0x63
  jmp alltraps
801077b3:	e9 36 f5 ff ff       	jmp    80106cee <alltraps>

801077b8 <vector100>:
.globl vector100
vector100:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $100
801077ba:	6a 64                	push   $0x64
  jmp alltraps
801077bc:	e9 2d f5 ff ff       	jmp    80106cee <alltraps>

801077c1 <vector101>:
.globl vector101
vector101:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $101
801077c3:	6a 65                	push   $0x65
  jmp alltraps
801077c5:	e9 24 f5 ff ff       	jmp    80106cee <alltraps>

801077ca <vector102>:
.globl vector102
vector102:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $102
801077cc:	6a 66                	push   $0x66
  jmp alltraps
801077ce:	e9 1b f5 ff ff       	jmp    80106cee <alltraps>

801077d3 <vector103>:
.globl vector103
vector103:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $103
801077d5:	6a 67                	push   $0x67
  jmp alltraps
801077d7:	e9 12 f5 ff ff       	jmp    80106cee <alltraps>

801077dc <vector104>:
.globl vector104
vector104:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $104
801077de:	6a 68                	push   $0x68
  jmp alltraps
801077e0:	e9 09 f5 ff ff       	jmp    80106cee <alltraps>

801077e5 <vector105>:
.globl vector105
vector105:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $105
801077e7:	6a 69                	push   $0x69
  jmp alltraps
801077e9:	e9 00 f5 ff ff       	jmp    80106cee <alltraps>

801077ee <vector106>:
.globl vector106
vector106:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $106
801077f0:	6a 6a                	push   $0x6a
  jmp alltraps
801077f2:	e9 f7 f4 ff ff       	jmp    80106cee <alltraps>

801077f7 <vector107>:
.globl vector107
vector107:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $107
801077f9:	6a 6b                	push   $0x6b
  jmp alltraps
801077fb:	e9 ee f4 ff ff       	jmp    80106cee <alltraps>

80107800 <vector108>:
.globl vector108
vector108:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $108
80107802:	6a 6c                	push   $0x6c
  jmp alltraps
80107804:	e9 e5 f4 ff ff       	jmp    80106cee <alltraps>

80107809 <vector109>:
.globl vector109
vector109:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $109
8010780b:	6a 6d                	push   $0x6d
  jmp alltraps
8010780d:	e9 dc f4 ff ff       	jmp    80106cee <alltraps>

80107812 <vector110>:
.globl vector110
vector110:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $110
80107814:	6a 6e                	push   $0x6e
  jmp alltraps
80107816:	e9 d3 f4 ff ff       	jmp    80106cee <alltraps>

8010781b <vector111>:
.globl vector111
vector111:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $111
8010781d:	6a 6f                	push   $0x6f
  jmp alltraps
8010781f:	e9 ca f4 ff ff       	jmp    80106cee <alltraps>

80107824 <vector112>:
.globl vector112
vector112:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $112
80107826:	6a 70                	push   $0x70
  jmp alltraps
80107828:	e9 c1 f4 ff ff       	jmp    80106cee <alltraps>

8010782d <vector113>:
.globl vector113
vector113:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $113
8010782f:	6a 71                	push   $0x71
  jmp alltraps
80107831:	e9 b8 f4 ff ff       	jmp    80106cee <alltraps>

80107836 <vector114>:
.globl vector114
vector114:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $114
80107838:	6a 72                	push   $0x72
  jmp alltraps
8010783a:	e9 af f4 ff ff       	jmp    80106cee <alltraps>

8010783f <vector115>:
.globl vector115
vector115:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $115
80107841:	6a 73                	push   $0x73
  jmp alltraps
80107843:	e9 a6 f4 ff ff       	jmp    80106cee <alltraps>

80107848 <vector116>:
.globl vector116
vector116:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $116
8010784a:	6a 74                	push   $0x74
  jmp alltraps
8010784c:	e9 9d f4 ff ff       	jmp    80106cee <alltraps>

80107851 <vector117>:
.globl vector117
vector117:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $117
80107853:	6a 75                	push   $0x75
  jmp alltraps
80107855:	e9 94 f4 ff ff       	jmp    80106cee <alltraps>

8010785a <vector118>:
.globl vector118
vector118:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $118
8010785c:	6a 76                	push   $0x76
  jmp alltraps
8010785e:	e9 8b f4 ff ff       	jmp    80106cee <alltraps>

80107863 <vector119>:
.globl vector119
vector119:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $119
80107865:	6a 77                	push   $0x77
  jmp alltraps
80107867:	e9 82 f4 ff ff       	jmp    80106cee <alltraps>

8010786c <vector120>:
.globl vector120
vector120:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $120
8010786e:	6a 78                	push   $0x78
  jmp alltraps
80107870:	e9 79 f4 ff ff       	jmp    80106cee <alltraps>

80107875 <vector121>:
.globl vector121
vector121:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $121
80107877:	6a 79                	push   $0x79
  jmp alltraps
80107879:	e9 70 f4 ff ff       	jmp    80106cee <alltraps>

8010787e <vector122>:
.globl vector122
vector122:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $122
80107880:	6a 7a                	push   $0x7a
  jmp alltraps
80107882:	e9 67 f4 ff ff       	jmp    80106cee <alltraps>

80107887 <vector123>:
.globl vector123
vector123:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $123
80107889:	6a 7b                	push   $0x7b
  jmp alltraps
8010788b:	e9 5e f4 ff ff       	jmp    80106cee <alltraps>

80107890 <vector124>:
.globl vector124
vector124:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $124
80107892:	6a 7c                	push   $0x7c
  jmp alltraps
80107894:	e9 55 f4 ff ff       	jmp    80106cee <alltraps>

80107899 <vector125>:
.globl vector125
vector125:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $125
8010789b:	6a 7d                	push   $0x7d
  jmp alltraps
8010789d:	e9 4c f4 ff ff       	jmp    80106cee <alltraps>

801078a2 <vector126>:
.globl vector126
vector126:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $126
801078a4:	6a 7e                	push   $0x7e
  jmp alltraps
801078a6:	e9 43 f4 ff ff       	jmp    80106cee <alltraps>

801078ab <vector127>:
.globl vector127
vector127:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $127
801078ad:	6a 7f                	push   $0x7f
  jmp alltraps
801078af:	e9 3a f4 ff ff       	jmp    80106cee <alltraps>

801078b4 <vector128>:
.globl vector128
vector128:
  pushl $0
801078b4:	6a 00                	push   $0x0
  pushl $128
801078b6:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801078bb:	e9 2e f4 ff ff       	jmp    80106cee <alltraps>

801078c0 <vector129>:
.globl vector129
vector129:
  pushl $0
801078c0:	6a 00                	push   $0x0
  pushl $129
801078c2:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078c7:	e9 22 f4 ff ff       	jmp    80106cee <alltraps>

801078cc <vector130>:
.globl vector130
vector130:
  pushl $0
801078cc:	6a 00                	push   $0x0
  pushl $130
801078ce:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078d3:	e9 16 f4 ff ff       	jmp    80106cee <alltraps>

801078d8 <vector131>:
.globl vector131
vector131:
  pushl $0
801078d8:	6a 00                	push   $0x0
  pushl $131
801078da:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078df:	e9 0a f4 ff ff       	jmp    80106cee <alltraps>

801078e4 <vector132>:
.globl vector132
vector132:
  pushl $0
801078e4:	6a 00                	push   $0x0
  pushl $132
801078e6:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078eb:	e9 fe f3 ff ff       	jmp    80106cee <alltraps>

801078f0 <vector133>:
.globl vector133
vector133:
  pushl $0
801078f0:	6a 00                	push   $0x0
  pushl $133
801078f2:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078f7:	e9 f2 f3 ff ff       	jmp    80106cee <alltraps>

801078fc <vector134>:
.globl vector134
vector134:
  pushl $0
801078fc:	6a 00                	push   $0x0
  pushl $134
801078fe:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107903:	e9 e6 f3 ff ff       	jmp    80106cee <alltraps>

80107908 <vector135>:
.globl vector135
vector135:
  pushl $0
80107908:	6a 00                	push   $0x0
  pushl $135
8010790a:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010790f:	e9 da f3 ff ff       	jmp    80106cee <alltraps>

80107914 <vector136>:
.globl vector136
vector136:
  pushl $0
80107914:	6a 00                	push   $0x0
  pushl $136
80107916:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010791b:	e9 ce f3 ff ff       	jmp    80106cee <alltraps>

80107920 <vector137>:
.globl vector137
vector137:
  pushl $0
80107920:	6a 00                	push   $0x0
  pushl $137
80107922:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107927:	e9 c2 f3 ff ff       	jmp    80106cee <alltraps>

8010792c <vector138>:
.globl vector138
vector138:
  pushl $0
8010792c:	6a 00                	push   $0x0
  pushl $138
8010792e:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107933:	e9 b6 f3 ff ff       	jmp    80106cee <alltraps>

80107938 <vector139>:
.globl vector139
vector139:
  pushl $0
80107938:	6a 00                	push   $0x0
  pushl $139
8010793a:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010793f:	e9 aa f3 ff ff       	jmp    80106cee <alltraps>

80107944 <vector140>:
.globl vector140
vector140:
  pushl $0
80107944:	6a 00                	push   $0x0
  pushl $140
80107946:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010794b:	e9 9e f3 ff ff       	jmp    80106cee <alltraps>

80107950 <vector141>:
.globl vector141
vector141:
  pushl $0
80107950:	6a 00                	push   $0x0
  pushl $141
80107952:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107957:	e9 92 f3 ff ff       	jmp    80106cee <alltraps>

8010795c <vector142>:
.globl vector142
vector142:
  pushl $0
8010795c:	6a 00                	push   $0x0
  pushl $142
8010795e:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107963:	e9 86 f3 ff ff       	jmp    80106cee <alltraps>

80107968 <vector143>:
.globl vector143
vector143:
  pushl $0
80107968:	6a 00                	push   $0x0
  pushl $143
8010796a:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010796f:	e9 7a f3 ff ff       	jmp    80106cee <alltraps>

80107974 <vector144>:
.globl vector144
vector144:
  pushl $0
80107974:	6a 00                	push   $0x0
  pushl $144
80107976:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010797b:	e9 6e f3 ff ff       	jmp    80106cee <alltraps>

80107980 <vector145>:
.globl vector145
vector145:
  pushl $0
80107980:	6a 00                	push   $0x0
  pushl $145
80107982:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107987:	e9 62 f3 ff ff       	jmp    80106cee <alltraps>

8010798c <vector146>:
.globl vector146
vector146:
  pushl $0
8010798c:	6a 00                	push   $0x0
  pushl $146
8010798e:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107993:	e9 56 f3 ff ff       	jmp    80106cee <alltraps>

80107998 <vector147>:
.globl vector147
vector147:
  pushl $0
80107998:	6a 00                	push   $0x0
  pushl $147
8010799a:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010799f:	e9 4a f3 ff ff       	jmp    80106cee <alltraps>

801079a4 <vector148>:
.globl vector148
vector148:
  pushl $0
801079a4:	6a 00                	push   $0x0
  pushl $148
801079a6:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801079ab:	e9 3e f3 ff ff       	jmp    80106cee <alltraps>

801079b0 <vector149>:
.globl vector149
vector149:
  pushl $0
801079b0:	6a 00                	push   $0x0
  pushl $149
801079b2:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801079b7:	e9 32 f3 ff ff       	jmp    80106cee <alltraps>

801079bc <vector150>:
.globl vector150
vector150:
  pushl $0
801079bc:	6a 00                	push   $0x0
  pushl $150
801079be:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801079c3:	e9 26 f3 ff ff       	jmp    80106cee <alltraps>

801079c8 <vector151>:
.globl vector151
vector151:
  pushl $0
801079c8:	6a 00                	push   $0x0
  pushl $151
801079ca:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079cf:	e9 1a f3 ff ff       	jmp    80106cee <alltraps>

801079d4 <vector152>:
.globl vector152
vector152:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $152
801079d6:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079db:	e9 0e f3 ff ff       	jmp    80106cee <alltraps>

801079e0 <vector153>:
.globl vector153
vector153:
  pushl $0
801079e0:	6a 00                	push   $0x0
  pushl $153
801079e2:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079e7:	e9 02 f3 ff ff       	jmp    80106cee <alltraps>

801079ec <vector154>:
.globl vector154
vector154:
  pushl $0
801079ec:	6a 00                	push   $0x0
  pushl $154
801079ee:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079f3:	e9 f6 f2 ff ff       	jmp    80106cee <alltraps>

801079f8 <vector155>:
.globl vector155
vector155:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $155
801079fa:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079ff:	e9 ea f2 ff ff       	jmp    80106cee <alltraps>

80107a04 <vector156>:
.globl vector156
vector156:
  pushl $0
80107a04:	6a 00                	push   $0x0
  pushl $156
80107a06:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107a0b:	e9 de f2 ff ff       	jmp    80106cee <alltraps>

80107a10 <vector157>:
.globl vector157
vector157:
  pushl $0
80107a10:	6a 00                	push   $0x0
  pushl $157
80107a12:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a17:	e9 d2 f2 ff ff       	jmp    80106cee <alltraps>

80107a1c <vector158>:
.globl vector158
vector158:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $158
80107a1e:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a23:	e9 c6 f2 ff ff       	jmp    80106cee <alltraps>

80107a28 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a28:	6a 00                	push   $0x0
  pushl $159
80107a2a:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a2f:	e9 ba f2 ff ff       	jmp    80106cee <alltraps>

80107a34 <vector160>:
.globl vector160
vector160:
  pushl $0
80107a34:	6a 00                	push   $0x0
  pushl $160
80107a36:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a3b:	e9 ae f2 ff ff       	jmp    80106cee <alltraps>

80107a40 <vector161>:
.globl vector161
vector161:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $161
80107a42:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a47:	e9 a2 f2 ff ff       	jmp    80106cee <alltraps>

80107a4c <vector162>:
.globl vector162
vector162:
  pushl $0
80107a4c:	6a 00                	push   $0x0
  pushl $162
80107a4e:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a53:	e9 96 f2 ff ff       	jmp    80106cee <alltraps>

80107a58 <vector163>:
.globl vector163
vector163:
  pushl $0
80107a58:	6a 00                	push   $0x0
  pushl $163
80107a5a:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a5f:	e9 8a f2 ff ff       	jmp    80106cee <alltraps>

80107a64 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $164
80107a66:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a6b:	e9 7e f2 ff ff       	jmp    80106cee <alltraps>

80107a70 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a70:	6a 00                	push   $0x0
  pushl $165
80107a72:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a77:	e9 72 f2 ff ff       	jmp    80106cee <alltraps>

80107a7c <vector166>:
.globl vector166
vector166:
  pushl $0
80107a7c:	6a 00                	push   $0x0
  pushl $166
80107a7e:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a83:	e9 66 f2 ff ff       	jmp    80106cee <alltraps>

80107a88 <vector167>:
.globl vector167
vector167:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $167
80107a8a:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a8f:	e9 5a f2 ff ff       	jmp    80106cee <alltraps>

80107a94 <vector168>:
.globl vector168
vector168:
  pushl $0
80107a94:	6a 00                	push   $0x0
  pushl $168
80107a96:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a9b:	e9 4e f2 ff ff       	jmp    80106cee <alltraps>

80107aa0 <vector169>:
.globl vector169
vector169:
  pushl $0
80107aa0:	6a 00                	push   $0x0
  pushl $169
80107aa2:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107aa7:	e9 42 f2 ff ff       	jmp    80106cee <alltraps>

80107aac <vector170>:
.globl vector170
vector170:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $170
80107aae:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107ab3:	e9 36 f2 ff ff       	jmp    80106cee <alltraps>

80107ab8 <vector171>:
.globl vector171
vector171:
  pushl $0
80107ab8:	6a 00                	push   $0x0
  pushl $171
80107aba:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107abf:	e9 2a f2 ff ff       	jmp    80106cee <alltraps>

80107ac4 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ac4:	6a 00                	push   $0x0
  pushl $172
80107ac6:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107acb:	e9 1e f2 ff ff       	jmp    80106cee <alltraps>

80107ad0 <vector173>:
.globl vector173
vector173:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $173
80107ad2:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ad7:	e9 12 f2 ff ff       	jmp    80106cee <alltraps>

80107adc <vector174>:
.globl vector174
vector174:
  pushl $0
80107adc:	6a 00                	push   $0x0
  pushl $174
80107ade:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107ae3:	e9 06 f2 ff ff       	jmp    80106cee <alltraps>

80107ae8 <vector175>:
.globl vector175
vector175:
  pushl $0
80107ae8:	6a 00                	push   $0x0
  pushl $175
80107aea:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107aef:	e9 fa f1 ff ff       	jmp    80106cee <alltraps>

80107af4 <vector176>:
.globl vector176
vector176:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $176
80107af6:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107afb:	e9 ee f1 ff ff       	jmp    80106cee <alltraps>

80107b00 <vector177>:
.globl vector177
vector177:
  pushl $0
80107b00:	6a 00                	push   $0x0
  pushl $177
80107b02:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107b07:	e9 e2 f1 ff ff       	jmp    80106cee <alltraps>

80107b0c <vector178>:
.globl vector178
vector178:
  pushl $0
80107b0c:	6a 00                	push   $0x0
  pushl $178
80107b0e:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b13:	e9 d6 f1 ff ff       	jmp    80106cee <alltraps>

80107b18 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $179
80107b1a:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b1f:	e9 ca f1 ff ff       	jmp    80106cee <alltraps>

80107b24 <vector180>:
.globl vector180
vector180:
  pushl $0
80107b24:	6a 00                	push   $0x0
  pushl $180
80107b26:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b2b:	e9 be f1 ff ff       	jmp    80106cee <alltraps>

80107b30 <vector181>:
.globl vector181
vector181:
  pushl $0
80107b30:	6a 00                	push   $0x0
  pushl $181
80107b32:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b37:	e9 b2 f1 ff ff       	jmp    80106cee <alltraps>

80107b3c <vector182>:
.globl vector182
vector182:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $182
80107b3e:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b43:	e9 a6 f1 ff ff       	jmp    80106cee <alltraps>

80107b48 <vector183>:
.globl vector183
vector183:
  pushl $0
80107b48:	6a 00                	push   $0x0
  pushl $183
80107b4a:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b4f:	e9 9a f1 ff ff       	jmp    80106cee <alltraps>

80107b54 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b54:	6a 00                	push   $0x0
  pushl $184
80107b56:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b5b:	e9 8e f1 ff ff       	jmp    80106cee <alltraps>

80107b60 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $185
80107b62:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b67:	e9 82 f1 ff ff       	jmp    80106cee <alltraps>

80107b6c <vector186>:
.globl vector186
vector186:
  pushl $0
80107b6c:	6a 00                	push   $0x0
  pushl $186
80107b6e:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b73:	e9 76 f1 ff ff       	jmp    80106cee <alltraps>

80107b78 <vector187>:
.globl vector187
vector187:
  pushl $0
80107b78:	6a 00                	push   $0x0
  pushl $187
80107b7a:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b7f:	e9 6a f1 ff ff       	jmp    80106cee <alltraps>

80107b84 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $188
80107b86:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b8b:	e9 5e f1 ff ff       	jmp    80106cee <alltraps>

80107b90 <vector189>:
.globl vector189
vector189:
  pushl $0
80107b90:	6a 00                	push   $0x0
  pushl $189
80107b92:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b97:	e9 52 f1 ff ff       	jmp    80106cee <alltraps>

80107b9c <vector190>:
.globl vector190
vector190:
  pushl $0
80107b9c:	6a 00                	push   $0x0
  pushl $190
80107b9e:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107ba3:	e9 46 f1 ff ff       	jmp    80106cee <alltraps>

80107ba8 <vector191>:
.globl vector191
vector191:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $191
80107baa:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107baf:	e9 3a f1 ff ff       	jmp    80106cee <alltraps>

80107bb4 <vector192>:
.globl vector192
vector192:
  pushl $0
80107bb4:	6a 00                	push   $0x0
  pushl $192
80107bb6:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107bbb:	e9 2e f1 ff ff       	jmp    80106cee <alltraps>

80107bc0 <vector193>:
.globl vector193
vector193:
  pushl $0
80107bc0:	6a 00                	push   $0x0
  pushl $193
80107bc2:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107bc7:	e9 22 f1 ff ff       	jmp    80106cee <alltraps>

80107bcc <vector194>:
.globl vector194
vector194:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $194
80107bce:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107bd3:	e9 16 f1 ff ff       	jmp    80106cee <alltraps>

80107bd8 <vector195>:
.globl vector195
vector195:
  pushl $0
80107bd8:	6a 00                	push   $0x0
  pushl $195
80107bda:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bdf:	e9 0a f1 ff ff       	jmp    80106cee <alltraps>

80107be4 <vector196>:
.globl vector196
vector196:
  pushl $0
80107be4:	6a 00                	push   $0x0
  pushl $196
80107be6:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107beb:	e9 fe f0 ff ff       	jmp    80106cee <alltraps>

80107bf0 <vector197>:
.globl vector197
vector197:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $197
80107bf2:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107bf7:	e9 f2 f0 ff ff       	jmp    80106cee <alltraps>

80107bfc <vector198>:
.globl vector198
vector198:
  pushl $0
80107bfc:	6a 00                	push   $0x0
  pushl $198
80107bfe:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107c03:	e9 e6 f0 ff ff       	jmp    80106cee <alltraps>

80107c08 <vector199>:
.globl vector199
vector199:
  pushl $0
80107c08:	6a 00                	push   $0x0
  pushl $199
80107c0a:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107c0f:	e9 da f0 ff ff       	jmp    80106cee <alltraps>

80107c14 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $200
80107c16:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c1b:	e9 ce f0 ff ff       	jmp    80106cee <alltraps>

80107c20 <vector201>:
.globl vector201
vector201:
  pushl $0
80107c20:	6a 00                	push   $0x0
  pushl $201
80107c22:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c27:	e9 c2 f0 ff ff       	jmp    80106cee <alltraps>

80107c2c <vector202>:
.globl vector202
vector202:
  pushl $0
80107c2c:	6a 00                	push   $0x0
  pushl $202
80107c2e:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c33:	e9 b6 f0 ff ff       	jmp    80106cee <alltraps>

80107c38 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $203
80107c3a:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c3f:	e9 aa f0 ff ff       	jmp    80106cee <alltraps>

80107c44 <vector204>:
.globl vector204
vector204:
  pushl $0
80107c44:	6a 00                	push   $0x0
  pushl $204
80107c46:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c4b:	e9 9e f0 ff ff       	jmp    80106cee <alltraps>

80107c50 <vector205>:
.globl vector205
vector205:
  pushl $0
80107c50:	6a 00                	push   $0x0
  pushl $205
80107c52:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c57:	e9 92 f0 ff ff       	jmp    80106cee <alltraps>

80107c5c <vector206>:
.globl vector206
vector206:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $206
80107c5e:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c63:	e9 86 f0 ff ff       	jmp    80106cee <alltraps>

80107c68 <vector207>:
.globl vector207
vector207:
  pushl $0
80107c68:	6a 00                	push   $0x0
  pushl $207
80107c6a:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c6f:	e9 7a f0 ff ff       	jmp    80106cee <alltraps>

80107c74 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c74:	6a 00                	push   $0x0
  pushl $208
80107c76:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c7b:	e9 6e f0 ff ff       	jmp    80106cee <alltraps>

80107c80 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $209
80107c82:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c87:	e9 62 f0 ff ff       	jmp    80106cee <alltraps>

80107c8c <vector210>:
.globl vector210
vector210:
  pushl $0
80107c8c:	6a 00                	push   $0x0
  pushl $210
80107c8e:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c93:	e9 56 f0 ff ff       	jmp    80106cee <alltraps>

80107c98 <vector211>:
.globl vector211
vector211:
  pushl $0
80107c98:	6a 00                	push   $0x0
  pushl $211
80107c9a:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c9f:	e9 4a f0 ff ff       	jmp    80106cee <alltraps>

80107ca4 <vector212>:
.globl vector212
vector212:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $212
80107ca6:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107cab:	e9 3e f0 ff ff       	jmp    80106cee <alltraps>

80107cb0 <vector213>:
.globl vector213
vector213:
  pushl $0
80107cb0:	6a 00                	push   $0x0
  pushl $213
80107cb2:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107cb7:	e9 32 f0 ff ff       	jmp    80106cee <alltraps>

80107cbc <vector214>:
.globl vector214
vector214:
  pushl $0
80107cbc:	6a 00                	push   $0x0
  pushl $214
80107cbe:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107cc3:	e9 26 f0 ff ff       	jmp    80106cee <alltraps>

80107cc8 <vector215>:
.globl vector215
vector215:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $215
80107cca:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107ccf:	e9 1a f0 ff ff       	jmp    80106cee <alltraps>

80107cd4 <vector216>:
.globl vector216
vector216:
  pushl $0
80107cd4:	6a 00                	push   $0x0
  pushl $216
80107cd6:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107cdb:	e9 0e f0 ff ff       	jmp    80106cee <alltraps>

80107ce0 <vector217>:
.globl vector217
vector217:
  pushl $0
80107ce0:	6a 00                	push   $0x0
  pushl $217
80107ce2:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ce7:	e9 02 f0 ff ff       	jmp    80106cee <alltraps>

80107cec <vector218>:
.globl vector218
vector218:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $218
80107cee:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107cf3:	e9 f6 ef ff ff       	jmp    80106cee <alltraps>

80107cf8 <vector219>:
.globl vector219
vector219:
  pushl $0
80107cf8:	6a 00                	push   $0x0
  pushl $219
80107cfa:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107cff:	e9 ea ef ff ff       	jmp    80106cee <alltraps>

80107d04 <vector220>:
.globl vector220
vector220:
  pushl $0
80107d04:	6a 00                	push   $0x0
  pushl $220
80107d06:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107d0b:	e9 de ef ff ff       	jmp    80106cee <alltraps>

80107d10 <vector221>:
.globl vector221
vector221:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $221
80107d12:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d17:	e9 d2 ef ff ff       	jmp    80106cee <alltraps>

80107d1c <vector222>:
.globl vector222
vector222:
  pushl $0
80107d1c:	6a 00                	push   $0x0
  pushl $222
80107d1e:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d23:	e9 c6 ef ff ff       	jmp    80106cee <alltraps>

80107d28 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d28:	6a 00                	push   $0x0
  pushl $223
80107d2a:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d2f:	e9 ba ef ff ff       	jmp    80106cee <alltraps>

80107d34 <vector224>:
.globl vector224
vector224:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $224
80107d36:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d3b:	e9 ae ef ff ff       	jmp    80106cee <alltraps>

80107d40 <vector225>:
.globl vector225
vector225:
  pushl $0
80107d40:	6a 00                	push   $0x0
  pushl $225
80107d42:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d47:	e9 a2 ef ff ff       	jmp    80106cee <alltraps>

80107d4c <vector226>:
.globl vector226
vector226:
  pushl $0
80107d4c:	6a 00                	push   $0x0
  pushl $226
80107d4e:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d53:	e9 96 ef ff ff       	jmp    80106cee <alltraps>

80107d58 <vector227>:
.globl vector227
vector227:
  pushl $0
80107d58:	6a 00                	push   $0x0
  pushl $227
80107d5a:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d5f:	e9 8a ef ff ff       	jmp    80106cee <alltraps>

80107d64 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d64:	6a 00                	push   $0x0
  pushl $228
80107d66:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d6b:	e9 7e ef ff ff       	jmp    80106cee <alltraps>

80107d70 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d70:	6a 00                	push   $0x0
  pushl $229
80107d72:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d77:	e9 72 ef ff ff       	jmp    80106cee <alltraps>

80107d7c <vector230>:
.globl vector230
vector230:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $230
80107d7e:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d83:	e9 66 ef ff ff       	jmp    80106cee <alltraps>

80107d88 <vector231>:
.globl vector231
vector231:
  pushl $0
80107d88:	6a 00                	push   $0x0
  pushl $231
80107d8a:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d8f:	e9 5a ef ff ff       	jmp    80106cee <alltraps>

80107d94 <vector232>:
.globl vector232
vector232:
  pushl $0
80107d94:	6a 00                	push   $0x0
  pushl $232
80107d96:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d9b:	e9 4e ef ff ff       	jmp    80106cee <alltraps>

80107da0 <vector233>:
.globl vector233
vector233:
  pushl $0
80107da0:	6a 00                	push   $0x0
  pushl $233
80107da2:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107da7:	e9 42 ef ff ff       	jmp    80106cee <alltraps>

80107dac <vector234>:
.globl vector234
vector234:
  pushl $0
80107dac:	6a 00                	push   $0x0
  pushl $234
80107dae:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107db3:	e9 36 ef ff ff       	jmp    80106cee <alltraps>

80107db8 <vector235>:
.globl vector235
vector235:
  pushl $0
80107db8:	6a 00                	push   $0x0
  pushl $235
80107dba:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107dbf:	e9 2a ef ff ff       	jmp    80106cee <alltraps>

80107dc4 <vector236>:
.globl vector236
vector236:
  pushl $0
80107dc4:	6a 00                	push   $0x0
  pushl $236
80107dc6:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107dcb:	e9 1e ef ff ff       	jmp    80106cee <alltraps>

80107dd0 <vector237>:
.globl vector237
vector237:
  pushl $0
80107dd0:	6a 00                	push   $0x0
  pushl $237
80107dd2:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107dd7:	e9 12 ef ff ff       	jmp    80106cee <alltraps>

80107ddc <vector238>:
.globl vector238
vector238:
  pushl $0
80107ddc:	6a 00                	push   $0x0
  pushl $238
80107dde:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107de3:	e9 06 ef ff ff       	jmp    80106cee <alltraps>

80107de8 <vector239>:
.globl vector239
vector239:
  pushl $0
80107de8:	6a 00                	push   $0x0
  pushl $239
80107dea:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107def:	e9 fa ee ff ff       	jmp    80106cee <alltraps>

80107df4 <vector240>:
.globl vector240
vector240:
  pushl $0
80107df4:	6a 00                	push   $0x0
  pushl $240
80107df6:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107dfb:	e9 ee ee ff ff       	jmp    80106cee <alltraps>

80107e00 <vector241>:
.globl vector241
vector241:
  pushl $0
80107e00:	6a 00                	push   $0x0
  pushl $241
80107e02:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107e07:	e9 e2 ee ff ff       	jmp    80106cee <alltraps>

80107e0c <vector242>:
.globl vector242
vector242:
  pushl $0
80107e0c:	6a 00                	push   $0x0
  pushl $242
80107e0e:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e13:	e9 d6 ee ff ff       	jmp    80106cee <alltraps>

80107e18 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e18:	6a 00                	push   $0x0
  pushl $243
80107e1a:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e1f:	e9 ca ee ff ff       	jmp    80106cee <alltraps>

80107e24 <vector244>:
.globl vector244
vector244:
  pushl $0
80107e24:	6a 00                	push   $0x0
  pushl $244
80107e26:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e2b:	e9 be ee ff ff       	jmp    80106cee <alltraps>

80107e30 <vector245>:
.globl vector245
vector245:
  pushl $0
80107e30:	6a 00                	push   $0x0
  pushl $245
80107e32:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e37:	e9 b2 ee ff ff       	jmp    80106cee <alltraps>

80107e3c <vector246>:
.globl vector246
vector246:
  pushl $0
80107e3c:	6a 00                	push   $0x0
  pushl $246
80107e3e:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e43:	e9 a6 ee ff ff       	jmp    80106cee <alltraps>

80107e48 <vector247>:
.globl vector247
vector247:
  pushl $0
80107e48:	6a 00                	push   $0x0
  pushl $247
80107e4a:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e4f:	e9 9a ee ff ff       	jmp    80106cee <alltraps>

80107e54 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $248
80107e56:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e5b:	e9 8e ee ff ff       	jmp    80106cee <alltraps>

80107e60 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e60:	6a 00                	push   $0x0
  pushl $249
80107e62:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e67:	e9 82 ee ff ff       	jmp    80106cee <alltraps>

80107e6c <vector250>:
.globl vector250
vector250:
  pushl $0
80107e6c:	6a 00                	push   $0x0
  pushl $250
80107e6e:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e73:	e9 76 ee ff ff       	jmp    80106cee <alltraps>

80107e78 <vector251>:
.globl vector251
vector251:
  pushl $0
80107e78:	6a 00                	push   $0x0
  pushl $251
80107e7a:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e7f:	e9 6a ee ff ff       	jmp    80106cee <alltraps>

80107e84 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e84:	6a 00                	push   $0x0
  pushl $252
80107e86:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e8b:	e9 5e ee ff ff       	jmp    80106cee <alltraps>

80107e90 <vector253>:
.globl vector253
vector253:
  pushl $0
80107e90:	6a 00                	push   $0x0
  pushl $253
80107e92:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e97:	e9 52 ee ff ff       	jmp    80106cee <alltraps>

80107e9c <vector254>:
.globl vector254
vector254:
  pushl $0
80107e9c:	6a 00                	push   $0x0
  pushl $254
80107e9e:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107ea3:	e9 46 ee ff ff       	jmp    80106cee <alltraps>

80107ea8 <vector255>:
.globl vector255
vector255:
  pushl $0
80107ea8:	6a 00                	push   $0x0
  pushl $255
80107eaa:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107eaf:	e9 3a ee ff ff       	jmp    80106cee <alltraps>

80107eb4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107eb4:	55                   	push   %ebp
80107eb5:	89 e5                	mov    %esp,%ebp
80107eb7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ebd:	83 e8 01             	sub    $0x1,%eax
80107ec0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ece:	c1 e8 10             	shr    $0x10,%eax
80107ed1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ed5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ed8:	0f 01 10             	lgdtl  (%eax)
}
80107edb:	c9                   	leave  
80107edc:	c3                   	ret    

80107edd <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107edd:	55                   	push   %ebp
80107ede:	89 e5                	mov    %esp,%ebp
80107ee0:	83 ec 04             	sub    $0x4,%esp
80107ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107eea:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107eee:	0f 00 d8             	ltr    %ax
}
80107ef1:	c9                   	leave  
80107ef2:	c3                   	ret    

80107ef3 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107ef3:	55                   	push   %ebp
80107ef4:	89 e5                	mov    %esp,%ebp
80107ef6:	83 ec 04             	sub    $0x4,%esp
80107ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80107efc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f00:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f04:	8e e8                	mov    %eax,%gs
}
80107f06:	c9                   	leave  
80107f07:	c3                   	ret    

80107f08 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107f08:	55                   	push   %ebp
80107f09:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0e:	0f 22 d8             	mov    %eax,%cr3
}
80107f11:	5d                   	pop    %ebp
80107f12:	c3                   	ret    

80107f13 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107f13:	55                   	push   %ebp
80107f14:	89 e5                	mov    %esp,%ebp
80107f16:	8b 45 08             	mov    0x8(%ebp),%eax
80107f19:	05 00 00 00 80       	add    $0x80000000,%eax
80107f1e:	5d                   	pop    %ebp
80107f1f:	c3                   	ret    

80107f20 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f20:	55                   	push   %ebp
80107f21:	89 e5                	mov    %esp,%ebp
80107f23:	8b 45 08             	mov    0x8(%ebp),%eax
80107f26:	05 00 00 00 80       	add    $0x80000000,%eax
80107f2b:	5d                   	pop    %ebp
80107f2c:	c3                   	ret    

80107f2d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f2d:	55                   	push   %ebp
80107f2e:	89 e5                	mov    %esp,%ebp
80107f30:	53                   	push   %ebx
80107f31:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f34:	e8 a9 af ff ff       	call   80102ee2 <cpunum>
80107f39:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107f3f:	05 40 34 11 80       	add    $0x80113440,%eax
80107f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f53:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5c:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f63:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f67:	83 e2 f0             	and    $0xfffffff0,%edx
80107f6a:	83 ca 0a             	or     $0xa,%edx
80107f6d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f77:	83 ca 10             	or     $0x10,%edx
80107f7a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f80:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f84:	83 e2 9f             	and    $0xffffff9f,%edx
80107f87:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f91:	83 ca 80             	or     $0xffffff80,%edx
80107f94:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f9e:	83 ca 0f             	or     $0xf,%edx
80107fa1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fab:	83 e2 ef             	and    $0xffffffef,%edx
80107fae:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fb8:	83 e2 df             	and    $0xffffffdf,%edx
80107fbb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fc5:	83 ca 40             	or     $0x40,%edx
80107fc8:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fce:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fd2:	83 ca 80             	or     $0xffffff80,%edx
80107fd5:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe2:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107fe9:	ff ff 
80107feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fee:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107ff5:	00 00 
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010800b:	83 e2 f0             	and    $0xfffffff0,%edx
8010800e:	83 ca 02             	or     $0x2,%edx
80108011:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108021:	83 ca 10             	or     $0x10,%edx
80108024:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010802a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108034:	83 e2 9f             	and    $0xffffff9f,%edx
80108037:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108047:	83 ca 80             	or     $0xffffff80,%edx
8010804a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010805a:	83 ca 0f             	or     $0xf,%edx
8010805d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108066:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010806d:	83 e2 ef             	and    $0xffffffef,%edx
80108070:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108079:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108080:	83 e2 df             	and    $0xffffffdf,%edx
80108083:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108093:	83 ca 40             	or     $0x40,%edx
80108096:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010809c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080a6:	83 ca 80             	or     $0xffffff80,%edx
801080a9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b2:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801080b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bc:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080c3:	ff ff 
801080c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c8:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080cf:	00 00 
801080d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d4:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080de:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080e5:	83 e2 f0             	and    $0xfffffff0,%edx
801080e8:	83 ca 0a             	or     $0xa,%edx
801080eb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080fb:	83 ca 10             	or     $0x10,%edx
801080fe:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108107:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010810e:	83 ca 60             	or     $0x60,%edx
80108111:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108121:	83 ca 80             	or     $0xffffff80,%edx
80108124:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010812a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108134:	83 ca 0f             	or     $0xf,%edx
80108137:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010813d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108140:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108147:	83 e2 ef             	and    $0xffffffef,%edx
8010814a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108153:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010815a:	83 e2 df             	and    $0xffffffdf,%edx
8010815d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010816d:	83 ca 40             	or     $0x40,%edx
80108170:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108179:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108180:	83 ca 80             	or     $0xffffff80,%edx
80108183:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108189:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108196:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010819d:	ff ff 
8010819f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a2:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801081a9:	00 00 
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081bf:	83 e2 f0             	and    $0xfffffff0,%edx
801081c2:	83 ca 02             	or     $0x2,%edx
801081c5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ce:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081d5:	83 ca 10             	or     $0x10,%edx
801081d8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081e8:	83 ca 60             	or     $0x60,%edx
801081eb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081fb:	83 ca 80             	or     $0xffffff80,%edx
801081fe:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108207:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010820e:	83 ca 0f             	or     $0xf,%edx
80108211:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108221:	83 e2 ef             	and    $0xffffffef,%edx
80108224:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010822a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108234:	83 e2 df             	and    $0xffffffdf,%edx
80108237:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010823d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108240:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108247:	83 ca 40             	or     $0x40,%edx
8010824a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108253:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010825a:	83 ca 80             	or     $0xffffff80,%edx
8010825d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108266:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	05 b4 00 00 00       	add    $0xb4,%eax
80108275:	89 c3                	mov    %eax,%ebx
80108277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827a:	05 b4 00 00 00       	add    $0xb4,%eax
8010827f:	c1 e8 10             	shr    $0x10,%eax
80108282:	89 c2                	mov    %eax,%edx
80108284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108287:	05 b4 00 00 00       	add    $0xb4,%eax
8010828c:	c1 e8 18             	shr    $0x18,%eax
8010828f:	89 c1                	mov    %eax,%ecx
80108291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108294:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010829b:	00 00 
8010829d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a0:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801082b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082ba:	83 e2 f0             	and    $0xfffffff0,%edx
801082bd:	83 ca 02             	or     $0x2,%edx
801082c0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082d0:	83 ca 10             	or     $0x10,%edx
801082d3:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082dc:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082e3:	83 e2 9f             	and    $0xffffff9f,%edx
801082e6:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ef:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082f6:	83 ca 80             	or     $0xffffff80,%edx
801082f9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108302:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108309:	83 e2 f0             	and    $0xfffffff0,%edx
8010830c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108315:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010831c:	83 e2 ef             	and    $0xffffffef,%edx
8010831f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108328:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010832f:	83 e2 df             	and    $0xffffffdf,%edx
80108332:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108342:	83 ca 40             	or     $0x40,%edx
80108345:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010834b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108355:	83 ca 80             	or     $0xffffff80,%edx
80108358:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010835e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108361:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836a:	83 c0 70             	add    $0x70,%eax
8010836d:	83 ec 08             	sub    $0x8,%esp
80108370:	6a 38                	push   $0x38
80108372:	50                   	push   %eax
80108373:	e8 3c fb ff ff       	call   80107eb4 <lgdt>
80108378:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010837b:	83 ec 0c             	sub    $0xc,%esp
8010837e:	6a 18                	push   $0x18
80108380:	e8 6e fb ff ff       	call   80107ef3 <loadgs>
80108385:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010838b:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108391:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108398:	00 00 00 00 
}
8010839c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010839f:	c9                   	leave  
801083a0:	c3                   	ret    

801083a1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083a1:	55                   	push   %ebp
801083a2:	89 e5                	mov    %esp,%ebp
801083a4:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801083aa:	c1 e8 16             	shr    $0x16,%eax
801083ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083b4:	8b 45 08             	mov    0x8(%ebp),%eax
801083b7:	01 d0                	add    %edx,%eax
801083b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801083bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083bf:	8b 00                	mov    (%eax),%eax
801083c1:	83 e0 01             	and    $0x1,%eax
801083c4:	85 c0                	test   %eax,%eax
801083c6:	74 18                	je     801083e0 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801083c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083cb:	8b 00                	mov    (%eax),%eax
801083cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083d2:	50                   	push   %eax
801083d3:	e8 48 fb ff ff       	call   80107f20 <p2v>
801083d8:	83 c4 04             	add    $0x4,%esp
801083db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083de:	eb 48                	jmp    80108428 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083e4:	74 0e                	je     801083f4 <walkpgdir+0x53>
801083e6:	e8 96 a7 ff ff       	call   80102b81 <kalloc>
801083eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083f2:	75 07                	jne    801083fb <walkpgdir+0x5a>
      return 0;
801083f4:	b8 00 00 00 00       	mov    $0x0,%eax
801083f9:	eb 44                	jmp    8010843f <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801083fb:	83 ec 04             	sub    $0x4,%esp
801083fe:	68 00 10 00 00       	push   $0x1000
80108403:	6a 00                	push   $0x0
80108405:	ff 75 f4             	pushl  -0xc(%ebp)
80108408:	e8 13 d2 ff ff       	call   80105620 <memset>
8010840d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108410:	83 ec 0c             	sub    $0xc,%esp
80108413:	ff 75 f4             	pushl  -0xc(%ebp)
80108416:	e8 f8 fa ff ff       	call   80107f13 <v2p>
8010841b:	83 c4 10             	add    $0x10,%esp
8010841e:	83 c8 07             	or     $0x7,%eax
80108421:	89 c2                	mov    %eax,%edx
80108423:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108426:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108428:	8b 45 0c             	mov    0xc(%ebp),%eax
8010842b:	c1 e8 0c             	shr    $0xc,%eax
8010842e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010843a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843d:	01 d0                	add    %edx,%eax
}
8010843f:	c9                   	leave  
80108440:	c3                   	ret    

80108441 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108441:	55                   	push   %ebp
80108442:	89 e5                	mov    %esp,%ebp
80108444:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108447:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010844f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108452:	8b 55 0c             	mov    0xc(%ebp),%edx
80108455:	8b 45 10             	mov    0x10(%ebp),%eax
80108458:	01 d0                	add    %edx,%eax
8010845a:	83 e8 01             	sub    $0x1,%eax
8010845d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108462:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108465:	83 ec 04             	sub    $0x4,%esp
80108468:	6a 01                	push   $0x1
8010846a:	ff 75 f4             	pushl  -0xc(%ebp)
8010846d:	ff 75 08             	pushl  0x8(%ebp)
80108470:	e8 2c ff ff ff       	call   801083a1 <walkpgdir>
80108475:	83 c4 10             	add    $0x10,%esp
80108478:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010847b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010847f:	75 07                	jne    80108488 <mappages+0x47>
      return -1;
80108481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108486:	eb 30                	jmp    801084b8 <mappages+0x77>
    *pte = pa | perm | PTE_P;
80108488:	8b 45 18             	mov    0x18(%ebp),%eax
8010848b:	0b 45 14             	or     0x14(%ebp),%eax
8010848e:	83 c8 01             	or     $0x1,%eax
80108491:	89 c2                	mov    %eax,%edx
80108493:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108496:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010849b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010849e:	75 08                	jne    801084a8 <mappages+0x67>
      break;
801084a0:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801084a1:	b8 00 00 00 00       	mov    $0x0,%eax
801084a6:	eb 10                	jmp    801084b8 <mappages+0x77>
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801084a8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801084af:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801084b6:	eb ad                	jmp    80108465 <mappages+0x24>
  return 0;
}
801084b8:	c9                   	leave  
801084b9:	c3                   	ret    

801084ba <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801084ba:	55                   	push   %ebp
801084bb:	89 e5                	mov    %esp,%ebp
801084bd:	53                   	push   %ebx
801084be:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801084c1:	e8 bb a6 ff ff       	call   80102b81 <kalloc>
801084c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084cd:	75 0a                	jne    801084d9 <setupkvm+0x1f>
    return 0;
801084cf:	b8 00 00 00 00       	mov    $0x0,%eax
801084d4:	e9 8e 00 00 00       	jmp    80108567 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801084d9:	83 ec 04             	sub    $0x4,%esp
801084dc:	68 00 10 00 00       	push   $0x1000
801084e1:	6a 00                	push   $0x0
801084e3:	ff 75 f0             	pushl  -0x10(%ebp)
801084e6:	e8 35 d1 ff ff       	call   80105620 <memset>
801084eb:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801084ee:	83 ec 0c             	sub    $0xc,%esp
801084f1:	68 00 00 00 0e       	push   $0xe000000
801084f6:	e8 25 fa ff ff       	call   80107f20 <p2v>
801084fb:	83 c4 10             	add    $0x10,%esp
801084fe:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108503:	76 0d                	jbe    80108512 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108505:	83 ec 0c             	sub    $0xc,%esp
80108508:	68 a0 92 10 80       	push   $0x801092a0
8010850d:	e8 4a 80 ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108512:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108519:	eb 40                	jmp    8010855b <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010851b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851e:	8b 48 0c             	mov    0xc(%eax),%ecx
80108521:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108524:	8b 50 04             	mov    0x4(%eax),%edx
80108527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010852a:	8b 58 08             	mov    0x8(%eax),%ebx
8010852d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108530:	8b 40 04             	mov    0x4(%eax),%eax
80108533:	29 c3                	sub    %eax,%ebx
80108535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108538:	8b 00                	mov    (%eax),%eax
8010853a:	83 ec 0c             	sub    $0xc,%esp
8010853d:	51                   	push   %ecx
8010853e:	52                   	push   %edx
8010853f:	53                   	push   %ebx
80108540:	50                   	push   %eax
80108541:	ff 75 f0             	pushl  -0x10(%ebp)
80108544:	e8 f8 fe ff ff       	call   80108441 <mappages>
80108549:	83 c4 20             	add    $0x20,%esp
8010854c:	85 c0                	test   %eax,%eax
8010854e:	79 07                	jns    80108557 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108550:	b8 00 00 00 00       	mov    $0x0,%eax
80108555:	eb 10                	jmp    80108567 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108557:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010855b:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108562:	72 b7                	jb     8010851b <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108564:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010856a:	c9                   	leave  
8010856b:	c3                   	ret    

8010856c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010856c:	55                   	push   %ebp
8010856d:	89 e5                	mov    %esp,%ebp
8010856f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108572:	e8 43 ff ff ff       	call   801084ba <setupkvm>
80108577:	a3 58 6c 11 80       	mov    %eax,0x80116c58
  switchkvm();
8010857c:	e8 02 00 00 00       	call   80108583 <switchkvm>
}
80108581:	c9                   	leave  
80108582:	c3                   	ret    

80108583 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108583:	55                   	push   %ebp
80108584:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108586:	a1 58 6c 11 80       	mov    0x80116c58,%eax
8010858b:	50                   	push   %eax
8010858c:	e8 82 f9 ff ff       	call   80107f13 <v2p>
80108591:	83 c4 04             	add    $0x4,%esp
80108594:	50                   	push   %eax
80108595:	e8 6e f9 ff ff       	call   80107f08 <lcr3>
8010859a:	83 c4 04             	add    $0x4,%esp
}
8010859d:	c9                   	leave  
8010859e:	c3                   	ret    

8010859f <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010859f:	55                   	push   %ebp
801085a0:	89 e5                	mov    %esp,%ebp
801085a2:	56                   	push   %esi
801085a3:	53                   	push   %ebx
  pushcli();
801085a4:	e8 75 cf ff ff       	call   8010551e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801085a9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085af:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085b6:	83 c2 08             	add    $0x8,%edx
801085b9:	89 d6                	mov    %edx,%esi
801085bb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085c2:	83 c2 08             	add    $0x8,%edx
801085c5:	c1 ea 10             	shr    $0x10,%edx
801085c8:	89 d3                	mov    %edx,%ebx
801085ca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085d1:	83 c2 08             	add    $0x8,%edx
801085d4:	c1 ea 18             	shr    $0x18,%edx
801085d7:	89 d1                	mov    %edx,%ecx
801085d9:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801085e0:	67 00 
801085e2:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801085e9:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801085ef:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801085f6:	83 e2 f0             	and    $0xfffffff0,%edx
801085f9:	83 ca 09             	or     $0x9,%edx
801085fc:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108602:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108609:	83 ca 10             	or     $0x10,%edx
8010860c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108612:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108619:	83 e2 9f             	and    $0xffffff9f,%edx
8010861c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108622:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108629:	83 ca 80             	or     $0xffffff80,%edx
8010862c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108632:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108639:	83 e2 f0             	and    $0xfffffff0,%edx
8010863c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108642:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108649:	83 e2 ef             	and    $0xffffffef,%edx
8010864c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108652:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108659:	83 e2 df             	and    $0xffffffdf,%edx
8010865c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108662:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108669:	83 ca 40             	or     $0x40,%edx
8010866c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108672:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108679:	83 e2 7f             	and    $0x7f,%edx
8010867c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108682:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108688:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010868e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108695:	83 e2 ef             	and    $0xffffffef,%edx
80108698:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010869e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086a4:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801086aa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086b0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801086b7:	8b 52 08             	mov    0x8(%edx),%edx
801086ba:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086c0:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801086c3:	83 ec 0c             	sub    $0xc,%esp
801086c6:	6a 30                	push   $0x30
801086c8:	e8 10 f8 ff ff       	call   80107edd <ltr>
801086cd:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801086d0:	8b 45 08             	mov    0x8(%ebp),%eax
801086d3:	8b 40 04             	mov    0x4(%eax),%eax
801086d6:	85 c0                	test   %eax,%eax
801086d8:	75 0d                	jne    801086e7 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801086da:	83 ec 0c             	sub    $0xc,%esp
801086dd:	68 b1 92 10 80       	push   $0x801092b1
801086e2:	e8 75 7e ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801086e7:	8b 45 08             	mov    0x8(%ebp),%eax
801086ea:	8b 40 04             	mov    0x4(%eax),%eax
801086ed:	83 ec 0c             	sub    $0xc,%esp
801086f0:	50                   	push   %eax
801086f1:	e8 1d f8 ff ff       	call   80107f13 <v2p>
801086f6:	83 c4 10             	add    $0x10,%esp
801086f9:	83 ec 0c             	sub    $0xc,%esp
801086fc:	50                   	push   %eax
801086fd:	e8 06 f8 ff ff       	call   80107f08 <lcr3>
80108702:	83 c4 10             	add    $0x10,%esp
  popcli();
80108705:	e8 58 ce ff ff       	call   80105562 <popcli>
}
8010870a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010870d:	5b                   	pop    %ebx
8010870e:	5e                   	pop    %esi
8010870f:	5d                   	pop    %ebp
80108710:	c3                   	ret    

80108711 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108711:	55                   	push   %ebp
80108712:	89 e5                	mov    %esp,%ebp
80108714:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108717:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010871e:	76 0d                	jbe    8010872d <inituvm+0x1c>
    panic("inituvm: more than a page");
80108720:	83 ec 0c             	sub    $0xc,%esp
80108723:	68 c5 92 10 80       	push   $0x801092c5
80108728:	e8 2f 7e ff ff       	call   8010055c <panic>
  mem = kalloc();
8010872d:	e8 4f a4 ff ff       	call   80102b81 <kalloc>
80108732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108735:	83 ec 04             	sub    $0x4,%esp
80108738:	68 00 10 00 00       	push   $0x1000
8010873d:	6a 00                	push   $0x0
8010873f:	ff 75 f4             	pushl  -0xc(%ebp)
80108742:	e8 d9 ce ff ff       	call   80105620 <memset>
80108747:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010874a:	83 ec 0c             	sub    $0xc,%esp
8010874d:	ff 75 f4             	pushl  -0xc(%ebp)
80108750:	e8 be f7 ff ff       	call   80107f13 <v2p>
80108755:	83 c4 10             	add    $0x10,%esp
80108758:	83 ec 0c             	sub    $0xc,%esp
8010875b:	6a 06                	push   $0x6
8010875d:	50                   	push   %eax
8010875e:	68 00 10 00 00       	push   $0x1000
80108763:	6a 00                	push   $0x0
80108765:	ff 75 08             	pushl  0x8(%ebp)
80108768:	e8 d4 fc ff ff       	call   80108441 <mappages>
8010876d:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108770:	83 ec 04             	sub    $0x4,%esp
80108773:	ff 75 10             	pushl  0x10(%ebp)
80108776:	ff 75 0c             	pushl  0xc(%ebp)
80108779:	ff 75 f4             	pushl  -0xc(%ebp)
8010877c:	e8 5e cf ff ff       	call   801056df <memmove>
80108781:	83 c4 10             	add    $0x10,%esp
}
80108784:	c9                   	leave  
80108785:	c3                   	ret    

80108786 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108786:	55                   	push   %ebp
80108787:	89 e5                	mov    %esp,%ebp
80108789:	53                   	push   %ebx
8010878a:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010878d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108790:	25 ff 0f 00 00       	and    $0xfff,%eax
80108795:	85 c0                	test   %eax,%eax
80108797:	74 0d                	je     801087a6 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108799:	83 ec 0c             	sub    $0xc,%esp
8010879c:	68 e0 92 10 80       	push   $0x801092e0
801087a1:	e8 b6 7d ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
801087a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087ad:	e9 95 00 00 00       	jmp    80108847 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801087b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b8:	01 d0                	add    %edx,%eax
801087ba:	83 ec 04             	sub    $0x4,%esp
801087bd:	6a 00                	push   $0x0
801087bf:	50                   	push   %eax
801087c0:	ff 75 08             	pushl  0x8(%ebp)
801087c3:	e8 d9 fb ff ff       	call   801083a1 <walkpgdir>
801087c8:	83 c4 10             	add    $0x10,%esp
801087cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087d2:	75 0d                	jne    801087e1 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801087d4:	83 ec 0c             	sub    $0xc,%esp
801087d7:	68 03 93 10 80       	push   $0x80109303
801087dc:	e8 7b 7d ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
801087e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087e4:	8b 00                	mov    (%eax),%eax
801087e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801087ee:	8b 45 18             	mov    0x18(%ebp),%eax
801087f1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801087f4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801087f9:	77 0b                	ja     80108806 <loaduvm+0x80>
      n = sz - i;
801087fb:	8b 45 18             	mov    0x18(%ebp),%eax
801087fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108801:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108804:	eb 07                	jmp    8010880d <loaduvm+0x87>
    else
      n = PGSIZE;
80108806:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010880d:	8b 55 14             	mov    0x14(%ebp),%edx
80108810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108813:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108816:	83 ec 0c             	sub    $0xc,%esp
80108819:	ff 75 e8             	pushl  -0x18(%ebp)
8010881c:	e8 ff f6 ff ff       	call   80107f20 <p2v>
80108821:	83 c4 10             	add    $0x10,%esp
80108824:	ff 75 f0             	pushl  -0x10(%ebp)
80108827:	53                   	push   %ebx
80108828:	50                   	push   %eax
80108829:	ff 75 10             	pushl  0x10(%ebp)
8010882c:	e8 fb 95 ff ff       	call   80101e2c <readi>
80108831:	83 c4 10             	add    $0x10,%esp
80108834:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108837:	74 07                	je     80108840 <loaduvm+0xba>
      return -1;
80108839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010883e:	eb 18                	jmp    80108858 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108840:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884a:	3b 45 18             	cmp    0x18(%ebp),%eax
8010884d:	0f 82 5f ff ff ff    	jb     801087b2 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108853:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010885b:	c9                   	leave  
8010885c:	c3                   	ret    

8010885d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010885d:	55                   	push   %ebp
8010885e:	89 e5                	mov    %esp,%ebp
80108860:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108863:	8b 45 10             	mov    0x10(%ebp),%eax
80108866:	85 c0                	test   %eax,%eax
80108868:	79 0a                	jns    80108874 <allocuvm+0x17>
    return 0;
8010886a:	b8 00 00 00 00       	mov    $0x0,%eax
8010886f:	e9 b0 00 00 00       	jmp    80108924 <allocuvm+0xc7>
  if(newsz < oldsz)
80108874:	8b 45 10             	mov    0x10(%ebp),%eax
80108877:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010887a:	73 08                	jae    80108884 <allocuvm+0x27>
    return oldsz;
8010887c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010887f:	e9 a0 00 00 00       	jmp    80108924 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108884:	8b 45 0c             	mov    0xc(%ebp),%eax
80108887:	05 ff 0f 00 00       	add    $0xfff,%eax
8010888c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108894:	eb 7f                	jmp    80108915 <allocuvm+0xb8>
    mem = kalloc();
80108896:	e8 e6 a2 ff ff       	call   80102b81 <kalloc>
8010889b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010889e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088a2:	75 2b                	jne    801088cf <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801088a4:	83 ec 0c             	sub    $0xc,%esp
801088a7:	68 21 93 10 80       	push   $0x80109321
801088ac:	e8 0e 7b ff ff       	call   801003bf <cprintf>
801088b1:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801088b4:	83 ec 04             	sub    $0x4,%esp
801088b7:	ff 75 0c             	pushl  0xc(%ebp)
801088ba:	ff 75 10             	pushl  0x10(%ebp)
801088bd:	ff 75 08             	pushl  0x8(%ebp)
801088c0:	e8 61 00 00 00       	call   80108926 <deallocuvm>
801088c5:	83 c4 10             	add    $0x10,%esp
      return 0;
801088c8:	b8 00 00 00 00       	mov    $0x0,%eax
801088cd:	eb 55                	jmp    80108924 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801088cf:	83 ec 04             	sub    $0x4,%esp
801088d2:	68 00 10 00 00       	push   $0x1000
801088d7:	6a 00                	push   $0x0
801088d9:	ff 75 f0             	pushl  -0x10(%ebp)
801088dc:	e8 3f cd ff ff       	call   80105620 <memset>
801088e1:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801088e4:	83 ec 0c             	sub    $0xc,%esp
801088e7:	ff 75 f0             	pushl  -0x10(%ebp)
801088ea:	e8 24 f6 ff ff       	call   80107f13 <v2p>
801088ef:	83 c4 10             	add    $0x10,%esp
801088f2:	89 c2                	mov    %eax,%edx
801088f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f7:	83 ec 0c             	sub    $0xc,%esp
801088fa:	6a 06                	push   $0x6
801088fc:	52                   	push   %edx
801088fd:	68 00 10 00 00       	push   $0x1000
80108902:	50                   	push   %eax
80108903:	ff 75 08             	pushl  0x8(%ebp)
80108906:	e8 36 fb ff ff       	call   80108441 <mappages>
8010890b:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010890e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108918:	3b 45 10             	cmp    0x10(%ebp),%eax
8010891b:	0f 82 75 ff ff ff    	jb     80108896 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108921:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108924:	c9                   	leave  
80108925:	c3                   	ret    

80108926 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108926:	55                   	push   %ebp
80108927:	89 e5                	mov    %esp,%ebp
80108929:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010892c:	8b 45 10             	mov    0x10(%ebp),%eax
8010892f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108932:	72 08                	jb     8010893c <deallocuvm+0x16>
    return oldsz;
80108934:	8b 45 0c             	mov    0xc(%ebp),%eax
80108937:	e9 a5 00 00 00       	jmp    801089e1 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
8010893c:	8b 45 10             	mov    0x10(%ebp),%eax
8010893f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108944:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010894c:	e9 81 00 00 00       	jmp    801089d2 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108954:	83 ec 04             	sub    $0x4,%esp
80108957:	6a 00                	push   $0x0
80108959:	50                   	push   %eax
8010895a:	ff 75 08             	pushl  0x8(%ebp)
8010895d:	e8 3f fa ff ff       	call   801083a1 <walkpgdir>
80108962:	83 c4 10             	add    $0x10,%esp
80108965:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010896c:	75 09                	jne    80108977 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010896e:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108975:	eb 54                	jmp    801089cb <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108977:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010897a:	8b 00                	mov    (%eax),%eax
8010897c:	83 e0 01             	and    $0x1,%eax
8010897f:	85 c0                	test   %eax,%eax
80108981:	74 48                	je     801089cb <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108983:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108986:	8b 00                	mov    (%eax),%eax
80108988:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010898d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108990:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108994:	75 0d                	jne    801089a3 <deallocuvm+0x7d>
        panic("kfree");
80108996:	83 ec 0c             	sub    $0xc,%esp
80108999:	68 39 93 10 80       	push   $0x80109339
8010899e:	e8 b9 7b ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
801089a3:	83 ec 0c             	sub    $0xc,%esp
801089a6:	ff 75 ec             	pushl  -0x14(%ebp)
801089a9:	e8 72 f5 ff ff       	call   80107f20 <p2v>
801089ae:	83 c4 10             	add    $0x10,%esp
801089b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801089b4:	83 ec 0c             	sub    $0xc,%esp
801089b7:	ff 75 e8             	pushl  -0x18(%ebp)
801089ba:	e8 26 a1 ff ff       	call   80102ae5 <kfree>
801089bf:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801089c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801089cb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089d8:	0f 82 73 ff ff ff    	jb     80108951 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801089de:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089e1:	c9                   	leave  
801089e2:	c3                   	ret    

801089e3 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801089e3:	55                   	push   %ebp
801089e4:	89 e5                	mov    %esp,%ebp
801089e6:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801089e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801089ed:	75 0d                	jne    801089fc <freevm+0x19>
    panic("freevm: no pgdir");
801089ef:	83 ec 0c             	sub    $0xc,%esp
801089f2:	68 3f 93 10 80       	push   $0x8010933f
801089f7:	e8 60 7b ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801089fc:	83 ec 04             	sub    $0x4,%esp
801089ff:	6a 00                	push   $0x0
80108a01:	68 00 00 00 80       	push   $0x80000000
80108a06:	ff 75 08             	pushl  0x8(%ebp)
80108a09:	e8 18 ff ff ff       	call   80108926 <deallocuvm>
80108a0e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a18:	eb 4f                	jmp    80108a69 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a24:	8b 45 08             	mov    0x8(%ebp),%eax
80108a27:	01 d0                	add    %edx,%eax
80108a29:	8b 00                	mov    (%eax),%eax
80108a2b:	83 e0 01             	and    $0x1,%eax
80108a2e:	85 c0                	test   %eax,%eax
80108a30:	74 33                	je     80108a65 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80108a3f:	01 d0                	add    %edx,%eax
80108a41:	8b 00                	mov    (%eax),%eax
80108a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a48:	83 ec 0c             	sub    $0xc,%esp
80108a4b:	50                   	push   %eax
80108a4c:	e8 cf f4 ff ff       	call   80107f20 <p2v>
80108a51:	83 c4 10             	add    $0x10,%esp
80108a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108a57:	83 ec 0c             	sub    $0xc,%esp
80108a5a:	ff 75 f0             	pushl  -0x10(%ebp)
80108a5d:	e8 83 a0 ff ff       	call   80102ae5 <kfree>
80108a62:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108a65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108a69:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108a70:	76 a8                	jbe    80108a1a <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108a72:	83 ec 0c             	sub    $0xc,%esp
80108a75:	ff 75 08             	pushl  0x8(%ebp)
80108a78:	e8 68 a0 ff ff       	call   80102ae5 <kfree>
80108a7d:	83 c4 10             	add    $0x10,%esp
}
80108a80:	c9                   	leave  
80108a81:	c3                   	ret    

80108a82 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a82:	55                   	push   %ebp
80108a83:	89 e5                	mov    %esp,%ebp
80108a85:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a88:	83 ec 04             	sub    $0x4,%esp
80108a8b:	6a 00                	push   $0x0
80108a8d:	ff 75 0c             	pushl  0xc(%ebp)
80108a90:	ff 75 08             	pushl  0x8(%ebp)
80108a93:	e8 09 f9 ff ff       	call   801083a1 <walkpgdir>
80108a98:	83 c4 10             	add    $0x10,%esp
80108a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108aa2:	75 0d                	jne    80108ab1 <clearpteu+0x2f>
    panic("clearpteu");
80108aa4:	83 ec 0c             	sub    $0xc,%esp
80108aa7:	68 50 93 10 80       	push   $0x80109350
80108aac:	e8 ab 7a ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
80108ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab4:	8b 00                	mov    (%eax),%eax
80108ab6:	83 e0 fb             	and    $0xfffffffb,%eax
80108ab9:	89 c2                	mov    %eax,%edx
80108abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abe:	89 10                	mov    %edx,(%eax)
}
80108ac0:	c9                   	leave  
80108ac1:	c3                   	ret    

80108ac2 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108ac2:	55                   	push   %ebp
80108ac3:	89 e5                	mov    %esp,%ebp
80108ac5:	53                   	push   %ebx
80108ac6:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108ac9:	e8 ec f9 ff ff       	call   801084ba <setupkvm>
80108ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ad5:	75 0a                	jne    80108ae1 <copyuvm+0x1f>
    return 0;
80108ad7:	b8 00 00 00 00       	mov    $0x0,%eax
80108adc:	e9 df 00 00 00       	jmp    80108bc0 <copyuvm+0xfe>
  for(i = 0; i < sz; i += PGSIZE){
80108ae1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ae8:	e9 af 00 00 00       	jmp    80108b9c <copyuvm+0xda>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af0:	83 ec 04             	sub    $0x4,%esp
80108af3:	6a 00                	push   $0x0
80108af5:	50                   	push   %eax
80108af6:	ff 75 08             	pushl  0x8(%ebp)
80108af9:	e8 a3 f8 ff ff       	call   801083a1 <walkpgdir>
80108afe:	83 c4 10             	add    $0x10,%esp
80108b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b08:	75 0d                	jne    80108b17 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108b0a:	83 ec 0c             	sub    $0xc,%esp
80108b0d:	68 5a 93 10 80       	push   $0x8010935a
80108b12:	e8 45 7a ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80108b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b1a:	8b 00                	mov    (%eax),%eax
80108b1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b27:	8b 00                	mov    (%eax),%eax
80108b29:	25 ff 0f 00 00       	and    $0xfff,%eax
80108b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108b31:	e8 4b a0 ff ff       	call   80102b81 <kalloc>
80108b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108b3d:	75 02                	jne    80108b41 <copyuvm+0x7f>
      goto bad;
80108b3f:	eb 6c                	jmp    80108bad <copyuvm+0xeb>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b41:	83 ec 0c             	sub    $0xc,%esp
80108b44:	ff 75 e8             	pushl  -0x18(%ebp)
80108b47:	e8 d4 f3 ff ff       	call   80107f20 <p2v>
80108b4c:	83 c4 10             	add    $0x10,%esp
80108b4f:	83 ec 04             	sub    $0x4,%esp
80108b52:	68 00 10 00 00       	push   $0x1000
80108b57:	50                   	push   %eax
80108b58:	ff 75 e0             	pushl  -0x20(%ebp)
80108b5b:	e8 7f cb ff ff       	call   801056df <memmove>
80108b60:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108b63:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108b66:	83 ec 0c             	sub    $0xc,%esp
80108b69:	ff 75 e0             	pushl  -0x20(%ebp)
80108b6c:	e8 a2 f3 ff ff       	call   80107f13 <v2p>
80108b71:	83 c4 10             	add    $0x10,%esp
80108b74:	89 c2                	mov    %eax,%edx
80108b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b79:	83 ec 0c             	sub    $0xc,%esp
80108b7c:	53                   	push   %ebx
80108b7d:	52                   	push   %edx
80108b7e:	68 00 10 00 00       	push   $0x1000
80108b83:	50                   	push   %eax
80108b84:	ff 75 f0             	pushl  -0x10(%ebp)
80108b87:	e8 b5 f8 ff ff       	call   80108441 <mappages>
80108b8c:	83 c4 20             	add    $0x20,%esp
80108b8f:	85 c0                	test   %eax,%eax
80108b91:	79 02                	jns    80108b95 <copyuvm+0xd3>
      goto bad;
80108b93:	eb 18                	jmp    80108bad <copyuvm+0xeb>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b95:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ba2:	0f 82 45 ff ff ff    	jb     80108aed <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bab:	eb 13                	jmp    80108bc0 <copyuvm+0xfe>

bad:
  freevm(d);
80108bad:	83 ec 0c             	sub    $0xc,%esp
80108bb0:	ff 75 f0             	pushl  -0x10(%ebp)
80108bb3:	e8 2b fe ff ff       	call   801089e3 <freevm>
80108bb8:	83 c4 10             	add    $0x10,%esp
  return 0;
80108bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108bc3:	c9                   	leave  
80108bc4:	c3                   	ret    

80108bc5 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108bc5:	55                   	push   %ebp
80108bc6:	89 e5                	mov    %esp,%ebp
80108bc8:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108bcb:	83 ec 04             	sub    $0x4,%esp
80108bce:	6a 00                	push   $0x0
80108bd0:	ff 75 0c             	pushl  0xc(%ebp)
80108bd3:	ff 75 08             	pushl  0x8(%ebp)
80108bd6:	e8 c6 f7 ff ff       	call   801083a1 <walkpgdir>
80108bdb:	83 c4 10             	add    $0x10,%esp
80108bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be4:	8b 00                	mov    (%eax),%eax
80108be6:	83 e0 01             	and    $0x1,%eax
80108be9:	85 c0                	test   %eax,%eax
80108beb:	75 07                	jne    80108bf4 <uva2ka+0x2f>
    return 0;
80108bed:	b8 00 00 00 00       	mov    $0x0,%eax
80108bf2:	eb 29                	jmp    80108c1d <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf7:	8b 00                	mov    (%eax),%eax
80108bf9:	83 e0 04             	and    $0x4,%eax
80108bfc:	85 c0                	test   %eax,%eax
80108bfe:	75 07                	jne    80108c07 <uva2ka+0x42>
    return 0;
80108c00:	b8 00 00 00 00       	mov    $0x0,%eax
80108c05:	eb 16                	jmp    80108c1d <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0a:	8b 00                	mov    (%eax),%eax
80108c0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c11:	83 ec 0c             	sub    $0xc,%esp
80108c14:	50                   	push   %eax
80108c15:	e8 06 f3 ff ff       	call   80107f20 <p2v>
80108c1a:	83 c4 10             	add    $0x10,%esp
}
80108c1d:	c9                   	leave  
80108c1e:	c3                   	ret    

80108c1f <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c1f:	55                   	push   %ebp
80108c20:	89 e5                	mov    %esp,%ebp
80108c22:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c25:	8b 45 10             	mov    0x10(%ebp),%eax
80108c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c2b:	eb 7f                	jmp    80108cac <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c3b:	83 ec 08             	sub    $0x8,%esp
80108c3e:	50                   	push   %eax
80108c3f:	ff 75 08             	pushl  0x8(%ebp)
80108c42:	e8 7e ff ff ff       	call   80108bc5 <uva2ka>
80108c47:	83 c4 10             	add    $0x10,%esp
80108c4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c51:	75 07                	jne    80108c5a <copyout+0x3b>
      return -1;
80108c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c58:	eb 61                	jmp    80108cbb <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c5d:	2b 45 0c             	sub    0xc(%ebp),%eax
80108c60:	05 00 10 00 00       	add    $0x1000,%eax
80108c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c6b:	3b 45 14             	cmp    0x14(%ebp),%eax
80108c6e:	76 06                	jbe    80108c76 <copyout+0x57>
      n = len;
80108c70:	8b 45 14             	mov    0x14(%ebp),%eax
80108c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108c76:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c79:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108c7c:	89 c2                	mov    %eax,%edx
80108c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c81:	01 d0                	add    %edx,%eax
80108c83:	83 ec 04             	sub    $0x4,%esp
80108c86:	ff 75 f0             	pushl  -0x10(%ebp)
80108c89:	ff 75 f4             	pushl  -0xc(%ebp)
80108c8c:	50                   	push   %eax
80108c8d:	e8 4d ca ff ff       	call   801056df <memmove>
80108c92:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c98:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c9e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ca4:	05 00 10 00 00       	add    $0x1000,%eax
80108ca9:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108cac:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108cb0:	0f 85 77 ff ff ff    	jne    80108c2d <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cbb:	c9                   	leave  
80108cbc:	c3                   	ret    
