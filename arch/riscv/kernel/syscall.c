#include "syscall.h"
#include "mm.h"
#include "proc.h"
#include "rand.h"
#include "sbi.h"
#include "stddef.h"
#include "trap.h"
#include "types.h"
#include "defs.h"
#include "vm.h"

extern struct task_struct *current;
uint64 sys_getpid() { return current->pid; }

void sys_write(uint64 fd, const char *buf, uint64 count) {
  for (uint64 i = 0; i < count; ++i) {
    sbi_ecall(fd, 0, buf[i], 0, 0, 0, 0, 0);
  }
}

extern void ret_from_fork(struct pt_regs *trapframe); // in entry.S
void forkret() { ret_from_fork(current->trapframe); }

extern struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此
extern uint64 num_tasks;                   // 线程数量

uint64 do_fork(struct pt_regs *regs) {
  ++num_tasks;          // 线程数量加一
  uint64 i = num_tasks; // alias

  // 1.参考 task_init 创建一个新的子进程，设置好 state, counter, priority, pid
  uint64 task_page = kalloc();
  task[i] = (struct task_struct *)task_page;
  task[i]->state = TASK_RUNNING;
  task[i]->counter = 0;
  // task[i]->priority = rand();
  if(i == 2){
    task[i]->priority = 4;
  }else{
    task[i]->priority = 5;
  }
  task[i]->pid = i;

  // 2. 创建子进程的用户栈，将子进程用户栈的地址保存在 thread_info->user_sp 中，并将父进程用户栈的内容拷贝到子进程的用户栈中
  uint64* user_stack = (uint64*)kalloc();
  task[i]->thread_info = (struct thread_info*) kalloc();
  task[i]->thread_info->user_sp = (uint64)user_stack + (uint64)PGSIZE; // 指向栈顶
  for(uint64 j = 0; j < 512; ++j) {
    user_stack[j] = ((uint64*)((uint64)USER_END - (uint64)PGSIZE))[j];
  }

  // 3. 正确设置子进程的 thread 成员变量
  task[i]->thread.ra = (uint64)forkret;
  task[i]->thread.sp = (uint64)task[i] + PGSIZE;
  task[i]->thread.sepc = regs->sepc;
  task[i]->thread.sstatus = (1 << 18) | (1 << 5);
  task[i]->thread.sscratch = (uint64)task[i] + PGSIZE;

  // 4. 正确设置子进程的 pgd 成员变量，为子进程分配根页表，并将内核根页表 swapper_pg_dir 的内容复制到子进程的根页表中，从而对于子进程来说只建立了内核的页表映射。
  uint64 user_pgd = (uint64)setupUserPage(user_stack) - (uint64)PA2VA_OFFSET;
  task[i]->pgd = (uint64*)user_pgd;

  // 5. 正确设置子进程的 mm 成员变量，复制父进程的 vma 链表
  task[i]->mm = (struct mm_struct*)kalloc();
  struct vm_area_struct* vma = current->mm->mmap;
  while(vma != NULL) {
    do_mmap(task[i]->mm, vma->vm_start, vma->vm_end - vma->vm_start, vma->vm_flags);
    vma = vma->vm_next;
  }

  // 6. 正确设置子进程的 trapframe 成员变量。将父进程的上下文环境（即传入的 regs）保存到子进程的 trapframe 中
  task[i]->trapframe = (struct pt_regs*)kalloc();
  for(uint64 j = 0; j < 31; ++j){
    task[i]->trapframe->x[j] = regs->x[j];
  }  
  task[i]->trapframe->sepc = regs->sepc;
  task[i]->trapframe->sstatus = regs->sstatus;

  task[i]->trapframe->x[10] = 0; // 子进程返回值为 0
  task[i]->trapframe->x[1] = csr_read(sscratch); // sp 为父进程的 sscratch(用户态 sp)

  // 7. 返回子进程的 pid
  return i;
}

uint64 clone(struct pt_regs *regs) { return do_fork(regs); }