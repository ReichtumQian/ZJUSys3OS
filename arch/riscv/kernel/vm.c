// arch/riscv/kernel/vm.c

extern unsigned long _stext;
extern unsigned long _srodata;
extern unsigned long _sdata;
extern unsigned long _sbsss;

#include "vm.h"
#include "defs.h"
#include "mm.h"
#include "printk.h"
#include "types.h"
#include <stddef.h>
#include <string.h>

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm(void) {
  /*
  1. 由于是进行 1GB 的映射 这里不需要使用多级页表
  2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
      high bit 可以忽略
      中间9 bit 作为 early_pgtbl 的 index
      低 30 bit 作为 页内偏移 这里注意到 30 = 9 + 9 + 12， 即我们只使用根页表，
  根页表的每个 entry 都对应 1GB 的区域。
  3. Page Table Entry 的权限 V | R | W | X 位设置为 1
  4. early_pgtbl
  对应的是虚拟地址，而在本函数中你需要将其转换为对应的物理地址使用
  */
  // ------------------ calculation ------------------
  // va = 0xffffffe000000000
  // index bit = 1 1000 0000b = 384d
  // pa = 0x80000000
  // page_number = pa >> 12 = 0x80000
  // ppn = page_number << 10 = 0x2000 0000
  // table entry = ppn | 0xf = 0x2000 0000 | 0xf = 0x2000 000f
  // -------------------------------------------------

  // definition for perm
  // const uint64 PTE_V = 1UL << 0;
  // const uint64 PTE_R = 1UL << 1;
  // const uint64 PTE_W = 1UL << 2;
  // const uint64 PTE_X = 1UL << 3;

  // uint64 index = (PHY_START >> 30) & 0x1ff; // index for early_pgtbl
  // uint64 pageNumber = PHY_START >> 12;
  // uint64 ppn = pageNumber << 10;
  // early_pgtbl[index] = ppn | PTE_V | PTE_R | PTE_W | PTE_X;

  // index = (VM_START >> 30) & 0x1ff;
  // early_pgtbl[index] = ppn | PTE_V | PTE_R | PTE_W | PTE_X;


  printk("setup_vm finished!\n");
  return;
}

/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final(void) {
  // definition for perm
  const uint64 PTE_V = 1UL << 0;
  const uint64 PTE_R = 1UL << 1;
  const uint64 PTE_W = 1UL << 2;
  const uint64 PTE_X = 1UL << 3;

  memset(swapper_pg_dir, 0x0, PGSIZE);

  // No OpenSBI mapping required

  // mapping kernel text X|-|R|V
  create_mapping(swapper_pg_dir, _stext, _stext - PA2VA_OFFSET,
                 _srodata - _stext, PTE_R | PTE_X | PTE_V);

  // mapping kernel rodata -|-|R|V
  create_mapping(swapper_pg_dir, _srodata, _srodata - PA2VA_OFFSET,
                 _sdata - _srodata, PTE_R | PTE_V);

  // mapping other memory -|W|R|V
  create_mapping(swapper_pg_dir, _sdata, _sdata - PA2VA_OFFSET, VM_END - _sdata,
                 PTE_R | PTE_W | PTE_V);

  // set satp with swapper_pg_dir
  asm volatile("csrw satp, %0" : : "r"(swapper_pg_dir) : "memory");

  // flush TLB
  asm volatile("sfence.vma zero, zero");
  return;
}

/* 创建多级页表映射关系 */
void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
  /*
  pgtbl 为根页表的基地址
  va, pa 为需要映射的虚拟地址、物理地址
  sz 为映射的大小
  perm 为映射的读写权限

  将给定的一段虚拟内存映射到物理内存上
  物理内存需要分页
  创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
  可以使用 V bit 来判断页表项是否存在
  */
  const uint64 PTE_V = 1UL << 0;
  uint64 vpn[3];
  vpn[2] = (va >> 30) & 0x1ff;
  vpn[1] = (va >> 21) & 0x1ff;
  vpn[0] = (va >> 12) & 0x1ff;
  uint64 ppn[3]; // ppn for three levels
  for (int i = 0; i < 3; ++i) {
    //------------------ first and second level -------------------
    if (i == 0 || i == 1) {
      // if not exist
      if ((pgtbl[vpn[i]] & PTE_V) == 0) {
        uint64 new_pgtbl = kalloc();
        uint64 new_pgtbl_ppn = new_pgtbl >> 12;
        pgtbl[vpn[i]] = (new_pgtbl_ppn << 10) | perm;
      }
      ppn[i] = pgtbl[vpn[i]] >> 10;
      pgtbl = (uint64 *)(ppn[i] << 12);
    }
    // ----------------- third level -------------------
    else {
      ppn[i] = pa >> 12;
      pgtbl[vpn[i]] = (ppn[i] << 10) | perm;
    }
  }
}
