.extern start_kernel
.extern _traps
.extern mm_init
.extern task_init

  .section .text.init
  .globl _start
_start:
  lla sp, _stack
  call setup_vm
  call relocate
  
  call mm_init
  call setup_vm_final
  call task_init

  //===================================
  // lab5 ： 开启中断
  // set stvec = _traps
  # la t0, _traps
  # csrw stvec, t0

  // set sstatus[SIE] = 1
  # li t0, 0x2
  # csrs sstatus, t0

  // set first time interrupt
  # li a7, 0x00
  # li a6, 0
  # rdtime t0
  # li t1, 10000000
  # add t0, t0, t1
  # mv a0, t0
  # ecall

  // set sie[STIE] = 1
  # csrr t0, sie
  # li t1, 0x20
  # or t0, t0, t1
  # csrw sie, t0

  j start_kernel

relocate:
  # set t1 as PA2VA_OFFSET
  li t1, 0xffffffe000000000
  li t2, 0x0000000080000000
  sub t1, t1, t2

  # set ra = ra + PA2VA_OFFSET
  add ra, ra, t1
  # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
  add sp, sp, t1
  
  # set satp with early_pgtbl‘s physical address
  li t3, 1
  slli t3, t3, 63 # set mode to Sv39
  la t0, early_pgtbl
  sub t0, t0, t1
  srli t0, t0, 12
  add t0, t0, t3
  csrw satp, t0


  # flush tlb
  sfence.vma zero, zero

  ret
