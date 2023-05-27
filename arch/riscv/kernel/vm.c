// arch/riscv/kernel/vm.c

// extern unsigned long _stext is not correct!! so I change it to extern unsigned long _stext[]
// extern unsigned long _stext;
extern unsigned long _stext[];
extern unsigned long _srodata[];
extern unsigned long _sdata[];
extern unsigned long _sbss[];
extern unsigned long uapp_start[];
extern unsigned long uapp_end[];

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
  // early_pgtbl[384] = 0x000000002000000F;
  // early_pgtbl[2] = 0x000000002000000F;
  // -------------------------------------------------

  // definition for perm
  const uint64 PTE_V = 1UL << 0;
  const uint64 PTE_R = 1UL << 1;
  const uint64 PTE_W = 1UL << 2;
  const uint64 PTE_X = 1UL << 3;

  uint64 pageNumber = PHY_START >> 12;
  uint64 ppn = pageNumber << 10;

  uint64 index = (VM_START >> 30) & 0x1ff; // index for early_pgtbl
  early_pgtbl[index] = ppn | PTE_V | PTE_R | PTE_W | PTE_X;

  // index = (PHY_START >> 30) & 0x1ff;
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
  uint64 textLength = (uint64)_srodata - (uint64)_stext;
  create_mapping(swapper_pg_dir, (uint64)_stext, (uint64)_stext - PA2VA_OFFSET,
                 textLength, PTE_R | PTE_X | PTE_V);

  // mapping kernel rodata -|-|R|V
  uint64 rodataLength = (uint64)_sdata - (uint64)_srodata;
  create_mapping(swapper_pg_dir, (uint64)_srodata, (uint64)_srodata - PA2VA_OFFSET,
                 rodataLength, PTE_R | PTE_V);

  // mapping other memory -|W|R|V
  uint64 otherLength = PHY_SIZE - textLength - rodataLength;
  create_mapping(swapper_pg_dir, (uint64)_sdata, (uint64)_sdata - PA2VA_OFFSET,
                 otherLength, PTE_R | PTE_W | PTE_V);

  // set satp with swapper_pg_dir
  uint64 swp_pa = ((uint64)swapper_pg_dir) - PA2VA_OFFSET;
  uint64 swp_ppn = swp_pa >> 12;
  asm volatile(
    "mv t0, %0\n"
    "li t1, 1\n"
    "slli t1, t1, 63\n"
    "or t0, t0, t1\n"
    "csrw satp, t0\n"
    :
    : "r"(swp_ppn)
    : "memory"
  );

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
  const uint64 INT_MAX = 0x8000000000000000;
  uint64 vpn[3];
  uint64 ppn[3]; // ppn for three levels
  uint64 size = sz;
  uint64* pgtbl2, *pgtbl3;
  uint64 value; // for debug
  while(size < INT_MAX && size > 0){
    vpn[0] = (va >> 30) & 0x1ff;  // in virtual address it means vpn[2], but for convenience, we use vpn[0]
    vpn[1] = (va >> 21) & 0x1ff;
    vpn[2] = (va >> 12) & 0x1ff;
    for (int i = 0; i < 3; ++i) {
      //------------------ first  level -------------------
      if (i == 0) {
        // if not exist
        if ((pgtbl[vpn[i]] & PTE_V) == 0) {
          pgtbl2 = (uint64*)kalloc();
          memset(pgtbl2, 0x0, PGSIZE);
          uint64 pgtbl2_ppn = ((uint64)pgtbl2 - PA2VA_OFFSET) >> 12;
          value = ((pgtbl2_ppn) << 10) | PTE_V;
          pgtbl[vpn[i]] = value;
        }
        else{
          ppn[i] = pgtbl[vpn[i]] >> 10;
          value = ((ppn[i] << 12) + PA2VA_OFFSET);
          pgtbl2 = (uint64 *)value;
        }
      }
      //------------------ second level -------------------
      else if (i == 1) {
        // if not exist
        if ((pgtbl2[vpn[i]] & PTE_V) == 0) {
          pgtbl3 = (uint64*)kalloc();
          memset(pgtbl3, 0x0, PGSIZE);
          uint64 pgtbl3_ppn = ((uint64)pgtbl3 - PA2VA_OFFSET) >> 12;
          value = ((pgtbl3_ppn) << 10) | PTE_V;
          pgtbl2[vpn[i]] = value;
        }
        else{
          ppn[i] = pgtbl2[vpn[i]] >> 10;
          value = ((ppn[i] << 12) + PA2VA_OFFSET);
          pgtbl3 = (uint64 *)value;
        }
      }
      // ----------------- third level -------------------
      else {
        ppn[i] = pa >> 12;
        value = (ppn[i] << 10) | perm;
        pgtbl3[vpn[i]] = value;
      }
    }
    va += PGSIZE;
    pa += PGSIZE;
    size -= PGSIZE;
  }

}

