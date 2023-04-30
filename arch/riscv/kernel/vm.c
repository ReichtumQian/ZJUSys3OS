// arch/riscv/kernel/vm.c

extern unsigned long _stext;
extern unsigned long _srodata;
extern unsigned long _sdata;
extern unsigned long _sbsss;

#include "defs.h"
#include <string.h>
#include <stddef.h>
#include "mm.h"
#include "printk.h"
#include "types.h"

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm(void)
{
    /*
    1. 由于是进行 1GB 的映射 这里不需要使用多级页表
    2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
        high bit 可以忽略
        中间9 bit 作为 early_pgtbl 的 index
        低 30 bit 作为 页内偏移 这里注意到 30 = 9 + 9 + 12， 即我们只使用根页表， 根页表的每个 entry 都对应 1GB 的区域。
    3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    4. early_pgtbl 对应的是虚拟地址，而在本函数中你需要将其转换为对应的物理地址使用
    */
    // convert virtual address to physical address
    unsigned long* early_pgtbl_pa = early_pgtbl - PA2VA_OFFSET;
    for(size_t i = 0; i < 512; ++i){
      // set PPN
      early_pgtbl_pa[i] = PHY_START + (i << 30); 
      // set V, R, W, X bit to 1
      early_pgtbl_pa[i] += (1) | (1 << 1) | (1 << 2) | (1 << 3);
    }
}


/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long  swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final(void) {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required

    // mapping kernel text X|-|R|V
    //  create_mapping(swapper_pg_dir, (uint64)&_stext, (uint64)&_stext, (uint64)&_srodata - (uint64)&_stext, PTE_R | PTE_X | PTE_V);

    // mapping kernel rodata -|-|R|V
    // create_mapping(...);
  
    // mapping other memory -|W|R|V
    // create_mapping(...);
  
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
  // uint64 va_start = PGROUNDDOWN(va);
  // uint64 va_end = PGROUNDUP(va + sz);
  // uint64 pa_start = PGROUNDDOWN(pa);
  // uint64 pa_end = PGROUNDUP(pa + sz);
  // for(uint64 va_cur = va_start, pa_cur = pa_start; va_cur < va_end; va_cur += PGSIZE, pa_cur += PGSIZE){
  //   // get pte
  //   uint64* pte = walk(pgtbl, va_cur, 1);
  //  // set pte
  //   *pte = pa_cur | perm | PTE_V;
  // }
}
