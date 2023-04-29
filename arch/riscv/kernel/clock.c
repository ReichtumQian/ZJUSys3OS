// clock.c

#include"sbi.h"
#include"clock.h"

unsigned long TIMECLOCK = 10000000;

unsigned long get_cycles() {
  // 使用 rdtime 编写内联汇编，获取 time 寄存器中（也就是 mtime 寄存器）的值，并返回
  unsigned long cycles;
  asm volatile("rdtime %0" : "=r"(cycles));
  return cycles;
}

void clock_set_next_event() {
  // 下一次时钟中断的时间点
  unsigned long next = get_cycles() + TIMECLOCK;

  // 使用 sbi_ecall 来完成对下一次时钟中断的设置
  sbi_ecall(SBI_SET_TIMER,0, next, 0, 0, 0, 0, 0);
  return;
} 