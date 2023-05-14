#include "syscall.h"
#include "proc.h"


extern struct task_struct* current;
uint64 sys_getpid(){
  return current -> pid;
}