uint64* setupUserPage(uint64* user_stack){
  // definition
  // const uint64 PTE_V = 1UL << 0;
  // const uint64 PTE_R = 1UL << 1;
  // const uint64 PTE_W = 1UL << 2;
  // const uint64 PTE_X = 1UL << 3;
  // const uint64 PTE_U = 1UL << 4;
  // create user page table
  uint64* pgtbl = (uint64*)kalloc();

  // 复制内核页表
  for(uint64 i = 0; i < 512; ++i){
    pgtbl[i] = swapper_pg_dir[i];
  }
  // -------------- 在 lab5 中注释对 U-MODE code, User stack 的映射 --------------
  // 设置 uapp 的页表，U, X, R, V = 1
  // create_mapping(pgtbl, USER_START, (uint64)uapp_start - PA2VA_OFFSET, PGSIZE, PTE_V | PTE_R | PTE_X | PTE_U| PTE_W);
  // 设置用户栈的页表，U, R, V = 1
  // create_mapping(pgtbl, USER_END - PGSIZE, (uint64)user_stack - PA2VA_OFFSET, PGSIZE, PTE_V | PTE_R | PTE_U| PTE_W);


  return pgtbl;
}

// struct vm_area_struct *find_vma(struct mm_struct *mm, uint64 addr){
//   if(mm == NULL){
//     return NULL;
//   }
//   struct vm_area_struct *vma = mm->mmap;
//   while(vma != NULL){
//     if(vma->vm_start <= addr && vma->vm_end > addr){
//       return vma;
//     }
//     vma = vma->vm_next;
//   }
//   return NULL;  // not found
// }

// uint64 do_mmap(struct mm_struct *mm, uint64 addr, uint64 length, int prot){

//   struct vm_area_struct *vma = mm->mmap;
  // uint64 alloc = kalloc();
  // struct vm_area_struct *node = (struct vm_area_struct *)alloc;
  // node->vm_mm = mm;
  // node->vm_flags = prot;
  // node->vm_start = addr;
  // node->vm_end = addr + length;
  // node->vm_next = NULL;
  // while(vma->vm_next != NULL){
  //   vma = vma->vm_next;
  // }
  // vma->vm_next = node;
  // node->vm_prev = vma;
  // return addr;
// }

// uint64 get_unmapped_area(struct mm_struct *mm, uint64 length){
//   // 这里采用了遍历 vma 的方式而非以 PGSIZE 为单位遍历的方式，这样可以简化实现

//   struct vm_area_struct *vma = mm->mmap;
//   if(length <= vma->vm_start){
//     return 0;
//   }
//   while(vma->vm_next != NULL){
//     uint64 gap = vma->vm_next->vm_start - vma->vm_end;
//     if(gap >= length){
//       return vma->vm_end;
//     }
//     vma = vma->vm_next;
//   }
//   return vma->vm_end;
// }

