// trap.c
#include "trap.h"
#include "clock.h"
#include "defs.h"
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
    }
    regs->sepc += 4;
  }
  // ------------------------ page fault ------------------------
  else if (scause == 12 || scause == 13 || scause == 15) {
    do_page_fault(regs);
  }
  // ------------------------ unhandled interrupt ------------------------
  else {
    printk("Unhandled interrupt! scause: %d\n", scause);
    printk("Unhandled interrupt! sepc: %d\n", sepc);
  }

  return;
}

extern struct task_struct* current;

void do_page_fault(struct pt_regs *regs) {
  // 1. 通过 stval 获得访问出错的虚拟内存地址（Bad Address）
  uint64 stval = csr_read(stval);
  // 2. 通过 scause 获得当前的 Page Fault 类型
  uint64 scause = csr_read(scause);
  // 3. 通过 find_vm() 找到对应的 vm_area_struct
  struct vm_area_struct *vma = find_vma(current->mm, stval);
  // 4. 通过 vm_area_struct 的 vm_flags 对当前的 Page Fault 类型进行检查
  // 5. 最后调用 create_mapping 对页表进行映射
}