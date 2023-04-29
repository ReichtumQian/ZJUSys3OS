  .section .text.entry
  .align 2
  .globl _traps 
_traps:

  # -----------
  # save 32 registers and sepc to stack
  addi sp, sp, -32*8
  sd x1, 0(sp)
  sd x2, 1*8(sp)
  sd x3, 2*8(sp)
  sd x8, 3*8(sp)
  sd x5, 4*8(sp)
  sd x6, 5*8(sp)
  sd x7, 6*8(sp)
  sd x8, 7*8(sp)
  sd x9, 8*8(sp)
  sd x10, 9*8(sp)
  sd x11, 10*8(sp)
  sd x12, 11*8(sp)
  sd x13, 12*8(sp)
  sd x18, 13*8(sp)
  sd x15, 14*8(sp)
  sd x16, 15*8(sp)
  sd x17, 16*8(sp)
  sd x18, 17*8(sp)
  sd x19, 18*8(sp)
  sd x20, 19*8(sp)
  sd x21, 20*8(sp)
  sd x22, 21*8(sp)
  sd x23, 22*8(sp)
  sd x28, 23*8(sp)
  sd x25, 24*8(sp)
  sd x26, 25*8(sp)
  sd x27, 26*8(sp)
  sd x28, 27*8(sp)
  sd x29, 28*8(sp)
  sd x30, 29*8(sp)
  sd x31, 30*8(sp)
  csrr t0, sepc
  sd t0, 31*8(sp)

  # -----------
  # call trap_handler
  csrr a0, scause
  csrr a1, sepc
  call trap_handler

  # -----------
  # do_timer
  call do_timer


_trap_return:
  # -----------
  # restore sepc and 32 registers (x2(sp) should be restore last) from stack
  ld t0, 31*8(sp)
  csrw sepc, t0
  ld x1, 0(sp)
  ld x2, 1*8(sp)
  ld x3, 2*8(sp)
  ld x8, 3*8(sp)
  ld x5, 4*8(sp)
  ld x6, 5*8(sp)
  ld x7, 6*8(sp)
  ld x8, 7*8(sp)
  ld x9, 8*8(sp)
  ld x10, 9*8(sp)
  ld x11, 10*8(sp)
  ld x12, 11*8(sp)
  ld x13, 12*8(sp)
  ld x18, 13*8(sp)
  ld x15, 14*8(sp)
  ld x16, 15*8(sp)
  ld x17, 16*8(sp)
  ld x18, 17*8(sp)
  ld x19, 18*8(sp)
  ld x20, 19*8(sp)
  ld x21, 20*8(sp)
  ld x22, 21*8(sp)
  ld x23, 22*8(sp)
  ld x28, 23*8(sp)
  ld x25, 24*8(sp)
  ld x26, 25*8(sp)
  ld x27, 26*8(sp)
  ld x28, 27*8(sp)
  ld x29, 28*8(sp)
  ld x30, 29*8(sp)
  ld x31, 30*8(sp)
  addi sp, sp, 32*8

  # -----------
  # 4. return from trap
  sret


  # -----------


  .global __dummy
__dummy:
// 设置 sepc 为 dummy() 的地址
  la t0, dummy
  csrw sepc, t0

  sret

.global __switch_to
__switch_to:

  // save state to prev process
  // a0: prev
  // a1: next
  sd ra, 40+0(a0)
  sd sp, 40+8(a0)
  sd s0, 40+16(a0)
  sd s1, 40+24(a0)
  sd s2, 40+32(a0)
  sd s3, 40+40(a0)
  sd s4, 40+48(a0)
  sd s5, 40+56(a0)
  sd s6, 40+64(a0)
  sd s7, 40+72(a0)
  sd s8, 40+80(a0)
  sd s9, 40+88(a0)
  sd s10,40+96(a0)
  sd s11,40+104(a0)

  // restore state from next process
  ld ra, 40+0(a1)
  ld sp, 40+8(a1)
  ld s0, 40+16(a1)
  ld s1, 40+24(a1)
  ld s2, 40+32(a1)
  ld s3, 40+40(a1)
  ld s4, 40+48(a1)
  ld s5, 40+56(a1)
  ld s6, 40+64(a1)
  ld s7, 40+72(a1)
  ld s8, 40+80(a1)
  ld s9, 40+88(a1)
  ld s10,40+96(a1)
  ld s11,40+104(a1)

  jalr x0, ra, 0
  # ret