/*
* @mm          : current thread's mm_struct
* @address     : the va to look up
*
* @return      : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64 addr){
    if(mm == NULL) return NULL;
    struct vm_area_struct *temp = mm->mmap;
    if(temp == NULL) return NULL;
    while(temp->vm_next){
        if(temp->vm_start <= addr && temp->vm_end > addr){
            return temp;
        }
        temp = temp->vm_next;
    }
    if(temp->vm_start <= addr && temp->vm_end > addr){
            return temp;
    }
    else return NULL;
}

/*
 * @mm     : current thread's mm_struct
 * @addr   : the suggested va to map
 * @length : memory size to map
 * @prot   : protection
 *
 * @return : start va
*/
uint64 do_mmap(struct mm_struct *mm, uint64 addr, uint64 length, int prot){
    printk("Do_mmap: start addr:%lx  length:%lx\n",addr, length);
        
    struct vm_area_struct *newnode = (struct vm_area_struct *)kalloc();
    newnode->vm_prev = NULL;
    newnode->vm_next = NULL;
    newnode->vm_flags = prot;
    newnode->vm_mm = mm;
    struct vm_area_struct *temp = mm->mmap;
    int flag = 0;
    if(temp == NULL){
        mm->mmap = newnode;
        newnode->vm_start = addr;
        newnode->vm_end = addr + length;
        //printk("Do_mmap: start addr:%lx  end addr:%lx\n",newnode->vm_start, newnode->vm_end);
        return addr;
    }
    if(temp->vm_start > addr){//添加在链表最前面
        if(temp->vm_start <= addr + length){//页表前面没有空间，那就得放后面
            addr = get_unmapped_area(mm,length);
            flag = 1;
        }
        else{//页表前面有空间
            temp->vm_prev = newnode;
            newnode->vm_next = temp;
            mm->mmap = newnode;

            newnode->vm_start = addr;
            newnode->vm_end = addr + length;
            //printk("Do_mmap: start addr:%lx  end addr:%lx\n",newnode->vm_start, newnode->vm_end);
            return addr;
        }
    }
    while(temp->vm_next){           //addr必然在当前块start后面，再分end前、后讨论
        if(addr < temp->vm_end){   //如果addr在当前vma-end的前面，那必然冲突了
            if(!flag) addr = get_unmapped_area(mm, length);
            break;
        }
        if(addr >= temp->vm_end && addr < temp->vm_next->vm_start){ //如果addr在当前vma和下一个vma之间空挡
            if(temp->vm_next->vm_start < addr + length) //如果本次length会覆盖到下一个vma
                if(!flag) addr = get_unmapped_area(mm, length);
            break;//本次length不会覆盖下一个vma

        }
        temp=temp->vm_next;
    }
    //写着写着发现这里不需要映射，等到pagefault的时候才映射
    //create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
    //create_mapping(current->pgd, addr, phy_addr, length, prot);
    
    newnode->vm_start = addr;
    newnode->vm_end = addr + length;
    if(temp->vm_next) temp->vm_next->vm_prev = newnode;
    newnode->vm_next = temp->vm_next;
    newnode->vm_prev = temp;
    temp->vm_next = newnode;
    //printk("Do_mmap: start addr:%lx  end addr:%lx\n",newnode->vm_start, newnode->vm_end);
    return addr;
}

uint64 get_unmapped_area(struct mm_struct *mm, uint64 length){
    uint64 *i, *j;
    //遍历vma链表寻找之中空的那个
    printk("get unmapped area length %x\n",length);
    struct  vm_area_struct *temp = mm->mmap;
    printk("mmap %lx - %lx\n",temp->vm_start, temp->vm_end);
    uint64 addr=0;
    if(length <= temp->vm_start) return addr;
    while(temp->vm_next){
        //printk("mmap %lx - %lx\n",temp->vm_start, temp->vm_end);
        if(temp->vm_next->vm_start - temp->vm_end >= length){
            return temp->vm_end;
        }
        temp = temp->vm_next;
    }
    return temp->vm_end;
}