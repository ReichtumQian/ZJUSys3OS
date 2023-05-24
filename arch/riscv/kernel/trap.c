// trap.c
#include "clock.h"
#include "defs.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"
#include "types.h"


struct pt_regs {
  uint64 x[31];
  uint64 sepc;
  uint64 sstatus;
};

void trap_handler(unsigned long scause, unsigned long sepc,
                  struct pt_regs *regs) {
  // judge trap type via scause
  unsigned long mask = 1;
  mask = mask << 63;
  unsigned long interrupt = scause & mask;
  // 如果是 interrupt 判断是否为 timer interrupt
  if (interrupt != 0) {
    // timer interrupt
    if (scause == 0x8000000000000005) {
      // printk("[S] Supervisor Mode Timer Interrupt\n");
      clock_set_next_event();
      do_timer();
    }
  } else {
    if (scause == 8) {
      // 由于 regs 中没有存 x0，所以获取 x17 其实读取的是 x[17 - 1]
      if (regs->x[17 - 1] == SYS_WRITE) {
        sys_write(regs->x[10 - 1], (char *)regs->x[11 - 1], regs->x[12 - 1]);
      } else if (regs->x[17 - 1] == SYS_GETPID) {
        regs->x[10 - 1] = sys_getpid();
      }
      regs->sepc += 4;
    }
  }

  return;
}

void do_page_fault(struct pt_regs *regs) {
    /*
    1. 通过 stval 获得访问出错的虚拟内存地址（Bad Address）
    2. 通过 scause 获得当前的 Page Fault 类型
    3. 通过 find_vm() 找到对应的 vm_area_struct
    4. 通过 vm_area_struct 的 vm_flags 对当前的 Page Fault 类型进行检查
        4.1 Instruction Page Fault      -> VM_EXEC
        4.2 Load Page Fault             -> VM_READ
        4.3 Store Page Fault            -> VM_WRITE
    5. 最后调用 create_mapping 对页表进行映射
    */

    // 读取 stval
    uint64 stval = csr_read(stval);
    uint64 scause = csr_read(scause);
}