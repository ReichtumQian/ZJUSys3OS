// trap.c
#include "trap.h"
#include "clock.h"
#include "defs.h"
#include "mm.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"
#include "types.h"
#include "vm.h"

void trap_handler(unsigned long scause, unsigned long sepc,
                  struct pt_regs *regs) {
  // judge trap type via scause
  unsigned long mask = 1;
  mask = mask << 63;
  unsigned long interrupt = scause & mask;
  // ------------------------ interrupt ------------------------
  if (interrupt != 0) {
    // timer interrupt
    if (scause == 0x8000000000000005) {
      // printk("[S] Supervisor Mode Timer Interrupt\n");
      clock_set_next_event();
      do_timer();
    }
  }
  // ------------------------ system call ------------------------
  else if (scause == 8) { // system call
    // 由于 regs 中没有存 x0，所以获取 x17 其实读取的是 x[17 - 1]
    if (regs->x[17 - 1] == SYS_WRITE) {
      sys_write(regs->x[10 - 1], (char *)regs->x[11 - 1], regs->x[12 - 1]);
    } else if (regs->x[17 - 1] == SYS_GETPID) {
      regs->x[10 - 1] = sys_getpid();
    } else if(regs->x[17 - 1] == SYS_CLONE){
      regs->x[10 - 1] = clone(regs);
    }
    regs->sepc += 4;
  }
  // ------------------------ page fault ------------------------
  else if (scause == 12 || scause == 13 || scause == 15) {
    do_page_fault(regs);
  }
  // ------------------------ unhandled interrupt ------------------------
  else {
    // printk("Unhandled interrupt! scause: %d\n", scause);
    // printk("Unhandled interrupt! sepc: %d\n", sepc);
  }

  return;
}

extern struct task_struct *current;
extern uint64 uapp_start[];
extern uint64 uapp_end[];

void do_page_fault(struct pt_regs *regs) {
  const uint64 PTE_V = 1UL << 0;
  const uint64 PTE_R = 1UL << 1;
  const uint64 PTE_W = 1UL << 2;
  const uint64 PTE_X = 1UL << 3;
  const uint64 PTE_U = 1UL << 4;

  // 1. 通过 stval 获得访问出错的虚拟内存地址（Bad Address）
  uint64 stval = csr_read(stval);
  // 2. 通过 scause 获得当前的 Page Fault 类型
  uint64 scause = csr_read(scause);
  printk("[S] PAGE_FAULT: scause: %d, sepc: 0x%lx, badaddr: 0x%lx\n", scause, csr_read(sepc), stval);
  // 3. 通过 find_vm() 找到对应的 vm_area_struct
  struct vm_area_struct *vma = find_vma(current->mm, stval);
  // 4. 通过 vm_area_struct 的 vm_flags 对当前的 Page Fault 类型进行检查
  uint64 pte_prot = 0; // 页表项权限
  switch (scause) {
  case 12: // instruction page fault
    vma->vm_flags |= VM_EXEC;
    pte_prot = PTE_U | PTE_R | PTE_X | PTE_V | PTE_W;
    break;
  case 13: // load page fault
    vma->vm_flags |= VM_READ;
    pte_prot = PTE_U | PTE_R | PTE_V;
    break;
  case 15: // write page fault
    vma->vm_flags |= VM_WRITE;
    pte_prot = PTE_U | PTE_R | PTE_W | PTE_V;
    break;
  default:
    break;
  }
  // 5. 最后调用 create_mapping 对页表进行映射
  uint64 *pgtbl = (uint64 *)((uint64)current->pgd + (uint64)PA2VA_OFFSET);
  //   5.1 若 Bad Address 在用户态代码段的地址范围内，则将其映射至 uapp_start
  //   所在的物理地址
  uint64 userCodeLength = (uint64)uapp_end - (uint64)uapp_start;
  if (stval >= USER_START && stval < USER_START + userCodeLength) {
    create_mapping(pgtbl, vma->vm_start,
                   (uint64)uapp_start - (uint64)PA2VA_OFFSET,
                   userCodeLength, pte_prot);
  }
  //   5.2 若是 user stack，则直接分配映射
  else if (vma->vm_start == USER_END - PGSIZE) {
    create_mapping(pgtbl, vma->vm_start, current->thread_info->user_sp - (uint64)PGSIZE - (uint64)PA2VA_OFFSET,
                   PGSIZE, pte_prot);
  }
  //   5.3 若是其他情况，则用 kalloc 新建一块内存区域，并将 Bad Address
  //   所属的页面映射到该内存区域
  else {
    uint64 page = kalloc();
    create_mapping(pgtbl, vma->vm_start, (uint64)page - (uint64)PA2VA_OFFSET,
                   PGSIZE, pte_prot);
  }
}