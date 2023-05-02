#include "mm.h"
#include "defs.h"
#include "string.h"


#include "printk.h"

extern char _end[];

struct {
  struct run *freelist;
} kmem;

uint64 kalloc() {
  struct run *r;

  r = kmem.freelist;
  kmem.freelist = r->next; // 将 r 移动到下一个位置

  memset((void *)r, 0x0, PGSIZE); // 将 r 指向的内存后 PGSIZE 个字节置为 0
  return (uint64)r;               // 返回分配地址的指针
}

void kfree(uint64 addr) {
  struct run *r;

  // PGSIZE align
  addr = addr & ~(PGSIZE - 1);

  memset((void *)addr, 0x0, (uint64)PGSIZE);

  r = (struct run *)addr;
  r->next = kmem.freelist;
  kmem.freelist = r;

  return;
}

void kfreerange(char *start, char *end) {
  char *addr = (char *)PGROUNDUP((uint64)start);
  for (; (uint64)(addr) + PGSIZE <= (uint64)end; addr += PGSIZE) {
    kfree((uint64)addr);
  }
}

void mm_init(void) {
  kfreerange(_end, (char *)(PHY_END + PA2VA_OFFSET));
  printk("...mm_init done!\n");
}
