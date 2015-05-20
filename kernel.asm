
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b1 37 10 80       	mov    $0x801037b1,%eax
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
8010003d:	68 10 8c 10 80       	push   $0x80108c10
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 67 53 00 00       	call   801053b3 <initlock>
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
801000bf:	e8 10 53 00 00       	call   801053d4 <acquire>
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
8010010a:	e8 2b 53 00 00       	call   8010543a <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 d6 10 80       	push   $0x8010d680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 b6 4d 00 00       	call   80104ee0 <sleep>
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
80100186:	e8 af 52 00 00       	call   8010543a <release>
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
801001a8:	68 17 8c 10 80       	push   $0x80108c17
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
801001e0:	e8 5c 26 00 00       	call   80102841 <iderw>
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
80100202:	68 28 8c 10 80       	push   $0x80108c28
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
80100221:	e8 1b 26 00 00       	call   80102841 <iderw>
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
80100240:	68 2f 8c 10 80       	push   $0x80108c2f
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 d6 10 80       	push   $0x8010d680
80100252:	e8 7d 51 00 00       	call   801053d4 <acquire>
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
801002b6:	e8 48 4d 00 00       	call   80105003 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 d6 10 80       	push   $0x8010d680
801002c6:	e8 6f 51 00 00       	call   8010543a <release>
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
801003db:	e8 f4 4f 00 00       	call   801053d4 <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 36 8c 10 80       	push   $0x80108c36
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
801004c7:	c7 45 ec 3f 8c 10 80 	movl   $0x80108c3f,-0x14(%ebp)
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
80100552:	e8 e3 4e 00 00       	call   8010543a <release>
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
80100581:	68 46 8c 10 80       	push   $0x80108c46
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
801005a0:	68 55 8c 10 80       	push   $0x80108c55
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 ce 4e 00 00       	call   8010548b <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 57 8c 10 80       	push   $0x80108c57
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
801006d1:	e8 19 50 00 00       	call   801056ef <memmove>
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
801006fb:	e8 30 4f 00 00       	call   80105630 <memset>
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
8010078f:	e8 10 6b 00 00       	call   801072a4 <uartputc>
80100794:	83 c4 10             	add    $0x10,%esp
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	6a 20                	push   $0x20
8010079c:	e8 03 6b 00 00       	call   801072a4 <uartputc>
801007a1:	83 c4 10             	add    $0x10,%esp
801007a4:	83 ec 0c             	sub    $0xc,%esp
801007a7:	6a 08                	push   $0x8
801007a9:	e8 f6 6a 00 00       	call   801072a4 <uartputc>
801007ae:	83 c4 10             	add    $0x10,%esp
801007b1:	eb 0e                	jmp    801007c1 <consputc+0x56>
  } else
    uartputc(c);
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 08             	pushl  0x8(%ebp)
801007b9:	e8 e6 6a 00 00       	call   801072a4 <uartputc>
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
801007df:	e8 f0 4b 00 00       	call   801053d4 <acquire>
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
80100812:	e8 c1 48 00 00       	call   801050d8 <procdump>
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
80100926:	e8 d8 46 00 00       	call   80105003 <wakeup>
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
80100949:	e8 ec 4a 00 00       	call   8010543a <release>
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
8010095f:	e8 cd 10 00 00       	call   80101a31 <iunlock>
80100964:	83 c4 10             	add    $0x10,%esp
  target = n;
80100967:	8b 45 10             	mov    0x10(%ebp),%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010096d:	83 ec 0c             	sub    $0xc,%esp
80100970:	68 c0 17 11 80       	push   $0x801117c0
80100975:	e8 5a 4a 00 00       	call   801053d4 <acquire>
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
80100999:	e8 9c 4a 00 00       	call   8010543a <release>
8010099e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009a1:	83 ec 0c             	sub    $0xc,%esp
801009a4:	ff 75 08             	pushl  0x8(%ebp)
801009a7:	e8 2e 0f 00 00       	call   801018da <ilock>
801009ac:	83 c4 10             	add    $0x10,%esp
        return -1;
801009af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009b4:	e9 af 00 00 00       	jmp    80100a68 <consoleread+0x115>
      }
      sleep(&input.r, &input.lock);
801009b9:	83 ec 08             	sub    $0x8,%esp
801009bc:	68 c0 17 11 80       	push   $0x801117c0
801009c1:	68 74 18 11 80       	push   $0x80111874
801009c6:	e8 15 45 00 00       	call   80104ee0 <sleep>
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
80100a48:	e8 ed 49 00 00       	call   8010543a <release>
80100a4d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a50:	83 ec 0c             	sub    $0xc,%esp
80100a53:	ff 75 08             	pushl  0x8(%ebp)
80100a56:	e8 7f 0e 00 00       	call   801018da <ilock>
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
80100a76:	e8 b6 0f 00 00       	call   80101a31 <iunlock>
80100a7b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a86:	e8 49 49 00 00       	call   801053d4 <acquire>
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
80100ac8:	e8 6d 49 00 00       	call   8010543a <release>
80100acd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	ff 75 08             	pushl  0x8(%ebp)
80100ad6:	e8 ff 0d 00 00       	call   801018da <ilock>
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
80100aec:	68 5b 8c 10 80       	push   $0x80108c5b
80100af1:	68 e0 c5 10 80       	push   $0x8010c5e0
80100af6:	e8 b8 48 00 00       	call   801053b3 <initlock>
80100afb:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100afe:	83 ec 08             	sub    $0x8,%esp
80100b01:	68 63 8c 10 80       	push   $0x80108c63
80100b06:	68 c0 17 11 80       	push   $0x801117c0
80100b0b:	e8 a3 48 00 00       	call   801053b3 <initlock>
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
80100b36:	e8 10 33 00 00       	call   80103e4b <picenable>
80100b3b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b3e:	83 ec 08             	sub    $0x8,%esp
80100b41:	6a 00                	push   $0x0
80100b43:	6a 01                	push   $0x1
80100b45:	e8 c0 1e 00 00       	call   80102a0a <ioapicenable>
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
80100b58:	e8 15 29 00 00       	call   80103472 <begin_op>
  if((ip = namei(path)) == 0){
80100b5d:	83 ec 0c             	sub    $0xc,%esp
80100b60:	ff 75 08             	pushl  0x8(%ebp)
80100b63:	e8 35 19 00 00       	call   8010249d <namei>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b72:	75 0f                	jne    80100b83 <exec+0x34>
    end_op();
80100b74:	e8 87 29 00 00       	call   80103500 <end_op>
    return -1;
80100b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b7e:	e9 b9 03 00 00       	jmp    80100f3c <exec+0x3ed>
  }
  ilock(ip);
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	ff 75 d8             	pushl  -0x28(%ebp)
80100b89:	e8 4c 0d 00 00       	call   801018da <ilock>
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
80100ba6:	e8 91 12 00 00       	call   80101e3c <readi>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	83 f8 33             	cmp    $0x33,%eax
80100bb1:	77 05                	ja     80100bb8 <exec+0x69>
    goto bad;
80100bb3:	e9 52 03 00 00       	jmp    80100f0a <exec+0x3bb>
  if(elf.magic != ELF_MAGIC)
80100bb8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbe:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc3:	74 05                	je     80100bca <exec+0x7b>
    goto bad;
80100bc5:	e9 40 03 00 00       	jmp    80100f0a <exec+0x3bb>

  if((pgdir = setupkvm()) == 0)
80100bca:	e8 25 78 00 00       	call   801083f4 <setupkvm>
80100bcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bd6:	75 05                	jne    80100bdd <exec+0x8e>
    goto bad;
80100bd8:	e9 2d 03 00 00       	jmp    80100f0a <exec+0x3bb>

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
80100c09:	e8 2e 12 00 00       	call   80101e3c <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 20             	cmp    $0x20,%eax
80100c14:	74 05                	je     80100c1b <exec+0xcc>
      goto bad;
80100c16:	e9 ef 02 00 00       	jmp    80100f0a <exec+0x3bb>
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
80100c38:	e9 cd 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 3d 7b 00 00       	call   80108797 <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	75 05                	jne    80100c6b <exec+0x11c>
      goto bad;
80100c66:	e9 9f 02 00 00       	jmp    80100f0a <exec+0x3bb>
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
80100c89:	e8 32 7a 00 00       	call   801086c0 <loaduvm>
80100c8e:	83 c4 20             	add    $0x20,%esp
80100c91:	85 c0                	test   %eax,%eax
80100c93:	79 05                	jns    80100c9a <exec+0x14b>
      goto bad;
80100c95:	e9 70 02 00 00       	jmp    80100f0a <exec+0x3bb>
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
80100cc0:	e8 cc 0e 00 00       	call   80101b91 <iunlockput>
80100cc5:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc8:	e8 33 28 00 00       	call   80103500 <end_op>
  ip = 0;
80100ccd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd7:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce7:	05 00 20 00 00       	add    $0x2000,%eax
80100cec:	83 ec 04             	sub    $0x4,%esp
80100cef:	50                   	push   %eax
80100cf0:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf6:	e8 9c 7a 00 00       	call   80108797 <allocuvm>
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d05:	75 05                	jne    80100d0c <exec+0x1bd>
    goto bad;
80100d07:	e9 fe 01 00 00       	jmp    80100f0a <exec+0x3bb>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 9c 7c 00 00       	call   801089bc <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 98 00 00 00       	jmp    80100dcd <exec+0x27e>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	76 05                	jbe    80100d40 <exec+0x1f1>
      goto bad;
80100d3b:	e9 ca 01 00 00       	jmp    80100f0a <exec+0x3bb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4d:	01 d0                	add    %edx,%eax
80100d4f:	8b 00                	mov    (%eax),%eax
80100d51:	83 ec 0c             	sub    $0xc,%esp
80100d54:	50                   	push   %eax
80100d55:	e8 25 4b 00 00       	call   8010587f <strlen>
80100d5a:	83 c4 10             	add    $0x10,%esp
80100d5d:	89 c2                	mov    %eax,%edx
80100d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d62:	29 d0                	sub    %edx,%eax
80100d64:	83 e8 01             	sub    $0x1,%eax
80100d67:	83 e0 fc             	and    $0xfffffffc,%eax
80100d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7a:	01 d0                	add    %edx,%eax
80100d7c:	8b 00                	mov    (%eax),%eax
80100d7e:	83 ec 0c             	sub    $0xc,%esp
80100d81:	50                   	push   %eax
80100d82:	e8 f8 4a 00 00       	call   8010587f <strlen>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	83 c0 01             	add    $0x1,%eax
80100d8d:	89 c1                	mov    %eax,%ecx
80100d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9c:	01 d0                	add    %edx,%eax
80100d9e:	8b 00                	mov    (%eax),%eax
80100da0:	51                   	push   %ecx
80100da1:	50                   	push   %eax
80100da2:	ff 75 dc             	pushl  -0x24(%ebp)
80100da5:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da8:	e8 c5 7d 00 00       	call   80108b72 <copyout>
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	85 c0                	test   %eax,%eax
80100db2:	79 05                	jns    80100db9 <exec+0x26a>
      goto bad;
80100db4:	e9 51 01 00 00       	jmp    80100f0a <exec+0x3bb>
    ustack[3+argc] = sp;
80100db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbc:	8d 50 03             	lea    0x3(%eax),%edx
80100dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc2:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dda:	01 d0                	add    %edx,%eax
80100ddc:	8b 00                	mov    (%eax),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	0f 85 4f ff ff ff    	jne    80100d35 <exec+0x1e6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	83 c0 03             	add    $0x3,%eax
80100dec:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df7:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfe:	ff ff ff 
  ustack[1] = argc;
80100e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e04:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	29 d0                	sub    %edx,%eax
80100e1c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e25:	83 c0 04             	add    $0x4,%eax
80100e28:	c1 e0 02             	shl    $0x2,%eax
80100e2b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	83 c0 04             	add    $0x4,%eax
80100e34:	c1 e0 02             	shl    $0x2,%eax
80100e37:	50                   	push   %eax
80100e38:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3e:	50                   	push   %eax
80100e3f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e42:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e45:	e8 28 7d 00 00       	call   80108b72 <copyout>
80100e4a:	83 c4 10             	add    $0x10,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	79 05                	jns    80100e56 <exec+0x307>
    goto bad;
80100e51:	e9 b4 00 00 00       	jmp    80100f0a <exec+0x3bb>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e56:	8b 45 08             	mov    0x8(%ebp),%eax
80100e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e62:	eb 17                	jmp    80100e7b <exec+0x32c>
    if(*s == '/')
80100e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e67:	0f b6 00             	movzbl (%eax),%eax
80100e6a:	3c 2f                	cmp    $0x2f,%al
80100e6c:	75 09                	jne    80100e77 <exec+0x328>
      last = s+1;
80100e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e71:	83 c0 01             	add    $0x1,%eax
80100e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7e:	0f b6 00             	movzbl (%eax),%eax
80100e81:	84 c0                	test   %al,%al
80100e83:	75 df                	jne    80100e64 <exec+0x315>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8b:	83 c0 6c             	add    $0x6c,%eax
80100e8e:	83 ec 04             	sub    $0x4,%esp
80100e91:	6a 10                	push   $0x10
80100e93:	ff 75 f0             	pushl  -0x10(%ebp)
80100e96:	50                   	push   %eax
80100e97:	e8 99 49 00 00       	call   80105835 <safestrcpy>
80100e9c:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea5:	8b 40 04             	mov    0x4(%eax),%eax
80100ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100eab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb4:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ec0:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec8:	8b 40 18             	mov    0x18(%eax),%eax
80100ecb:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ed1:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eda:	8b 40 18             	mov    0x18(%eax),%eax
80100edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ee0:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	50                   	push   %eax
80100eed:	e8 e7 75 00 00       	call   801084d9 <switchuvm>
80100ef2:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 d0             	pushl  -0x30(%ebp)
80100efb:	e8 1d 7a 00 00       	call   8010891d <freevm>
80100f00:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f03:	b8 00 00 00 00       	mov    $0x0,%eax
80100f08:	eb 32                	jmp    80100f3c <exec+0x3ed>

 bad:
  if(pgdir)
80100f0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f0e:	74 0e                	je     80100f1e <exec+0x3cf>
    freevm(pgdir);
80100f10:	83 ec 0c             	sub    $0xc,%esp
80100f13:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f16:	e8 02 7a 00 00       	call   8010891d <freevm>
80100f1b:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f22:	74 13                	je     80100f37 <exec+0x3e8>
    iunlockput(ip);
80100f24:	83 ec 0c             	sub    $0xc,%esp
80100f27:	ff 75 d8             	pushl  -0x28(%ebp)
80100f2a:	e8 62 0c 00 00       	call   80101b91 <iunlockput>
80100f2f:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f32:	e8 c9 25 00 00       	call   80103500 <end_op>
  }
  return -1;
80100f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f3c:	c9                   	leave  
80100f3d:	c3                   	ret    

80100f3e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f3e:	55                   	push   %ebp
80100f3f:	89 e5                	mov    %esp,%ebp
80100f41:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f44:	83 ec 08             	sub    $0x8,%esp
80100f47:	68 69 8c 10 80       	push   $0x80108c69
80100f4c:	68 80 18 11 80       	push   $0x80111880
80100f51:	e8 5d 44 00 00       	call   801053b3 <initlock>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	c9                   	leave  
80100f5a:	c3                   	ret    

80100f5b <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f5b:	55                   	push   %ebp
80100f5c:	89 e5                	mov    %esp,%ebp
80100f5e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f61:	83 ec 0c             	sub    $0xc,%esp
80100f64:	68 80 18 11 80       	push   $0x80111880
80100f69:	e8 66 44 00 00       	call   801053d4 <acquire>
80100f6e:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f71:	c7 45 f4 b4 18 11 80 	movl   $0x801118b4,-0xc(%ebp)
80100f78:	eb 2d                	jmp    80100fa7 <filealloc+0x4c>
    if(f->ref == 0){
80100f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7d:	8b 40 04             	mov    0x4(%eax),%eax
80100f80:	85 c0                	test   %eax,%eax
80100f82:	75 1f                	jne    80100fa3 <filealloc+0x48>
      f->ref = 1;
80100f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f87:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
80100f91:	68 80 18 11 80       	push   $0x80111880
80100f96:	e8 9f 44 00 00       	call   8010543a <release>
80100f9b:	83 c4 10             	add    $0x10,%esp
      return f;
80100f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa1:	eb 22                	jmp    80100fc5 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa3:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa7:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
80100fae:	72 ca                	jb     80100f7a <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
80100fb3:	68 80 18 11 80       	push   $0x80111880
80100fb8:	e8 7d 44 00 00       	call   8010543a <release>
80100fbd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fc5:	c9                   	leave  
80100fc6:	c3                   	ret    

80100fc7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc7:	55                   	push   %ebp
80100fc8:	89 e5                	mov    %esp,%ebp
80100fca:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	68 80 18 11 80       	push   $0x80111880
80100fd5:	e8 fa 43 00 00       	call   801053d4 <acquire>
80100fda:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe0:	8b 40 04             	mov    0x4(%eax),%eax
80100fe3:	85 c0                	test   %eax,%eax
80100fe5:	7f 0d                	jg     80100ff4 <filedup+0x2d>
    panic("filedup");
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	68 70 8c 10 80       	push   $0x80108c70
80100fef:	e8 68 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff7:	8b 40 04             	mov    0x4(%eax),%eax
80100ffa:	8d 50 01             	lea    0x1(%eax),%edx
80100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80101000:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101003:	83 ec 0c             	sub    $0xc,%esp
80101006:	68 80 18 11 80       	push   $0x80111880
8010100b:	e8 2a 44 00 00       	call   8010543a <release>
80101010:	83 c4 10             	add    $0x10,%esp
  return f;
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101016:	c9                   	leave  
80101017:	c3                   	ret    

80101018 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101018:	55                   	push   %ebp
80101019:	89 e5                	mov    %esp,%ebp
8010101b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010101e:	83 ec 0c             	sub    $0xc,%esp
80101021:	68 80 18 11 80       	push   $0x80111880
80101026:	e8 a9 43 00 00       	call   801053d4 <acquire>
8010102b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010102e:	8b 45 08             	mov    0x8(%ebp),%eax
80101031:	8b 40 04             	mov    0x4(%eax),%eax
80101034:	85 c0                	test   %eax,%eax
80101036:	7f 0d                	jg     80101045 <fileclose+0x2d>
    panic("fileclose");
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 78 8c 10 80       	push   $0x80108c78
80101040:	e8 17 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104e:	8b 45 08             	mov    0x8(%ebp),%eax
80101051:	89 50 04             	mov    %edx,0x4(%eax)
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 15                	jle    80101073 <fileclose+0x5b>
    release(&ftable.lock);
8010105e:	83 ec 0c             	sub    $0xc,%esp
80101061:	68 80 18 11 80       	push   $0x80111880
80101066:	e8 cf 43 00 00       	call   8010543a <release>
8010106b:	83 c4 10             	add    $0x10,%esp
8010106e:	e9 8b 00 00 00       	jmp    801010fe <fileclose+0xe6>
    return;
  }
  ff = *f;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	8b 10                	mov    (%eax),%edx
80101078:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010107b:	8b 50 04             	mov    0x4(%eax),%edx
8010107e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101081:	8b 50 08             	mov    0x8(%eax),%edx
80101084:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101087:	8b 50 0c             	mov    0xc(%eax),%edx
8010108a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010108d:	8b 50 10             	mov    0x10(%eax),%edx
80101090:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101093:	8b 40 14             	mov    0x14(%eax),%eax
80101096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010a3:	8b 45 08             	mov    0x8(%ebp),%eax
801010a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 80 18 11 80       	push   $0x80111880
801010b4:	e8 81 43 00 00       	call   8010543a <release>
801010b9:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bf:	83 f8 01             	cmp    $0x1,%eax
801010c2:	75 19                	jne    801010dd <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010c4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010c8:	0f be d0             	movsbl %al,%edx
801010cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ce:	83 ec 08             	sub    $0x8,%esp
801010d1:	52                   	push   %edx
801010d2:	50                   	push   %eax
801010d3:	e8 da 2f 00 00       	call   801040b2 <pipeclose>
801010d8:	83 c4 10             	add    $0x10,%esp
801010db:	eb 21                	jmp    801010fe <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e0:	83 f8 02             	cmp    $0x2,%eax
801010e3:	75 19                	jne    801010fe <fileclose+0xe6>
    begin_op();
801010e5:	e8 88 23 00 00       	call   80103472 <begin_op>
    iput(ff.ip);
801010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010ed:	83 ec 0c             	sub    $0xc,%esp
801010f0:	50                   	push   %eax
801010f1:	e8 ac 09 00 00       	call   80101aa2 <iput>
801010f6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010f9:	e8 02 24 00 00       	call   80103500 <end_op>
  }
}
801010fe:	c9                   	leave  
801010ff:	c3                   	ret    

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101106:	8b 45 08             	mov    0x8(%ebp),%eax
80101109:	8b 00                	mov    (%eax),%eax
8010110b:	83 f8 02             	cmp    $0x2,%eax
8010110e:	75 40                	jne    80101150 <filestat+0x50>
    ilock(f->ip);
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 40 10             	mov    0x10(%eax),%eax
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	50                   	push   %eax
8010111a:	e8 bb 07 00 00       	call   801018da <ilock>
8010111f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101122:	8b 45 08             	mov    0x8(%ebp),%eax
80101125:	8b 40 10             	mov    0x10(%eax),%eax
80101128:	83 ec 08             	sub    $0x8,%esp
8010112b:	ff 75 0c             	pushl  0xc(%ebp)
8010112e:	50                   	push   %eax
8010112f:	e8 c3 0c 00 00       	call   80101df7 <stati>
80101134:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 10             	mov    0x10(%eax),%eax
8010113d:	83 ec 0c             	sub    $0xc,%esp
80101140:	50                   	push   %eax
80101141:	e8 eb 08 00 00       	call   80101a31 <iunlock>
80101146:	83 c4 10             	add    $0x10,%esp
    return 0;
80101149:	b8 00 00 00 00       	mov    $0x0,%eax
8010114e:	eb 05                	jmp    80101155 <filestat+0x55>
  }
  return -1;
80101150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101155:	c9                   	leave  
80101156:	c3                   	ret    

80101157 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101157:	55                   	push   %ebp
80101158:	89 e5                	mov    %esp,%ebp
8010115a:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101164:	84 c0                	test   %al,%al
80101166:	75 0a                	jne    80101172 <fileread+0x1b>
    return -1;
80101168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010116d:	e9 9b 00 00 00       	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_PIPE)
80101172:	8b 45 08             	mov    0x8(%ebp),%eax
80101175:	8b 00                	mov    (%eax),%eax
80101177:	83 f8 01             	cmp    $0x1,%eax
8010117a:	75 1a                	jne    80101196 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 40 0c             	mov    0xc(%eax),%eax
80101182:	83 ec 04             	sub    $0x4,%esp
80101185:	ff 75 10             	pushl  0x10(%ebp)
80101188:	ff 75 0c             	pushl  0xc(%ebp)
8010118b:	50                   	push   %eax
8010118c:	e8 ce 30 00 00       	call   8010425f <piperead>
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	eb 77                	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_INODE){
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	8b 00                	mov    (%eax),%eax
8010119b:	83 f8 02             	cmp    $0x2,%eax
8010119e:	75 60                	jne    80101200 <fileread+0xa9>
    ilock(f->ip);
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 40 10             	mov    0x10(%eax),%eax
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	50                   	push   %eax
801011aa:	e8 2b 07 00 00       	call   801018da <ilock>
801011af:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 50 14             	mov    0x14(%eax),%edx
801011bb:	8b 45 08             	mov    0x8(%ebp),%eax
801011be:	8b 40 10             	mov    0x10(%eax),%eax
801011c1:	51                   	push   %ecx
801011c2:	52                   	push   %edx
801011c3:	ff 75 0c             	pushl  0xc(%ebp)
801011c6:	50                   	push   %eax
801011c7:	e8 70 0c 00 00       	call   80101e3c <readi>
801011cc:	83 c4 10             	add    $0x10,%esp
801011cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011d6:	7e 11                	jle    801011e9 <fileread+0x92>
      f->off += r;
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	8b 50 14             	mov    0x14(%eax),%edx
801011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e1:	01 c2                	add    %eax,%edx
801011e3:	8b 45 08             	mov    0x8(%ebp),%eax
801011e6:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 40 10             	mov    0x10(%eax),%eax
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	50                   	push   %eax
801011f3:	e8 39 08 00 00       	call   80101a31 <iunlock>
801011f8:	83 c4 10             	add    $0x10,%esp
    return r;
801011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fe:	eb 0d                	jmp    8010120d <fileread+0xb6>
  }
  panic("fileread");
80101200:	83 ec 0c             	sub    $0xc,%esp
80101203:	68 82 8c 10 80       	push   $0x80108c82
80101208:	e8 4f f3 ff ff       	call   8010055c <panic>
}
8010120d:	c9                   	leave  
8010120e:	c3                   	ret    

8010120f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010120f:	55                   	push   %ebp
80101210:	89 e5                	mov    %esp,%ebp
80101212:	53                   	push   %ebx
80101213:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010121d:	84 c0                	test   %al,%al
8010121f:	75 0a                	jne    8010122b <filewrite+0x1c>
    return -1;
80101221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101226:	e9 1a 01 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_PIPE)
8010122b:	8b 45 08             	mov    0x8(%ebp),%eax
8010122e:	8b 00                	mov    (%eax),%eax
80101230:	83 f8 01             	cmp    $0x1,%eax
80101233:	75 1d                	jne    80101252 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101235:	8b 45 08             	mov    0x8(%ebp),%eax
80101238:	8b 40 0c             	mov    0xc(%eax),%eax
8010123b:	83 ec 04             	sub    $0x4,%esp
8010123e:	ff 75 10             	pushl  0x10(%ebp)
80101241:	ff 75 0c             	pushl  0xc(%ebp)
80101244:	50                   	push   %eax
80101245:	e8 11 2f 00 00       	call   8010415b <pipewrite>
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	e9 f3 00 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_INODE){
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 00                	mov    (%eax),%eax
80101257:	83 f8 02             	cmp    $0x2,%eax
8010125a:	0f 85 d8 00 00 00    	jne    80101338 <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101260:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010126e:	e9 a5 00 00 00       	jmp    80101318 <filewrite+0x109>
      int n1 = n - i;
80101273:	8b 45 10             	mov    0x10(%ebp),%eax
80101276:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101279:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101282:	7e 06                	jle    8010128a <filewrite+0x7b>
        n1 = max;
80101284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101287:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010128a:	e8 e3 21 00 00       	call   80103472 <begin_op>
      ilock(f->ip);
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 40 10             	mov    0x10(%eax),%eax
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	50                   	push   %eax
80101299:	e8 3c 06 00 00       	call   801018da <ilock>
8010129e:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012a4:	8b 45 08             	mov    0x8(%ebp),%eax
801012a7:	8b 50 14             	mov    0x14(%eax),%edx
801012aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b0:	01 c3                	add    %eax,%ebx
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 40 10             	mov    0x10(%eax),%eax
801012b8:	51                   	push   %ecx
801012b9:	52                   	push   %edx
801012ba:	53                   	push   %ebx
801012bb:	50                   	push   %eax
801012bc:	e8 dc 0c 00 00       	call   80101f9d <writei>
801012c1:	83 c4 10             	add    $0x10,%esp
801012c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012cb:	7e 11                	jle    801012de <filewrite+0xcf>
        f->off += r;
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 50 14             	mov    0x14(%eax),%edx
801012d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d6:	01 c2                	add    %eax,%edx
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012de:	8b 45 08             	mov    0x8(%ebp),%eax
801012e1:	8b 40 10             	mov    0x10(%eax),%eax
801012e4:	83 ec 0c             	sub    $0xc,%esp
801012e7:	50                   	push   %eax
801012e8:	e8 44 07 00 00       	call   80101a31 <iunlock>
801012ed:	83 c4 10             	add    $0x10,%esp
      end_op();
801012f0:	e8 0b 22 00 00       	call   80103500 <end_op>

      if(r < 0)
801012f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012f9:	79 02                	jns    801012fd <filewrite+0xee>
        break;
801012fb:	eb 27                	jmp    80101324 <filewrite+0x115>
      if(r != n1)
801012fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101303:	74 0d                	je     80101312 <filewrite+0x103>
        panic("short filewrite");
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	68 8b 8c 10 80       	push   $0x80108c8b
8010130d:	e8 4a f2 ff ff       	call   8010055c <panic>
      i += r;
80101312:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101315:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010131e:	0f 8c 4f ff ff ff    	jl     80101273 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101327:	3b 45 10             	cmp    0x10(%ebp),%eax
8010132a:	75 05                	jne    80101331 <filewrite+0x122>
8010132c:	8b 45 10             	mov    0x10(%ebp),%eax
8010132f:	eb 14                	jmp    80101345 <filewrite+0x136>
80101331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101336:	eb 0d                	jmp    80101345 <filewrite+0x136>
  }
  panic("filewrite");
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	68 9b 8c 10 80       	push   $0x80108c9b
80101340:	e8 17 f2 ff ff       	call   8010055c <panic>
}
80101345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101348:	c9                   	leave  
80101349:	c3                   	ret    

8010134a <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010134a:	55                   	push   %ebp
8010134b:	89 e5                	mov    %esp,%ebp
8010134d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101350:	8b 45 08             	mov    0x8(%ebp),%eax
80101353:	83 ec 08             	sub    $0x8,%esp
80101356:	6a 01                	push   $0x1
80101358:	50                   	push   %eax
80101359:	e8 56 ee ff ff       	call   801001b4 <bread>
8010135e:	83 c4 10             	add    $0x10,%esp
80101361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	83 c0 18             	add    $0x18,%eax
8010136a:	83 ec 04             	sub    $0x4,%esp
8010136d:	6a 10                	push   $0x10
8010136f:	50                   	push   %eax
80101370:	ff 75 0c             	pushl  0xc(%ebp)
80101373:	e8 77 43 00 00       	call   801056ef <memmove>
80101378:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	ff 75 f4             	pushl  -0xc(%ebp)
80101381:	e8 a5 ee ff ff       	call   8010022b <brelse>
80101386:	83 c4 10             	add    $0x10,%esp
}
80101389:	c9                   	leave  
8010138a:	c3                   	ret    

8010138b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010138b:	55                   	push   %ebp
8010138c:	89 e5                	mov    %esp,%ebp
8010138e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101391:	8b 55 0c             	mov    0xc(%ebp),%edx
80101394:	8b 45 08             	mov    0x8(%ebp),%eax
80101397:	83 ec 08             	sub    $0x8,%esp
8010139a:	52                   	push   %edx
8010139b:	50                   	push   %eax
8010139c:	e8 13 ee ff ff       	call   801001b4 <bread>
801013a1:	83 c4 10             	add    $0x10,%esp
801013a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013aa:	83 c0 18             	add    $0x18,%eax
801013ad:	83 ec 04             	sub    $0x4,%esp
801013b0:	68 00 02 00 00       	push   $0x200
801013b5:	6a 00                	push   $0x0
801013b7:	50                   	push   %eax
801013b8:	e8 73 42 00 00       	call   80105630 <memset>
801013bd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	ff 75 f4             	pushl  -0xc(%ebp)
801013c6:	e8 de 22 00 00       	call   801036a9 <log_write>
801013cb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ce:	83 ec 0c             	sub    $0xc,%esp
801013d1:	ff 75 f4             	pushl  -0xc(%ebp)
801013d4:	e8 52 ee ff ff       	call   8010022b <brelse>
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	c9                   	leave  
801013dd:	c3                   	ret    

801013de <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013de:	55                   	push   %ebp
801013df:	89 e5                	mov    %esp,%ebp
801013e1:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013eb:	8b 45 08             	mov    0x8(%ebp),%eax
801013ee:	83 ec 08             	sub    $0x8,%esp
801013f1:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013f4:	52                   	push   %edx
801013f5:	50                   	push   %eax
801013f6:	e8 4f ff ff ff       	call   8010134a <readsb>
801013fb:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801013fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101405:	e9 0c 01 00 00       	jmp    80101516 <balloc+0x138>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010140a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140d:	99                   	cltd   
8010140e:	c1 ea 14             	shr    $0x14,%edx
80101411:	01 d0                	add    %edx,%eax
80101413:	c1 f8 0c             	sar    $0xc,%eax
80101416:	89 c2                	mov    %eax,%edx
80101418:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010141b:	c1 e8 03             	shr    $0x3,%eax
8010141e:	01 d0                	add    %edx,%eax
80101420:	83 c0 03             	add    $0x3,%eax
80101423:	83 ec 08             	sub    $0x8,%esp
80101426:	50                   	push   %eax
80101427:	ff 75 08             	pushl  0x8(%ebp)
8010142a:	e8 85 ed ff ff       	call   801001b4 <bread>
8010142f:	83 c4 10             	add    $0x10,%esp
80101432:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010143c:	e9 a2 00 00 00       	jmp    801014e3 <balloc+0x105>
      m = 1 << (bi % 8);
80101441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101444:	99                   	cltd   
80101445:	c1 ea 1d             	shr    $0x1d,%edx
80101448:	01 d0                	add    %edx,%eax
8010144a:	83 e0 07             	and    $0x7,%eax
8010144d:	29 d0                	sub    %edx,%eax
8010144f:	ba 01 00 00 00       	mov    $0x1,%edx
80101454:	89 c1                	mov    %eax,%ecx
80101456:	d3 e2                	shl    %cl,%edx
80101458:	89 d0                	mov    %edx,%eax
8010145a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101460:	99                   	cltd   
80101461:	c1 ea 1d             	shr    $0x1d,%edx
80101464:	01 d0                	add    %edx,%eax
80101466:	c1 f8 03             	sar    $0x3,%eax
80101469:	89 c2                	mov    %eax,%edx
8010146b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101473:	0f b6 c0             	movzbl %al,%eax
80101476:	23 45 e8             	and    -0x18(%ebp),%eax
80101479:	85 c0                	test   %eax,%eax
8010147b:	75 62                	jne    801014df <balloc+0x101>
        bp->data[bi/8] |= m;  // Mark block in use.
8010147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101480:	99                   	cltd   
80101481:	c1 ea 1d             	shr    $0x1d,%edx
80101484:	01 d0                	add    %edx,%eax
80101486:	c1 f8 03             	sar    $0x3,%eax
80101489:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010148c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101491:	89 d1                	mov    %edx,%ecx
80101493:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101496:	09 ca                	or     %ecx,%edx
80101498:	89 d1                	mov    %edx,%ecx
8010149a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010149d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	ff 75 ec             	pushl  -0x14(%ebp)
801014a7:	e8 fd 21 00 00       	call   801036a9 <log_write>
801014ac:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	ff 75 ec             	pushl  -0x14(%ebp)
801014b5:	e8 71 ed ff ff       	call   8010022b <brelse>
801014ba:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c3:	01 c2                	add    %eax,%edx
801014c5:	8b 45 08             	mov    0x8(%ebp),%eax
801014c8:	83 ec 08             	sub    $0x8,%esp
801014cb:	52                   	push   %edx
801014cc:	50                   	push   %eax
801014cd:	e8 b9 fe ff ff       	call   8010138b <bzero>
801014d2:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014db:	01 d0                	add    %edx,%eax
801014dd:	eb 52                	jmp    80101531 <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014e3:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014ea:	7f 15                	jg     80101501 <balloc+0x123>
801014ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f2:	01 d0                	add    %edx,%eax
801014f4:	89 c2                	mov    %eax,%edx
801014f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014f9:	39 c2                	cmp    %eax,%edx
801014fb:	0f 82 40 ff ff ff    	jb     80101441 <balloc+0x63>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101501:	83 ec 0c             	sub    $0xc,%esp
80101504:	ff 75 ec             	pushl  -0x14(%ebp)
80101507:	e8 1f ed ff ff       	call   8010022b <brelse>
8010150c:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
8010150f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101519:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010151c:	39 c2                	cmp    %eax,%edx
8010151e:	0f 82 e6 fe ff ff    	jb     8010140a <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 a5 8c 10 80       	push   $0x80108ca5
8010152c:	e8 2b f0 ff ff       	call   8010055c <panic>
}
80101531:	c9                   	leave  
80101532:	c3                   	ret    

80101533 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101533:	55                   	push   %ebp
80101534:	89 e5                	mov    %esp,%ebp
80101536:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010153f:	50                   	push   %eax
80101540:	ff 75 08             	pushl  0x8(%ebp)
80101543:	e8 02 fe ff ff       	call   8010134a <readsb>
80101548:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010154b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010154e:	c1 e8 0c             	shr    $0xc,%eax
80101551:	89 c2                	mov    %eax,%edx
80101553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101556:	c1 e8 03             	shr    $0x3,%eax
80101559:	01 d0                	add    %edx,%eax
8010155b:	8d 50 03             	lea    0x3(%eax),%edx
8010155e:	8b 45 08             	mov    0x8(%ebp),%eax
80101561:	83 ec 08             	sub    $0x8,%esp
80101564:	52                   	push   %edx
80101565:	50                   	push   %eax
80101566:	e8 49 ec ff ff       	call   801001b4 <bread>
8010156b:	83 c4 10             	add    $0x10,%esp
8010156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101571:	8b 45 0c             	mov    0xc(%ebp),%eax
80101574:	25 ff 0f 00 00       	and    $0xfff,%eax
80101579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157f:	99                   	cltd   
80101580:	c1 ea 1d             	shr    $0x1d,%edx
80101583:	01 d0                	add    %edx,%eax
80101585:	83 e0 07             	and    $0x7,%eax
80101588:	29 d0                	sub    %edx,%eax
8010158a:	ba 01 00 00 00       	mov    $0x1,%edx
8010158f:	89 c1                	mov    %eax,%ecx
80101591:	d3 e2                	shl    %cl,%edx
80101593:	89 d0                	mov    %edx,%eax
80101595:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159b:	99                   	cltd   
8010159c:	c1 ea 1d             	shr    $0x1d,%edx
8010159f:	01 d0                	add    %edx,%eax
801015a1:	c1 f8 03             	sar    $0x3,%eax
801015a4:	89 c2                	mov    %eax,%edx
801015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a9:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ae:	0f b6 c0             	movzbl %al,%eax
801015b1:	23 45 ec             	and    -0x14(%ebp),%eax
801015b4:	85 c0                	test   %eax,%eax
801015b6:	75 0d                	jne    801015c5 <bfree+0x92>
    panic("freeing free block");
801015b8:	83 ec 0c             	sub    $0xc,%esp
801015bb:	68 bb 8c 10 80       	push   $0x80108cbb
801015c0:	e8 97 ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c8:	99                   	cltd   
801015c9:	c1 ea 1d             	shr    $0x1d,%edx
801015cc:	01 d0                	add    %edx,%eax
801015ce:	c1 f8 03             	sar    $0x3,%eax
801015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d4:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015d9:	89 d1                	mov    %edx,%ecx
801015db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015de:	f7 d2                	not    %edx
801015e0:	21 ca                	and    %ecx,%edx
801015e2:	89 d1                	mov    %edx,%ecx
801015e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015e7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	ff 75 f4             	pushl  -0xc(%ebp)
801015f1:	e8 b3 20 00 00       	call   801036a9 <log_write>
801015f6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015f9:	83 ec 0c             	sub    $0xc,%esp
801015fc:	ff 75 f4             	pushl  -0xc(%ebp)
801015ff:	e8 27 ec ff ff       	call   8010022b <brelse>
80101604:	83 c4 10             	add    $0x10,%esp
}
80101607:	c9                   	leave  
80101608:	c3                   	ret    

80101609 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101609:	55                   	push   %ebp
8010160a:	89 e5                	mov    %esp,%ebp
8010160c:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	68 ce 8c 10 80       	push   $0x80108cce
80101617:	68 c0 22 11 80       	push   $0x801122c0
8010161c:	e8 92 3d 00 00       	call   801053b3 <initlock>
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	c9                   	leave  
80101625:	c3                   	ret    

80101626 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101626:	55                   	push   %ebp
80101627:	89 e5                	mov    %esp,%ebp
80101629:	83 ec 38             	sub    $0x38,%esp
8010162c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101633:	8b 45 08             	mov    0x8(%ebp),%eax
80101636:	83 ec 08             	sub    $0x8,%esp
80101639:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010163c:	52                   	push   %edx
8010163d:	50                   	push   %eax
8010163e:	e8 07 fd ff ff       	call   8010134a <readsb>
80101643:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101646:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010164d:	e9 98 00 00 00       	jmp    801016ea <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
80101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101655:	c1 e8 03             	shr    $0x3,%eax
80101658:	83 c0 02             	add    $0x2,%eax
8010165b:	83 ec 08             	sub    $0x8,%esp
8010165e:	50                   	push   %eax
8010165f:	ff 75 08             	pushl  0x8(%ebp)
80101662:	e8 4d eb ff ff       	call   801001b4 <bread>
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	8d 50 18             	lea    0x18(%eax),%edx
80101673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101676:	83 e0 07             	and    $0x7,%eax
80101679:	c1 e0 06             	shl    $0x6,%eax
8010167c:	01 d0                	add    %edx,%eax
8010167e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101681:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101684:	0f b7 00             	movzwl (%eax),%eax
80101687:	66 85 c0             	test   %ax,%ax
8010168a:	75 4c                	jne    801016d8 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
8010168c:	83 ec 04             	sub    $0x4,%esp
8010168f:	6a 40                	push   $0x40
80101691:	6a 00                	push   $0x0
80101693:	ff 75 ec             	pushl  -0x14(%ebp)
80101696:	e8 95 3f 00 00       	call   80105630 <memset>
8010169b:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016a1:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016a5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016a8:	83 ec 0c             	sub    $0xc,%esp
801016ab:	ff 75 f0             	pushl  -0x10(%ebp)
801016ae:	e8 f6 1f 00 00       	call   801036a9 <log_write>
801016b3:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016b6:	83 ec 0c             	sub    $0xc,%esp
801016b9:	ff 75 f0             	pushl  -0x10(%ebp)
801016bc:	e8 6a eb ff ff       	call   8010022b <brelse>
801016c1:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c7:	83 ec 08             	sub    $0x8,%esp
801016ca:	50                   	push   %eax
801016cb:	ff 75 08             	pushl  0x8(%ebp)
801016ce:	e8 ee 00 00 00       	call   801017c1 <iget>
801016d3:	83 c4 10             	add    $0x10,%esp
801016d6:	eb 2d                	jmp    80101705 <ialloc+0xdf>
    }
    brelse(bp);
801016d8:	83 ec 0c             	sub    $0xc,%esp
801016db:	ff 75 f0             	pushl  -0x10(%ebp)
801016de:	e8 48 eb ff ff       	call   8010022b <brelse>
801016e3:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016f0:	39 c2                	cmp    %eax,%edx
801016f2:	0f 82 5a ff ff ff    	jb     80101652 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	68 d5 8c 10 80       	push   $0x80108cd5
80101700:	e8 57 ee ff ff       	call   8010055c <panic>
}
80101705:	c9                   	leave  
80101706:	c3                   	ret    

80101707 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101707:	55                   	push   %ebp
80101708:	89 e5                	mov    %esp,%ebp
8010170a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010170d:	8b 45 08             	mov    0x8(%ebp),%eax
80101710:	8b 40 04             	mov    0x4(%eax),%eax
80101713:	c1 e8 03             	shr    $0x3,%eax
80101716:	8d 50 02             	lea    0x2(%eax),%edx
80101719:	8b 45 08             	mov    0x8(%ebp),%eax
8010171c:	8b 00                	mov    (%eax),%eax
8010171e:	83 ec 08             	sub    $0x8,%esp
80101721:	52                   	push   %edx
80101722:	50                   	push   %eax
80101723:	e8 8c ea ff ff       	call   801001b4 <bread>
80101728:	83 c4 10             	add    $0x10,%esp
8010172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	8d 50 18             	lea    0x18(%eax),%edx
80101734:	8b 45 08             	mov    0x8(%ebp),%eax
80101737:	8b 40 04             	mov    0x4(%eax),%eax
8010173a:	83 e0 07             	and    $0x7,%eax
8010173d:	c1 e0 06             	shl    $0x6,%eax
80101740:	01 d0                	add    %edx,%eax
80101742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101745:	8b 45 08             	mov    0x8(%ebp),%eax
80101748:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101752:	8b 45 08             	mov    0x8(%ebp),%eax
80101755:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101759:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101760:	8b 45 08             	mov    0x8(%ebp),%eax
80101763:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010176e:	8b 45 08             	mov    0x8(%ebp),%eax
80101771:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010177c:	8b 45 08             	mov    0x8(%ebp),%eax
8010177f:	8b 50 18             	mov    0x18(%eax),%edx
80101782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101785:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101788:	8b 45 08             	mov    0x8(%ebp),%eax
8010178b:	8d 50 1c             	lea    0x1c(%eax),%edx
8010178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101791:	83 c0 0c             	add    $0xc,%eax
80101794:	83 ec 04             	sub    $0x4,%esp
80101797:	6a 34                	push   $0x34
80101799:	52                   	push   %edx
8010179a:	50                   	push   %eax
8010179b:	e8 4f 3f 00 00       	call   801056ef <memmove>
801017a0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017a3:	83 ec 0c             	sub    $0xc,%esp
801017a6:	ff 75 f4             	pushl  -0xc(%ebp)
801017a9:	e8 fb 1e 00 00       	call   801036a9 <log_write>
801017ae:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017b1:	83 ec 0c             	sub    $0xc,%esp
801017b4:	ff 75 f4             	pushl  -0xc(%ebp)
801017b7:	e8 6f ea ff ff       	call   8010022b <brelse>
801017bc:	83 c4 10             	add    $0x10,%esp
}
801017bf:	c9                   	leave  
801017c0:	c3                   	ret    

801017c1 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017c1:	55                   	push   %ebp
801017c2:	89 e5                	mov    %esp,%ebp
801017c4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017c7:	83 ec 0c             	sub    $0xc,%esp
801017ca:	68 c0 22 11 80       	push   $0x801122c0
801017cf:	e8 00 3c 00 00       	call   801053d4 <acquire>
801017d4:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801017d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017de:	c7 45 f4 f4 22 11 80 	movl   $0x801122f4,-0xc(%ebp)
801017e5:	eb 5d                	jmp    80101844 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ea:	8b 40 08             	mov    0x8(%eax),%eax
801017ed:	85 c0                	test   %eax,%eax
801017ef:	7e 39                	jle    8010182a <iget+0x69>
801017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f4:	8b 00                	mov    (%eax),%eax
801017f6:	3b 45 08             	cmp    0x8(%ebp),%eax
801017f9:	75 2f                	jne    8010182a <iget+0x69>
801017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fe:	8b 40 04             	mov    0x4(%eax),%eax
80101801:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101804:	75 24                	jne    8010182a <iget+0x69>
      ip->ref++;
80101806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101809:	8b 40 08             	mov    0x8(%eax),%eax
8010180c:	8d 50 01             	lea    0x1(%eax),%edx
8010180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101812:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101815:	83 ec 0c             	sub    $0xc,%esp
80101818:	68 c0 22 11 80       	push   $0x801122c0
8010181d:	e8 18 3c 00 00       	call   8010543a <release>
80101822:	83 c4 10             	add    $0x10,%esp
      return ip;
80101825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101828:	eb 74                	jmp    8010189e <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010182a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010182e:	75 10                	jne    80101840 <iget+0x7f>
80101830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101833:	8b 40 08             	mov    0x8(%eax),%eax
80101836:	85 c0                	test   %eax,%eax
80101838:	75 06                	jne    80101840 <iget+0x7f>
      empty = ip;
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101840:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101844:	81 7d f4 94 32 11 80 	cmpl   $0x80113294,-0xc(%ebp)
8010184b:	72 9a                	jb     801017e7 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010184d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101851:	75 0d                	jne    80101860 <iget+0x9f>
    panic("iget: no inodes");
80101853:	83 ec 0c             	sub    $0xc,%esp
80101856:	68 e7 8c 10 80       	push   $0x80108ce7
8010185b:	e8 fc ec ff ff       	call   8010055c <panic>

  ip = empty;
80101860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101869:	8b 55 08             	mov    0x8(%ebp),%edx
8010186c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101871:	8b 55 0c             	mov    0xc(%ebp),%edx
80101874:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010188b:	83 ec 0c             	sub    $0xc,%esp
8010188e:	68 c0 22 11 80       	push   $0x801122c0
80101893:	e8 a2 3b 00 00       	call   8010543a <release>
80101898:	83 c4 10             	add    $0x10,%esp

  return ip;
8010189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010189e:	c9                   	leave  
8010189f:	c3                   	ret    

801018a0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	68 c0 22 11 80       	push   $0x801122c0
801018ae:	e8 21 3b 00 00       	call   801053d4 <acquire>
801018b3:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	8b 40 08             	mov    0x8(%eax),%eax
801018bc:	8d 50 01             	lea    0x1(%eax),%edx
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
801018c2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	68 c0 22 11 80       	push   $0x801122c0
801018cd:	e8 68 3b 00 00       	call   8010543a <release>
801018d2:	83 c4 10             	add    $0x10,%esp
  return ip;
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018d8:	c9                   	leave  
801018d9:	c3                   	ret    

801018da <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018da:	55                   	push   %ebp
801018db:	89 e5                	mov    %esp,%ebp
801018dd:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018e4:	74 0a                	je     801018f0 <ilock+0x16>
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 08             	mov    0x8(%eax),%eax
801018ec:	85 c0                	test   %eax,%eax
801018ee:	7f 0d                	jg     801018fd <ilock+0x23>
    panic("ilock");
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 f7 8c 10 80       	push   $0x80108cf7
801018f8:	e8 5f ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
801018fd:	83 ec 0c             	sub    $0xc,%esp
80101900:	68 c0 22 11 80       	push   $0x801122c0
80101905:	e8 ca 3a 00 00       	call   801053d4 <acquire>
8010190a:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010190d:	eb 13                	jmp    80101922 <ilock+0x48>
    sleep(ip, &icache.lock);
8010190f:	83 ec 08             	sub    $0x8,%esp
80101912:	68 c0 22 11 80       	push   $0x801122c0
80101917:	ff 75 08             	pushl  0x8(%ebp)
8010191a:	e8 c1 35 00 00       	call   80104ee0 <sleep>
8010191f:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101922:	8b 45 08             	mov    0x8(%ebp),%eax
80101925:	8b 40 0c             	mov    0xc(%eax),%eax
80101928:	83 e0 01             	and    $0x1,%eax
8010192b:	85 c0                	test   %eax,%eax
8010192d:	75 e0                	jne    8010190f <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
80101932:	8b 40 0c             	mov    0xc(%eax),%eax
80101935:	83 c8 01             	or     $0x1,%eax
80101938:	89 c2                	mov    %eax,%edx
8010193a:	8b 45 08             	mov    0x8(%ebp),%eax
8010193d:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101940:	83 ec 0c             	sub    $0xc,%esp
80101943:	68 c0 22 11 80       	push   $0x801122c0
80101948:	e8 ed 3a 00 00       	call   8010543a <release>
8010194d:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101950:	8b 45 08             	mov    0x8(%ebp),%eax
80101953:	8b 40 0c             	mov    0xc(%eax),%eax
80101956:	83 e0 02             	and    $0x2,%eax
80101959:	85 c0                	test   %eax,%eax
8010195b:	0f 85 ce 00 00 00    	jne    80101a2f <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	8b 40 04             	mov    0x4(%eax),%eax
80101967:	c1 e8 03             	shr    $0x3,%eax
8010196a:	8d 50 02             	lea    0x2(%eax),%edx
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	8b 00                	mov    (%eax),%eax
80101972:	83 ec 08             	sub    $0x8,%esp
80101975:	52                   	push   %edx
80101976:	50                   	push   %eax
80101977:	e8 38 e8 ff ff       	call   801001b4 <bread>
8010197c:	83 c4 10             	add    $0x10,%esp
8010197f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101985:	8d 50 18             	lea    0x18(%eax),%edx
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	8b 40 04             	mov    0x4(%eax),%eax
8010198e:	83 e0 07             	and    $0x7,%eax
80101991:	c1 e0 06             	shl    $0x6,%eax
80101994:	01 d0                	add    %edx,%eax
80101996:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199c:	0f b7 10             	movzwl (%eax),%edx
8010199f:	8b 45 08             	mov    0x8(%ebp),%eax
801019a2:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a9:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b7:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019bb:	8b 45 08             	mov    0x8(%ebp),%eax
801019be:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d3:	8b 50 08             	mov    0x8(%eax),%edx
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019df:	8d 50 0c             	lea    0xc(%eax),%edx
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	83 c0 1c             	add    $0x1c,%eax
801019e8:	83 ec 04             	sub    $0x4,%esp
801019eb:	6a 34                	push   $0x34
801019ed:	52                   	push   %edx
801019ee:	50                   	push   %eax
801019ef:	e8 fb 3c 00 00       	call   801056ef <memmove>
801019f4:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801019f7:	83 ec 0c             	sub    $0xc,%esp
801019fa:	ff 75 f4             	pushl  -0xc(%ebp)
801019fd:	e8 29 e8 ff ff       	call   8010022b <brelse>
80101a02:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a05:	8b 45 08             	mov    0x8(%ebp),%eax
80101a08:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0b:	83 c8 02             	or     $0x2,%eax
80101a0e:	89 c2                	mov    %eax,%edx
80101a10:	8b 45 08             	mov    0x8(%ebp),%eax
80101a13:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a16:	8b 45 08             	mov    0x8(%ebp),%eax
80101a19:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a1d:	66 85 c0             	test   %ax,%ax
80101a20:	75 0d                	jne    80101a2f <ilock+0x155>
      panic("ilock: no type");
80101a22:	83 ec 0c             	sub    $0xc,%esp
80101a25:	68 fd 8c 10 80       	push   $0x80108cfd
80101a2a:	e8 2d eb ff ff       	call   8010055c <panic>
  }
}
80101a2f:	c9                   	leave  
80101a30:	c3                   	ret    

80101a31 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a31:	55                   	push   %ebp
80101a32:	89 e5                	mov    %esp,%ebp
80101a34:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a3b:	74 17                	je     80101a54 <iunlock+0x23>
80101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a40:	8b 40 0c             	mov    0xc(%eax),%eax
80101a43:	83 e0 01             	and    $0x1,%eax
80101a46:	85 c0                	test   %eax,%eax
80101a48:	74 0a                	je     80101a54 <iunlock+0x23>
80101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4d:	8b 40 08             	mov    0x8(%eax),%eax
80101a50:	85 c0                	test   %eax,%eax
80101a52:	7f 0d                	jg     80101a61 <iunlock+0x30>
    panic("iunlock");
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	68 0c 8d 10 80       	push   $0x80108d0c
80101a5c:	e8 fb ea ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101a61:	83 ec 0c             	sub    $0xc,%esp
80101a64:	68 c0 22 11 80       	push   $0x801122c0
80101a69:	e8 66 39 00 00       	call   801053d4 <acquire>
80101a6e:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 40 0c             	mov    0xc(%eax),%eax
80101a77:	83 e0 fe             	and    $0xfffffffe,%eax
80101a7a:	89 c2                	mov    %eax,%edx
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a82:	83 ec 0c             	sub    $0xc,%esp
80101a85:	ff 75 08             	pushl  0x8(%ebp)
80101a88:	e8 76 35 00 00       	call   80105003 <wakeup>
80101a8d:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101a90:	83 ec 0c             	sub    $0xc,%esp
80101a93:	68 c0 22 11 80       	push   $0x801122c0
80101a98:	e8 9d 39 00 00       	call   8010543a <release>
80101a9d:	83 c4 10             	add    $0x10,%esp
}
80101aa0:	c9                   	leave  
80101aa1:	c3                   	ret    

80101aa2 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101aa2:	55                   	push   %ebp
80101aa3:	89 e5                	mov    %esp,%ebp
80101aa5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aa8:	83 ec 0c             	sub    $0xc,%esp
80101aab:	68 c0 22 11 80       	push   $0x801122c0
80101ab0:	e8 1f 39 00 00       	call   801053d4 <acquire>
80101ab5:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80101abb:	8b 40 08             	mov    0x8(%eax),%eax
80101abe:	83 f8 01             	cmp    $0x1,%eax
80101ac1:	0f 85 a9 00 00 00    	jne    80101b70 <iput+0xce>
80101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aca:	8b 40 0c             	mov    0xc(%eax),%eax
80101acd:	83 e0 02             	and    $0x2,%eax
80101ad0:	85 c0                	test   %eax,%eax
80101ad2:	0f 84 98 00 00 00    	je     80101b70 <iput+0xce>
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101adf:	66 85 c0             	test   %ax,%ax
80101ae2:	0f 85 88 00 00 00    	jne    80101b70 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	8b 40 0c             	mov    0xc(%eax),%eax
80101aee:	83 e0 01             	and    $0x1,%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	74 0d                	je     80101b02 <iput+0x60>
      panic("iput busy");
80101af5:	83 ec 0c             	sub    $0xc,%esp
80101af8:	68 14 8d 10 80       	push   $0x80108d14
80101afd:	e8 5a ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	8b 40 0c             	mov    0xc(%eax),%eax
80101b08:	83 c8 01             	or     $0x1,%eax
80101b0b:	89 c2                	mov    %eax,%edx
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b13:	83 ec 0c             	sub    $0xc,%esp
80101b16:	68 c0 22 11 80       	push   $0x801122c0
80101b1b:	e8 1a 39 00 00       	call   8010543a <release>
80101b20:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	ff 75 08             	pushl  0x8(%ebp)
80101b29:	e8 a6 01 00 00       	call   80101cd4 <itrunc>
80101b2e:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b3a:	83 ec 0c             	sub    $0xc,%esp
80101b3d:	ff 75 08             	pushl  0x8(%ebp)
80101b40:	e8 c2 fb ff ff       	call   80101707 <iupdate>
80101b45:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b48:	83 ec 0c             	sub    $0xc,%esp
80101b4b:	68 c0 22 11 80       	push   $0x801122c0
80101b50:	e8 7f 38 00 00       	call   801053d4 <acquire>
80101b55:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b62:	83 ec 0c             	sub    $0xc,%esp
80101b65:	ff 75 08             	pushl  0x8(%ebp)
80101b68:	e8 96 34 00 00       	call   80105003 <wakeup>
80101b6d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	8b 40 08             	mov    0x8(%eax),%eax
80101b76:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b79:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b7f:	83 ec 0c             	sub    $0xc,%esp
80101b82:	68 c0 22 11 80       	push   $0x801122c0
80101b87:	e8 ae 38 00 00       	call   8010543a <release>
80101b8c:	83 c4 10             	add    $0x10,%esp
}
80101b8f:	c9                   	leave  
80101b90:	c3                   	ret    

80101b91 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b91:	55                   	push   %ebp
80101b92:	89 e5                	mov    %esp,%ebp
80101b94:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	ff 75 08             	pushl  0x8(%ebp)
80101b9d:	e8 8f fe ff ff       	call   80101a31 <iunlock>
80101ba2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ba5:	83 ec 0c             	sub    $0xc,%esp
80101ba8:	ff 75 08             	pushl  0x8(%ebp)
80101bab:	e8 f2 fe ff ff       	call   80101aa2 <iput>
80101bb0:	83 c4 10             	add    $0x10,%esp
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    

80101bb5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bb5:	55                   	push   %ebp
80101bb6:	89 e5                	mov    %esp,%ebp
80101bb8:	53                   	push   %ebx
80101bb9:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bbc:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bc0:	77 42                	ja     80101c04 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bc8:	83 c2 04             	add    $0x4,%edx
80101bcb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bd6:	75 24                	jne    80101bfc <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdb:	8b 00                	mov    (%eax),%eax
80101bdd:	83 ec 0c             	sub    $0xc,%esp
80101be0:	50                   	push   %eax
80101be1:	e8 f8 f7 ff ff       	call   801013de <balloc>
80101be6:	83 c4 10             	add    $0x10,%esp
80101be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bf2:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bf8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bff:	e9 cb 00 00 00       	jmp    80101ccf <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c04:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c08:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c0c:	0f 87 b0 00 00 00    	ja     80101cc2 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c1f:	75 1d                	jne    80101c3e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	8b 00                	mov    (%eax),%eax
80101c26:	83 ec 0c             	sub    $0xc,%esp
80101c29:	50                   	push   %eax
80101c2a:	e8 af f7 ff ff       	call   801013de <balloc>
80101c2f:	83 c4 10             	add    $0x10,%esp
80101c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c35:	8b 45 08             	mov    0x8(%ebp),%eax
80101c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	8b 00                	mov    (%eax),%eax
80101c43:	83 ec 08             	sub    $0x8,%esp
80101c46:	ff 75 f4             	pushl  -0xc(%ebp)
80101c49:	50                   	push   %eax
80101c4a:	e8 65 e5 ff ff       	call   801001b4 <bread>
80101c4f:	83 c4 10             	add    $0x10,%esp
80101c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c58:	83 c0 18             	add    $0x18,%eax
80101c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c6b:	01 d0                	add    %edx,%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c76:	75 37                	jne    80101caf <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101c78:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c85:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c88:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8b:	8b 00                	mov    (%eax),%eax
80101c8d:	83 ec 0c             	sub    $0xc,%esp
80101c90:	50                   	push   %eax
80101c91:	e8 48 f7 ff ff       	call   801013de <balloc>
80101c96:	83 c4 10             	add    $0x10,%esp
80101c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c9f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ca1:	83 ec 0c             	sub    $0xc,%esp
80101ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80101ca7:	e8 fd 19 00 00       	call   801036a9 <log_write>
80101cac:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101caf:	83 ec 0c             	sub    $0xc,%esp
80101cb2:	ff 75 f0             	pushl  -0x10(%ebp)
80101cb5:	e8 71 e5 ff ff       	call   8010022b <brelse>
80101cba:	83 c4 10             	add    $0x10,%esp
    return addr;
80101cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc0:	eb 0d                	jmp    80101ccf <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 1e 8d 10 80       	push   $0x80108d1e
80101cca:	e8 8d e8 ff ff       	call   8010055c <panic>
}
80101ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cd2:	c9                   	leave  
80101cd3:	c3                   	ret    

80101cd4 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ce1:	eb 45                	jmp    80101d28 <itrunc+0x54>
    if(ip->addrs[i]){
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce9:	83 c2 04             	add    $0x4,%edx
80101cec:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cf0:	85 c0                	test   %eax,%eax
80101cf2:	74 30                	je     80101d24 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfa:	83 c2 04             	add    $0x4,%edx
80101cfd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d01:	8b 55 08             	mov    0x8(%ebp),%edx
80101d04:	8b 12                	mov    (%edx),%edx
80101d06:	83 ec 08             	sub    $0x8,%esp
80101d09:	50                   	push   %eax
80101d0a:	52                   	push   %edx
80101d0b:	e8 23 f8 ff ff       	call   80101533 <bfree>
80101d10:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d19:	83 c2 04             	add    $0x4,%edx
80101d1c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d23:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d28:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d2c:	7e b5                	jle    80101ce3 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d31:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d34:	85 c0                	test   %eax,%eax
80101d36:	0f 84 a1 00 00 00    	je     80101ddd <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	8b 00                	mov    (%eax),%eax
80101d47:	83 ec 08             	sub    $0x8,%esp
80101d4a:	52                   	push   %edx
80101d4b:	50                   	push   %eax
80101d4c:	e8 63 e4 ff ff       	call   801001b4 <bread>
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d5a:	83 c0 18             	add    $0x18,%eax
80101d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d67:	eb 3c                	jmp    80101da5 <itrunc+0xd1>
      if(a[j])
80101d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d76:	01 d0                	add    %edx,%eax
80101d78:	8b 00                	mov    (%eax),%eax
80101d7a:	85 c0                	test   %eax,%eax
80101d7c:	74 23                	je     80101da1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d8b:	01 d0                	add    %edx,%eax
80101d8d:	8b 00                	mov    (%eax),%eax
80101d8f:	8b 55 08             	mov    0x8(%ebp),%edx
80101d92:	8b 12                	mov    (%edx),%edx
80101d94:	83 ec 08             	sub    $0x8,%esp
80101d97:	50                   	push   %eax
80101d98:	52                   	push   %edx
80101d99:	e8 95 f7 ff ff       	call   80101533 <bfree>
80101d9e:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101da1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da8:	83 f8 7f             	cmp    $0x7f,%eax
80101dab:	76 bc                	jbe    80101d69 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101dad:	83 ec 0c             	sub    $0xc,%esp
80101db0:	ff 75 ec             	pushl  -0x14(%ebp)
80101db3:	e8 73 e4 ff ff       	call   8010022b <brelse>
80101db8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbe:	8b 40 4c             	mov    0x4c(%eax),%eax
80101dc1:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc4:	8b 12                	mov    (%edx),%edx
80101dc6:	83 ec 08             	sub    $0x8,%esp
80101dc9:	50                   	push   %eax
80101dca:	52                   	push   %edx
80101dcb:	e8 63 f7 ff ff       	call   80101533 <bfree>
80101dd0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80101de0:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101de7:	83 ec 0c             	sub    $0xc,%esp
80101dea:	ff 75 08             	pushl  0x8(%ebp)
80101ded:	e8 15 f9 ff ff       	call   80101707 <iupdate>
80101df2:	83 c4 10             	add    $0x10,%esp
}
80101df5:	c9                   	leave  
80101df6:	c3                   	ret    

80101df7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101df7:	55                   	push   %ebp
80101df8:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfd:	8b 00                	mov    (%eax),%eax
80101dff:	89 c2                	mov    %eax,%edx
80101e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e04:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	8b 50 04             	mov    0x4(%eax),%edx
80101e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e10:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e31:	8b 50 18             	mov    0x18(%eax),%edx
80101e34:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e37:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    

80101e3c <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e3c:	55                   	push   %ebp
80101e3d:	89 e5                	mov    %esp,%ebp
80101e3f:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e49:	66 83 f8 03          	cmp    $0x3,%ax
80101e4d:	75 5c                	jne    80101eab <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e52:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e56:	66 85 c0             	test   %ax,%ax
80101e59:	78 20                	js     80101e7b <readi+0x3f>
80101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e62:	66 83 f8 09          	cmp    $0x9,%ax
80101e66:	7f 13                	jg     80101e7b <readi+0x3f>
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e6f:	98                   	cwtl   
80101e70:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101e77:	85 c0                	test   %eax,%eax
80101e79:	75 0a                	jne    80101e85 <readi+0x49>
      return -1;
80101e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e80:	e9 16 01 00 00       	jmp    80101f9b <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
80101e85:	8b 45 08             	mov    0x8(%ebp),%eax
80101e88:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e8c:	98                   	cwtl   
80101e8d:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101e94:	8b 55 14             	mov    0x14(%ebp),%edx
80101e97:	83 ec 04             	sub    $0x4,%esp
80101e9a:	52                   	push   %edx
80101e9b:	ff 75 0c             	pushl  0xc(%ebp)
80101e9e:	ff 75 08             	pushl  0x8(%ebp)
80101ea1:	ff d0                	call   *%eax
80101ea3:	83 c4 10             	add    $0x10,%esp
80101ea6:	e9 f0 00 00 00       	jmp    80101f9b <readi+0x15f>
  }

  if(off > ip->size || off + n < off)
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
80101eae:	8b 40 18             	mov    0x18(%eax),%eax
80101eb1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eb4:	72 0d                	jb     80101ec3 <readi+0x87>
80101eb6:	8b 55 10             	mov    0x10(%ebp),%edx
80101eb9:	8b 45 14             	mov    0x14(%ebp),%eax
80101ebc:	01 d0                	add    %edx,%eax
80101ebe:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ec1:	73 0a                	jae    80101ecd <readi+0x91>
    return -1;
80101ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec8:	e9 ce 00 00 00       	jmp    80101f9b <readi+0x15f>
  if(off + n > ip->size)
80101ecd:	8b 55 10             	mov    0x10(%ebp),%edx
80101ed0:	8b 45 14             	mov    0x14(%ebp),%eax
80101ed3:	01 c2                	add    %eax,%edx
80101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed8:	8b 40 18             	mov    0x18(%eax),%eax
80101edb:	39 c2                	cmp    %eax,%edx
80101edd:	76 0c                	jbe    80101eeb <readi+0xaf>
    n = ip->size - off;
80101edf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee2:	8b 40 18             	mov    0x18(%eax),%eax
80101ee5:	2b 45 10             	sub    0x10(%ebp),%eax
80101ee8:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ef2:	e9 95 00 00 00       	jmp    80101f8c <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ef7:	8b 45 10             	mov    0x10(%ebp),%eax
80101efa:	c1 e8 09             	shr    $0x9,%eax
80101efd:	83 ec 08             	sub    $0x8,%esp
80101f00:	50                   	push   %eax
80101f01:	ff 75 08             	pushl  0x8(%ebp)
80101f04:	e8 ac fc ff ff       	call   80101bb5 <bmap>
80101f09:	83 c4 10             	add    $0x10,%esp
80101f0c:	89 c2                	mov    %eax,%edx
80101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f11:	8b 00                	mov    (%eax),%eax
80101f13:	83 ec 08             	sub    $0x8,%esp
80101f16:	52                   	push   %edx
80101f17:	50                   	push   %eax
80101f18:	e8 97 e2 ff ff       	call   801001b4 <bread>
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f23:	8b 45 10             	mov    0x10(%ebp),%eax
80101f26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f2b:	ba 00 02 00 00       	mov    $0x200,%edx
80101f30:	89 d1                	mov    %edx,%ecx
80101f32:	29 c1                	sub    %eax,%ecx
80101f34:	8b 45 14             	mov    0x14(%ebp),%eax
80101f37:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f3a:	89 c2                	mov    %eax,%edx
80101f3c:	89 c8                	mov    %ecx,%eax
80101f3e:	39 d0                	cmp    %edx,%eax
80101f40:	76 02                	jbe    80101f44 <readi+0x108>
80101f42:	89 d0                	mov    %edx,%eax
80101f44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f47:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f4f:	8d 50 10             	lea    0x10(%eax),%edx
80101f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f55:	01 d0                	add    %edx,%eax
80101f57:	83 c0 08             	add    $0x8,%eax
80101f5a:	83 ec 04             	sub    $0x4,%esp
80101f5d:	ff 75 ec             	pushl  -0x14(%ebp)
80101f60:	50                   	push   %eax
80101f61:	ff 75 0c             	pushl  0xc(%ebp)
80101f64:	e8 86 37 00 00       	call   801056ef <memmove>
80101f69:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f6c:	83 ec 0c             	sub    $0xc,%esp
80101f6f:	ff 75 f0             	pushl  -0x10(%ebp)
80101f72:	e8 b4 e2 ff ff       	call   8010022b <brelse>
80101f77:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f7d:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f83:	01 45 10             	add    %eax,0x10(%ebp)
80101f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f89:	01 45 0c             	add    %eax,0xc(%ebp)
80101f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f8f:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f92:	0f 82 5f ff ff ff    	jb     80101ef7 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f98:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f9b:	c9                   	leave  
80101f9c:	c3                   	ret    

80101f9d <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f9d:	55                   	push   %ebp
80101f9e:	89 e5                	mov    %esp,%ebp
80101fa0:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101faa:	66 83 f8 03          	cmp    $0x3,%ax
80101fae:	75 5c                	jne    8010200c <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb7:	66 85 c0             	test   %ax,%ax
80101fba:	78 20                	js     80101fdc <writei+0x3f>
80101fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc3:	66 83 f8 09          	cmp    $0x9,%ax
80101fc7:	7f 13                	jg     80101fdc <writei+0x3f>
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd0:	98                   	cwtl   
80101fd1:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
80101fd8:	85 c0                	test   %eax,%eax
80101fda:	75 0a                	jne    80101fe6 <writei+0x49>
      return -1;
80101fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe1:	e9 47 01 00 00       	jmp    8010212d <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fed:	98                   	cwtl   
80101fee:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
80101ff5:	8b 55 14             	mov    0x14(%ebp),%edx
80101ff8:	83 ec 04             	sub    $0x4,%esp
80101ffb:	52                   	push   %edx
80101ffc:	ff 75 0c             	pushl  0xc(%ebp)
80101fff:	ff 75 08             	pushl  0x8(%ebp)
80102002:	ff d0                	call   *%eax
80102004:	83 c4 10             	add    $0x10,%esp
80102007:	e9 21 01 00 00       	jmp    8010212d <writei+0x190>
  }

  if(off > ip->size || off + n < off)
8010200c:	8b 45 08             	mov    0x8(%ebp),%eax
8010200f:	8b 40 18             	mov    0x18(%eax),%eax
80102012:	3b 45 10             	cmp    0x10(%ebp),%eax
80102015:	72 0d                	jb     80102024 <writei+0x87>
80102017:	8b 55 10             	mov    0x10(%ebp),%edx
8010201a:	8b 45 14             	mov    0x14(%ebp),%eax
8010201d:	01 d0                	add    %edx,%eax
8010201f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102022:	73 0a                	jae    8010202e <writei+0x91>
    return -1;
80102024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102029:	e9 ff 00 00 00       	jmp    8010212d <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
8010202e:	8b 55 10             	mov    0x10(%ebp),%edx
80102031:	8b 45 14             	mov    0x14(%ebp),%eax
80102034:	01 d0                	add    %edx,%eax
80102036:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010203b:	76 0a                	jbe    80102047 <writei+0xaa>
    return -1;
8010203d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102042:	e9 e6 00 00 00       	jmp    8010212d <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010204e:	e9 a3 00 00 00       	jmp    801020f6 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102053:	8b 45 10             	mov    0x10(%ebp),%eax
80102056:	c1 e8 09             	shr    $0x9,%eax
80102059:	83 ec 08             	sub    $0x8,%esp
8010205c:	50                   	push   %eax
8010205d:	ff 75 08             	pushl  0x8(%ebp)
80102060:	e8 50 fb ff ff       	call   80101bb5 <bmap>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	89 c2                	mov    %eax,%edx
8010206a:	8b 45 08             	mov    0x8(%ebp),%eax
8010206d:	8b 00                	mov    (%eax),%eax
8010206f:	83 ec 08             	sub    $0x8,%esp
80102072:	52                   	push   %edx
80102073:	50                   	push   %eax
80102074:	e8 3b e1 ff ff       	call   801001b4 <bread>
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010207f:	8b 45 10             	mov    0x10(%ebp),%eax
80102082:	25 ff 01 00 00       	and    $0x1ff,%eax
80102087:	ba 00 02 00 00       	mov    $0x200,%edx
8010208c:	89 d1                	mov    %edx,%ecx
8010208e:	29 c1                	sub    %eax,%ecx
80102090:	8b 45 14             	mov    0x14(%ebp),%eax
80102093:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102096:	89 c2                	mov    %eax,%edx
80102098:	89 c8                	mov    %ecx,%eax
8010209a:	39 d0                	cmp    %edx,%eax
8010209c:	76 02                	jbe    801020a0 <writei+0x103>
8010209e:	89 d0                	mov    %edx,%eax
801020a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020a3:	8b 45 10             	mov    0x10(%ebp),%eax
801020a6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ab:	8d 50 10             	lea    0x10(%eax),%edx
801020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020b1:	01 d0                	add    %edx,%eax
801020b3:	83 c0 08             	add    $0x8,%eax
801020b6:	83 ec 04             	sub    $0x4,%esp
801020b9:	ff 75 ec             	pushl  -0x14(%ebp)
801020bc:	ff 75 0c             	pushl  0xc(%ebp)
801020bf:	50                   	push   %eax
801020c0:	e8 2a 36 00 00       	call   801056ef <memmove>
801020c5:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	ff 75 f0             	pushl  -0x10(%ebp)
801020ce:	e8 d6 15 00 00       	call   801036a9 <log_write>
801020d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020d6:	83 ec 0c             	sub    $0xc,%esp
801020d9:	ff 75 f0             	pushl  -0x10(%ebp)
801020dc:	e8 4a e1 ff ff       	call   8010022b <brelse>
801020e1:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020e7:	01 45 f4             	add    %eax,-0xc(%ebp)
801020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ed:	01 45 10             	add    %eax,0x10(%ebp)
801020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020f3:	01 45 0c             	add    %eax,0xc(%ebp)
801020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020f9:	3b 45 14             	cmp    0x14(%ebp),%eax
801020fc:	0f 82 51 ff ff ff    	jb     80102053 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102102:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102106:	74 22                	je     8010212a <writei+0x18d>
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8b 40 18             	mov    0x18(%eax),%eax
8010210e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102111:	73 17                	jae    8010212a <writei+0x18d>
    ip->size = off;
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	8b 55 10             	mov    0x10(%ebp),%edx
80102119:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	ff 75 08             	pushl  0x8(%ebp)
80102122:	e8 e0 f5 ff ff       	call   80101707 <iupdate>
80102127:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010212a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010212d:	c9                   	leave  
8010212e:	c3                   	ret    

8010212f <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010212f:	55                   	push   %ebp
80102130:	89 e5                	mov    %esp,%ebp
80102132:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102135:	83 ec 04             	sub    $0x4,%esp
80102138:	6a 0e                	push   $0xe
8010213a:	ff 75 0c             	pushl  0xc(%ebp)
8010213d:	ff 75 08             	pushl  0x8(%ebp)
80102140:	e8 42 36 00 00       	call   80105787 <strncmp>
80102145:	83 c4 10             	add    $0x10,%esp
}
80102148:	c9                   	leave  
80102149:	c3                   	ret    

8010214a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010214a:	55                   	push   %ebp
8010214b:	89 e5                	mov    %esp,%ebp
8010214d:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102157:	66 83 f8 01          	cmp    $0x1,%ax
8010215b:	74 0d                	je     8010216a <dirlookup+0x20>
    panic("dirlookup not DIR");
8010215d:	83 ec 0c             	sub    $0xc,%esp
80102160:	68 31 8d 10 80       	push   $0x80108d31
80102165:	e8 f2 e3 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010216a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102171:	eb 7c                	jmp    801021ef <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102173:	6a 10                	push   $0x10
80102175:	ff 75 f4             	pushl  -0xc(%ebp)
80102178:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010217b:	50                   	push   %eax
8010217c:	ff 75 08             	pushl  0x8(%ebp)
8010217f:	e8 b8 fc ff ff       	call   80101e3c <readi>
80102184:	83 c4 10             	add    $0x10,%esp
80102187:	83 f8 10             	cmp    $0x10,%eax
8010218a:	74 0d                	je     80102199 <dirlookup+0x4f>
      panic("dirlink read");
8010218c:	83 ec 0c             	sub    $0xc,%esp
8010218f:	68 43 8d 10 80       	push   $0x80108d43
80102194:	e8 c3 e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
80102199:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010219d:	66 85 c0             	test   %ax,%ax
801021a0:	75 02                	jne    801021a4 <dirlookup+0x5a>
      continue;
801021a2:	eb 47                	jmp    801021eb <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
801021a4:	83 ec 08             	sub    $0x8,%esp
801021a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021aa:	83 c0 02             	add    $0x2,%eax
801021ad:	50                   	push   %eax
801021ae:	ff 75 0c             	pushl  0xc(%ebp)
801021b1:	e8 79 ff ff ff       	call   8010212f <namecmp>
801021b6:	83 c4 10             	add    $0x10,%esp
801021b9:	85 c0                	test   %eax,%eax
801021bb:	75 2e                	jne    801021eb <dirlookup+0xa1>
      // entry matches path element
      if(poff)
801021bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021c1:	74 08                	je     801021cb <dirlookup+0x81>
        *poff = off;
801021c3:	8b 45 10             	mov    0x10(%ebp),%eax
801021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c9:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021cb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021cf:	0f b7 c0             	movzwl %ax,%eax
801021d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021d5:	8b 45 08             	mov    0x8(%ebp),%eax
801021d8:	8b 00                	mov    (%eax),%eax
801021da:	83 ec 08             	sub    $0x8,%esp
801021dd:	ff 75 f0             	pushl  -0x10(%ebp)
801021e0:	50                   	push   %eax
801021e1:	e8 db f5 ff ff       	call   801017c1 <iget>
801021e6:	83 c4 10             	add    $0x10,%esp
801021e9:	eb 18                	jmp    80102203 <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021eb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021ef:	8b 45 08             	mov    0x8(%ebp),%eax
801021f2:	8b 40 18             	mov    0x18(%eax),%eax
801021f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021f8:	0f 87 75 ff ff ff    	ja     80102173 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    

80102205 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102205:	55                   	push   %ebp
80102206:	89 e5                	mov    %esp,%ebp
80102208:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010220b:	83 ec 04             	sub    $0x4,%esp
8010220e:	6a 00                	push   $0x0
80102210:	ff 75 0c             	pushl  0xc(%ebp)
80102213:	ff 75 08             	pushl  0x8(%ebp)
80102216:	e8 2f ff ff ff       	call   8010214a <dirlookup>
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102225:	74 18                	je     8010223f <dirlink+0x3a>
    iput(ip);
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	ff 75 f0             	pushl  -0x10(%ebp)
8010222d:	e8 70 f8 ff ff       	call   80101aa2 <iput>
80102232:	83 c4 10             	add    $0x10,%esp
    return -1;
80102235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010223a:	e9 9b 00 00 00       	jmp    801022da <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010223f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102246:	eb 3b                	jmp    80102283 <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010224b:	6a 10                	push   $0x10
8010224d:	50                   	push   %eax
8010224e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102251:	50                   	push   %eax
80102252:	ff 75 08             	pushl  0x8(%ebp)
80102255:	e8 e2 fb ff ff       	call   80101e3c <readi>
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	83 f8 10             	cmp    $0x10,%eax
80102260:	74 0d                	je     8010226f <dirlink+0x6a>
      panic("dirlink read");
80102262:	83 ec 0c             	sub    $0xc,%esp
80102265:	68 43 8d 10 80       	push   $0x80108d43
8010226a:	e8 ed e2 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
8010226f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102273:	66 85 c0             	test   %ax,%ax
80102276:	75 02                	jne    8010227a <dirlink+0x75>
      break;
80102278:	eb 16                	jmp    80102290 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010227d:	83 c0 10             	add    $0x10,%eax
80102280:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102283:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102286:	8b 45 08             	mov    0x8(%ebp),%eax
80102289:	8b 40 18             	mov    0x18(%eax),%eax
8010228c:	39 c2                	cmp    %eax,%edx
8010228e:	72 b8                	jb     80102248 <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102290:	83 ec 04             	sub    $0x4,%esp
80102293:	6a 0e                	push   $0xe
80102295:	ff 75 0c             	pushl  0xc(%ebp)
80102298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010229b:	83 c0 02             	add    $0x2,%eax
8010229e:	50                   	push   %eax
8010229f:	e8 39 35 00 00       	call   801057dd <strncpy>
801022a4:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022a7:	8b 45 10             	mov    0x10(%ebp),%eax
801022aa:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b1:	6a 10                	push   $0x10
801022b3:	50                   	push   %eax
801022b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b7:	50                   	push   %eax
801022b8:	ff 75 08             	pushl  0x8(%ebp)
801022bb:	e8 dd fc ff ff       	call   80101f9d <writei>
801022c0:	83 c4 10             	add    $0x10,%esp
801022c3:	83 f8 10             	cmp    $0x10,%eax
801022c6:	74 0d                	je     801022d5 <dirlink+0xd0>
    panic("dirlink");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 50 8d 10 80       	push   $0x80108d50
801022d0:	e8 87 e2 ff ff       	call   8010055c <panic>
  
  return 0;
801022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022da:	c9                   	leave  
801022db:	c3                   	ret    

801022dc <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022dc:	55                   	push   %ebp
801022dd:	89 e5                	mov    %esp,%ebp
801022df:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801022e2:	eb 04                	jmp    801022e8 <skipelem+0xc>
    path++;
801022e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022e8:	8b 45 08             	mov    0x8(%ebp),%eax
801022eb:	0f b6 00             	movzbl (%eax),%eax
801022ee:	3c 2f                	cmp    $0x2f,%al
801022f0:	74 f2                	je     801022e4 <skipelem+0x8>
    path++;
  if(*path == 0)
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	0f b6 00             	movzbl (%eax),%eax
801022f8:	84 c0                	test   %al,%al
801022fa:	75 07                	jne    80102303 <skipelem+0x27>
    return 0;
801022fc:	b8 00 00 00 00       	mov    $0x0,%eax
80102301:	eb 7b                	jmp    8010237e <skipelem+0xa2>
  s = path;
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
80102306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102309:	eb 04                	jmp    8010230f <skipelem+0x33>
    path++;
8010230b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010230f:	8b 45 08             	mov    0x8(%ebp),%eax
80102312:	0f b6 00             	movzbl (%eax),%eax
80102315:	3c 2f                	cmp    $0x2f,%al
80102317:	74 0a                	je     80102323 <skipelem+0x47>
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
8010231c:	0f b6 00             	movzbl (%eax),%eax
8010231f:	84 c0                	test   %al,%al
80102321:	75 e8                	jne    8010230b <skipelem+0x2f>
    path++;
  len = path - s;
80102323:	8b 55 08             	mov    0x8(%ebp),%edx
80102326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102329:	29 c2                	sub    %eax,%edx
8010232b:	89 d0                	mov    %edx,%eax
8010232d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102330:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102334:	7e 15                	jle    8010234b <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102336:	83 ec 04             	sub    $0x4,%esp
80102339:	6a 0e                	push   $0xe
8010233b:	ff 75 f4             	pushl  -0xc(%ebp)
8010233e:	ff 75 0c             	pushl  0xc(%ebp)
80102341:	e8 a9 33 00 00       	call   801056ef <memmove>
80102346:	83 c4 10             	add    $0x10,%esp
80102349:	eb 20                	jmp    8010236b <skipelem+0x8f>
  else {
    memmove(name, s, len);
8010234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010234e:	83 ec 04             	sub    $0x4,%esp
80102351:	50                   	push   %eax
80102352:	ff 75 f4             	pushl  -0xc(%ebp)
80102355:	ff 75 0c             	pushl  0xc(%ebp)
80102358:	e8 92 33 00 00       	call   801056ef <memmove>
8010235d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102360:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102363:	8b 45 0c             	mov    0xc(%ebp),%eax
80102366:	01 d0                	add    %edx,%eax
80102368:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010236b:	eb 04                	jmp    80102371 <skipelem+0x95>
    path++;
8010236d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102371:	8b 45 08             	mov    0x8(%ebp),%eax
80102374:	0f b6 00             	movzbl (%eax),%eax
80102377:	3c 2f                	cmp    $0x2f,%al
80102379:	74 f2                	je     8010236d <skipelem+0x91>
    path++;
  return path;
8010237b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010237e:	c9                   	leave  
8010237f:	c3                   	ret    

80102380 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102386:	8b 45 08             	mov    0x8(%ebp),%eax
80102389:	0f b6 00             	movzbl (%eax),%eax
8010238c:	3c 2f                	cmp    $0x2f,%al
8010238e:	75 14                	jne    801023a4 <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
80102390:	83 ec 08             	sub    $0x8,%esp
80102393:	6a 01                	push   $0x1
80102395:	6a 01                	push   $0x1
80102397:	e8 25 f4 ff ff       	call   801017c1 <iget>
8010239c:	83 c4 10             	add    $0x10,%esp
8010239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023a2:	eb 18                	jmp    801023bc <namex+0x3c>
  else
    ip = idup(proc->cwd);
801023a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023aa:	8b 40 68             	mov    0x68(%eax),%eax
801023ad:	83 ec 0c             	sub    $0xc,%esp
801023b0:	50                   	push   %eax
801023b1:	e8 ea f4 ff ff       	call   801018a0 <idup>
801023b6:	83 c4 10             	add    $0x10,%esp
801023b9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023bc:	e9 9e 00 00 00       	jmp    8010245f <namex+0xdf>
    ilock(ip);
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	ff 75 f4             	pushl  -0xc(%ebp)
801023c7:	e8 0e f5 ff ff       	call   801018da <ilock>
801023cc:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023d6:	66 83 f8 01          	cmp    $0x1,%ax
801023da:	74 18                	je     801023f4 <namex+0x74>
      iunlockput(ip);
801023dc:	83 ec 0c             	sub    $0xc,%esp
801023df:	ff 75 f4             	pushl  -0xc(%ebp)
801023e2:	e8 aa f7 ff ff       	call   80101b91 <iunlockput>
801023e7:	83 c4 10             	add    $0x10,%esp
      return 0;
801023ea:	b8 00 00 00 00       	mov    $0x0,%eax
801023ef:	e9 a7 00 00 00       	jmp    8010249b <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
801023f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f8:	74 20                	je     8010241a <namex+0x9a>
801023fa:	8b 45 08             	mov    0x8(%ebp),%eax
801023fd:	0f b6 00             	movzbl (%eax),%eax
80102400:	84 c0                	test   %al,%al
80102402:	75 16                	jne    8010241a <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	ff 75 f4             	pushl  -0xc(%ebp)
8010240a:	e8 22 f6 ff ff       	call   80101a31 <iunlock>
8010240f:	83 c4 10             	add    $0x10,%esp
      return ip;
80102412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102415:	e9 81 00 00 00       	jmp    8010249b <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010241a:	83 ec 04             	sub    $0x4,%esp
8010241d:	6a 00                	push   $0x0
8010241f:	ff 75 10             	pushl  0x10(%ebp)
80102422:	ff 75 f4             	pushl  -0xc(%ebp)
80102425:	e8 20 fd ff ff       	call   8010214a <dirlookup>
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102434:	75 15                	jne    8010244b <namex+0xcb>
      iunlockput(ip);
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	ff 75 f4             	pushl  -0xc(%ebp)
8010243c:	e8 50 f7 ff ff       	call   80101b91 <iunlockput>
80102441:	83 c4 10             	add    $0x10,%esp
      return 0;
80102444:	b8 00 00 00 00       	mov    $0x0,%eax
80102449:	eb 50                	jmp    8010249b <namex+0x11b>
    }
    iunlockput(ip);
8010244b:	83 ec 0c             	sub    $0xc,%esp
8010244e:	ff 75 f4             	pushl  -0xc(%ebp)
80102451:	e8 3b f7 ff ff       	call   80101b91 <iunlockput>
80102456:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010245c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010245f:	83 ec 08             	sub    $0x8,%esp
80102462:	ff 75 10             	pushl  0x10(%ebp)
80102465:	ff 75 08             	pushl  0x8(%ebp)
80102468:	e8 6f fe ff ff       	call   801022dc <skipelem>
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	89 45 08             	mov    %eax,0x8(%ebp)
80102473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102477:	0f 85 44 ff ff ff    	jne    801023c1 <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010247d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102481:	74 15                	je     80102498 <namex+0x118>
    iput(ip);
80102483:	83 ec 0c             	sub    $0xc,%esp
80102486:	ff 75 f4             	pushl  -0xc(%ebp)
80102489:	e8 14 f6 ff ff       	call   80101aa2 <iput>
8010248e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102491:	b8 00 00 00 00       	mov    $0x0,%eax
80102496:	eb 03                	jmp    8010249b <namex+0x11b>
  }
  return ip;
80102498:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010249b:	c9                   	leave  
8010249c:	c3                   	ret    

8010249d <namei>:

struct inode*
namei(char *path)
{
8010249d:	55                   	push   %ebp
8010249e:	89 e5                	mov    %esp,%ebp
801024a0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024a3:	83 ec 04             	sub    $0x4,%esp
801024a6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024a9:	50                   	push   %eax
801024aa:	6a 00                	push   $0x0
801024ac:	ff 75 08             	pushl  0x8(%ebp)
801024af:	e8 cc fe ff ff       	call   80102380 <namex>
801024b4:	83 c4 10             	add    $0x10,%esp
}
801024b7:	c9                   	leave  
801024b8:	c3                   	ret    

801024b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024b9:	55                   	push   %ebp
801024ba:	89 e5                	mov    %esp,%ebp
801024bc:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024bf:	83 ec 04             	sub    $0x4,%esp
801024c2:	ff 75 0c             	pushl  0xc(%ebp)
801024c5:	6a 01                	push   $0x1
801024c7:	ff 75 08             	pushl  0x8(%ebp)
801024ca:	e8 b1 fe ff ff       	call   80102380 <namex>
801024cf:	83 c4 10             	add    $0x10,%esp
}
801024d2:	c9                   	leave  
801024d3:	c3                   	ret    

801024d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	83 ec 14             	sub    $0x14,%esp
801024da:	8b 45 08             	mov    0x8(%ebp),%eax
801024dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024e5:	89 c2                	mov    %eax,%edx
801024e7:	ec                   	in     (%dx),%al
801024e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024ef:	c9                   	leave  
801024f0:	c3                   	ret    

801024f1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024f1:	55                   	push   %ebp
801024f2:	89 e5                	mov    %esp,%ebp
801024f4:	57                   	push   %edi
801024f5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024f6:	8b 55 08             	mov    0x8(%ebp),%edx
801024f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024fc:	8b 45 10             	mov    0x10(%ebp),%eax
801024ff:	89 cb                	mov    %ecx,%ebx
80102501:	89 df                	mov    %ebx,%edi
80102503:	89 c1                	mov    %eax,%ecx
80102505:	fc                   	cld    
80102506:	f3 6d                	rep insl (%dx),%es:(%edi)
80102508:	89 c8                	mov    %ecx,%eax
8010250a:	89 fb                	mov    %edi,%ebx
8010250c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010250f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102512:	5b                   	pop    %ebx
80102513:	5f                   	pop    %edi
80102514:	5d                   	pop    %ebp
80102515:	c3                   	ret    

80102516 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102516:	55                   	push   %ebp
80102517:	89 e5                	mov    %esp,%ebp
80102519:	83 ec 08             	sub    $0x8,%esp
8010251c:	8b 55 08             	mov    0x8(%ebp),%edx
8010251f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102522:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102526:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102529:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010252d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102531:	ee                   	out    %al,(%dx)
}
80102532:	c9                   	leave  
80102533:	c3                   	ret    

80102534 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	56                   	push   %esi
80102538:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102539:	8b 55 08             	mov    0x8(%ebp),%edx
8010253c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253f:	8b 45 10             	mov    0x10(%ebp),%eax
80102542:	89 cb                	mov    %ecx,%ebx
80102544:	89 de                	mov    %ebx,%esi
80102546:	89 c1                	mov    %eax,%ecx
80102548:	fc                   	cld    
80102549:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010254b:	89 c8                	mov    %ecx,%eax
8010254d:	89 f3                	mov    %esi,%ebx
8010254f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102552:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102555:	5b                   	pop    %ebx
80102556:	5e                   	pop    %esi
80102557:	5d                   	pop    %ebp
80102558:	c3                   	ret    

80102559 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010255f:	90                   	nop
80102560:	68 f7 01 00 00       	push   $0x1f7
80102565:	e8 6a ff ff ff       	call   801024d4 <inb>
8010256a:	83 c4 04             	add    $0x4,%esp
8010256d:	0f b6 c0             	movzbl %al,%eax
80102570:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102573:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102576:	25 c0 00 00 00       	and    $0xc0,%eax
8010257b:	83 f8 40             	cmp    $0x40,%eax
8010257e:	75 e0                	jne    80102560 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102584:	74 11                	je     80102597 <idewait+0x3e>
80102586:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102589:	83 e0 21             	and    $0x21,%eax
8010258c:	85 c0                	test   %eax,%eax
8010258e:	74 07                	je     80102597 <idewait+0x3e>
    return -1;
80102590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102595:	eb 05                	jmp    8010259c <idewait+0x43>
  return 0;
80102597:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010259c:	c9                   	leave  
8010259d:	c3                   	ret    

8010259e <ideinit>:

void
ideinit(void)
{
8010259e:	55                   	push   %ebp
8010259f:	89 e5                	mov    %esp,%ebp
801025a1:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025a4:	83 ec 08             	sub    $0x8,%esp
801025a7:	68 58 8d 10 80       	push   $0x80108d58
801025ac:	68 20 c6 10 80       	push   $0x8010c620
801025b1:	e8 fd 2d 00 00       	call   801053b3 <initlock>
801025b6:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025b9:	83 ec 0c             	sub    $0xc,%esp
801025bc:	6a 0e                	push   $0xe
801025be:	e8 88 18 00 00       	call   80103e4b <picenable>
801025c3:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025c6:	a1 20 3a 11 80       	mov    0x80113a20,%eax
801025cb:	83 e8 01             	sub    $0x1,%eax
801025ce:	83 ec 08             	sub    $0x8,%esp
801025d1:	50                   	push   %eax
801025d2:	6a 0e                	push   $0xe
801025d4:	e8 31 04 00 00       	call   80102a0a <ioapicenable>
801025d9:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801025dc:	83 ec 0c             	sub    $0xc,%esp
801025df:	6a 00                	push   $0x0
801025e1:	e8 73 ff ff ff       	call   80102559 <idewait>
801025e6:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025e9:	83 ec 08             	sub    $0x8,%esp
801025ec:	68 f0 00 00 00       	push   $0xf0
801025f1:	68 f6 01 00 00       	push   $0x1f6
801025f6:	e8 1b ff ff ff       	call   80102516 <outb>
801025fb:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801025fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102605:	eb 24                	jmp    8010262b <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102607:	83 ec 0c             	sub    $0xc,%esp
8010260a:	68 f7 01 00 00       	push   $0x1f7
8010260f:	e8 c0 fe ff ff       	call   801024d4 <inb>
80102614:	83 c4 10             	add    $0x10,%esp
80102617:	84 c0                	test   %al,%al
80102619:	74 0c                	je     80102627 <ideinit+0x89>
      havedisk1 = 1;
8010261b:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102622:	00 00 00 
      break;
80102625:	eb 0d                	jmp    80102634 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010262b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102632:	7e d3                	jle    80102607 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102634:	83 ec 08             	sub    $0x8,%esp
80102637:	68 e0 00 00 00       	push   $0xe0
8010263c:	68 f6 01 00 00       	push   $0x1f6
80102641:	e8 d0 fe ff ff       	call   80102516 <outb>
80102646:	83 c4 10             	add    $0x10,%esp
}
80102649:	c9                   	leave  
8010264a:	c3                   	ret    

8010264b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010264b:	55                   	push   %ebp
8010264c:	89 e5                	mov    %esp,%ebp
8010264e:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102655:	75 0d                	jne    80102664 <idestart+0x19>
    panic("idestart");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 5c 8d 10 80       	push   $0x80108d5c
8010265f:	e8 f8 de ff ff       	call   8010055c <panic>

  idewait(0);
80102664:	83 ec 0c             	sub    $0xc,%esp
80102667:	6a 00                	push   $0x0
80102669:	e8 eb fe ff ff       	call   80102559 <idewait>
8010266e:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102671:	83 ec 08             	sub    $0x8,%esp
80102674:	6a 00                	push   $0x0
80102676:	68 f6 03 00 00       	push   $0x3f6
8010267b:	e8 96 fe ff ff       	call   80102516 <outb>
80102680:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
80102683:	83 ec 08             	sub    $0x8,%esp
80102686:	6a 01                	push   $0x1
80102688:	68 f2 01 00 00       	push   $0x1f2
8010268d:	e8 84 fe ff ff       	call   80102516 <outb>
80102692:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
80102695:	8b 45 08             	mov    0x8(%ebp),%eax
80102698:	8b 40 08             	mov    0x8(%eax),%eax
8010269b:	0f b6 c0             	movzbl %al,%eax
8010269e:	83 ec 08             	sub    $0x8,%esp
801026a1:	50                   	push   %eax
801026a2:	68 f3 01 00 00       	push   $0x1f3
801026a7:	e8 6a fe ff ff       	call   80102516 <outb>
801026ac:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026af:	8b 45 08             	mov    0x8(%ebp),%eax
801026b2:	8b 40 08             	mov    0x8(%eax),%eax
801026b5:	c1 e8 08             	shr    $0x8,%eax
801026b8:	0f b6 c0             	movzbl %al,%eax
801026bb:	83 ec 08             	sub    $0x8,%esp
801026be:	50                   	push   %eax
801026bf:	68 f4 01 00 00       	push   $0x1f4
801026c4:	e8 4d fe ff ff       	call   80102516 <outb>
801026c9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026cc:	8b 45 08             	mov    0x8(%ebp),%eax
801026cf:	8b 40 08             	mov    0x8(%eax),%eax
801026d2:	c1 e8 10             	shr    $0x10,%eax
801026d5:	0f b6 c0             	movzbl %al,%eax
801026d8:	83 ec 08             	sub    $0x8,%esp
801026db:	50                   	push   %eax
801026dc:	68 f5 01 00 00       	push   $0x1f5
801026e1:	e8 30 fe ff ff       	call   80102516 <outb>
801026e6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026e9:	8b 45 08             	mov    0x8(%ebp),%eax
801026ec:	8b 40 04             	mov    0x4(%eax),%eax
801026ef:	83 e0 01             	and    $0x1,%eax
801026f2:	c1 e0 04             	shl    $0x4,%eax
801026f5:	89 c2                	mov    %eax,%edx
801026f7:	8b 45 08             	mov    0x8(%ebp),%eax
801026fa:	8b 40 08             	mov    0x8(%eax),%eax
801026fd:	c1 e8 18             	shr    $0x18,%eax
80102700:	83 e0 0f             	and    $0xf,%eax
80102703:	09 d0                	or     %edx,%eax
80102705:	83 c8 e0             	or     $0xffffffe0,%eax
80102708:	0f b6 c0             	movzbl %al,%eax
8010270b:	83 ec 08             	sub    $0x8,%esp
8010270e:	50                   	push   %eax
8010270f:	68 f6 01 00 00       	push   $0x1f6
80102714:	e8 fd fd ff ff       	call   80102516 <outb>
80102719:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010271c:	8b 45 08             	mov    0x8(%ebp),%eax
8010271f:	8b 00                	mov    (%eax),%eax
80102721:	83 e0 04             	and    $0x4,%eax
80102724:	85 c0                	test   %eax,%eax
80102726:	74 30                	je     80102758 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	6a 30                	push   $0x30
8010272d:	68 f7 01 00 00       	push   $0x1f7
80102732:	e8 df fd ff ff       	call   80102516 <outb>
80102737:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
8010273d:	83 c0 18             	add    $0x18,%eax
80102740:	83 ec 04             	sub    $0x4,%esp
80102743:	68 80 00 00 00       	push   $0x80
80102748:	50                   	push   %eax
80102749:	68 f0 01 00 00       	push   $0x1f0
8010274e:	e8 e1 fd ff ff       	call   80102534 <outsl>
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	eb 12                	jmp    8010276a <idestart+0x11f>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102758:	83 ec 08             	sub    $0x8,%esp
8010275b:	6a 20                	push   $0x20
8010275d:	68 f7 01 00 00       	push   $0x1f7
80102762:	e8 af fd ff ff       	call   80102516 <outb>
80102767:	83 c4 10             	add    $0x10,%esp
  }
}
8010276a:	c9                   	leave  
8010276b:	c3                   	ret    

8010276c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010276c:	55                   	push   %ebp
8010276d:	89 e5                	mov    %esp,%ebp
8010276f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102772:	83 ec 0c             	sub    $0xc,%esp
80102775:	68 20 c6 10 80       	push   $0x8010c620
8010277a:	e8 55 2c 00 00       	call   801053d4 <acquire>
8010277f:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102782:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102787:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010278a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010278e:	75 15                	jne    801027a5 <ideintr+0x39>
    release(&idelock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 20 c6 10 80       	push   $0x8010c620
80102798:	e8 9d 2c 00 00       	call   8010543a <release>
8010279d:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027a0:	e9 9a 00 00 00       	jmp    8010283f <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a8:	8b 40 14             	mov    0x14(%eax),%eax
801027ab:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b3:	8b 00                	mov    (%eax),%eax
801027b5:	83 e0 04             	and    $0x4,%eax
801027b8:	85 c0                	test   %eax,%eax
801027ba:	75 2d                	jne    801027e9 <ideintr+0x7d>
801027bc:	83 ec 0c             	sub    $0xc,%esp
801027bf:	6a 01                	push   $0x1
801027c1:	e8 93 fd ff ff       	call   80102559 <idewait>
801027c6:	83 c4 10             	add    $0x10,%esp
801027c9:	85 c0                	test   %eax,%eax
801027cb:	78 1c                	js     801027e9 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d0:	83 c0 18             	add    $0x18,%eax
801027d3:	83 ec 04             	sub    $0x4,%esp
801027d6:	68 80 00 00 00       	push   $0x80
801027db:	50                   	push   %eax
801027dc:	68 f0 01 00 00       	push   $0x1f0
801027e1:	e8 0b fd ff ff       	call   801024f1 <insl>
801027e6:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ec:	8b 00                	mov    (%eax),%eax
801027ee:	83 c8 02             	or     $0x2,%eax
801027f1:	89 c2                	mov    %eax,%edx
801027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f6:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fb:	8b 00                	mov    (%eax),%eax
801027fd:	83 e0 fb             	and    $0xfffffffb,%eax
80102800:	89 c2                	mov    %eax,%edx
80102802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102805:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102807:	83 ec 0c             	sub    $0xc,%esp
8010280a:	ff 75 f4             	pushl  -0xc(%ebp)
8010280d:	e8 f1 27 00 00       	call   80105003 <wakeup>
80102812:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102815:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010281a:	85 c0                	test   %eax,%eax
8010281c:	74 11                	je     8010282f <ideintr+0xc3>
    idestart(idequeue);
8010281e:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102823:	83 ec 0c             	sub    $0xc,%esp
80102826:	50                   	push   %eax
80102827:	e8 1f fe ff ff       	call   8010264b <idestart>
8010282c:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010282f:	83 ec 0c             	sub    $0xc,%esp
80102832:	68 20 c6 10 80       	push   $0x8010c620
80102837:	e8 fe 2b 00 00       	call   8010543a <release>
8010283c:	83 c4 10             	add    $0x10,%esp
}
8010283f:	c9                   	leave  
80102840:	c3                   	ret    

80102841 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102841:	55                   	push   %ebp
80102842:	89 e5                	mov    %esp,%ebp
80102844:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102847:	8b 45 08             	mov    0x8(%ebp),%eax
8010284a:	8b 00                	mov    (%eax),%eax
8010284c:	83 e0 01             	and    $0x1,%eax
8010284f:	85 c0                	test   %eax,%eax
80102851:	75 0d                	jne    80102860 <iderw+0x1f>
    panic("iderw: buf not busy");
80102853:	83 ec 0c             	sub    $0xc,%esp
80102856:	68 65 8d 10 80       	push   $0x80108d65
8010285b:	e8 fc dc ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102860:	8b 45 08             	mov    0x8(%ebp),%eax
80102863:	8b 00                	mov    (%eax),%eax
80102865:	83 e0 06             	and    $0x6,%eax
80102868:	83 f8 02             	cmp    $0x2,%eax
8010286b:	75 0d                	jne    8010287a <iderw+0x39>
    panic("iderw: nothing to do");
8010286d:	83 ec 0c             	sub    $0xc,%esp
80102870:	68 79 8d 10 80       	push   $0x80108d79
80102875:	e8 e2 dc ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
8010287a:	8b 45 08             	mov    0x8(%ebp),%eax
8010287d:	8b 40 04             	mov    0x4(%eax),%eax
80102880:	85 c0                	test   %eax,%eax
80102882:	74 16                	je     8010289a <iderw+0x59>
80102884:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102889:	85 c0                	test   %eax,%eax
8010288b:	75 0d                	jne    8010289a <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010288d:	83 ec 0c             	sub    $0xc,%esp
80102890:	68 8e 8d 10 80       	push   $0x80108d8e
80102895:	e8 c2 dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010289a:	83 ec 0c             	sub    $0xc,%esp
8010289d:	68 20 c6 10 80       	push   $0x8010c620
801028a2:	e8 2d 2b 00 00       	call   801053d4 <acquire>
801028a7:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028aa:	8b 45 08             	mov    0x8(%ebp),%eax
801028ad:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028b4:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801028bb:	eb 0b                	jmp    801028c8 <iderw+0x87>
801028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c0:	8b 00                	mov    (%eax),%eax
801028c2:	83 c0 14             	add    $0x14,%eax
801028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cb:	8b 00                	mov    (%eax),%eax
801028cd:	85 c0                	test   %eax,%eax
801028cf:	75 ec                	jne    801028bd <iderw+0x7c>
    ;
  *pp = b;
801028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d4:	8b 55 08             	mov    0x8(%ebp),%edx
801028d7:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028d9:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028de:	3b 45 08             	cmp    0x8(%ebp),%eax
801028e1:	75 0e                	jne    801028f1 <iderw+0xb0>
    idestart(b);
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	ff 75 08             	pushl  0x8(%ebp)
801028e9:	e8 5d fd ff ff       	call   8010264b <idestart>
801028ee:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028f1:	eb 13                	jmp    80102906 <iderw+0xc5>
    sleep(b, &idelock);
801028f3:	83 ec 08             	sub    $0x8,%esp
801028f6:	68 20 c6 10 80       	push   $0x8010c620
801028fb:	ff 75 08             	pushl  0x8(%ebp)
801028fe:	e8 dd 25 00 00       	call   80104ee0 <sleep>
80102903:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102906:	8b 45 08             	mov    0x8(%ebp),%eax
80102909:	8b 00                	mov    (%eax),%eax
8010290b:	83 e0 06             	and    $0x6,%eax
8010290e:	83 f8 02             	cmp    $0x2,%eax
80102911:	75 e0                	jne    801028f3 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102913:	83 ec 0c             	sub    $0xc,%esp
80102916:	68 20 c6 10 80       	push   $0x8010c620
8010291b:	e8 1a 2b 00 00       	call   8010543a <release>
80102920:	83 c4 10             	add    $0x10,%esp
}
80102923:	c9                   	leave  
80102924:	c3                   	ret    

80102925 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102925:	55                   	push   %ebp
80102926:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102928:	a1 94 32 11 80       	mov    0x80113294,%eax
8010292d:	8b 55 08             	mov    0x8(%ebp),%edx
80102930:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102932:	a1 94 32 11 80       	mov    0x80113294,%eax
80102937:	8b 40 10             	mov    0x10(%eax),%eax
}
8010293a:	5d                   	pop    %ebp
8010293b:	c3                   	ret    

8010293c <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010293c:	55                   	push   %ebp
8010293d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010293f:	a1 94 32 11 80       	mov    0x80113294,%eax
80102944:	8b 55 08             	mov    0x8(%ebp),%edx
80102947:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102949:	a1 94 32 11 80       	mov    0x80113294,%eax
8010294e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102951:	89 50 10             	mov    %edx,0x10(%eax)
}
80102954:	5d                   	pop    %ebp
80102955:	c3                   	ret    

80102956 <ioapicinit>:

void
ioapicinit(void)
{
80102956:	55                   	push   %ebp
80102957:	89 e5                	mov    %esp,%ebp
80102959:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
8010295c:	a1 04 34 11 80       	mov    0x80113404,%eax
80102961:	85 c0                	test   %eax,%eax
80102963:	75 05                	jne    8010296a <ioapicinit+0x14>
    return;
80102965:	e9 9e 00 00 00       	jmp    80102a08 <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
8010296a:	c7 05 94 32 11 80 00 	movl   $0xfec00000,0x80113294
80102971:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102974:	6a 01                	push   $0x1
80102976:	e8 aa ff ff ff       	call   80102925 <ioapicread>
8010297b:	83 c4 04             	add    $0x4,%esp
8010297e:	c1 e8 10             	shr    $0x10,%eax
80102981:	25 ff 00 00 00       	and    $0xff,%eax
80102986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102989:	6a 00                	push   $0x0
8010298b:	e8 95 ff ff ff       	call   80102925 <ioapicread>
80102990:	83 c4 04             	add    $0x4,%esp
80102993:	c1 e8 18             	shr    $0x18,%eax
80102996:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102999:	0f b6 05 00 34 11 80 	movzbl 0x80113400,%eax
801029a0:	0f b6 c0             	movzbl %al,%eax
801029a3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029a6:	74 10                	je     801029b8 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029a8:	83 ec 0c             	sub    $0xc,%esp
801029ab:	68 ac 8d 10 80       	push   $0x80108dac
801029b0:	e8 0a da ff ff       	call   801003bf <cprintf>
801029b5:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029bf:	eb 3f                	jmp    80102a00 <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c4:	83 c0 20             	add    $0x20,%eax
801029c7:	0d 00 00 01 00       	or     $0x10000,%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d1:	83 c0 08             	add    $0x8,%eax
801029d4:	01 c0                	add    %eax,%eax
801029d6:	83 ec 08             	sub    $0x8,%esp
801029d9:	52                   	push   %edx
801029da:	50                   	push   %eax
801029db:	e8 5c ff ff ff       	call   8010293c <ioapicwrite>
801029e0:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e6:	83 c0 08             	add    $0x8,%eax
801029e9:	01 c0                	add    %eax,%eax
801029eb:	83 c0 01             	add    $0x1,%eax
801029ee:	83 ec 08             	sub    $0x8,%esp
801029f1:	6a 00                	push   $0x0
801029f3:	50                   	push   %eax
801029f4:	e8 43 ff ff ff       	call   8010293c <ioapicwrite>
801029f9:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a06:	7e b9                	jle    801029c1 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a08:	c9                   	leave  
80102a09:	c3                   	ret    

80102a0a <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a0a:	55                   	push   %ebp
80102a0b:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a0d:	a1 04 34 11 80       	mov    0x80113404,%eax
80102a12:	85 c0                	test   %eax,%eax
80102a14:	75 02                	jne    80102a18 <ioapicenable+0xe>
    return;
80102a16:	eb 37                	jmp    80102a4f <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a18:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1b:	83 c0 20             	add    $0x20,%eax
80102a1e:	89 c2                	mov    %eax,%edx
80102a20:	8b 45 08             	mov    0x8(%ebp),%eax
80102a23:	83 c0 08             	add    $0x8,%eax
80102a26:	01 c0                	add    %eax,%eax
80102a28:	52                   	push   %edx
80102a29:	50                   	push   %eax
80102a2a:	e8 0d ff ff ff       	call   8010293c <ioapicwrite>
80102a2f:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a32:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a35:	c1 e0 18             	shl    $0x18,%eax
80102a38:	89 c2                	mov    %eax,%edx
80102a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3d:	83 c0 08             	add    $0x8,%eax
80102a40:	01 c0                	add    %eax,%eax
80102a42:	83 c0 01             	add    $0x1,%eax
80102a45:	52                   	push   %edx
80102a46:	50                   	push   %eax
80102a47:	e8 f0 fe ff ff       	call   8010293c <ioapicwrite>
80102a4c:	83 c4 08             	add    $0x8,%esp
}
80102a4f:	c9                   	leave  
80102a50:	c3                   	ret    

80102a51 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a51:	55                   	push   %ebp
80102a52:	89 e5                	mov    %esp,%ebp
80102a54:	8b 45 08             	mov    0x8(%ebp),%eax
80102a57:	05 00 00 00 80       	add    $0x80000000,%eax
80102a5c:	5d                   	pop    %ebp
80102a5d:	c3                   	ret    

80102a5e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a5e:	55                   	push   %ebp
80102a5f:	89 e5                	mov    %esp,%ebp
80102a61:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a64:	83 ec 08             	sub    $0x8,%esp
80102a67:	68 de 8d 10 80       	push   $0x80108dde
80102a6c:	68 a0 32 11 80       	push   $0x801132a0
80102a71:	e8 3d 29 00 00       	call   801053b3 <initlock>
80102a76:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a79:	c7 05 d4 32 11 80 00 	movl   $0x0,0x801132d4
80102a80:	00 00 00 
  freerange(vstart, vend);
80102a83:	83 ec 08             	sub    $0x8,%esp
80102a86:	ff 75 0c             	pushl  0xc(%ebp)
80102a89:	ff 75 08             	pushl  0x8(%ebp)
80102a8c:	e8 28 00 00 00       	call   80102ab9 <freerange>
80102a91:	83 c4 10             	add    $0x10,%esp
}
80102a94:	c9                   	leave  
80102a95:	c3                   	ret    

80102a96 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a96:	55                   	push   %ebp
80102a97:	89 e5                	mov    %esp,%ebp
80102a99:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102a9c:	83 ec 08             	sub    $0x8,%esp
80102a9f:	ff 75 0c             	pushl  0xc(%ebp)
80102aa2:	ff 75 08             	pushl  0x8(%ebp)
80102aa5:	e8 0f 00 00 00       	call   80102ab9 <freerange>
80102aaa:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102aad:	c7 05 d4 32 11 80 01 	movl   $0x1,0x801132d4
80102ab4:	00 00 00 
}
80102ab7:	c9                   	leave  
80102ab8:	c3                   	ret    

80102ab9 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ab9:	55                   	push   %ebp
80102aba:	89 e5                	mov    %esp,%ebp
80102abc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102abf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac2:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ac7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acf:	eb 15                	jmp    80102ae6 <freerange+0x2d>
    kfree(p);
80102ad1:	83 ec 0c             	sub    $0xc,%esp
80102ad4:	ff 75 f4             	pushl  -0xc(%ebp)
80102ad7:	e8 19 00 00 00       	call   80102af5 <kfree>
80102adc:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102adf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae9:	05 00 10 00 00       	add    $0x1000,%eax
80102aee:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102af1:	76 de                	jbe    80102ad1 <freerange+0x18>
    kfree(p);
}
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    

80102af5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102afb:	8b 45 08             	mov    0x8(%ebp),%eax
80102afe:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b03:	85 c0                	test   %eax,%eax
80102b05:	75 1b                	jne    80102b22 <kfree+0x2d>
80102b07:	81 7d 08 5c 6c 11 80 	cmpl   $0x80116c5c,0x8(%ebp)
80102b0e:	72 12                	jb     80102b22 <kfree+0x2d>
80102b10:	ff 75 08             	pushl  0x8(%ebp)
80102b13:	e8 39 ff ff ff       	call   80102a51 <v2p>
80102b18:	83 c4 04             	add    $0x4,%esp
80102b1b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b20:	76 0d                	jbe    80102b2f <kfree+0x3a>
    panic("kfree");
80102b22:	83 ec 0c             	sub    $0xc,%esp
80102b25:	68 e3 8d 10 80       	push   $0x80108de3
80102b2a:	e8 2d da ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b2f:	83 ec 04             	sub    $0x4,%esp
80102b32:	68 00 10 00 00       	push   $0x1000
80102b37:	6a 01                	push   $0x1
80102b39:	ff 75 08             	pushl  0x8(%ebp)
80102b3c:	e8 ef 2a 00 00       	call   80105630 <memset>
80102b41:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b44:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b49:	85 c0                	test   %eax,%eax
80102b4b:	74 10                	je     80102b5d <kfree+0x68>
    acquire(&kmem.lock);
80102b4d:	83 ec 0c             	sub    $0xc,%esp
80102b50:	68 a0 32 11 80       	push   $0x801132a0
80102b55:	e8 7a 28 00 00       	call   801053d4 <acquire>
80102b5a:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b63:	8b 15 d8 32 11 80    	mov    0x801132d8,%edx
80102b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b6c:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b71:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102b76:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b7b:	85 c0                	test   %eax,%eax
80102b7d:	74 10                	je     80102b8f <kfree+0x9a>
    release(&kmem.lock);
80102b7f:	83 ec 0c             	sub    $0xc,%esp
80102b82:	68 a0 32 11 80       	push   $0x801132a0
80102b87:	e8 ae 28 00 00       	call   8010543a <release>
80102b8c:	83 c4 10             	add    $0x10,%esp
}
80102b8f:	c9                   	leave  
80102b90:	c3                   	ret    

80102b91 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b91:	55                   	push   %ebp
80102b92:	89 e5                	mov    %esp,%ebp
80102b94:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102b97:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b9c:	85 c0                	test   %eax,%eax
80102b9e:	74 10                	je     80102bb0 <kalloc+0x1f>
    acquire(&kmem.lock);
80102ba0:	83 ec 0c             	sub    $0xc,%esp
80102ba3:	68 a0 32 11 80       	push   $0x801132a0
80102ba8:	e8 27 28 00 00       	call   801053d4 <acquire>
80102bad:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102bb0:	a1 d8 32 11 80       	mov    0x801132d8,%eax
80102bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bbc:	74 0a                	je     80102bc8 <kalloc+0x37>
    kmem.freelist = r->next;
80102bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bc1:	8b 00                	mov    (%eax),%eax
80102bc3:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102bc8:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102bcd:	85 c0                	test   %eax,%eax
80102bcf:	74 10                	je     80102be1 <kalloc+0x50>
    release(&kmem.lock);
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	68 a0 32 11 80       	push   $0x801132a0
80102bd9:	e8 5c 28 00 00       	call   8010543a <release>
80102bde:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102be4:	c9                   	leave  
80102be5:	c3                   	ret    

80102be6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102be6:	55                   	push   %ebp
80102be7:	89 e5                	mov    %esp,%ebp
80102be9:	83 ec 14             	sub    $0x14,%esp
80102bec:	8b 45 08             	mov    0x8(%ebp),%eax
80102bef:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102bf7:	89 c2                	mov    %eax,%edx
80102bf9:	ec                   	in     (%dx),%al
80102bfa:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102bfd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c01:	c9                   	leave  
80102c02:	c3                   	ret    

80102c03 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c03:	55                   	push   %ebp
80102c04:	89 e5                	mov    %esp,%ebp
80102c06:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c09:	6a 64                	push   $0x64
80102c0b:	e8 d6 ff ff ff       	call   80102be6 <inb>
80102c10:	83 c4 04             	add    $0x4,%esp
80102c13:	0f b6 c0             	movzbl %al,%eax
80102c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c1c:	83 e0 01             	and    $0x1,%eax
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	75 0a                	jne    80102c2d <kbdgetc+0x2a>
    return -1;
80102c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c28:	e9 23 01 00 00       	jmp    80102d50 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c2d:	6a 60                	push   $0x60
80102c2f:	e8 b2 ff ff ff       	call   80102be6 <inb>
80102c34:	83 c4 04             	add    $0x4,%esp
80102c37:	0f b6 c0             	movzbl %al,%eax
80102c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c3d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c44:	75 17                	jne    80102c5d <kbdgetc+0x5a>
    shift |= E0ESC;
80102c46:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c4b:	83 c8 40             	or     $0x40,%eax
80102c4e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c53:	b8 00 00 00 00       	mov    $0x0,%eax
80102c58:	e9 f3 00 00 00       	jmp    80102d50 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c60:	25 80 00 00 00       	and    $0x80,%eax
80102c65:	85 c0                	test   %eax,%eax
80102c67:	74 45                	je     80102cae <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c69:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c6e:	83 e0 40             	and    $0x40,%eax
80102c71:	85 c0                	test   %eax,%eax
80102c73:	75 08                	jne    80102c7d <kbdgetc+0x7a>
80102c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c78:	83 e0 7f             	and    $0x7f,%eax
80102c7b:	eb 03                	jmp    80102c80 <kbdgetc+0x7d>
80102c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c86:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102c8b:	0f b6 00             	movzbl (%eax),%eax
80102c8e:	83 c8 40             	or     $0x40,%eax
80102c91:	0f b6 c0             	movzbl %al,%eax
80102c94:	f7 d0                	not    %eax
80102c96:	89 c2                	mov    %eax,%edx
80102c98:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c9d:	21 d0                	and    %edx,%eax
80102c9f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ca4:	b8 00 00 00 00       	mov    $0x0,%eax
80102ca9:	e9 a2 00 00 00       	jmp    80102d50 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102cae:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cb3:	83 e0 40             	and    $0x40,%eax
80102cb6:	85 c0                	test   %eax,%eax
80102cb8:	74 14                	je     80102cce <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cba:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cc1:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cc6:	83 e0 bf             	and    $0xffffffbf,%eax
80102cc9:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd1:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102cd6:	0f b6 00             	movzbl (%eax),%eax
80102cd9:	0f b6 d0             	movzbl %al,%edx
80102cdc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce1:	09 d0                	or     %edx,%eax
80102ce3:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ceb:	05 40 a1 10 80       	add    $0x8010a140,%eax
80102cf0:	0f b6 00             	movzbl (%eax),%eax
80102cf3:	0f b6 d0             	movzbl %al,%edx
80102cf6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cfb:	31 d0                	xor    %edx,%eax
80102cfd:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d02:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d07:	83 e0 03             	and    $0x3,%eax
80102d0a:	8b 14 85 40 a5 10 80 	mov    -0x7fef5ac0(,%eax,4),%edx
80102d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d14:	01 d0                	add    %edx,%eax
80102d16:	0f b6 00             	movzbl (%eax),%eax
80102d19:	0f b6 c0             	movzbl %al,%eax
80102d1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d1f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d24:	83 e0 08             	and    $0x8,%eax
80102d27:	85 c0                	test   %eax,%eax
80102d29:	74 22                	je     80102d4d <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d2b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d2f:	76 0c                	jbe    80102d3d <kbdgetc+0x13a>
80102d31:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d35:	77 06                	ja     80102d3d <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d37:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d3b:	eb 10                	jmp    80102d4d <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d3d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d41:	76 0a                	jbe    80102d4d <kbdgetc+0x14a>
80102d43:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d47:	77 04                	ja     80102d4d <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d49:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d50:	c9                   	leave  
80102d51:	c3                   	ret    

80102d52 <kbdintr>:

void
kbdintr(void)
{
80102d52:	55                   	push   %ebp
80102d53:	89 e5                	mov    %esp,%ebp
80102d55:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d58:	83 ec 0c             	sub    $0xc,%esp
80102d5b:	68 03 2c 10 80       	push   $0x80102c03
80102d60:	e8 6c da ff ff       	call   801007d1 <consoleintr>
80102d65:	83 c4 10             	add    $0x10,%esp
}
80102d68:	c9                   	leave  
80102d69:	c3                   	ret    

80102d6a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d6a:	55                   	push   %ebp
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	83 ec 14             	sub    $0x14,%esp
80102d70:	8b 45 08             	mov    0x8(%ebp),%eax
80102d73:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d77:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d7b:	89 c2                	mov    %eax,%edx
80102d7d:	ec                   	in     (%dx),%al
80102d7e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d81:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    

80102d87 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d87:	55                   	push   %ebp
80102d88:	89 e5                	mov    %esp,%ebp
80102d8a:	83 ec 08             	sub    $0x8,%esp
80102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80102d90:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d93:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d97:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d9e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102da2:	ee                   	out    %al,(%dx)
}
80102da3:	c9                   	leave  
80102da4:	c3                   	ret    

80102da5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102da5:	55                   	push   %ebp
80102da6:	89 e5                	mov    %esp,%ebp
80102da8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102dab:	9c                   	pushf  
80102dac:	58                   	pop    %eax
80102dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102db0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102db3:	c9                   	leave  
80102db4:	c3                   	ret    

80102db5 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102db5:	55                   	push   %ebp
80102db6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102db8:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dbd:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc0:	c1 e2 02             	shl    $0x2,%edx
80102dc3:	01 c2                	add    %eax,%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dca:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dcf:	83 c0 20             	add    $0x20,%eax
80102dd2:	8b 00                	mov    (%eax),%eax
}
80102dd4:	5d                   	pop    %ebp
80102dd5:	c3                   	ret    

80102dd6 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102dd6:	55                   	push   %ebp
80102dd7:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102dd9:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	75 05                	jne    80102de7 <lapicinit+0x11>
    return;
80102de2:	e9 09 01 00 00       	jmp    80102ef0 <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102de7:	68 3f 01 00 00       	push   $0x13f
80102dec:	6a 3c                	push   $0x3c
80102dee:	e8 c2 ff ff ff       	call   80102db5 <lapicw>
80102df3:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102df6:	6a 0b                	push   $0xb
80102df8:	68 f8 00 00 00       	push   $0xf8
80102dfd:	e8 b3 ff ff ff       	call   80102db5 <lapicw>
80102e02:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e05:	68 20 00 02 00       	push   $0x20020
80102e0a:	68 c8 00 00 00       	push   $0xc8
80102e0f:	e8 a1 ff ff ff       	call   80102db5 <lapicw>
80102e14:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e17:	68 80 96 98 00       	push   $0x989680
80102e1c:	68 e0 00 00 00       	push   $0xe0
80102e21:	e8 8f ff ff ff       	call   80102db5 <lapicw>
80102e26:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e29:	68 00 00 01 00       	push   $0x10000
80102e2e:	68 d4 00 00 00       	push   $0xd4
80102e33:	e8 7d ff ff ff       	call   80102db5 <lapicw>
80102e38:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e3b:	68 00 00 01 00       	push   $0x10000
80102e40:	68 d8 00 00 00       	push   $0xd8
80102e45:	e8 6b ff ff ff       	call   80102db5 <lapicw>
80102e4a:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e4d:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102e52:	83 c0 30             	add    $0x30,%eax
80102e55:	8b 00                	mov    (%eax),%eax
80102e57:	c1 e8 10             	shr    $0x10,%eax
80102e5a:	0f b6 c0             	movzbl %al,%eax
80102e5d:	83 f8 03             	cmp    $0x3,%eax
80102e60:	76 12                	jbe    80102e74 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102e62:	68 00 00 01 00       	push   $0x10000
80102e67:	68 d0 00 00 00       	push   $0xd0
80102e6c:	e8 44 ff ff ff       	call   80102db5 <lapicw>
80102e71:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e74:	6a 33                	push   $0x33
80102e76:	68 dc 00 00 00       	push   $0xdc
80102e7b:	e8 35 ff ff ff       	call   80102db5 <lapicw>
80102e80:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e83:	6a 00                	push   $0x0
80102e85:	68 a0 00 00 00       	push   $0xa0
80102e8a:	e8 26 ff ff ff       	call   80102db5 <lapicw>
80102e8f:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102e92:	6a 00                	push   $0x0
80102e94:	68 a0 00 00 00       	push   $0xa0
80102e99:	e8 17 ff ff ff       	call   80102db5 <lapicw>
80102e9e:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ea1:	6a 00                	push   $0x0
80102ea3:	6a 2c                	push   $0x2c
80102ea5:	e8 0b ff ff ff       	call   80102db5 <lapicw>
80102eaa:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ead:	6a 00                	push   $0x0
80102eaf:	68 c4 00 00 00       	push   $0xc4
80102eb4:	e8 fc fe ff ff       	call   80102db5 <lapicw>
80102eb9:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ebc:	68 00 85 08 00       	push   $0x88500
80102ec1:	68 c0 00 00 00       	push   $0xc0
80102ec6:	e8 ea fe ff ff       	call   80102db5 <lapicw>
80102ecb:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ece:	90                   	nop
80102ecf:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102ed4:	05 00 03 00 00       	add    $0x300,%eax
80102ed9:	8b 00                	mov    (%eax),%eax
80102edb:	25 00 10 00 00       	and    $0x1000,%eax
80102ee0:	85 c0                	test   %eax,%eax
80102ee2:	75 eb                	jne    80102ecf <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ee4:	6a 00                	push   $0x0
80102ee6:	6a 20                	push   $0x20
80102ee8:	e8 c8 fe ff ff       	call   80102db5 <lapicw>
80102eed:	83 c4 08             	add    $0x8,%esp
}
80102ef0:	c9                   	leave  
80102ef1:	c3                   	ret    

80102ef2 <cpunum>:

int
cpunum(void)
{
80102ef2:	55                   	push   %ebp
80102ef3:	89 e5                	mov    %esp,%ebp
80102ef5:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ef8:	e8 a8 fe ff ff       	call   80102da5 <readeflags>
80102efd:	25 00 02 00 00       	and    $0x200,%eax
80102f02:	85 c0                	test   %eax,%eax
80102f04:	74 26                	je     80102f2c <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f06:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102f0b:	8d 50 01             	lea    0x1(%eax),%edx
80102f0e:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102f14:	85 c0                	test   %eax,%eax
80102f16:	75 14                	jne    80102f2c <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f18:	8b 45 04             	mov    0x4(%ebp),%eax
80102f1b:	83 ec 08             	sub    $0x8,%esp
80102f1e:	50                   	push   %eax
80102f1f:	68 ec 8d 10 80       	push   $0x80108dec
80102f24:	e8 96 d4 ff ff       	call   801003bf <cprintf>
80102f29:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f2c:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f31:	85 c0                	test   %eax,%eax
80102f33:	74 0f                	je     80102f44 <cpunum+0x52>
    return lapic[ID]>>24;
80102f35:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f3a:	83 c0 20             	add    $0x20,%eax
80102f3d:	8b 00                	mov    (%eax),%eax
80102f3f:	c1 e8 18             	shr    $0x18,%eax
80102f42:	eb 05                	jmp    80102f49 <cpunum+0x57>
  return 0;
80102f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f49:	c9                   	leave  
80102f4a:	c3                   	ret    

80102f4b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f4b:	55                   	push   %ebp
80102f4c:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f4e:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102f53:	85 c0                	test   %eax,%eax
80102f55:	74 0c                	je     80102f63 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f57:	6a 00                	push   $0x0
80102f59:	6a 2c                	push   $0x2c
80102f5b:	e8 55 fe ff ff       	call   80102db5 <lapicw>
80102f60:	83 c4 08             	add    $0x8,%esp
}
80102f63:	c9                   	leave  
80102f64:	c3                   	ret    

80102f65 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f65:	55                   	push   %ebp
80102f66:	89 e5                	mov    %esp,%ebp
}
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    

80102f6a <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f6a:	55                   	push   %ebp
80102f6b:	89 e5                	mov    %esp,%ebp
80102f6d:	83 ec 14             	sub    $0x14,%esp
80102f70:	8b 45 08             	mov    0x8(%ebp),%eax
80102f73:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f76:	6a 0f                	push   $0xf
80102f78:	6a 70                	push   $0x70
80102f7a:	e8 08 fe ff ff       	call   80102d87 <outb>
80102f7f:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102f82:	6a 0a                	push   $0xa
80102f84:	6a 71                	push   $0x71
80102f86:	e8 fc fd ff ff       	call   80102d87 <outb>
80102f8b:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f8e:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f98:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fa0:	83 c0 02             	add    $0x2,%eax
80102fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fa6:	c1 ea 04             	shr    $0x4,%edx
80102fa9:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fac:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fb0:	c1 e0 18             	shl    $0x18,%eax
80102fb3:	50                   	push   %eax
80102fb4:	68 c4 00 00 00       	push   $0xc4
80102fb9:	e8 f7 fd ff ff       	call   80102db5 <lapicw>
80102fbe:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fc1:	68 00 c5 00 00       	push   $0xc500
80102fc6:	68 c0 00 00 00       	push   $0xc0
80102fcb:	e8 e5 fd ff ff       	call   80102db5 <lapicw>
80102fd0:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102fd3:	68 c8 00 00 00       	push   $0xc8
80102fd8:	e8 88 ff ff ff       	call   80102f65 <microdelay>
80102fdd:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102fe0:	68 00 85 00 00       	push   $0x8500
80102fe5:	68 c0 00 00 00       	push   $0xc0
80102fea:	e8 c6 fd ff ff       	call   80102db5 <lapicw>
80102fef:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102ff2:	6a 64                	push   $0x64
80102ff4:	e8 6c ff ff ff       	call   80102f65 <microdelay>
80102ff9:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103003:	eb 3d                	jmp    80103042 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103005:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103009:	c1 e0 18             	shl    $0x18,%eax
8010300c:	50                   	push   %eax
8010300d:	68 c4 00 00 00       	push   $0xc4
80103012:	e8 9e fd ff ff       	call   80102db5 <lapicw>
80103017:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010301a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010301d:	c1 e8 0c             	shr    $0xc,%eax
80103020:	80 cc 06             	or     $0x6,%ah
80103023:	50                   	push   %eax
80103024:	68 c0 00 00 00       	push   $0xc0
80103029:	e8 87 fd ff ff       	call   80102db5 <lapicw>
8010302e:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103031:	68 c8 00 00 00       	push   $0xc8
80103036:	e8 2a ff ff ff       	call   80102f65 <microdelay>
8010303b:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010303e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103042:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103046:	7e bd                	jle    80103005 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103048:	c9                   	leave  
80103049:	c3                   	ret    

8010304a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010304a:	55                   	push   %ebp
8010304b:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010304d:	8b 45 08             	mov    0x8(%ebp),%eax
80103050:	0f b6 c0             	movzbl %al,%eax
80103053:	50                   	push   %eax
80103054:	6a 70                	push   $0x70
80103056:	e8 2c fd ff ff       	call   80102d87 <outb>
8010305b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010305e:	68 c8 00 00 00       	push   $0xc8
80103063:	e8 fd fe ff ff       	call   80102f65 <microdelay>
80103068:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010306b:	6a 71                	push   $0x71
8010306d:	e8 f8 fc ff ff       	call   80102d6a <inb>
80103072:	83 c4 04             	add    $0x4,%esp
80103075:	0f b6 c0             	movzbl %al,%eax
}
80103078:	c9                   	leave  
80103079:	c3                   	ret    

8010307a <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010307d:	6a 00                	push   $0x0
8010307f:	e8 c6 ff ff ff       	call   8010304a <cmos_read>
80103084:	83 c4 04             	add    $0x4,%esp
80103087:	89 c2                	mov    %eax,%edx
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010308e:	6a 02                	push   $0x2
80103090:	e8 b5 ff ff ff       	call   8010304a <cmos_read>
80103095:	83 c4 04             	add    $0x4,%esp
80103098:	89 c2                	mov    %eax,%edx
8010309a:	8b 45 08             	mov    0x8(%ebp),%eax
8010309d:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801030a0:	6a 04                	push   $0x4
801030a2:	e8 a3 ff ff ff       	call   8010304a <cmos_read>
801030a7:	83 c4 04             	add    $0x4,%esp
801030aa:	89 c2                	mov    %eax,%edx
801030ac:	8b 45 08             	mov    0x8(%ebp),%eax
801030af:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801030b2:	6a 07                	push   $0x7
801030b4:	e8 91 ff ff ff       	call   8010304a <cmos_read>
801030b9:	83 c4 04             	add    $0x4,%esp
801030bc:	89 c2                	mov    %eax,%edx
801030be:	8b 45 08             	mov    0x8(%ebp),%eax
801030c1:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801030c4:	6a 08                	push   $0x8
801030c6:	e8 7f ff ff ff       	call   8010304a <cmos_read>
801030cb:	83 c4 04             	add    $0x4,%esp
801030ce:	89 c2                	mov    %eax,%edx
801030d0:	8b 45 08             	mov    0x8(%ebp),%eax
801030d3:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801030d6:	6a 09                	push   $0x9
801030d8:	e8 6d ff ff ff       	call   8010304a <cmos_read>
801030dd:	83 c4 04             	add    $0x4,%esp
801030e0:	89 c2                	mov    %eax,%edx
801030e2:	8b 45 08             	mov    0x8(%ebp),%eax
801030e5:	89 50 14             	mov    %edx,0x14(%eax)
}
801030e8:	c9                   	leave  
801030e9:	c3                   	ret    

801030ea <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
801030ed:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030f0:	6a 0b                	push   $0xb
801030f2:	e8 53 ff ff ff       	call   8010304a <cmos_read>
801030f7:	83 c4 04             	add    $0x4,%esp
801030fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103100:	83 e0 04             	and    $0x4,%eax
80103103:	85 c0                	test   %eax,%eax
80103105:	0f 94 c0             	sete   %al
80103108:	0f b6 c0             	movzbl %al,%eax
8010310b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010310e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103111:	50                   	push   %eax
80103112:	e8 63 ff ff ff       	call   8010307a <fill_rtcdate>
80103117:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010311a:	6a 0a                	push   $0xa
8010311c:	e8 29 ff ff ff       	call   8010304a <cmos_read>
80103121:	83 c4 04             	add    $0x4,%esp
80103124:	25 80 00 00 00       	and    $0x80,%eax
80103129:	85 c0                	test   %eax,%eax
8010312b:	74 02                	je     8010312f <cmostime+0x45>
        continue;
8010312d:	eb 32                	jmp    80103161 <cmostime+0x77>
    fill_rtcdate(&t2);
8010312f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103132:	50                   	push   %eax
80103133:	e8 42 ff ff ff       	call   8010307a <fill_rtcdate>
80103138:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010313b:	83 ec 04             	sub    $0x4,%esp
8010313e:	6a 18                	push   $0x18
80103140:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103143:	50                   	push   %eax
80103144:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103147:	50                   	push   %eax
80103148:	e8 4a 25 00 00       	call   80105697 <memcmp>
8010314d:	83 c4 10             	add    $0x10,%esp
80103150:	85 c0                	test   %eax,%eax
80103152:	75 0d                	jne    80103161 <cmostime+0x77>
      break;
80103154:	90                   	nop
  }

  // convert
  if (bcd) {
80103155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103159:	0f 84 b8 00 00 00    	je     80103217 <cmostime+0x12d>
8010315f:	eb 02                	jmp    80103163 <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103161:	eb ab                	jmp    8010310e <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103163:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103166:	c1 e8 04             	shr    $0x4,%eax
80103169:	89 c2                	mov    %eax,%edx
8010316b:	89 d0                	mov    %edx,%eax
8010316d:	c1 e0 02             	shl    $0x2,%eax
80103170:	01 d0                	add    %edx,%eax
80103172:	01 c0                	add    %eax,%eax
80103174:	89 c2                	mov    %eax,%edx
80103176:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103179:	83 e0 0f             	and    $0xf,%eax
8010317c:	01 d0                	add    %edx,%eax
8010317e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103181:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103184:	c1 e8 04             	shr    $0x4,%eax
80103187:	89 c2                	mov    %eax,%edx
80103189:	89 d0                	mov    %edx,%eax
8010318b:	c1 e0 02             	shl    $0x2,%eax
8010318e:	01 d0                	add    %edx,%eax
80103190:	01 c0                	add    %eax,%eax
80103192:	89 c2                	mov    %eax,%edx
80103194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103197:	83 e0 0f             	and    $0xf,%eax
8010319a:	01 d0                	add    %edx,%eax
8010319c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010319f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031a2:	c1 e8 04             	shr    $0x4,%eax
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	89 d0                	mov    %edx,%eax
801031a9:	c1 e0 02             	shl    $0x2,%eax
801031ac:	01 d0                	add    %edx,%eax
801031ae:	01 c0                	add    %eax,%eax
801031b0:	89 c2                	mov    %eax,%edx
801031b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031b5:	83 e0 0f             	and    $0xf,%eax
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	89 c2                	mov    %eax,%edx
801031d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031d3:	83 e0 0f             	and    $0xf,%eax
801031d6:	01 d0                	add    %edx,%eax
801031d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031de:	c1 e8 04             	shr    $0x4,%eax
801031e1:	89 c2                	mov    %eax,%edx
801031e3:	89 d0                	mov    %edx,%eax
801031e5:	c1 e0 02             	shl    $0x2,%eax
801031e8:	01 d0                	add    %edx,%eax
801031ea:	01 c0                	add    %eax,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031f1:	83 e0 0f             	and    $0xf,%eax
801031f4:	01 d0                	add    %edx,%eax
801031f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031fc:	c1 e8 04             	shr    $0x4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	89 d0                	mov    %edx,%eax
80103203:	c1 e0 02             	shl    $0x2,%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	01 c0                	add    %eax,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010320f:	83 e0 0f             	and    $0xf,%eax
80103212:	01 d0                	add    %edx,%eax
80103214:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103217:	8b 45 08             	mov    0x8(%ebp),%eax
8010321a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010321d:	89 10                	mov    %edx,(%eax)
8010321f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103222:	89 50 04             	mov    %edx,0x4(%eax)
80103225:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103228:	89 50 08             	mov    %edx,0x8(%eax)
8010322b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010322e:	89 50 0c             	mov    %edx,0xc(%eax)
80103231:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103234:	89 50 10             	mov    %edx,0x10(%eax)
80103237:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010323a:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010323d:	8b 45 08             	mov    0x8(%ebp),%eax
80103240:	8b 40 14             	mov    0x14(%eax),%eax
80103243:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103249:	8b 45 08             	mov    0x8(%ebp),%eax
8010324c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010324f:	c9                   	leave  
80103250:	c3                   	ret    

80103251 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103251:	55                   	push   %ebp
80103252:	89 e5                	mov    %esp,%ebp
80103254:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103257:	83 ec 08             	sub    $0x8,%esp
8010325a:	68 18 8e 10 80       	push   $0x80108e18
8010325f:	68 00 33 11 80       	push   $0x80113300
80103264:	e8 4a 21 00 00       	call   801053b3 <initlock>
80103269:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
8010326c:	83 ec 08             	sub    $0x8,%esp
8010326f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103272:	50                   	push   %eax
80103273:	6a 01                	push   $0x1
80103275:	e8 d0 e0 ff ff       	call   8010134a <readsb>
8010327a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
8010327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103283:	29 c2                	sub    %eax,%edx
80103285:	89 d0                	mov    %edx,%eax
80103287:	a3 34 33 11 80       	mov    %eax,0x80113334
  log.size = sb.nlog;
8010328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010328f:	a3 38 33 11 80       	mov    %eax,0x80113338
  log.dev = ROOTDEV;
80103294:	c7 05 44 33 11 80 01 	movl   $0x1,0x80113344
8010329b:	00 00 00 
  recover_from_log();
8010329e:	e8 ae 01 00 00       	call   80103451 <recover_from_log>
}
801032a3:	c9                   	leave  
801032a4:	c3                   	ret    

801032a5 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032a5:	55                   	push   %ebp
801032a6:	89 e5                	mov    %esp,%ebp
801032a8:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b2:	e9 95 00 00 00       	jmp    8010334c <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032b7:	8b 15 34 33 11 80    	mov    0x80113334,%edx
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	01 d0                	add    %edx,%eax
801032c2:	83 c0 01             	add    $0x1,%eax
801032c5:	89 c2                	mov    %eax,%edx
801032c7:	a1 44 33 11 80       	mov    0x80113344,%eax
801032cc:	83 ec 08             	sub    $0x8,%esp
801032cf:	52                   	push   %edx
801032d0:	50                   	push   %eax
801032d1:	e8 de ce ff ff       	call   801001b4 <bread>
801032d6:	83 c4 10             	add    $0x10,%esp
801032d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032df:	83 c0 10             	add    $0x10,%eax
801032e2:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
801032e9:	89 c2                	mov    %eax,%edx
801032eb:	a1 44 33 11 80       	mov    0x80113344,%eax
801032f0:	83 ec 08             	sub    $0x8,%esp
801032f3:	52                   	push   %edx
801032f4:	50                   	push   %eax
801032f5:	e8 ba ce ff ff       	call   801001b4 <bread>
801032fa:	83 c4 10             	add    $0x10,%esp
801032fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103300:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103303:	8d 50 18             	lea    0x18(%eax),%edx
80103306:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103309:	83 c0 18             	add    $0x18,%eax
8010330c:	83 ec 04             	sub    $0x4,%esp
8010330f:	68 00 02 00 00       	push   $0x200
80103314:	52                   	push   %edx
80103315:	50                   	push   %eax
80103316:	e8 d4 23 00 00       	call   801056ef <memmove>
8010331b:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010331e:	83 ec 0c             	sub    $0xc,%esp
80103321:	ff 75 ec             	pushl  -0x14(%ebp)
80103324:	e8 c4 ce ff ff       	call   801001ed <bwrite>
80103329:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010332c:	83 ec 0c             	sub    $0xc,%esp
8010332f:	ff 75 f0             	pushl  -0x10(%ebp)
80103332:	e8 f4 ce ff ff       	call   8010022b <brelse>
80103337:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010333a:	83 ec 0c             	sub    $0xc,%esp
8010333d:	ff 75 ec             	pushl  -0x14(%ebp)
80103340:	e8 e6 ce ff ff       	call   8010022b <brelse>
80103345:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103348:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010334c:	a1 48 33 11 80       	mov    0x80113348,%eax
80103351:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103354:	0f 8f 5d ff ff ff    	jg     801032b7 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010335a:	c9                   	leave  
8010335b:	c3                   	ret    

8010335c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010335c:	55                   	push   %ebp
8010335d:	89 e5                	mov    %esp,%ebp
8010335f:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103362:	a1 34 33 11 80       	mov    0x80113334,%eax
80103367:	89 c2                	mov    %eax,%edx
80103369:	a1 44 33 11 80       	mov    0x80113344,%eax
8010336e:	83 ec 08             	sub    $0x8,%esp
80103371:	52                   	push   %edx
80103372:	50                   	push   %eax
80103373:	e8 3c ce ff ff       	call   801001b4 <bread>
80103378:	83 c4 10             	add    $0x10,%esp
8010337b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103381:	83 c0 18             	add    $0x18,%eax
80103384:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103387:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338a:	8b 00                	mov    (%eax),%eax
8010338c:	a3 48 33 11 80       	mov    %eax,0x80113348
  for (i = 0; i < log.lh.n; i++) {
80103391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103398:	eb 1b                	jmp    801033b5 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
8010339a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010339d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033a0:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033a7:	83 c2 10             	add    $0x10,%edx
801033aa:	89 04 95 0c 33 11 80 	mov    %eax,-0x7feeccf4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033b5:	a1 48 33 11 80       	mov    0x80113348,%eax
801033ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033bd:	7f db                	jg     8010339a <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033bf:	83 ec 0c             	sub    $0xc,%esp
801033c2:	ff 75 f0             	pushl  -0x10(%ebp)
801033c5:	e8 61 ce ff ff       	call   8010022b <brelse>
801033ca:	83 c4 10             	add    $0x10,%esp
}
801033cd:	c9                   	leave  
801033ce:	c3                   	ret    

801033cf <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033cf:	55                   	push   %ebp
801033d0:	89 e5                	mov    %esp,%ebp
801033d2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033d5:	a1 34 33 11 80       	mov    0x80113334,%eax
801033da:	89 c2                	mov    %eax,%edx
801033dc:	a1 44 33 11 80       	mov    0x80113344,%eax
801033e1:	83 ec 08             	sub    $0x8,%esp
801033e4:	52                   	push   %edx
801033e5:	50                   	push   %eax
801033e6:	e8 c9 cd ff ff       	call   801001b4 <bread>
801033eb:	83 c4 10             	add    $0x10,%esp
801033ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f4:	83 c0 18             	add    $0x18,%eax
801033f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033fa:	8b 15 48 33 11 80    	mov    0x80113348,%edx
80103400:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103403:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010340c:	eb 1b                	jmp    80103429 <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
8010340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103411:	83 c0 10             	add    $0x10,%eax
80103414:	8b 0c 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%ecx
8010341b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010341e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103421:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103429:	a1 48 33 11 80       	mov    0x80113348,%eax
8010342e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103431:	7f db                	jg     8010340e <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103433:	83 ec 0c             	sub    $0xc,%esp
80103436:	ff 75 f0             	pushl  -0x10(%ebp)
80103439:	e8 af cd ff ff       	call   801001ed <bwrite>
8010343e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103441:	83 ec 0c             	sub    $0xc,%esp
80103444:	ff 75 f0             	pushl  -0x10(%ebp)
80103447:	e8 df cd ff ff       	call   8010022b <brelse>
8010344c:	83 c4 10             	add    $0x10,%esp
}
8010344f:	c9                   	leave  
80103450:	c3                   	ret    

80103451 <recover_from_log>:

static void
recover_from_log(void)
{
80103451:	55                   	push   %ebp
80103452:	89 e5                	mov    %esp,%ebp
80103454:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103457:	e8 00 ff ff ff       	call   8010335c <read_head>
  install_trans(); // if committed, copy from log to disk
8010345c:	e8 44 fe ff ff       	call   801032a5 <install_trans>
  log.lh.n = 0;
80103461:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
80103468:	00 00 00 
  write_head(); // clear the log
8010346b:	e8 5f ff ff ff       	call   801033cf <write_head>
}
80103470:	c9                   	leave  
80103471:	c3                   	ret    

80103472 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103472:	55                   	push   %ebp
80103473:	89 e5                	mov    %esp,%ebp
80103475:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 00 33 11 80       	push   $0x80113300
80103480:	e8 4f 1f 00 00       	call   801053d4 <acquire>
80103485:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103488:	a1 40 33 11 80       	mov    0x80113340,%eax
8010348d:	85 c0                	test   %eax,%eax
8010348f:	74 17                	je     801034a8 <begin_op+0x36>
      sleep(&log, &log.lock);
80103491:	83 ec 08             	sub    $0x8,%esp
80103494:	68 00 33 11 80       	push   $0x80113300
80103499:	68 00 33 11 80       	push   $0x80113300
8010349e:	e8 3d 1a 00 00       	call   80104ee0 <sleep>
801034a3:	83 c4 10             	add    $0x10,%esp
801034a6:	eb 54                	jmp    801034fc <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034a8:	8b 0d 48 33 11 80    	mov    0x80113348,%ecx
801034ae:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801034b3:	8d 50 01             	lea    0x1(%eax),%edx
801034b6:	89 d0                	mov    %edx,%eax
801034b8:	c1 e0 02             	shl    $0x2,%eax
801034bb:	01 d0                	add    %edx,%eax
801034bd:	01 c0                	add    %eax,%eax
801034bf:	01 c8                	add    %ecx,%eax
801034c1:	83 f8 1e             	cmp    $0x1e,%eax
801034c4:	7e 17                	jle    801034dd <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034c6:	83 ec 08             	sub    $0x8,%esp
801034c9:	68 00 33 11 80       	push   $0x80113300
801034ce:	68 00 33 11 80       	push   $0x80113300
801034d3:	e8 08 1a 00 00       	call   80104ee0 <sleep>
801034d8:	83 c4 10             	add    $0x10,%esp
801034db:	eb 1f                	jmp    801034fc <begin_op+0x8a>
    } else {
      log.outstanding += 1;
801034dd:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801034e2:	83 c0 01             	add    $0x1,%eax
801034e5:	a3 3c 33 11 80       	mov    %eax,0x8011333c
      release(&log.lock);
801034ea:	83 ec 0c             	sub    $0xc,%esp
801034ed:	68 00 33 11 80       	push   $0x80113300
801034f2:	e8 43 1f 00 00       	call   8010543a <release>
801034f7:	83 c4 10             	add    $0x10,%esp
      break;
801034fa:	eb 02                	jmp    801034fe <begin_op+0x8c>
    }
  }
801034fc:	eb 8a                	jmp    80103488 <begin_op+0x16>
}
801034fe:	c9                   	leave  
801034ff:	c3                   	ret    

80103500 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103506:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010350d:	83 ec 0c             	sub    $0xc,%esp
80103510:	68 00 33 11 80       	push   $0x80113300
80103515:	e8 ba 1e 00 00       	call   801053d4 <acquire>
8010351a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010351d:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103522:	83 e8 01             	sub    $0x1,%eax
80103525:	a3 3c 33 11 80       	mov    %eax,0x8011333c
  if(log.committing)
8010352a:	a1 40 33 11 80       	mov    0x80113340,%eax
8010352f:	85 c0                	test   %eax,%eax
80103531:	74 0d                	je     80103540 <end_op+0x40>
    panic("log.committing");
80103533:	83 ec 0c             	sub    $0xc,%esp
80103536:	68 1c 8e 10 80       	push   $0x80108e1c
8010353b:	e8 1c d0 ff ff       	call   8010055c <panic>
  if(log.outstanding == 0){
80103540:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103545:	85 c0                	test   %eax,%eax
80103547:	75 13                	jne    8010355c <end_op+0x5c>
    do_commit = 1;
80103549:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103550:	c7 05 40 33 11 80 01 	movl   $0x1,0x80113340
80103557:	00 00 00 
8010355a:	eb 10                	jmp    8010356c <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010355c:	83 ec 0c             	sub    $0xc,%esp
8010355f:	68 00 33 11 80       	push   $0x80113300
80103564:	e8 9a 1a 00 00       	call   80105003 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010356c:	83 ec 0c             	sub    $0xc,%esp
8010356f:	68 00 33 11 80       	push   $0x80113300
80103574:	e8 c1 1e 00 00       	call   8010543a <release>
80103579:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010357c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103580:	74 3f                	je     801035c1 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103582:	e8 f3 00 00 00       	call   8010367a <commit>
    acquire(&log.lock);
80103587:	83 ec 0c             	sub    $0xc,%esp
8010358a:	68 00 33 11 80       	push   $0x80113300
8010358f:	e8 40 1e 00 00       	call   801053d4 <acquire>
80103594:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103597:	c7 05 40 33 11 80 00 	movl   $0x0,0x80113340
8010359e:	00 00 00 
    wakeup(&log);
801035a1:	83 ec 0c             	sub    $0xc,%esp
801035a4:	68 00 33 11 80       	push   $0x80113300
801035a9:	e8 55 1a 00 00       	call   80105003 <wakeup>
801035ae:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801035b1:	83 ec 0c             	sub    $0xc,%esp
801035b4:	68 00 33 11 80       	push   $0x80113300
801035b9:	e8 7c 1e 00 00       	call   8010543a <release>
801035be:	83 c4 10             	add    $0x10,%esp
  }
}
801035c1:	c9                   	leave  
801035c2:	c3                   	ret    

801035c3 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035c3:	55                   	push   %ebp
801035c4:	89 e5                	mov    %esp,%ebp
801035c6:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035d0:	e9 95 00 00 00       	jmp    8010366a <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035d5:	8b 15 34 33 11 80    	mov    0x80113334,%edx
801035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035de:	01 d0                	add    %edx,%eax
801035e0:	83 c0 01             	add    $0x1,%eax
801035e3:	89 c2                	mov    %eax,%edx
801035e5:	a1 44 33 11 80       	mov    0x80113344,%eax
801035ea:	83 ec 08             	sub    $0x8,%esp
801035ed:	52                   	push   %edx
801035ee:	50                   	push   %eax
801035ef:	e8 c0 cb ff ff       	call   801001b4 <bread>
801035f4:	83 c4 10             	add    $0x10,%esp
801035f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
801035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035fd:	83 c0 10             	add    $0x10,%eax
80103600:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
80103607:	89 c2                	mov    %eax,%edx
80103609:	a1 44 33 11 80       	mov    0x80113344,%eax
8010360e:	83 ec 08             	sub    $0x8,%esp
80103611:	52                   	push   %edx
80103612:	50                   	push   %eax
80103613:	e8 9c cb ff ff       	call   801001b4 <bread>
80103618:	83 c4 10             	add    $0x10,%esp
8010361b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010361e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103621:	8d 50 18             	lea    0x18(%eax),%edx
80103624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103627:	83 c0 18             	add    $0x18,%eax
8010362a:	83 ec 04             	sub    $0x4,%esp
8010362d:	68 00 02 00 00       	push   $0x200
80103632:	52                   	push   %edx
80103633:	50                   	push   %eax
80103634:	e8 b6 20 00 00       	call   801056ef <memmove>
80103639:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	ff 75 f0             	pushl  -0x10(%ebp)
80103642:	e8 a6 cb ff ff       	call   801001ed <bwrite>
80103647:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010364a:	83 ec 0c             	sub    $0xc,%esp
8010364d:	ff 75 ec             	pushl  -0x14(%ebp)
80103650:	e8 d6 cb ff ff       	call   8010022b <brelse>
80103655:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	ff 75 f0             	pushl  -0x10(%ebp)
8010365e:	e8 c8 cb ff ff       	call   8010022b <brelse>
80103663:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103666:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010366a:	a1 48 33 11 80       	mov    0x80113348,%eax
8010366f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103672:	0f 8f 5d ff ff ff    	jg     801035d5 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103678:	c9                   	leave  
80103679:	c3                   	ret    

8010367a <commit>:

static void
commit()
{
8010367a:	55                   	push   %ebp
8010367b:	89 e5                	mov    %esp,%ebp
8010367d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103680:	a1 48 33 11 80       	mov    0x80113348,%eax
80103685:	85 c0                	test   %eax,%eax
80103687:	7e 1e                	jle    801036a7 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103689:	e8 35 ff ff ff       	call   801035c3 <write_log>
    write_head();    // Write header to disk -- the real commit
8010368e:	e8 3c fd ff ff       	call   801033cf <write_head>
    install_trans(); // Now install writes to home locations
80103693:	e8 0d fc ff ff       	call   801032a5 <install_trans>
    log.lh.n = 0; 
80103698:	c7 05 48 33 11 80 00 	movl   $0x0,0x80113348
8010369f:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a2:	e8 28 fd ff ff       	call   801033cf <write_head>
  }
}
801036a7:	c9                   	leave  
801036a8:	c3                   	ret    

801036a9 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036a9:	55                   	push   %ebp
801036aa:	89 e5                	mov    %esp,%ebp
801036ac:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036af:	a1 48 33 11 80       	mov    0x80113348,%eax
801036b4:	83 f8 1d             	cmp    $0x1d,%eax
801036b7:	7f 12                	jg     801036cb <log_write+0x22>
801036b9:	a1 48 33 11 80       	mov    0x80113348,%eax
801036be:	8b 15 38 33 11 80    	mov    0x80113338,%edx
801036c4:	83 ea 01             	sub    $0x1,%edx
801036c7:	39 d0                	cmp    %edx,%eax
801036c9:	7c 0d                	jl     801036d8 <log_write+0x2f>
    panic("too big a transaction");
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	68 2b 8e 10 80       	push   $0x80108e2b
801036d3:	e8 84 ce ff ff       	call   8010055c <panic>
  if (log.outstanding < 1)
801036d8:	a1 3c 33 11 80       	mov    0x8011333c,%eax
801036dd:	85 c0                	test   %eax,%eax
801036df:	7f 0d                	jg     801036ee <log_write+0x45>
    panic("log_write outside of trans");
801036e1:	83 ec 0c             	sub    $0xc,%esp
801036e4:	68 41 8e 10 80       	push   $0x80108e41
801036e9:	e8 6e ce ff ff       	call   8010055c <panic>

  acquire(&log.lock);
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	68 00 33 11 80       	push   $0x80113300
801036f6:	e8 d9 1c 00 00       	call   801053d4 <acquire>
801036fb:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801036fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103705:	eb 1f                	jmp    80103726 <log_write+0x7d>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010370a:	83 c0 10             	add    $0x10,%eax
8010370d:	8b 04 85 0c 33 11 80 	mov    -0x7feeccf4(,%eax,4),%eax
80103714:	89 c2                	mov    %eax,%edx
80103716:	8b 45 08             	mov    0x8(%ebp),%eax
80103719:	8b 40 08             	mov    0x8(%eax),%eax
8010371c:	39 c2                	cmp    %eax,%edx
8010371e:	75 02                	jne    80103722 <log_write+0x79>
      break;
80103720:	eb 0e                	jmp    80103730 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103726:	a1 48 33 11 80       	mov    0x80113348,%eax
8010372b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010372e:	7f d7                	jg     80103707 <log_write+0x5e>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
80103730:	8b 45 08             	mov    0x8(%ebp),%eax
80103733:	8b 40 08             	mov    0x8(%eax),%eax
80103736:	89 c2                	mov    %eax,%edx
80103738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373b:	83 c0 10             	add    $0x10,%eax
8010373e:	89 14 85 0c 33 11 80 	mov    %edx,-0x7feeccf4(,%eax,4)
  if (i == log.lh.n)
80103745:	a1 48 33 11 80       	mov    0x80113348,%eax
8010374a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010374d:	75 0d                	jne    8010375c <log_write+0xb3>
    log.lh.n++;
8010374f:	a1 48 33 11 80       	mov    0x80113348,%eax
80103754:	83 c0 01             	add    $0x1,%eax
80103757:	a3 48 33 11 80       	mov    %eax,0x80113348
  b->flags |= B_DIRTY; // prevent eviction
8010375c:	8b 45 08             	mov    0x8(%ebp),%eax
8010375f:	8b 00                	mov    (%eax),%eax
80103761:	83 c8 04             	or     $0x4,%eax
80103764:	89 c2                	mov    %eax,%edx
80103766:	8b 45 08             	mov    0x8(%ebp),%eax
80103769:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010376b:	83 ec 0c             	sub    $0xc,%esp
8010376e:	68 00 33 11 80       	push   $0x80113300
80103773:	e8 c2 1c 00 00       	call   8010543a <release>
80103778:	83 c4 10             	add    $0x10,%esp
}
8010377b:	c9                   	leave  
8010377c:	c3                   	ret    

8010377d <v2p>:
8010377d:	55                   	push   %ebp
8010377e:	89 e5                	mov    %esp,%ebp
80103780:	8b 45 08             	mov    0x8(%ebp),%eax
80103783:	05 00 00 00 80       	add    $0x80000000,%eax
80103788:	5d                   	pop    %ebp
80103789:	c3                   	ret    

8010378a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010378a:	55                   	push   %ebp
8010378b:	89 e5                	mov    %esp,%ebp
8010378d:	8b 45 08             	mov    0x8(%ebp),%eax
80103790:	05 00 00 00 80       	add    $0x80000000,%eax
80103795:	5d                   	pop    %ebp
80103796:	c3                   	ret    

80103797 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103797:	55                   	push   %ebp
80103798:	89 e5                	mov    %esp,%ebp
8010379a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010379d:	8b 55 08             	mov    0x8(%ebp),%edx
801037a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801037a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037a6:	f0 87 02             	lock xchg %eax,(%edx)
801037a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037af:	c9                   	leave  
801037b0:	c3                   	ret    

801037b1 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037b1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801037b5:	83 e4 f0             	and    $0xfffffff0,%esp
801037b8:	ff 71 fc             	pushl  -0x4(%ecx)
801037bb:	55                   	push   %ebp
801037bc:	89 e5                	mov    %esp,%ebp
801037be:	51                   	push   %ecx
801037bf:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037c2:	83 ec 08             	sub    $0x8,%esp
801037c5:	68 00 00 40 80       	push   $0x80400000
801037ca:	68 5c 6c 11 80       	push   $0x80116c5c
801037cf:	e8 8a f2 ff ff       	call   80102a5e <kinit1>
801037d4:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801037d7:	e8 ca 4c 00 00       	call   801084a6 <kvmalloc>
  mpinit();        // collect info about this machine
801037dc:	e8 45 04 00 00       	call   80103c26 <mpinit>
  lapicinit();
801037e1:	e8 f0 f5 ff ff       	call   80102dd6 <lapicinit>
  seginit();       // set up segments
801037e6:	e8 63 46 00 00       	call   80107e4e <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801037eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037f1:	0f b6 00             	movzbl (%eax),%eax
801037f4:	0f b6 c0             	movzbl %al,%eax
801037f7:	83 ec 08             	sub    $0x8,%esp
801037fa:	50                   	push   %eax
801037fb:	68 5c 8e 10 80       	push   $0x80108e5c
80103800:	e8 ba cb ff ff       	call   801003bf <cprintf>
80103805:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103808:	e8 6a 06 00 00       	call   80103e77 <picinit>
  ioapicinit();    // another interrupt controller
8010380d:	e8 44 f1 ff ff       	call   80102956 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103812:	e8 cc d2 ff ff       	call   80100ae3 <consoleinit>
  uartinit();      // serial port
80103817:	e8 95 39 00 00       	call   801071b1 <uartinit>
  pinit();         // process table
8010381c:	e8 55 0b 00 00       	call   80104376 <pinit>
  tvinit();        // trap vectors
80103821:	e8 3d 35 00 00       	call   80106d63 <tvinit>
  binit();         // buffer cache
80103826:	e8 09 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010382b:	e8 0e d7 ff ff       	call   80100f3e <fileinit>
  iinit();         // inode cache
80103830:	e8 d4 dd ff ff       	call   80101609 <iinit>
  ideinit();       // disk
80103835:	e8 64 ed ff ff       	call   8010259e <ideinit>
  if(!ismp)
8010383a:	a1 04 34 11 80       	mov    0x80113404,%eax
8010383f:	85 c0                	test   %eax,%eax
80103841:	75 05                	jne    80103848 <main+0x97>
    timerinit();   // uniprocessor timer
80103843:	e8 7a 34 00 00       	call   80106cc2 <timerinit>
  startothers();   // start other processors
80103848:	e8 7f 00 00 00       	call   801038cc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010384d:	83 ec 08             	sub    $0x8,%esp
80103850:	68 00 00 00 8e       	push   $0x8e000000
80103855:	68 00 00 40 80       	push   $0x80400000
8010385a:	e8 37 f2 ff ff       	call   80102a96 <kinit2>
8010385f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103862:	e8 91 0d 00 00       	call   801045f8 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103867:	e8 1a 00 00 00       	call   80103886 <mpmain>

8010386c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103872:	e8 46 4c 00 00       	call   801084bd <switchkvm>
  seginit();
80103877:	e8 d2 45 00 00       	call   80107e4e <seginit>
  lapicinit();
8010387c:	e8 55 f5 ff ff       	call   80102dd6 <lapicinit>
  mpmain();
80103881:	e8 00 00 00 00       	call   80103886 <mpmain>

80103886 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103886:	55                   	push   %ebp
80103887:	89 e5                	mov    %esp,%ebp
80103889:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010388c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103892:	0f b6 00             	movzbl (%eax),%eax
80103895:	0f b6 c0             	movzbl %al,%eax
80103898:	83 ec 08             	sub    $0x8,%esp
8010389b:	50                   	push   %eax
8010389c:	68 73 8e 10 80       	push   $0x80108e73
801038a1:	e8 19 cb ff ff       	call   801003bf <cprintf>
801038a6:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038a9:	e8 2a 36 00 00       	call   80106ed8 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038b4:	05 a8 00 00 00       	add    $0xa8,%eax
801038b9:	83 ec 08             	sub    $0x8,%esp
801038bc:	6a 01                	push   $0x1
801038be:	50                   	push   %eax
801038bf:	e8 d3 fe ff ff       	call   80103797 <xchg>
801038c4:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801038c7:	e8 ce 13 00 00       	call   80104c9a <scheduler>

801038cc <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038cc:	55                   	push   %ebp
801038cd:	89 e5                	mov    %esp,%ebp
801038cf:	53                   	push   %ebx
801038d0:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038d3:	68 00 70 00 00       	push   $0x7000
801038d8:	e8 ad fe ff ff       	call   8010378a <p2v>
801038dd:	83 c4 04             	add    $0x4,%esp
801038e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038e3:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038e8:	83 ec 04             	sub    $0x4,%esp
801038eb:	50                   	push   %eax
801038ec:	68 2c c5 10 80       	push   $0x8010c52c
801038f1:	ff 75 f0             	pushl  -0x10(%ebp)
801038f4:	e8 f6 1d 00 00       	call   801056ef <memmove>
801038f9:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801038fc:	c7 45 f4 40 34 11 80 	movl   $0x80113440,-0xc(%ebp)
80103903:	e9 8f 00 00 00       	jmp    80103997 <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
80103908:	e8 e5 f5 ff ff       	call   80102ef2 <cpunum>
8010390d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103913:	05 40 34 11 80       	add    $0x80113440,%eax
80103918:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010391b:	75 02                	jne    8010391f <startothers+0x53>
      continue;
8010391d:	eb 71                	jmp    80103990 <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010391f:	e8 6d f2 ff ff       	call   80102b91 <kalloc>
80103924:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103927:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010392a:	83 e8 04             	sub    $0x4,%eax
8010392d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103930:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103936:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010393b:	83 e8 08             	sub    $0x8,%eax
8010393e:	c7 00 6c 38 10 80    	movl   $0x8010386c,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103944:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103947:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 00 b0 10 80       	push   $0x8010b000
80103952:	e8 26 fe ff ff       	call   8010377d <v2p>
80103957:	83 c4 10             	add    $0x10,%esp
8010395a:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010395c:	83 ec 0c             	sub    $0xc,%esp
8010395f:	ff 75 f0             	pushl  -0x10(%ebp)
80103962:	e8 16 fe ff ff       	call   8010377d <v2p>
80103967:	83 c4 10             	add    $0x10,%esp
8010396a:	89 c2                	mov    %eax,%edx
8010396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010396f:	0f b6 00             	movzbl (%eax),%eax
80103972:	0f b6 c0             	movzbl %al,%eax
80103975:	83 ec 08             	sub    $0x8,%esp
80103978:	52                   	push   %edx
80103979:	50                   	push   %eax
8010397a:	e8 eb f5 ff ff       	call   80102f6a <lapicstartap>
8010397f:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103982:	90                   	nop
80103983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103986:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010398c:	85 c0                	test   %eax,%eax
8010398e:	74 f3                	je     80103983 <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103990:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103997:	a1 20 3a 11 80       	mov    0x80113a20,%eax
8010399c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039a2:	05 40 34 11 80       	add    $0x80113440,%eax
801039a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039aa:	0f 87 58 ff ff ff    	ja     80103908 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b3:	c9                   	leave  
801039b4:	c3                   	ret    

801039b5 <p2v>:
801039b5:	55                   	push   %ebp
801039b6:	89 e5                	mov    %esp,%ebp
801039b8:	8b 45 08             	mov    0x8(%ebp),%eax
801039bb:	05 00 00 00 80       	add    $0x80000000,%eax
801039c0:	5d                   	pop    %ebp
801039c1:	c3                   	ret    

801039c2 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039c2:	55                   	push   %ebp
801039c3:	89 e5                	mov    %esp,%ebp
801039c5:	83 ec 14             	sub    $0x14,%esp
801039c8:	8b 45 08             	mov    0x8(%ebp),%eax
801039cb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039d3:	89 c2                	mov    %eax,%edx
801039d5:	ec                   	in     (%dx),%al
801039d6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039d9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801039dd:	c9                   	leave  
801039de:	c3                   	ret    

801039df <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039df:	55                   	push   %ebp
801039e0:	89 e5                	mov    %esp,%ebp
801039e2:	83 ec 08             	sub    $0x8,%esp
801039e5:	8b 55 08             	mov    0x8(%ebp),%edx
801039e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801039eb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039ef:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039f2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039f6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801039fa:	ee                   	out    %al,(%dx)
}
801039fb:	c9                   	leave  
801039fc:	c3                   	ret    

801039fd <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801039fd:	55                   	push   %ebp
801039fe:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a00:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103a05:	89 c2                	mov    %eax,%edx
80103a07:	b8 40 34 11 80       	mov    $0x80113440,%eax
80103a0c:	29 c2                	sub    %eax,%edx
80103a0e:	89 d0                	mov    %edx,%eax
80103a10:	c1 f8 02             	sar    $0x2,%eax
80103a13:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a19:	5d                   	pop    %ebp
80103a1a:	c3                   	ret    

80103a1b <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a1b:	55                   	push   %ebp
80103a1c:	89 e5                	mov    %esp,%ebp
80103a1e:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a2f:	eb 15                	jmp    80103a46 <sum+0x2b>
    sum += addr[i];
80103a31:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a34:	8b 45 08             	mov    0x8(%ebp),%eax
80103a37:	01 d0                	add    %edx,%eax
80103a39:	0f b6 00             	movzbl (%eax),%eax
80103a3c:	0f b6 c0             	movzbl %al,%eax
80103a3f:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a49:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a4c:	7c e3                	jl     80103a31 <sum+0x16>
    sum += addr[i];
  return sum;
80103a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    

80103a53 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a53:	55                   	push   %ebp
80103a54:	89 e5                	mov    %esp,%ebp
80103a56:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a59:	ff 75 08             	pushl  0x8(%ebp)
80103a5c:	e8 54 ff ff ff       	call   801039b5 <p2v>
80103a61:	83 c4 04             	add    $0x4,%esp
80103a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a67:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a6d:	01 d0                	add    %edx,%eax
80103a6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a78:	eb 36                	jmp    80103ab0 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a7a:	83 ec 04             	sub    $0x4,%esp
80103a7d:	6a 04                	push   $0x4
80103a7f:	68 84 8e 10 80       	push   $0x80108e84
80103a84:	ff 75 f4             	pushl  -0xc(%ebp)
80103a87:	e8 0b 1c 00 00       	call   80105697 <memcmp>
80103a8c:	83 c4 10             	add    $0x10,%esp
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	75 19                	jne    80103aac <mpsearch1+0x59>
80103a93:	83 ec 08             	sub    $0x8,%esp
80103a96:	6a 10                	push   $0x10
80103a98:	ff 75 f4             	pushl  -0xc(%ebp)
80103a9b:	e8 7b ff ff ff       	call   80103a1b <sum>
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	84 c0                	test   %al,%al
80103aa5:	75 05                	jne    80103aac <mpsearch1+0x59>
      return (struct mp*)p;
80103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aaa:	eb 11                	jmp    80103abd <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103aac:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ab6:	72 c2                	jb     80103a7a <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103abd:	c9                   	leave  
80103abe:	c3                   	ret    

80103abf <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103abf:	55                   	push   %ebp
80103ac0:	89 e5                	mov    %esp,%ebp
80103ac2:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ac5:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103acf:	83 c0 0f             	add    $0xf,%eax
80103ad2:	0f b6 00             	movzbl (%eax),%eax
80103ad5:	0f b6 c0             	movzbl %al,%eax
80103ad8:	c1 e0 08             	shl    $0x8,%eax
80103adb:	89 c2                	mov    %eax,%edx
80103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae0:	83 c0 0e             	add    $0xe,%eax
80103ae3:	0f b6 00             	movzbl (%eax),%eax
80103ae6:	0f b6 c0             	movzbl %al,%eax
80103ae9:	09 d0                	or     %edx,%eax
80103aeb:	c1 e0 04             	shl    $0x4,%eax
80103aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103af1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103af5:	74 21                	je     80103b18 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103af7:	83 ec 08             	sub    $0x8,%esp
80103afa:	68 00 04 00 00       	push   $0x400
80103aff:	ff 75 f0             	pushl  -0x10(%ebp)
80103b02:	e8 4c ff ff ff       	call   80103a53 <mpsearch1>
80103b07:	83 c4 10             	add    $0x10,%esp
80103b0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b11:	74 51                	je     80103b64 <mpsearch+0xa5>
      return mp;
80103b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b16:	eb 61                	jmp    80103b79 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1b:	83 c0 14             	add    $0x14,%eax
80103b1e:	0f b6 00             	movzbl (%eax),%eax
80103b21:	0f b6 c0             	movzbl %al,%eax
80103b24:	c1 e0 08             	shl    $0x8,%eax
80103b27:	89 c2                	mov    %eax,%edx
80103b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2c:	83 c0 13             	add    $0x13,%eax
80103b2f:	0f b6 00             	movzbl (%eax),%eax
80103b32:	0f b6 c0             	movzbl %al,%eax
80103b35:	09 d0                	or     %edx,%eax
80103b37:	c1 e0 0a             	shl    $0xa,%eax
80103b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b40:	2d 00 04 00 00       	sub    $0x400,%eax
80103b45:	83 ec 08             	sub    $0x8,%esp
80103b48:	68 00 04 00 00       	push   $0x400
80103b4d:	50                   	push   %eax
80103b4e:	e8 00 ff ff ff       	call   80103a53 <mpsearch1>
80103b53:	83 c4 10             	add    $0x10,%esp
80103b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b5d:	74 05                	je     80103b64 <mpsearch+0xa5>
      return mp;
80103b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b62:	eb 15                	jmp    80103b79 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b64:	83 ec 08             	sub    $0x8,%esp
80103b67:	68 00 00 01 00       	push   $0x10000
80103b6c:	68 00 00 0f 00       	push   $0xf0000
80103b71:	e8 dd fe ff ff       	call   80103a53 <mpsearch1>
80103b76:	83 c4 10             	add    $0x10,%esp
}
80103b79:	c9                   	leave  
80103b7a:	c3                   	ret    

80103b7b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b7b:	55                   	push   %ebp
80103b7c:	89 e5                	mov    %esp,%ebp
80103b7e:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b81:	e8 39 ff ff ff       	call   80103abf <mpsearch>
80103b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b8d:	74 0a                	je     80103b99 <mpconfig+0x1e>
80103b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b92:	8b 40 04             	mov    0x4(%eax),%eax
80103b95:	85 c0                	test   %eax,%eax
80103b97:	75 0a                	jne    80103ba3 <mpconfig+0x28>
    return 0;
80103b99:	b8 00 00 00 00       	mov    $0x0,%eax
80103b9e:	e9 81 00 00 00       	jmp    80103c24 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba6:	8b 40 04             	mov    0x4(%eax),%eax
80103ba9:	83 ec 0c             	sub    $0xc,%esp
80103bac:	50                   	push   %eax
80103bad:	e8 03 fe ff ff       	call   801039b5 <p2v>
80103bb2:	83 c4 10             	add    $0x10,%esp
80103bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bb8:	83 ec 04             	sub    $0x4,%esp
80103bbb:	6a 04                	push   $0x4
80103bbd:	68 89 8e 10 80       	push   $0x80108e89
80103bc2:	ff 75 f0             	pushl  -0x10(%ebp)
80103bc5:	e8 cd 1a 00 00       	call   80105697 <memcmp>
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	85 c0                	test   %eax,%eax
80103bcf:	74 07                	je     80103bd8 <mpconfig+0x5d>
    return 0;
80103bd1:	b8 00 00 00 00       	mov    $0x0,%eax
80103bd6:	eb 4c                	jmp    80103c24 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bdb:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bdf:	3c 01                	cmp    $0x1,%al
80103be1:	74 12                	je     80103bf5 <mpconfig+0x7a>
80103be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be6:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bea:	3c 04                	cmp    $0x4,%al
80103bec:	74 07                	je     80103bf5 <mpconfig+0x7a>
    return 0;
80103bee:	b8 00 00 00 00       	mov    $0x0,%eax
80103bf3:	eb 2f                	jmp    80103c24 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf8:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bfc:	0f b7 c0             	movzwl %ax,%eax
80103bff:	83 ec 08             	sub    $0x8,%esp
80103c02:	50                   	push   %eax
80103c03:	ff 75 f0             	pushl  -0x10(%ebp)
80103c06:	e8 10 fe ff ff       	call   80103a1b <sum>
80103c0b:	83 c4 10             	add    $0x10,%esp
80103c0e:	84 c0                	test   %al,%al
80103c10:	74 07                	je     80103c19 <mpconfig+0x9e>
    return 0;
80103c12:	b8 00 00 00 00       	mov    $0x0,%eax
80103c17:	eb 0b                	jmp    80103c24 <mpconfig+0xa9>
  *pmp = mp;
80103c19:	8b 45 08             	mov    0x8(%ebp),%eax
80103c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c1f:	89 10                	mov    %edx,(%eax)
  return conf;
80103c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c24:	c9                   	leave  
80103c25:	c3                   	ret    

80103c26 <mpinit>:

void
mpinit(void)
{
80103c26:	55                   	push   %ebp
80103c27:	89 e5                	mov    %esp,%ebp
80103c29:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c2c:	c7 05 64 c6 10 80 40 	movl   $0x80113440,0x8010c664
80103c33:	34 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c36:	83 ec 0c             	sub    $0xc,%esp
80103c39:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c3c:	50                   	push   %eax
80103c3d:	e8 39 ff ff ff       	call   80103b7b <mpconfig>
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c4c:	75 05                	jne    80103c53 <mpinit+0x2d>
    return;
80103c4e:	e9 94 01 00 00       	jmp    80103de7 <mpinit+0x1c1>
  ismp = 1;
80103c53:	c7 05 04 34 11 80 01 	movl   $0x1,0x80113404
80103c5a:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c60:	8b 40 24             	mov    0x24(%eax),%eax
80103c63:	a3 dc 32 11 80       	mov    %eax,0x801132dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6b:	83 c0 2c             	add    $0x2c,%eax
80103c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c74:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c78:	0f b7 d0             	movzwl %ax,%edx
80103c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c7e:	01 d0                	add    %edx,%eax
80103c80:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c83:	e9 f2 00 00 00       	jmp    80103d7a <mpinit+0x154>
    switch(*p){
80103c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8b:	0f b6 00             	movzbl (%eax),%eax
80103c8e:	0f b6 c0             	movzbl %al,%eax
80103c91:	83 f8 04             	cmp    $0x4,%eax
80103c94:	0f 87 bc 00 00 00    	ja     80103d56 <mpinit+0x130>
80103c9a:	8b 04 85 cc 8e 10 80 	mov    -0x7fef7134(,%eax,4),%eax
80103ca1:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cac:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cb0:	0f b6 d0             	movzbl %al,%edx
80103cb3:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103cb8:	39 c2                	cmp    %eax,%edx
80103cba:	74 2b                	je     80103ce7 <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cbf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cc3:	0f b6 d0             	movzbl %al,%edx
80103cc6:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103ccb:	83 ec 04             	sub    $0x4,%esp
80103cce:	52                   	push   %edx
80103ccf:	50                   	push   %eax
80103cd0:	68 8e 8e 10 80       	push   $0x80108e8e
80103cd5:	e8 e5 c6 ff ff       	call   801003bf <cprintf>
80103cda:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103cdd:	c7 05 04 34 11 80 00 	movl   $0x0,0x80113404
80103ce4:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cea:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103cee:	0f b6 c0             	movzbl %al,%eax
80103cf1:	83 e0 02             	and    $0x2,%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 15                	je     80103d0d <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103cf8:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103cfd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d03:	05 40 34 11 80       	add    $0x80113440,%eax
80103d08:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103d0d:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103d12:	8b 15 20 3a 11 80    	mov    0x80113a20,%edx
80103d18:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d1e:	05 40 34 11 80       	add    $0x80113440,%eax
80103d23:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d25:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103d2a:	83 c0 01             	add    $0x1,%eax
80103d2d:	a3 20 3a 11 80       	mov    %eax,0x80113a20
      p += sizeof(struct mpproc);
80103d32:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d36:	eb 42                	jmp    80103d7a <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d41:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d45:	a2 00 34 11 80       	mov    %al,0x80113400
      p += sizeof(struct mpioapic);
80103d4a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d4e:	eb 2a                	jmp    80103d7a <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d50:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d54:	eb 24                	jmp    80103d7a <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d59:	0f b6 00             	movzbl (%eax),%eax
80103d5c:	0f b6 c0             	movzbl %al,%eax
80103d5f:	83 ec 08             	sub    $0x8,%esp
80103d62:	50                   	push   %eax
80103d63:	68 ac 8e 10 80       	push   $0x80108eac
80103d68:	e8 52 c6 ff ff       	call   801003bf <cprintf>
80103d6d:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103d70:	c7 05 04 34 11 80 00 	movl   $0x0,0x80113404
80103d77:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d80:	0f 82 02 ff ff ff    	jb     80103c88 <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d86:	a1 04 34 11 80       	mov    0x80113404,%eax
80103d8b:	85 c0                	test   %eax,%eax
80103d8d:	75 1d                	jne    80103dac <mpinit+0x186>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d8f:	c7 05 20 3a 11 80 01 	movl   $0x1,0x80113a20
80103d96:	00 00 00 
    lapic = 0;
80103d99:	c7 05 dc 32 11 80 00 	movl   $0x0,0x801132dc
80103da0:	00 00 00 
    ioapicid = 0;
80103da3:	c6 05 00 34 11 80 00 	movb   $0x0,0x80113400
    return;
80103daa:	eb 3b                	jmp    80103de7 <mpinit+0x1c1>
  }

  if(mp->imcrp){
80103dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103daf:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103db3:	84 c0                	test   %al,%al
80103db5:	74 30                	je     80103de7 <mpinit+0x1c1>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103db7:	83 ec 08             	sub    $0x8,%esp
80103dba:	6a 70                	push   $0x70
80103dbc:	6a 22                	push   $0x22
80103dbe:	e8 1c fc ff ff       	call   801039df <outb>
80103dc3:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	6a 23                	push   $0x23
80103dcb:	e8 f2 fb ff ff       	call   801039c2 <inb>
80103dd0:	83 c4 10             	add    $0x10,%esp
80103dd3:	83 c8 01             	or     $0x1,%eax
80103dd6:	0f b6 c0             	movzbl %al,%eax
80103dd9:	83 ec 08             	sub    $0x8,%esp
80103ddc:	50                   	push   %eax
80103ddd:	6a 23                	push   $0x23
80103ddf:	e8 fb fb ff ff       	call   801039df <outb>
80103de4:	83 c4 10             	add    $0x10,%esp
  }
}
80103de7:	c9                   	leave  
80103de8:	c3                   	ret    

80103de9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103de9:	55                   	push   %ebp
80103dea:	89 e5                	mov    %esp,%ebp
80103dec:	83 ec 08             	sub    $0x8,%esp
80103def:	8b 55 08             	mov    0x8(%ebp),%edx
80103df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103df9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dfc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e00:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e04:	ee                   	out    %al,(%dx)
}
80103e05:	c9                   	leave  
80103e06:	c3                   	ret    

80103e07 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e07:	55                   	push   %ebp
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	83 ec 04             	sub    $0x4,%esp
80103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e10:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e14:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e18:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e1e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e22:	0f b6 c0             	movzbl %al,%eax
80103e25:	50                   	push   %eax
80103e26:	6a 21                	push   $0x21
80103e28:	e8 bc ff ff ff       	call   80103de9 <outb>
80103e2d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e30:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e34:	66 c1 e8 08          	shr    $0x8,%ax
80103e38:	0f b6 c0             	movzbl %al,%eax
80103e3b:	50                   	push   %eax
80103e3c:	68 a1 00 00 00       	push   $0xa1
80103e41:	e8 a3 ff ff ff       	call   80103de9 <outb>
80103e46:	83 c4 08             	add    $0x8,%esp
}
80103e49:	c9                   	leave  
80103e4a:	c3                   	ret    

80103e4b <picenable>:

void
picenable(int irq)
{
80103e4b:	55                   	push   %ebp
80103e4c:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e51:	ba 01 00 00 00       	mov    $0x1,%edx
80103e56:	89 c1                	mov    %eax,%ecx
80103e58:	d3 e2                	shl    %cl,%edx
80103e5a:	89 d0                	mov    %edx,%eax
80103e5c:	f7 d0                	not    %eax
80103e5e:	89 c2                	mov    %eax,%edx
80103e60:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e67:	21 d0                	and    %edx,%eax
80103e69:	0f b7 c0             	movzwl %ax,%eax
80103e6c:	50                   	push   %eax
80103e6d:	e8 95 ff ff ff       	call   80103e07 <picsetmask>
80103e72:	83 c4 04             	add    $0x4,%esp
}
80103e75:	c9                   	leave  
80103e76:	c3                   	ret    

80103e77 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e77:	55                   	push   %ebp
80103e78:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e7a:	68 ff 00 00 00       	push   $0xff
80103e7f:	6a 21                	push   $0x21
80103e81:	e8 63 ff ff ff       	call   80103de9 <outb>
80103e86:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103e89:	68 ff 00 00 00       	push   $0xff
80103e8e:	68 a1 00 00 00       	push   $0xa1
80103e93:	e8 51 ff ff ff       	call   80103de9 <outb>
80103e98:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e9b:	6a 11                	push   $0x11
80103e9d:	6a 20                	push   $0x20
80103e9f:	e8 45 ff ff ff       	call   80103de9 <outb>
80103ea4:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ea7:	6a 20                	push   $0x20
80103ea9:	6a 21                	push   $0x21
80103eab:	e8 39 ff ff ff       	call   80103de9 <outb>
80103eb0:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103eb3:	6a 04                	push   $0x4
80103eb5:	6a 21                	push   $0x21
80103eb7:	e8 2d ff ff ff       	call   80103de9 <outb>
80103ebc:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ebf:	6a 03                	push   $0x3
80103ec1:	6a 21                	push   $0x21
80103ec3:	e8 21 ff ff ff       	call   80103de9 <outb>
80103ec8:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ecb:	6a 11                	push   $0x11
80103ecd:	68 a0 00 00 00       	push   $0xa0
80103ed2:	e8 12 ff ff ff       	call   80103de9 <outb>
80103ed7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103eda:	6a 28                	push   $0x28
80103edc:	68 a1 00 00 00       	push   $0xa1
80103ee1:	e8 03 ff ff ff       	call   80103de9 <outb>
80103ee6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ee9:	6a 02                	push   $0x2
80103eeb:	68 a1 00 00 00       	push   $0xa1
80103ef0:	e8 f4 fe ff ff       	call   80103de9 <outb>
80103ef5:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ef8:	6a 03                	push   $0x3
80103efa:	68 a1 00 00 00       	push   $0xa1
80103eff:	e8 e5 fe ff ff       	call   80103de9 <outb>
80103f04:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f07:	6a 68                	push   $0x68
80103f09:	6a 20                	push   $0x20
80103f0b:	e8 d9 fe ff ff       	call   80103de9 <outb>
80103f10:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f13:	6a 0a                	push   $0xa
80103f15:	6a 20                	push   $0x20
80103f17:	e8 cd fe ff ff       	call   80103de9 <outb>
80103f1c:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f1f:	6a 68                	push   $0x68
80103f21:	68 a0 00 00 00       	push   $0xa0
80103f26:	e8 be fe ff ff       	call   80103de9 <outb>
80103f2b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f2e:	6a 0a                	push   $0xa
80103f30:	68 a0 00 00 00       	push   $0xa0
80103f35:	e8 af fe ff ff       	call   80103de9 <outb>
80103f3a:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103f3d:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f44:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f48:	74 13                	je     80103f5d <picinit+0xe6>
    picsetmask(irqmask);
80103f4a:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f51:	0f b7 c0             	movzwl %ax,%eax
80103f54:	50                   	push   %eax
80103f55:	e8 ad fe ff ff       	call   80103e07 <picsetmask>
80103f5a:	83 c4 04             	add    $0x4,%esp
}
80103f5d:	c9                   	leave  
80103f5e:	c3                   	ret    

80103f5f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f5f:	55                   	push   %ebp
80103f60:	89 e5                	mov    %esp,%ebp
80103f62:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103f65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f78:	8b 10                	mov    (%eax),%edx
80103f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7d:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f7f:	e8 d7 cf ff ff       	call   80100f5b <filealloc>
80103f84:	89 c2                	mov    %eax,%edx
80103f86:	8b 45 08             	mov    0x8(%ebp),%eax
80103f89:	89 10                	mov    %edx,(%eax)
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	8b 00                	mov    (%eax),%eax
80103f90:	85 c0                	test   %eax,%eax
80103f92:	0f 84 cb 00 00 00    	je     80104063 <pipealloc+0x104>
80103f98:	e8 be cf ff ff       	call   80100f5b <filealloc>
80103f9d:	89 c2                	mov    %eax,%edx
80103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa2:	89 10                	mov    %edx,(%eax)
80103fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa7:	8b 00                	mov    (%eax),%eax
80103fa9:	85 c0                	test   %eax,%eax
80103fab:	0f 84 b2 00 00 00    	je     80104063 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fb1:	e8 db eb ff ff       	call   80102b91 <kalloc>
80103fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fbd:	75 05                	jne    80103fc4 <pipealloc+0x65>
    goto bad;
80103fbf:	e9 9f 00 00 00       	jmp    80104063 <pipealloc+0x104>
  p->readopen = 1;
80103fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fce:	00 00 00 
  p->writeopen = 1;
80103fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fdb:	00 00 00 
  p->nwrite = 0;
80103fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fe8:	00 00 00 
  p->nread = 0;
80103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fee:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ff5:	00 00 00 
  initlock(&p->lock, "pipe");
80103ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffb:	83 ec 08             	sub    $0x8,%esp
80103ffe:	68 e0 8e 10 80       	push   $0x80108ee0
80104003:	50                   	push   %eax
80104004:	e8 aa 13 00 00       	call   801053b3 <initlock>
80104009:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010400c:	8b 45 08             	mov    0x8(%ebp),%eax
8010400f:	8b 00                	mov    (%eax),%eax
80104011:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104017:	8b 45 08             	mov    0x8(%ebp),%eax
8010401a:	8b 00                	mov    (%eax),%eax
8010401c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104020:	8b 45 08             	mov    0x8(%ebp),%eax
80104023:	8b 00                	mov    (%eax),%eax
80104025:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104029:	8b 45 08             	mov    0x8(%ebp),%eax
8010402c:	8b 00                	mov    (%eax),%eax
8010402e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104031:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104034:	8b 45 0c             	mov    0xc(%ebp),%eax
80104037:	8b 00                	mov    (%eax),%eax
80104039:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010403f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104042:	8b 00                	mov    (%eax),%eax
80104044:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104048:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404b:	8b 00                	mov    (%eax),%eax
8010404d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104051:	8b 45 0c             	mov    0xc(%ebp),%eax
80104054:	8b 00                	mov    (%eax),%eax
80104056:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104059:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010405c:	b8 00 00 00 00       	mov    $0x0,%eax
80104061:	eb 4d                	jmp    801040b0 <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
80104063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104067:	74 0e                	je     80104077 <pipealloc+0x118>
    kfree((char*)p);
80104069:	83 ec 0c             	sub    $0xc,%esp
8010406c:	ff 75 f4             	pushl  -0xc(%ebp)
8010406f:	e8 81 ea ff ff       	call   80102af5 <kfree>
80104074:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104077:	8b 45 08             	mov    0x8(%ebp),%eax
8010407a:	8b 00                	mov    (%eax),%eax
8010407c:	85 c0                	test   %eax,%eax
8010407e:	74 11                	je     80104091 <pipealloc+0x132>
    fileclose(*f0);
80104080:	8b 45 08             	mov    0x8(%ebp),%eax
80104083:	8b 00                	mov    (%eax),%eax
80104085:	83 ec 0c             	sub    $0xc,%esp
80104088:	50                   	push   %eax
80104089:	e8 8a cf ff ff       	call   80101018 <fileclose>
8010408e:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104091:	8b 45 0c             	mov    0xc(%ebp),%eax
80104094:	8b 00                	mov    (%eax),%eax
80104096:	85 c0                	test   %eax,%eax
80104098:	74 11                	je     801040ab <pipealloc+0x14c>
    fileclose(*f1);
8010409a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409d:	8b 00                	mov    (%eax),%eax
8010409f:	83 ec 0c             	sub    $0xc,%esp
801040a2:	50                   	push   %eax
801040a3:	e8 70 cf ff ff       	call   80101018 <fileclose>
801040a8:	83 c4 10             	add    $0x10,%esp
  return -1;
801040ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040b0:	c9                   	leave  
801040b1:	c3                   	ret    

801040b2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040b2:	55                   	push   %ebp
801040b3:	89 e5                	mov    %esp,%ebp
801040b5:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801040b8:	8b 45 08             	mov    0x8(%ebp),%eax
801040bb:	83 ec 0c             	sub    $0xc,%esp
801040be:	50                   	push   %eax
801040bf:	e8 10 13 00 00       	call   801053d4 <acquire>
801040c4:	83 c4 10             	add    $0x10,%esp
  if(writable){
801040c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040cb:	74 23                	je     801040f0 <pipeclose+0x3e>
    p->writeopen = 0;
801040cd:	8b 45 08             	mov    0x8(%ebp),%eax
801040d0:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801040d7:	00 00 00 
    wakeup(&p->nread);
801040da:	8b 45 08             	mov    0x8(%ebp),%eax
801040dd:	05 34 02 00 00       	add    $0x234,%eax
801040e2:	83 ec 0c             	sub    $0xc,%esp
801040e5:	50                   	push   %eax
801040e6:	e8 18 0f 00 00       	call   80105003 <wakeup>
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	eb 21                	jmp    80104111 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801040f0:	8b 45 08             	mov    0x8(%ebp),%eax
801040f3:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040fa:	00 00 00 
    wakeup(&p->nwrite);
801040fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104100:	05 38 02 00 00       	add    $0x238,%eax
80104105:	83 ec 0c             	sub    $0xc,%esp
80104108:	50                   	push   %eax
80104109:	e8 f5 0e 00 00       	call   80105003 <wakeup>
8010410e:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104111:	8b 45 08             	mov    0x8(%ebp),%eax
80104114:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010411a:	85 c0                	test   %eax,%eax
8010411c:	75 2c                	jne    8010414a <pipeclose+0x98>
8010411e:	8b 45 08             	mov    0x8(%ebp),%eax
80104121:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104127:	85 c0                	test   %eax,%eax
80104129:	75 1f                	jne    8010414a <pipeclose+0x98>
    release(&p->lock);
8010412b:	8b 45 08             	mov    0x8(%ebp),%eax
8010412e:	83 ec 0c             	sub    $0xc,%esp
80104131:	50                   	push   %eax
80104132:	e8 03 13 00 00       	call   8010543a <release>
80104137:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	ff 75 08             	pushl  0x8(%ebp)
80104140:	e8 b0 e9 ff ff       	call   80102af5 <kfree>
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	eb 0f                	jmp    80104159 <pipeclose+0xa7>
  } else
    release(&p->lock);
8010414a:	8b 45 08             	mov    0x8(%ebp),%eax
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	50                   	push   %eax
80104151:	e8 e4 12 00 00       	call   8010543a <release>
80104156:	83 c4 10             	add    $0x10,%esp
}
80104159:	c9                   	leave  
8010415a:	c3                   	ret    

8010415b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010415b:	55                   	push   %ebp
8010415c:	89 e5                	mov    %esp,%ebp
8010415e:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104161:	8b 45 08             	mov    0x8(%ebp),%eax
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	50                   	push   %eax
80104168:	e8 67 12 00 00       	call   801053d4 <acquire>
8010416d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104177:	e9 af 00 00 00       	jmp    8010422b <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010417c:	eb 60                	jmp    801041de <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
8010417e:	8b 45 08             	mov    0x8(%ebp),%eax
80104181:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104187:	85 c0                	test   %eax,%eax
80104189:	74 0d                	je     80104198 <pipewrite+0x3d>
8010418b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104191:	8b 40 24             	mov    0x24(%eax),%eax
80104194:	85 c0                	test   %eax,%eax
80104196:	74 19                	je     801041b1 <pipewrite+0x56>
        release(&p->lock);
80104198:	8b 45 08             	mov    0x8(%ebp),%eax
8010419b:	83 ec 0c             	sub    $0xc,%esp
8010419e:	50                   	push   %eax
8010419f:	e8 96 12 00 00       	call   8010543a <release>
801041a4:	83 c4 10             	add    $0x10,%esp
        return -1;
801041a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041ac:	e9 ac 00 00 00       	jmp    8010425d <pipewrite+0x102>
      }
      wakeup(&p->nread);
801041b1:	8b 45 08             	mov    0x8(%ebp),%eax
801041b4:	05 34 02 00 00       	add    $0x234,%eax
801041b9:	83 ec 0c             	sub    $0xc,%esp
801041bc:	50                   	push   %eax
801041bd:	e8 41 0e 00 00       	call   80105003 <wakeup>
801041c2:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041c5:	8b 45 08             	mov    0x8(%ebp),%eax
801041c8:	8b 55 08             	mov    0x8(%ebp),%edx
801041cb:	81 c2 38 02 00 00    	add    $0x238,%edx
801041d1:	83 ec 08             	sub    $0x8,%esp
801041d4:	50                   	push   %eax
801041d5:	52                   	push   %edx
801041d6:	e8 05 0d 00 00       	call   80104ee0 <sleep>
801041db:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041de:	8b 45 08             	mov    0x8(%ebp),%eax
801041e1:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801041e7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ea:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041f0:	05 00 02 00 00       	add    $0x200,%eax
801041f5:	39 c2                	cmp    %eax,%edx
801041f7:	74 85                	je     8010417e <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041f9:	8b 45 08             	mov    0x8(%ebp),%eax
801041fc:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104202:	8d 48 01             	lea    0x1(%eax),%ecx
80104205:	8b 55 08             	mov    0x8(%ebp),%edx
80104208:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010420e:	25 ff 01 00 00       	and    $0x1ff,%eax
80104213:	89 c1                	mov    %eax,%ecx
80104215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421b:	01 d0                	add    %edx,%eax
8010421d:	0f b6 10             	movzbl (%eax),%edx
80104220:	8b 45 08             	mov    0x8(%ebp),%eax
80104223:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104227:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422e:	3b 45 10             	cmp    0x10(%ebp),%eax
80104231:	0f 8c 45 ff ff ff    	jl     8010417c <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104237:	8b 45 08             	mov    0x8(%ebp),%eax
8010423a:	05 34 02 00 00       	add    $0x234,%eax
8010423f:	83 ec 0c             	sub    $0xc,%esp
80104242:	50                   	push   %eax
80104243:	e8 bb 0d 00 00       	call   80105003 <wakeup>
80104248:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010424b:	8b 45 08             	mov    0x8(%ebp),%eax
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	50                   	push   %eax
80104252:	e8 e3 11 00 00       	call   8010543a <release>
80104257:	83 c4 10             	add    $0x10,%esp
  return n;
8010425a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010425d:	c9                   	leave  
8010425e:	c3                   	ret    

8010425f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010425f:	55                   	push   %ebp
80104260:	89 e5                	mov    %esp,%ebp
80104262:	53                   	push   %ebx
80104263:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104266:	8b 45 08             	mov    0x8(%ebp),%eax
80104269:	83 ec 0c             	sub    $0xc,%esp
8010426c:	50                   	push   %eax
8010426d:	e8 62 11 00 00       	call   801053d4 <acquire>
80104272:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104275:	eb 3f                	jmp    801042b6 <piperead+0x57>
    if(proc->killed){
80104277:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010427d:	8b 40 24             	mov    0x24(%eax),%eax
80104280:	85 c0                	test   %eax,%eax
80104282:	74 19                	je     8010429d <piperead+0x3e>
      release(&p->lock);
80104284:	8b 45 08             	mov    0x8(%ebp),%eax
80104287:	83 ec 0c             	sub    $0xc,%esp
8010428a:	50                   	push   %eax
8010428b:	e8 aa 11 00 00       	call   8010543a <release>
80104290:	83 c4 10             	add    $0x10,%esp
      return -1;
80104293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104298:	e9 be 00 00 00       	jmp    8010435b <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010429d:	8b 45 08             	mov    0x8(%ebp),%eax
801042a0:	8b 55 08             	mov    0x8(%ebp),%edx
801042a3:	81 c2 34 02 00 00    	add    $0x234,%edx
801042a9:	83 ec 08             	sub    $0x8,%esp
801042ac:	50                   	push   %eax
801042ad:	52                   	push   %edx
801042ae:	e8 2d 0c 00 00       	call   80104ee0 <sleep>
801042b3:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042b6:	8b 45 08             	mov    0x8(%ebp),%eax
801042b9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042bf:	8b 45 08             	mov    0x8(%ebp),%eax
801042c2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042c8:	39 c2                	cmp    %eax,%edx
801042ca:	75 0d                	jne    801042d9 <piperead+0x7a>
801042cc:	8b 45 08             	mov    0x8(%ebp),%eax
801042cf:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	75 9e                	jne    80104277 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042e0:	eb 4b                	jmp    8010432d <piperead+0xce>
    if(p->nread == p->nwrite)
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042eb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ee:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042f4:	39 c2                	cmp    %eax,%edx
801042f6:	75 02                	jne    801042fa <piperead+0x9b>
      break;
801042f8:	eb 3b                	jmp    80104335 <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104300:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104303:	8b 45 08             	mov    0x8(%ebp),%eax
80104306:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010430c:	8d 48 01             	lea    0x1(%eax),%ecx
8010430f:	8b 55 08             	mov    0x8(%ebp),%edx
80104312:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104318:	25 ff 01 00 00       	and    $0x1ff,%eax
8010431d:	89 c2                	mov    %eax,%edx
8010431f:	8b 45 08             	mov    0x8(%ebp),%eax
80104322:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104327:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104329:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104330:	3b 45 10             	cmp    0x10(%ebp),%eax
80104333:	7c ad                	jl     801042e2 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104335:	8b 45 08             	mov    0x8(%ebp),%eax
80104338:	05 38 02 00 00       	add    $0x238,%eax
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	50                   	push   %eax
80104341:	e8 bd 0c 00 00       	call   80105003 <wakeup>
80104346:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104349:	8b 45 08             	mov    0x8(%ebp),%eax
8010434c:	83 ec 0c             	sub    $0xc,%esp
8010434f:	50                   	push   %eax
80104350:	e8 e5 10 00 00       	call   8010543a <release>
80104355:	83 c4 10             	add    $0x10,%esp
  return i;
80104358:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010435b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010435e:	c9                   	leave  
8010435f:	c3                   	ret    

80104360 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104366:	9c                   	pushf  
80104367:	58                   	pop    %eax
80104368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010436b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010436e:	c9                   	leave  
8010436f:	c3                   	ret    

80104370 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104373:	fb                   	sti    
}
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    

80104376 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104376:	55                   	push   %ebp
80104377:	89 e5                	mov    %esp,%ebp
80104379:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010437c:	83 ec 08             	sub    $0x8,%esp
8010437f:	68 e5 8e 10 80       	push   $0x80108ee5
80104384:	68 40 3a 11 80       	push   $0x80113a40
80104389:	e8 25 10 00 00       	call   801053b3 <initlock>
8010438e:	83 c4 10             	add    $0x10,%esp
}
80104391:	c9                   	leave  
80104392:	c3                   	ret    

80104393 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104393:	55                   	push   %ebp
80104394:	89 e5                	mov    %esp,%ebp
80104396:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104399:	83 ec 0c             	sub    $0xc,%esp
8010439c:	68 40 3a 11 80       	push   $0x80113a40
801043a1:	e8 2e 10 00 00       	call   801053d4 <acquire>
801043a6:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a9:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
801043b0:	eb 73                	jmp    80104425 <allocproc+0x92>
    if(p->state == UNUSED)
801043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b5:	8b 40 0c             	mov    0xc(%eax),%eax
801043b8:	85 c0                	test   %eax,%eax
801043ba:	75 62                	jne    8010441e <allocproc+0x8b>
      goto found;
801043bc:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801043c7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801043cc:	8d 50 01             	lea    0x1(%eax),%edx
801043cf:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801043d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d8:	89 42 10             	mov    %eax,0x10(%edx)
  p->priority = 0;
801043db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043de:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801043e5:	00 00 00 
  p->next = 0;
801043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043eb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801043f2:	00 00 00 
  release(&ptable.lock);
801043f5:	83 ec 0c             	sub    $0xc,%esp
801043f8:	68 40 3a 11 80       	push   $0x80113a40
801043fd:	e8 38 10 00 00       	call   8010543a <release>
80104402:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104405:	e8 87 e7 ff ff       	call   80102b91 <kalloc>
8010440a:	89 c2                	mov    %eax,%edx
8010440c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440f:	89 50 08             	mov    %edx,0x8(%eax)
80104412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104415:	8b 40 08             	mov    0x8(%eax),%eax
80104418:	85 c0                	test   %eax,%eax
8010441a:	75 3a                	jne    80104456 <allocproc+0xc3>
8010441c:	eb 27                	jmp    80104445 <allocproc+0xb2>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104425:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
8010442c:	72 84                	jb     801043b2 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010442e:	83 ec 0c             	sub    $0xc,%esp
80104431:	68 40 3a 11 80       	push   $0x80113a40
80104436:	e8 ff 0f 00 00       	call   8010543a <release>
8010443b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010443e:	b8 00 00 00 00       	mov    $0x0,%eax
80104443:	eb 6e                	jmp    801044b3 <allocproc+0x120>
  p->next = 0;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104448:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010444f:	b8 00 00 00 00       	mov    $0x0,%eax
80104454:	eb 5d                	jmp    801044b3 <allocproc+0x120>
  }
  sp = p->kstack + KSTACKSIZE;
80104456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104459:	8b 40 08             	mov    0x8(%eax),%eax
8010445c:	05 00 10 00 00       	add    $0x1000,%eax
80104461:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104464:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010446e:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104471:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104475:	ba 1e 6d 10 80       	mov    $0x80106d1e,%edx
8010447a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010447d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010447f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104489:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010448c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104492:	83 ec 04             	sub    $0x4,%esp
80104495:	6a 14                	push   $0x14
80104497:	6a 00                	push   $0x0
80104499:	50                   	push   %eax
8010449a:	e8 91 11 00 00       	call   80105630 <memset>
8010449f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a5:	8b 40 1c             	mov    0x1c(%eax),%eax
801044a8:	ba b0 4e 10 80       	mov    $0x80104eb0,%edx
801044ad:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044b3:	c9                   	leave  
801044b4:	c3                   	ret    

801044b5 <is_empty>:


//reports if the queue is empty
//1 = true
int is_empty(int i){
801044b5:	55                   	push   %ebp
801044b6:	89 e5                	mov    %esp,%ebp
  return (ptable.mlf[i].first == 0);
801044b8:	8b 45 08             	mov    0x8(%ebp),%eax
801044bb:	05 06 05 00 00       	add    $0x506,%eax
801044c0:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801044c7:	85 c0                	test   %eax,%eax
801044c9:	0f 94 c0             	sete   %al
801044cc:	0f b6 c0             	movzbl %al,%eax
}
801044cf:	5d                   	pop    %ebp
801044d0:	c3                   	ret    

801044d1 <enqueue>:

// enqueue in mlf[priority]
void enqueue(struct proc *p,int priority){
801044d1:	55                   	push   %ebp
801044d2:	89 e5                	mov    %esp,%ebp
  if (!is_empty(priority)){
801044d4:	ff 75 0c             	pushl  0xc(%ebp)
801044d7:	e8 d9 ff ff ff       	call   801044b5 <is_empty>
801044dc:	83 c4 04             	add    $0x4,%esp
801044df:	85 c0                	test   %eax,%eax
801044e1:	75 2d                	jne    80104510 <enqueue+0x3f>
    ptable.mlf[priority].last->next = p;
801044e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044e6:	05 06 05 00 00       	add    $0x506,%eax
801044eb:	8b 04 c5 48 3a 11 80 	mov    -0x7feec5b8(,%eax,8),%eax
801044f2:	8b 55 08             	mov    0x8(%ebp),%edx
801044f5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    ptable.mlf[priority].last = p;
801044fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801044fe:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
80104504:	8b 45 08             	mov    0x8(%ebp),%eax
80104507:	89 04 d5 48 3a 11 80 	mov    %eax,-0x7feec5b8(,%edx,8)
8010450e:	eb 26                	jmp    80104536 <enqueue+0x65>
  } else {
    ptable.mlf[priority].first = p;
80104510:	8b 45 0c             	mov    0xc(%ebp),%eax
80104513:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
80104519:	8b 45 08             	mov    0x8(%ebp),%eax
8010451c:	89 04 d5 44 3a 11 80 	mov    %eax,-0x7feec5bc(,%edx,8)
    ptable.mlf[priority].last = p;
80104523:	8b 45 0c             	mov    0xc(%ebp),%eax
80104526:	8d 90 06 05 00 00    	lea    0x506(%eax),%edx
8010452c:	8b 45 08             	mov    0x8(%ebp),%eax
8010452f:	89 04 d5 48 3a 11 80 	mov    %eax,-0x7feec5b8(,%edx,8)
  }
}
80104536:	c9                   	leave  
80104537:	c3                   	ret    

80104538 <dequeue>:

// dequeue in mlf[priority]
struct proc * dequeue(int priority){
80104538:	55                   	push   %ebp
80104539:	89 e5                	mov    %esp,%ebp
8010453b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = 0;
8010453e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  if (!is_empty(priority)){
80104545:	ff 75 08             	pushl  0x8(%ebp)
80104548:	e8 68 ff ff ff       	call   801044b5 <is_empty>
8010454d:	83 c4 04             	add    $0x4,%esp
80104550:	85 c0                	test   %eax,%eax
80104552:	0f 85 9b 00 00 00    	jne    801045f3 <dequeue+0xbb>
    if (ptable.mlf[priority].first == ptable.mlf[priority].last){ 
80104558:	8b 45 08             	mov    0x8(%ebp),%eax
8010455b:	05 06 05 00 00       	add    $0x506,%eax
80104560:	8b 14 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%edx
80104567:	8b 45 08             	mov    0x8(%ebp),%eax
8010456a:	05 06 05 00 00       	add    $0x506,%eax
8010456f:	8b 04 c5 48 3a 11 80 	mov    -0x7feec5b8(,%eax,8),%eax
80104576:	39 c2                	cmp    %eax,%edx
80104578:	75 3d                	jne    801045b7 <dequeue+0x7f>
      p = ptable.mlf[priority].first;
8010457a:	8b 45 08             	mov    0x8(%ebp),%eax
8010457d:	05 06 05 00 00       	add    $0x506,%eax
80104582:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
80104589:	89 45 fc             	mov    %eax,-0x4(%ebp)
      ptable.mlf[priority].first = 0;
8010458c:	8b 45 08             	mov    0x8(%ebp),%eax
8010458f:	05 06 05 00 00       	add    $0x506,%eax
80104594:	c7 04 c5 44 3a 11 80 	movl   $0x0,-0x7feec5bc(,%eax,8)
8010459b:	00 00 00 00 
      ptable.mlf[priority].last = 0;
8010459f:	8b 45 08             	mov    0x8(%ebp),%eax
801045a2:	05 06 05 00 00       	add    $0x506,%eax
801045a7:	c7 04 c5 48 3a 11 80 	movl   $0x0,-0x7feec5b8(,%eax,8)
801045ae:	00 00 00 00 
      return p;
801045b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801045b5:	eb 3f                	jmp    801045f6 <dequeue+0xbe>
    } else {
      p = ptable.mlf[priority].first;
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ba:	05 06 05 00 00       	add    $0x506,%eax
801045bf:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801045c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
      ptable.mlf[priority].first = ptable.mlf[priority].first->next;
801045c9:	8b 45 08             	mov    0x8(%ebp),%eax
801045cc:	05 06 05 00 00       	add    $0x506,%eax
801045d1:	8b 04 c5 44 3a 11 80 	mov    -0x7feec5bc(,%eax,8),%eax
801045d8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801045de:	8b 55 08             	mov    0x8(%ebp),%edx
801045e1:	81 c2 06 05 00 00    	add    $0x506,%edx
801045e7:	89 04 d5 44 3a 11 80 	mov    %eax,-0x7feec5bc(,%edx,8)
      return p;
801045ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801045f1:	eb 03                	jmp    801045f6 <dequeue+0xbe>
    }
  }
  return p;;
801045f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801045f6:	c9                   	leave  
801045f7:	c3                   	ret    

801045f8 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045f8:	55                   	push   %ebp
801045f9:	89 e5                	mov    %esp,%ebp
801045fb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801045fe:	e8 90 fd ff ff       	call   80104393 <allocproc>
80104603:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104609:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
8010460e:	e8 e1 3d 00 00       	call   801083f4 <setupkvm>
80104613:	89 c2                	mov    %eax,%edx
80104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104618:	89 50 04             	mov    %edx,0x4(%eax)
8010461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461e:	8b 40 04             	mov    0x4(%eax),%eax
80104621:	85 c0                	test   %eax,%eax
80104623:	75 0d                	jne    80104632 <userinit+0x3a>
    panic("userinit: out of memory?");
80104625:	83 ec 0c             	sub    $0xc,%esp
80104628:	68 ec 8e 10 80       	push   $0x80108eec
8010462d:	e8 2a bf ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104632:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463a:	8b 40 04             	mov    0x4(%eax),%eax
8010463d:	83 ec 04             	sub    $0x4,%esp
80104640:	52                   	push   %edx
80104641:	68 00 c5 10 80       	push   $0x8010c500
80104646:	50                   	push   %eax
80104647:	e8 ff 3f 00 00       	call   8010864b <inituvm>
8010464c:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104652:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465b:	8b 40 18             	mov    0x18(%eax),%eax
8010465e:	83 ec 04             	sub    $0x4,%esp
80104661:	6a 4c                	push   $0x4c
80104663:	6a 00                	push   $0x0
80104665:	50                   	push   %eax
80104666:	e8 c5 0f 00 00       	call   80105630 <memset>
8010466b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104671:	8b 40 18             	mov    0x18(%eax),%eax
80104674:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467d:	8b 40 18             	mov    0x18(%eax),%eax
80104680:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104689:	8b 40 18             	mov    0x18(%eax),%eax
8010468c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010468f:	8b 52 18             	mov    0x18(%edx),%edx
80104692:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104696:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469d:	8b 40 18             	mov    0x18(%eax),%eax
801046a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046a3:	8b 52 18             	mov    0x18(%edx),%edx
801046a6:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046aa:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b1:	8b 40 18             	mov    0x18(%eax),%eax
801046b4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046be:	8b 40 18             	mov    0x18(%eax),%eax
801046c1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cb:	8b 40 18             	mov    0x18(%eax),%eax
801046ce:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d8:	83 c0 6c             	add    $0x6c,%eax
801046db:	83 ec 04             	sub    $0x4,%esp
801046de:	6a 10                	push   $0x10
801046e0:	68 05 8f 10 80       	push   $0x80108f05
801046e5:	50                   	push   %eax
801046e6:	e8 4a 11 00 00       	call   80105835 <safestrcpy>
801046eb:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	68 0e 8f 10 80       	push   $0x80108f0e
801046f6:	e8 a2 dd ff ff       	call   8010249d <namei>
801046fb:	83 c4 10             	add    $0x10,%esp
801046fe:	89 c2                	mov    %eax,%edx
80104700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104703:	89 50 68             	mov    %edx,0x68(%eax)
  p->quantum = 0;
80104706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104709:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  p->state = RUNNABLE;
80104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104713:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p,p->priority);
8010471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104723:	83 ec 08             	sub    $0x8,%esp
80104726:	50                   	push   %eax
80104727:	ff 75 f4             	pushl  -0xc(%ebp)
8010472a:	e8 a2 fd ff ff       	call   801044d1 <enqueue>
8010472f:	83 c4 10             	add    $0x10,%esp
}
80104732:	c9                   	leave  
80104733:	c3                   	ret    

80104734 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010473a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104740:	8b 00                	mov    (%eax),%eax
80104742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104749:	7e 31                	jle    8010477c <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010474b:	8b 55 08             	mov    0x8(%ebp),%edx
8010474e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104751:	01 c2                	add    %eax,%edx
80104753:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104759:	8b 40 04             	mov    0x4(%eax),%eax
8010475c:	83 ec 04             	sub    $0x4,%esp
8010475f:	52                   	push   %edx
80104760:	ff 75 f4             	pushl  -0xc(%ebp)
80104763:	50                   	push   %eax
80104764:	e8 2e 40 00 00       	call   80108797 <allocuvm>
80104769:	83 c4 10             	add    $0x10,%esp
8010476c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010476f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104773:	75 3e                	jne    801047b3 <growproc+0x7f>
      return -1;
80104775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010477a:	eb 59                	jmp    801047d5 <growproc+0xa1>
  } else if(n < 0){
8010477c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104780:	79 31                	jns    801047b3 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104782:	8b 55 08             	mov    0x8(%ebp),%edx
80104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104788:	01 c2                	add    %eax,%edx
8010478a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104790:	8b 40 04             	mov    0x4(%eax),%eax
80104793:	83 ec 04             	sub    $0x4,%esp
80104796:	52                   	push   %edx
80104797:	ff 75 f4             	pushl  -0xc(%ebp)
8010479a:	50                   	push   %eax
8010479b:	e8 c0 40 00 00       	call   80108860 <deallocuvm>
801047a0:	83 c4 10             	add    $0x10,%esp
801047a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047aa:	75 07                	jne    801047b3 <growproc+0x7f>
      return -1;
801047ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047b1:	eb 22                	jmp    801047d5 <growproc+0xa1>
  }
  proc->sz = sz;
801047b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047bc:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	50                   	push   %eax
801047c8:	e8 0c 3d 00 00       	call   801084d9 <switchuvm>
801047cd:	83 c4 10             	add    $0x10,%esp
  return 0;
801047d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047d5:	c9                   	leave  
801047d6:	c3                   	ret    

801047d7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047d7:	55                   	push   %ebp
801047d8:	89 e5                	mov    %esp,%ebp
801047da:	57                   	push   %edi
801047db:	56                   	push   %esi
801047dc:	53                   	push   %ebx
801047dd:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801047e0:	e8 ae fb ff ff       	call   80104393 <allocproc>
801047e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801047e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047ec:	75 0a                	jne    801047f8 <fork+0x21>
    return -1;
801047ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f3:	e9 ee 01 00 00       	jmp    801049e6 <fork+0x20f>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801047f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fe:	8b 10                	mov    (%eax),%edx
80104800:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104806:	8b 40 04             	mov    0x4(%eax),%eax
80104809:	83 ec 08             	sub    $0x8,%esp
8010480c:	52                   	push   %edx
8010480d:	50                   	push   %eax
8010480e:	e8 e9 41 00 00       	call   801089fc <copyuvm>
80104813:	83 c4 10             	add    $0x10,%esp
80104816:	89 c2                	mov    %eax,%edx
80104818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481b:	89 50 04             	mov    %edx,0x4(%eax)
8010481e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104821:	8b 40 04             	mov    0x4(%eax),%eax
80104824:	85 c0                	test   %eax,%eax
80104826:	75 30                	jne    80104858 <fork+0x81>
    kfree(np->kstack);
80104828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482b:	8b 40 08             	mov    0x8(%eax),%eax
8010482e:	83 ec 0c             	sub    $0xc,%esp
80104831:	50                   	push   %eax
80104832:	e8 be e2 ff ff       	call   80102af5 <kfree>
80104837:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010483a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104844:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104847:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010484e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104853:	e9 8e 01 00 00       	jmp    801049e6 <fork+0x20f>
  }
  np->sz = proc->sz;
80104858:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485e:	8b 10                	mov    (%eax),%edx
80104860:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104863:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104865:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010486c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104872:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104875:	8b 50 18             	mov    0x18(%eax),%edx
80104878:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487e:	8b 40 18             	mov    0x18(%eax),%eax
80104881:	89 c3                	mov    %eax,%ebx
80104883:	b8 13 00 00 00       	mov    $0x13,%eax
80104888:	89 d7                	mov    %edx,%edi
8010488a:	89 de                	mov    %ebx,%esi
8010488c:	89 c1                	mov    %eax,%ecx
8010488e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104890:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104893:	8b 40 18             	mov    0x18(%eax),%eax
80104896:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010489d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801048a4:	eb 43                	jmp    801048e9 <fork+0x112>
    if(proc->ofile[i])
801048a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048af:	83 c2 08             	add    $0x8,%edx
801048b2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048b6:	85 c0                	test   %eax,%eax
801048b8:	74 2b                	je     801048e5 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801048ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048c3:	83 c2 08             	add    $0x8,%edx
801048c6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048ca:	83 ec 0c             	sub    $0xc,%esp
801048cd:	50                   	push   %eax
801048ce:	e8 f4 c6 ff ff       	call   80100fc7 <filedup>
801048d3:	83 c4 10             	add    $0x10,%esp
801048d6:	89 c1                	mov    %eax,%ecx
801048d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048de:	83 c2 08             	add    $0x8,%edx
801048e1:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801048e5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048e9:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048ed:	7e b7                	jle    801048a6 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801048ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f5:	8b 40 68             	mov    0x68(%eax),%eax
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	50                   	push   %eax
801048fc:	e8 9f cf ff ff       	call   801018a0 <idup>
80104901:	83 c4 10             	add    $0x10,%esp
80104904:	89 c2                	mov    %eax,%edx
80104906:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104909:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010490c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104912:	8d 50 6c             	lea    0x6c(%eax),%edx
80104915:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104918:	83 c0 6c             	add    $0x6c,%eax
8010491b:	83 ec 04             	sub    $0x4,%esp
8010491e:	6a 10                	push   $0x10
80104920:	52                   	push   %edx
80104921:	50                   	push   %eax
80104922:	e8 0e 0f 00 00       	call   80105835 <safestrcpy>
80104927:	83 c4 10             	add    $0x10,%esp
 
  //inherits all the semaphores.
  for(i = 0; i < proc->squantity; i++){
8010492a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104931:	eb 3f                	jmp    80104972 <fork+0x19b>
    np->sem[i] = proc->sem[i];
80104933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010493c:	83 c2 20             	add    $0x20,%edx
8010493f:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80104943:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104946:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104949:	83 c1 20             	add    $0x20,%ecx
8010494c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
    semget(proc->sem[i],0);
80104950:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104956:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104959:	83 c2 20             	add    $0x20,%edx
8010495c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104960:	83 ec 08             	sub    $0x8,%esp
80104963:	6a 00                	push   $0x0
80104965:	50                   	push   %eax
80104966:	e8 73 08 00 00       	call   801051de <semget>
8010496b:	83 c4 10             	add    $0x10,%esp
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  //inherits all the semaphores.
  for(i = 0; i < proc->squantity; i++){
8010496e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104972:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104978:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
8010497e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80104981:	7f b0                	jg     80104933 <fork+0x15c>
    np->sem[i] = proc->sem[i];
    semget(proc->sem[i],0);
  }
  np->squantity = proc->squantity;
80104983:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104989:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
8010498f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104992:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)

  pid = np->pid;
80104998:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499b:	8b 40 10             	mov    0x10(%eax),%eax
8010499e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801049a1:	83 ec 0c             	sub    $0xc,%esp
801049a4:	68 40 3a 11 80       	push   $0x80113a40
801049a9:	e8 26 0a 00 00       	call   801053d4 <acquire>
801049ae:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(np,np->priority);
801049bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049be:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801049c4:	83 ec 08             	sub    $0x8,%esp
801049c7:	50                   	push   %eax
801049c8:	ff 75 e0             	pushl  -0x20(%ebp)
801049cb:	e8 01 fb ff ff       	call   801044d1 <enqueue>
801049d0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801049d3:	83 ec 0c             	sub    $0xc,%esp
801049d6:	68 40 3a 11 80       	push   $0x80113a40
801049db:	e8 5a 0a 00 00       	call   8010543a <release>
801049e0:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801049e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5f                   	pop    %edi
801049ec:	5d                   	pop    %ebp
801049ed:	c3                   	ret    

801049ee <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049ee:	55                   	push   %ebp
801049ef:	89 e5                	mov    %esp,%ebp
801049f1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049f4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049fb:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104a00:	39 c2                	cmp    %eax,%edx
80104a02:	75 0d                	jne    80104a11 <exit+0x23>
    panic("init exiting");
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	68 10 8f 10 80       	push   $0x80108f10
80104a0c:	e8 4b bb ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a18:	eb 48                	jmp    80104a62 <exit+0x74>
    if(proc->ofile[fd]){
80104a1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a23:	83 c2 08             	add    $0x8,%edx
80104a26:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a2a:	85 c0                	test   %eax,%eax
80104a2c:	74 30                	je     80104a5e <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a37:	83 c2 08             	add    $0x8,%edx
80104a3a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a3e:	83 ec 0c             	sub    $0xc,%esp
80104a41:	50                   	push   %eax
80104a42:	e8 d1 c5 ff ff       	call   80101018 <fileclose>
80104a47:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a53:	83 c2 08             	add    $0x8,%edx
80104a56:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a5d:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a5e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a62:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a66:	7e b2                	jle    80104a1a <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a68:	e8 05 ea ff ff       	call   80103472 <begin_op>
  iput(proc->cwd);
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 40 68             	mov    0x68(%eax),%eax
80104a76:	83 ec 0c             	sub    $0xc,%esp
80104a79:	50                   	push   %eax
80104a7a:	e8 23 d0 ff ff       	call   80101aa2 <iput>
80104a7f:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a82:	e8 79 ea ff ff       	call   80103500 <end_op>
  proc->cwd = 0;
80104a87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  int i;
  
  //release all the semaphores.
  for(i = 0; i < proc->squantity; i++){   
80104a94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104a9b:	eb 20                	jmp    80104abd <exit+0xcf>
    semfree(proc->sem[i]);
80104a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104aa6:	83 c2 20             	add    $0x20,%edx
80104aa9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104aad:	83 ec 0c             	sub    $0xc,%esp
80104ab0:	50                   	push   %eax
80104ab1:	e8 d6 07 00 00       	call   8010528c <semfree>
80104ab6:	83 c4 10             	add    $0x10,%esp
  end_op();
  proc->cwd = 0;
  int i;
  
  //release all the semaphores.
  for(i = 0; i < proc->squantity; i++){   
80104ab9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104abd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac3:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80104ac9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104acc:	7f cf                	jg     80104a9d <exit+0xaf>
    semfree(proc->sem[i]);
  }
  proc->squantity = 0;
80104ace:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad4:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
80104adb:	00 00 00 

  acquire(&ptable.lock);
80104ade:	83 ec 0c             	sub    $0xc,%esp
80104ae1:	68 40 3a 11 80       	push   $0x80113a40
80104ae6:	e8 e9 08 00 00       	call   801053d4 <acquire>
80104aeb:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104aee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af4:	8b 40 14             	mov    0x14(%eax),%eax
80104af7:	83 ec 0c             	sub    $0xc,%esp
80104afa:	50                   	push   %eax
80104afb:	e8 8b 04 00 00       	call   80104f8b <wakeup1>
80104b00:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b03:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104b0a:	eb 3f                	jmp    80104b4b <exit+0x15d>
    if(p->parent == proc){
80104b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0f:	8b 50 14             	mov    0x14(%eax),%edx
80104b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b18:	39 c2                	cmp    %eax,%edx
80104b1a:	75 28                	jne    80104b44 <exit+0x156>
      p->parent = initproc;
80104b1c:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b25:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b2e:	83 f8 05             	cmp    $0x5,%eax
80104b31:	75 11                	jne    80104b44 <exit+0x156>
        wakeup1(initproc);
80104b33:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	50                   	push   %eax
80104b3c:	e8 4a 04 00 00       	call   80104f8b <wakeup1>
80104b41:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b44:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104b4b:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
80104b52:	72 b8                	jb     80104b0c <exit+0x11e>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104b54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5a:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104b61:	e8 09 02 00 00       	call   80104d6f <sched>
  panic("zombie exit");
80104b66:	83 ec 0c             	sub    $0xc,%esp
80104b69:	68 1d 8f 10 80       	push   $0x80108f1d
80104b6e:	e8 e9 b9 ff ff       	call   8010055c <panic>

80104b73 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b73:	55                   	push   %ebp
80104b74:	89 e5                	mov    %esp,%ebp
80104b76:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	68 40 3a 11 80       	push   $0x80113a40
80104b81:	e8 4e 08 00 00       	call   801053d4 <acquire>
80104b86:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b90:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104b97:	e9 a9 00 00 00       	jmp    80104c45 <wait+0xd2>
      if(p->parent != proc)
80104b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9f:	8b 50 14             	mov    0x14(%eax),%edx
80104ba2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba8:	39 c2                	cmp    %eax,%edx
80104baa:	74 05                	je     80104bb1 <wait+0x3e>
        continue;
80104bac:	e9 8d 00 00 00       	jmp    80104c3e <wait+0xcb>
      havekids = 1;
80104bb1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbb:	8b 40 0c             	mov    0xc(%eax),%eax
80104bbe:	83 f8 05             	cmp    $0x5,%eax
80104bc1:	75 7b                	jne    80104c3e <wait+0xcb>
        // Found one.
        pid = p->pid;
80104bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc6:	8b 40 10             	mov    0x10(%eax),%eax
80104bc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcf:	8b 40 08             	mov    0x8(%eax),%eax
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	50                   	push   %eax
80104bd6:	e8 1a df ff ff       	call   80102af5 <kfree>
80104bdb:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104beb:	8b 40 04             	mov    0x4(%eax),%eax
80104bee:	83 ec 0c             	sub    $0xc,%esp
80104bf1:	50                   	push   %eax
80104bf2:	e8 26 3d 00 00       	call   8010891d <freevm>
80104bf7:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c07:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c11:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c22:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c29:	83 ec 0c             	sub    $0xc,%esp
80104c2c:	68 40 3a 11 80       	push   $0x80113a40
80104c31:	e8 04 08 00 00       	call   8010543a <release>
80104c36:	83 c4 10             	add    $0x10,%esp
        return pid;
80104c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3c:	eb 5a                	jmp    80104c98 <wait+0x125>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c3e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104c45:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
80104c4c:	0f 82 4a ff ff ff    	jb     80104b9c <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c56:	74 0d                	je     80104c65 <wait+0xf2>
80104c58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5e:	8b 40 24             	mov    0x24(%eax),%eax
80104c61:	85 c0                	test   %eax,%eax
80104c63:	74 17                	je     80104c7c <wait+0x109>
      release(&ptable.lock);
80104c65:	83 ec 0c             	sub    $0xc,%esp
80104c68:	68 40 3a 11 80       	push   $0x80113a40
80104c6d:	e8 c8 07 00 00       	call   8010543a <release>
80104c72:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7a:	eb 1c                	jmp    80104c98 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c82:	83 ec 08             	sub    $0x8,%esp
80104c85:	68 40 3a 11 80       	push   $0x80113a40
80104c8a:	50                   	push   %eax
80104c8b:	e8 50 02 00 00       	call   80104ee0 <sleep>
80104c90:	83 c4 10             	add    $0x10,%esp
  }
80104c93:	e9 f1 fe ff ff       	jmp    80104b89 <wait+0x16>
}
80104c98:	c9                   	leave  
80104c99:	c3                   	ret    

80104c9a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c9a:	55                   	push   %ebp
80104c9b:	89 e5                	mov    %esp,%ebp
80104c9d:	83 ec 18             	sub    $0x18,%esp

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ca0:	e8 cb f6 ff ff       	call   80104370 <sti>

    int level = 0;
80104ca5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    // Loop over process queue looking for process to run.
    acquire(&ptable.lock);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	68 40 3a 11 80       	push   $0x80113a40
80104cb4:	e8 1b 07 00 00       	call   801053d4 <acquire>
80104cb9:	83 c4 10             	add    $0x10,%esp
      while (level<MLF_SIZE){
80104cbc:	e9 8f 00 00 00       	jmp    80104d50 <scheduler+0xb6>
        if (!is_empty(level)){ 
80104cc1:	83 ec 0c             	sub    $0xc,%esp
80104cc4:	ff 75 f4             	pushl  -0xc(%ebp)
80104cc7:	e8 e9 f7 ff ff       	call   801044b5 <is_empty>
80104ccc:	83 c4 10             	add    $0x10,%esp
80104ccf:	85 c0                	test   %eax,%eax
80104cd1:	75 79                	jne    80104d4c <scheduler+0xb2>
          // Switch to chosen process.  It is the process's job
          // to release ptable.lock and then reacquire it
          // before jumping back to us.
          proc = dequeue(level);
80104cd3:	83 ec 0c             	sub    $0xc,%esp
80104cd6:	ff 75 f4             	pushl  -0xc(%ebp)
80104cd9:	e8 5a f8 ff ff       	call   80104538 <dequeue>
80104cde:	83 c4 10             	add    $0x10,%esp
80104ce1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
          switchuvm(proc);
80104ce7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ced:	83 ec 0c             	sub    $0xc,%esp
80104cf0:	50                   	push   %eax
80104cf1:	e8 e3 37 00 00       	call   801084d9 <switchuvm>
80104cf6:	83 c4 10             	add    $0x10,%esp
          proc->quantum = 0;
80104cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cff:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
          proc->state = RUNNING;
80104d06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d0c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
          swtch(&cpu->scheduler, proc->context);
80104d13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d19:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d1c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d23:	83 c2 04             	add    $0x4,%edx
80104d26:	83 ec 08             	sub    $0x8,%esp
80104d29:	50                   	push   %eax
80104d2a:	52                   	push   %edx
80104d2b:	e8 76 0b 00 00       	call   801058a6 <swtch>
80104d30:	83 c4 10             	add    $0x10,%esp
          switchkvm();          
80104d33:	e8 85 37 00 00       	call   801084bd <switchkvm>
          // Process is done running for now.
          // It should have changed its p->state before coming back.            
          proc = 0;          
80104d38:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d3f:	00 00 00 00 
          level=MLF_SIZE;
80104d43:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
80104d4a:	eb 04                	jmp    80104d50 <scheduler+0xb6>
        } else {
          level++;
80104d4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    sti();

    int level = 0;
    // Loop over process queue looking for process to run.
    acquire(&ptable.lock);
      while (level<MLF_SIZE){
80104d50:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104d54:	0f 8e 67 ff ff ff    	jle    80104cc1 <scheduler+0x27>
          level=MLF_SIZE;
        } else {
          level++;
        }
      }
    release(&ptable.lock);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	68 40 3a 11 80       	push   $0x80113a40
80104d62:	e8 d3 06 00 00       	call   8010543a <release>
80104d67:	83 c4 10             	add    $0x10,%esp
  }
80104d6a:	e9 31 ff ff ff       	jmp    80104ca0 <scheduler+0x6>

80104d6f <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d6f:	55                   	push   %ebp
80104d70:	89 e5                	mov    %esp,%ebp
80104d72:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d75:	83 ec 0c             	sub    $0xc,%esp
80104d78:	68 40 3a 11 80       	push   $0x80113a40
80104d7d:	e8 82 07 00 00       	call   80105504 <holding>
80104d82:	83 c4 10             	add    $0x10,%esp
80104d85:	85 c0                	test   %eax,%eax
80104d87:	75 0d                	jne    80104d96 <sched+0x27>
    panic("sched ptable.lock");
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	68 29 8f 10 80       	push   $0x80108f29
80104d91:	e8 c6 b7 ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
80104d96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d9c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104da2:	83 f8 01             	cmp    $0x1,%eax
80104da5:	74 0d                	je     80104db4 <sched+0x45>
    panic("sched locks");
80104da7:	83 ec 0c             	sub    $0xc,%esp
80104daa:	68 3b 8f 10 80       	push   $0x80108f3b
80104daf:	e8 a8 b7 ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104db4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dba:	8b 40 0c             	mov    0xc(%eax),%eax
80104dbd:	83 f8 04             	cmp    $0x4,%eax
80104dc0:	75 0d                	jne    80104dcf <sched+0x60>
    panic("sched running");
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 47 8f 10 80       	push   $0x80108f47
80104dca:	e8 8d b7 ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104dcf:	e8 8c f5 ff ff       	call   80104360 <readeflags>
80104dd4:	25 00 02 00 00       	and    $0x200,%eax
80104dd9:	85 c0                	test   %eax,%eax
80104ddb:	74 0d                	je     80104dea <sched+0x7b>
    panic("sched interruptible");
80104ddd:	83 ec 0c             	sub    $0xc,%esp
80104de0:	68 55 8f 10 80       	push   $0x80108f55
80104de5:	e8 72 b7 ff ff       	call   8010055c <panic>
  intena = cpu->intena;
80104dea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104df9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dff:	8b 40 04             	mov    0x4(%eax),%eax
80104e02:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e09:	83 c2 1c             	add    $0x1c,%edx
80104e0c:	83 ec 08             	sub    $0x8,%esp
80104e0f:	50                   	push   %eax
80104e10:	52                   	push   %edx
80104e11:	e8 90 0a 00 00       	call   801058a6 <swtch>
80104e16:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e19:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e22:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e28:	c9                   	leave  
80104e29:	c3                   	ret    

80104e2a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e2a:	55                   	push   %ebp
80104e2b:	89 e5                	mov    %esp,%ebp
80104e2d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	68 40 3a 11 80       	push   $0x80113a40
80104e38:	e8 97 05 00 00       	call   801053d4 <acquire>
80104e3d:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e46:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(proc->priority < MLF_SIZE-1){
80104e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e53:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104e59:	83 f8 02             	cmp    $0x2,%eax
80104e5c:	7f 1c                	jg     80104e7a <yield+0x50>
    proc->priority = proc->priority + 1;
80104e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e64:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e6b:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
80104e71:	83 c2 01             	add    $0x1,%edx
80104e74:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  enqueue(proc,proc->priority);
80104e7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e80:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104e86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e8c:	83 ec 08             	sub    $0x8,%esp
80104e8f:	52                   	push   %edx
80104e90:	50                   	push   %eax
80104e91:	e8 3b f6 ff ff       	call   801044d1 <enqueue>
80104e96:	83 c4 10             	add    $0x10,%esp
  sched();
80104e99:	e8 d1 fe ff ff       	call   80104d6f <sched>
  release(&ptable.lock);
80104e9e:	83 ec 0c             	sub    $0xc,%esp
80104ea1:	68 40 3a 11 80       	push   $0x80113a40
80104ea6:	e8 8f 05 00 00       	call   8010543a <release>
80104eab:	83 c4 10             	add    $0x10,%esp
}
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    

80104eb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104eb6:	83 ec 0c             	sub    $0xc,%esp
80104eb9:	68 40 3a 11 80       	push   $0x80113a40
80104ebe:	e8 77 05 00 00       	call   8010543a <release>
80104ec3:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104ec6:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	74 0f                	je     80104ede <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104ecf:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104ed6:	00 00 00 
    initlog();
80104ed9:	e8 73 e3 ff ff       	call   80103251 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104ede:	c9                   	leave  
80104edf:	c3                   	ret    

80104ee0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104ee6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eec:	85 c0                	test   %eax,%eax
80104eee:	75 0d                	jne    80104efd <sleep+0x1d>
    panic("sleep");
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	68 69 8f 10 80       	push   $0x80108f69
80104ef8:	e8 5f b6 ff ff       	call   8010055c <panic>

  if(lk == 0)
80104efd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f01:	75 0d                	jne    80104f10 <sleep+0x30>
    panic("sleep without lk");
80104f03:	83 ec 0c             	sub    $0xc,%esp
80104f06:	68 6f 8f 10 80       	push   $0x80108f6f
80104f0b:	e8 4c b6 ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104f10:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104f17:	74 1e                	je     80104f37 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 40 3a 11 80       	push   $0x80113a40
80104f21:	e8 ae 04 00 00       	call   801053d4 <acquire>
80104f26:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	ff 75 0c             	pushl  0xc(%ebp)
80104f2f:	e8 06 05 00 00       	call   8010543a <release>
80104f34:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104f37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f40:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f49:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f50:	e8 1a fe ff ff       	call   80104d6f <sched>

  // Tidy up.
  proc->chan = 0;
80104f55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f5b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f62:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104f69:	74 1e                	je     80104f89 <sleep+0xa9>
    release(&ptable.lock);
80104f6b:	83 ec 0c             	sub    $0xc,%esp
80104f6e:	68 40 3a 11 80       	push   $0x80113a40
80104f73:	e8 c2 04 00 00       	call   8010543a <release>
80104f78:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	ff 75 0c             	pushl  0xc(%ebp)
80104f81:	e8 4e 04 00 00       	call   801053d4 <acquire>
80104f86:	83 c4 10             	add    $0x10,%esp
  }
}
80104f89:	c9                   	leave  
80104f8a:	c3                   	ret    

80104f8b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f8b:	55                   	push   %ebp
80104f8c:	89 e5                	mov    %esp,%ebp
80104f8e:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f91:	c7 45 fc 74 3a 11 80 	movl   $0x80113a74,-0x4(%ebp)
80104f98:	eb 5e                	jmp    80104ff8 <wakeup1+0x6d>
    if(p->state == SLEEPING && p->chan == chan){
80104f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f9d:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa0:	83 f8 02             	cmp    $0x2,%eax
80104fa3:	75 4c                	jne    80104ff1 <wakeup1+0x66>
80104fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fa8:	8b 40 20             	mov    0x20(%eax),%eax
80104fab:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fae:	75 41                	jne    80104ff1 <wakeup1+0x66>
      p->state = RUNNABLE;
80104fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fb3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      if(p->priority > 0){
80104fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fbd:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fc3:	85 c0                	test   %eax,%eax
80104fc5:	7e 15                	jle    80104fdc <wakeup1+0x51>
        p->priority = p->priority - 1;
80104fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fca:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fd0:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd6:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      } 
      enqueue(p,p->priority);
80104fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fdf:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fe5:	50                   	push   %eax
80104fe6:	ff 75 fc             	pushl  -0x4(%ebp)
80104fe9:	e8 e3 f4 ff ff       	call   801044d1 <enqueue>
80104fee:	83 c4 08             	add    $0x8,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff1:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80104ff8:	81 7d fc 74 62 11 80 	cmpl   $0x80116274,-0x4(%ebp)
80104fff:	72 99                	jb     80104f9a <wakeup1+0xf>
        p->priority = p->priority - 1;
      } 
      enqueue(p,p->priority);
    }
  }    
}
80105001:	c9                   	leave  
80105002:	c3                   	ret    

80105003 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105003:	55                   	push   %ebp
80105004:	89 e5                	mov    %esp,%ebp
80105006:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	68 40 3a 11 80       	push   $0x80113a40
80105011:	e8 be 03 00 00       	call   801053d4 <acquire>
80105016:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	ff 75 08             	pushl  0x8(%ebp)
8010501f:	e8 67 ff ff ff       	call   80104f8b <wakeup1>
80105024:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105027:	83 ec 0c             	sub    $0xc,%esp
8010502a:	68 40 3a 11 80       	push   $0x80113a40
8010502f:	e8 06 04 00 00       	call   8010543a <release>
80105034:	83 c4 10             	add    $0x10,%esp
}
80105037:	c9                   	leave  
80105038:	c3                   	ret    

80105039 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105039:	55                   	push   %ebp
8010503a:	89 e5                	mov    %esp,%ebp
8010503c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 40 3a 11 80       	push   $0x80113a40
80105047:	e8 88 03 00 00       	call   801053d4 <acquire>
8010504c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010504f:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80105056:	eb 60                	jmp    801050b8 <kill+0x7f>
    if(p->pid == pid){
80105058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505b:	8b 40 10             	mov    0x10(%eax),%eax
8010505e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105061:	75 4e                	jne    801050b1 <kill+0x78>
      p->killed = 1;
80105063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105066:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)

      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
8010506d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105070:	8b 40 0c             	mov    0xc(%eax),%eax
80105073:	83 f8 02             	cmp    $0x2,%eax
80105076:	75 22                	jne    8010509a <kill+0x61>
        p->state = RUNNABLE;
80105078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        enqueue(p,p->priority);
80105082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105085:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010508b:	83 ec 08             	sub    $0x8,%esp
8010508e:	50                   	push   %eax
8010508f:	ff 75 f4             	pushl  -0xc(%ebp)
80105092:	e8 3a f4 ff ff       	call   801044d1 <enqueue>
80105097:	83 c4 10             	add    $0x10,%esp
      }
      release(&ptable.lock);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	68 40 3a 11 80       	push   $0x80113a40
801050a2:	e8 93 03 00 00       	call   8010543a <release>
801050a7:	83 c4 10             	add    $0x10,%esp
      return 0;
801050aa:	b8 00 00 00 00       	mov    $0x0,%eax
801050af:	eb 25                	jmp    801050d6 <kill+0x9d>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050b1:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801050b8:	81 7d f4 74 62 11 80 	cmpl   $0x80116274,-0xc(%ebp)
801050bf:	72 97                	jb     80105058 <kill+0x1f>
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801050c1:	83 ec 0c             	sub    $0xc,%esp
801050c4:	68 40 3a 11 80       	push   $0x80113a40
801050c9:	e8 6c 03 00 00       	call   8010543a <release>
801050ce:	83 c4 10             	add    $0x10,%esp
  return -1;
801050d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d6:	c9                   	leave  
801050d7:	c3                   	ret    

801050d8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801050d8:	55                   	push   %ebp
801050d9:	89 e5                	mov    %esp,%ebp
801050db:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050de:	c7 45 f0 74 3a 11 80 	movl   $0x80113a74,-0x10(%ebp)
801050e5:	e9 e5 00 00 00       	jmp    801051cf <procdump+0xf7>
    if(p->state == UNUSED)
801050ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ed:	8b 40 0c             	mov    0xc(%eax),%eax
801050f0:	85 c0                	test   %eax,%eax
801050f2:	75 05                	jne    801050f9 <procdump+0x21>
      continue;
801050f4:	e9 cf 00 00 00       	jmp    801051c8 <procdump+0xf0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050fc:	8b 40 0c             	mov    0xc(%eax),%eax
801050ff:	83 f8 05             	cmp    $0x5,%eax
80105102:	77 23                	ja     80105127 <procdump+0x4f>
80105104:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105107:	8b 40 0c             	mov    0xc(%eax),%eax
8010510a:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105111:	85 c0                	test   %eax,%eax
80105113:	74 12                	je     80105127 <procdump+0x4f>
      state = states[p->state];
80105115:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105118:	8b 40 0c             	mov    0xc(%eax),%eax
8010511b:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105122:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105125:	eb 07                	jmp    8010512e <procdump+0x56>
    else
      state = "???";
80105127:	c7 45 ec 80 8f 10 80 	movl   $0x80108f80,-0x14(%ebp)
    cprintf("%d %s %s priority: %d ", p->pid, state, p->name, p->priority);
8010512e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105131:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513a:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010513d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105140:	8b 40 10             	mov    0x10(%eax),%eax
80105143:	83 ec 0c             	sub    $0xc,%esp
80105146:	52                   	push   %edx
80105147:	51                   	push   %ecx
80105148:	ff 75 ec             	pushl  -0x14(%ebp)
8010514b:	50                   	push   %eax
8010514c:	68 84 8f 10 80       	push   $0x80108f84
80105151:	e8 69 b2 ff ff       	call   801003bf <cprintf>
80105156:	83 c4 20             	add    $0x20,%esp
    if(p->state == SLEEPING){
80105159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515c:	8b 40 0c             	mov    0xc(%eax),%eax
8010515f:	83 f8 02             	cmp    $0x2,%eax
80105162:	75 54                	jne    801051b8 <procdump+0xe0>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105167:	8b 40 1c             	mov    0x1c(%eax),%eax
8010516a:	8b 40 0c             	mov    0xc(%eax),%eax
8010516d:	83 c0 08             	add    $0x8,%eax
80105170:	89 c2                	mov    %eax,%edx
80105172:	83 ec 08             	sub    $0x8,%esp
80105175:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105178:	50                   	push   %eax
80105179:	52                   	push   %edx
8010517a:	e8 0c 03 00 00       	call   8010548b <getcallerpcs>
8010517f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105189:	eb 1c                	jmp    801051a7 <procdump+0xcf>
        cprintf(" %p", pc[i]);
8010518b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105192:	83 ec 08             	sub    $0x8,%esp
80105195:	50                   	push   %eax
80105196:	68 9b 8f 10 80       	push   $0x80108f9b
8010519b:	e8 1f b2 ff ff       	call   801003bf <cprintf>
801051a0:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s priority: %d ", p->pid, state, p->name, p->priority);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801051a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801051a7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801051ab:	7f 0b                	jg     801051b8 <procdump+0xe0>
801051ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801051b4:	85 c0                	test   %eax,%eax
801051b6:	75 d3                	jne    8010518b <procdump+0xb3>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	68 9f 8f 10 80       	push   $0x80108f9f
801051c0:	e8 fa b1 ff ff       	call   801003bf <cprintf>
801051c5:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051c8:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801051cf:	81 7d f0 74 62 11 80 	cmpl   $0x80116274,-0x10(%ebp)
801051d6:	0f 82 0e ff ff ff    	jb     801050ea <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051dc:	c9                   	leave  
801051dd:	c3                   	ret    

801051de <semget>:
parameters:
if Sem_id == -1, create a new one.
Return: semaphore identifier obtained or created, otherwise return a negative value indicating error. 
-1: Sem_id > 0  the semaphore is not in use.
-3: Sem_id = -1  no more semaphores available in the system*/
int semget(int sem_id, int init_value){
801051de:	55                   	push   %ebp
801051df:	89 e5                	mov    %esp,%ebp
801051e1:	83 ec 10             	sub    $0x10,%esp
  if (sem_id == -1){
801051e4:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
801051e8:	75 6f                	jne    80105259 <semget+0x7b>
    if (stable.quantity == MAXSEM){
801051ea:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
801051f1:	66 83 f8 14          	cmp    $0x14,%ax
801051f5:	75 0a                	jne    80105201 <semget+0x23>
      return -3;
801051f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
801051fc:	e9 89 00 00 00       	jmp    8010528a <semget+0xac>
    }
    int i = 0;
80105201:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i<MAXSEM){
80105208:	eb 42                	jmp    8010524c <semget+0x6e>
      if (stable.semaphore[i].refcount == 0){
8010520a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010520d:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105214:	85 c0                	test   %eax,%eax
80105216:	75 30                	jne    80105248 <semget+0x6a>
        stable.semaphore[i].value = init_value;
80105218:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010521b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010521e:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
        stable.semaphore[i].refcount = 1;
80105225:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105228:	c7 04 c5 c4 62 11 80 	movl   $0x1,-0x7fee9d3c(,%eax,8)
8010522f:	01 00 00 00 
        stable.quantity++;
80105233:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
8010523a:	83 c0 01             	add    $0x1,%eax
8010523d:	66 a3 94 63 11 80    	mov    %ax,0x80116394
        return i;
80105243:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105246:	eb 42                	jmp    8010528a <semget+0xac>
      } else
        ++i;    
80105248:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  if (sem_id == -1){
    if (stable.quantity == MAXSEM){
      return -3;
    }
    int i = 0;
    while (i<MAXSEM){
8010524c:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
80105250:	7e b8                	jle    8010520a <semget+0x2c>
        stable.quantity++;
        return i;
      } else
        ++i;    
    }
    return -3;
80105252:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80105257:	eb 31                	jmp    8010528a <semget+0xac>
  } else {
    if (stable.semaphore[sem_id].refcount == 0)
80105259:	8b 45 08             	mov    0x8(%ebp),%eax
8010525c:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105263:	85 c0                	test   %eax,%eax
80105265:	75 07                	jne    8010526e <semget+0x90>
      return -1;
80105267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526c:	eb 1c                	jmp    8010528a <semget+0xac>
    stable.semaphore[sem_id].refcount++;      
8010526e:	8b 45 08             	mov    0x8(%ebp),%eax
80105271:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105278:	8d 50 01             	lea    0x1(%eax),%edx
8010527b:	8b 45 08             	mov    0x8(%ebp),%eax
8010527e:	89 14 c5 c4 62 11 80 	mov    %edx,-0x7fee9d3c(,%eax,8)
    return 0;
80105285:	b8 00 00 00 00       	mov    $0x0,%eax
  }  
}
8010528a:	c9                   	leave  
8010528b:	c3                   	ret    

8010528c <semfree>:


/*Releases the semaphore.
Return -1 on error (not semaphore obtained by the process). Zero otherwise*/
int semfree(int sem_id){
8010528c:	55                   	push   %ebp
8010528d:	89 e5                	mov    %esp,%ebp
8010528f:	83 ec 08             	sub    $0x8,%esp
  if (stable.semaphore[sem_id].refcount == 0)
80105292:	8b 45 08             	mov    0x8(%ebp),%eax
80105295:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
8010529c:	85 c0                	test   %eax,%eax
8010529e:	75 07                	jne    801052a7 <semfree+0x1b>
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a5:	eb 5a                	jmp    80105301 <semfree+0x75>
  acquire(&stable.lock);
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	68 60 63 11 80       	push   $0x80116360
801052af:	e8 20 01 00 00       	call   801053d4 <acquire>
801052b4:	83 c4 10             	add    $0x10,%esp
  stable.semaphore[sem_id].refcount--;
801052b7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ba:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
801052c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801052c4:	8b 45 08             	mov    0x8(%ebp),%eax
801052c7:	89 14 c5 c4 62 11 80 	mov    %edx,-0x7fee9d3c(,%eax,8)
  if (stable.semaphore[sem_id].refcount == 0)
801052ce:	8b 45 08             	mov    0x8(%ebp),%eax
801052d1:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
801052d8:	85 c0                	test   %eax,%eax
801052da:	75 10                	jne    801052ec <semfree+0x60>
    stable.quantity--;
801052dc:	0f b7 05 94 63 11 80 	movzwl 0x80116394,%eax
801052e3:	83 e8 01             	sub    $0x1,%eax
801052e6:	66 a3 94 63 11 80    	mov    %ax,0x80116394
  release(&stable.lock);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	68 60 63 11 80       	push   $0x80116360
801052f4:	e8 41 01 00 00       	call   8010543a <release>
801052f9:	83 c4 10             	add    $0x10,%esp
  return 0;
801052fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105301:	c9                   	leave  
80105302:	c3                   	ret    

80105303 <semdown>:

//decrease the unit value of the semaphore
int semdown(int sem_id){
80105303:	55                   	push   %ebp
80105304:	89 e5                	mov    %esp,%ebp
  stable.semaphore[sem_id].value--;
80105306:	8b 45 08             	mov    0x8(%ebp),%eax
80105309:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80105310:	8d 50 ff             	lea    -0x1(%eax),%edx
80105313:	8b 45 08             	mov    0x8(%ebp),%eax
80105316:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
  return 0;
8010531d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105322:	5d                   	pop    %ebp
80105323:	c3                   	ret    

80105324 <semup>:

//Increase the unit value of the semaphore
int semup(int sem_id){
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 08             	sub    $0x8,%esp
  if (stable.semaphore[sem_id].refcount == 0)
8010532a:	8b 45 08             	mov    0x8(%ebp),%eax
8010532d:	8b 04 c5 c4 62 11 80 	mov    -0x7fee9d3c(,%eax,8),%eax
80105334:	85 c0                	test   %eax,%eax
80105336:	75 07                	jne    8010533f <semup+0x1b>
    return -1;
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb 3c                	jmp    8010537b <semup+0x57>
  acquire(&stable.lock);
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	68 60 63 11 80       	push   $0x80116360
80105347:	e8 88 00 00 00       	call   801053d4 <acquire>
8010534c:	83 c4 10             	add    $0x10,%esp
  stable.semaphore[sem_id].value++;
8010534f:	8b 45 08             	mov    0x8(%ebp),%eax
80105352:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80105359:	8d 50 01             	lea    0x1(%eax),%edx
8010535c:	8b 45 08             	mov    0x8(%ebp),%eax
8010535f:	89 14 c5 c0 62 11 80 	mov    %edx,-0x7fee9d40(,%eax,8)
  release(&stable.lock);
80105366:	83 ec 0c             	sub    $0xc,%esp
80105369:	68 60 63 11 80       	push   $0x80116360
8010536e:	e8 c7 00 00 00       	call   8010543a <release>
80105373:	83 c4 10             	add    $0x10,%esp
  return 0;
80105376:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010537b:	c9                   	leave  
8010537c:	c3                   	ret    

8010537d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010537d:	55                   	push   %ebp
8010537e:	89 e5                	mov    %esp,%ebp
80105380:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105383:	9c                   	pushf  
80105384:	58                   	pop    %eax
80105385:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010538b:	c9                   	leave  
8010538c:	c3                   	ret    

8010538d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010538d:	55                   	push   %ebp
8010538e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105390:	fa                   	cli    
}
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    

80105393 <sti>:

static inline void
sti(void)
{
80105393:	55                   	push   %ebp
80105394:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105396:	fb                   	sti    
}
80105397:	5d                   	pop    %ebp
80105398:	c3                   	ret    

80105399 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105399:	55                   	push   %ebp
8010539a:	89 e5                	mov    %esp,%ebp
8010539c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010539f:	8b 55 08             	mov    0x8(%ebp),%edx
801053a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053a8:	f0 87 02             	lock xchg %eax,(%edx)
801053ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801053ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053b1:	c9                   	leave  
801053b2:	c3                   	ret    

801053b3 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053b3:	55                   	push   %ebp
801053b4:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801053b6:	8b 45 08             	mov    0x8(%ebp),%eax
801053b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801053bc:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801053bf:	8b 45 08             	mov    0x8(%ebp),%eax
801053c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801053c8:	8b 45 08             	mov    0x8(%ebp),%eax
801053cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053d2:	5d                   	pop    %ebp
801053d3:	c3                   	ret    

801053d4 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801053da:	e8 4f 01 00 00       	call   8010552e <pushcli>
  if(holding(lk))
801053df:	8b 45 08             	mov    0x8(%ebp),%eax
801053e2:	83 ec 0c             	sub    $0xc,%esp
801053e5:	50                   	push   %eax
801053e6:	e8 19 01 00 00       	call   80105504 <holding>
801053eb:	83 c4 10             	add    $0x10,%esp
801053ee:	85 c0                	test   %eax,%eax
801053f0:	74 0d                	je     801053ff <acquire+0x2b>
    panic("acquire");
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 cb 8f 10 80       	push   $0x80108fcb
801053fa:	e8 5d b1 ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801053ff:	90                   	nop
80105400:	8b 45 08             	mov    0x8(%ebp),%eax
80105403:	83 ec 08             	sub    $0x8,%esp
80105406:	6a 01                	push   $0x1
80105408:	50                   	push   %eax
80105409:	e8 8b ff ff ff       	call   80105399 <xchg>
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	85 c0                	test   %eax,%eax
80105413:	75 eb                	jne    80105400 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010541f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105422:	8b 45 08             	mov    0x8(%ebp),%eax
80105425:	83 c0 0c             	add    $0xc,%eax
80105428:	83 ec 08             	sub    $0x8,%esp
8010542b:	50                   	push   %eax
8010542c:	8d 45 08             	lea    0x8(%ebp),%eax
8010542f:	50                   	push   %eax
80105430:	e8 56 00 00 00       	call   8010548b <getcallerpcs>
80105435:	83 c4 10             	add    $0x10,%esp
}
80105438:	c9                   	leave  
80105439:	c3                   	ret    

8010543a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010543a:	55                   	push   %ebp
8010543b:	89 e5                	mov    %esp,%ebp
8010543d:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	ff 75 08             	pushl  0x8(%ebp)
80105446:	e8 b9 00 00 00       	call   80105504 <holding>
8010544b:	83 c4 10             	add    $0x10,%esp
8010544e:	85 c0                	test   %eax,%eax
80105450:	75 0d                	jne    8010545f <release+0x25>
    panic("release");
80105452:	83 ec 0c             	sub    $0xc,%esp
80105455:	68 d3 8f 10 80       	push   $0x80108fd3
8010545a:	e8 fd b0 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
8010545f:	8b 45 08             	mov    0x8(%ebp),%eax
80105462:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105469:	8b 45 08             	mov    0x8(%ebp),%eax
8010546c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105473:	8b 45 08             	mov    0x8(%ebp),%eax
80105476:	83 ec 08             	sub    $0x8,%esp
80105479:	6a 00                	push   $0x0
8010547b:	50                   	push   %eax
8010547c:	e8 18 ff ff ff       	call   80105399 <xchg>
80105481:	83 c4 10             	add    $0x10,%esp

  popcli();
80105484:	e8 e9 00 00 00       	call   80105572 <popcli>
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    

8010548b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010548b:	55                   	push   %ebp
8010548c:	89 e5                	mov    %esp,%ebp
8010548e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105491:	8b 45 08             	mov    0x8(%ebp),%eax
80105494:	83 e8 08             	sub    $0x8,%eax
80105497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010549a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801054a1:	eb 38                	jmp    801054db <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054a7:	74 38                	je     801054e1 <getcallerpcs+0x56>
801054a9:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801054b0:	76 2f                	jbe    801054e1 <getcallerpcs+0x56>
801054b2:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801054b6:	74 29                	je     801054e1 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801054b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c5:	01 c2                	add    %eax,%edx
801054c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ca:	8b 40 04             	mov    0x4(%eax),%eax
801054cd:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801054cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d2:	8b 00                	mov    (%eax),%eax
801054d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801054d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054db:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054df:	7e c2                	jle    801054a3 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054e1:	eb 19                	jmp    801054fc <getcallerpcs+0x71>
    pcs[i] = 0;
801054e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f0:	01 d0                	add    %edx,%eax
801054f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054f8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054fc:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105500:	7e e1                	jle    801054e3 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105502:	c9                   	leave  
80105503:	c3                   	ret    

80105504 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105507:	8b 45 08             	mov    0x8(%ebp),%eax
8010550a:	8b 00                	mov    (%eax),%eax
8010550c:	85 c0                	test   %eax,%eax
8010550e:	74 17                	je     80105527 <holding+0x23>
80105510:	8b 45 08             	mov    0x8(%ebp),%eax
80105513:	8b 50 08             	mov    0x8(%eax),%edx
80105516:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010551c:	39 c2                	cmp    %eax,%edx
8010551e:	75 07                	jne    80105527 <holding+0x23>
80105520:	b8 01 00 00 00       	mov    $0x1,%eax
80105525:	eb 05                	jmp    8010552c <holding+0x28>
80105527:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010552c:	5d                   	pop    %ebp
8010552d:	c3                   	ret    

8010552e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010552e:	55                   	push   %ebp
8010552f:	89 e5                	mov    %esp,%ebp
80105531:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105534:	e8 44 fe ff ff       	call   8010537d <readeflags>
80105539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010553c:	e8 4c fe ff ff       	call   8010538d <cli>
  if(cpu->ncli++ == 0)
80105541:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105548:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010554e:	8d 48 01             	lea    0x1(%eax),%ecx
80105551:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105557:	85 c0                	test   %eax,%eax
80105559:	75 15                	jne    80105570 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010555b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105561:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105564:	81 e2 00 02 00 00    	and    $0x200,%edx
8010556a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105570:	c9                   	leave  
80105571:	c3                   	ret    

80105572 <popcli>:

void
popcli(void)
{
80105572:	55                   	push   %ebp
80105573:	89 e5                	mov    %esp,%ebp
80105575:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105578:	e8 00 fe ff ff       	call   8010537d <readeflags>
8010557d:	25 00 02 00 00       	and    $0x200,%eax
80105582:	85 c0                	test   %eax,%eax
80105584:	74 0d                	je     80105593 <popcli+0x21>
    panic("popcli - interruptible");
80105586:	83 ec 0c             	sub    $0xc,%esp
80105589:	68 db 8f 10 80       	push   $0x80108fdb
8010558e:	e8 c9 af ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
80105593:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105599:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010559f:	83 ea 01             	sub    $0x1,%edx
801055a2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055a8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055ae:	85 c0                	test   %eax,%eax
801055b0:	79 0d                	jns    801055bf <popcli+0x4d>
    panic("popcli");
801055b2:	83 ec 0c             	sub    $0xc,%esp
801055b5:	68 f2 8f 10 80       	push   $0x80108ff2
801055ba:	e8 9d af ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
801055bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055c5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055cb:	85 c0                	test   %eax,%eax
801055cd:	75 15                	jne    801055e4 <popcli+0x72>
801055cf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055d5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801055db:	85 c0                	test   %eax,%eax
801055dd:	74 05                	je     801055e4 <popcli+0x72>
    sti();
801055df:	e8 af fd ff ff       	call   80105393 <sti>
}
801055e4:	c9                   	leave  
801055e5:	c3                   	ret    

801055e6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801055e6:	55                   	push   %ebp
801055e7:	89 e5                	mov    %esp,%ebp
801055e9:	57                   	push   %edi
801055ea:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801055eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055ee:	8b 55 10             	mov    0x10(%ebp),%edx
801055f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f4:	89 cb                	mov    %ecx,%ebx
801055f6:	89 df                	mov    %ebx,%edi
801055f8:	89 d1                	mov    %edx,%ecx
801055fa:	fc                   	cld    
801055fb:	f3 aa                	rep stos %al,%es:(%edi)
801055fd:	89 ca                	mov    %ecx,%edx
801055ff:	89 fb                	mov    %edi,%ebx
80105601:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105604:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105607:	5b                   	pop    %ebx
80105608:	5f                   	pop    %edi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    

8010560b <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010560b:	55                   	push   %ebp
8010560c:	89 e5                	mov    %esp,%ebp
8010560e:	57                   	push   %edi
8010560f:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105610:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105613:	8b 55 10             	mov    0x10(%ebp),%edx
80105616:	8b 45 0c             	mov    0xc(%ebp),%eax
80105619:	89 cb                	mov    %ecx,%ebx
8010561b:	89 df                	mov    %ebx,%edi
8010561d:	89 d1                	mov    %edx,%ecx
8010561f:	fc                   	cld    
80105620:	f3 ab                	rep stos %eax,%es:(%edi)
80105622:	89 ca                	mov    %ecx,%edx
80105624:	89 fb                	mov    %edi,%ebx
80105626:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105629:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010562c:	5b                   	pop    %ebx
8010562d:	5f                   	pop    %edi
8010562e:	5d                   	pop    %ebp
8010562f:	c3                   	ret    

80105630 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105633:	8b 45 08             	mov    0x8(%ebp),%eax
80105636:	83 e0 03             	and    $0x3,%eax
80105639:	85 c0                	test   %eax,%eax
8010563b:	75 43                	jne    80105680 <memset+0x50>
8010563d:	8b 45 10             	mov    0x10(%ebp),%eax
80105640:	83 e0 03             	and    $0x3,%eax
80105643:	85 c0                	test   %eax,%eax
80105645:	75 39                	jne    80105680 <memset+0x50>
    c &= 0xFF;
80105647:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010564e:	8b 45 10             	mov    0x10(%ebp),%eax
80105651:	c1 e8 02             	shr    $0x2,%eax
80105654:	89 c1                	mov    %eax,%ecx
80105656:	8b 45 0c             	mov    0xc(%ebp),%eax
80105659:	c1 e0 18             	shl    $0x18,%eax
8010565c:	89 c2                	mov    %eax,%edx
8010565e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105661:	c1 e0 10             	shl    $0x10,%eax
80105664:	09 c2                	or     %eax,%edx
80105666:	8b 45 0c             	mov    0xc(%ebp),%eax
80105669:	c1 e0 08             	shl    $0x8,%eax
8010566c:	09 d0                	or     %edx,%eax
8010566e:	0b 45 0c             	or     0xc(%ebp),%eax
80105671:	51                   	push   %ecx
80105672:	50                   	push   %eax
80105673:	ff 75 08             	pushl  0x8(%ebp)
80105676:	e8 90 ff ff ff       	call   8010560b <stosl>
8010567b:	83 c4 0c             	add    $0xc,%esp
8010567e:	eb 12                	jmp    80105692 <memset+0x62>
  } else
    stosb(dst, c, n);
80105680:	8b 45 10             	mov    0x10(%ebp),%eax
80105683:	50                   	push   %eax
80105684:	ff 75 0c             	pushl  0xc(%ebp)
80105687:	ff 75 08             	pushl  0x8(%ebp)
8010568a:	e8 57 ff ff ff       	call   801055e6 <stosb>
8010568f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105692:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    

80105697 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105697:	55                   	push   %ebp
80105698:	89 e5                	mov    %esp,%ebp
8010569a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010569d:	8b 45 08             	mov    0x8(%ebp),%eax
801056a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801056a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801056a9:	eb 30                	jmp    801056db <memcmp+0x44>
    if(*s1 != *s2)
801056ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ae:	0f b6 10             	movzbl (%eax),%edx
801056b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056b4:	0f b6 00             	movzbl (%eax),%eax
801056b7:	38 c2                	cmp    %al,%dl
801056b9:	74 18                	je     801056d3 <memcmp+0x3c>
      return *s1 - *s2;
801056bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056be:	0f b6 00             	movzbl (%eax),%eax
801056c1:	0f b6 d0             	movzbl %al,%edx
801056c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056c7:	0f b6 00             	movzbl (%eax),%eax
801056ca:	0f b6 c0             	movzbl %al,%eax
801056cd:	29 c2                	sub    %eax,%edx
801056cf:	89 d0                	mov    %edx,%eax
801056d1:	eb 1a                	jmp    801056ed <memcmp+0x56>
    s1++, s2++;
801056d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056db:	8b 45 10             	mov    0x10(%ebp),%eax
801056de:	8d 50 ff             	lea    -0x1(%eax),%edx
801056e1:	89 55 10             	mov    %edx,0x10(%ebp)
801056e4:	85 c0                	test   %eax,%eax
801056e6:	75 c3                	jne    801056ab <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801056e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    

801056ef <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056ef:	55                   	push   %ebp
801056f0:	89 e5                	mov    %esp,%ebp
801056f2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801056f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801056fb:	8b 45 08             	mov    0x8(%ebp),%eax
801056fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105701:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105707:	73 3d                	jae    80105746 <memmove+0x57>
80105709:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010570c:	8b 45 10             	mov    0x10(%ebp),%eax
8010570f:	01 d0                	add    %edx,%eax
80105711:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105714:	76 30                	jbe    80105746 <memmove+0x57>
    s += n;
80105716:	8b 45 10             	mov    0x10(%ebp),%eax
80105719:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010571c:	8b 45 10             	mov    0x10(%ebp),%eax
8010571f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105722:	eb 13                	jmp    80105737 <memmove+0x48>
      *--d = *--s;
80105724:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105728:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010572c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010572f:	0f b6 10             	movzbl (%eax),%edx
80105732:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105735:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105737:	8b 45 10             	mov    0x10(%ebp),%eax
8010573a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010573d:	89 55 10             	mov    %edx,0x10(%ebp)
80105740:	85 c0                	test   %eax,%eax
80105742:	75 e0                	jne    80105724 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105744:	eb 26                	jmp    8010576c <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105746:	eb 17                	jmp    8010575f <memmove+0x70>
      *d++ = *s++;
80105748:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010574b:	8d 50 01             	lea    0x1(%eax),%edx
8010574e:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105751:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105754:	8d 4a 01             	lea    0x1(%edx),%ecx
80105757:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010575a:	0f b6 12             	movzbl (%edx),%edx
8010575d:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010575f:	8b 45 10             	mov    0x10(%ebp),%eax
80105762:	8d 50 ff             	lea    -0x1(%eax),%edx
80105765:	89 55 10             	mov    %edx,0x10(%ebp)
80105768:	85 c0                	test   %eax,%eax
8010576a:	75 dc                	jne    80105748 <memmove+0x59>
      *d++ = *s++;

  return dst;
8010576c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010576f:	c9                   	leave  
80105770:	c3                   	ret    

80105771 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105771:	55                   	push   %ebp
80105772:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105774:	ff 75 10             	pushl  0x10(%ebp)
80105777:	ff 75 0c             	pushl  0xc(%ebp)
8010577a:	ff 75 08             	pushl  0x8(%ebp)
8010577d:	e8 6d ff ff ff       	call   801056ef <memmove>
80105782:	83 c4 0c             	add    $0xc,%esp
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    

80105787 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105787:	55                   	push   %ebp
80105788:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010578a:	eb 0c                	jmp    80105798 <strncmp+0x11>
    n--, p++, q++;
8010578c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105790:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105794:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105798:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010579c:	74 1a                	je     801057b8 <strncmp+0x31>
8010579e:	8b 45 08             	mov    0x8(%ebp),%eax
801057a1:	0f b6 00             	movzbl (%eax),%eax
801057a4:	84 c0                	test   %al,%al
801057a6:	74 10                	je     801057b8 <strncmp+0x31>
801057a8:	8b 45 08             	mov    0x8(%ebp),%eax
801057ab:	0f b6 10             	movzbl (%eax),%edx
801057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b1:	0f b6 00             	movzbl (%eax),%eax
801057b4:	38 c2                	cmp    %al,%dl
801057b6:	74 d4                	je     8010578c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801057b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057bc:	75 07                	jne    801057c5 <strncmp+0x3e>
    return 0;
801057be:	b8 00 00 00 00       	mov    $0x0,%eax
801057c3:	eb 16                	jmp    801057db <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801057c5:	8b 45 08             	mov    0x8(%ebp),%eax
801057c8:	0f b6 00             	movzbl (%eax),%eax
801057cb:	0f b6 d0             	movzbl %al,%edx
801057ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d1:	0f b6 00             	movzbl (%eax),%eax
801057d4:	0f b6 c0             	movzbl %al,%eax
801057d7:	29 c2                	sub    %eax,%edx
801057d9:	89 d0                	mov    %edx,%eax
}
801057db:	5d                   	pop    %ebp
801057dc:	c3                   	ret    

801057dd <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057dd:	55                   	push   %ebp
801057de:	89 e5                	mov    %esp,%ebp
801057e0:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801057e3:	8b 45 08             	mov    0x8(%ebp),%eax
801057e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801057e9:	90                   	nop
801057ea:	8b 45 10             	mov    0x10(%ebp),%eax
801057ed:	8d 50 ff             	lea    -0x1(%eax),%edx
801057f0:	89 55 10             	mov    %edx,0x10(%ebp)
801057f3:	85 c0                	test   %eax,%eax
801057f5:	7e 1e                	jle    80105815 <strncpy+0x38>
801057f7:	8b 45 08             	mov    0x8(%ebp),%eax
801057fa:	8d 50 01             	lea    0x1(%eax),%edx
801057fd:	89 55 08             	mov    %edx,0x8(%ebp)
80105800:	8b 55 0c             	mov    0xc(%ebp),%edx
80105803:	8d 4a 01             	lea    0x1(%edx),%ecx
80105806:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105809:	0f b6 12             	movzbl (%edx),%edx
8010580c:	88 10                	mov    %dl,(%eax)
8010580e:	0f b6 00             	movzbl (%eax),%eax
80105811:	84 c0                	test   %al,%al
80105813:	75 d5                	jne    801057ea <strncpy+0xd>
    ;
  while(n-- > 0)
80105815:	eb 0c                	jmp    80105823 <strncpy+0x46>
    *s++ = 0;
80105817:	8b 45 08             	mov    0x8(%ebp),%eax
8010581a:	8d 50 01             	lea    0x1(%eax),%edx
8010581d:	89 55 08             	mov    %edx,0x8(%ebp)
80105820:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105823:	8b 45 10             	mov    0x10(%ebp),%eax
80105826:	8d 50 ff             	lea    -0x1(%eax),%edx
80105829:	89 55 10             	mov    %edx,0x10(%ebp)
8010582c:	85 c0                	test   %eax,%eax
8010582e:	7f e7                	jg     80105817 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105830:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105833:	c9                   	leave  
80105834:	c3                   	ret    

80105835 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105835:	55                   	push   %ebp
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010583b:	8b 45 08             	mov    0x8(%ebp),%eax
8010583e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105841:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105845:	7f 05                	jg     8010584c <safestrcpy+0x17>
    return os;
80105847:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010584a:	eb 31                	jmp    8010587d <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010584c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105850:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105854:	7e 1e                	jle    80105874 <safestrcpy+0x3f>
80105856:	8b 45 08             	mov    0x8(%ebp),%eax
80105859:	8d 50 01             	lea    0x1(%eax),%edx
8010585c:	89 55 08             	mov    %edx,0x8(%ebp)
8010585f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105862:	8d 4a 01             	lea    0x1(%edx),%ecx
80105865:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105868:	0f b6 12             	movzbl (%edx),%edx
8010586b:	88 10                	mov    %dl,(%eax)
8010586d:	0f b6 00             	movzbl (%eax),%eax
80105870:	84 c0                	test   %al,%al
80105872:	75 d8                	jne    8010584c <safestrcpy+0x17>
    ;
  *s = 0;
80105874:	8b 45 08             	mov    0x8(%ebp),%eax
80105877:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010587a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010587d:	c9                   	leave  
8010587e:	c3                   	ret    

8010587f <strlen>:

int
strlen(const char *s)
{
8010587f:	55                   	push   %ebp
80105880:	89 e5                	mov    %esp,%ebp
80105882:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010588c:	eb 04                	jmp    80105892 <strlen+0x13>
8010588e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105892:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105895:	8b 45 08             	mov    0x8(%ebp),%eax
80105898:	01 d0                	add    %edx,%eax
8010589a:	0f b6 00             	movzbl (%eax),%eax
8010589d:	84 c0                	test   %al,%al
8010589f:	75 ed                	jne    8010588e <strlen+0xf>
    ;
  return n;
801058a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058a4:	c9                   	leave  
801058a5:	c3                   	ret    

801058a6 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801058a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801058aa:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801058ae:	55                   	push   %ebp
  pushl %ebx
801058af:	53                   	push   %ebx
  pushl %esi
801058b0:	56                   	push   %esi
  pushl %edi
801058b1:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058b2:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058b4:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801058b6:	5f                   	pop    %edi
  popl %esi
801058b7:	5e                   	pop    %esi
  popl %ebx
801058b8:	5b                   	pop    %ebx
  popl %ebp
801058b9:	5d                   	pop    %ebp
  ret
801058ba:	c3                   	ret    

801058bb <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058bb:	55                   	push   %ebp
801058bc:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801058be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c4:	8b 00                	mov    (%eax),%eax
801058c6:	3b 45 08             	cmp    0x8(%ebp),%eax
801058c9:	76 12                	jbe    801058dd <fetchint+0x22>
801058cb:	8b 45 08             	mov    0x8(%ebp),%eax
801058ce:	8d 50 04             	lea    0x4(%eax),%edx
801058d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d7:	8b 00                	mov    (%eax),%eax
801058d9:	39 c2                	cmp    %eax,%edx
801058db:	76 07                	jbe    801058e4 <fetchint+0x29>
    return -1;
801058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e2:	eb 0f                	jmp    801058f3 <fetchint+0x38>
  *ip = *(int*)(addr);
801058e4:	8b 45 08             	mov    0x8(%ebp),%eax
801058e7:	8b 10                	mov    (%eax),%edx
801058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ec:	89 10                	mov    %edx,(%eax)
  return 0;
801058ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058f3:	5d                   	pop    %ebp
801058f4:	c3                   	ret    

801058f5 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058f5:	55                   	push   %ebp
801058f6:	89 e5                	mov    %esp,%ebp
801058f8:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801058fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105901:	8b 00                	mov    (%eax),%eax
80105903:	3b 45 08             	cmp    0x8(%ebp),%eax
80105906:	77 07                	ja     8010590f <fetchstr+0x1a>
    return -1;
80105908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590d:	eb 46                	jmp    80105955 <fetchstr+0x60>
  *pp = (char*)addr;
8010590f:	8b 55 08             	mov    0x8(%ebp),%edx
80105912:	8b 45 0c             	mov    0xc(%ebp),%eax
80105915:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105917:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010591d:	8b 00                	mov    (%eax),%eax
8010591f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105922:	8b 45 0c             	mov    0xc(%ebp),%eax
80105925:	8b 00                	mov    (%eax),%eax
80105927:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010592a:	eb 1c                	jmp    80105948 <fetchstr+0x53>
    if(*s == 0)
8010592c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010592f:	0f b6 00             	movzbl (%eax),%eax
80105932:	84 c0                	test   %al,%al
80105934:	75 0e                	jne    80105944 <fetchstr+0x4f>
      return s - *pp;
80105936:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105939:	8b 45 0c             	mov    0xc(%ebp),%eax
8010593c:	8b 00                	mov    (%eax),%eax
8010593e:	29 c2                	sub    %eax,%edx
80105940:	89 d0                	mov    %edx,%eax
80105942:	eb 11                	jmp    80105955 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105944:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105948:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010594b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010594e:	72 dc                	jb     8010592c <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    

80105957 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105957:	55                   	push   %ebp
80105958:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010595a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105960:	8b 40 18             	mov    0x18(%eax),%eax
80105963:	8b 40 44             	mov    0x44(%eax),%eax
80105966:	8b 55 08             	mov    0x8(%ebp),%edx
80105969:	c1 e2 02             	shl    $0x2,%edx
8010596c:	01 d0                	add    %edx,%eax
8010596e:	83 c0 04             	add    $0x4,%eax
80105971:	ff 75 0c             	pushl  0xc(%ebp)
80105974:	50                   	push   %eax
80105975:	e8 41 ff ff ff       	call   801058bb <fetchint>
8010597a:	83 c4 08             	add    $0x8,%esp
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    

8010597f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010597f:	55                   	push   %ebp
80105980:	89 e5                	mov    %esp,%ebp
80105982:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105985:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105988:	50                   	push   %eax
80105989:	ff 75 08             	pushl  0x8(%ebp)
8010598c:	e8 c6 ff ff ff       	call   80105957 <argint>
80105991:	83 c4 08             	add    $0x8,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	79 07                	jns    8010599f <argptr+0x20>
    return -1;
80105998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599d:	eb 3d                	jmp    801059dc <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010599f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059a2:	89 c2                	mov    %eax,%edx
801059a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059aa:	8b 00                	mov    (%eax),%eax
801059ac:	39 c2                	cmp    %eax,%edx
801059ae:	73 16                	jae    801059c6 <argptr+0x47>
801059b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059b3:	89 c2                	mov    %eax,%edx
801059b5:	8b 45 10             	mov    0x10(%ebp),%eax
801059b8:	01 c2                	add    %eax,%edx
801059ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059c0:	8b 00                	mov    (%eax),%eax
801059c2:	39 c2                	cmp    %eax,%edx
801059c4:	76 07                	jbe    801059cd <argptr+0x4e>
    return -1;
801059c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cb:	eb 0f                	jmp    801059dc <argptr+0x5d>
  *pp = (char*)i;
801059cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059d0:	89 c2                	mov    %eax,%edx
801059d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d5:	89 10                	mov    %edx,(%eax)
  return 0;
801059d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059dc:	c9                   	leave  
801059dd:	c3                   	ret    

801059de <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059de:	55                   	push   %ebp
801059df:	89 e5                	mov    %esp,%ebp
801059e1:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801059e4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059e7:	50                   	push   %eax
801059e8:	ff 75 08             	pushl  0x8(%ebp)
801059eb:	e8 67 ff ff ff       	call   80105957 <argint>
801059f0:	83 c4 08             	add    $0x8,%esp
801059f3:	85 c0                	test   %eax,%eax
801059f5:	79 07                	jns    801059fe <argstr+0x20>
    return -1;
801059f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fc:	eb 0f                	jmp    80105a0d <argstr+0x2f>
  return fetchstr(addr, pp);
801059fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a01:	ff 75 0c             	pushl  0xc(%ebp)
80105a04:	50                   	push   %eax
80105a05:	e8 eb fe ff ff       	call   801058f5 <fetchstr>
80105a0a:	83 c4 08             	add    $0x8,%esp
}
80105a0d:	c9                   	leave  
80105a0e:	c3                   	ret    

80105a0f <syscall>:
[SYS_semup] sys_semup,
};

void
syscall(void)
{
80105a0f:	55                   	push   %ebp
80105a10:	89 e5                	mov    %esp,%ebp
80105a12:	53                   	push   %ebx
80105a13:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a1c:	8b 40 18             	mov    0x18(%eax),%eax
80105a1f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a29:	7e 30                	jle    80105a5b <syscall+0x4c>
80105a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2e:	83 f8 1b             	cmp    $0x1b,%eax
80105a31:	77 28                	ja     80105a5b <syscall+0x4c>
80105a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a36:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	74 1a                	je     80105a5b <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a47:	8b 58 18             	mov    0x18(%eax),%ebx
80105a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a54:	ff d0                	call   *%eax
80105a56:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105a59:	eb 34                	jmp    80105a8f <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105a5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a61:	8d 50 6c             	lea    0x6c(%eax),%edx
80105a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a6a:	8b 40 10             	mov    0x10(%eax),%eax
80105a6d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a70:	52                   	push   %edx
80105a71:	50                   	push   %eax
80105a72:	68 f9 8f 10 80       	push   $0x80108ff9
80105a77:	e8 43 a9 ff ff       	call   801003bf <cprintf>
80105a7c:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105a7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a85:	8b 40 18             	mov    0x18(%eax),%eax
80105a88:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a92:	c9                   	leave  
80105a93:	c3                   	ret    

80105a94 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105a9a:	83 ec 08             	sub    $0x8,%esp
80105a9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aa0:	50                   	push   %eax
80105aa1:	ff 75 08             	pushl  0x8(%ebp)
80105aa4:	e8 ae fe ff ff       	call   80105957 <argint>
80105aa9:	83 c4 10             	add    $0x10,%esp
80105aac:	85 c0                	test   %eax,%eax
80105aae:	79 07                	jns    80105ab7 <argfd+0x23>
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab5:	eb 50                	jmp    80105b07 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aba:	85 c0                	test   %eax,%eax
80105abc:	78 21                	js     80105adf <argfd+0x4b>
80105abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac1:	83 f8 0f             	cmp    $0xf,%eax
80105ac4:	7f 19                	jg     80105adf <argfd+0x4b>
80105ac6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105acc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105acf:	83 c2 08             	add    $0x8,%edx
80105ad2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105add:	75 07                	jne    80105ae6 <argfd+0x52>
    return -1;
80105adf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae4:	eb 21                	jmp    80105b07 <argfd+0x73>
  if(pfd)
80105ae6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105aea:	74 08                	je     80105af4 <argfd+0x60>
    *pfd = fd;
80105aec:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aef:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af2:	89 10                	mov    %edx,(%eax)
  if(pf)
80105af4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105af8:	74 08                	je     80105b02 <argfd+0x6e>
    *pf = f;
80105afa:	8b 45 10             	mov    0x10(%ebp),%eax
80105afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b00:	89 10                	mov    %edx,(%eax)
  return 0;
80105b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b07:	c9                   	leave  
80105b08:	c3                   	ret    

80105b09 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b09:	55                   	push   %ebp
80105b0a:	89 e5                	mov    %esp,%ebp
80105b0c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b16:	eb 30                	jmp    80105b48 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b21:	83 c2 08             	add    $0x8,%edx
80105b24:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b28:	85 c0                	test   %eax,%eax
80105b2a:	75 18                	jne    80105b44 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b32:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b35:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b38:	8b 55 08             	mov    0x8(%ebp),%edx
80105b3b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b42:	eb 0f                	jmp    80105b53 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b44:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b48:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b4c:	7e ca                	jle    80105b18 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b53:	c9                   	leave  
80105b54:	c3                   	ret    

80105b55 <sys_dup>:

int
sys_dup(void)
{
80105b55:	55                   	push   %ebp
80105b56:	89 e5                	mov    %esp,%ebp
80105b58:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105b5b:	83 ec 04             	sub    $0x4,%esp
80105b5e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b61:	50                   	push   %eax
80105b62:	6a 00                	push   $0x0
80105b64:	6a 00                	push   $0x0
80105b66:	e8 29 ff ff ff       	call   80105a94 <argfd>
80105b6b:	83 c4 10             	add    $0x10,%esp
80105b6e:	85 c0                	test   %eax,%eax
80105b70:	79 07                	jns    80105b79 <sys_dup+0x24>
    return -1;
80105b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b77:	eb 31                	jmp    80105baa <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7c:	83 ec 0c             	sub    $0xc,%esp
80105b7f:	50                   	push   %eax
80105b80:	e8 84 ff ff ff       	call   80105b09 <fdalloc>
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b8f:	79 07                	jns    80105b98 <sys_dup+0x43>
    return -1;
80105b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b96:	eb 12                	jmp    80105baa <sys_dup+0x55>
  filedup(f);
80105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9b:	83 ec 0c             	sub    $0xc,%esp
80105b9e:	50                   	push   %eax
80105b9f:	e8 23 b4 ff ff       	call   80100fc7 <filedup>
80105ba4:	83 c4 10             	add    $0x10,%esp
  return fd;
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105baa:	c9                   	leave  
80105bab:	c3                   	ret    

80105bac <sys_read>:

int
sys_read(void)
{
80105bac:	55                   	push   %ebp
80105bad:	89 e5                	mov    %esp,%ebp
80105baf:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bb2:	83 ec 04             	sub    $0x4,%esp
80105bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb8:	50                   	push   %eax
80105bb9:	6a 00                	push   $0x0
80105bbb:	6a 00                	push   $0x0
80105bbd:	e8 d2 fe ff ff       	call   80105a94 <argfd>
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	78 2e                	js     80105bf7 <sys_read+0x4b>
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bcf:	50                   	push   %eax
80105bd0:	6a 02                	push   $0x2
80105bd2:	e8 80 fd ff ff       	call   80105957 <argint>
80105bd7:	83 c4 10             	add    $0x10,%esp
80105bda:	85 c0                	test   %eax,%eax
80105bdc:	78 19                	js     80105bf7 <sys_read+0x4b>
80105bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be1:	83 ec 04             	sub    $0x4,%esp
80105be4:	50                   	push   %eax
80105be5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be8:	50                   	push   %eax
80105be9:	6a 01                	push   $0x1
80105beb:	e8 8f fd ff ff       	call   8010597f <argptr>
80105bf0:	83 c4 10             	add    $0x10,%esp
80105bf3:	85 c0                	test   %eax,%eax
80105bf5:	79 07                	jns    80105bfe <sys_read+0x52>
    return -1;
80105bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfc:	eb 17                	jmp    80105c15 <sys_read+0x69>
  return fileread(f, p, n);
80105bfe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c01:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c07:	83 ec 04             	sub    $0x4,%esp
80105c0a:	51                   	push   %ecx
80105c0b:	52                   	push   %edx
80105c0c:	50                   	push   %eax
80105c0d:	e8 45 b5 ff ff       	call   80101157 <fileread>
80105c12:	83 c4 10             	add    $0x10,%esp
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    

80105c17 <sys_write>:

int
sys_write(void)
{
80105c17:	55                   	push   %ebp
80105c18:	89 e5                	mov    %esp,%ebp
80105c1a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c1d:	83 ec 04             	sub    $0x4,%esp
80105c20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c23:	50                   	push   %eax
80105c24:	6a 00                	push   $0x0
80105c26:	6a 00                	push   $0x0
80105c28:	e8 67 fe ff ff       	call   80105a94 <argfd>
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	85 c0                	test   %eax,%eax
80105c32:	78 2e                	js     80105c62 <sys_write+0x4b>
80105c34:	83 ec 08             	sub    $0x8,%esp
80105c37:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c3a:	50                   	push   %eax
80105c3b:	6a 02                	push   $0x2
80105c3d:	e8 15 fd ff ff       	call   80105957 <argint>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	78 19                	js     80105c62 <sys_write+0x4b>
80105c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4c:	83 ec 04             	sub    $0x4,%esp
80105c4f:	50                   	push   %eax
80105c50:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c53:	50                   	push   %eax
80105c54:	6a 01                	push   $0x1
80105c56:	e8 24 fd ff ff       	call   8010597f <argptr>
80105c5b:	83 c4 10             	add    $0x10,%esp
80105c5e:	85 c0                	test   %eax,%eax
80105c60:	79 07                	jns    80105c69 <sys_write+0x52>
    return -1;
80105c62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c67:	eb 17                	jmp    80105c80 <sys_write+0x69>
  return filewrite(f, p, n);
80105c69:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c72:	83 ec 04             	sub    $0x4,%esp
80105c75:	51                   	push   %ecx
80105c76:	52                   	push   %edx
80105c77:	50                   	push   %eax
80105c78:	e8 92 b5 ff ff       	call   8010120f <filewrite>
80105c7d:	83 c4 10             	add    $0x10,%esp
}
80105c80:	c9                   	leave  
80105c81:	c3                   	ret    

80105c82 <sys_close>:

int
sys_close(void)
{
80105c82:	55                   	push   %ebp
80105c83:	89 e5                	mov    %esp,%ebp
80105c85:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c88:	83 ec 04             	sub    $0x4,%esp
80105c8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8e:	50                   	push   %eax
80105c8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c92:	50                   	push   %eax
80105c93:	6a 00                	push   $0x0
80105c95:	e8 fa fd ff ff       	call   80105a94 <argfd>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	79 07                	jns    80105ca8 <sys_close+0x26>
    return -1;
80105ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca6:	eb 28                	jmp    80105cd0 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105ca8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cb1:	83 c2 08             	add    $0x8,%edx
80105cb4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cbb:	00 
  fileclose(f);
80105cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbf:	83 ec 0c             	sub    $0xc,%esp
80105cc2:	50                   	push   %eax
80105cc3:	e8 50 b3 ff ff       	call   80101018 <fileclose>
80105cc8:	83 c4 10             	add    $0x10,%esp
  return 0;
80105ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cd0:	c9                   	leave  
80105cd1:	c3                   	ret    

80105cd2 <sys_fstat>:

int
sys_fstat(void)
{
80105cd2:	55                   	push   %ebp
80105cd3:	89 e5                	mov    %esp,%ebp
80105cd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cd8:	83 ec 04             	sub    $0x4,%esp
80105cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cde:	50                   	push   %eax
80105cdf:	6a 00                	push   $0x0
80105ce1:	6a 00                	push   $0x0
80105ce3:	e8 ac fd ff ff       	call   80105a94 <argfd>
80105ce8:	83 c4 10             	add    $0x10,%esp
80105ceb:	85 c0                	test   %eax,%eax
80105ced:	78 17                	js     80105d06 <sys_fstat+0x34>
80105cef:	83 ec 04             	sub    $0x4,%esp
80105cf2:	6a 14                	push   $0x14
80105cf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cf7:	50                   	push   %eax
80105cf8:	6a 01                	push   $0x1
80105cfa:	e8 80 fc ff ff       	call   8010597f <argptr>
80105cff:	83 c4 10             	add    $0x10,%esp
80105d02:	85 c0                	test   %eax,%eax
80105d04:	79 07                	jns    80105d0d <sys_fstat+0x3b>
    return -1;
80105d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0b:	eb 13                	jmp    80105d20 <sys_fstat+0x4e>
  return filestat(f, st);
80105d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d13:	83 ec 08             	sub    $0x8,%esp
80105d16:	52                   	push   %edx
80105d17:	50                   	push   %eax
80105d18:	e8 e3 b3 ff ff       	call   80101100 <filestat>
80105d1d:	83 c4 10             	add    $0x10,%esp
}
80105d20:	c9                   	leave  
80105d21:	c3                   	ret    

80105d22 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d22:	55                   	push   %ebp
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d28:	83 ec 08             	sub    $0x8,%esp
80105d2b:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d2e:	50                   	push   %eax
80105d2f:	6a 00                	push   $0x0
80105d31:	e8 a8 fc ff ff       	call   801059de <argstr>
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	78 15                	js     80105d52 <sys_link+0x30>
80105d3d:	83 ec 08             	sub    $0x8,%esp
80105d40:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d43:	50                   	push   %eax
80105d44:	6a 01                	push   $0x1
80105d46:	e8 93 fc ff ff       	call   801059de <argstr>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	85 c0                	test   %eax,%eax
80105d50:	79 0a                	jns    80105d5c <sys_link+0x3a>
    return -1;
80105d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d57:	e9 69 01 00 00       	jmp    80105ec5 <sys_link+0x1a3>

  begin_op();
80105d5c:	e8 11 d7 ff ff       	call   80103472 <begin_op>
  if((ip = namei(old)) == 0){
80105d61:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105d64:	83 ec 0c             	sub    $0xc,%esp
80105d67:	50                   	push   %eax
80105d68:	e8 30 c7 ff ff       	call   8010249d <namei>
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d77:	75 0f                	jne    80105d88 <sys_link+0x66>
    end_op();
80105d79:	e8 82 d7 ff ff       	call   80103500 <end_op>
    return -1;
80105d7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d83:	e9 3d 01 00 00       	jmp    80105ec5 <sys_link+0x1a3>
  }

  ilock(ip);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 47 bb ff ff       	call   801018da <ilock>
80105d93:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d99:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d9d:	66 83 f8 01          	cmp    $0x1,%ax
80105da1:	75 1d                	jne    80105dc0 <sys_link+0x9e>
    iunlockput(ip);
80105da3:	83 ec 0c             	sub    $0xc,%esp
80105da6:	ff 75 f4             	pushl  -0xc(%ebp)
80105da9:	e8 e3 bd ff ff       	call   80101b91 <iunlockput>
80105dae:	83 c4 10             	add    $0x10,%esp
    end_op();
80105db1:	e8 4a d7 ff ff       	call   80103500 <end_op>
    return -1;
80105db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbb:	e9 05 01 00 00       	jmp    80105ec5 <sys_link+0x1a3>
  }

  ip->nlink++;
80105dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dc7:	83 c0 01             	add    $0x1,%eax
80105dca:	89 c2                	mov    %eax,%edx
80105dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcf:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dd3:	83 ec 0c             	sub    $0xc,%esp
80105dd6:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd9:	e8 29 b9 ff ff       	call   80101707 <iupdate>
80105dde:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105de1:	83 ec 0c             	sub    $0xc,%esp
80105de4:	ff 75 f4             	pushl  -0xc(%ebp)
80105de7:	e8 45 bc ff ff       	call   80101a31 <iunlock>
80105dec:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105def:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105df2:	83 ec 08             	sub    $0x8,%esp
80105df5:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105df8:	52                   	push   %edx
80105df9:	50                   	push   %eax
80105dfa:	e8 ba c6 ff ff       	call   801024b9 <nameiparent>
80105dff:	83 c4 10             	add    $0x10,%esp
80105e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e09:	75 02                	jne    80105e0d <sys_link+0xeb>
    goto bad;
80105e0b:	eb 71                	jmp    80105e7e <sys_link+0x15c>
  ilock(dp);
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	ff 75 f0             	pushl  -0x10(%ebp)
80105e13:	e8 c2 ba ff ff       	call   801018da <ilock>
80105e18:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1e:	8b 10                	mov    (%eax),%edx
80105e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e23:	8b 00                	mov    (%eax),%eax
80105e25:	39 c2                	cmp    %eax,%edx
80105e27:	75 1d                	jne    80105e46 <sys_link+0x124>
80105e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2c:	8b 40 04             	mov    0x4(%eax),%eax
80105e2f:	83 ec 04             	sub    $0x4,%esp
80105e32:	50                   	push   %eax
80105e33:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e36:	50                   	push   %eax
80105e37:	ff 75 f0             	pushl  -0x10(%ebp)
80105e3a:	e8 c6 c3 ff ff       	call   80102205 <dirlink>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	85 c0                	test   %eax,%eax
80105e44:	79 10                	jns    80105e56 <sys_link+0x134>
    iunlockput(dp);
80105e46:	83 ec 0c             	sub    $0xc,%esp
80105e49:	ff 75 f0             	pushl  -0x10(%ebp)
80105e4c:	e8 40 bd ff ff       	call   80101b91 <iunlockput>
80105e51:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e54:	eb 28                	jmp    80105e7e <sys_link+0x15c>
  }
  iunlockput(dp);
80105e56:	83 ec 0c             	sub    $0xc,%esp
80105e59:	ff 75 f0             	pushl  -0x10(%ebp)
80105e5c:	e8 30 bd ff ff       	call   80101b91 <iunlockput>
80105e61:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	ff 75 f4             	pushl  -0xc(%ebp)
80105e6a:	e8 33 bc ff ff       	call   80101aa2 <iput>
80105e6f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e72:	e8 89 d6 ff ff       	call   80103500 <end_op>

  return 0;
80105e77:	b8 00 00 00 00       	mov    $0x0,%eax
80105e7c:	eb 47                	jmp    80105ec5 <sys_link+0x1a3>

bad:
  ilock(ip);
80105e7e:	83 ec 0c             	sub    $0xc,%esp
80105e81:	ff 75 f4             	pushl  -0xc(%ebp)
80105e84:	e8 51 ba ff ff       	call   801018da <ilock>
80105e89:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e93:	83 e8 01             	sub    $0x1,%eax
80105e96:	89 c2                	mov    %eax,%edx
80105e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e9f:	83 ec 0c             	sub    $0xc,%esp
80105ea2:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea5:	e8 5d b8 ff ff       	call   80101707 <iupdate>
80105eaa:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105ead:	83 ec 0c             	sub    $0xc,%esp
80105eb0:	ff 75 f4             	pushl  -0xc(%ebp)
80105eb3:	e8 d9 bc ff ff       	call   80101b91 <iunlockput>
80105eb8:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ebb:	e8 40 d6 ff ff       	call   80103500 <end_op>
  return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    

80105ec7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ec7:	55                   	push   %ebp
80105ec8:	89 e5                	mov    %esp,%ebp
80105eca:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ecd:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ed4:	eb 40                	jmp    80105f16 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed9:	6a 10                	push   $0x10
80105edb:	50                   	push   %eax
80105edc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105edf:	50                   	push   %eax
80105ee0:	ff 75 08             	pushl  0x8(%ebp)
80105ee3:	e8 54 bf ff ff       	call   80101e3c <readi>
80105ee8:	83 c4 10             	add    $0x10,%esp
80105eeb:	83 f8 10             	cmp    $0x10,%eax
80105eee:	74 0d                	je     80105efd <isdirempty+0x36>
      panic("isdirempty: readi");
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	68 15 90 10 80       	push   $0x80109015
80105ef8:	e8 5f a6 ff ff       	call   8010055c <panic>
    if(de.inum != 0)
80105efd:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105f01:	66 85 c0             	test   %ax,%ax
80105f04:	74 07                	je     80105f0d <isdirempty+0x46>
      return 0;
80105f06:	b8 00 00 00 00       	mov    $0x0,%eax
80105f0b:	eb 1b                	jmp    80105f28 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f10:	83 c0 10             	add    $0x10,%eax
80105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f19:	8b 45 08             	mov    0x8(%ebp),%eax
80105f1c:	8b 40 18             	mov    0x18(%eax),%eax
80105f1f:	39 c2                	cmp    %eax,%edx
80105f21:	72 b3                	jb     80105ed6 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f23:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f28:	c9                   	leave  
80105f29:	c3                   	ret    

80105f2a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f2a:	55                   	push   %ebp
80105f2b:	89 e5                	mov    %esp,%ebp
80105f2d:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f30:	83 ec 08             	sub    $0x8,%esp
80105f33:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f36:	50                   	push   %eax
80105f37:	6a 00                	push   $0x0
80105f39:	e8 a0 fa ff ff       	call   801059de <argstr>
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	85 c0                	test   %eax,%eax
80105f43:	79 0a                	jns    80105f4f <sys_unlink+0x25>
    return -1;
80105f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4a:	e9 bc 01 00 00       	jmp    8010610b <sys_unlink+0x1e1>

  begin_op();
80105f4f:	e8 1e d5 ff ff       	call   80103472 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f57:	83 ec 08             	sub    $0x8,%esp
80105f5a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105f5d:	52                   	push   %edx
80105f5e:	50                   	push   %eax
80105f5f:	e8 55 c5 ff ff       	call   801024b9 <nameiparent>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f6e:	75 0f                	jne    80105f7f <sys_unlink+0x55>
    end_op();
80105f70:	e8 8b d5 ff ff       	call   80103500 <end_op>
    return -1;
80105f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7a:	e9 8c 01 00 00       	jmp    8010610b <sys_unlink+0x1e1>
  }

  ilock(dp);
80105f7f:	83 ec 0c             	sub    $0xc,%esp
80105f82:	ff 75 f4             	pushl  -0xc(%ebp)
80105f85:	e8 50 b9 ff ff       	call   801018da <ilock>
80105f8a:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f8d:	83 ec 08             	sub    $0x8,%esp
80105f90:	68 27 90 10 80       	push   $0x80109027
80105f95:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f98:	50                   	push   %eax
80105f99:	e8 91 c1 ff ff       	call   8010212f <namecmp>
80105f9e:	83 c4 10             	add    $0x10,%esp
80105fa1:	85 c0                	test   %eax,%eax
80105fa3:	0f 84 4a 01 00 00    	je     801060f3 <sys_unlink+0x1c9>
80105fa9:	83 ec 08             	sub    $0x8,%esp
80105fac:	68 29 90 10 80       	push   $0x80109029
80105fb1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fb4:	50                   	push   %eax
80105fb5:	e8 75 c1 ff ff       	call   8010212f <namecmp>
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	85 c0                	test   %eax,%eax
80105fbf:	0f 84 2e 01 00 00    	je     801060f3 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105fc5:	83 ec 04             	sub    $0x4,%esp
80105fc8:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105fcb:	50                   	push   %eax
80105fcc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fcf:	50                   	push   %eax
80105fd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd3:	e8 72 c1 ff ff       	call   8010214a <dirlookup>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fe2:	75 05                	jne    80105fe9 <sys_unlink+0xbf>
    goto bad;
80105fe4:	e9 0a 01 00 00       	jmp    801060f3 <sys_unlink+0x1c9>
  ilock(ip);
80105fe9:	83 ec 0c             	sub    $0xc,%esp
80105fec:	ff 75 f0             	pushl  -0x10(%ebp)
80105fef:	e8 e6 b8 ff ff       	call   801018da <ilock>
80105ff4:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ffe:	66 85 c0             	test   %ax,%ax
80106001:	7f 0d                	jg     80106010 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80106003:	83 ec 0c             	sub    $0xc,%esp
80106006:	68 2c 90 10 80       	push   $0x8010902c
8010600b:	e8 4c a5 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106010:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106013:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106017:	66 83 f8 01          	cmp    $0x1,%ax
8010601b:	75 25                	jne    80106042 <sys_unlink+0x118>
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	ff 75 f0             	pushl  -0x10(%ebp)
80106023:	e8 9f fe ff ff       	call   80105ec7 <isdirempty>
80106028:	83 c4 10             	add    $0x10,%esp
8010602b:	85 c0                	test   %eax,%eax
8010602d:	75 13                	jne    80106042 <sys_unlink+0x118>
    iunlockput(ip);
8010602f:	83 ec 0c             	sub    $0xc,%esp
80106032:	ff 75 f0             	pushl  -0x10(%ebp)
80106035:	e8 57 bb ff ff       	call   80101b91 <iunlockput>
8010603a:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010603d:	e9 b1 00 00 00       	jmp    801060f3 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106042:	83 ec 04             	sub    $0x4,%esp
80106045:	6a 10                	push   $0x10
80106047:	6a 00                	push   $0x0
80106049:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010604c:	50                   	push   %eax
8010604d:	e8 de f5 ff ff       	call   80105630 <memset>
80106052:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106055:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106058:	6a 10                	push   $0x10
8010605a:	50                   	push   %eax
8010605b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010605e:	50                   	push   %eax
8010605f:	ff 75 f4             	pushl  -0xc(%ebp)
80106062:	e8 36 bf ff ff       	call   80101f9d <writei>
80106067:	83 c4 10             	add    $0x10,%esp
8010606a:	83 f8 10             	cmp    $0x10,%eax
8010606d:	74 0d                	je     8010607c <sys_unlink+0x152>
    panic("unlink: writei");
8010606f:	83 ec 0c             	sub    $0xc,%esp
80106072:	68 3e 90 10 80       	push   $0x8010903e
80106077:	e8 e0 a4 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
8010607c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106083:	66 83 f8 01          	cmp    $0x1,%ax
80106087:	75 21                	jne    801060aa <sys_unlink+0x180>
    dp->nlink--;
80106089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106090:	83 e8 01             	sub    $0x1,%eax
80106093:	89 c2                	mov    %eax,%edx
80106095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106098:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010609c:	83 ec 0c             	sub    $0xc,%esp
8010609f:	ff 75 f4             	pushl  -0xc(%ebp)
801060a2:	e8 60 b6 ff ff       	call   80101707 <iupdate>
801060a7:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801060aa:	83 ec 0c             	sub    $0xc,%esp
801060ad:	ff 75 f4             	pushl  -0xc(%ebp)
801060b0:	e8 dc ba ff ff       	call   80101b91 <iunlockput>
801060b5:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060bf:	83 e8 01             	sub    $0x1,%eax
801060c2:	89 c2                	mov    %eax,%edx
801060c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801060cb:	83 ec 0c             	sub    $0xc,%esp
801060ce:	ff 75 f0             	pushl  -0x10(%ebp)
801060d1:	e8 31 b6 ff ff       	call   80101707 <iupdate>
801060d6:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801060d9:	83 ec 0c             	sub    $0xc,%esp
801060dc:	ff 75 f0             	pushl  -0x10(%ebp)
801060df:	e8 ad ba ff ff       	call   80101b91 <iunlockput>
801060e4:	83 c4 10             	add    $0x10,%esp

  end_op();
801060e7:	e8 14 d4 ff ff       	call   80103500 <end_op>

  return 0;
801060ec:	b8 00 00 00 00       	mov    $0x0,%eax
801060f1:	eb 18                	jmp    8010610b <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
801060f3:	83 ec 0c             	sub    $0xc,%esp
801060f6:	ff 75 f4             	pushl  -0xc(%ebp)
801060f9:	e8 93 ba ff ff       	call   80101b91 <iunlockput>
801060fe:	83 c4 10             	add    $0x10,%esp
  end_op();
80106101:	e8 fa d3 ff ff       	call   80103500 <end_op>
  return -1;
80106106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010610b:	c9                   	leave  
8010610c:	c3                   	ret    

8010610d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010610d:	55                   	push   %ebp
8010610e:	89 e5                	mov    %esp,%ebp
80106110:	83 ec 38             	sub    $0x38,%esp
80106113:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106116:	8b 55 10             	mov    0x10(%ebp),%edx
80106119:	8b 45 14             	mov    0x14(%ebp),%eax
8010611c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106120:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106124:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106128:	83 ec 08             	sub    $0x8,%esp
8010612b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010612e:	50                   	push   %eax
8010612f:	ff 75 08             	pushl  0x8(%ebp)
80106132:	e8 82 c3 ff ff       	call   801024b9 <nameiparent>
80106137:	83 c4 10             	add    $0x10,%esp
8010613a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010613d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106141:	75 0a                	jne    8010614d <create+0x40>
    return 0;
80106143:	b8 00 00 00 00       	mov    $0x0,%eax
80106148:	e9 90 01 00 00       	jmp    801062dd <create+0x1d0>
  ilock(dp);
8010614d:	83 ec 0c             	sub    $0xc,%esp
80106150:	ff 75 f4             	pushl  -0xc(%ebp)
80106153:	e8 82 b7 ff ff       	call   801018da <ilock>
80106158:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010615b:	83 ec 04             	sub    $0x4,%esp
8010615e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106161:	50                   	push   %eax
80106162:	8d 45 de             	lea    -0x22(%ebp),%eax
80106165:	50                   	push   %eax
80106166:	ff 75 f4             	pushl  -0xc(%ebp)
80106169:	e8 dc bf ff ff       	call   8010214a <dirlookup>
8010616e:	83 c4 10             	add    $0x10,%esp
80106171:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106178:	74 50                	je     801061ca <create+0xbd>
    iunlockput(dp);
8010617a:	83 ec 0c             	sub    $0xc,%esp
8010617d:	ff 75 f4             	pushl  -0xc(%ebp)
80106180:	e8 0c ba ff ff       	call   80101b91 <iunlockput>
80106185:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	ff 75 f0             	pushl  -0x10(%ebp)
8010618e:	e8 47 b7 ff ff       	call   801018da <ilock>
80106193:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106196:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010619b:	75 15                	jne    801061b2 <create+0xa5>
8010619d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061a4:	66 83 f8 02          	cmp    $0x2,%ax
801061a8:	75 08                	jne    801061b2 <create+0xa5>
      return ip;
801061aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ad:	e9 2b 01 00 00       	jmp    801062dd <create+0x1d0>
    iunlockput(ip);
801061b2:	83 ec 0c             	sub    $0xc,%esp
801061b5:	ff 75 f0             	pushl  -0x10(%ebp)
801061b8:	e8 d4 b9 ff ff       	call   80101b91 <iunlockput>
801061bd:	83 c4 10             	add    $0x10,%esp
    return 0;
801061c0:	b8 00 00 00 00       	mov    $0x0,%eax
801061c5:	e9 13 01 00 00       	jmp    801062dd <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801061ca:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801061ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d1:	8b 00                	mov    (%eax),%eax
801061d3:	83 ec 08             	sub    $0x8,%esp
801061d6:	52                   	push   %edx
801061d7:	50                   	push   %eax
801061d8:	e8 49 b4 ff ff       	call   80101626 <ialloc>
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061e7:	75 0d                	jne    801061f6 <create+0xe9>
    panic("create: ialloc");
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	68 4d 90 10 80       	push   $0x8010904d
801061f1:	e8 66 a3 ff ff       	call   8010055c <panic>

  ilock(ip);
801061f6:	83 ec 0c             	sub    $0xc,%esp
801061f9:	ff 75 f0             	pushl  -0x10(%ebp)
801061fc:	e8 d9 b6 ff ff       	call   801018da <ilock>
80106201:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106204:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106207:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010620b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106216:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010621a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106223:	83 ec 0c             	sub    $0xc,%esp
80106226:	ff 75 f0             	pushl  -0x10(%ebp)
80106229:	e8 d9 b4 ff ff       	call   80101707 <iupdate>
8010622e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106231:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106236:	75 6a                	jne    801062a2 <create+0x195>
    dp->nlink++;  // for ".."
80106238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010623f:	83 c0 01             	add    $0x1,%eax
80106242:	89 c2                	mov    %eax,%edx
80106244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106247:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010624b:	83 ec 0c             	sub    $0xc,%esp
8010624e:	ff 75 f4             	pushl  -0xc(%ebp)
80106251:	e8 b1 b4 ff ff       	call   80101707 <iupdate>
80106256:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625c:	8b 40 04             	mov    0x4(%eax),%eax
8010625f:	83 ec 04             	sub    $0x4,%esp
80106262:	50                   	push   %eax
80106263:	68 27 90 10 80       	push   $0x80109027
80106268:	ff 75 f0             	pushl  -0x10(%ebp)
8010626b:	e8 95 bf ff ff       	call   80102205 <dirlink>
80106270:	83 c4 10             	add    $0x10,%esp
80106273:	85 c0                	test   %eax,%eax
80106275:	78 1e                	js     80106295 <create+0x188>
80106277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627a:	8b 40 04             	mov    0x4(%eax),%eax
8010627d:	83 ec 04             	sub    $0x4,%esp
80106280:	50                   	push   %eax
80106281:	68 29 90 10 80       	push   $0x80109029
80106286:	ff 75 f0             	pushl  -0x10(%ebp)
80106289:	e8 77 bf ff ff       	call   80102205 <dirlink>
8010628e:	83 c4 10             	add    $0x10,%esp
80106291:	85 c0                	test   %eax,%eax
80106293:	79 0d                	jns    801062a2 <create+0x195>
      panic("create dots");
80106295:	83 ec 0c             	sub    $0xc,%esp
80106298:	68 5c 90 10 80       	push   $0x8010905c
8010629d:	e8 ba a2 ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801062a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a5:	8b 40 04             	mov    0x4(%eax),%eax
801062a8:	83 ec 04             	sub    $0x4,%esp
801062ab:	50                   	push   %eax
801062ac:	8d 45 de             	lea    -0x22(%ebp),%eax
801062af:	50                   	push   %eax
801062b0:	ff 75 f4             	pushl  -0xc(%ebp)
801062b3:	e8 4d bf ff ff       	call   80102205 <dirlink>
801062b8:	83 c4 10             	add    $0x10,%esp
801062bb:	85 c0                	test   %eax,%eax
801062bd:	79 0d                	jns    801062cc <create+0x1bf>
    panic("create: dirlink");
801062bf:	83 ec 0c             	sub    $0xc,%esp
801062c2:	68 68 90 10 80       	push   $0x80109068
801062c7:	e8 90 a2 ff ff       	call   8010055c <panic>

  iunlockput(dp);
801062cc:	83 ec 0c             	sub    $0xc,%esp
801062cf:	ff 75 f4             	pushl  -0xc(%ebp)
801062d2:	e8 ba b8 ff ff       	call   80101b91 <iunlockput>
801062d7:	83 c4 10             	add    $0x10,%esp

  return ip;
801062da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801062dd:	c9                   	leave  
801062de:	c3                   	ret    

801062df <sys_open>:

int
sys_open(void)
{
801062df:	55                   	push   %ebp
801062e0:	89 e5                	mov    %esp,%ebp
801062e2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801062e5:	83 ec 08             	sub    $0x8,%esp
801062e8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062eb:	50                   	push   %eax
801062ec:	6a 00                	push   $0x0
801062ee:	e8 eb f6 ff ff       	call   801059de <argstr>
801062f3:	83 c4 10             	add    $0x10,%esp
801062f6:	85 c0                	test   %eax,%eax
801062f8:	78 15                	js     8010630f <sys_open+0x30>
801062fa:	83 ec 08             	sub    $0x8,%esp
801062fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106300:	50                   	push   %eax
80106301:	6a 01                	push   $0x1
80106303:	e8 4f f6 ff ff       	call   80105957 <argint>
80106308:	83 c4 10             	add    $0x10,%esp
8010630b:	85 c0                	test   %eax,%eax
8010630d:	79 0a                	jns    80106319 <sys_open+0x3a>
    return -1;
8010630f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106314:	e9 61 01 00 00       	jmp    8010647a <sys_open+0x19b>

  begin_op();
80106319:	e8 54 d1 ff ff       	call   80103472 <begin_op>

  if(omode & O_CREATE){
8010631e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106321:	25 00 02 00 00       	and    $0x200,%eax
80106326:	85 c0                	test   %eax,%eax
80106328:	74 2a                	je     80106354 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010632a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010632d:	6a 00                	push   $0x0
8010632f:	6a 00                	push   $0x0
80106331:	6a 02                	push   $0x2
80106333:	50                   	push   %eax
80106334:	e8 d4 fd ff ff       	call   8010610d <create>
80106339:	83 c4 10             	add    $0x10,%esp
8010633c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010633f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106343:	75 75                	jne    801063ba <sys_open+0xdb>
      end_op();
80106345:	e8 b6 d1 ff ff       	call   80103500 <end_op>
      return -1;
8010634a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634f:	e9 26 01 00 00       	jmp    8010647a <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106354:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106357:	83 ec 0c             	sub    $0xc,%esp
8010635a:	50                   	push   %eax
8010635b:	e8 3d c1 ff ff       	call   8010249d <namei>
80106360:	83 c4 10             	add    $0x10,%esp
80106363:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010636a:	75 0f                	jne    8010637b <sys_open+0x9c>
      end_op();
8010636c:	e8 8f d1 ff ff       	call   80103500 <end_op>
      return -1;
80106371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106376:	e9 ff 00 00 00       	jmp    8010647a <sys_open+0x19b>
    }
    ilock(ip);
8010637b:	83 ec 0c             	sub    $0xc,%esp
8010637e:	ff 75 f4             	pushl  -0xc(%ebp)
80106381:	e8 54 b5 ff ff       	call   801018da <ilock>
80106386:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106390:	66 83 f8 01          	cmp    $0x1,%ax
80106394:	75 24                	jne    801063ba <sys_open+0xdb>
80106396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106399:	85 c0                	test   %eax,%eax
8010639b:	74 1d                	je     801063ba <sys_open+0xdb>
      iunlockput(ip);
8010639d:	83 ec 0c             	sub    $0xc,%esp
801063a0:	ff 75 f4             	pushl  -0xc(%ebp)
801063a3:	e8 e9 b7 ff ff       	call   80101b91 <iunlockput>
801063a8:	83 c4 10             	add    $0x10,%esp
      end_op();
801063ab:	e8 50 d1 ff ff       	call   80103500 <end_op>
      return -1;
801063b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b5:	e9 c0 00 00 00       	jmp    8010647a <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801063ba:	e8 9c ab ff ff       	call   80100f5b <filealloc>
801063bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063c6:	74 17                	je     801063df <sys_open+0x100>
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f0             	pushl  -0x10(%ebp)
801063ce:	e8 36 f7 ff ff       	call   80105b09 <fdalloc>
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801063d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801063dd:	79 2e                	jns    8010640d <sys_open+0x12e>
    if(f)
801063df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063e3:	74 0e                	je     801063f3 <sys_open+0x114>
      fileclose(f);
801063e5:	83 ec 0c             	sub    $0xc,%esp
801063e8:	ff 75 f0             	pushl  -0x10(%ebp)
801063eb:	e8 28 ac ff ff       	call   80101018 <fileclose>
801063f0:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063f3:	83 ec 0c             	sub    $0xc,%esp
801063f6:	ff 75 f4             	pushl  -0xc(%ebp)
801063f9:	e8 93 b7 ff ff       	call   80101b91 <iunlockput>
801063fe:	83 c4 10             	add    $0x10,%esp
    end_op();
80106401:	e8 fa d0 ff ff       	call   80103500 <end_op>
    return -1;
80106406:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640b:	eb 6d                	jmp    8010647a <sys_open+0x19b>
  }
  iunlock(ip);
8010640d:	83 ec 0c             	sub    $0xc,%esp
80106410:	ff 75 f4             	pushl  -0xc(%ebp)
80106413:	e8 19 b6 ff ff       	call   80101a31 <iunlock>
80106418:	83 c4 10             	add    $0x10,%esp
  end_op();
8010641b:	e8 e0 d0 ff ff       	call   80103500 <end_op>

  f->type = FD_INODE;
80106420:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106423:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010642f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106432:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106435:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010643c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010643f:	83 e0 01             	and    $0x1,%eax
80106442:	85 c0                	test   %eax,%eax
80106444:	0f 94 c0             	sete   %al
80106447:	89 c2                	mov    %eax,%edx
80106449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010644f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106452:	83 e0 01             	and    $0x1,%eax
80106455:	85 c0                	test   %eax,%eax
80106457:	75 0a                	jne    80106463 <sys_open+0x184>
80106459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010645c:	83 e0 02             	and    $0x2,%eax
8010645f:	85 c0                	test   %eax,%eax
80106461:	74 07                	je     8010646a <sys_open+0x18b>
80106463:	b8 01 00 00 00       	mov    $0x1,%eax
80106468:	eb 05                	jmp    8010646f <sys_open+0x190>
8010646a:	b8 00 00 00 00       	mov    $0x0,%eax
8010646f:	89 c2                	mov    %eax,%edx
80106471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106474:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106477:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010647a:	c9                   	leave  
8010647b:	c3                   	ret    

8010647c <sys_mkdir>:

int
sys_mkdir(void)
{
8010647c:	55                   	push   %ebp
8010647d:	89 e5                	mov    %esp,%ebp
8010647f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106482:	e8 eb cf ff ff       	call   80103472 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106487:	83 ec 08             	sub    $0x8,%esp
8010648a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010648d:	50                   	push   %eax
8010648e:	6a 00                	push   $0x0
80106490:	e8 49 f5 ff ff       	call   801059de <argstr>
80106495:	83 c4 10             	add    $0x10,%esp
80106498:	85 c0                	test   %eax,%eax
8010649a:	78 1b                	js     801064b7 <sys_mkdir+0x3b>
8010649c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649f:	6a 00                	push   $0x0
801064a1:	6a 00                	push   $0x0
801064a3:	6a 01                	push   $0x1
801064a5:	50                   	push   %eax
801064a6:	e8 62 fc ff ff       	call   8010610d <create>
801064ab:	83 c4 10             	add    $0x10,%esp
801064ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b5:	75 0c                	jne    801064c3 <sys_mkdir+0x47>
    end_op();
801064b7:	e8 44 d0 ff ff       	call   80103500 <end_op>
    return -1;
801064bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c1:	eb 18                	jmp    801064db <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801064c3:	83 ec 0c             	sub    $0xc,%esp
801064c6:	ff 75 f4             	pushl  -0xc(%ebp)
801064c9:	e8 c3 b6 ff ff       	call   80101b91 <iunlockput>
801064ce:	83 c4 10             	add    $0x10,%esp
  end_op();
801064d1:	e8 2a d0 ff ff       	call   80103500 <end_op>
  return 0;
801064d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064db:	c9                   	leave  
801064dc:	c3                   	ret    

801064dd <sys_mknod>:

int
sys_mknod(void)
{
801064dd:	55                   	push   %ebp
801064de:	89 e5                	mov    %esp,%ebp
801064e0:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801064e3:	e8 8a cf ff ff       	call   80103472 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801064e8:	83 ec 08             	sub    $0x8,%esp
801064eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064ee:	50                   	push   %eax
801064ef:	6a 00                	push   $0x0
801064f1:	e8 e8 f4 ff ff       	call   801059de <argstr>
801064f6:	83 c4 10             	add    $0x10,%esp
801064f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106500:	78 4f                	js     80106551 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106502:	83 ec 08             	sub    $0x8,%esp
80106505:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106508:	50                   	push   %eax
80106509:	6a 01                	push   $0x1
8010650b:	e8 47 f4 ff ff       	call   80105957 <argint>
80106510:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106513:	85 c0                	test   %eax,%eax
80106515:	78 3a                	js     80106551 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106517:	83 ec 08             	sub    $0x8,%esp
8010651a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010651d:	50                   	push   %eax
8010651e:	6a 02                	push   $0x2
80106520:	e8 32 f4 ff ff       	call   80105957 <argint>
80106525:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106528:	85 c0                	test   %eax,%eax
8010652a:	78 25                	js     80106551 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010652c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010652f:	0f bf c8             	movswl %ax,%ecx
80106532:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106535:	0f bf d0             	movswl %ax,%edx
80106538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010653b:	51                   	push   %ecx
8010653c:	52                   	push   %edx
8010653d:	6a 03                	push   $0x3
8010653f:	50                   	push   %eax
80106540:	e8 c8 fb ff ff       	call   8010610d <create>
80106545:	83 c4 10             	add    $0x10,%esp
80106548:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010654b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010654f:	75 0c                	jne    8010655d <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106551:	e8 aa cf ff ff       	call   80103500 <end_op>
    return -1;
80106556:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655b:	eb 18                	jmp    80106575 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010655d:	83 ec 0c             	sub    $0xc,%esp
80106560:	ff 75 f0             	pushl  -0x10(%ebp)
80106563:	e8 29 b6 ff ff       	call   80101b91 <iunlockput>
80106568:	83 c4 10             	add    $0x10,%esp
  end_op();
8010656b:	e8 90 cf ff ff       	call   80103500 <end_op>
  return 0;
80106570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106575:	c9                   	leave  
80106576:	c3                   	ret    

80106577 <sys_chdir>:

int
sys_chdir(void)
{
80106577:	55                   	push   %ebp
80106578:	89 e5                	mov    %esp,%ebp
8010657a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010657d:	e8 f0 ce ff ff       	call   80103472 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106582:	83 ec 08             	sub    $0x8,%esp
80106585:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106588:	50                   	push   %eax
80106589:	6a 00                	push   $0x0
8010658b:	e8 4e f4 ff ff       	call   801059de <argstr>
80106590:	83 c4 10             	add    $0x10,%esp
80106593:	85 c0                	test   %eax,%eax
80106595:	78 18                	js     801065af <sys_chdir+0x38>
80106597:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010659a:	83 ec 0c             	sub    $0xc,%esp
8010659d:	50                   	push   %eax
8010659e:	e8 fa be ff ff       	call   8010249d <namei>
801065a3:	83 c4 10             	add    $0x10,%esp
801065a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ad:	75 0c                	jne    801065bb <sys_chdir+0x44>
    end_op();
801065af:	e8 4c cf ff ff       	call   80103500 <end_op>
    return -1;
801065b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b9:	eb 6e                	jmp    80106629 <sys_chdir+0xb2>
  }
  ilock(ip);
801065bb:	83 ec 0c             	sub    $0xc,%esp
801065be:	ff 75 f4             	pushl  -0xc(%ebp)
801065c1:	e8 14 b3 ff ff       	call   801018da <ilock>
801065c6:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801065c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065d0:	66 83 f8 01          	cmp    $0x1,%ax
801065d4:	74 1a                	je     801065f0 <sys_chdir+0x79>
    iunlockput(ip);
801065d6:	83 ec 0c             	sub    $0xc,%esp
801065d9:	ff 75 f4             	pushl  -0xc(%ebp)
801065dc:	e8 b0 b5 ff ff       	call   80101b91 <iunlockput>
801065e1:	83 c4 10             	add    $0x10,%esp
    end_op();
801065e4:	e8 17 cf ff ff       	call   80103500 <end_op>
    return -1;
801065e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ee:	eb 39                	jmp    80106629 <sys_chdir+0xb2>
  }
  iunlock(ip);
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	ff 75 f4             	pushl  -0xc(%ebp)
801065f6:	e8 36 b4 ff ff       	call   80101a31 <iunlock>
801065fb:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801065fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106604:	8b 40 68             	mov    0x68(%eax),%eax
80106607:	83 ec 0c             	sub    $0xc,%esp
8010660a:	50                   	push   %eax
8010660b:	e8 92 b4 ff ff       	call   80101aa2 <iput>
80106610:	83 c4 10             	add    $0x10,%esp
  end_op();
80106613:	e8 e8 ce ff ff       	call   80103500 <end_op>
  proc->cwd = ip;
80106618:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106621:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106624:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106629:	c9                   	leave  
8010662a:	c3                   	ret    

8010662b <sys_exec>:

int
sys_exec(void)
{
8010662b:	55                   	push   %ebp
8010662c:	89 e5                	mov    %esp,%ebp
8010662e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106634:	83 ec 08             	sub    $0x8,%esp
80106637:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010663a:	50                   	push   %eax
8010663b:	6a 00                	push   $0x0
8010663d:	e8 9c f3 ff ff       	call   801059de <argstr>
80106642:	83 c4 10             	add    $0x10,%esp
80106645:	85 c0                	test   %eax,%eax
80106647:	78 18                	js     80106661 <sys_exec+0x36>
80106649:	83 ec 08             	sub    $0x8,%esp
8010664c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106652:	50                   	push   %eax
80106653:	6a 01                	push   $0x1
80106655:	e8 fd f2 ff ff       	call   80105957 <argint>
8010665a:	83 c4 10             	add    $0x10,%esp
8010665d:	85 c0                	test   %eax,%eax
8010665f:	79 0a                	jns    8010666b <sys_exec+0x40>
    return -1;
80106661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106666:	e9 c6 00 00 00       	jmp    80106731 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010666b:	83 ec 04             	sub    $0x4,%esp
8010666e:	68 80 00 00 00       	push   $0x80
80106673:	6a 00                	push   $0x0
80106675:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010667b:	50                   	push   %eax
8010667c:	e8 af ef ff ff       	call   80105630 <memset>
80106681:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010668b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668e:	83 f8 1f             	cmp    $0x1f,%eax
80106691:	76 0a                	jbe    8010669d <sys_exec+0x72>
      return -1;
80106693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106698:	e9 94 00 00 00       	jmp    80106731 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010669d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a0:	c1 e0 02             	shl    $0x2,%eax
801066a3:	89 c2                	mov    %eax,%edx
801066a5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801066ab:	01 c2                	add    %eax,%edx
801066ad:	83 ec 08             	sub    $0x8,%esp
801066b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801066b6:	50                   	push   %eax
801066b7:	52                   	push   %edx
801066b8:	e8 fe f1 ff ff       	call   801058bb <fetchint>
801066bd:	83 c4 10             	add    $0x10,%esp
801066c0:	85 c0                	test   %eax,%eax
801066c2:	79 07                	jns    801066cb <sys_exec+0xa0>
      return -1;
801066c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c9:	eb 66                	jmp    80106731 <sys_exec+0x106>
    if(uarg == 0){
801066cb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801066d1:	85 c0                	test   %eax,%eax
801066d3:	75 27                	jne    801066fc <sys_exec+0xd1>
      argv[i] = 0;
801066d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d8:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801066df:	00 00 00 00 
      break;
801066e3:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801066e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e7:	83 ec 08             	sub    $0x8,%esp
801066ea:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801066f0:	52                   	push   %edx
801066f1:	50                   	push   %eax
801066f2:	e8 58 a4 ff ff       	call   80100b4f <exec>
801066f7:	83 c4 10             	add    $0x10,%esp
801066fa:	eb 35                	jmp    80106731 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066fc:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106702:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106705:	c1 e2 02             	shl    $0x2,%edx
80106708:	01 c2                	add    %eax,%edx
8010670a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106710:	83 ec 08             	sub    $0x8,%esp
80106713:	52                   	push   %edx
80106714:	50                   	push   %eax
80106715:	e8 db f1 ff ff       	call   801058f5 <fetchstr>
8010671a:	83 c4 10             	add    $0x10,%esp
8010671d:	85 c0                	test   %eax,%eax
8010671f:	79 07                	jns    80106728 <sys_exec+0xfd>
      return -1;
80106721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106726:	eb 09                	jmp    80106731 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106728:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010672c:	e9 5a ff ff ff       	jmp    8010668b <sys_exec+0x60>
  return exec(path, argv);
}
80106731:	c9                   	leave  
80106732:	c3                   	ret    

80106733 <sys_pipe>:

int
sys_pipe(void)
{
80106733:	55                   	push   %ebp
80106734:	89 e5                	mov    %esp,%ebp
80106736:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106739:	83 ec 04             	sub    $0x4,%esp
8010673c:	6a 08                	push   $0x8
8010673e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106741:	50                   	push   %eax
80106742:	6a 00                	push   $0x0
80106744:	e8 36 f2 ff ff       	call   8010597f <argptr>
80106749:	83 c4 10             	add    $0x10,%esp
8010674c:	85 c0                	test   %eax,%eax
8010674e:	79 0a                	jns    8010675a <sys_pipe+0x27>
    return -1;
80106750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106755:	e9 af 00 00 00       	jmp    80106809 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010675a:	83 ec 08             	sub    $0x8,%esp
8010675d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106760:	50                   	push   %eax
80106761:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106764:	50                   	push   %eax
80106765:	e8 f5 d7 ff ff       	call   80103f5f <pipealloc>
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	85 c0                	test   %eax,%eax
8010676f:	79 0a                	jns    8010677b <sys_pipe+0x48>
    return -1;
80106771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106776:	e9 8e 00 00 00       	jmp    80106809 <sys_pipe+0xd6>
  fd0 = -1;
8010677b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106782:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106785:	83 ec 0c             	sub    $0xc,%esp
80106788:	50                   	push   %eax
80106789:	e8 7b f3 ff ff       	call   80105b09 <fdalloc>
8010678e:	83 c4 10             	add    $0x10,%esp
80106791:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106798:	78 18                	js     801067b2 <sys_pipe+0x7f>
8010679a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	50                   	push   %eax
801067a1:	e8 63 f3 ff ff       	call   80105b09 <fdalloc>
801067a6:	83 c4 10             	add    $0x10,%esp
801067a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067b0:	79 3f                	jns    801067f1 <sys_pipe+0xbe>
    if(fd0 >= 0)
801067b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067b6:	78 14                	js     801067cc <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801067b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067c1:	83 c2 08             	add    $0x8,%edx
801067c4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067cb:	00 
    fileclose(rf);
801067cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067cf:	83 ec 0c             	sub    $0xc,%esp
801067d2:	50                   	push   %eax
801067d3:	e8 40 a8 ff ff       	call   80101018 <fileclose>
801067d8:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801067db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067de:	83 ec 0c             	sub    $0xc,%esp
801067e1:	50                   	push   %eax
801067e2:	e8 31 a8 ff ff       	call   80101018 <fileclose>
801067e7:	83 c4 10             	add    $0x10,%esp
    return -1;
801067ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ef:	eb 18                	jmp    80106809 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801067f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067f7:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801067f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067fc:	8d 50 04             	lea    0x4(%eax),%edx
801067ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106802:	89 02                	mov    %eax,(%edx)
  return 0;
80106804:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106809:	c9                   	leave  
8010680a:	c3                   	ret    

8010680b <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010680b:	55                   	push   %ebp
8010680c:	89 e5                	mov    %esp,%ebp
8010680e:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106811:	e8 c1 df ff ff       	call   801047d7 <fork>
}
80106816:	c9                   	leave  
80106817:	c3                   	ret    

80106818 <sys_exit>:

int
sys_exit(void)
{
80106818:	55                   	push   %ebp
80106819:	89 e5                	mov    %esp,%ebp
8010681b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010681e:	e8 cb e1 ff ff       	call   801049ee <exit>
  return 0;  // not reached
80106823:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106828:	c9                   	leave  
80106829:	c3                   	ret    

8010682a <sys_wait>:

int
sys_wait(void)
{
8010682a:	55                   	push   %ebp
8010682b:	89 e5                	mov    %esp,%ebp
8010682d:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106830:	e8 3e e3 ff ff       	call   80104b73 <wait>
}
80106835:	c9                   	leave  
80106836:	c3                   	ret    

80106837 <sys_kill>:

int
sys_kill(void)
{
80106837:	55                   	push   %ebp
80106838:	89 e5                	mov    %esp,%ebp
8010683a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010683d:	83 ec 08             	sub    $0x8,%esp
80106840:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106843:	50                   	push   %eax
80106844:	6a 00                	push   $0x0
80106846:	e8 0c f1 ff ff       	call   80105957 <argint>
8010684b:	83 c4 10             	add    $0x10,%esp
8010684e:	85 c0                	test   %eax,%eax
80106850:	79 07                	jns    80106859 <sys_kill+0x22>
    return -1;
80106852:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106857:	eb 0f                	jmp    80106868 <sys_kill+0x31>
  return kill(pid);
80106859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010685c:	83 ec 0c             	sub    $0xc,%esp
8010685f:	50                   	push   %eax
80106860:	e8 d4 e7 ff ff       	call   80105039 <kill>
80106865:	83 c4 10             	add    $0x10,%esp
}
80106868:	c9                   	leave  
80106869:	c3                   	ret    

8010686a <sys_getpid>:

int
sys_getpid(void)
{
8010686a:	55                   	push   %ebp
8010686b:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010686d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106873:	8b 40 10             	mov    0x10(%eax),%eax
}
80106876:	5d                   	pop    %ebp
80106877:	c3                   	ret    

80106878 <sys_sbrk>:

int
sys_sbrk(void)
{
80106878:	55                   	push   %ebp
80106879:	89 e5                	mov    %esp,%ebp
8010687b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010687e:	83 ec 08             	sub    $0x8,%esp
80106881:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106884:	50                   	push   %eax
80106885:	6a 00                	push   $0x0
80106887:	e8 cb f0 ff ff       	call   80105957 <argint>
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	85 c0                	test   %eax,%eax
80106891:	79 07                	jns    8010689a <sys_sbrk+0x22>
    return -1;
80106893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106898:	eb 28                	jmp    801068c2 <sys_sbrk+0x4a>
  addr = proc->sz;
8010689a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068a0:	8b 00                	mov    (%eax),%eax
801068a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801068a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068a8:	83 ec 0c             	sub    $0xc,%esp
801068ab:	50                   	push   %eax
801068ac:	e8 83 de ff ff       	call   80104734 <growproc>
801068b1:	83 c4 10             	add    $0x10,%esp
801068b4:	85 c0                	test   %eax,%eax
801068b6:	79 07                	jns    801068bf <sys_sbrk+0x47>
    return -1;
801068b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068bd:	eb 03                	jmp    801068c2 <sys_sbrk+0x4a>
  return addr;
801068bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068c2:	c9                   	leave  
801068c3:	c3                   	ret    

801068c4 <sys_sleep>:

int
sys_sleep(void)
{
801068c4:	55                   	push   %ebp
801068c5:	89 e5                	mov    %esp,%ebp
801068c7:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801068ca:	83 ec 08             	sub    $0x8,%esp
801068cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068d0:	50                   	push   %eax
801068d1:	6a 00                	push   $0x0
801068d3:	e8 7f f0 ff ff       	call   80105957 <argint>
801068d8:	83 c4 10             	add    $0x10,%esp
801068db:	85 c0                	test   %eax,%eax
801068dd:	79 07                	jns    801068e6 <sys_sleep+0x22>
    return -1;
801068df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e4:	eb 77                	jmp    8010695d <sys_sleep+0x99>
  acquire(&tickslock);
801068e6:	83 ec 0c             	sub    $0xc,%esp
801068e9:	68 c0 63 11 80       	push   $0x801163c0
801068ee:	e8 e1 ea ff ff       	call   801053d4 <acquire>
801068f3:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801068f6:	a1 00 6c 11 80       	mov    0x80116c00,%eax
801068fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801068fe:	eb 39                	jmp    80106939 <sys_sleep+0x75>
    if(proc->killed){
80106900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106906:	8b 40 24             	mov    0x24(%eax),%eax
80106909:	85 c0                	test   %eax,%eax
8010690b:	74 17                	je     80106924 <sys_sleep+0x60>
      release(&tickslock);
8010690d:	83 ec 0c             	sub    $0xc,%esp
80106910:	68 c0 63 11 80       	push   $0x801163c0
80106915:	e8 20 eb ff ff       	call   8010543a <release>
8010691a:	83 c4 10             	add    $0x10,%esp
      return -1;
8010691d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106922:	eb 39                	jmp    8010695d <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106924:	83 ec 08             	sub    $0x8,%esp
80106927:	68 c0 63 11 80       	push   $0x801163c0
8010692c:	68 00 6c 11 80       	push   $0x80116c00
80106931:	e8 aa e5 ff ff       	call   80104ee0 <sleep>
80106936:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106939:	a1 00 6c 11 80       	mov    0x80116c00,%eax
8010693e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106941:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106944:	39 d0                	cmp    %edx,%eax
80106946:	72 b8                	jb     80106900 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106948:	83 ec 0c             	sub    $0xc,%esp
8010694b:	68 c0 63 11 80       	push   $0x801163c0
80106950:	e8 e5 ea ff ff       	call   8010543a <release>
80106955:	83 c4 10             	add    $0x10,%esp
  return 0;
80106958:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010695d:	c9                   	leave  
8010695e:	c3                   	ret    

8010695f <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010695f:	55                   	push   %ebp
80106960:	89 e5                	mov    %esp,%ebp
80106962:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106965:	83 ec 0c             	sub    $0xc,%esp
80106968:	68 c0 63 11 80       	push   $0x801163c0
8010696d:	e8 62 ea ff ff       	call   801053d4 <acquire>
80106972:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106975:	a1 00 6c 11 80       	mov    0x80116c00,%eax
8010697a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010697d:	83 ec 0c             	sub    $0xc,%esp
80106980:	68 c0 63 11 80       	push   $0x801163c0
80106985:	e8 b0 ea ff ff       	call   8010543a <release>
8010698a:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010698d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106990:	c9                   	leave  
80106991:	c3                   	ret    

80106992 <sys_procstat>:

// Print a process listing to console. 
int
sys_procstat(void){  
80106992:	55                   	push   %ebp
80106993:	89 e5                	mov    %esp,%ebp
80106995:	83 ec 08             	sub    $0x8,%esp
  procdump();
80106998:	e8 3b e7 ff ff       	call   801050d8 <procdump>
  return 0;
8010699d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a2:	c9                   	leave  
801069a3:	c3                   	ret    

801069a4 <sys_set_priority>:

//change the priority
int
sys_set_priority(void){
801069a4:	55                   	push   %ebp
801069a5:	89 e5                	mov    %esp,%ebp
801069a7:	83 ec 18             	sub    $0x18,%esp
  int priority;
  if(argint(0, &priority) < 0)
801069aa:	83 ec 08             	sub    $0x8,%esp
801069ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069b0:	50                   	push   %eax
801069b1:	6a 00                	push   $0x0
801069b3:	e8 9f ef ff ff       	call   80105957 <argint>
801069b8:	83 c4 10             	add    $0x10,%esp
801069bb:	85 c0                	test   %eax,%eax
801069bd:	79 07                	jns    801069c6 <sys_set_priority+0x22>
    return -1; 
801069bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c4:	eb 2a                	jmp    801069f0 <sys_set_priority+0x4c>
  if (priority<0 || priority>MLF_SIZE-1)
801069c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c9:	85 c0                	test   %eax,%eax
801069cb:	78 08                	js     801069d5 <sys_set_priority+0x31>
801069cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d0:	83 f8 03             	cmp    $0x3,%eax
801069d3:	7e 07                	jle    801069dc <sys_set_priority+0x38>
    return -1;   
801069d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069da:	eb 14                	jmp    801069f0 <sys_set_priority+0x4c>
  proc->priority = priority;
801069dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069e5:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
801069eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f0:	c9                   	leave  
801069f1:	c3                   	ret    

801069f2 <belong>:
#include "spinlock.h"
#include "semaphore.h"

//private: true if semaphore belongs to proc
static int 
belong(int sem_id){
801069f2:	55                   	push   %ebp
801069f3:	89 e5                	mov    %esp,%ebp
801069f5:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
801069f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (i < MAXSEMPROC){
801069ff:	eb 20                	jmp    80106a21 <belong+0x2f>
    if (proc->sem[i] == sem_id){
80106a01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a07:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a0a:	83 c2 20             	add    $0x20,%edx
80106a0d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106a11:	3b 45 08             	cmp    0x8(%ebp),%eax
80106a14:	75 07                	jne    80106a1d <belong+0x2b>
      return 1;
80106a16:	b8 01 00 00 00       	mov    $0x1,%eax
80106a1b:	eb 0f                	jmp    80106a2c <belong+0x3a>
    }
    i++;
80106a1d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

//private: true if semaphore belongs to proc
static int 
belong(int sem_id){
  int i = 0;
  while (i < MAXSEMPROC){
80106a21:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
80106a25:	7e da                	jle    80106a01 <belong+0xf>
    if (proc->sem[i] == sem_id){
      return 1;
    }
    i++;
  }
  return 0;
80106a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a2c:	c9                   	leave  
80106a2d:	c3                   	ret    

80106a2e <sys_semget>:

//Create or obtain a descriptor of a semaphore.
int
sys_semget(void){ //int sem_id, int init_value
80106a2e:	55                   	push   %ebp
80106a2f:	89 e5                	mov    %esp,%ebp
80106a31:	83 ec 18             	sub    $0x18,%esp
  if (proc->squantity == MAXSEMPROC){
80106a34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a3a:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80106a40:	83 f8 05             	cmp    $0x5,%eax
80106a43:	75 0a                	jne    80106a4f <sys_semget+0x21>
    return -2;
80106a45:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80106a4a:	e9 89 00 00 00       	jmp    80106ad8 <sys_semget+0xaa>
  } else {
    int sem_id;
    if(argint(0, &sem_id) < 0)
80106a4f:	83 ec 08             	sub    $0x8,%esp
80106a52:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a55:	50                   	push   %eax
80106a56:	6a 00                	push   $0x0
80106a58:	e8 fa ee ff ff       	call   80105957 <argint>
80106a5d:	83 c4 10             	add    $0x10,%esp
80106a60:	85 c0                	test   %eax,%eax
80106a62:	79 07                	jns    80106a6b <sys_semget+0x3d>
      return -4;  
80106a64:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106a69:	eb 6d                	jmp    80106ad8 <sys_semget+0xaa>
    int init_value;
    if(argint(1, &init_value) < 0)
80106a6b:	83 ec 08             	sub    $0x8,%esp
80106a6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a71:	50                   	push   %eax
80106a72:	6a 01                	push   $0x1
80106a74:	e8 de ee ff ff       	call   80105957 <argint>
80106a79:	83 c4 10             	add    $0x10,%esp
80106a7c:	85 c0                	test   %eax,%eax
80106a7e:	79 07                	jns    80106a87 <sys_semget+0x59>
      return -4;    
80106a80:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106a85:	eb 51                	jmp    80106ad8 <sys_semget+0xaa>
    int ret = semget(sem_id, init_value);
80106a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a8d:	83 ec 08             	sub    $0x8,%esp
80106a90:	52                   	push   %edx
80106a91:	50                   	push   %eax
80106a92:	e8 47 e7 ff ff       	call   801051de <semget>
80106a97:	83 c4 10             	add    $0x10,%esp
80106a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ret>-1){ 
80106a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106aa1:	78 32                	js     80106ad5 <sys_semget+0xa7>
      proc->sem[proc->squantity] = ret;
80106aa3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aa9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106ab0:	8b 92 9c 00 00 00    	mov    0x9c(%edx),%edx
80106ab6:	8d 4a 20             	lea    0x20(%edx),%ecx
80106ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106abc:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      proc->squantity++;
80106ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac6:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80106acc:	83 c2 01             	add    $0x1,%edx
80106acf:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
    } 
    return ret;
80106ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  }  
}
80106ad8:	c9                   	leave  
80106ad9:	c3                   	ret    

80106ada <sys_semfree>:

//Releases the semaphore.
int
sys_semfree(void){ //int sem_id
80106ada:	55                   	push   %ebp
80106adb:	89 e5                	mov    %esp,%ebp
80106add:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106ae0:	83 ec 08             	sub    $0x8,%esp
80106ae3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ae6:	50                   	push   %eax
80106ae7:	6a 00                	push   $0x0
80106ae9:	e8 69 ee ff ff       	call   80105957 <argint>
80106aee:	83 c4 10             	add    $0x10,%esp
80106af1:	85 c0                	test   %eax,%eax
80106af3:	79 0a                	jns    80106aff <sys_semfree+0x25>
    return -4;
80106af5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106afa:	e9 94 00 00 00       	jmp    80106b93 <sys_semfree+0xb9>
  int i = 0;
80106aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (belong(sem_id)){
80106b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b09:	83 ec 0c             	sub    $0xc,%esp
80106b0c:	50                   	push   %eax
80106b0d:	e8 e0 fe ff ff       	call   801069f2 <belong>
80106b12:	83 c4 10             	add    $0x10,%esp
80106b15:	85 c0                	test   %eax,%eax
80106b17:	74 75                	je     80106b8e <sys_semfree+0xb4>
    if (semfree(sem_id) == -1){
80106b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b1c:	83 ec 0c             	sub    $0xc,%esp
80106b1f:	50                   	push   %eax
80106b20:	e8 67 e7 ff ff       	call   8010528c <semfree>
80106b25:	83 c4 10             	add    $0x10,%esp
80106b28:	83 f8 ff             	cmp    $0xffffffff,%eax
80106b2b:	75 07                	jne    80106b34 <sys_semfree+0x5a>
      return -1;
80106b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b32:	eb 5f                	jmp    80106b93 <sys_semfree+0xb9>
    } else {
      for (i=i; i<proc->squantity-1;i++){
80106b34:	eb 28                	jmp    80106b5e <sys_semfree+0x84>
        proc->sem[i] = proc->sem[i+1];
80106b36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b3c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106b43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106b46:	83 c1 01             	add    $0x1,%ecx
80106b49:	83 c1 20             	add    $0x20,%ecx
80106b4c:	8b 54 8a 08          	mov    0x8(%edx,%ecx,4),%edx
80106b50:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106b53:	83 c1 20             	add    $0x20,%ecx
80106b56:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
  int i = 0;
  if (belong(sem_id)){
    if (semfree(sem_id) == -1){
      return -1;
    } else {
      for (i=i; i<proc->squantity-1;i++){
80106b5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b64:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80106b6a:	83 e8 01             	sub    $0x1,%eax
80106b6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106b70:	7f c4                	jg     80106b36 <sys_semfree+0x5c>
        proc->sem[i] = proc->sem[i+1];
      }
      proc->squantity--;
80106b72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b78:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80106b7e:	83 ea 01             	sub    $0x1,%edx
80106b81:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
      return 0;
80106b87:	b8 00 00 00 00       	mov    $0x0,%eax
80106b8c:	eb 05                	jmp    80106b93 <sys_semfree+0xb9>
    }
  }
  return -1;
80106b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b93:	c9                   	leave  
80106b94:	c3                   	ret    

80106b95 <sys_semdown>:

//decrease the unit value of the semaphore
int
sys_semdown(void){ //int sem_id
80106b95:	55                   	push   %ebp
80106b96:	89 e5                	mov    %esp,%ebp
80106b98:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106b9b:	83 ec 08             	sub    $0x8,%esp
80106b9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ba1:	50                   	push   %eax
80106ba2:	6a 00                	push   $0x0
80106ba4:	e8 ae ed ff ff       	call   80105957 <argint>
80106ba9:	83 c4 10             	add    $0x10,%esp
80106bac:	85 c0                	test   %eax,%eax
80106bae:	79 07                	jns    80106bb7 <sys_semdown+0x22>
      return -4;  
80106bb0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80106bb5:	eb 78                	jmp    80106c2f <sys_semdown+0x9a>
  if (belong(sem_id)){
80106bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	50                   	push   %eax
80106bbe:	e8 2f fe ff ff       	call   801069f2 <belong>
80106bc3:	83 c4 10             	add    $0x10,%esp
80106bc6:	85 c0                	test   %eax,%eax
80106bc8:	74 60                	je     80106c2a <sys_semdown+0x95>
    acquire(&stable.lock);
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 60 63 11 80       	push   $0x80116360
80106bd2:	e8 fd e7 ff ff       	call   801053d4 <acquire>
80106bd7:	83 c4 10             	add    $0x10,%esp
    while(stable.semaphore[sem_id].value == 0)
80106bda:	eb 1a                	jmp    80106bf6 <sys_semdown+0x61>
      sleep(proc->chan, &stable.lock);
80106bdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106be2:	8b 40 20             	mov    0x20(%eax),%eax
80106be5:	83 ec 08             	sub    $0x8,%esp
80106be8:	68 60 63 11 80       	push   $0x80116360
80106bed:	50                   	push   %eax
80106bee:	e8 ed e2 ff ff       	call   80104ee0 <sleep>
80106bf3:	83 c4 10             	add    $0x10,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
      return -4;  
  if (belong(sem_id)){
    acquire(&stable.lock);
    while(stable.semaphore[sem_id].value == 0)
80106bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf9:	8b 04 c5 c0 62 11 80 	mov    -0x7fee9d40(,%eax,8),%eax
80106c00:	85 c0                	test   %eax,%eax
80106c02:	74 d8                	je     80106bdc <sys_semdown+0x47>
      sleep(proc->chan, &stable.lock);
    semdown(sem_id);
80106c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c07:	83 ec 0c             	sub    $0xc,%esp
80106c0a:	50                   	push   %eax
80106c0b:	e8 f3 e6 ff ff       	call   80105303 <semdown>
80106c10:	83 c4 10             	add    $0x10,%esp
    release(&stable.lock);
80106c13:	83 ec 0c             	sub    $0xc,%esp
80106c16:	68 60 63 11 80       	push   $0x80116360
80106c1b:	e8 1a e8 ff ff       	call   8010543a <release>
80106c20:	83 c4 10             	add    $0x10,%esp
    return 0;
80106c23:	b8 00 00 00 00       	mov    $0x0,%eax
80106c28:	eb 05                	jmp    80106c2f <sys_semdown+0x9a>
  }
  return -1;  
80106c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c2f:	c9                   	leave  
80106c30:	c3                   	ret    

80106c31 <sys_semup>:

//Increase the unit value of the semaphore
int
sys_semup(void){ //int sem_id
80106c31:	55                   	push   %ebp
80106c32:	89 e5                	mov    %esp,%ebp
80106c34:	83 ec 18             	sub    $0x18,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106c37:	83 ec 08             	sub    $0x8,%esp
80106c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c3d:	50                   	push   %eax
80106c3e:	6a 00                	push   $0x0
80106c40:	e8 12 ed ff ff       	call   80105957 <argint>
80106c45:	83 c4 10             	add    $0x10,%esp
80106c48:	85 c0                	test   %eax,%eax
80106c4a:	79 07                	jns    80106c53 <sys_semup+0x22>
      return -1;
80106c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c51:	eb 4f                	jmp    80106ca2 <sys_semup+0x71>
  if (belong(sem_id)){    
80106c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c56:	83 ec 0c             	sub    $0xc,%esp
80106c59:	50                   	push   %eax
80106c5a:	e8 93 fd ff ff       	call   801069f2 <belong>
80106c5f:	83 c4 10             	add    $0x10,%esp
80106c62:	85 c0                	test   %eax,%eax
80106c64:	74 37                	je     80106c9d <sys_semup+0x6c>
    if (semup(sem_id) == -1)
80106c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	50                   	push   %eax
80106c6d:	e8 b2 e6 ff ff       	call   80105324 <semup>
80106c72:	83 c4 10             	add    $0x10,%esp
80106c75:	83 f8 ff             	cmp    $0xffffffff,%eax
80106c78:	75 07                	jne    80106c81 <sys_semup+0x50>
      return -1;
80106c7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c7f:	eb 21                	jmp    80106ca2 <sys_semup+0x71>
    else {
      wakeup(proc->chan);
80106c81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c87:	8b 40 20             	mov    0x20(%eax),%eax
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	50                   	push   %eax
80106c8e:	e8 70 e3 ff ff       	call   80105003 <wakeup>
80106c93:	83 c4 10             	add    $0x10,%esp
      return 0;
80106c96:	b8 00 00 00 00       	mov    $0x0,%eax
80106c9b:	eb 05                	jmp    80106ca2 <sys_semup+0x71>
    }
  }   
  return -1;
80106c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ca2:	c9                   	leave  
80106ca3:	c3                   	ret    

80106ca4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106ca4:	55                   	push   %ebp
80106ca5:	89 e5                	mov    %esp,%ebp
80106ca7:	83 ec 08             	sub    $0x8,%esp
80106caa:	8b 55 08             	mov    0x8(%ebp),%edx
80106cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106cb4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106cb7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106cbb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106cbf:	ee                   	out    %al,(%dx)
}
80106cc0:	c9                   	leave  
80106cc1:	c3                   	ret    

80106cc2 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106cc2:	55                   	push   %ebp
80106cc3:	89 e5                	mov    %esp,%ebp
80106cc5:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106cc8:	6a 34                	push   $0x34
80106cca:	6a 43                	push   $0x43
80106ccc:	e8 d3 ff ff ff       	call   80106ca4 <outb>
80106cd1:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106cd4:	68 9c 00 00 00       	push   $0x9c
80106cd9:	6a 40                	push   $0x40
80106cdb:	e8 c4 ff ff ff       	call   80106ca4 <outb>
80106ce0:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106ce3:	6a 2e                	push   $0x2e
80106ce5:	6a 40                	push   $0x40
80106ce7:	e8 b8 ff ff ff       	call   80106ca4 <outb>
80106cec:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106cef:	83 ec 0c             	sub    $0xc,%esp
80106cf2:	6a 00                	push   $0x0
80106cf4:	e8 52 d1 ff ff       	call   80103e4b <picenable>
80106cf9:	83 c4 10             	add    $0x10,%esp
}
80106cfc:	c9                   	leave  
80106cfd:	c3                   	ret    

80106cfe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106cfe:	1e                   	push   %ds
  pushl %es
80106cff:	06                   	push   %es
  pushl %fs
80106d00:	0f a0                	push   %fs
  pushl %gs
80106d02:	0f a8                	push   %gs
  pushal
80106d04:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106d05:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d09:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d0b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d0d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d11:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d13:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d15:	54                   	push   %esp
  call trap
80106d16:	e8 d4 01 00 00       	call   80106eef <trap>
  addl $4, %esp
80106d1b:	83 c4 04             	add    $0x4,%esp

80106d1e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d1e:	61                   	popa   
  popl %gs
80106d1f:	0f a9                	pop    %gs
  popl %fs
80106d21:	0f a1                	pop    %fs
  popl %es
80106d23:	07                   	pop    %es
  popl %ds
80106d24:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d25:	83 c4 08             	add    $0x8,%esp
  iret
80106d28:	cf                   	iret   

80106d29 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d29:	55                   	push   %ebp
80106d2a:	89 e5                	mov    %esp,%ebp
80106d2c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d32:	83 e8 01             	sub    $0x1,%eax
80106d35:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d39:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d40:	8b 45 08             	mov    0x8(%ebp),%eax
80106d43:	c1 e8 10             	shr    $0x10,%eax
80106d46:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106d4a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d4d:	0f 01 18             	lidtl  (%eax)
}
80106d50:	c9                   	leave  
80106d51:	c3                   	ret    

80106d52 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106d52:	55                   	push   %ebp
80106d53:	89 e5                	mov    %esp,%ebp
80106d55:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d58:	0f 20 d0             	mov    %cr2,%eax
80106d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d61:	c9                   	leave  
80106d62:	c3                   	ret    

80106d63 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106d63:	55                   	push   %ebp
80106d64:	89 e5                	mov    %esp,%ebp
80106d66:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d70:	e9 c3 00 00 00       	jmp    80106e38 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d78:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106d7f:	89 c2                	mov    %eax,%edx
80106d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d84:	66 89 14 c5 00 64 11 	mov    %dx,-0x7fee9c00(,%eax,8)
80106d8b:	80 
80106d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d8f:	66 c7 04 c5 02 64 11 	movw   $0x8,-0x7fee9bfe(,%eax,8)
80106d96:	80 08 00 
80106d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9c:	0f b6 14 c5 04 64 11 	movzbl -0x7fee9bfc(,%eax,8),%edx
80106da3:	80 
80106da4:	83 e2 e0             	and    $0xffffffe0,%edx
80106da7:	88 14 c5 04 64 11 80 	mov    %dl,-0x7fee9bfc(,%eax,8)
80106dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db1:	0f b6 14 c5 04 64 11 	movzbl -0x7fee9bfc(,%eax,8),%edx
80106db8:	80 
80106db9:	83 e2 1f             	and    $0x1f,%edx
80106dbc:	88 14 c5 04 64 11 80 	mov    %dl,-0x7fee9bfc(,%eax,8)
80106dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc6:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dcd:	80 
80106dce:	83 e2 f0             	and    $0xfffffff0,%edx
80106dd1:	83 ca 0e             	or     $0xe,%edx
80106dd4:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dde:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106de5:	80 
80106de6:	83 e2 ef             	and    $0xffffffef,%edx
80106de9:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df3:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106dfa:	80 
80106dfb:	83 e2 9f             	and    $0xffffff9f,%edx
80106dfe:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e08:	0f b6 14 c5 05 64 11 	movzbl -0x7fee9bfb(,%eax,8),%edx
80106e0f:	80 
80106e10:	83 ca 80             	or     $0xffffff80,%edx
80106e13:	88 14 c5 05 64 11 80 	mov    %dl,-0x7fee9bfb(,%eax,8)
80106e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e1d:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106e24:	c1 e8 10             	shr    $0x10,%eax
80106e27:	89 c2                	mov    %eax,%edx
80106e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2c:	66 89 14 c5 06 64 11 	mov    %dx,-0x7fee9bfa(,%eax,8)
80106e33:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106e34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e38:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e3f:	0f 8e 30 ff ff ff    	jle    80106d75 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e45:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106e4a:	66 a3 00 66 11 80    	mov    %ax,0x80116600
80106e50:	66 c7 05 02 66 11 80 	movw   $0x8,0x80116602
80106e57:	08 00 
80106e59:	0f b6 05 04 66 11 80 	movzbl 0x80116604,%eax
80106e60:	83 e0 e0             	and    $0xffffffe0,%eax
80106e63:	a2 04 66 11 80       	mov    %al,0x80116604
80106e68:	0f b6 05 04 66 11 80 	movzbl 0x80116604,%eax
80106e6f:	83 e0 1f             	and    $0x1f,%eax
80106e72:	a2 04 66 11 80       	mov    %al,0x80116604
80106e77:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e7e:	83 c8 0f             	or     $0xf,%eax
80106e81:	a2 05 66 11 80       	mov    %al,0x80116605
80106e86:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e8d:	83 e0 ef             	and    $0xffffffef,%eax
80106e90:	a2 05 66 11 80       	mov    %al,0x80116605
80106e95:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106e9c:	83 c8 60             	or     $0x60,%eax
80106e9f:	a2 05 66 11 80       	mov    %al,0x80116605
80106ea4:	0f b6 05 05 66 11 80 	movzbl 0x80116605,%eax
80106eab:	83 c8 80             	or     $0xffffff80,%eax
80106eae:	a2 05 66 11 80       	mov    %al,0x80116605
80106eb3:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106eb8:	c1 e8 10             	shr    $0x10,%eax
80106ebb:	66 a3 06 66 11 80    	mov    %ax,0x80116606
  
  initlock(&tickslock, "time");
80106ec1:	83 ec 08             	sub    $0x8,%esp
80106ec4:	68 78 90 10 80       	push   $0x80109078
80106ec9:	68 c0 63 11 80       	push   $0x801163c0
80106ece:	e8 e0 e4 ff ff       	call   801053b3 <initlock>
80106ed3:	83 c4 10             	add    $0x10,%esp
}
80106ed6:	c9                   	leave  
80106ed7:	c3                   	ret    

80106ed8 <idtinit>:

void
idtinit(void)
{
80106ed8:	55                   	push   %ebp
80106ed9:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106edb:	68 00 08 00 00       	push   $0x800
80106ee0:	68 00 64 11 80       	push   $0x80116400
80106ee5:	e8 3f fe ff ff       	call   80106d29 <lidt>
80106eea:	83 c4 08             	add    $0x8,%esp
}
80106eed:	c9                   	leave  
80106eee:	c3                   	ret    

80106eef <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106eef:	55                   	push   %ebp
80106ef0:	89 e5                	mov    %esp,%ebp
80106ef2:	57                   	push   %edi
80106ef3:	56                   	push   %esi
80106ef4:	53                   	push   %ebx
80106ef5:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80106efb:	8b 40 30             	mov    0x30(%eax),%eax
80106efe:	83 f8 40             	cmp    $0x40,%eax
80106f01:	75 3f                	jne    80106f42 <trap+0x53>
    if(proc->killed)
80106f03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f09:	8b 40 24             	mov    0x24(%eax),%eax
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	74 05                	je     80106f15 <trap+0x26>
      exit();
80106f10:	e8 d9 da ff ff       	call   801049ee <exit>
    proc->tf = tf;
80106f15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f1e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f21:	e8 e9 ea ff ff       	call   80105a0f <syscall>
    if(proc->killed)
80106f26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f2c:	8b 40 24             	mov    0x24(%eax),%eax
80106f2f:	85 c0                	test   %eax,%eax
80106f31:	74 0a                	je     80106f3d <trap+0x4e>
      exit();
80106f33:	e8 b6 da ff ff       	call   801049ee <exit>
    return;
80106f38:	e9 31 02 00 00       	jmp    8010716e <trap+0x27f>
80106f3d:	e9 2c 02 00 00       	jmp    8010716e <trap+0x27f>
  }

  switch(tf->trapno){
80106f42:	8b 45 08             	mov    0x8(%ebp),%eax
80106f45:	8b 40 30             	mov    0x30(%eax),%eax
80106f48:	83 e8 20             	sub    $0x20,%eax
80106f4b:	83 f8 1f             	cmp    $0x1f,%eax
80106f4e:	0f 87 c0 00 00 00    	ja     80107014 <trap+0x125>
80106f54:	8b 04 85 20 91 10 80 	mov    -0x7fef6ee0(,%eax,4),%eax
80106f5b:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106f5d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f63:	0f b6 00             	movzbl (%eax),%eax
80106f66:	84 c0                	test   %al,%al
80106f68:	75 3d                	jne    80106fa7 <trap+0xb8>
      acquire(&tickslock);
80106f6a:	83 ec 0c             	sub    $0xc,%esp
80106f6d:	68 c0 63 11 80       	push   $0x801163c0
80106f72:	e8 5d e4 ff ff       	call   801053d4 <acquire>
80106f77:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106f7a:	a1 00 6c 11 80       	mov    0x80116c00,%eax
80106f7f:	83 c0 01             	add    $0x1,%eax
80106f82:	a3 00 6c 11 80       	mov    %eax,0x80116c00
      wakeup(&ticks);
80106f87:	83 ec 0c             	sub    $0xc,%esp
80106f8a:	68 00 6c 11 80       	push   $0x80116c00
80106f8f:	e8 6f e0 ff ff       	call   80105003 <wakeup>
80106f94:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106f97:	83 ec 0c             	sub    $0xc,%esp
80106f9a:	68 c0 63 11 80       	push   $0x801163c0
80106f9f:	e8 96 e4 ff ff       	call   8010543a <release>
80106fa4:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106fa7:	e8 9f bf ff ff       	call   80102f4b <lapiceoi>
    break;
80106fac:	e9 1c 01 00 00       	jmp    801070cd <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106fb1:	e8 b6 b7 ff ff       	call   8010276c <ideintr>
    lapiceoi();
80106fb6:	e8 90 bf ff ff       	call   80102f4b <lapiceoi>
    break;
80106fbb:	e9 0d 01 00 00       	jmp    801070cd <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106fc0:	e8 8d bd ff ff       	call   80102d52 <kbdintr>
    lapiceoi();
80106fc5:	e8 81 bf ff ff       	call   80102f4b <lapiceoi>
    break;
80106fca:	e9 fe 00 00 00       	jmp    801070cd <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106fcf:	e8 77 03 00 00       	call   8010734b <uartintr>
    lapiceoi();
80106fd4:	e8 72 bf ff ff       	call   80102f4b <lapiceoi>
    break;
80106fd9:	e9 ef 00 00 00       	jmp    801070cd <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106fde:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106feb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106fee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ff4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ff7:	0f b6 c0             	movzbl %al,%eax
80106ffa:	51                   	push   %ecx
80106ffb:	52                   	push   %edx
80106ffc:	50                   	push   %eax
80106ffd:	68 80 90 10 80       	push   $0x80109080
80107002:	e8 b8 93 ff ff       	call   801003bf <cprintf>
80107007:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010700a:	e8 3c bf ff ff       	call   80102f4b <lapiceoi>
    break;
8010700f:	e9 b9 00 00 00       	jmp    801070cd <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107014:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701a:	85 c0                	test   %eax,%eax
8010701c:	74 11                	je     8010702f <trap+0x140>
8010701e:	8b 45 08             	mov    0x8(%ebp),%eax
80107021:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107025:	0f b7 c0             	movzwl %ax,%eax
80107028:	83 e0 03             	and    $0x3,%eax
8010702b:	85 c0                	test   %eax,%eax
8010702d:	75 40                	jne    8010706f <trap+0x180>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010702f:	e8 1e fd ff ff       	call   80106d52 <rcr2>
80107034:	89 c3                	mov    %eax,%ebx
80107036:	8b 45 08             	mov    0x8(%ebp),%eax
80107039:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010703c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107042:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107045:	0f b6 d0             	movzbl %al,%edx
80107048:	8b 45 08             	mov    0x8(%ebp),%eax
8010704b:	8b 40 30             	mov    0x30(%eax),%eax
8010704e:	83 ec 0c             	sub    $0xc,%esp
80107051:	53                   	push   %ebx
80107052:	51                   	push   %ecx
80107053:	52                   	push   %edx
80107054:	50                   	push   %eax
80107055:	68 a4 90 10 80       	push   $0x801090a4
8010705a:	e8 60 93 ff ff       	call   801003bf <cprintf>
8010705f:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107062:	83 ec 0c             	sub    $0xc,%esp
80107065:	68 d6 90 10 80       	push   $0x801090d6
8010706a:	e8 ed 94 ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010706f:	e8 de fc ff ff       	call   80106d52 <rcr2>
80107074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107077:	8b 45 08             	mov    0x8(%ebp),%eax
8010707a:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010707d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107083:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107086:	0f b6 d8             	movzbl %al,%ebx
80107089:	8b 45 08             	mov    0x8(%ebp),%eax
8010708c:	8b 48 34             	mov    0x34(%eax),%ecx
8010708f:	8b 45 08             	mov    0x8(%ebp),%eax
80107092:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107095:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010709b:	8d 78 6c             	lea    0x6c(%eax),%edi
8010709e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070a4:	8b 40 10             	mov    0x10(%eax),%eax
801070a7:	ff 75 e4             	pushl  -0x1c(%ebp)
801070aa:	56                   	push   %esi
801070ab:	53                   	push   %ebx
801070ac:	51                   	push   %ecx
801070ad:	52                   	push   %edx
801070ae:	57                   	push   %edi
801070af:	50                   	push   %eax
801070b0:	68 dc 90 10 80       	push   $0x801090dc
801070b5:	e8 05 93 ff ff       	call   801003bf <cprintf>
801070ba:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801070bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801070ca:	eb 01                	jmp    801070cd <trap+0x1de>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801070cc:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801070cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070d3:	85 c0                	test   %eax,%eax
801070d5:	74 24                	je     801070fb <trap+0x20c>
801070d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070dd:	8b 40 24             	mov    0x24(%eax),%eax
801070e0:	85 c0                	test   %eax,%eax
801070e2:	74 17                	je     801070fb <trap+0x20c>
801070e4:	8b 45 08             	mov    0x8(%ebp),%eax
801070e7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070eb:	0f b7 c0             	movzwl %ax,%eax
801070ee:	83 e0 03             	and    $0x3,%eax
801070f1:	83 f8 03             	cmp    $0x3,%eax
801070f4:	75 05                	jne    801070fb <trap+0x20c>
    exit();
801070f6:	e8 f3 d8 ff ff       	call   801049ee <exit>

  // Force process to give up CPU on third clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801070fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107101:	85 c0                	test   %eax,%eax
80107103:	74 3b                	je     80107140 <trap+0x251>
80107105:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010710b:	8b 40 0c             	mov    0xc(%eax),%eax
8010710e:	83 f8 04             	cmp    $0x4,%eax
80107111:	75 2d                	jne    80107140 <trap+0x251>
80107113:	8b 45 08             	mov    0x8(%ebp),%eax
80107116:	8b 40 30             	mov    0x30(%eax),%eax
80107119:	83 f8 20             	cmp    $0x20,%eax
8010711c:	75 22                	jne    80107140 <trap+0x251>
    proc->quantum++;   // increases the quantum ticks counter
8010711e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107124:	8b 50 7c             	mov    0x7c(%eax),%edx
80107127:	83 c2 01             	add    $0x1,%edx
8010712a:	89 50 7c             	mov    %edx,0x7c(%eax)
    if (proc->quantum >= QUANTUM){ 
8010712d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107133:	8b 40 7c             	mov    0x7c(%eax),%eax
80107136:	83 f8 02             	cmp    $0x2,%eax
80107139:	7e 05                	jle    80107140 <trap+0x251>
      yield();
8010713b:	e8 ea dc ff ff       	call   80104e2a <yield>
    }
  }   

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107146:	85 c0                	test   %eax,%eax
80107148:	74 24                	je     8010716e <trap+0x27f>
8010714a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107150:	8b 40 24             	mov    0x24(%eax),%eax
80107153:	85 c0                	test   %eax,%eax
80107155:	74 17                	je     8010716e <trap+0x27f>
80107157:	8b 45 08             	mov    0x8(%ebp),%eax
8010715a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010715e:	0f b7 c0             	movzwl %ax,%eax
80107161:	83 e0 03             	and    $0x3,%eax
80107164:	83 f8 03             	cmp    $0x3,%eax
80107167:	75 05                	jne    8010716e <trap+0x27f>
    exit();
80107169:	e8 80 d8 ff ff       	call   801049ee <exit>
}
8010716e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107171:	5b                   	pop    %ebx
80107172:	5e                   	pop    %esi
80107173:	5f                   	pop    %edi
80107174:	5d                   	pop    %ebp
80107175:	c3                   	ret    

80107176 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107176:	55                   	push   %ebp
80107177:	89 e5                	mov    %esp,%ebp
80107179:	83 ec 14             	sub    $0x14,%esp
8010717c:	8b 45 08             	mov    0x8(%ebp),%eax
8010717f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107183:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107187:	89 c2                	mov    %eax,%edx
80107189:	ec                   	in     (%dx),%al
8010718a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010718d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107191:	c9                   	leave  
80107192:	c3                   	ret    

80107193 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107193:	55                   	push   %ebp
80107194:	89 e5                	mov    %esp,%ebp
80107196:	83 ec 08             	sub    $0x8,%esp
80107199:	8b 55 08             	mov    0x8(%ebp),%edx
8010719c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010719f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801071a3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071a6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801071aa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801071ae:	ee                   	out    %al,(%dx)
}
801071af:	c9                   	leave  
801071b0:	c3                   	ret    

801071b1 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801071b1:	55                   	push   %ebp
801071b2:	89 e5                	mov    %esp,%ebp
801071b4:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801071b7:	6a 00                	push   $0x0
801071b9:	68 fa 03 00 00       	push   $0x3fa
801071be:	e8 d0 ff ff ff       	call   80107193 <outb>
801071c3:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801071c6:	68 80 00 00 00       	push   $0x80
801071cb:	68 fb 03 00 00       	push   $0x3fb
801071d0:	e8 be ff ff ff       	call   80107193 <outb>
801071d5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801071d8:	6a 0c                	push   $0xc
801071da:	68 f8 03 00 00       	push   $0x3f8
801071df:	e8 af ff ff ff       	call   80107193 <outb>
801071e4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801071e7:	6a 00                	push   $0x0
801071e9:	68 f9 03 00 00       	push   $0x3f9
801071ee:	e8 a0 ff ff ff       	call   80107193 <outb>
801071f3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801071f6:	6a 03                	push   $0x3
801071f8:	68 fb 03 00 00       	push   $0x3fb
801071fd:	e8 91 ff ff ff       	call   80107193 <outb>
80107202:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107205:	6a 00                	push   $0x0
80107207:	68 fc 03 00 00       	push   $0x3fc
8010720c:	e8 82 ff ff ff       	call   80107193 <outb>
80107211:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107214:	6a 01                	push   $0x1
80107216:	68 f9 03 00 00       	push   $0x3f9
8010721b:	e8 73 ff ff ff       	call   80107193 <outb>
80107220:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107223:	68 fd 03 00 00       	push   $0x3fd
80107228:	e8 49 ff ff ff       	call   80107176 <inb>
8010722d:	83 c4 04             	add    $0x4,%esp
80107230:	3c ff                	cmp    $0xff,%al
80107232:	75 02                	jne    80107236 <uartinit+0x85>
    return;
80107234:	eb 6c                	jmp    801072a2 <uartinit+0xf1>
  uart = 1;
80107236:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
8010723d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107240:	68 fa 03 00 00       	push   $0x3fa
80107245:	e8 2c ff ff ff       	call   80107176 <inb>
8010724a:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010724d:	68 f8 03 00 00       	push   $0x3f8
80107252:	e8 1f ff ff ff       	call   80107176 <inb>
80107257:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010725a:	83 ec 0c             	sub    $0xc,%esp
8010725d:	6a 04                	push   $0x4
8010725f:	e8 e7 cb ff ff       	call   80103e4b <picenable>
80107264:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107267:	83 ec 08             	sub    $0x8,%esp
8010726a:	6a 00                	push   $0x0
8010726c:	6a 04                	push   $0x4
8010726e:	e8 97 b7 ff ff       	call   80102a0a <ioapicenable>
80107273:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107276:	c7 45 f4 a0 91 10 80 	movl   $0x801091a0,-0xc(%ebp)
8010727d:	eb 19                	jmp    80107298 <uartinit+0xe7>
    uartputc(*p);
8010727f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107282:	0f b6 00             	movzbl (%eax),%eax
80107285:	0f be c0             	movsbl %al,%eax
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	50                   	push   %eax
8010728c:	e8 13 00 00 00       	call   801072a4 <uartputc>
80107291:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107294:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729b:	0f b6 00             	movzbl (%eax),%eax
8010729e:	84 c0                	test   %al,%al
801072a0:	75 dd                	jne    8010727f <uartinit+0xce>
    uartputc(*p);
}
801072a2:	c9                   	leave  
801072a3:	c3                   	ret    

801072a4 <uartputc>:

void
uartputc(int c)
{
801072a4:	55                   	push   %ebp
801072a5:	89 e5                	mov    %esp,%ebp
801072a7:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801072aa:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801072af:	85 c0                	test   %eax,%eax
801072b1:	75 02                	jne    801072b5 <uartputc+0x11>
    return;
801072b3:	eb 51                	jmp    80107306 <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801072bc:	eb 11                	jmp    801072cf <uartputc+0x2b>
    microdelay(10);
801072be:	83 ec 0c             	sub    $0xc,%esp
801072c1:	6a 0a                	push   $0xa
801072c3:	e8 9d bc ff ff       	call   80102f65 <microdelay>
801072c8:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801072cf:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801072d3:	7f 1a                	jg     801072ef <uartputc+0x4b>
801072d5:	83 ec 0c             	sub    $0xc,%esp
801072d8:	68 fd 03 00 00       	push   $0x3fd
801072dd:	e8 94 fe ff ff       	call   80107176 <inb>
801072e2:	83 c4 10             	add    $0x10,%esp
801072e5:	0f b6 c0             	movzbl %al,%eax
801072e8:	83 e0 20             	and    $0x20,%eax
801072eb:	85 c0                	test   %eax,%eax
801072ed:	74 cf                	je     801072be <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801072ef:	8b 45 08             	mov    0x8(%ebp),%eax
801072f2:	0f b6 c0             	movzbl %al,%eax
801072f5:	83 ec 08             	sub    $0x8,%esp
801072f8:	50                   	push   %eax
801072f9:	68 f8 03 00 00       	push   $0x3f8
801072fe:	e8 90 fe ff ff       	call   80107193 <outb>
80107303:	83 c4 10             	add    $0x10,%esp
}
80107306:	c9                   	leave  
80107307:	c3                   	ret    

80107308 <uartgetc>:

static int
uartgetc(void)
{
80107308:	55                   	push   %ebp
80107309:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010730b:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107310:	85 c0                	test   %eax,%eax
80107312:	75 07                	jne    8010731b <uartgetc+0x13>
    return -1;
80107314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107319:	eb 2e                	jmp    80107349 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010731b:	68 fd 03 00 00       	push   $0x3fd
80107320:	e8 51 fe ff ff       	call   80107176 <inb>
80107325:	83 c4 04             	add    $0x4,%esp
80107328:	0f b6 c0             	movzbl %al,%eax
8010732b:	83 e0 01             	and    $0x1,%eax
8010732e:	85 c0                	test   %eax,%eax
80107330:	75 07                	jne    80107339 <uartgetc+0x31>
    return -1;
80107332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107337:	eb 10                	jmp    80107349 <uartgetc+0x41>
  return inb(COM1+0);
80107339:	68 f8 03 00 00       	push   $0x3f8
8010733e:	e8 33 fe ff ff       	call   80107176 <inb>
80107343:	83 c4 04             	add    $0x4,%esp
80107346:	0f b6 c0             	movzbl %al,%eax
}
80107349:	c9                   	leave  
8010734a:	c3                   	ret    

8010734b <uartintr>:

void
uartintr(void)
{
8010734b:	55                   	push   %ebp
8010734c:	89 e5                	mov    %esp,%ebp
8010734e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107351:	83 ec 0c             	sub    $0xc,%esp
80107354:	68 08 73 10 80       	push   $0x80107308
80107359:	e8 73 94 ff ff       	call   801007d1 <consoleintr>
8010735e:	83 c4 10             	add    $0x10,%esp
}
80107361:	c9                   	leave  
80107362:	c3                   	ret    

80107363 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $0
80107365:	6a 00                	push   $0x0
  jmp alltraps
80107367:	e9 92 f9 ff ff       	jmp    80106cfe <alltraps>

8010736c <vector1>:
.globl vector1
vector1:
  pushl $0
8010736c:	6a 00                	push   $0x0
  pushl $1
8010736e:	6a 01                	push   $0x1
  jmp alltraps
80107370:	e9 89 f9 ff ff       	jmp    80106cfe <alltraps>

80107375 <vector2>:
.globl vector2
vector2:
  pushl $0
80107375:	6a 00                	push   $0x0
  pushl $2
80107377:	6a 02                	push   $0x2
  jmp alltraps
80107379:	e9 80 f9 ff ff       	jmp    80106cfe <alltraps>

8010737e <vector3>:
.globl vector3
vector3:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $3
80107380:	6a 03                	push   $0x3
  jmp alltraps
80107382:	e9 77 f9 ff ff       	jmp    80106cfe <alltraps>

80107387 <vector4>:
.globl vector4
vector4:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $4
80107389:	6a 04                	push   $0x4
  jmp alltraps
8010738b:	e9 6e f9 ff ff       	jmp    80106cfe <alltraps>

80107390 <vector5>:
.globl vector5
vector5:
  pushl $0
80107390:	6a 00                	push   $0x0
  pushl $5
80107392:	6a 05                	push   $0x5
  jmp alltraps
80107394:	e9 65 f9 ff ff       	jmp    80106cfe <alltraps>

80107399 <vector6>:
.globl vector6
vector6:
  pushl $0
80107399:	6a 00                	push   $0x0
  pushl $6
8010739b:	6a 06                	push   $0x6
  jmp alltraps
8010739d:	e9 5c f9 ff ff       	jmp    80106cfe <alltraps>

801073a2 <vector7>:
.globl vector7
vector7:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $7
801073a4:	6a 07                	push   $0x7
  jmp alltraps
801073a6:	e9 53 f9 ff ff       	jmp    80106cfe <alltraps>

801073ab <vector8>:
.globl vector8
vector8:
  pushl $8
801073ab:	6a 08                	push   $0x8
  jmp alltraps
801073ad:	e9 4c f9 ff ff       	jmp    80106cfe <alltraps>

801073b2 <vector9>:
.globl vector9
vector9:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $9
801073b4:	6a 09                	push   $0x9
  jmp alltraps
801073b6:	e9 43 f9 ff ff       	jmp    80106cfe <alltraps>

801073bb <vector10>:
.globl vector10
vector10:
  pushl $10
801073bb:	6a 0a                	push   $0xa
  jmp alltraps
801073bd:	e9 3c f9 ff ff       	jmp    80106cfe <alltraps>

801073c2 <vector11>:
.globl vector11
vector11:
  pushl $11
801073c2:	6a 0b                	push   $0xb
  jmp alltraps
801073c4:	e9 35 f9 ff ff       	jmp    80106cfe <alltraps>

801073c9 <vector12>:
.globl vector12
vector12:
  pushl $12
801073c9:	6a 0c                	push   $0xc
  jmp alltraps
801073cb:	e9 2e f9 ff ff       	jmp    80106cfe <alltraps>

801073d0 <vector13>:
.globl vector13
vector13:
  pushl $13
801073d0:	6a 0d                	push   $0xd
  jmp alltraps
801073d2:	e9 27 f9 ff ff       	jmp    80106cfe <alltraps>

801073d7 <vector14>:
.globl vector14
vector14:
  pushl $14
801073d7:	6a 0e                	push   $0xe
  jmp alltraps
801073d9:	e9 20 f9 ff ff       	jmp    80106cfe <alltraps>

801073de <vector15>:
.globl vector15
vector15:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $15
801073e0:	6a 0f                	push   $0xf
  jmp alltraps
801073e2:	e9 17 f9 ff ff       	jmp    80106cfe <alltraps>

801073e7 <vector16>:
.globl vector16
vector16:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $16
801073e9:	6a 10                	push   $0x10
  jmp alltraps
801073eb:	e9 0e f9 ff ff       	jmp    80106cfe <alltraps>

801073f0 <vector17>:
.globl vector17
vector17:
  pushl $17
801073f0:	6a 11                	push   $0x11
  jmp alltraps
801073f2:	e9 07 f9 ff ff       	jmp    80106cfe <alltraps>

801073f7 <vector18>:
.globl vector18
vector18:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $18
801073f9:	6a 12                	push   $0x12
  jmp alltraps
801073fb:	e9 fe f8 ff ff       	jmp    80106cfe <alltraps>

80107400 <vector19>:
.globl vector19
vector19:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $19
80107402:	6a 13                	push   $0x13
  jmp alltraps
80107404:	e9 f5 f8 ff ff       	jmp    80106cfe <alltraps>

80107409 <vector20>:
.globl vector20
vector20:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $20
8010740b:	6a 14                	push   $0x14
  jmp alltraps
8010740d:	e9 ec f8 ff ff       	jmp    80106cfe <alltraps>

80107412 <vector21>:
.globl vector21
vector21:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $21
80107414:	6a 15                	push   $0x15
  jmp alltraps
80107416:	e9 e3 f8 ff ff       	jmp    80106cfe <alltraps>

8010741b <vector22>:
.globl vector22
vector22:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $22
8010741d:	6a 16                	push   $0x16
  jmp alltraps
8010741f:	e9 da f8 ff ff       	jmp    80106cfe <alltraps>

80107424 <vector23>:
.globl vector23
vector23:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $23
80107426:	6a 17                	push   $0x17
  jmp alltraps
80107428:	e9 d1 f8 ff ff       	jmp    80106cfe <alltraps>

8010742d <vector24>:
.globl vector24
vector24:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $24
8010742f:	6a 18                	push   $0x18
  jmp alltraps
80107431:	e9 c8 f8 ff ff       	jmp    80106cfe <alltraps>

80107436 <vector25>:
.globl vector25
vector25:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $25
80107438:	6a 19                	push   $0x19
  jmp alltraps
8010743a:	e9 bf f8 ff ff       	jmp    80106cfe <alltraps>

8010743f <vector26>:
.globl vector26
vector26:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $26
80107441:	6a 1a                	push   $0x1a
  jmp alltraps
80107443:	e9 b6 f8 ff ff       	jmp    80106cfe <alltraps>

80107448 <vector27>:
.globl vector27
vector27:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $27
8010744a:	6a 1b                	push   $0x1b
  jmp alltraps
8010744c:	e9 ad f8 ff ff       	jmp    80106cfe <alltraps>

80107451 <vector28>:
.globl vector28
vector28:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $28
80107453:	6a 1c                	push   $0x1c
  jmp alltraps
80107455:	e9 a4 f8 ff ff       	jmp    80106cfe <alltraps>

8010745a <vector29>:
.globl vector29
vector29:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $29
8010745c:	6a 1d                	push   $0x1d
  jmp alltraps
8010745e:	e9 9b f8 ff ff       	jmp    80106cfe <alltraps>

80107463 <vector30>:
.globl vector30
vector30:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $30
80107465:	6a 1e                	push   $0x1e
  jmp alltraps
80107467:	e9 92 f8 ff ff       	jmp    80106cfe <alltraps>

8010746c <vector31>:
.globl vector31
vector31:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $31
8010746e:	6a 1f                	push   $0x1f
  jmp alltraps
80107470:	e9 89 f8 ff ff       	jmp    80106cfe <alltraps>

80107475 <vector32>:
.globl vector32
vector32:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $32
80107477:	6a 20                	push   $0x20
  jmp alltraps
80107479:	e9 80 f8 ff ff       	jmp    80106cfe <alltraps>

8010747e <vector33>:
.globl vector33
vector33:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $33
80107480:	6a 21                	push   $0x21
  jmp alltraps
80107482:	e9 77 f8 ff ff       	jmp    80106cfe <alltraps>

80107487 <vector34>:
.globl vector34
vector34:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $34
80107489:	6a 22                	push   $0x22
  jmp alltraps
8010748b:	e9 6e f8 ff ff       	jmp    80106cfe <alltraps>

80107490 <vector35>:
.globl vector35
vector35:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $35
80107492:	6a 23                	push   $0x23
  jmp alltraps
80107494:	e9 65 f8 ff ff       	jmp    80106cfe <alltraps>

80107499 <vector36>:
.globl vector36
vector36:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $36
8010749b:	6a 24                	push   $0x24
  jmp alltraps
8010749d:	e9 5c f8 ff ff       	jmp    80106cfe <alltraps>

801074a2 <vector37>:
.globl vector37
vector37:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $37
801074a4:	6a 25                	push   $0x25
  jmp alltraps
801074a6:	e9 53 f8 ff ff       	jmp    80106cfe <alltraps>

801074ab <vector38>:
.globl vector38
vector38:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $38
801074ad:	6a 26                	push   $0x26
  jmp alltraps
801074af:	e9 4a f8 ff ff       	jmp    80106cfe <alltraps>

801074b4 <vector39>:
.globl vector39
vector39:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $39
801074b6:	6a 27                	push   $0x27
  jmp alltraps
801074b8:	e9 41 f8 ff ff       	jmp    80106cfe <alltraps>

801074bd <vector40>:
.globl vector40
vector40:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $40
801074bf:	6a 28                	push   $0x28
  jmp alltraps
801074c1:	e9 38 f8 ff ff       	jmp    80106cfe <alltraps>

801074c6 <vector41>:
.globl vector41
vector41:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $41
801074c8:	6a 29                	push   $0x29
  jmp alltraps
801074ca:	e9 2f f8 ff ff       	jmp    80106cfe <alltraps>

801074cf <vector42>:
.globl vector42
vector42:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $42
801074d1:	6a 2a                	push   $0x2a
  jmp alltraps
801074d3:	e9 26 f8 ff ff       	jmp    80106cfe <alltraps>

801074d8 <vector43>:
.globl vector43
vector43:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $43
801074da:	6a 2b                	push   $0x2b
  jmp alltraps
801074dc:	e9 1d f8 ff ff       	jmp    80106cfe <alltraps>

801074e1 <vector44>:
.globl vector44
vector44:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $44
801074e3:	6a 2c                	push   $0x2c
  jmp alltraps
801074e5:	e9 14 f8 ff ff       	jmp    80106cfe <alltraps>

801074ea <vector45>:
.globl vector45
vector45:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $45
801074ec:	6a 2d                	push   $0x2d
  jmp alltraps
801074ee:	e9 0b f8 ff ff       	jmp    80106cfe <alltraps>

801074f3 <vector46>:
.globl vector46
vector46:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $46
801074f5:	6a 2e                	push   $0x2e
  jmp alltraps
801074f7:	e9 02 f8 ff ff       	jmp    80106cfe <alltraps>

801074fc <vector47>:
.globl vector47
vector47:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $47
801074fe:	6a 2f                	push   $0x2f
  jmp alltraps
80107500:	e9 f9 f7 ff ff       	jmp    80106cfe <alltraps>

80107505 <vector48>:
.globl vector48
vector48:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $48
80107507:	6a 30                	push   $0x30
  jmp alltraps
80107509:	e9 f0 f7 ff ff       	jmp    80106cfe <alltraps>

8010750e <vector49>:
.globl vector49
vector49:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $49
80107510:	6a 31                	push   $0x31
  jmp alltraps
80107512:	e9 e7 f7 ff ff       	jmp    80106cfe <alltraps>

80107517 <vector50>:
.globl vector50
vector50:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $50
80107519:	6a 32                	push   $0x32
  jmp alltraps
8010751b:	e9 de f7 ff ff       	jmp    80106cfe <alltraps>

80107520 <vector51>:
.globl vector51
vector51:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $51
80107522:	6a 33                	push   $0x33
  jmp alltraps
80107524:	e9 d5 f7 ff ff       	jmp    80106cfe <alltraps>

80107529 <vector52>:
.globl vector52
vector52:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $52
8010752b:	6a 34                	push   $0x34
  jmp alltraps
8010752d:	e9 cc f7 ff ff       	jmp    80106cfe <alltraps>

80107532 <vector53>:
.globl vector53
vector53:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $53
80107534:	6a 35                	push   $0x35
  jmp alltraps
80107536:	e9 c3 f7 ff ff       	jmp    80106cfe <alltraps>

8010753b <vector54>:
.globl vector54
vector54:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $54
8010753d:	6a 36                	push   $0x36
  jmp alltraps
8010753f:	e9 ba f7 ff ff       	jmp    80106cfe <alltraps>

80107544 <vector55>:
.globl vector55
vector55:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $55
80107546:	6a 37                	push   $0x37
  jmp alltraps
80107548:	e9 b1 f7 ff ff       	jmp    80106cfe <alltraps>

8010754d <vector56>:
.globl vector56
vector56:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $56
8010754f:	6a 38                	push   $0x38
  jmp alltraps
80107551:	e9 a8 f7 ff ff       	jmp    80106cfe <alltraps>

80107556 <vector57>:
.globl vector57
vector57:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $57
80107558:	6a 39                	push   $0x39
  jmp alltraps
8010755a:	e9 9f f7 ff ff       	jmp    80106cfe <alltraps>

8010755f <vector58>:
.globl vector58
vector58:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $58
80107561:	6a 3a                	push   $0x3a
  jmp alltraps
80107563:	e9 96 f7 ff ff       	jmp    80106cfe <alltraps>

80107568 <vector59>:
.globl vector59
vector59:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $59
8010756a:	6a 3b                	push   $0x3b
  jmp alltraps
8010756c:	e9 8d f7 ff ff       	jmp    80106cfe <alltraps>

80107571 <vector60>:
.globl vector60
vector60:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $60
80107573:	6a 3c                	push   $0x3c
  jmp alltraps
80107575:	e9 84 f7 ff ff       	jmp    80106cfe <alltraps>

8010757a <vector61>:
.globl vector61
vector61:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $61
8010757c:	6a 3d                	push   $0x3d
  jmp alltraps
8010757e:	e9 7b f7 ff ff       	jmp    80106cfe <alltraps>

80107583 <vector62>:
.globl vector62
vector62:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $62
80107585:	6a 3e                	push   $0x3e
  jmp alltraps
80107587:	e9 72 f7 ff ff       	jmp    80106cfe <alltraps>

8010758c <vector63>:
.globl vector63
vector63:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $63
8010758e:	6a 3f                	push   $0x3f
  jmp alltraps
80107590:	e9 69 f7 ff ff       	jmp    80106cfe <alltraps>

80107595 <vector64>:
.globl vector64
vector64:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $64
80107597:	6a 40                	push   $0x40
  jmp alltraps
80107599:	e9 60 f7 ff ff       	jmp    80106cfe <alltraps>

8010759e <vector65>:
.globl vector65
vector65:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $65
801075a0:	6a 41                	push   $0x41
  jmp alltraps
801075a2:	e9 57 f7 ff ff       	jmp    80106cfe <alltraps>

801075a7 <vector66>:
.globl vector66
vector66:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $66
801075a9:	6a 42                	push   $0x42
  jmp alltraps
801075ab:	e9 4e f7 ff ff       	jmp    80106cfe <alltraps>

801075b0 <vector67>:
.globl vector67
vector67:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $67
801075b2:	6a 43                	push   $0x43
  jmp alltraps
801075b4:	e9 45 f7 ff ff       	jmp    80106cfe <alltraps>

801075b9 <vector68>:
.globl vector68
vector68:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $68
801075bb:	6a 44                	push   $0x44
  jmp alltraps
801075bd:	e9 3c f7 ff ff       	jmp    80106cfe <alltraps>

801075c2 <vector69>:
.globl vector69
vector69:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $69
801075c4:	6a 45                	push   $0x45
  jmp alltraps
801075c6:	e9 33 f7 ff ff       	jmp    80106cfe <alltraps>

801075cb <vector70>:
.globl vector70
vector70:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $70
801075cd:	6a 46                	push   $0x46
  jmp alltraps
801075cf:	e9 2a f7 ff ff       	jmp    80106cfe <alltraps>

801075d4 <vector71>:
.globl vector71
vector71:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $71
801075d6:	6a 47                	push   $0x47
  jmp alltraps
801075d8:	e9 21 f7 ff ff       	jmp    80106cfe <alltraps>

801075dd <vector72>:
.globl vector72
vector72:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $72
801075df:	6a 48                	push   $0x48
  jmp alltraps
801075e1:	e9 18 f7 ff ff       	jmp    80106cfe <alltraps>

801075e6 <vector73>:
.globl vector73
vector73:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $73
801075e8:	6a 49                	push   $0x49
  jmp alltraps
801075ea:	e9 0f f7 ff ff       	jmp    80106cfe <alltraps>

801075ef <vector74>:
.globl vector74
vector74:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $74
801075f1:	6a 4a                	push   $0x4a
  jmp alltraps
801075f3:	e9 06 f7 ff ff       	jmp    80106cfe <alltraps>

801075f8 <vector75>:
.globl vector75
vector75:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $75
801075fa:	6a 4b                	push   $0x4b
  jmp alltraps
801075fc:	e9 fd f6 ff ff       	jmp    80106cfe <alltraps>

80107601 <vector76>:
.globl vector76
vector76:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $76
80107603:	6a 4c                	push   $0x4c
  jmp alltraps
80107605:	e9 f4 f6 ff ff       	jmp    80106cfe <alltraps>

8010760a <vector77>:
.globl vector77
vector77:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $77
8010760c:	6a 4d                	push   $0x4d
  jmp alltraps
8010760e:	e9 eb f6 ff ff       	jmp    80106cfe <alltraps>

80107613 <vector78>:
.globl vector78
vector78:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $78
80107615:	6a 4e                	push   $0x4e
  jmp alltraps
80107617:	e9 e2 f6 ff ff       	jmp    80106cfe <alltraps>

8010761c <vector79>:
.globl vector79
vector79:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $79
8010761e:	6a 4f                	push   $0x4f
  jmp alltraps
80107620:	e9 d9 f6 ff ff       	jmp    80106cfe <alltraps>

80107625 <vector80>:
.globl vector80
vector80:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $80
80107627:	6a 50                	push   $0x50
  jmp alltraps
80107629:	e9 d0 f6 ff ff       	jmp    80106cfe <alltraps>

8010762e <vector81>:
.globl vector81
vector81:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $81
80107630:	6a 51                	push   $0x51
  jmp alltraps
80107632:	e9 c7 f6 ff ff       	jmp    80106cfe <alltraps>

80107637 <vector82>:
.globl vector82
vector82:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $82
80107639:	6a 52                	push   $0x52
  jmp alltraps
8010763b:	e9 be f6 ff ff       	jmp    80106cfe <alltraps>

80107640 <vector83>:
.globl vector83
vector83:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $83
80107642:	6a 53                	push   $0x53
  jmp alltraps
80107644:	e9 b5 f6 ff ff       	jmp    80106cfe <alltraps>

80107649 <vector84>:
.globl vector84
vector84:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $84
8010764b:	6a 54                	push   $0x54
  jmp alltraps
8010764d:	e9 ac f6 ff ff       	jmp    80106cfe <alltraps>

80107652 <vector85>:
.globl vector85
vector85:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $85
80107654:	6a 55                	push   $0x55
  jmp alltraps
80107656:	e9 a3 f6 ff ff       	jmp    80106cfe <alltraps>

8010765b <vector86>:
.globl vector86
vector86:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $86
8010765d:	6a 56                	push   $0x56
  jmp alltraps
8010765f:	e9 9a f6 ff ff       	jmp    80106cfe <alltraps>

80107664 <vector87>:
.globl vector87
vector87:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $87
80107666:	6a 57                	push   $0x57
  jmp alltraps
80107668:	e9 91 f6 ff ff       	jmp    80106cfe <alltraps>

8010766d <vector88>:
.globl vector88
vector88:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $88
8010766f:	6a 58                	push   $0x58
  jmp alltraps
80107671:	e9 88 f6 ff ff       	jmp    80106cfe <alltraps>

80107676 <vector89>:
.globl vector89
vector89:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $89
80107678:	6a 59                	push   $0x59
  jmp alltraps
8010767a:	e9 7f f6 ff ff       	jmp    80106cfe <alltraps>

8010767f <vector90>:
.globl vector90
vector90:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $90
80107681:	6a 5a                	push   $0x5a
  jmp alltraps
80107683:	e9 76 f6 ff ff       	jmp    80106cfe <alltraps>

80107688 <vector91>:
.globl vector91
vector91:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $91
8010768a:	6a 5b                	push   $0x5b
  jmp alltraps
8010768c:	e9 6d f6 ff ff       	jmp    80106cfe <alltraps>

80107691 <vector92>:
.globl vector92
vector92:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $92
80107693:	6a 5c                	push   $0x5c
  jmp alltraps
80107695:	e9 64 f6 ff ff       	jmp    80106cfe <alltraps>

8010769a <vector93>:
.globl vector93
vector93:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $93
8010769c:	6a 5d                	push   $0x5d
  jmp alltraps
8010769e:	e9 5b f6 ff ff       	jmp    80106cfe <alltraps>

801076a3 <vector94>:
.globl vector94
vector94:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $94
801076a5:	6a 5e                	push   $0x5e
  jmp alltraps
801076a7:	e9 52 f6 ff ff       	jmp    80106cfe <alltraps>

801076ac <vector95>:
.globl vector95
vector95:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $95
801076ae:	6a 5f                	push   $0x5f
  jmp alltraps
801076b0:	e9 49 f6 ff ff       	jmp    80106cfe <alltraps>

801076b5 <vector96>:
.globl vector96
vector96:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $96
801076b7:	6a 60                	push   $0x60
  jmp alltraps
801076b9:	e9 40 f6 ff ff       	jmp    80106cfe <alltraps>

801076be <vector97>:
.globl vector97
vector97:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $97
801076c0:	6a 61                	push   $0x61
  jmp alltraps
801076c2:	e9 37 f6 ff ff       	jmp    80106cfe <alltraps>

801076c7 <vector98>:
.globl vector98
vector98:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $98
801076c9:	6a 62                	push   $0x62
  jmp alltraps
801076cb:	e9 2e f6 ff ff       	jmp    80106cfe <alltraps>

801076d0 <vector99>:
.globl vector99
vector99:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $99
801076d2:	6a 63                	push   $0x63
  jmp alltraps
801076d4:	e9 25 f6 ff ff       	jmp    80106cfe <alltraps>

801076d9 <vector100>:
.globl vector100
vector100:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $100
801076db:	6a 64                	push   $0x64
  jmp alltraps
801076dd:	e9 1c f6 ff ff       	jmp    80106cfe <alltraps>

801076e2 <vector101>:
.globl vector101
vector101:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $101
801076e4:	6a 65                	push   $0x65
  jmp alltraps
801076e6:	e9 13 f6 ff ff       	jmp    80106cfe <alltraps>

801076eb <vector102>:
.globl vector102
vector102:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $102
801076ed:	6a 66                	push   $0x66
  jmp alltraps
801076ef:	e9 0a f6 ff ff       	jmp    80106cfe <alltraps>

801076f4 <vector103>:
.globl vector103
vector103:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $103
801076f6:	6a 67                	push   $0x67
  jmp alltraps
801076f8:	e9 01 f6 ff ff       	jmp    80106cfe <alltraps>

801076fd <vector104>:
.globl vector104
vector104:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $104
801076ff:	6a 68                	push   $0x68
  jmp alltraps
80107701:	e9 f8 f5 ff ff       	jmp    80106cfe <alltraps>

80107706 <vector105>:
.globl vector105
vector105:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $105
80107708:	6a 69                	push   $0x69
  jmp alltraps
8010770a:	e9 ef f5 ff ff       	jmp    80106cfe <alltraps>

8010770f <vector106>:
.globl vector106
vector106:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $106
80107711:	6a 6a                	push   $0x6a
  jmp alltraps
80107713:	e9 e6 f5 ff ff       	jmp    80106cfe <alltraps>

80107718 <vector107>:
.globl vector107
vector107:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $107
8010771a:	6a 6b                	push   $0x6b
  jmp alltraps
8010771c:	e9 dd f5 ff ff       	jmp    80106cfe <alltraps>

80107721 <vector108>:
.globl vector108
vector108:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $108
80107723:	6a 6c                	push   $0x6c
  jmp alltraps
80107725:	e9 d4 f5 ff ff       	jmp    80106cfe <alltraps>

8010772a <vector109>:
.globl vector109
vector109:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $109
8010772c:	6a 6d                	push   $0x6d
  jmp alltraps
8010772e:	e9 cb f5 ff ff       	jmp    80106cfe <alltraps>

80107733 <vector110>:
.globl vector110
vector110:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $110
80107735:	6a 6e                	push   $0x6e
  jmp alltraps
80107737:	e9 c2 f5 ff ff       	jmp    80106cfe <alltraps>

8010773c <vector111>:
.globl vector111
vector111:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $111
8010773e:	6a 6f                	push   $0x6f
  jmp alltraps
80107740:	e9 b9 f5 ff ff       	jmp    80106cfe <alltraps>

80107745 <vector112>:
.globl vector112
vector112:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $112
80107747:	6a 70                	push   $0x70
  jmp alltraps
80107749:	e9 b0 f5 ff ff       	jmp    80106cfe <alltraps>

8010774e <vector113>:
.globl vector113
vector113:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $113
80107750:	6a 71                	push   $0x71
  jmp alltraps
80107752:	e9 a7 f5 ff ff       	jmp    80106cfe <alltraps>

80107757 <vector114>:
.globl vector114
vector114:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $114
80107759:	6a 72                	push   $0x72
  jmp alltraps
8010775b:	e9 9e f5 ff ff       	jmp    80106cfe <alltraps>

80107760 <vector115>:
.globl vector115
vector115:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $115
80107762:	6a 73                	push   $0x73
  jmp alltraps
80107764:	e9 95 f5 ff ff       	jmp    80106cfe <alltraps>

80107769 <vector116>:
.globl vector116
vector116:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $116
8010776b:	6a 74                	push   $0x74
  jmp alltraps
8010776d:	e9 8c f5 ff ff       	jmp    80106cfe <alltraps>

80107772 <vector117>:
.globl vector117
vector117:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $117
80107774:	6a 75                	push   $0x75
  jmp alltraps
80107776:	e9 83 f5 ff ff       	jmp    80106cfe <alltraps>

8010777b <vector118>:
.globl vector118
vector118:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $118
8010777d:	6a 76                	push   $0x76
  jmp alltraps
8010777f:	e9 7a f5 ff ff       	jmp    80106cfe <alltraps>

80107784 <vector119>:
.globl vector119
vector119:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $119
80107786:	6a 77                	push   $0x77
  jmp alltraps
80107788:	e9 71 f5 ff ff       	jmp    80106cfe <alltraps>

8010778d <vector120>:
.globl vector120
vector120:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $120
8010778f:	6a 78                	push   $0x78
  jmp alltraps
80107791:	e9 68 f5 ff ff       	jmp    80106cfe <alltraps>

80107796 <vector121>:
.globl vector121
vector121:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $121
80107798:	6a 79                	push   $0x79
  jmp alltraps
8010779a:	e9 5f f5 ff ff       	jmp    80106cfe <alltraps>

8010779f <vector122>:
.globl vector122
vector122:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $122
801077a1:	6a 7a                	push   $0x7a
  jmp alltraps
801077a3:	e9 56 f5 ff ff       	jmp    80106cfe <alltraps>

801077a8 <vector123>:
.globl vector123
vector123:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $123
801077aa:	6a 7b                	push   $0x7b
  jmp alltraps
801077ac:	e9 4d f5 ff ff       	jmp    80106cfe <alltraps>

801077b1 <vector124>:
.globl vector124
vector124:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $124
801077b3:	6a 7c                	push   $0x7c
  jmp alltraps
801077b5:	e9 44 f5 ff ff       	jmp    80106cfe <alltraps>

801077ba <vector125>:
.globl vector125
vector125:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $125
801077bc:	6a 7d                	push   $0x7d
  jmp alltraps
801077be:	e9 3b f5 ff ff       	jmp    80106cfe <alltraps>

801077c3 <vector126>:
.globl vector126
vector126:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $126
801077c5:	6a 7e                	push   $0x7e
  jmp alltraps
801077c7:	e9 32 f5 ff ff       	jmp    80106cfe <alltraps>

801077cc <vector127>:
.globl vector127
vector127:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $127
801077ce:	6a 7f                	push   $0x7f
  jmp alltraps
801077d0:	e9 29 f5 ff ff       	jmp    80106cfe <alltraps>

801077d5 <vector128>:
.globl vector128
vector128:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $128
801077d7:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801077dc:	e9 1d f5 ff ff       	jmp    80106cfe <alltraps>

801077e1 <vector129>:
.globl vector129
vector129:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $129
801077e3:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801077e8:	e9 11 f5 ff ff       	jmp    80106cfe <alltraps>

801077ed <vector130>:
.globl vector130
vector130:
  pushl $0
801077ed:	6a 00                	push   $0x0
  pushl $130
801077ef:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801077f4:	e9 05 f5 ff ff       	jmp    80106cfe <alltraps>

801077f9 <vector131>:
.globl vector131
vector131:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $131
801077fb:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107800:	e9 f9 f4 ff ff       	jmp    80106cfe <alltraps>

80107805 <vector132>:
.globl vector132
vector132:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $132
80107807:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010780c:	e9 ed f4 ff ff       	jmp    80106cfe <alltraps>

80107811 <vector133>:
.globl vector133
vector133:
  pushl $0
80107811:	6a 00                	push   $0x0
  pushl $133
80107813:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107818:	e9 e1 f4 ff ff       	jmp    80106cfe <alltraps>

8010781d <vector134>:
.globl vector134
vector134:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $134
8010781f:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107824:	e9 d5 f4 ff ff       	jmp    80106cfe <alltraps>

80107829 <vector135>:
.globl vector135
vector135:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $135
8010782b:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107830:	e9 c9 f4 ff ff       	jmp    80106cfe <alltraps>

80107835 <vector136>:
.globl vector136
vector136:
  pushl $0
80107835:	6a 00                	push   $0x0
  pushl $136
80107837:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010783c:	e9 bd f4 ff ff       	jmp    80106cfe <alltraps>

80107841 <vector137>:
.globl vector137
vector137:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $137
80107843:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107848:	e9 b1 f4 ff ff       	jmp    80106cfe <alltraps>

8010784d <vector138>:
.globl vector138
vector138:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $138
8010784f:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107854:	e9 a5 f4 ff ff       	jmp    80106cfe <alltraps>

80107859 <vector139>:
.globl vector139
vector139:
  pushl $0
80107859:	6a 00                	push   $0x0
  pushl $139
8010785b:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107860:	e9 99 f4 ff ff       	jmp    80106cfe <alltraps>

80107865 <vector140>:
.globl vector140
vector140:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $140
80107867:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010786c:	e9 8d f4 ff ff       	jmp    80106cfe <alltraps>

80107871 <vector141>:
.globl vector141
vector141:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $141
80107873:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107878:	e9 81 f4 ff ff       	jmp    80106cfe <alltraps>

8010787d <vector142>:
.globl vector142
vector142:
  pushl $0
8010787d:	6a 00                	push   $0x0
  pushl $142
8010787f:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107884:	e9 75 f4 ff ff       	jmp    80106cfe <alltraps>

80107889 <vector143>:
.globl vector143
vector143:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $143
8010788b:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107890:	e9 69 f4 ff ff       	jmp    80106cfe <alltraps>

80107895 <vector144>:
.globl vector144
vector144:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $144
80107897:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010789c:	e9 5d f4 ff ff       	jmp    80106cfe <alltraps>

801078a1 <vector145>:
.globl vector145
vector145:
  pushl $0
801078a1:	6a 00                	push   $0x0
  pushl $145
801078a3:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801078a8:	e9 51 f4 ff ff       	jmp    80106cfe <alltraps>

801078ad <vector146>:
.globl vector146
vector146:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $146
801078af:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801078b4:	e9 45 f4 ff ff       	jmp    80106cfe <alltraps>

801078b9 <vector147>:
.globl vector147
vector147:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $147
801078bb:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801078c0:	e9 39 f4 ff ff       	jmp    80106cfe <alltraps>

801078c5 <vector148>:
.globl vector148
vector148:
  pushl $0
801078c5:	6a 00                	push   $0x0
  pushl $148
801078c7:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801078cc:	e9 2d f4 ff ff       	jmp    80106cfe <alltraps>

801078d1 <vector149>:
.globl vector149
vector149:
  pushl $0
801078d1:	6a 00                	push   $0x0
  pushl $149
801078d3:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801078d8:	e9 21 f4 ff ff       	jmp    80106cfe <alltraps>

801078dd <vector150>:
.globl vector150
vector150:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $150
801078df:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801078e4:	e9 15 f4 ff ff       	jmp    80106cfe <alltraps>

801078e9 <vector151>:
.globl vector151
vector151:
  pushl $0
801078e9:	6a 00                	push   $0x0
  pushl $151
801078eb:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801078f0:	e9 09 f4 ff ff       	jmp    80106cfe <alltraps>

801078f5 <vector152>:
.globl vector152
vector152:
  pushl $0
801078f5:	6a 00                	push   $0x0
  pushl $152
801078f7:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801078fc:	e9 fd f3 ff ff       	jmp    80106cfe <alltraps>

80107901 <vector153>:
.globl vector153
vector153:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $153
80107903:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107908:	e9 f1 f3 ff ff       	jmp    80106cfe <alltraps>

8010790d <vector154>:
.globl vector154
vector154:
  pushl $0
8010790d:	6a 00                	push   $0x0
  pushl $154
8010790f:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107914:	e9 e5 f3 ff ff       	jmp    80106cfe <alltraps>

80107919 <vector155>:
.globl vector155
vector155:
  pushl $0
80107919:	6a 00                	push   $0x0
  pushl $155
8010791b:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107920:	e9 d9 f3 ff ff       	jmp    80106cfe <alltraps>

80107925 <vector156>:
.globl vector156
vector156:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $156
80107927:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010792c:	e9 cd f3 ff ff       	jmp    80106cfe <alltraps>

80107931 <vector157>:
.globl vector157
vector157:
  pushl $0
80107931:	6a 00                	push   $0x0
  pushl $157
80107933:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107938:	e9 c1 f3 ff ff       	jmp    80106cfe <alltraps>

8010793d <vector158>:
.globl vector158
vector158:
  pushl $0
8010793d:	6a 00                	push   $0x0
  pushl $158
8010793f:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107944:	e9 b5 f3 ff ff       	jmp    80106cfe <alltraps>

80107949 <vector159>:
.globl vector159
vector159:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $159
8010794b:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107950:	e9 a9 f3 ff ff       	jmp    80106cfe <alltraps>

80107955 <vector160>:
.globl vector160
vector160:
  pushl $0
80107955:	6a 00                	push   $0x0
  pushl $160
80107957:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010795c:	e9 9d f3 ff ff       	jmp    80106cfe <alltraps>

80107961 <vector161>:
.globl vector161
vector161:
  pushl $0
80107961:	6a 00                	push   $0x0
  pushl $161
80107963:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107968:	e9 91 f3 ff ff       	jmp    80106cfe <alltraps>

8010796d <vector162>:
.globl vector162
vector162:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $162
8010796f:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107974:	e9 85 f3 ff ff       	jmp    80106cfe <alltraps>

80107979 <vector163>:
.globl vector163
vector163:
  pushl $0
80107979:	6a 00                	push   $0x0
  pushl $163
8010797b:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107980:	e9 79 f3 ff ff       	jmp    80106cfe <alltraps>

80107985 <vector164>:
.globl vector164
vector164:
  pushl $0
80107985:	6a 00                	push   $0x0
  pushl $164
80107987:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010798c:	e9 6d f3 ff ff       	jmp    80106cfe <alltraps>

80107991 <vector165>:
.globl vector165
vector165:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $165
80107993:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107998:	e9 61 f3 ff ff       	jmp    80106cfe <alltraps>

8010799d <vector166>:
.globl vector166
vector166:
  pushl $0
8010799d:	6a 00                	push   $0x0
  pushl $166
8010799f:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801079a4:	e9 55 f3 ff ff       	jmp    80106cfe <alltraps>

801079a9 <vector167>:
.globl vector167
vector167:
  pushl $0
801079a9:	6a 00                	push   $0x0
  pushl $167
801079ab:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801079b0:	e9 49 f3 ff ff       	jmp    80106cfe <alltraps>

801079b5 <vector168>:
.globl vector168
vector168:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $168
801079b7:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801079bc:	e9 3d f3 ff ff       	jmp    80106cfe <alltraps>

801079c1 <vector169>:
.globl vector169
vector169:
  pushl $0
801079c1:	6a 00                	push   $0x0
  pushl $169
801079c3:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801079c8:	e9 31 f3 ff ff       	jmp    80106cfe <alltraps>

801079cd <vector170>:
.globl vector170
vector170:
  pushl $0
801079cd:	6a 00                	push   $0x0
  pushl $170
801079cf:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801079d4:	e9 25 f3 ff ff       	jmp    80106cfe <alltraps>

801079d9 <vector171>:
.globl vector171
vector171:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $171
801079db:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801079e0:	e9 19 f3 ff ff       	jmp    80106cfe <alltraps>

801079e5 <vector172>:
.globl vector172
vector172:
  pushl $0
801079e5:	6a 00                	push   $0x0
  pushl $172
801079e7:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801079ec:	e9 0d f3 ff ff       	jmp    80106cfe <alltraps>

801079f1 <vector173>:
.globl vector173
vector173:
  pushl $0
801079f1:	6a 00                	push   $0x0
  pushl $173
801079f3:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801079f8:	e9 01 f3 ff ff       	jmp    80106cfe <alltraps>

801079fd <vector174>:
.globl vector174
vector174:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $174
801079ff:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a04:	e9 f5 f2 ff ff       	jmp    80106cfe <alltraps>

80107a09 <vector175>:
.globl vector175
vector175:
  pushl $0
80107a09:	6a 00                	push   $0x0
  pushl $175
80107a0b:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107a10:	e9 e9 f2 ff ff       	jmp    80106cfe <alltraps>

80107a15 <vector176>:
.globl vector176
vector176:
  pushl $0
80107a15:	6a 00                	push   $0x0
  pushl $176
80107a17:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107a1c:	e9 dd f2 ff ff       	jmp    80106cfe <alltraps>

80107a21 <vector177>:
.globl vector177
vector177:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $177
80107a23:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107a28:	e9 d1 f2 ff ff       	jmp    80106cfe <alltraps>

80107a2d <vector178>:
.globl vector178
vector178:
  pushl $0
80107a2d:	6a 00                	push   $0x0
  pushl $178
80107a2f:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107a34:	e9 c5 f2 ff ff       	jmp    80106cfe <alltraps>

80107a39 <vector179>:
.globl vector179
vector179:
  pushl $0
80107a39:	6a 00                	push   $0x0
  pushl $179
80107a3b:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107a40:	e9 b9 f2 ff ff       	jmp    80106cfe <alltraps>

80107a45 <vector180>:
.globl vector180
vector180:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $180
80107a47:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107a4c:	e9 ad f2 ff ff       	jmp    80106cfe <alltraps>

80107a51 <vector181>:
.globl vector181
vector181:
  pushl $0
80107a51:	6a 00                	push   $0x0
  pushl $181
80107a53:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107a58:	e9 a1 f2 ff ff       	jmp    80106cfe <alltraps>

80107a5d <vector182>:
.globl vector182
vector182:
  pushl $0
80107a5d:	6a 00                	push   $0x0
  pushl $182
80107a5f:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107a64:	e9 95 f2 ff ff       	jmp    80106cfe <alltraps>

80107a69 <vector183>:
.globl vector183
vector183:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $183
80107a6b:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107a70:	e9 89 f2 ff ff       	jmp    80106cfe <alltraps>

80107a75 <vector184>:
.globl vector184
vector184:
  pushl $0
80107a75:	6a 00                	push   $0x0
  pushl $184
80107a77:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107a7c:	e9 7d f2 ff ff       	jmp    80106cfe <alltraps>

80107a81 <vector185>:
.globl vector185
vector185:
  pushl $0
80107a81:	6a 00                	push   $0x0
  pushl $185
80107a83:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107a88:	e9 71 f2 ff ff       	jmp    80106cfe <alltraps>

80107a8d <vector186>:
.globl vector186
vector186:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $186
80107a8f:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107a94:	e9 65 f2 ff ff       	jmp    80106cfe <alltraps>

80107a99 <vector187>:
.globl vector187
vector187:
  pushl $0
80107a99:	6a 00                	push   $0x0
  pushl $187
80107a9b:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107aa0:	e9 59 f2 ff ff       	jmp    80106cfe <alltraps>

80107aa5 <vector188>:
.globl vector188
vector188:
  pushl $0
80107aa5:	6a 00                	push   $0x0
  pushl $188
80107aa7:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107aac:	e9 4d f2 ff ff       	jmp    80106cfe <alltraps>

80107ab1 <vector189>:
.globl vector189
vector189:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $189
80107ab3:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107ab8:	e9 41 f2 ff ff       	jmp    80106cfe <alltraps>

80107abd <vector190>:
.globl vector190
vector190:
  pushl $0
80107abd:	6a 00                	push   $0x0
  pushl $190
80107abf:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107ac4:	e9 35 f2 ff ff       	jmp    80106cfe <alltraps>

80107ac9 <vector191>:
.globl vector191
vector191:
  pushl $0
80107ac9:	6a 00                	push   $0x0
  pushl $191
80107acb:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107ad0:	e9 29 f2 ff ff       	jmp    80106cfe <alltraps>

80107ad5 <vector192>:
.globl vector192
vector192:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $192
80107ad7:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107adc:	e9 1d f2 ff ff       	jmp    80106cfe <alltraps>

80107ae1 <vector193>:
.globl vector193
vector193:
  pushl $0
80107ae1:	6a 00                	push   $0x0
  pushl $193
80107ae3:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107ae8:	e9 11 f2 ff ff       	jmp    80106cfe <alltraps>

80107aed <vector194>:
.globl vector194
vector194:
  pushl $0
80107aed:	6a 00                	push   $0x0
  pushl $194
80107aef:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107af4:	e9 05 f2 ff ff       	jmp    80106cfe <alltraps>

80107af9 <vector195>:
.globl vector195
vector195:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $195
80107afb:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b00:	e9 f9 f1 ff ff       	jmp    80106cfe <alltraps>

80107b05 <vector196>:
.globl vector196
vector196:
  pushl $0
80107b05:	6a 00                	push   $0x0
  pushl $196
80107b07:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b0c:	e9 ed f1 ff ff       	jmp    80106cfe <alltraps>

80107b11 <vector197>:
.globl vector197
vector197:
  pushl $0
80107b11:	6a 00                	push   $0x0
  pushl $197
80107b13:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107b18:	e9 e1 f1 ff ff       	jmp    80106cfe <alltraps>

80107b1d <vector198>:
.globl vector198
vector198:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $198
80107b1f:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107b24:	e9 d5 f1 ff ff       	jmp    80106cfe <alltraps>

80107b29 <vector199>:
.globl vector199
vector199:
  pushl $0
80107b29:	6a 00                	push   $0x0
  pushl $199
80107b2b:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107b30:	e9 c9 f1 ff ff       	jmp    80106cfe <alltraps>

80107b35 <vector200>:
.globl vector200
vector200:
  pushl $0
80107b35:	6a 00                	push   $0x0
  pushl $200
80107b37:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107b3c:	e9 bd f1 ff ff       	jmp    80106cfe <alltraps>

80107b41 <vector201>:
.globl vector201
vector201:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $201
80107b43:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107b48:	e9 b1 f1 ff ff       	jmp    80106cfe <alltraps>

80107b4d <vector202>:
.globl vector202
vector202:
  pushl $0
80107b4d:	6a 00                	push   $0x0
  pushl $202
80107b4f:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107b54:	e9 a5 f1 ff ff       	jmp    80106cfe <alltraps>

80107b59 <vector203>:
.globl vector203
vector203:
  pushl $0
80107b59:	6a 00                	push   $0x0
  pushl $203
80107b5b:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107b60:	e9 99 f1 ff ff       	jmp    80106cfe <alltraps>

80107b65 <vector204>:
.globl vector204
vector204:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $204
80107b67:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107b6c:	e9 8d f1 ff ff       	jmp    80106cfe <alltraps>

80107b71 <vector205>:
.globl vector205
vector205:
  pushl $0
80107b71:	6a 00                	push   $0x0
  pushl $205
80107b73:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107b78:	e9 81 f1 ff ff       	jmp    80106cfe <alltraps>

80107b7d <vector206>:
.globl vector206
vector206:
  pushl $0
80107b7d:	6a 00                	push   $0x0
  pushl $206
80107b7f:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107b84:	e9 75 f1 ff ff       	jmp    80106cfe <alltraps>

80107b89 <vector207>:
.globl vector207
vector207:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $207
80107b8b:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107b90:	e9 69 f1 ff ff       	jmp    80106cfe <alltraps>

80107b95 <vector208>:
.globl vector208
vector208:
  pushl $0
80107b95:	6a 00                	push   $0x0
  pushl $208
80107b97:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b9c:	e9 5d f1 ff ff       	jmp    80106cfe <alltraps>

80107ba1 <vector209>:
.globl vector209
vector209:
  pushl $0
80107ba1:	6a 00                	push   $0x0
  pushl $209
80107ba3:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107ba8:	e9 51 f1 ff ff       	jmp    80106cfe <alltraps>

80107bad <vector210>:
.globl vector210
vector210:
  pushl $0
80107bad:	6a 00                	push   $0x0
  pushl $210
80107baf:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107bb4:	e9 45 f1 ff ff       	jmp    80106cfe <alltraps>

80107bb9 <vector211>:
.globl vector211
vector211:
  pushl $0
80107bb9:	6a 00                	push   $0x0
  pushl $211
80107bbb:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107bc0:	e9 39 f1 ff ff       	jmp    80106cfe <alltraps>

80107bc5 <vector212>:
.globl vector212
vector212:
  pushl $0
80107bc5:	6a 00                	push   $0x0
  pushl $212
80107bc7:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107bcc:	e9 2d f1 ff ff       	jmp    80106cfe <alltraps>

80107bd1 <vector213>:
.globl vector213
vector213:
  pushl $0
80107bd1:	6a 00                	push   $0x0
  pushl $213
80107bd3:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107bd8:	e9 21 f1 ff ff       	jmp    80106cfe <alltraps>

80107bdd <vector214>:
.globl vector214
vector214:
  pushl $0
80107bdd:	6a 00                	push   $0x0
  pushl $214
80107bdf:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107be4:	e9 15 f1 ff ff       	jmp    80106cfe <alltraps>

80107be9 <vector215>:
.globl vector215
vector215:
  pushl $0
80107be9:	6a 00                	push   $0x0
  pushl $215
80107beb:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107bf0:	e9 09 f1 ff ff       	jmp    80106cfe <alltraps>

80107bf5 <vector216>:
.globl vector216
vector216:
  pushl $0
80107bf5:	6a 00                	push   $0x0
  pushl $216
80107bf7:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107bfc:	e9 fd f0 ff ff       	jmp    80106cfe <alltraps>

80107c01 <vector217>:
.globl vector217
vector217:
  pushl $0
80107c01:	6a 00                	push   $0x0
  pushl $217
80107c03:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c08:	e9 f1 f0 ff ff       	jmp    80106cfe <alltraps>

80107c0d <vector218>:
.globl vector218
vector218:
  pushl $0
80107c0d:	6a 00                	push   $0x0
  pushl $218
80107c0f:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107c14:	e9 e5 f0 ff ff       	jmp    80106cfe <alltraps>

80107c19 <vector219>:
.globl vector219
vector219:
  pushl $0
80107c19:	6a 00                	push   $0x0
  pushl $219
80107c1b:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107c20:	e9 d9 f0 ff ff       	jmp    80106cfe <alltraps>

80107c25 <vector220>:
.globl vector220
vector220:
  pushl $0
80107c25:	6a 00                	push   $0x0
  pushl $220
80107c27:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107c2c:	e9 cd f0 ff ff       	jmp    80106cfe <alltraps>

80107c31 <vector221>:
.globl vector221
vector221:
  pushl $0
80107c31:	6a 00                	push   $0x0
  pushl $221
80107c33:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107c38:	e9 c1 f0 ff ff       	jmp    80106cfe <alltraps>

80107c3d <vector222>:
.globl vector222
vector222:
  pushl $0
80107c3d:	6a 00                	push   $0x0
  pushl $222
80107c3f:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107c44:	e9 b5 f0 ff ff       	jmp    80106cfe <alltraps>

80107c49 <vector223>:
.globl vector223
vector223:
  pushl $0
80107c49:	6a 00                	push   $0x0
  pushl $223
80107c4b:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107c50:	e9 a9 f0 ff ff       	jmp    80106cfe <alltraps>

80107c55 <vector224>:
.globl vector224
vector224:
  pushl $0
80107c55:	6a 00                	push   $0x0
  pushl $224
80107c57:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107c5c:	e9 9d f0 ff ff       	jmp    80106cfe <alltraps>

80107c61 <vector225>:
.globl vector225
vector225:
  pushl $0
80107c61:	6a 00                	push   $0x0
  pushl $225
80107c63:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107c68:	e9 91 f0 ff ff       	jmp    80106cfe <alltraps>

80107c6d <vector226>:
.globl vector226
vector226:
  pushl $0
80107c6d:	6a 00                	push   $0x0
  pushl $226
80107c6f:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107c74:	e9 85 f0 ff ff       	jmp    80106cfe <alltraps>

80107c79 <vector227>:
.globl vector227
vector227:
  pushl $0
80107c79:	6a 00                	push   $0x0
  pushl $227
80107c7b:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107c80:	e9 79 f0 ff ff       	jmp    80106cfe <alltraps>

80107c85 <vector228>:
.globl vector228
vector228:
  pushl $0
80107c85:	6a 00                	push   $0x0
  pushl $228
80107c87:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107c8c:	e9 6d f0 ff ff       	jmp    80106cfe <alltraps>

80107c91 <vector229>:
.globl vector229
vector229:
  pushl $0
80107c91:	6a 00                	push   $0x0
  pushl $229
80107c93:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107c98:	e9 61 f0 ff ff       	jmp    80106cfe <alltraps>

80107c9d <vector230>:
.globl vector230
vector230:
  pushl $0
80107c9d:	6a 00                	push   $0x0
  pushl $230
80107c9f:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ca4:	e9 55 f0 ff ff       	jmp    80106cfe <alltraps>

80107ca9 <vector231>:
.globl vector231
vector231:
  pushl $0
80107ca9:	6a 00                	push   $0x0
  pushl $231
80107cab:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107cb0:	e9 49 f0 ff ff       	jmp    80106cfe <alltraps>

80107cb5 <vector232>:
.globl vector232
vector232:
  pushl $0
80107cb5:	6a 00                	push   $0x0
  pushl $232
80107cb7:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107cbc:	e9 3d f0 ff ff       	jmp    80106cfe <alltraps>

80107cc1 <vector233>:
.globl vector233
vector233:
  pushl $0
80107cc1:	6a 00                	push   $0x0
  pushl $233
80107cc3:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107cc8:	e9 31 f0 ff ff       	jmp    80106cfe <alltraps>

80107ccd <vector234>:
.globl vector234
vector234:
  pushl $0
80107ccd:	6a 00                	push   $0x0
  pushl $234
80107ccf:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107cd4:	e9 25 f0 ff ff       	jmp    80106cfe <alltraps>

80107cd9 <vector235>:
.globl vector235
vector235:
  pushl $0
80107cd9:	6a 00                	push   $0x0
  pushl $235
80107cdb:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107ce0:	e9 19 f0 ff ff       	jmp    80106cfe <alltraps>

80107ce5 <vector236>:
.globl vector236
vector236:
  pushl $0
80107ce5:	6a 00                	push   $0x0
  pushl $236
80107ce7:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107cec:	e9 0d f0 ff ff       	jmp    80106cfe <alltraps>

80107cf1 <vector237>:
.globl vector237
vector237:
  pushl $0
80107cf1:	6a 00                	push   $0x0
  pushl $237
80107cf3:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107cf8:	e9 01 f0 ff ff       	jmp    80106cfe <alltraps>

80107cfd <vector238>:
.globl vector238
vector238:
  pushl $0
80107cfd:	6a 00                	push   $0x0
  pushl $238
80107cff:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d04:	e9 f5 ef ff ff       	jmp    80106cfe <alltraps>

80107d09 <vector239>:
.globl vector239
vector239:
  pushl $0
80107d09:	6a 00                	push   $0x0
  pushl $239
80107d0b:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107d10:	e9 e9 ef ff ff       	jmp    80106cfe <alltraps>

80107d15 <vector240>:
.globl vector240
vector240:
  pushl $0
80107d15:	6a 00                	push   $0x0
  pushl $240
80107d17:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107d1c:	e9 dd ef ff ff       	jmp    80106cfe <alltraps>

80107d21 <vector241>:
.globl vector241
vector241:
  pushl $0
80107d21:	6a 00                	push   $0x0
  pushl $241
80107d23:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107d28:	e9 d1 ef ff ff       	jmp    80106cfe <alltraps>

80107d2d <vector242>:
.globl vector242
vector242:
  pushl $0
80107d2d:	6a 00                	push   $0x0
  pushl $242
80107d2f:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107d34:	e9 c5 ef ff ff       	jmp    80106cfe <alltraps>

80107d39 <vector243>:
.globl vector243
vector243:
  pushl $0
80107d39:	6a 00                	push   $0x0
  pushl $243
80107d3b:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107d40:	e9 b9 ef ff ff       	jmp    80106cfe <alltraps>

80107d45 <vector244>:
.globl vector244
vector244:
  pushl $0
80107d45:	6a 00                	push   $0x0
  pushl $244
80107d47:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107d4c:	e9 ad ef ff ff       	jmp    80106cfe <alltraps>

80107d51 <vector245>:
.globl vector245
vector245:
  pushl $0
80107d51:	6a 00                	push   $0x0
  pushl $245
80107d53:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107d58:	e9 a1 ef ff ff       	jmp    80106cfe <alltraps>

80107d5d <vector246>:
.globl vector246
vector246:
  pushl $0
80107d5d:	6a 00                	push   $0x0
  pushl $246
80107d5f:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107d64:	e9 95 ef ff ff       	jmp    80106cfe <alltraps>

80107d69 <vector247>:
.globl vector247
vector247:
  pushl $0
80107d69:	6a 00                	push   $0x0
  pushl $247
80107d6b:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107d70:	e9 89 ef ff ff       	jmp    80106cfe <alltraps>

80107d75 <vector248>:
.globl vector248
vector248:
  pushl $0
80107d75:	6a 00                	push   $0x0
  pushl $248
80107d77:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107d7c:	e9 7d ef ff ff       	jmp    80106cfe <alltraps>

80107d81 <vector249>:
.globl vector249
vector249:
  pushl $0
80107d81:	6a 00                	push   $0x0
  pushl $249
80107d83:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107d88:	e9 71 ef ff ff       	jmp    80106cfe <alltraps>

80107d8d <vector250>:
.globl vector250
vector250:
  pushl $0
80107d8d:	6a 00                	push   $0x0
  pushl $250
80107d8f:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107d94:	e9 65 ef ff ff       	jmp    80106cfe <alltraps>

80107d99 <vector251>:
.globl vector251
vector251:
  pushl $0
80107d99:	6a 00                	push   $0x0
  pushl $251
80107d9b:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107da0:	e9 59 ef ff ff       	jmp    80106cfe <alltraps>

80107da5 <vector252>:
.globl vector252
vector252:
  pushl $0
80107da5:	6a 00                	push   $0x0
  pushl $252
80107da7:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107dac:	e9 4d ef ff ff       	jmp    80106cfe <alltraps>

80107db1 <vector253>:
.globl vector253
vector253:
  pushl $0
80107db1:	6a 00                	push   $0x0
  pushl $253
80107db3:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107db8:	e9 41 ef ff ff       	jmp    80106cfe <alltraps>

80107dbd <vector254>:
.globl vector254
vector254:
  pushl $0
80107dbd:	6a 00                	push   $0x0
  pushl $254
80107dbf:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107dc4:	e9 35 ef ff ff       	jmp    80106cfe <alltraps>

80107dc9 <vector255>:
.globl vector255
vector255:
  pushl $0
80107dc9:	6a 00                	push   $0x0
  pushl $255
80107dcb:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107dd0:	e9 29 ef ff ff       	jmp    80106cfe <alltraps>

80107dd5 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107dd5:	55                   	push   %ebp
80107dd6:	89 e5                	mov    %esp,%ebp
80107dd8:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dde:	83 e8 01             	sub    $0x1,%eax
80107de1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107de5:	8b 45 08             	mov    0x8(%ebp),%eax
80107de8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107dec:	8b 45 08             	mov    0x8(%ebp),%eax
80107def:	c1 e8 10             	shr    $0x10,%eax
80107df2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107df6:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107df9:	0f 01 10             	lgdtl  (%eax)
}
80107dfc:	c9                   	leave  
80107dfd:	c3                   	ret    

80107dfe <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107dfe:	55                   	push   %ebp
80107dff:	89 e5                	mov    %esp,%ebp
80107e01:	83 ec 04             	sub    $0x4,%esp
80107e04:	8b 45 08             	mov    0x8(%ebp),%eax
80107e07:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107e0b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e0f:	0f 00 d8             	ltr    %ax
}
80107e12:	c9                   	leave  
80107e13:	c3                   	ret    

80107e14 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	83 ec 04             	sub    $0x4,%esp
80107e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107e21:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e25:	8e e8                	mov    %eax,%gs
}
80107e27:	c9                   	leave  
80107e28:	c3                   	ret    

80107e29 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107e29:	55                   	push   %ebp
80107e2a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e2f:	0f 22 d8             	mov    %eax,%cr3
}
80107e32:	5d                   	pop    %ebp
80107e33:	c3                   	ret    

80107e34 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107e34:	55                   	push   %ebp
80107e35:	89 e5                	mov    %esp,%ebp
80107e37:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3a:	05 00 00 00 80       	add    $0x80000000,%eax
80107e3f:	5d                   	pop    %ebp
80107e40:	c3                   	ret    

80107e41 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107e41:	55                   	push   %ebp
80107e42:	89 e5                	mov    %esp,%ebp
80107e44:	8b 45 08             	mov    0x8(%ebp),%eax
80107e47:	05 00 00 00 80       	add    $0x80000000,%eax
80107e4c:	5d                   	pop    %ebp
80107e4d:	c3                   	ret    

80107e4e <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107e4e:	55                   	push   %ebp
80107e4f:	89 e5                	mov    %esp,%ebp
80107e51:	53                   	push   %ebx
80107e52:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107e55:	e8 98 b0 ff ff       	call   80102ef2 <cpunum>
80107e5a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107e60:	05 40 34 11 80       	add    $0x80113440,%eax
80107e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e74:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e84:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e88:	83 e2 f0             	and    $0xfffffff0,%edx
80107e8b:	83 ca 0a             	or     $0xa,%edx
80107e8e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e94:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107e98:	83 ca 10             	or     $0x10,%edx
80107e9b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ea5:	83 e2 9f             	and    $0xffffff9f,%edx
80107ea8:	88 50 7d             	mov    %dl,0x7d(%eax)
80107eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eae:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107eb2:	83 ca 80             	or     $0xffffff80,%edx
80107eb5:	88 50 7d             	mov    %dl,0x7d(%eax)
80107eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ebf:	83 ca 0f             	or     $0xf,%edx
80107ec2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ecc:	83 e2 ef             	and    $0xffffffef,%edx
80107ecf:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ed9:	83 e2 df             	and    $0xffffffdf,%edx
80107edc:	88 50 7e             	mov    %dl,0x7e(%eax)
80107edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ee6:	83 ca 40             	or     $0x40,%edx
80107ee9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eef:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ef3:	83 ca 80             	or     $0xffffff80,%edx
80107ef6:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f03:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f0a:	ff ff 
80107f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107f16:	00 00 
80107f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f25:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f2c:	83 e2 f0             	and    $0xfffffff0,%edx
80107f2f:	83 ca 02             	or     $0x2,%edx
80107f32:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f42:	83 ca 10             	or     $0x10,%edx
80107f45:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f55:	83 e2 9f             	and    $0xffffff9f,%edx
80107f58:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f61:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f68:	83 ca 80             	or     $0xffffff80,%edx
80107f6b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f74:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f7b:	83 ca 0f             	or     $0xf,%edx
80107f7e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f87:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107f8e:	83 e2 ef             	and    $0xffffffef,%edx
80107f91:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fa1:	83 e2 df             	and    $0xffffffdf,%edx
80107fa4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fad:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fb4:	83 ca 40             	or     $0x40,%edx
80107fb7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fc7:	83 ca 80             	or     $0xffffff80,%edx
80107fca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107fe4:	ff ff 
80107fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe9:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107ff0:	00 00 
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fff:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108006:	83 e2 f0             	and    $0xfffffff0,%edx
80108009:	83 ca 0a             	or     $0xa,%edx
8010800c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010801c:	83 ca 10             	or     $0x10,%edx
8010801f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108028:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010802f:	83 ca 60             	or     $0x60,%edx
80108032:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108042:	83 ca 80             	or     $0xffffff80,%edx
80108045:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108055:	83 ca 0f             	or     $0xf,%edx
80108058:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010805e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108061:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108068:	83 e2 ef             	and    $0xffffffef,%edx
8010806b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108074:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010807b:	83 e2 df             	and    $0xffffffdf,%edx
8010807e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108087:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010808e:	83 ca 40             	or     $0x40,%edx
80108091:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080a1:	83 ca 80             	or     $0xffffff80,%edx
801080a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ad:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b7:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801080be:	ff ff 
801080c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c3:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801080ca:	00 00 
801080cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cf:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801080d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801080e0:	83 e2 f0             	and    $0xfffffff0,%edx
801080e3:	83 ca 02             	or     $0x2,%edx
801080e6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801080ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ef:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801080f6:	83 ca 10             	or     $0x10,%edx
801080f9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801080ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108102:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108109:	83 ca 60             	or     $0x60,%edx
8010810c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010811c:	83 ca 80             	or     $0xffffff80,%edx
8010811f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108128:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010812f:	83 ca 0f             	or     $0xf,%edx
80108132:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108142:	83 e2 ef             	and    $0xffffffef,%edx
80108145:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010814b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108155:	83 e2 df             	and    $0xffffffdf,%edx
80108158:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010815e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108161:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108168:	83 ca 40             	or     $0x40,%edx
8010816b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108174:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010817b:	83 ca 80             	or     $0xffffff80,%edx
8010817e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108187:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010818e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108191:	05 b4 00 00 00       	add    $0xb4,%eax
80108196:	89 c3                	mov    %eax,%ebx
80108198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819b:	05 b4 00 00 00       	add    $0xb4,%eax
801081a0:	c1 e8 10             	shr    $0x10,%eax
801081a3:	89 c2                	mov    %eax,%edx
801081a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a8:	05 b4 00 00 00       	add    $0xb4,%eax
801081ad:	c1 e8 18             	shr    $0x18,%eax
801081b0:	89 c1                	mov    %eax,%ecx
801081b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b5:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801081bc:	00 00 
801081be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c1:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801081d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801081db:	83 e2 f0             	and    $0xfffffff0,%edx
801081de:	83 ca 02             	or     $0x2,%edx
801081e1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ea:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801081f1:	83 ca 10             	or     $0x10,%edx
801081f4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801081fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108204:	83 e2 9f             	and    $0xffffff9f,%edx
80108207:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010820d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108210:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108217:	83 ca 80             	or     $0xffffff80,%edx
8010821a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108223:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010822a:	83 e2 f0             	and    $0xfffffff0,%edx
8010822d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108236:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010823d:	83 e2 ef             	and    $0xffffffef,%edx
80108240:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108249:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108250:	83 e2 df             	and    $0xffffffdf,%edx
80108253:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108263:	83 ca 40             	or     $0x40,%edx
80108266:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010826c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108276:	83 ca 80             	or     $0xffffff80,%edx
80108279:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010827f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108282:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828b:	83 c0 70             	add    $0x70,%eax
8010828e:	83 ec 08             	sub    $0x8,%esp
80108291:	6a 38                	push   $0x38
80108293:	50                   	push   %eax
80108294:	e8 3c fb ff ff       	call   80107dd5 <lgdt>
80108299:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010829c:	83 ec 0c             	sub    $0xc,%esp
8010829f:	6a 18                	push   $0x18
801082a1:	e8 6e fb ff ff       	call   80107e14 <loadgs>
801082a6:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801082a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ac:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801082b2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801082b9:	00 00 00 00 
}
801082bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082c0:	c9                   	leave  
801082c1:	c3                   	ret    

801082c2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801082c2:	55                   	push   %ebp
801082c3:	89 e5                	mov    %esp,%ebp
801082c5:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801082c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801082cb:	c1 e8 16             	shr    $0x16,%eax
801082ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082d5:	8b 45 08             	mov    0x8(%ebp),%eax
801082d8:	01 d0                	add    %edx,%eax
801082da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801082dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082e0:	8b 00                	mov    (%eax),%eax
801082e2:	83 e0 01             	and    $0x1,%eax
801082e5:	85 c0                	test   %eax,%eax
801082e7:	74 18                	je     80108301 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801082e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ec:	8b 00                	mov    (%eax),%eax
801082ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f3:	50                   	push   %eax
801082f4:	e8 48 fb ff ff       	call   80107e41 <p2v>
801082f9:	83 c4 04             	add    $0x4,%esp
801082fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801082ff:	eb 48                	jmp    80108349 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108301:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108305:	74 0e                	je     80108315 <walkpgdir+0x53>
80108307:	e8 85 a8 ff ff       	call   80102b91 <kalloc>
8010830c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010830f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108313:	75 07                	jne    8010831c <walkpgdir+0x5a>
      return 0;
80108315:	b8 00 00 00 00       	mov    $0x0,%eax
8010831a:	eb 44                	jmp    80108360 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010831c:	83 ec 04             	sub    $0x4,%esp
8010831f:	68 00 10 00 00       	push   $0x1000
80108324:	6a 00                	push   $0x0
80108326:	ff 75 f4             	pushl  -0xc(%ebp)
80108329:	e8 02 d3 ff ff       	call   80105630 <memset>
8010832e:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108331:	83 ec 0c             	sub    $0xc,%esp
80108334:	ff 75 f4             	pushl  -0xc(%ebp)
80108337:	e8 f8 fa ff ff       	call   80107e34 <v2p>
8010833c:	83 c4 10             	add    $0x10,%esp
8010833f:	83 c8 07             	or     $0x7,%eax
80108342:	89 c2                	mov    %eax,%edx
80108344:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108347:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010834c:	c1 e8 0c             	shr    $0xc,%eax
8010834f:	25 ff 03 00 00       	and    $0x3ff,%eax
80108354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835e:	01 d0                	add    %edx,%eax
}
80108360:	c9                   	leave  
80108361:	c3                   	ret    

80108362 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108362:	55                   	push   %ebp
80108363:	89 e5                	mov    %esp,%ebp
80108365:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108368:	8b 45 0c             	mov    0xc(%ebp),%eax
8010836b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108373:	8b 55 0c             	mov    0xc(%ebp),%edx
80108376:	8b 45 10             	mov    0x10(%ebp),%eax
80108379:	01 d0                	add    %edx,%eax
8010837b:	83 e8 01             	sub    $0x1,%eax
8010837e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108383:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108386:	83 ec 04             	sub    $0x4,%esp
80108389:	6a 01                	push   $0x1
8010838b:	ff 75 f4             	pushl  -0xc(%ebp)
8010838e:	ff 75 08             	pushl  0x8(%ebp)
80108391:	e8 2c ff ff ff       	call   801082c2 <walkpgdir>
80108396:	83 c4 10             	add    $0x10,%esp
80108399:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010839c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083a0:	75 07                	jne    801083a9 <mappages+0x47>
      return -1;
801083a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083a7:	eb 49                	jmp    801083f2 <mappages+0x90>
    if(*pte & PTE_P)
801083a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083ac:	8b 00                	mov    (%eax),%eax
801083ae:	83 e0 01             	and    $0x1,%eax
801083b1:	85 c0                	test   %eax,%eax
801083b3:	74 0d                	je     801083c2 <mappages+0x60>
      panic("remap");
801083b5:	83 ec 0c             	sub    $0xc,%esp
801083b8:	68 a8 91 10 80       	push   $0x801091a8
801083bd:	e8 9a 81 ff ff       	call   8010055c <panic>
    *pte = pa | perm | PTE_P;
801083c2:	8b 45 18             	mov    0x18(%ebp),%eax
801083c5:	0b 45 14             	or     0x14(%ebp),%eax
801083c8:	83 c8 01             	or     $0x1,%eax
801083cb:	89 c2                	mov    %eax,%edx
801083cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083d0:	89 10                	mov    %edx,(%eax)
    if(a == last)
801083d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801083d8:	75 08                	jne    801083e2 <mappages+0x80>
      break;
801083da:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801083db:	b8 00 00 00 00       	mov    $0x0,%eax
801083e0:	eb 10                	jmp    801083f2 <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801083e2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801083e9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801083f0:	eb 94                	jmp    80108386 <mappages+0x24>
  return 0;
}
801083f2:	c9                   	leave  
801083f3:	c3                   	ret    

801083f4 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801083f4:	55                   	push   %ebp
801083f5:	89 e5                	mov    %esp,%ebp
801083f7:	53                   	push   %ebx
801083f8:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801083fb:	e8 91 a7 ff ff       	call   80102b91 <kalloc>
80108400:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108403:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108407:	75 0a                	jne    80108413 <setupkvm+0x1f>
    return 0;
80108409:	b8 00 00 00 00       	mov    $0x0,%eax
8010840e:	e9 8e 00 00 00       	jmp    801084a1 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108413:	83 ec 04             	sub    $0x4,%esp
80108416:	68 00 10 00 00       	push   $0x1000
8010841b:	6a 00                	push   $0x0
8010841d:	ff 75 f0             	pushl  -0x10(%ebp)
80108420:	e8 0b d2 ff ff       	call   80105630 <memset>
80108425:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108428:	83 ec 0c             	sub    $0xc,%esp
8010842b:	68 00 00 00 0e       	push   $0xe000000
80108430:	e8 0c fa ff ff       	call   80107e41 <p2v>
80108435:	83 c4 10             	add    $0x10,%esp
80108438:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010843d:	76 0d                	jbe    8010844c <setupkvm+0x58>
    panic("PHYSTOP too high");
8010843f:	83 ec 0c             	sub    $0xc,%esp
80108442:	68 ae 91 10 80       	push   $0x801091ae
80108447:	e8 10 81 ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010844c:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108453:	eb 40                	jmp    80108495 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108458:	8b 48 0c             	mov    0xc(%eax),%ecx
8010845b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845e:	8b 50 04             	mov    0x4(%eax),%edx
80108461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108464:	8b 58 08             	mov    0x8(%eax),%ebx
80108467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010846a:	8b 40 04             	mov    0x4(%eax),%eax
8010846d:	29 c3                	sub    %eax,%ebx
8010846f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108472:	8b 00                	mov    (%eax),%eax
80108474:	83 ec 0c             	sub    $0xc,%esp
80108477:	51                   	push   %ecx
80108478:	52                   	push   %edx
80108479:	53                   	push   %ebx
8010847a:	50                   	push   %eax
8010847b:	ff 75 f0             	pushl  -0x10(%ebp)
8010847e:	e8 df fe ff ff       	call   80108362 <mappages>
80108483:	83 c4 20             	add    $0x20,%esp
80108486:	85 c0                	test   %eax,%eax
80108488:	79 07                	jns    80108491 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010848a:	b8 00 00 00 00       	mov    $0x0,%eax
8010848f:	eb 10                	jmp    801084a1 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108491:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108495:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010849c:	72 b7                	jb     80108455 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010849e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801084a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084a4:	c9                   	leave  
801084a5:	c3                   	ret    

801084a6 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801084a6:	55                   	push   %ebp
801084a7:	89 e5                	mov    %esp,%ebp
801084a9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801084ac:	e8 43 ff ff ff       	call   801083f4 <setupkvm>
801084b1:	a3 58 6c 11 80       	mov    %eax,0x80116c58
  switchkvm();
801084b6:	e8 02 00 00 00       	call   801084bd <switchkvm>
}
801084bb:	c9                   	leave  
801084bc:	c3                   	ret    

801084bd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801084bd:	55                   	push   %ebp
801084be:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801084c0:	a1 58 6c 11 80       	mov    0x80116c58,%eax
801084c5:	50                   	push   %eax
801084c6:	e8 69 f9 ff ff       	call   80107e34 <v2p>
801084cb:	83 c4 04             	add    $0x4,%esp
801084ce:	50                   	push   %eax
801084cf:	e8 55 f9 ff ff       	call   80107e29 <lcr3>
801084d4:	83 c4 04             	add    $0x4,%esp
}
801084d7:	c9                   	leave  
801084d8:	c3                   	ret    

801084d9 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801084d9:	55                   	push   %ebp
801084da:	89 e5                	mov    %esp,%ebp
801084dc:	56                   	push   %esi
801084dd:	53                   	push   %ebx
  pushcli();
801084de:	e8 4b d0 ff ff       	call   8010552e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801084e3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084e9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801084f0:	83 c2 08             	add    $0x8,%edx
801084f3:	89 d6                	mov    %edx,%esi
801084f5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801084fc:	83 c2 08             	add    $0x8,%edx
801084ff:	c1 ea 10             	shr    $0x10,%edx
80108502:	89 d3                	mov    %edx,%ebx
80108504:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010850b:	83 c2 08             	add    $0x8,%edx
8010850e:	c1 ea 18             	shr    $0x18,%edx
80108511:	89 d1                	mov    %edx,%ecx
80108513:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010851a:	67 00 
8010851c:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108523:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108529:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108530:	83 e2 f0             	and    $0xfffffff0,%edx
80108533:	83 ca 09             	or     $0x9,%edx
80108536:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010853c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108543:	83 ca 10             	or     $0x10,%edx
80108546:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010854c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108553:	83 e2 9f             	and    $0xffffff9f,%edx
80108556:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010855c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108563:	83 ca 80             	or     $0xffffff80,%edx
80108566:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010856c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108573:	83 e2 f0             	and    $0xfffffff0,%edx
80108576:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010857c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108583:	83 e2 ef             	and    $0xffffffef,%edx
80108586:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010858c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108593:	83 e2 df             	and    $0xffffffdf,%edx
80108596:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010859c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085a3:	83 ca 40             	or     $0x40,%edx
801085a6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085ac:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085b3:	83 e2 7f             	and    $0x7f,%edx
801085b6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085bc:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801085c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085c8:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801085cf:	83 e2 ef             	and    $0xffffffef,%edx
801085d2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801085d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085de:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801085e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085ea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801085f1:	8b 52 08             	mov    0x8(%edx),%edx
801085f4:	81 c2 00 10 00 00    	add    $0x1000,%edx
801085fa:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801085fd:	83 ec 0c             	sub    $0xc,%esp
80108600:	6a 30                	push   $0x30
80108602:	e8 f7 f7 ff ff       	call   80107dfe <ltr>
80108607:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010860a:	8b 45 08             	mov    0x8(%ebp),%eax
8010860d:	8b 40 04             	mov    0x4(%eax),%eax
80108610:	85 c0                	test   %eax,%eax
80108612:	75 0d                	jne    80108621 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108614:	83 ec 0c             	sub    $0xc,%esp
80108617:	68 bf 91 10 80       	push   $0x801091bf
8010861c:	e8 3b 7f ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108621:	8b 45 08             	mov    0x8(%ebp),%eax
80108624:	8b 40 04             	mov    0x4(%eax),%eax
80108627:	83 ec 0c             	sub    $0xc,%esp
8010862a:	50                   	push   %eax
8010862b:	e8 04 f8 ff ff       	call   80107e34 <v2p>
80108630:	83 c4 10             	add    $0x10,%esp
80108633:	83 ec 0c             	sub    $0xc,%esp
80108636:	50                   	push   %eax
80108637:	e8 ed f7 ff ff       	call   80107e29 <lcr3>
8010863c:	83 c4 10             	add    $0x10,%esp
  popcli();
8010863f:	e8 2e cf ff ff       	call   80105572 <popcli>
}
80108644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108647:	5b                   	pop    %ebx
80108648:	5e                   	pop    %esi
80108649:	5d                   	pop    %ebp
8010864a:	c3                   	ret    

8010864b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010864b:	55                   	push   %ebp
8010864c:	89 e5                	mov    %esp,%ebp
8010864e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108651:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108658:	76 0d                	jbe    80108667 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010865a:	83 ec 0c             	sub    $0xc,%esp
8010865d:	68 d3 91 10 80       	push   $0x801091d3
80108662:	e8 f5 7e ff ff       	call   8010055c <panic>
  mem = kalloc();
80108667:	e8 25 a5 ff ff       	call   80102b91 <kalloc>
8010866c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010866f:	83 ec 04             	sub    $0x4,%esp
80108672:	68 00 10 00 00       	push   $0x1000
80108677:	6a 00                	push   $0x0
80108679:	ff 75 f4             	pushl  -0xc(%ebp)
8010867c:	e8 af cf ff ff       	call   80105630 <memset>
80108681:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108684:	83 ec 0c             	sub    $0xc,%esp
80108687:	ff 75 f4             	pushl  -0xc(%ebp)
8010868a:	e8 a5 f7 ff ff       	call   80107e34 <v2p>
8010868f:	83 c4 10             	add    $0x10,%esp
80108692:	83 ec 0c             	sub    $0xc,%esp
80108695:	6a 06                	push   $0x6
80108697:	50                   	push   %eax
80108698:	68 00 10 00 00       	push   $0x1000
8010869d:	6a 00                	push   $0x0
8010869f:	ff 75 08             	pushl  0x8(%ebp)
801086a2:	e8 bb fc ff ff       	call   80108362 <mappages>
801086a7:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801086aa:	83 ec 04             	sub    $0x4,%esp
801086ad:	ff 75 10             	pushl  0x10(%ebp)
801086b0:	ff 75 0c             	pushl  0xc(%ebp)
801086b3:	ff 75 f4             	pushl  -0xc(%ebp)
801086b6:	e8 34 d0 ff ff       	call   801056ef <memmove>
801086bb:	83 c4 10             	add    $0x10,%esp
}
801086be:	c9                   	leave  
801086bf:	c3                   	ret    

801086c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	53                   	push   %ebx
801086c4:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801086c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801086ca:	25 ff 0f 00 00       	and    $0xfff,%eax
801086cf:	85 c0                	test   %eax,%eax
801086d1:	74 0d                	je     801086e0 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801086d3:	83 ec 0c             	sub    $0xc,%esp
801086d6:	68 f0 91 10 80       	push   $0x801091f0
801086db:	e8 7c 7e ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
801086e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086e7:	e9 95 00 00 00       	jmp    80108781 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801086ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801086ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f2:	01 d0                	add    %edx,%eax
801086f4:	83 ec 04             	sub    $0x4,%esp
801086f7:	6a 00                	push   $0x0
801086f9:	50                   	push   %eax
801086fa:	ff 75 08             	pushl  0x8(%ebp)
801086fd:	e8 c0 fb ff ff       	call   801082c2 <walkpgdir>
80108702:	83 c4 10             	add    $0x10,%esp
80108705:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108708:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010870c:	75 0d                	jne    8010871b <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010870e:	83 ec 0c             	sub    $0xc,%esp
80108711:	68 13 92 10 80       	push   $0x80109213
80108716:	e8 41 7e ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
8010871b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010871e:	8b 00                	mov    (%eax),%eax
80108720:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108725:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108728:	8b 45 18             	mov    0x18(%ebp),%eax
8010872b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010872e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108733:	77 0b                	ja     80108740 <loaduvm+0x80>
      n = sz - i;
80108735:	8b 45 18             	mov    0x18(%ebp),%eax
80108738:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010873b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010873e:	eb 07                	jmp    80108747 <loaduvm+0x87>
    else
      n = PGSIZE;
80108740:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108747:	8b 55 14             	mov    0x14(%ebp),%edx
8010874a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108750:	83 ec 0c             	sub    $0xc,%esp
80108753:	ff 75 e8             	pushl  -0x18(%ebp)
80108756:	e8 e6 f6 ff ff       	call   80107e41 <p2v>
8010875b:	83 c4 10             	add    $0x10,%esp
8010875e:	ff 75 f0             	pushl  -0x10(%ebp)
80108761:	53                   	push   %ebx
80108762:	50                   	push   %eax
80108763:	ff 75 10             	pushl  0x10(%ebp)
80108766:	e8 d1 96 ff ff       	call   80101e3c <readi>
8010876b:	83 c4 10             	add    $0x10,%esp
8010876e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108771:	74 07                	je     8010877a <loaduvm+0xba>
      return -1;
80108773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108778:	eb 18                	jmp    80108792 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010877a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108784:	3b 45 18             	cmp    0x18(%ebp),%eax
80108787:	0f 82 5f ff ff ff    	jb     801086ec <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010878d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108795:	c9                   	leave  
80108796:	c3                   	ret    

80108797 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108797:	55                   	push   %ebp
80108798:	89 e5                	mov    %esp,%ebp
8010879a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010879d:	8b 45 10             	mov    0x10(%ebp),%eax
801087a0:	85 c0                	test   %eax,%eax
801087a2:	79 0a                	jns    801087ae <allocuvm+0x17>
    return 0;
801087a4:	b8 00 00 00 00       	mov    $0x0,%eax
801087a9:	e9 b0 00 00 00       	jmp    8010885e <allocuvm+0xc7>
  if(newsz < oldsz)
801087ae:	8b 45 10             	mov    0x10(%ebp),%eax
801087b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087b4:	73 08                	jae    801087be <allocuvm+0x27>
    return oldsz;
801087b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801087b9:	e9 a0 00 00 00       	jmp    8010885e <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801087be:	8b 45 0c             	mov    0xc(%ebp),%eax
801087c1:	05 ff 0f 00 00       	add    $0xfff,%eax
801087c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801087ce:	eb 7f                	jmp    8010884f <allocuvm+0xb8>
    mem = kalloc();
801087d0:	e8 bc a3 ff ff       	call   80102b91 <kalloc>
801087d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801087d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087dc:	75 2b                	jne    80108809 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801087de:	83 ec 0c             	sub    $0xc,%esp
801087e1:	68 31 92 10 80       	push   $0x80109231
801087e6:	e8 d4 7b ff ff       	call   801003bf <cprintf>
801087eb:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801087ee:	83 ec 04             	sub    $0x4,%esp
801087f1:	ff 75 0c             	pushl  0xc(%ebp)
801087f4:	ff 75 10             	pushl  0x10(%ebp)
801087f7:	ff 75 08             	pushl  0x8(%ebp)
801087fa:	e8 61 00 00 00       	call   80108860 <deallocuvm>
801087ff:	83 c4 10             	add    $0x10,%esp
      return 0;
80108802:	b8 00 00 00 00       	mov    $0x0,%eax
80108807:	eb 55                	jmp    8010885e <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108809:	83 ec 04             	sub    $0x4,%esp
8010880c:	68 00 10 00 00       	push   $0x1000
80108811:	6a 00                	push   $0x0
80108813:	ff 75 f0             	pushl  -0x10(%ebp)
80108816:	e8 15 ce ff ff       	call   80105630 <memset>
8010881b:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010881e:	83 ec 0c             	sub    $0xc,%esp
80108821:	ff 75 f0             	pushl  -0x10(%ebp)
80108824:	e8 0b f6 ff ff       	call   80107e34 <v2p>
80108829:	83 c4 10             	add    $0x10,%esp
8010882c:	89 c2                	mov    %eax,%edx
8010882e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108831:	83 ec 0c             	sub    $0xc,%esp
80108834:	6a 06                	push   $0x6
80108836:	52                   	push   %edx
80108837:	68 00 10 00 00       	push   $0x1000
8010883c:	50                   	push   %eax
8010883d:	ff 75 08             	pushl  0x8(%ebp)
80108840:	e8 1d fb ff ff       	call   80108362 <mappages>
80108845:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108848:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010884f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108852:	3b 45 10             	cmp    0x10(%ebp),%eax
80108855:	0f 82 75 ff ff ff    	jb     801087d0 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010885b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010885e:	c9                   	leave  
8010885f:	c3                   	ret    

80108860 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108860:	55                   	push   %ebp
80108861:	89 e5                	mov    %esp,%ebp
80108863:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108866:	8b 45 10             	mov    0x10(%ebp),%eax
80108869:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010886c:	72 08                	jb     80108876 <deallocuvm+0x16>
    return oldsz;
8010886e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108871:	e9 a5 00 00 00       	jmp    8010891b <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108876:	8b 45 10             	mov    0x10(%ebp),%eax
80108879:	05 ff 0f 00 00       	add    $0xfff,%eax
8010887e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108886:	e9 81 00 00 00       	jmp    8010890c <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010888b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010888e:	83 ec 04             	sub    $0x4,%esp
80108891:	6a 00                	push   $0x0
80108893:	50                   	push   %eax
80108894:	ff 75 08             	pushl  0x8(%ebp)
80108897:	e8 26 fa ff ff       	call   801082c2 <walkpgdir>
8010889c:	83 c4 10             	add    $0x10,%esp
8010889f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801088a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088a6:	75 09                	jne    801088b1 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801088a8:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801088af:	eb 54                	jmp    80108905 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801088b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088b4:	8b 00                	mov    (%eax),%eax
801088b6:	83 e0 01             	and    $0x1,%eax
801088b9:	85 c0                	test   %eax,%eax
801088bb:	74 48                	je     80108905 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801088bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088c0:	8b 00                	mov    (%eax),%eax
801088c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801088ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088ce:	75 0d                	jne    801088dd <deallocuvm+0x7d>
        panic("kfree");
801088d0:	83 ec 0c             	sub    $0xc,%esp
801088d3:	68 49 92 10 80       	push   $0x80109249
801088d8:	e8 7f 7c ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
801088dd:	83 ec 0c             	sub    $0xc,%esp
801088e0:	ff 75 ec             	pushl  -0x14(%ebp)
801088e3:	e8 59 f5 ff ff       	call   80107e41 <p2v>
801088e8:	83 c4 10             	add    $0x10,%esp
801088eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801088ee:	83 ec 0c             	sub    $0xc,%esp
801088f1:	ff 75 e8             	pushl  -0x18(%ebp)
801088f4:	e8 fc a1 ff ff       	call   80102af5 <kfree>
801088f9:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801088fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108905:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010890c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108912:	0f 82 73 ff ff ff    	jb     8010888b <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108918:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010891b:	c9                   	leave  
8010891c:	c3                   	ret    

8010891d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010891d:	55                   	push   %ebp
8010891e:	89 e5                	mov    %esp,%ebp
80108920:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108923:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108927:	75 0d                	jne    80108936 <freevm+0x19>
    panic("freevm: no pgdir");
80108929:	83 ec 0c             	sub    $0xc,%esp
8010892c:	68 4f 92 10 80       	push   $0x8010924f
80108931:	e8 26 7c ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108936:	83 ec 04             	sub    $0x4,%esp
80108939:	6a 00                	push   $0x0
8010893b:	68 00 00 00 80       	push   $0x80000000
80108940:	ff 75 08             	pushl  0x8(%ebp)
80108943:	e8 18 ff ff ff       	call   80108860 <deallocuvm>
80108948:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010894b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108952:	eb 4f                	jmp    801089a3 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108957:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010895e:	8b 45 08             	mov    0x8(%ebp),%eax
80108961:	01 d0                	add    %edx,%eax
80108963:	8b 00                	mov    (%eax),%eax
80108965:	83 e0 01             	and    $0x1,%eax
80108968:	85 c0                	test   %eax,%eax
8010896a:	74 33                	je     8010899f <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010896c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108976:	8b 45 08             	mov    0x8(%ebp),%eax
80108979:	01 d0                	add    %edx,%eax
8010897b:	8b 00                	mov    (%eax),%eax
8010897d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108982:	83 ec 0c             	sub    $0xc,%esp
80108985:	50                   	push   %eax
80108986:	e8 b6 f4 ff ff       	call   80107e41 <p2v>
8010898b:	83 c4 10             	add    $0x10,%esp
8010898e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108991:	83 ec 0c             	sub    $0xc,%esp
80108994:	ff 75 f0             	pushl  -0x10(%ebp)
80108997:	e8 59 a1 ff ff       	call   80102af5 <kfree>
8010899c:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010899f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089a3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801089aa:	76 a8                	jbe    80108954 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801089ac:	83 ec 0c             	sub    $0xc,%esp
801089af:	ff 75 08             	pushl  0x8(%ebp)
801089b2:	e8 3e a1 ff ff       	call   80102af5 <kfree>
801089b7:	83 c4 10             	add    $0x10,%esp
}
801089ba:	c9                   	leave  
801089bb:	c3                   	ret    

801089bc <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801089bc:	55                   	push   %ebp
801089bd:	89 e5                	mov    %esp,%ebp
801089bf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801089c2:	83 ec 04             	sub    $0x4,%esp
801089c5:	6a 00                	push   $0x0
801089c7:	ff 75 0c             	pushl  0xc(%ebp)
801089ca:	ff 75 08             	pushl  0x8(%ebp)
801089cd:	e8 f0 f8 ff ff       	call   801082c2 <walkpgdir>
801089d2:	83 c4 10             	add    $0x10,%esp
801089d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801089d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801089dc:	75 0d                	jne    801089eb <clearpteu+0x2f>
    panic("clearpteu");
801089de:	83 ec 0c             	sub    $0xc,%esp
801089e1:	68 60 92 10 80       	push   $0x80109260
801089e6:	e8 71 7b ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
801089eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ee:	8b 00                	mov    (%eax),%eax
801089f0:	83 e0 fb             	and    $0xfffffffb,%eax
801089f3:	89 c2                	mov    %eax,%edx
801089f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f8:	89 10                	mov    %edx,(%eax)
}
801089fa:	c9                   	leave  
801089fb:	c3                   	ret    

801089fc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801089fc:	55                   	push   %ebp
801089fd:	89 e5                	mov    %esp,%ebp
801089ff:	53                   	push   %ebx
80108a00:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a03:	e8 ec f9 ff ff       	call   801083f4 <setupkvm>
80108a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a0f:	75 0a                	jne    80108a1b <copyuvm+0x1f>
    return 0;
80108a11:	b8 00 00 00 00       	mov    $0x0,%eax
80108a16:	e9 f8 00 00 00       	jmp    80108b13 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a22:	e9 c8 00 00 00       	jmp    80108aef <copyuvm+0xf3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2a:	83 ec 04             	sub    $0x4,%esp
80108a2d:	6a 00                	push   $0x0
80108a2f:	50                   	push   %eax
80108a30:	ff 75 08             	pushl  0x8(%ebp)
80108a33:	e8 8a f8 ff ff       	call   801082c2 <walkpgdir>
80108a38:	83 c4 10             	add    $0x10,%esp
80108a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a42:	75 0d                	jne    80108a51 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108a44:	83 ec 0c             	sub    $0xc,%esp
80108a47:	68 6a 92 10 80       	push   $0x8010926a
80108a4c:	e8 0b 7b ff ff       	call   8010055c <panic>
    if(!(*pte & PTE_P))
80108a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a54:	8b 00                	mov    (%eax),%eax
80108a56:	83 e0 01             	and    $0x1,%eax
80108a59:	85 c0                	test   %eax,%eax
80108a5b:	75 0d                	jne    80108a6a <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108a5d:	83 ec 0c             	sub    $0xc,%esp
80108a60:	68 84 92 10 80       	push   $0x80109284
80108a65:	e8 f2 7a ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80108a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a6d:	8b 00                	mov    (%eax),%eax
80108a6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a7a:	8b 00                	mov    (%eax),%eax
80108a7c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108a84:	e8 08 a1 ff ff       	call   80102b91 <kalloc>
80108a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108a90:	75 02                	jne    80108a94 <copyuvm+0x98>
      goto bad;
80108a92:	eb 6c                	jmp    80108b00 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108a94:	83 ec 0c             	sub    $0xc,%esp
80108a97:	ff 75 e8             	pushl  -0x18(%ebp)
80108a9a:	e8 a2 f3 ff ff       	call   80107e41 <p2v>
80108a9f:	83 c4 10             	add    $0x10,%esp
80108aa2:	83 ec 04             	sub    $0x4,%esp
80108aa5:	68 00 10 00 00       	push   $0x1000
80108aaa:	50                   	push   %eax
80108aab:	ff 75 e0             	pushl  -0x20(%ebp)
80108aae:	e8 3c cc ff ff       	call   801056ef <memmove>
80108ab3:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108ab6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108ab9:	83 ec 0c             	sub    $0xc,%esp
80108abc:	ff 75 e0             	pushl  -0x20(%ebp)
80108abf:	e8 70 f3 ff ff       	call   80107e34 <v2p>
80108ac4:	83 c4 10             	add    $0x10,%esp
80108ac7:	89 c2                	mov    %eax,%edx
80108ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108acc:	83 ec 0c             	sub    $0xc,%esp
80108acf:	53                   	push   %ebx
80108ad0:	52                   	push   %edx
80108ad1:	68 00 10 00 00       	push   $0x1000
80108ad6:	50                   	push   %eax
80108ad7:	ff 75 f0             	pushl  -0x10(%ebp)
80108ada:	e8 83 f8 ff ff       	call   80108362 <mappages>
80108adf:	83 c4 20             	add    $0x20,%esp
80108ae2:	85 c0                	test   %eax,%eax
80108ae4:	79 02                	jns    80108ae8 <copyuvm+0xec>
      goto bad;
80108ae6:	eb 18                	jmp    80108b00 <copyuvm+0x104>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108ae8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108af5:	0f 82 2c ff ff ff    	jb     80108a27 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108afe:	eb 13                	jmp    80108b13 <copyuvm+0x117>

bad:
  freevm(d);
80108b00:	83 ec 0c             	sub    $0xc,%esp
80108b03:	ff 75 f0             	pushl  -0x10(%ebp)
80108b06:	e8 12 fe ff ff       	call   8010891d <freevm>
80108b0b:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b16:	c9                   	leave  
80108b17:	c3                   	ret    

80108b18 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108b18:	55                   	push   %ebp
80108b19:	89 e5                	mov    %esp,%ebp
80108b1b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b1e:	83 ec 04             	sub    $0x4,%esp
80108b21:	6a 00                	push   $0x0
80108b23:	ff 75 0c             	pushl  0xc(%ebp)
80108b26:	ff 75 08             	pushl  0x8(%ebp)
80108b29:	e8 94 f7 ff ff       	call   801082c2 <walkpgdir>
80108b2e:	83 c4 10             	add    $0x10,%esp
80108b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b37:	8b 00                	mov    (%eax),%eax
80108b39:	83 e0 01             	and    $0x1,%eax
80108b3c:	85 c0                	test   %eax,%eax
80108b3e:	75 07                	jne    80108b47 <uva2ka+0x2f>
    return 0;
80108b40:	b8 00 00 00 00       	mov    $0x0,%eax
80108b45:	eb 29                	jmp    80108b70 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4a:	8b 00                	mov    (%eax),%eax
80108b4c:	83 e0 04             	and    $0x4,%eax
80108b4f:	85 c0                	test   %eax,%eax
80108b51:	75 07                	jne    80108b5a <uva2ka+0x42>
    return 0;
80108b53:	b8 00 00 00 00       	mov    $0x0,%eax
80108b58:	eb 16                	jmp    80108b70 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5d:	8b 00                	mov    (%eax),%eax
80108b5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b64:	83 ec 0c             	sub    $0xc,%esp
80108b67:	50                   	push   %eax
80108b68:	e8 d4 f2 ff ff       	call   80107e41 <p2v>
80108b6d:	83 c4 10             	add    $0x10,%esp
}
80108b70:	c9                   	leave  
80108b71:	c3                   	ret    

80108b72 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108b72:	55                   	push   %ebp
80108b73:	89 e5                	mov    %esp,%ebp
80108b75:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108b78:	8b 45 10             	mov    0x10(%ebp),%eax
80108b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108b7e:	eb 7f                	jmp    80108bff <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108b80:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b83:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b8e:	83 ec 08             	sub    $0x8,%esp
80108b91:	50                   	push   %eax
80108b92:	ff 75 08             	pushl  0x8(%ebp)
80108b95:	e8 7e ff ff ff       	call   80108b18 <uva2ka>
80108b9a:	83 c4 10             	add    $0x10,%esp
80108b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108ba0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108ba4:	75 07                	jne    80108bad <copyout+0x3b>
      return -1;
80108ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108bab:	eb 61                	jmp    80108c0e <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb0:	2b 45 0c             	sub    0xc(%ebp),%eax
80108bb3:	05 00 10 00 00       	add    $0x1000,%eax
80108bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bbe:	3b 45 14             	cmp    0x14(%ebp),%eax
80108bc1:	76 06                	jbe    80108bc9 <copyout+0x57>
      n = len;
80108bc3:	8b 45 14             	mov    0x14(%ebp),%eax
80108bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bcc:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108bcf:	89 c2                	mov    %eax,%edx
80108bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108bd4:	01 d0                	add    %edx,%eax
80108bd6:	83 ec 04             	sub    $0x4,%esp
80108bd9:	ff 75 f0             	pushl  -0x10(%ebp)
80108bdc:	ff 75 f4             	pushl  -0xc(%ebp)
80108bdf:	50                   	push   %eax
80108be0:	e8 0a cb ff ff       	call   801056ef <memmove>
80108be5:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108beb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bf7:	05 00 10 00 00       	add    $0x1000,%eax
80108bfc:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108bff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108c03:	0f 85 77 ff ff ff    	jne    80108b80 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c0e:	c9                   	leave  
80108c0f:	c3                   	ret    
