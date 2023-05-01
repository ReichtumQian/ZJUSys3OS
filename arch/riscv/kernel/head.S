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
    
    # ...
    # call setup_vm_final

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

