#include "syscall.h"
#include "proc.h"
#include "sbi.h"


extern struct task_struct* current;
uint64 sys_getpid(){
  return current -> pid;
}

void sys_write(uint64 fd, const char* buf, uint64 count){
  for(uint64 i = 0; i < count; ++i){
    sbi_ecall(fd, 0, buf[i], 0, 0, 0, 0, 0);
  }
}
