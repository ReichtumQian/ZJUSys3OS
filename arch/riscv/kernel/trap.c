// trap.c 
#include"clock.h"
#include"printk.h"

void trap_handler(unsigned long scause, unsigned long sepc) {
  int tmp = scause;
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
    }
  }
  return ;
}