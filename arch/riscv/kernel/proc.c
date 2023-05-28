#include"proc.h"
#include"printk.h"
#include"mm.h"
#include"rand.h"
#include"defs.h"
#include "types.h"
#include "vm.h"
#include "proc.h"

extern unsigned long uapp_start[];
extern unsigned long uapp_end[];

#define INT_MAX 2147483647
#define UINT_MAX 4294967295

extern void __dummy();

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

struct task_struct* idle;           // idle process
struct task_struct* current;        // 指向当前运行线程的 `task_struct`
struct task_struct* task[NR_TASKS]; // 线程数组，所有的线程都保存在此
uint64 num_tasks = 1;                // 当前线程数


void task_init() {
  // 1. 调用 kalloc() 为 idle 分配一个物理页
  uint64 idle_page = kalloc();
  // 2. 设置 state 为 TASK_RUNNING;
  idle = (struct task_struct *)idle_page;
  idle->state = TASK_RUNNING;
  // 3. 由于 idle 不参与调度 可以将其 counter / priority 设置为 0
  idle->counter = 0;
  idle->priority = 0;
  // 4. 设置 idle 的 pid 为 0
  idle->pid = 0;
  // 5. 将 current 和 task[0] 指向 idle
  current = idle;
  task[0] = idle;


  // 1. 参考 idle 的设置, 为 task[1] ~ task[NR_TASKS - 1] 进行初始化
  // 2. 其中每个线程的 state 为 TASK_RUNNING, counter 为 0, priority 使用 rand() 来设置, pid 为该线程在线程数组中的下标。
  // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 `thread_struct` 中的 `ra` 和 `sp`, 
  // 4. 其中 `ra` 设置为 __dummy （见 4.3.2）的地址， `sp` 设置为 该线程申请的物理页的高地址
  for(int i = 1; i < 2; ++i) {
    // 设置 task、state、counter、priority、pid
    uint64 task_page = kalloc();
    task[i] = (struct task_struct *)task_page;
    task[i]->state = TASK_RUNNING;
    task[i]->counter = 0;
    // task[i]->priority = rand();
    task[i] -> priority = 10;
    task[i]->pid = i;
    // 设置 ra 和 sp
    task[i]->thread.ra = (uint64)__dummy;
    task[i]->thread.sp = task_page + PGSIZE;
    // 设置 sepc 为 USER_START，使得 sret 返回用户态
    task[i]->thread.sepc = USER_START;
    // 设置 sstatus 的 SPP = 0 (bit 8), SPIE = 1 (bit 5), SUM = 1 (bit 18)
    task[i]->thread.sstatus = (1 << 18) | (1 << 5);
    // 设置 sscratch 为 USER_END
    task[i]->thread.sscratch = USER_END;
    // ------------------- lab4 and lab5 ------------------------
    // 初始化 user_stack, page table
    uint64* user_stack = (uint64*) kalloc();
    task[i]->thread_info = (struct thread_info*)(kalloc());
    task[i]->thread_info->user_sp = (uint64)user_stack + PGSIZE;
    uint64 user_pgd = (uint64)setupUserPage(user_stack) - (uint64)PA2VA_OFFSET;
    task[i]->pgd =  (uint64*)user_pgd;
    // 初始化 mm_struct
    uint64 mm = kalloc();
    task[i]->mm = (struct mm_struct*)(mm);
    task[i]->mm->mmap=NULL;
    // user code segment
    do_mmap(task[i]->mm, USER_START, (uint64)uapp_end - (uint64)uapp_start, VM_READ|VM_WRITE|VM_EXEC);
    // user stack segment
    do_mmap(task[i]->mm, USER_END - PGSIZE, PGSIZE, VM_READ|VM_WRITE);
  }
  // task[1] -> priority = 1;
  // task[2] -> priority = 4;
  // task[3] -> priority = 5;

  printk("...proc_init done!\n");
  return;
}


void dummy() {
  uint64 MOD = 1000000007;
  uint64 auto_inc_local_var = 0;
  int last_counter = -1; // 记录上一个counter
  int last_last_counter = -1; // 记录上上个counter
  while(1) {
    if (last_counter == -1 || current->counter != last_counter) {
        last_last_counter = last_counter;
        last_counter = current->counter;
        auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
        printk("[PID = %d] is running. thread space begin at %lx\n", current->pid, current); 
    } else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
        // 这里比较 tricky，不要求理解。
        last_counter = 0; 
        current->counter = 0;
    }
  }
  return;
}

void switch_to(struct task_struct *next){
  // 和 current 比较，如果相同则无需处理
  if (current == next) {
    return;
  }
  // 否则进行切换
  struct task_struct *prev = current;
  current = next;
  printk("switch to [PID = %d, PRIORITY = %d, COUNTER = %d]\n", current->pid, current->priority, current->counter);
  // 一些 sao 操作，卡一下边界，否则可能多输出或少输出一些东西
  if(current -> counter != 1){
    current -> counter = current -> counter - 1;
  }
  __switch_to(prev, next);
  return;
}

void do_timer(){
  // 将当前进程的 count --，如果结果大于零则直接返回
  int counter = current->counter;
  if(counter > 0){
    current -> counter = counter - 1;
    return;
  }
  // 否则进行调度
  schedule();
  return;
}


void schedule(){
	int i,next;
  uint64 c;
	struct task_struct ** p;

  while (1) {
		c = UINT_MAX;
		next = 0;
		i = num_tasks + 1;
		p = &task[num_tasks + 1];
		while (--i) {
      --p;
      char one = (*p)->state == TASK_RUNNING;
      uint64 counter = (*p) -> counter;
      char two = (counter < c) && (counter != 0);
      if(one && two){
        c = (*p)->counter;
        next = i;
      }
		}
		if (c != UINT_MAX) break;
		for(p = (&FIRST_TASK+1) ; p <= &task[num_tasks] ; ++p){
      (*p)->counter = (*p)->priority;
      printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", (*p)->pid, (*p)->priority, (*p)-> counter);

      // (*p)->counter = ((*p)->counter >> 1) + (*p)->priority;
    }
		c = UINT_MAX;
	}
	switch_to(task[next]);
  return;
}




