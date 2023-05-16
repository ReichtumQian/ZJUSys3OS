// trap.c
#include "clock.h"
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