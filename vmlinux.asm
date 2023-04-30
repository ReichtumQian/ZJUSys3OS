
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_start>:
.extern task_init

    .section .text.init
    .globl _start
_start:
    lla sp, _stack
ffffffe000200000:	00008117          	auipc	sp,0x8
ffffffe000200004:	00010113          	mv	sp,sp
    call setup_vm
ffffffe000200008:	34d000ef          	jal	ra,ffffffe000200b54 <setup_vm>
    call relocate
ffffffe00020000c:	008000ef          	jal	ra,ffffffe000200014 <relocate>
    
    # ...

    j start_kernel
ffffffe000200010:	46d0006f          	j	ffffffe000200c7c <start_kernel>

ffffffe000200014 <relocate>:

relocate:
    # set t1 as PA2VA_OFFSET
    li t1, 0xffffffe000000000
ffffffe000200014:	fff0031b          	addiw	t1,zero,-1
ffffffe000200018:	02531313          	slli	t1,t1,0x25
    li t2, 0x0000000080000000
ffffffe00020001c:	0010039b          	addiw	t2,zero,1
ffffffe000200020:	01f39393          	slli	t2,t2,0x1f
    sub t1, t1, t2
ffffffe000200024:	40730333          	sub	t1,t1,t2

    # set ra = ra + PA2VA_OFFSET
    add ra, ra, t1
ffffffe000200028:	006080b3          	add	ra,ra,t1
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    add sp, sp, t1
ffffffe00020002c:	00610133          	add	sp,sp,t1
   
    # set satp with early_pgtbl‘s physical address
    li t3, 1
ffffffe000200030:	00100e13          	li	t3,1
    slli t3, t3, 63 # set mode to Sv39
ffffffe000200034:	03fe1e13          	slli	t3,t3,0x3f
    la t0, early_pgtbl
ffffffe000200038:	00003297          	auipc	t0,0x3
ffffffe00020003c:	fe02b283          	ld	t0,-32(t0) # ffffffe000203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    sub t0, t0, t1
ffffffe000200040:	406282b3          	sub	t0,t0,t1
    srli t0, t0, 12
ffffffe000200044:	00c2d293          	srli	t0,t0,0xc
    add t0, t0, t3
ffffffe000200048:	01c282b3          	add	t0,t0,t3
    csrw satp, t0
ffffffe00020004c:	18029073          	csrw	satp,t0
  
  
    # flush tlb
    sfence.vma zero, zero
ffffffe000200050:	12000073          	sfence.vma

    ret
ffffffe000200054:	00008067          	ret

ffffffe000200058 <_traps>:
  .globl _traps 
_traps:

  # -----------
  # save 32 registers and sepc to stack
  addi sp, sp, -32*8
ffffffe000200058:	f0010113          	addi	sp,sp,-256 # ffffffe000207f00 <r+0xef8>
  sd x1, 0(sp)
ffffffe00020005c:	00113023          	sd	ra,0(sp)
  sd x2, 1*8(sp)
ffffffe000200060:	00213423          	sd	sp,8(sp)
  sd x3, 2*8(sp)
ffffffe000200064:	00313823          	sd	gp,16(sp)
  sd x8, 3*8(sp)
ffffffe000200068:	00813c23          	sd	s0,24(sp)
  sd x5, 4*8(sp)
ffffffe00020006c:	02513023          	sd	t0,32(sp)
  sd x6, 5*8(sp)
ffffffe000200070:	02613423          	sd	t1,40(sp)
  sd x7, 6*8(sp)
ffffffe000200074:	02713823          	sd	t2,48(sp)
  sd x8, 7*8(sp)
ffffffe000200078:	02813c23          	sd	s0,56(sp)
  sd x9, 8*8(sp)
ffffffe00020007c:	04913023          	sd	s1,64(sp)
  sd x10, 9*8(sp)
ffffffe000200080:	04a13423          	sd	a0,72(sp)
  sd x11, 10*8(sp)
ffffffe000200084:	04b13823          	sd	a1,80(sp)
  sd x12, 11*8(sp)
ffffffe000200088:	04c13c23          	sd	a2,88(sp)
  sd x13, 12*8(sp)
ffffffe00020008c:	06d13023          	sd	a3,96(sp)
  sd x18, 13*8(sp)
ffffffe000200090:	07213423          	sd	s2,104(sp)
  sd x15, 14*8(sp)
ffffffe000200094:	06f13823          	sd	a5,112(sp)
  sd x16, 15*8(sp)
ffffffe000200098:	07013c23          	sd	a6,120(sp)
  sd x17, 16*8(sp)
ffffffe00020009c:	09113023          	sd	a7,128(sp)
  sd x18, 17*8(sp)
ffffffe0002000a0:	09213423          	sd	s2,136(sp)
  sd x19, 18*8(sp)
ffffffe0002000a4:	09313823          	sd	s3,144(sp)
  sd x20, 19*8(sp)
ffffffe0002000a8:	09413c23          	sd	s4,152(sp)
  sd x21, 20*8(sp)
ffffffe0002000ac:	0b513023          	sd	s5,160(sp)
  sd x22, 21*8(sp)
ffffffe0002000b0:	0b613423          	sd	s6,168(sp)
  sd x23, 22*8(sp)
ffffffe0002000b4:	0b713823          	sd	s7,176(sp)
  sd x28, 23*8(sp)
ffffffe0002000b8:	0bc13c23          	sd	t3,184(sp)
  sd x25, 24*8(sp)
ffffffe0002000bc:	0d913023          	sd	s9,192(sp)
  sd x26, 25*8(sp)
ffffffe0002000c0:	0da13423          	sd	s10,200(sp)
  sd x27, 26*8(sp)
ffffffe0002000c4:	0db13823          	sd	s11,208(sp)
  sd x28, 27*8(sp)
ffffffe0002000c8:	0dc13c23          	sd	t3,216(sp)
  sd x29, 28*8(sp)
ffffffe0002000cc:	0fd13023          	sd	t4,224(sp)
  sd x30, 29*8(sp)
ffffffe0002000d0:	0fe13423          	sd	t5,232(sp)
  sd x31, 30*8(sp)
ffffffe0002000d4:	0ff13823          	sd	t6,240(sp)
  csrr t0, sepc
ffffffe0002000d8:	141022f3          	csrr	t0,sepc
  sd t0, 31*8(sp)
ffffffe0002000dc:	0e513c23          	sd	t0,248(sp)

  # -----------
  # call trap_handler
  csrr a0, scause
ffffffe0002000e0:	14202573          	csrr	a0,scause
  csrr a1, sepc
ffffffe0002000e4:	141025f3          	csrr	a1,sepc
  call trap_handler
ffffffe0002000e8:	1f1000ef          	jal	ra,ffffffe000200ad8 <trap_handler>

  # -----------
  # do_timer
  call do_timer
ffffffe0002000ec:	6fc000ef          	jal	ra,ffffffe0002007e8 <do_timer>

ffffffe0002000f0 <_trap_return>:


_trap_return:
  # -----------
  # restore sepc and 32 registers (x2(sp) should be restore last) from stack
  ld t0, 31*8(sp)
ffffffe0002000f0:	0f813283          	ld	t0,248(sp)
  csrw sepc, t0
ffffffe0002000f4:	14129073          	csrw	sepc,t0
  ld x1, 0(sp)
ffffffe0002000f8:	00013083          	ld	ra,0(sp)
  ld x2, 1*8(sp)
ffffffe0002000fc:	00813103          	ld	sp,8(sp)
  ld x3, 2*8(sp)
ffffffe000200100:	01013183          	ld	gp,16(sp)
  ld x8, 3*8(sp)
ffffffe000200104:	01813403          	ld	s0,24(sp)
  ld x5, 4*8(sp)
ffffffe000200108:	02013283          	ld	t0,32(sp)
  ld x6, 5*8(sp)
ffffffe00020010c:	02813303          	ld	t1,40(sp)
  ld x7, 6*8(sp)
ffffffe000200110:	03013383          	ld	t2,48(sp)
  ld x8, 7*8(sp)
ffffffe000200114:	03813403          	ld	s0,56(sp)
  ld x9, 8*8(sp)
ffffffe000200118:	04013483          	ld	s1,64(sp)
  ld x10, 9*8(sp)
ffffffe00020011c:	04813503          	ld	a0,72(sp)
  ld x11, 10*8(sp)
ffffffe000200120:	05013583          	ld	a1,80(sp)
  ld x12, 11*8(sp)
ffffffe000200124:	05813603          	ld	a2,88(sp)
  ld x13, 12*8(sp)
ffffffe000200128:	06013683          	ld	a3,96(sp)
  ld x18, 13*8(sp)
ffffffe00020012c:	06813903          	ld	s2,104(sp)
  ld x15, 14*8(sp)
ffffffe000200130:	07013783          	ld	a5,112(sp)
  ld x16, 15*8(sp)
ffffffe000200134:	07813803          	ld	a6,120(sp)
  ld x17, 16*8(sp)
ffffffe000200138:	08013883          	ld	a7,128(sp)
  ld x18, 17*8(sp)
ffffffe00020013c:	08813903          	ld	s2,136(sp)
  ld x19, 18*8(sp)
ffffffe000200140:	09013983          	ld	s3,144(sp)
  ld x20, 19*8(sp)
ffffffe000200144:	09813a03          	ld	s4,152(sp)
  ld x21, 20*8(sp)
ffffffe000200148:	0a013a83          	ld	s5,160(sp)
  ld x22, 21*8(sp)
ffffffe00020014c:	0a813b03          	ld	s6,168(sp)
  ld x23, 22*8(sp)
ffffffe000200150:	0b013b83          	ld	s7,176(sp)
  ld x28, 23*8(sp)
ffffffe000200154:	0b813e03          	ld	t3,184(sp)
  ld x25, 24*8(sp)
ffffffe000200158:	0c013c83          	ld	s9,192(sp)
  ld x26, 25*8(sp)
ffffffe00020015c:	0c813d03          	ld	s10,200(sp)
  ld x27, 26*8(sp)
ffffffe000200160:	0d013d83          	ld	s11,208(sp)
  ld x28, 27*8(sp)
ffffffe000200164:	0d813e03          	ld	t3,216(sp)
  ld x29, 28*8(sp)
ffffffe000200168:	0e013e83          	ld	t4,224(sp)
  ld x30, 29*8(sp)
ffffffe00020016c:	0e813f03          	ld	t5,232(sp)
  ld x31, 30*8(sp)
ffffffe000200170:	0f013f83          	ld	t6,240(sp)
  addi sp, sp, 32*8
ffffffe000200174:	10010113          	addi	sp,sp,256

  # -----------
  # 4. return from trap
  sret
ffffffe000200178:	10200073          	sret

ffffffe00020017c <__dummy>:


  .global __dummy
__dummy:
// 设置 sepc 为 dummy() 的地址
  la t0, dummy
ffffffe00020017c:	00003297          	auipc	t0,0x3
ffffffe000200180:	ea42b283          	ld	t0,-348(t0) # ffffffe000203020 <_GLOBAL_OFFSET_TABLE_+0x18>
  csrw sepc, t0
ffffffe000200184:	14129073          	csrw	sepc,t0

  sret
ffffffe000200188:	10200073          	sret

ffffffe00020018c <__switch_to>:
__switch_to:

  // save state to prev process
  // a0: prev
  // a1: next
  sd ra, 40+0(a0)
ffffffe00020018c:	02153423          	sd	ra,40(a0)
  sd sp, 40+8(a0)
ffffffe000200190:	02253823          	sd	sp,48(a0)
  sd s0, 40+16(a0)
ffffffe000200194:	02853c23          	sd	s0,56(a0)
  sd s1, 40+24(a0)
ffffffe000200198:	04953023          	sd	s1,64(a0)
  sd s2, 40+32(a0)
ffffffe00020019c:	05253423          	sd	s2,72(a0)
  sd s3, 40+40(a0)
ffffffe0002001a0:	05353823          	sd	s3,80(a0)
  sd s4, 40+48(a0)
ffffffe0002001a4:	05453c23          	sd	s4,88(a0)
  sd s5, 40+56(a0)
ffffffe0002001a8:	07553023          	sd	s5,96(a0)
  sd s6, 40+64(a0)
ffffffe0002001ac:	07653423          	sd	s6,104(a0)
  sd s7, 40+72(a0)
ffffffe0002001b0:	07753823          	sd	s7,112(a0)
  sd s8, 40+80(a0)
ffffffe0002001b4:	07853c23          	sd	s8,120(a0)
  sd s9, 40+88(a0)
ffffffe0002001b8:	09953023          	sd	s9,128(a0)
  sd s10,40+96(a0)
ffffffe0002001bc:	09a53423          	sd	s10,136(a0)
  sd s11,40+104(a0)
ffffffe0002001c0:	09b53823          	sd	s11,144(a0)

  // restore state from next process
  ld ra, 40+0(a1)
ffffffe0002001c4:	0285b083          	ld	ra,40(a1)
  ld sp, 40+8(a1)
ffffffe0002001c8:	0305b103          	ld	sp,48(a1)
  ld s0, 40+16(a1)
ffffffe0002001cc:	0385b403          	ld	s0,56(a1)
  ld s1, 40+24(a1)
ffffffe0002001d0:	0405b483          	ld	s1,64(a1)
  ld s2, 40+32(a1)
ffffffe0002001d4:	0485b903          	ld	s2,72(a1)
  ld s3, 40+40(a1)
ffffffe0002001d8:	0505b983          	ld	s3,80(a1)
  ld s4, 40+48(a1)
ffffffe0002001dc:	0585ba03          	ld	s4,88(a1)
  ld s5, 40+56(a1)
ffffffe0002001e0:	0605ba83          	ld	s5,96(a1)
  ld s6, 40+64(a1)
ffffffe0002001e4:	0685bb03          	ld	s6,104(a1)
  ld s7, 40+72(a1)
ffffffe0002001e8:	0705bb83          	ld	s7,112(a1)
  ld s8, 40+80(a1)
ffffffe0002001ec:	0785bc03          	ld	s8,120(a1)
  ld s9, 40+88(a1)
ffffffe0002001f0:	0805bc83          	ld	s9,128(a1)
  ld s10,40+96(a1)
ffffffe0002001f4:	0885bd03          	ld	s10,136(a1)
  ld s11,40+104(a1)
ffffffe0002001f8:	0905bd83          	ld	s11,144(a1)

  jalr x0, ra, 0
ffffffe0002001fc:	00008067          	ret

ffffffe000200200 <get_cycles>:
#include"sbi.h"
#include"clock.h"

unsigned long TIMECLOCK = 10000000;

unsigned long get_cycles() {
ffffffe000200200:	fe010113          	addi	sp,sp,-32
ffffffe000200204:	00813c23          	sd	s0,24(sp)
ffffffe000200208:	02010413          	addi	s0,sp,32
  // 使用 rdtime 编写内联汇编，获取 time 寄存器中（也就是 mtime 寄存器）的值，并返回
  unsigned long cycles;
  asm volatile("rdtime %0" : "=r"(cycles));
ffffffe00020020c:	c01027f3          	rdtime	a5
ffffffe000200210:	fef43423          	sd	a5,-24(s0)
  return cycles;
ffffffe000200214:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200218:	00078513          	mv	a0,a5
ffffffe00020021c:	01813403          	ld	s0,24(sp)
ffffffe000200220:	02010113          	addi	sp,sp,32
ffffffe000200224:	00008067          	ret

ffffffe000200228 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200228:	fe010113          	addi	sp,sp,-32
ffffffe00020022c:	00113c23          	sd	ra,24(sp)
ffffffe000200230:	00813823          	sd	s0,16(sp)
ffffffe000200234:	02010413          	addi	s0,sp,32
  // 下一次时钟中断的时间点
  unsigned long next = get_cycles() + TIMECLOCK;
ffffffe000200238:	fc9ff0ef          	jal	ra,ffffffe000200200 <get_cycles>
ffffffe00020023c:	00050713          	mv	a4,a0
ffffffe000200240:	00003797          	auipc	a5,0x3
ffffffe000200244:	dc078793          	addi	a5,a5,-576 # ffffffe000203000 <TIMECLOCK>
ffffffe000200248:	0007b783          	ld	a5,0(a5)
ffffffe00020024c:	00f707b3          	add	a5,a4,a5
ffffffe000200250:	fef43423          	sd	a5,-24(s0)

  // 使用 sbi_ecall 来完成对下一次时钟中断的设置
  sbi_ecall(SBI_SET_TIMER,0, next, 0, 0, 0, 0, 0);
ffffffe000200254:	00000893          	li	a7,0
ffffffe000200258:	00000813          	li	a6,0
ffffffe00020025c:	00000793          	li	a5,0
ffffffe000200260:	00000713          	li	a4,0
ffffffe000200264:	00000693          	li	a3,0
ffffffe000200268:	fe843603          	ld	a2,-24(s0)
ffffffe00020026c:	00000593          	li	a1,0
ffffffe000200270:	00000513          	li	a0,0
ffffffe000200274:	788000ef          	jal	ra,ffffffe0002009fc <sbi_ecall>
  return;
ffffffe000200278:	00000013          	nop
ffffffe00020027c:	01813083          	ld	ra,24(sp)
ffffffe000200280:	01013403          	ld	s0,16(sp)
ffffffe000200284:	02010113          	addi	sp,sp,32
ffffffe000200288:	00008067          	ret

ffffffe00020028c <kalloc>:

struct {
    struct run *freelist;
} kmem;

uint64 kalloc() {
ffffffe00020028c:	fe010113          	addi	sp,sp,-32
ffffffe000200290:	00113c23          	sd	ra,24(sp)
ffffffe000200294:	00813823          	sd	s0,16(sp)
ffffffe000200298:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
ffffffe00020029c:	00004797          	auipc	a5,0x4
ffffffe0002002a0:	d6478793          	addi	a5,a5,-668 # ffffffe000204000 <kmem>
ffffffe0002002a4:	0007b783          	ld	a5,0(a5)
ffffffe0002002a8:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;  // 将 r 移动到下一个位置
ffffffe0002002ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002002b0:	0007b703          	ld	a4,0(a5)
ffffffe0002002b4:	00004797          	auipc	a5,0x4
ffffffe0002002b8:	d4c78793          	addi	a5,a5,-692 # ffffffe000204000 <kmem>
ffffffe0002002bc:	00e7b023          	sd	a4,0(a5)
    
    memset((void *)r, 0x0, PGSIZE);   // 将 r 指向的内存后 PGSIZE 个字节置为 0
ffffffe0002002c0:	00001637          	lui	a2,0x1
ffffffe0002002c4:	00000593          	li	a1,0
ffffffe0002002c8:	fe843503          	ld	a0,-24(s0)
ffffffe0002002cc:	2a4010ef          	jal	ra,ffffffe000201570 <memset>
    return (uint64) r; // 返回分配地址的指针
ffffffe0002002d0:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002d4:	00078513          	mv	a0,a5
ffffffe0002002d8:	01813083          	ld	ra,24(sp)
ffffffe0002002dc:	01013403          	ld	s0,16(sp)
ffffffe0002002e0:	02010113          	addi	sp,sp,32
ffffffe0002002e4:	00008067          	ret

ffffffe0002002e8 <kfree>:

void kfree(uint64 addr) {
ffffffe0002002e8:	fd010113          	addi	sp,sp,-48
ffffffe0002002ec:	02113423          	sd	ra,40(sp)
ffffffe0002002f0:	02813023          	sd	s0,32(sp)
ffffffe0002002f4:	03010413          	addi	s0,sp,48
ffffffe0002002f8:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    addr = addr & ~(PGSIZE - 1);
ffffffe0002002fc:	fd843703          	ld	a4,-40(s0)
ffffffe000200300:	fffff7b7          	lui	a5,0xfffff
ffffffe000200304:	00f777b3          	and	a5,a4,a5
ffffffe000200308:	fcf43c23          	sd	a5,-40(s0)

    memset((void *)addr, 0x0, (uint64)PGSIZE);
ffffffe00020030c:	fd843783          	ld	a5,-40(s0)
ffffffe000200310:	00001637          	lui	a2,0x1
ffffffe000200314:	00000593          	li	a1,0
ffffffe000200318:	00078513          	mv	a0,a5
ffffffe00020031c:	254010ef          	jal	ra,ffffffe000201570 <memset>

    r = (struct run *)addr;
ffffffe000200320:	fd843783          	ld	a5,-40(s0)
ffffffe000200324:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
ffffffe000200328:	00004797          	auipc	a5,0x4
ffffffe00020032c:	cd878793          	addi	a5,a5,-808 # ffffffe000204000 <kmem>
ffffffe000200330:	0007b703          	ld	a4,0(a5)
ffffffe000200334:	fe843783          	ld	a5,-24(s0)
ffffffe000200338:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
ffffffe00020033c:	00004797          	auipc	a5,0x4
ffffffe000200340:	cc478793          	addi	a5,a5,-828 # ffffffe000204000 <kmem>
ffffffe000200344:	fe843703          	ld	a4,-24(s0)
ffffffe000200348:	00e7b023          	sd	a4,0(a5)

    return ;
ffffffe00020034c:	00000013          	nop
}
ffffffe000200350:	02813083          	ld	ra,40(sp)
ffffffe000200354:	02013403          	ld	s0,32(sp)
ffffffe000200358:	03010113          	addi	sp,sp,48
ffffffe00020035c:	00008067          	ret

ffffffe000200360 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200360:	fd010113          	addi	sp,sp,-48
ffffffe000200364:	02113423          	sd	ra,40(sp)
ffffffe000200368:	02813023          	sd	s0,32(sp)
ffffffe00020036c:	03010413          	addi	s0,sp,48
ffffffe000200370:	fca43c23          	sd	a0,-40(s0)
ffffffe000200374:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uint64)start);
ffffffe000200378:	fd843703          	ld	a4,-40(s0)
ffffffe00020037c:	000017b7          	lui	a5,0x1
ffffffe000200380:	fff78793          	addi	a5,a5,-1 # fff <_start-0xffffffe0001ff001>
ffffffe000200384:	00f70733          	add	a4,a4,a5
ffffffe000200388:	fffff7b7          	lui	a5,0xfffff
ffffffe00020038c:	00f777b3          	and	a5,a4,a5
ffffffe000200390:	fef43423          	sd	a5,-24(s0)
    for (; (uint64)(addr) + PGSIZE <= (uint64)end; addr += PGSIZE) {
ffffffe000200394:	0200006f          	j	ffffffe0002003b4 <kfreerange+0x54>
        kfree((uint64)addr);
ffffffe000200398:	fe843783          	ld	a5,-24(s0)
ffffffe00020039c:	00078513          	mv	a0,a5
ffffffe0002003a0:	f49ff0ef          	jal	ra,ffffffe0002002e8 <kfree>
    for (; (uint64)(addr) + PGSIZE <= (uint64)end; addr += PGSIZE) {
ffffffe0002003a4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003a8:	000017b7          	lui	a5,0x1
ffffffe0002003ac:	00f707b3          	add	a5,a4,a5
ffffffe0002003b0:	fef43423          	sd	a5,-24(s0)
ffffffe0002003b4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003b8:	000017b7          	lui	a5,0x1
ffffffe0002003bc:	00f70733          	add	a4,a4,a5
ffffffe0002003c0:	fd043783          	ld	a5,-48(s0)
ffffffe0002003c4:	fce7fae3          	bgeu	a5,a4,ffffffe000200398 <kfreerange+0x38>
    }
}
ffffffe0002003c8:	00000013          	nop
ffffffe0002003cc:	00000013          	nop
ffffffe0002003d0:	02813083          	ld	ra,40(sp)
ffffffe0002003d4:	02013403          	ld	s0,32(sp)
ffffffe0002003d8:	03010113          	addi	sp,sp,48
ffffffe0002003dc:	00008067          	ret

ffffffe0002003e0 <mm_init>:

void mm_init(void) {
ffffffe0002003e0:	ff010113          	addi	sp,sp,-16
ffffffe0002003e4:	00113423          	sd	ra,8(sp)
ffffffe0002003e8:	00813023          	sd	s0,0(sp)
ffffffe0002003ec:	01010413          	addi	s0,sp,16
    kfreerange(_end, (char *)PHY_END);
ffffffe0002003f0:	01100793          	li	a5,17
ffffffe0002003f4:	01b79593          	slli	a1,a5,0x1b
ffffffe0002003f8:	00003517          	auipc	a0,0x3
ffffffe0002003fc:	c3053503          	ld	a0,-976(a0) # ffffffe000203028 <_GLOBAL_OFFSET_TABLE_+0x20>
ffffffe000200400:	f61ff0ef          	jal	ra,ffffffe000200360 <kfreerange>
    printk("...mm_init done!\n");
ffffffe000200404:	00002517          	auipc	a0,0x2
ffffffe000200408:	bfc50513          	addi	a0,a0,-1028 # ffffffe000202000 <_srodata>
ffffffe00020040c:	5e5000ef          	jal	ra,ffffffe0002011f0 <printk>
}
ffffffe000200410:	00000013          	nop
ffffffe000200414:	00813083          	ld	ra,8(sp)
ffffffe000200418:	00013403          	ld	s0,0(sp)
ffffffe00020041c:	01010113          	addi	sp,sp,16
ffffffe000200420:	00008067          	ret

ffffffe000200424 <task_init>:

struct task_struct* idle;           // idle process
struct task_struct* current;        // 指向当前运行线程的 `task_struct`
struct task_struct* task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
ffffffe000200424:	fd010113          	addi	sp,sp,-48
ffffffe000200428:	02113423          	sd	ra,40(sp)
ffffffe00020042c:	02813023          	sd	s0,32(sp)
ffffffe000200430:	03010413          	addi	s0,sp,48
  // 1. 调用 kalloc() 为 idle 分配一个物理页
  uint64 idle_page = kalloc();
ffffffe000200434:	e59ff0ef          	jal	ra,ffffffe00020028c <kalloc>
ffffffe000200438:	fea43023          	sd	a0,-32(s0)
  // 2. 设置 state 为 TASK_RUNNING;
  idle = (struct task_struct *)idle_page;
ffffffe00020043c:	fe043703          	ld	a4,-32(s0)
ffffffe000200440:	00004797          	auipc	a5,0x4
ffffffe000200444:	bc878793          	addi	a5,a5,-1080 # ffffffe000204008 <idle>
ffffffe000200448:	00e7b023          	sd	a4,0(a5)
  idle->state = TASK_RUNNING;
ffffffe00020044c:	00004797          	auipc	a5,0x4
ffffffe000200450:	bbc78793          	addi	a5,a5,-1092 # ffffffe000204008 <idle>
ffffffe000200454:	0007b783          	ld	a5,0(a5)
ffffffe000200458:	0007b423          	sd	zero,8(a5)
  // 3. 由于 idle 不参与调度 可以将其 counter / priority 设置为 0
  idle->counter = 0;
ffffffe00020045c:	00004797          	auipc	a5,0x4
ffffffe000200460:	bac78793          	addi	a5,a5,-1108 # ffffffe000204008 <idle>
ffffffe000200464:	0007b783          	ld	a5,0(a5)
ffffffe000200468:	0007b823          	sd	zero,16(a5)
  idle->priority = 0;
ffffffe00020046c:	00004797          	auipc	a5,0x4
ffffffe000200470:	b9c78793          	addi	a5,a5,-1124 # ffffffe000204008 <idle>
ffffffe000200474:	0007b783          	ld	a5,0(a5)
ffffffe000200478:	0007bc23          	sd	zero,24(a5)
  // 4. 设置 idle 的 pid 为 0
  idle->pid = 0;
ffffffe00020047c:	00004797          	auipc	a5,0x4
ffffffe000200480:	b8c78793          	addi	a5,a5,-1140 # ffffffe000204008 <idle>
ffffffe000200484:	0007b783          	ld	a5,0(a5)
ffffffe000200488:	0207b023          	sd	zero,32(a5)
  // 5. 将 current 和 task[0] 指向 idle
  current = idle;
ffffffe00020048c:	00004797          	auipc	a5,0x4
ffffffe000200490:	b7c78793          	addi	a5,a5,-1156 # ffffffe000204008 <idle>
ffffffe000200494:	0007b703          	ld	a4,0(a5)
ffffffe000200498:	00004797          	auipc	a5,0x4
ffffffe00020049c:	b7878793          	addi	a5,a5,-1160 # ffffffe000204010 <current>
ffffffe0002004a0:	00e7b023          	sd	a4,0(a5)
  task[0] = idle;
ffffffe0002004a4:	00004797          	auipc	a5,0x4
ffffffe0002004a8:	b6478793          	addi	a5,a5,-1180 # ffffffe000204008 <idle>
ffffffe0002004ac:	0007b703          	ld	a4,0(a5)
ffffffe0002004b0:	00004797          	auipc	a5,0x4
ffffffe0002004b4:	b6878793          	addi	a5,a5,-1176 # ffffffe000204018 <task>
ffffffe0002004b8:	00e7b023          	sd	a4,0(a5)

  // 1. 参考 idle 的设置, 为 task[1] ~ task[NR_TASKS - 1] 进行初始化
  // 2. 其中每个线程的 state 为 TASK_RUNNING, counter 为 0, priority 使用 rand() 来设置, pid 为该线程在线程数组中的下标。
  // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 `thread_struct` 中的 `ra` 和 `sp`, 
  // 4. 其中 `ra` 设置为 __dummy （见 4.3.2）的地址， `sp` 设置为 该线程申请的物理页的高地址
  for(int i = 1; i < NR_TASKS; ++i) {
ffffffe0002004bc:	00100793          	li	a5,1
ffffffe0002004c0:	fef42623          	sw	a5,-20(s0)
ffffffe0002004c4:	0d80006f          	j	ffffffe00020059c <task_init+0x178>
    // 设置 task、state、counter、priority、pid
    uint64 task_page = kalloc();
ffffffe0002004c8:	dc5ff0ef          	jal	ra,ffffffe00020028c <kalloc>
ffffffe0002004cc:	fca43c23          	sd	a0,-40(s0)
    task[i] = (struct task_struct *)task_page;
ffffffe0002004d0:	fd843703          	ld	a4,-40(s0)
ffffffe0002004d4:	00004697          	auipc	a3,0x4
ffffffe0002004d8:	b4468693          	addi	a3,a3,-1212 # ffffffe000204018 <task>
ffffffe0002004dc:	fec42783          	lw	a5,-20(s0)
ffffffe0002004e0:	00379793          	slli	a5,a5,0x3
ffffffe0002004e4:	00f687b3          	add	a5,a3,a5
ffffffe0002004e8:	00e7b023          	sd	a4,0(a5)
    task[i]->state = TASK_RUNNING;
ffffffe0002004ec:	00004717          	auipc	a4,0x4
ffffffe0002004f0:	b2c70713          	addi	a4,a4,-1236 # ffffffe000204018 <task>
ffffffe0002004f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002004f8:	00379793          	slli	a5,a5,0x3
ffffffe0002004fc:	00f707b3          	add	a5,a4,a5
ffffffe000200500:	0007b783          	ld	a5,0(a5)
ffffffe000200504:	0007b423          	sd	zero,8(a5)
    task[i]->counter = 0;
ffffffe000200508:	00004717          	auipc	a4,0x4
ffffffe00020050c:	b1070713          	addi	a4,a4,-1264 # ffffffe000204018 <task>
ffffffe000200510:	fec42783          	lw	a5,-20(s0)
ffffffe000200514:	00379793          	slli	a5,a5,0x3
ffffffe000200518:	00f707b3          	add	a5,a4,a5
ffffffe00020051c:	0007b783          	ld	a5,0(a5)
ffffffe000200520:	0007b823          	sd	zero,16(a5)
    // task[i]->priority = rand();
    task[i]->pid = i;
ffffffe000200524:	00004717          	auipc	a4,0x4
ffffffe000200528:	af470713          	addi	a4,a4,-1292 # ffffffe000204018 <task>
ffffffe00020052c:	fec42783          	lw	a5,-20(s0)
ffffffe000200530:	00379793          	slli	a5,a5,0x3
ffffffe000200534:	00f707b3          	add	a5,a4,a5
ffffffe000200538:	0007b783          	ld	a5,0(a5)
ffffffe00020053c:	fec42703          	lw	a4,-20(s0)
ffffffe000200540:	02e7b023          	sd	a4,32(a5)
    // 设置 ra 和 sp
    task[i]->thread.ra = (uint64)__dummy;
ffffffe000200544:	00004717          	auipc	a4,0x4
ffffffe000200548:	ad470713          	addi	a4,a4,-1324 # ffffffe000204018 <task>
ffffffe00020054c:	fec42783          	lw	a5,-20(s0)
ffffffe000200550:	00379793          	slli	a5,a5,0x3
ffffffe000200554:	00f707b3          	add	a5,a4,a5
ffffffe000200558:	0007b783          	ld	a5,0(a5)
ffffffe00020055c:	00003717          	auipc	a4,0x3
ffffffe000200560:	ab473703          	ld	a4,-1356(a4) # ffffffe000203010 <_GLOBAL_OFFSET_TABLE_+0x8>
ffffffe000200564:	02e7b423          	sd	a4,40(a5)
    task[i]->thread.sp = task_page + PGSIZE;
ffffffe000200568:	00004717          	auipc	a4,0x4
ffffffe00020056c:	ab070713          	addi	a4,a4,-1360 # ffffffe000204018 <task>
ffffffe000200570:	fec42783          	lw	a5,-20(s0)
ffffffe000200574:	00379793          	slli	a5,a5,0x3
ffffffe000200578:	00f707b3          	add	a5,a4,a5
ffffffe00020057c:	0007b783          	ld	a5,0(a5)
ffffffe000200580:	fd843683          	ld	a3,-40(s0)
ffffffe000200584:	00001737          	lui	a4,0x1
ffffffe000200588:	00e68733          	add	a4,a3,a4
ffffffe00020058c:	02e7b823          	sd	a4,48(a5)
  for(int i = 1; i < NR_TASKS; ++i) {
ffffffe000200590:	fec42783          	lw	a5,-20(s0)
ffffffe000200594:	0017879b          	addiw	a5,a5,1
ffffffe000200598:	fef42623          	sw	a5,-20(s0)
ffffffe00020059c:	fec42783          	lw	a5,-20(s0)
ffffffe0002005a0:	0007871b          	sext.w	a4,a5
ffffffe0002005a4:	00300793          	li	a5,3
ffffffe0002005a8:	f2e7d0e3          	bge	a5,a4,ffffffe0002004c8 <task_init+0xa4>
  }
  task[1] -> priority = 1;
ffffffe0002005ac:	00004797          	auipc	a5,0x4
ffffffe0002005b0:	a6c78793          	addi	a5,a5,-1428 # ffffffe000204018 <task>
ffffffe0002005b4:	0087b783          	ld	a5,8(a5)
ffffffe0002005b8:	00100713          	li	a4,1
ffffffe0002005bc:	00e7bc23          	sd	a4,24(a5)
  task[2] -> priority = 4;
ffffffe0002005c0:	00004797          	auipc	a5,0x4
ffffffe0002005c4:	a5878793          	addi	a5,a5,-1448 # ffffffe000204018 <task>
ffffffe0002005c8:	0107b783          	ld	a5,16(a5)
ffffffe0002005cc:	00400713          	li	a4,4
ffffffe0002005d0:	00e7bc23          	sd	a4,24(a5)
  task[3] -> priority = 5;
ffffffe0002005d4:	00004797          	auipc	a5,0x4
ffffffe0002005d8:	a4478793          	addi	a5,a5,-1468 # ffffffe000204018 <task>
ffffffe0002005dc:	0187b783          	ld	a5,24(a5)
ffffffe0002005e0:	00500713          	li	a4,5
ffffffe0002005e4:	00e7bc23          	sd	a4,24(a5)

  printk("...proc_init done!\n");
ffffffe0002005e8:	00002517          	auipc	a0,0x2
ffffffe0002005ec:	a3050513          	addi	a0,a0,-1488 # ffffffe000202018 <_srodata+0x18>
ffffffe0002005f0:	401000ef          	jal	ra,ffffffe0002011f0 <printk>
  return;
ffffffe0002005f4:	00000013          	nop
}
ffffffe0002005f8:	02813083          	ld	ra,40(sp)
ffffffe0002005fc:	02013403          	ld	s0,32(sp)
ffffffe000200600:	03010113          	addi	sp,sp,48
ffffffe000200604:	00008067          	ret

ffffffe000200608 <dummy>:


void dummy() {
ffffffe000200608:	fd010113          	addi	sp,sp,-48
ffffffe00020060c:	02113423          	sd	ra,40(sp)
ffffffe000200610:	02813023          	sd	s0,32(sp)
ffffffe000200614:	03010413          	addi	s0,sp,48
  uint64 MOD = 1000000007;
ffffffe000200618:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe00020061c:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_start-0xffffffdfc48535f9>
ffffffe000200620:	fcf43c23          	sd	a5,-40(s0)
  uint64 auto_inc_local_var = 0;
ffffffe000200624:	fe043423          	sd	zero,-24(s0)
  int last_counter = -1; // 记录上一个counter
ffffffe000200628:	fff00793          	li	a5,-1
ffffffe00020062c:	fef42223          	sw	a5,-28(s0)
  int last_last_counter = -1; // 记录上上个counter
ffffffe000200630:	fff00793          	li	a5,-1
ffffffe000200634:	fef42023          	sw	a5,-32(s0)
  while(1) {
    if (last_counter == -1 || current->counter != last_counter) {
ffffffe000200638:	fe442783          	lw	a5,-28(s0)
ffffffe00020063c:	0007871b          	sext.w	a4,a5
ffffffe000200640:	fff00793          	li	a5,-1
ffffffe000200644:	00f70e63          	beq	a4,a5,ffffffe000200660 <dummy+0x58>
ffffffe000200648:	00004797          	auipc	a5,0x4
ffffffe00020064c:	9c878793          	addi	a5,a5,-1592 # ffffffe000204010 <current>
ffffffe000200650:	0007b783          	ld	a5,0(a5)
ffffffe000200654:	0107b703          	ld	a4,16(a5)
ffffffe000200658:	fe442783          	lw	a5,-28(s0)
ffffffe00020065c:	04f70e63          	beq	a4,a5,ffffffe0002006b8 <dummy+0xb0>
        last_last_counter = last_counter;
ffffffe000200660:	fe442783          	lw	a5,-28(s0)
ffffffe000200664:	fef42023          	sw	a5,-32(s0)
        last_counter = current->counter;
ffffffe000200668:	00004797          	auipc	a5,0x4
ffffffe00020066c:	9a878793          	addi	a5,a5,-1624 # ffffffe000204010 <current>
ffffffe000200670:	0007b783          	ld	a5,0(a5)
ffffffe000200674:	0107b783          	ld	a5,16(a5)
ffffffe000200678:	fef42223          	sw	a5,-28(s0)
        auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe00020067c:	fe843783          	ld	a5,-24(s0)
ffffffe000200680:	00178713          	addi	a4,a5,1
ffffffe000200684:	fd843783          	ld	a5,-40(s0)
ffffffe000200688:	02f777b3          	remu	a5,a4,a5
ffffffe00020068c:	fef43423          	sd	a5,-24(s0)
        printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var); 
ffffffe000200690:	00004797          	auipc	a5,0x4
ffffffe000200694:	98078793          	addi	a5,a5,-1664 # ffffffe000204010 <current>
ffffffe000200698:	0007b783          	ld	a5,0(a5)
ffffffe00020069c:	0207b783          	ld	a5,32(a5)
ffffffe0002006a0:	fe843603          	ld	a2,-24(s0)
ffffffe0002006a4:	00078593          	mv	a1,a5
ffffffe0002006a8:	00002517          	auipc	a0,0x2
ffffffe0002006ac:	98850513          	addi	a0,a0,-1656 # ffffffe000202030 <_srodata+0x30>
ffffffe0002006b0:	341000ef          	jal	ra,ffffffe0002011f0 <printk>
ffffffe0002006b4:	0440006f          	j	ffffffe0002006f8 <dummy+0xf0>
    } else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
ffffffe0002006b8:	fe042783          	lw	a5,-32(s0)
ffffffe0002006bc:	0007879b          	sext.w	a5,a5
ffffffe0002006c0:	00078a63          	beqz	a5,ffffffe0002006d4 <dummy+0xcc>
ffffffe0002006c4:	fe042783          	lw	a5,-32(s0)
ffffffe0002006c8:	0007871b          	sext.w	a4,a5
ffffffe0002006cc:	fff00793          	li	a5,-1
ffffffe0002006d0:	f6f714e3          	bne	a4,a5,ffffffe000200638 <dummy+0x30>
ffffffe0002006d4:	fe442783          	lw	a5,-28(s0)
ffffffe0002006d8:	0007871b          	sext.w	a4,a5
ffffffe0002006dc:	00100793          	li	a5,1
ffffffe0002006e0:	f4f71ce3          	bne	a4,a5,ffffffe000200638 <dummy+0x30>
        // 这里比较 tricky，不要求理解。
        last_counter = 0; 
ffffffe0002006e4:	fe042223          	sw	zero,-28(s0)
        current->counter = 0;
ffffffe0002006e8:	00004797          	auipc	a5,0x4
ffffffe0002006ec:	92878793          	addi	a5,a5,-1752 # ffffffe000204010 <current>
ffffffe0002006f0:	0007b783          	ld	a5,0(a5)
ffffffe0002006f4:	0007b823          	sd	zero,16(a5)
    if (last_counter == -1 || current->counter != last_counter) {
ffffffe0002006f8:	f41ff06f          	j	ffffffe000200638 <dummy+0x30>

ffffffe0002006fc <switch_to>:
    }
  }
  return;
}

void switch_to(struct task_struct *next){
ffffffe0002006fc:	fd010113          	addi	sp,sp,-48
ffffffe000200700:	02113423          	sd	ra,40(sp)
ffffffe000200704:	02813023          	sd	s0,32(sp)
ffffffe000200708:	03010413          	addi	s0,sp,48
ffffffe00020070c:	fca43c23          	sd	a0,-40(s0)
  // 和 current 比较，如果相同则无需处理
  if (current == next) {
ffffffe000200710:	00004797          	auipc	a5,0x4
ffffffe000200714:	90078793          	addi	a5,a5,-1792 # ffffffe000204010 <current>
ffffffe000200718:	0007b783          	ld	a5,0(a5)
ffffffe00020071c:	fd843703          	ld	a4,-40(s0)
ffffffe000200720:	0af70a63          	beq	a4,a5,ffffffe0002007d4 <switch_to+0xd8>
    return;
  }
  // 否则进行切换
  struct task_struct *prev = current;
ffffffe000200724:	00004797          	auipc	a5,0x4
ffffffe000200728:	8ec78793          	addi	a5,a5,-1812 # ffffffe000204010 <current>
ffffffe00020072c:	0007b783          	ld	a5,0(a5)
ffffffe000200730:	fef43423          	sd	a5,-24(s0)
  current = next;
ffffffe000200734:	00004797          	auipc	a5,0x4
ffffffe000200738:	8dc78793          	addi	a5,a5,-1828 # ffffffe000204010 <current>
ffffffe00020073c:	fd843703          	ld	a4,-40(s0)
ffffffe000200740:	00e7b023          	sd	a4,0(a5)
  printk("switch to [PID = %d, PRIORITY = %d, COUNTER = %d]\n", current->pid, current->priority, current->counter);
ffffffe000200744:	00004797          	auipc	a5,0x4
ffffffe000200748:	8cc78793          	addi	a5,a5,-1844 # ffffffe000204010 <current>
ffffffe00020074c:	0007b783          	ld	a5,0(a5)
ffffffe000200750:	0207b703          	ld	a4,32(a5)
ffffffe000200754:	00004797          	auipc	a5,0x4
ffffffe000200758:	8bc78793          	addi	a5,a5,-1860 # ffffffe000204010 <current>
ffffffe00020075c:	0007b783          	ld	a5,0(a5)
ffffffe000200760:	0187b603          	ld	a2,24(a5)
ffffffe000200764:	00004797          	auipc	a5,0x4
ffffffe000200768:	8ac78793          	addi	a5,a5,-1876 # ffffffe000204010 <current>
ffffffe00020076c:	0007b783          	ld	a5,0(a5)
ffffffe000200770:	0107b783          	ld	a5,16(a5)
ffffffe000200774:	00078693          	mv	a3,a5
ffffffe000200778:	00070593          	mv	a1,a4
ffffffe00020077c:	00002517          	auipc	a0,0x2
ffffffe000200780:	8e450513          	addi	a0,a0,-1820 # ffffffe000202060 <_srodata+0x60>
ffffffe000200784:	26d000ef          	jal	ra,ffffffe0002011f0 <printk>
  // 一些 sao 操作，卡一下边界，否则可能多输出或少输出一些东西
  if(current -> counter != 1){
ffffffe000200788:	00004797          	auipc	a5,0x4
ffffffe00020078c:	88878793          	addi	a5,a5,-1912 # ffffffe000204010 <current>
ffffffe000200790:	0007b783          	ld	a5,0(a5)
ffffffe000200794:	0107b703          	ld	a4,16(a5)
ffffffe000200798:	00100793          	li	a5,1
ffffffe00020079c:	02f70463          	beq	a4,a5,ffffffe0002007c4 <switch_to+0xc8>
    current -> counter = current -> counter - 1;
ffffffe0002007a0:	00004797          	auipc	a5,0x4
ffffffe0002007a4:	87078793          	addi	a5,a5,-1936 # ffffffe000204010 <current>
ffffffe0002007a8:	0007b783          	ld	a5,0(a5)
ffffffe0002007ac:	0107b703          	ld	a4,16(a5)
ffffffe0002007b0:	00004797          	auipc	a5,0x4
ffffffe0002007b4:	86078793          	addi	a5,a5,-1952 # ffffffe000204010 <current>
ffffffe0002007b8:	0007b783          	ld	a5,0(a5)
ffffffe0002007bc:	fff70713          	addi	a4,a4,-1 # fff <_start-0xffffffe0001ff001>
ffffffe0002007c0:	00e7b823          	sd	a4,16(a5)
  }
  __switch_to(prev, next);
ffffffe0002007c4:	fd843583          	ld	a1,-40(s0)
ffffffe0002007c8:	fe843503          	ld	a0,-24(s0)
ffffffe0002007cc:	9c1ff0ef          	jal	ra,ffffffe00020018c <__switch_to>
  return;
ffffffe0002007d0:	0080006f          	j	ffffffe0002007d8 <switch_to+0xdc>
    return;
ffffffe0002007d4:	00000013          	nop
}
ffffffe0002007d8:	02813083          	ld	ra,40(sp)
ffffffe0002007dc:	02013403          	ld	s0,32(sp)
ffffffe0002007e0:	03010113          	addi	sp,sp,48
ffffffe0002007e4:	00008067          	ret

ffffffe0002007e8 <do_timer>:

void do_timer(){
ffffffe0002007e8:	fe010113          	addi	sp,sp,-32
ffffffe0002007ec:	00113c23          	sd	ra,24(sp)
ffffffe0002007f0:	00813823          	sd	s0,16(sp)
ffffffe0002007f4:	02010413          	addi	s0,sp,32
  // 将当前进程的 count --，如果结果大于零则直接返回
  int counter = current->counter;
ffffffe0002007f8:	00004797          	auipc	a5,0x4
ffffffe0002007fc:	81878793          	addi	a5,a5,-2024 # ffffffe000204010 <current>
ffffffe000200800:	0007b783          	ld	a5,0(a5)
ffffffe000200804:	0107b783          	ld	a5,16(a5)
ffffffe000200808:	fef42623          	sw	a5,-20(s0)
  if(counter > 0){
ffffffe00020080c:	fec42783          	lw	a5,-20(s0)
ffffffe000200810:	0007879b          	sext.w	a5,a5
ffffffe000200814:	02f05263          	blez	a5,ffffffe000200838 <do_timer+0x50>
    current -> counter = counter - 1;
ffffffe000200818:	fec42783          	lw	a5,-20(s0)
ffffffe00020081c:	fff7879b          	addiw	a5,a5,-1
ffffffe000200820:	0007871b          	sext.w	a4,a5
ffffffe000200824:	00003797          	auipc	a5,0x3
ffffffe000200828:	7ec78793          	addi	a5,a5,2028 # ffffffe000204010 <current>
ffffffe00020082c:	0007b783          	ld	a5,0(a5)
ffffffe000200830:	00e7b823          	sd	a4,16(a5)
    return;
ffffffe000200834:	00c0006f          	j	ffffffe000200840 <do_timer+0x58>
  }
  // 否则进行调度
  schedule();
ffffffe000200838:	018000ef          	jal	ra,ffffffe000200850 <schedule>
  return;
ffffffe00020083c:	00000013          	nop
}
ffffffe000200840:	01813083          	ld	ra,24(sp)
ffffffe000200844:	01013403          	ld	s0,16(sp)
ffffffe000200848:	02010113          	addi	sp,sp,32
ffffffe00020084c:	00008067          	ret

ffffffe000200850 <schedule>:


void schedule(){
ffffffe000200850:	fc010113          	addi	sp,sp,-64
ffffffe000200854:	02113c23          	sd	ra,56(sp)
ffffffe000200858:	02813823          	sd	s0,48(sp)
ffffffe00020085c:	04010413          	addi	s0,sp,64
	int i,next;
  uint64 c;
	struct task_struct ** p;

  while (1) {
		c = UINT_MAX;
ffffffe000200860:	fff00793          	li	a5,-1
ffffffe000200864:	0207d793          	srli	a5,a5,0x20
ffffffe000200868:	fef43023          	sd	a5,-32(s0)
		next = 0;
ffffffe00020086c:	fe042423          	sw	zero,-24(s0)
		i = NR_TASKS;
ffffffe000200870:	00400793          	li	a5,4
ffffffe000200874:	fef42623          	sw	a5,-20(s0)
		p = &task[NR_TASKS];
ffffffe000200878:	00003797          	auipc	a5,0x3
ffffffe00020087c:	7c078793          	addi	a5,a5,1984 # ffffffe000204038 <task+0x20>
ffffffe000200880:	fcf43c23          	sd	a5,-40(s0)
		while (--i) {
ffffffe000200884:	08c0006f          	j	ffffffe000200910 <schedule+0xc0>
      --p;
ffffffe000200888:	fd843783          	ld	a5,-40(s0)
ffffffe00020088c:	ff878793          	addi	a5,a5,-8
ffffffe000200890:	fcf43c23          	sd	a5,-40(s0)
      char one = (*p)->state == TASK_RUNNING;
ffffffe000200894:	fd843783          	ld	a5,-40(s0)
ffffffe000200898:	0007b783          	ld	a5,0(a5)
ffffffe00020089c:	0087b783          	ld	a5,8(a5)
ffffffe0002008a0:	0017b793          	seqz	a5,a5
ffffffe0002008a4:	0ff7f793          	zext.b	a5,a5
ffffffe0002008a8:	fcf40ba3          	sb	a5,-41(s0)
      uint64 counter = (*p) -> counter;
ffffffe0002008ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002008b0:	0007b783          	ld	a5,0(a5)
ffffffe0002008b4:	0107b783          	ld	a5,16(a5)
ffffffe0002008b8:	fcf43423          	sd	a5,-56(s0)
      char two = (counter < c) && (counter != 0);
ffffffe0002008bc:	fc843703          	ld	a4,-56(s0)
ffffffe0002008c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002008c4:	00f77a63          	bgeu	a4,a5,ffffffe0002008d8 <schedule+0x88>
ffffffe0002008c8:	fc843783          	ld	a5,-56(s0)
ffffffe0002008cc:	00078663          	beqz	a5,ffffffe0002008d8 <schedule+0x88>
ffffffe0002008d0:	00100793          	li	a5,1
ffffffe0002008d4:	0080006f          	j	ffffffe0002008dc <schedule+0x8c>
ffffffe0002008d8:	00000793          	li	a5,0
ffffffe0002008dc:	fcf403a3          	sb	a5,-57(s0)
      if(one && two){
ffffffe0002008e0:	fd744783          	lbu	a5,-41(s0)
ffffffe0002008e4:	0ff7f793          	zext.b	a5,a5
ffffffe0002008e8:	02078463          	beqz	a5,ffffffe000200910 <schedule+0xc0>
ffffffe0002008ec:	fc744783          	lbu	a5,-57(s0)
ffffffe0002008f0:	0ff7f793          	zext.b	a5,a5
ffffffe0002008f4:	00078e63          	beqz	a5,ffffffe000200910 <schedule+0xc0>
        c = (*p)->counter;
ffffffe0002008f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002008fc:	0007b783          	ld	a5,0(a5)
ffffffe000200900:	0107b783          	ld	a5,16(a5)
ffffffe000200904:	fef43023          	sd	a5,-32(s0)
        next = i;
ffffffe000200908:	fec42783          	lw	a5,-20(s0)
ffffffe00020090c:	fef42423          	sw	a5,-24(s0)
		while (--i) {
ffffffe000200910:	fec42783          	lw	a5,-20(s0)
ffffffe000200914:	fff7879b          	addiw	a5,a5,-1
ffffffe000200918:	fef42623          	sw	a5,-20(s0)
ffffffe00020091c:	fec42783          	lw	a5,-20(s0)
ffffffe000200920:	0007879b          	sext.w	a5,a5
ffffffe000200924:	f60792e3          	bnez	a5,ffffffe000200888 <schedule+0x38>
      }
		}
		if (c != UINT_MAX) break;
ffffffe000200928:	fe043703          	ld	a4,-32(s0)
ffffffe00020092c:	fff00793          	li	a5,-1
ffffffe000200930:	0207d793          	srli	a5,a5,0x20
ffffffe000200934:	08f71863          	bne	a4,a5,ffffffe0002009c4 <schedule+0x174>
		for(p = (&FIRST_TASK+1) ; p <= &LAST_TASK ; ++p){
ffffffe000200938:	00003797          	auipc	a5,0x3
ffffffe00020093c:	6e878793          	addi	a5,a5,1768 # ffffffe000204020 <task+0x8>
ffffffe000200940:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200944:	0600006f          	j	ffffffe0002009a4 <schedule+0x154>
      printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", (*p)->pid, (*p)->priority, (*p)-> counter);
ffffffe000200948:	fd843783          	ld	a5,-40(s0)
ffffffe00020094c:	0007b783          	ld	a5,0(a5)
ffffffe000200950:	0207b703          	ld	a4,32(a5)
ffffffe000200954:	fd843783          	ld	a5,-40(s0)
ffffffe000200958:	0007b783          	ld	a5,0(a5)
ffffffe00020095c:	0187b603          	ld	a2,24(a5)
ffffffe000200960:	fd843783          	ld	a5,-40(s0)
ffffffe000200964:	0007b783          	ld	a5,0(a5)
ffffffe000200968:	0107b783          	ld	a5,16(a5)
ffffffe00020096c:	00078693          	mv	a3,a5
ffffffe000200970:	00070593          	mv	a1,a4
ffffffe000200974:	00001517          	auipc	a0,0x1
ffffffe000200978:	72450513          	addi	a0,a0,1828 # ffffffe000202098 <_srodata+0x98>
ffffffe00020097c:	075000ef          	jal	ra,ffffffe0002011f0 <printk>

      (*p)->counter = (*p)->priority;
ffffffe000200980:	fd843783          	ld	a5,-40(s0)
ffffffe000200984:	0007b703          	ld	a4,0(a5)
ffffffe000200988:	fd843783          	ld	a5,-40(s0)
ffffffe00020098c:	0007b783          	ld	a5,0(a5)
ffffffe000200990:	01873703          	ld	a4,24(a4)
ffffffe000200994:	00e7b823          	sd	a4,16(a5)
		for(p = (&FIRST_TASK+1) ; p <= &LAST_TASK ; ++p){
ffffffe000200998:	fd843783          	ld	a5,-40(s0)
ffffffe00020099c:	00878793          	addi	a5,a5,8
ffffffe0002009a0:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002009a4:	fd843703          	ld	a4,-40(s0)
ffffffe0002009a8:	00003797          	auipc	a5,0x3
ffffffe0002009ac:	68878793          	addi	a5,a5,1672 # ffffffe000204030 <task+0x18>
ffffffe0002009b0:	f8e7fce3          	bgeu	a5,a4,ffffffe000200948 <schedule+0xf8>
      // (*p)->counter = ((*p)->counter >> 1) + (*p)->priority;
    }
		c = UINT_MAX;
ffffffe0002009b4:	fff00793          	li	a5,-1
ffffffe0002009b8:	0207d793          	srli	a5,a5,0x20
ffffffe0002009bc:	fef43023          	sd	a5,-32(s0)
		c = UINT_MAX;
ffffffe0002009c0:	ea1ff06f          	j	ffffffe000200860 <schedule+0x10>
		if (c != UINT_MAX) break;
ffffffe0002009c4:	00000013          	nop
	}
	switch_to(task[next]);
ffffffe0002009c8:	00003717          	auipc	a4,0x3
ffffffe0002009cc:	65070713          	addi	a4,a4,1616 # ffffffe000204018 <task>
ffffffe0002009d0:	fe842783          	lw	a5,-24(s0)
ffffffe0002009d4:	00379793          	slli	a5,a5,0x3
ffffffe0002009d8:	00f707b3          	add	a5,a4,a5
ffffffe0002009dc:	0007b783          	ld	a5,0(a5)
ffffffe0002009e0:	00078513          	mv	a0,a5
ffffffe0002009e4:	d19ff0ef          	jal	ra,ffffffe0002006fc <switch_to>
  return;
ffffffe0002009e8:	00000013          	nop
}
ffffffe0002009ec:	03813083          	ld	ra,56(sp)
ffffffe0002009f0:	03013403          	ld	s0,48(sp)
ffffffe0002009f4:	04010113          	addi	sp,sp,64
ffffffe0002009f8:	00008067          	ret

ffffffe0002009fc <sbi_ecall>:

struct sbiret sbi_ecall(int ext, int fid, uint64 arg0,
                        uint64 arg1, uint64 arg2,
                        uint64 arg3, uint64 arg4,
                        uint64 arg5)
{
ffffffe0002009fc:	f8010113          	addi	sp,sp,-128
ffffffe000200a00:	06813c23          	sd	s0,120(sp)
ffffffe000200a04:	08010413          	addi	s0,sp,128
ffffffe000200a08:	fac43823          	sd	a2,-80(s0)
ffffffe000200a0c:	fad43423          	sd	a3,-88(s0)
ffffffe000200a10:	fae43023          	sd	a4,-96(s0)
ffffffe000200a14:	f8f43c23          	sd	a5,-104(s0)
ffffffe000200a18:	f9043823          	sd	a6,-112(s0)
ffffffe000200a1c:	f9143423          	sd	a7,-120(s0)
ffffffe000200a20:	00050793          	mv	a5,a0
ffffffe000200a24:	faf42e23          	sw	a5,-68(s0)
ffffffe000200a28:	00058793          	mv	a5,a1
ffffffe000200a2c:	faf42c23          	sw	a5,-72(s0)
  long error;
  long value;
  __asm__ volatile(
ffffffe000200a30:	fbc42783          	lw	a5,-68(s0)
ffffffe000200a34:	00078813          	mv	a6,a5
ffffffe000200a38:	fb842783          	lw	a5,-72(s0)
ffffffe000200a3c:	00078893          	mv	a7,a5
ffffffe000200a40:	fb043783          	ld	a5,-80(s0)
ffffffe000200a44:	fa843703          	ld	a4,-88(s0)
ffffffe000200a48:	fa043683          	ld	a3,-96(s0)
ffffffe000200a4c:	f9843603          	ld	a2,-104(s0)
ffffffe000200a50:	f9043583          	ld	a1,-112(s0)
ffffffe000200a54:	f8843503          	ld	a0,-120(s0)
ffffffe000200a58:	00080893          	mv	a7,a6
ffffffe000200a5c:	00088813          	mv	a6,a7
ffffffe000200a60:	00078513          	mv	a0,a5
ffffffe000200a64:	00070593          	mv	a1,a4
ffffffe000200a68:	00068613          	mv	a2,a3
ffffffe000200a6c:	00060693          	mv	a3,a2
ffffffe000200a70:	00058713          	mv	a4,a1
ffffffe000200a74:	00050793          	mv	a5,a0
ffffffe000200a78:	00000073          	ecall
ffffffe000200a7c:	00050713          	mv	a4,a0
ffffffe000200a80:	00058793          	mv	a5,a1
ffffffe000200a84:	fee43423          	sd	a4,-24(s0)
ffffffe000200a88:	fef43023          	sd	a5,-32(s0)
    "mv %[error], a0\n"
    "mv %[value], a1"
    : [error] "=r" (error),[value] "=r" (value)
    : [ext] "r" (ext), [fid] "r" (fid), [arg0] "r" (arg0), [arg1] "r" (arg1), [arg2] "r" (arg2), [arg3] "r" (arg3), [arg4] "r" (arg4), [arg5] "r" (arg5)
  );
  struct sbiret result = {error, value};
ffffffe000200a8c:	fe843783          	ld	a5,-24(s0)
ffffffe000200a90:	fcf43023          	sd	a5,-64(s0)
ffffffe000200a94:	fe043783          	ld	a5,-32(s0)
ffffffe000200a98:	fcf43423          	sd	a5,-56(s0)
  return result;
ffffffe000200a9c:	fc043783          	ld	a5,-64(s0)
ffffffe000200aa0:	fcf43823          	sd	a5,-48(s0)
ffffffe000200aa4:	fc843783          	ld	a5,-56(s0)
ffffffe000200aa8:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200aac:	fd043703          	ld	a4,-48(s0)
ffffffe000200ab0:	fd843783          	ld	a5,-40(s0)
ffffffe000200ab4:	00070313          	mv	t1,a4
ffffffe000200ab8:	00078393          	mv	t2,a5
ffffffe000200abc:	00030713          	mv	a4,t1
ffffffe000200ac0:	00038793          	mv	a5,t2
}
ffffffe000200ac4:	00070513          	mv	a0,a4
ffffffe000200ac8:	00078593          	mv	a1,a5
ffffffe000200acc:	07813403          	ld	s0,120(sp)
ffffffe000200ad0:	08010113          	addi	sp,sp,128
ffffffe000200ad4:	00008067          	ret

ffffffe000200ad8 <trap_handler>:
// trap.c 
#include"clock.h"
#include"printk.h"

void trap_handler(unsigned long scause, unsigned long sepc) {
ffffffe000200ad8:	fc010113          	addi	sp,sp,-64
ffffffe000200adc:	02113c23          	sd	ra,56(sp)
ffffffe000200ae0:	02813823          	sd	s0,48(sp)
ffffffe000200ae4:	04010413          	addi	s0,sp,64
ffffffe000200ae8:	fca43423          	sd	a0,-56(s0)
ffffffe000200aec:	fcb43023          	sd	a1,-64(s0)
  int tmp = scause;
ffffffe000200af0:	fc843783          	ld	a5,-56(s0)
ffffffe000200af4:	fef42623          	sw	a5,-20(s0)
  // judge trap type via scause
  unsigned long mask = 1;
ffffffe000200af8:	00100793          	li	a5,1
ffffffe000200afc:	fef43023          	sd	a5,-32(s0)
  mask = mask << 63;
ffffffe000200b00:	fe043783          	ld	a5,-32(s0)
ffffffe000200b04:	03f79793          	slli	a5,a5,0x3f
ffffffe000200b08:	fef43023          	sd	a5,-32(s0)
  unsigned long interrupt = scause & mask;
ffffffe000200b0c:	fc843703          	ld	a4,-56(s0)
ffffffe000200b10:	fe043783          	ld	a5,-32(s0)
ffffffe000200b14:	00f777b3          	and	a5,a4,a5
ffffffe000200b18:	fcf43c23          	sd	a5,-40(s0)
  // 如果是 interrupt 判断是否为 timer interrupt
  if (interrupt != 0) {
ffffffe000200b1c:	fd843783          	ld	a5,-40(s0)
ffffffe000200b20:	02078063          	beqz	a5,ffffffe000200b40 <trap_handler+0x68>
    // timer interrupt
    if (scause == 0x8000000000000005) {
ffffffe000200b24:	fc843703          	ld	a4,-56(s0)
ffffffe000200b28:	fff00793          	li	a5,-1
ffffffe000200b2c:	03f79793          	slli	a5,a5,0x3f
ffffffe000200b30:	00578793          	addi	a5,a5,5
ffffffe000200b34:	00f71663          	bne	a4,a5,ffffffe000200b40 <trap_handler+0x68>
      // printk("[S] Supervisor Mode Timer Interrupt\n");
      clock_set_next_event();
ffffffe000200b38:	ef0ff0ef          	jal	ra,ffffffe000200228 <clock_set_next_event>
    }
  }
  return ;
ffffffe000200b3c:	00000013          	nop
ffffffe000200b40:	00000013          	nop
ffffffe000200b44:	03813083          	ld	ra,56(sp)
ffffffe000200b48:	03013403          	ld	s0,48(sp)
ffffffe000200b4c:	04010113          	addi	sp,sp,64
ffffffe000200b50:	00008067          	ret

ffffffe000200b54 <setup_vm>:

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm(void)
{
ffffffe000200b54:	fe010113          	addi	sp,sp,-32
ffffffe000200b58:	00813c23          	sd	s0,24(sp)
ffffffe000200b5c:	02010413          	addi	s0,sp,32
        低 30 bit 作为 页内偏移 这里注意到 30 = 9 + 9 + 12， 即我们只使用根页表， 根页表的每个 entry 都对应 1GB 的区域。
    3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    4. early_pgtbl 对应的是虚拟地址，而在本函数中你需要将其转换为对应的物理地址使用
    */
    // convert virtual address to physical address
    unsigned long* early_pgtbl_pa = early_pgtbl - PA2VA_OFFSET;
ffffffe000200b60:	00004717          	auipc	a4,0x4
ffffffe000200b64:	4a070713          	addi	a4,a4,1184 # ffffffe000205000 <early_pgtbl>
ffffffe000200b68:	04100793          	li	a5,65
ffffffe000200b6c:	02279793          	slli	a5,a5,0x22
ffffffe000200b70:	00f707b3          	add	a5,a4,a5
ffffffe000200b74:	fef43023          	sd	a5,-32(s0)
    for(size_t i = 0; i < 512; ++i){
ffffffe000200b78:	fe043423          	sd	zero,-24(s0)
ffffffe000200b7c:	0640006f          	j	ffffffe000200be0 <setup_vm+0x8c>
      // set PPN
      early_pgtbl_pa[i] = PHY_START + (i << 30); 
ffffffe000200b80:	fe843783          	ld	a5,-24(s0)
ffffffe000200b84:	01e79693          	slli	a3,a5,0x1e
ffffffe000200b88:	fe843783          	ld	a5,-24(s0)
ffffffe000200b8c:	00379793          	slli	a5,a5,0x3
ffffffe000200b90:	fe043703          	ld	a4,-32(s0)
ffffffe000200b94:	00f707b3          	add	a5,a4,a5
ffffffe000200b98:	00100713          	li	a4,1
ffffffe000200b9c:	01f71713          	slli	a4,a4,0x1f
ffffffe000200ba0:	00e68733          	add	a4,a3,a4
ffffffe000200ba4:	00e7b023          	sd	a4,0(a5)
      // set V, R, W, X bit to 1
      early_pgtbl_pa[i] += (1) | (1 << 1) | (1 << 2) | (1 << 3);
ffffffe000200ba8:	fe843783          	ld	a5,-24(s0)
ffffffe000200bac:	00379793          	slli	a5,a5,0x3
ffffffe000200bb0:	fe043703          	ld	a4,-32(s0)
ffffffe000200bb4:	00f707b3          	add	a5,a4,a5
ffffffe000200bb8:	0007b703          	ld	a4,0(a5)
ffffffe000200bbc:	fe843783          	ld	a5,-24(s0)
ffffffe000200bc0:	00379793          	slli	a5,a5,0x3
ffffffe000200bc4:	fe043683          	ld	a3,-32(s0)
ffffffe000200bc8:	00f687b3          	add	a5,a3,a5
ffffffe000200bcc:	00f70713          	addi	a4,a4,15
ffffffe000200bd0:	00e7b023          	sd	a4,0(a5)
    for(size_t i = 0; i < 512; ++i){
ffffffe000200bd4:	fe843783          	ld	a5,-24(s0)
ffffffe000200bd8:	00178793          	addi	a5,a5,1
ffffffe000200bdc:	fef43423          	sd	a5,-24(s0)
ffffffe000200be0:	fe843703          	ld	a4,-24(s0)
ffffffe000200be4:	1ff00793          	li	a5,511
ffffffe000200be8:	f8e7fce3          	bgeu	a5,a4,ffffffe000200b80 <setup_vm+0x2c>
    }
}
ffffffe000200bec:	00000013          	nop
ffffffe000200bf0:	00000013          	nop
ffffffe000200bf4:	01813403          	ld	s0,24(sp)
ffffffe000200bf8:	02010113          	addi	sp,sp,32
ffffffe000200bfc:	00008067          	ret

ffffffe000200c00 <setup_vm_final>:


/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long  swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final(void) {
ffffffe000200c00:	ff010113          	addi	sp,sp,-16
ffffffe000200c04:	00113423          	sd	ra,8(sp)
ffffffe000200c08:	00813023          	sd	s0,0(sp)
ffffffe000200c0c:	01010413          	addi	s0,sp,16
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000200c10:	00001637          	lui	a2,0x1
ffffffe000200c14:	00000593          	li	a1,0
ffffffe000200c18:	00005517          	auipc	a0,0x5
ffffffe000200c1c:	3e850513          	addi	a0,a0,1000 # ffffffe000206000 <swapper_pg_dir>
ffffffe000200c20:	151000ef          	jal	ra,ffffffe000201570 <memset>
    // mapping other memory -|W|R|V
    // create_mapping(...);
  
    // set satp with swapper_pg_dir

    asm volatile("csrw satp, %0" : : "r"(swapper_pg_dir) : "memory");
ffffffe000200c24:	00005797          	auipc	a5,0x5
ffffffe000200c28:	3dc78793          	addi	a5,a5,988 # ffffffe000206000 <swapper_pg_dir>
ffffffe000200c2c:	18079073          	csrw	satp,a5

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000200c30:	12000073          	sfence.vma
    return;
ffffffe000200c34:	00000013          	nop
}
ffffffe000200c38:	00813083          	ld	ra,8(sp)
ffffffe000200c3c:	00013403          	ld	s0,0(sp)
ffffffe000200c40:	01010113          	addi	sp,sp,16
ffffffe000200c44:	00008067          	ret

ffffffe000200c48 <create_mapping>:


/* 创建多级页表映射关系 */
void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
ffffffe000200c48:	fc010113          	addi	sp,sp,-64
ffffffe000200c4c:	02813c23          	sd	s0,56(sp)
ffffffe000200c50:	04010413          	addi	s0,sp,64
ffffffe000200c54:	fea43423          	sd	a0,-24(s0)
ffffffe000200c58:	feb43023          	sd	a1,-32(s0)
ffffffe000200c5c:	fcc43c23          	sd	a2,-40(s0)
ffffffe000200c60:	fcd43823          	sd	a3,-48(s0)
ffffffe000200c64:	00070793          	mv	a5,a4
ffffffe000200c68:	fcf42623          	sw	a5,-52(s0)
  //   // get pte
  //   uint64* pte = walk(pgtbl, va_cur, 1);
  //  // set pte
  //   *pte = pa_cur | perm | PTE_V;
  // }
}
ffffffe000200c6c:	00000013          	nop
ffffffe000200c70:	03813403          	ld	s0,56(sp)
ffffffe000200c74:	04010113          	addi	sp,sp,64
ffffffe000200c78:	00008067          	ret

ffffffe000200c7c <start_kernel>:
#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel() {
ffffffe000200c7c:	ff010113          	addi	sp,sp,-16
ffffffe000200c80:	00113423          	sd	ra,8(sp)
ffffffe000200c84:	00813023          	sd	s0,0(sp)
ffffffe000200c88:	01010413          	addi	s0,sp,16
    // int x = 2022;
    printk("2022 ZJU Computer System II\n");
ffffffe000200c8c:	00001517          	auipc	a0,0x1
ffffffe000200c90:	43c50513          	addi	a0,a0,1084 # ffffffe0002020c8 <_srodata+0xc8>
ffffffe000200c94:	55c000ef          	jal	ra,ffffffe0002011f0 <printk>

    test(); // DO NOT DELETE !!!
ffffffe000200c98:	01c000ef          	jal	ra,ffffffe000200cb4 <test>

	return 0;
ffffffe000200c9c:	00000793          	li	a5,0
}
ffffffe000200ca0:	00078513          	mv	a0,a5
ffffffe000200ca4:	00813083          	ld	ra,8(sp)
ffffffe000200ca8:	00013403          	ld	s0,0(sp)
ffffffe000200cac:	01010113          	addi	sp,sp,16
ffffffe000200cb0:	00008067          	ret

ffffffe000200cb4 <test>:
#include "printk.h"
#include "defs.h"


void test() {
ffffffe000200cb4:	ff010113          	addi	sp,sp,-16
ffffffe000200cb8:	00813423          	sd	s0,8(sp)
ffffffe000200cbc:	01010413          	addi	s0,sp,16
  // unsigned long record_time = 0;
  while (1){
ffffffe000200cc0:	0000006f          	j	ffffffe000200cc0 <test+0xc>

ffffffe000200cc4 <putc>:
#include "printk.h"
#include "sbi.h"

void putc(char c) {
ffffffe000200cc4:	fe010113          	addi	sp,sp,-32
ffffffe000200cc8:	00113c23          	sd	ra,24(sp)
ffffffe000200ccc:	00813823          	sd	s0,16(sp)
ffffffe000200cd0:	02010413          	addi	s0,sp,32
ffffffe000200cd4:	00050793          	mv	a5,a0
ffffffe000200cd8:	fef407a3          	sb	a5,-17(s0)
  sbi_ecall(SBI_PUTCHAR, 0, c, 0, 0, 0, 0, 0);
ffffffe000200cdc:	fef44603          	lbu	a2,-17(s0)
ffffffe000200ce0:	00000893          	li	a7,0
ffffffe000200ce4:	00000813          	li	a6,0
ffffffe000200ce8:	00000793          	li	a5,0
ffffffe000200cec:	00000713          	li	a4,0
ffffffe000200cf0:	00000693          	li	a3,0
ffffffe000200cf4:	00000593          	li	a1,0
ffffffe000200cf8:	00100513          	li	a0,1
ffffffe000200cfc:	d01ff0ef          	jal	ra,ffffffe0002009fc <sbi_ecall>
}
ffffffe000200d00:	00000013          	nop
ffffffe000200d04:	01813083          	ld	ra,24(sp)
ffffffe000200d08:	01013403          	ld	s0,16(sp)
ffffffe000200d0c:	02010113          	addi	sp,sp,32
ffffffe000200d10:	00008067          	ret

ffffffe000200d14 <vprintfmt>:

static int vprintfmt(void(*putch)(char), const char *fmt, va_list vl) {
ffffffe000200d14:	f2010113          	addi	sp,sp,-224
ffffffe000200d18:	0c113c23          	sd	ra,216(sp)
ffffffe000200d1c:	0c813823          	sd	s0,208(sp)
ffffffe000200d20:	0e010413          	addi	s0,sp,224
ffffffe000200d24:	f2a43c23          	sd	a0,-200(s0)
ffffffe000200d28:	f2b43823          	sd	a1,-208(s0)
ffffffe000200d2c:	f2c43423          	sd	a2,-216(s0)
    int in_format = 0, longarg = 0;
ffffffe000200d30:	fe042623          	sw	zero,-20(s0)
ffffffe000200d34:	fe042423          	sw	zero,-24(s0)
    size_t pos = 0;
ffffffe000200d38:	fe043023          	sd	zero,-32(s0)
    for( ; *fmt; fmt++) {
ffffffe000200d3c:	48c0006f          	j	ffffffe0002011c8 <vprintfmt+0x4b4>
        if (in_format) {
ffffffe000200d40:	fec42783          	lw	a5,-20(s0)
ffffffe000200d44:	0007879b          	sext.w	a5,a5
ffffffe000200d48:	42078663          	beqz	a5,ffffffe000201174 <vprintfmt+0x460>
            switch(*fmt) {
ffffffe000200d4c:	f3043783          	ld	a5,-208(s0)
ffffffe000200d50:	0007c783          	lbu	a5,0(a5)
ffffffe000200d54:	0007879b          	sext.w	a5,a5
ffffffe000200d58:	f9d7869b          	addiw	a3,a5,-99
ffffffe000200d5c:	0006871b          	sext.w	a4,a3
ffffffe000200d60:	01500793          	li	a5,21
ffffffe000200d64:	44e7ea63          	bltu	a5,a4,ffffffe0002011b8 <vprintfmt+0x4a4>
ffffffe000200d68:	02069793          	slli	a5,a3,0x20
ffffffe000200d6c:	0207d793          	srli	a5,a5,0x20
ffffffe000200d70:	00279713          	slli	a4,a5,0x2
ffffffe000200d74:	00001797          	auipc	a5,0x1
ffffffe000200d78:	37478793          	addi	a5,a5,884 # ffffffe0002020e8 <_srodata+0xe8>
ffffffe000200d7c:	00f707b3          	add	a5,a4,a5
ffffffe000200d80:	0007a783          	lw	a5,0(a5)
ffffffe000200d84:	0007871b          	sext.w	a4,a5
ffffffe000200d88:	00001797          	auipc	a5,0x1
ffffffe000200d8c:	36078793          	addi	a5,a5,864 # ffffffe0002020e8 <_srodata+0xe8>
ffffffe000200d90:	00f707b3          	add	a5,a4,a5
ffffffe000200d94:	00078067          	jr	a5
                case 'l': { 
                    longarg = 1; 
ffffffe000200d98:	00100793          	li	a5,1
ffffffe000200d9c:	fef42423          	sw	a5,-24(s0)
                    break; 
ffffffe000200da0:	41c0006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }
                
                case 'x': {
                    long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000200da4:	fe842783          	lw	a5,-24(s0)
ffffffe000200da8:	0007879b          	sext.w	a5,a5
ffffffe000200dac:	00078c63          	beqz	a5,ffffffe000200dc4 <vprintfmt+0xb0>
ffffffe000200db0:	f2843783          	ld	a5,-216(s0)
ffffffe000200db4:	00878713          	addi	a4,a5,8
ffffffe000200db8:	f2e43423          	sd	a4,-216(s0)
ffffffe000200dbc:	0007b783          	ld	a5,0(a5)
ffffffe000200dc0:	0140006f          	j	ffffffe000200dd4 <vprintfmt+0xc0>
ffffffe000200dc4:	f2843783          	ld	a5,-216(s0)
ffffffe000200dc8:	00878713          	addi	a4,a5,8
ffffffe000200dcc:	f2e43423          	sd	a4,-216(s0)
ffffffe000200dd0:	0007a783          	lw	a5,0(a5)
ffffffe000200dd4:	f8f43c23          	sd	a5,-104(s0)

                    int hexdigits = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1;
ffffffe000200dd8:	fe842783          	lw	a5,-24(s0)
ffffffe000200ddc:	0007879b          	sext.w	a5,a5
ffffffe000200de0:	00078663          	beqz	a5,ffffffe000200dec <vprintfmt+0xd8>
ffffffe000200de4:	00f00793          	li	a5,15
ffffffe000200de8:	0080006f          	j	ffffffe000200df0 <vprintfmt+0xdc>
ffffffe000200dec:	00700793          	li	a5,7
ffffffe000200df0:	f8f42a23          	sw	a5,-108(s0)
                    for(int halfbyte = hexdigits; halfbyte >= 0; halfbyte--) {
ffffffe000200df4:	f9442783          	lw	a5,-108(s0)
ffffffe000200df8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200dfc:	0840006f          	j	ffffffe000200e80 <vprintfmt+0x16c>
                        int hex = (num >> (4*halfbyte)) & 0xF;
ffffffe000200e00:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e04:	0027979b          	slliw	a5,a5,0x2
ffffffe000200e08:	0007879b          	sext.w	a5,a5
ffffffe000200e0c:	f9843703          	ld	a4,-104(s0)
ffffffe000200e10:	40f757b3          	sra	a5,a4,a5
ffffffe000200e14:	0007879b          	sext.w	a5,a5
ffffffe000200e18:	00f7f793          	andi	a5,a5,15
ffffffe000200e1c:	f8f42823          	sw	a5,-112(s0)
                        char hexchar = (hex < 10 ? '0' + hex : 'a' + hex - 10);
ffffffe000200e20:	f9042783          	lw	a5,-112(s0)
ffffffe000200e24:	0007871b          	sext.w	a4,a5
ffffffe000200e28:	00900793          	li	a5,9
ffffffe000200e2c:	00e7cc63          	blt	a5,a4,ffffffe000200e44 <vprintfmt+0x130>
ffffffe000200e30:	f9042783          	lw	a5,-112(s0)
ffffffe000200e34:	0ff7f793          	zext.b	a5,a5
ffffffe000200e38:	0307879b          	addiw	a5,a5,48
ffffffe000200e3c:	0ff7f793          	zext.b	a5,a5
ffffffe000200e40:	0140006f          	j	ffffffe000200e54 <vprintfmt+0x140>
ffffffe000200e44:	f9042783          	lw	a5,-112(s0)
ffffffe000200e48:	0ff7f793          	zext.b	a5,a5
ffffffe000200e4c:	0577879b          	addiw	a5,a5,87
ffffffe000200e50:	0ff7f793          	zext.b	a5,a5
ffffffe000200e54:	f8f407a3          	sb	a5,-113(s0)
                        putch(hexchar);
ffffffe000200e58:	f8f44703          	lbu	a4,-113(s0)
ffffffe000200e5c:	f3843783          	ld	a5,-200(s0)
ffffffe000200e60:	00070513          	mv	a0,a4
ffffffe000200e64:	000780e7          	jalr	a5
                        pos++;
ffffffe000200e68:	fe043783          	ld	a5,-32(s0)
ffffffe000200e6c:	00178793          	addi	a5,a5,1
ffffffe000200e70:	fef43023          	sd	a5,-32(s0)
                    for(int halfbyte = hexdigits; halfbyte >= 0; halfbyte--) {
ffffffe000200e74:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e78:	fff7879b          	addiw	a5,a5,-1
ffffffe000200e7c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200e80:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e84:	0007879b          	sext.w	a5,a5
ffffffe000200e88:	f607dce3          	bgez	a5,ffffffe000200e00 <vprintfmt+0xec>
                    }
                    longarg = 0; in_format = 0; 
ffffffe000200e8c:	fe042423          	sw	zero,-24(s0)
ffffffe000200e90:	fe042623          	sw	zero,-20(s0)
                    break;
ffffffe000200e94:	3280006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }
            
                case 'd': {
                    long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000200e98:	fe842783          	lw	a5,-24(s0)
ffffffe000200e9c:	0007879b          	sext.w	a5,a5
ffffffe000200ea0:	00078c63          	beqz	a5,ffffffe000200eb8 <vprintfmt+0x1a4>
ffffffe000200ea4:	f2843783          	ld	a5,-216(s0)
ffffffe000200ea8:	00878713          	addi	a4,a5,8
ffffffe000200eac:	f2e43423          	sd	a4,-216(s0)
ffffffe000200eb0:	0007b783          	ld	a5,0(a5)
ffffffe000200eb4:	0140006f          	j	ffffffe000200ec8 <vprintfmt+0x1b4>
ffffffe000200eb8:	f2843783          	ld	a5,-216(s0)
ffffffe000200ebc:	00878713          	addi	a4,a5,8
ffffffe000200ec0:	f2e43423          	sd	a4,-216(s0)
ffffffe000200ec4:	0007a783          	lw	a5,0(a5)
ffffffe000200ec8:	fcf43823          	sd	a5,-48(s0)
                    if (num < 0) {
ffffffe000200ecc:	fd043783          	ld	a5,-48(s0)
ffffffe000200ed0:	0207d463          	bgez	a5,ffffffe000200ef8 <vprintfmt+0x1e4>
                        num = -num; putch('-');
ffffffe000200ed4:	fd043783          	ld	a5,-48(s0)
ffffffe000200ed8:	40f007b3          	neg	a5,a5
ffffffe000200edc:	fcf43823          	sd	a5,-48(s0)
ffffffe000200ee0:	f3843783          	ld	a5,-200(s0)
ffffffe000200ee4:	02d00513          	li	a0,45
ffffffe000200ee8:	000780e7          	jalr	a5
                        pos++;
ffffffe000200eec:	fe043783          	ld	a5,-32(s0)
ffffffe000200ef0:	00178793          	addi	a5,a5,1
ffffffe000200ef4:	fef43023          	sd	a5,-32(s0)
                    }
                    int bits = 0;
ffffffe000200ef8:	fc042623          	sw	zero,-52(s0)
                    char decchar[25] = {'0', 0};
ffffffe000200efc:	03000793          	li	a5,48
ffffffe000200f00:	f6f43023          	sd	a5,-160(s0)
ffffffe000200f04:	f6043423          	sd	zero,-152(s0)
ffffffe000200f08:	f6043823          	sd	zero,-144(s0)
ffffffe000200f0c:	f6040c23          	sb	zero,-136(s0)
                    for (long tmp = num; tmp; bits++) {
ffffffe000200f10:	fd043783          	ld	a5,-48(s0)
ffffffe000200f14:	fcf43023          	sd	a5,-64(s0)
ffffffe000200f18:	0480006f          	j	ffffffe000200f60 <vprintfmt+0x24c>
                        decchar[bits] = (tmp % 10) + '0';
ffffffe000200f1c:	fc043703          	ld	a4,-64(s0)
ffffffe000200f20:	00a00793          	li	a5,10
ffffffe000200f24:	02f767b3          	rem	a5,a4,a5
ffffffe000200f28:	0ff7f793          	zext.b	a5,a5
ffffffe000200f2c:	0307879b          	addiw	a5,a5,48
ffffffe000200f30:	0ff7f713          	zext.b	a4,a5
ffffffe000200f34:	fcc42783          	lw	a5,-52(s0)
ffffffe000200f38:	ff078793          	addi	a5,a5,-16
ffffffe000200f3c:	008787b3          	add	a5,a5,s0
ffffffe000200f40:	f6e78823          	sb	a4,-144(a5)
                        tmp /= 10;
ffffffe000200f44:	fc043703          	ld	a4,-64(s0)
ffffffe000200f48:	00a00793          	li	a5,10
ffffffe000200f4c:	02f747b3          	div	a5,a4,a5
ffffffe000200f50:	fcf43023          	sd	a5,-64(s0)
                    for (long tmp = num; tmp; bits++) {
ffffffe000200f54:	fcc42783          	lw	a5,-52(s0)
ffffffe000200f58:	0017879b          	addiw	a5,a5,1
ffffffe000200f5c:	fcf42623          	sw	a5,-52(s0)
ffffffe000200f60:	fc043783          	ld	a5,-64(s0)
ffffffe000200f64:	fa079ce3          	bnez	a5,ffffffe000200f1c <vprintfmt+0x208>
                    }

                    for (int i = bits; i >= 0; i--) {
ffffffe000200f68:	fcc42783          	lw	a5,-52(s0)
ffffffe000200f6c:	faf42e23          	sw	a5,-68(s0)
ffffffe000200f70:	02c0006f          	j	ffffffe000200f9c <vprintfmt+0x288>
                        putch(decchar[i]);
ffffffe000200f74:	fbc42783          	lw	a5,-68(s0)
ffffffe000200f78:	ff078793          	addi	a5,a5,-16
ffffffe000200f7c:	008787b3          	add	a5,a5,s0
ffffffe000200f80:	f707c703          	lbu	a4,-144(a5)
ffffffe000200f84:	f3843783          	ld	a5,-200(s0)
ffffffe000200f88:	00070513          	mv	a0,a4
ffffffe000200f8c:	000780e7          	jalr	a5
                    for (int i = bits; i >= 0; i--) {
ffffffe000200f90:	fbc42783          	lw	a5,-68(s0)
ffffffe000200f94:	fff7879b          	addiw	a5,a5,-1
ffffffe000200f98:	faf42e23          	sw	a5,-68(s0)
ffffffe000200f9c:	fbc42783          	lw	a5,-68(s0)
ffffffe000200fa0:	0007879b          	sext.w	a5,a5
ffffffe000200fa4:	fc07d8e3          	bgez	a5,ffffffe000200f74 <vprintfmt+0x260>
                    }
                    pos += bits + 1;
ffffffe000200fa8:	fcc42783          	lw	a5,-52(s0)
ffffffe000200fac:	0017879b          	addiw	a5,a5,1
ffffffe000200fb0:	0007879b          	sext.w	a5,a5
ffffffe000200fb4:	00078713          	mv	a4,a5
ffffffe000200fb8:	fe043783          	ld	a5,-32(s0)
ffffffe000200fbc:	00e787b3          	add	a5,a5,a4
ffffffe000200fc0:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
ffffffe000200fc4:	fe042423          	sw	zero,-24(s0)
ffffffe000200fc8:	fe042623          	sw	zero,-20(s0)
                    break;
ffffffe000200fcc:	1f00006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }

                case 'u': {
                    unsigned long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000200fd0:	fe842783          	lw	a5,-24(s0)
ffffffe000200fd4:	0007879b          	sext.w	a5,a5
ffffffe000200fd8:	00078c63          	beqz	a5,ffffffe000200ff0 <vprintfmt+0x2dc>
ffffffe000200fdc:	f2843783          	ld	a5,-216(s0)
ffffffe000200fe0:	00878713          	addi	a4,a5,8
ffffffe000200fe4:	f2e43423          	sd	a4,-216(s0)
ffffffe000200fe8:	0007b783          	ld	a5,0(a5)
ffffffe000200fec:	0140006f          	j	ffffffe000201000 <vprintfmt+0x2ec>
ffffffe000200ff0:	f2843783          	ld	a5,-216(s0)
ffffffe000200ff4:	00878713          	addi	a4,a5,8
ffffffe000200ff8:	f2e43423          	sd	a4,-216(s0)
ffffffe000200ffc:	0007a783          	lw	a5,0(a5)
ffffffe000201000:	f8f43023          	sd	a5,-128(s0)
                    int bits = 0;
ffffffe000201004:	fa042c23          	sw	zero,-72(s0)
                    char decchar[25] = {'0', 0};
ffffffe000201008:	03000793          	li	a5,48
ffffffe00020100c:	f4f43023          	sd	a5,-192(s0)
ffffffe000201010:	f4043423          	sd	zero,-184(s0)
ffffffe000201014:	f4043823          	sd	zero,-176(s0)
ffffffe000201018:	f4040c23          	sb	zero,-168(s0)
                    for (long tmp = num; tmp; bits++) {
ffffffe00020101c:	f8043783          	ld	a5,-128(s0)
ffffffe000201020:	faf43823          	sd	a5,-80(s0)
ffffffe000201024:	0480006f          	j	ffffffe00020106c <vprintfmt+0x358>
                        decchar[bits] = (tmp % 10) + '0';
ffffffe000201028:	fb043703          	ld	a4,-80(s0)
ffffffe00020102c:	00a00793          	li	a5,10
ffffffe000201030:	02f767b3          	rem	a5,a4,a5
ffffffe000201034:	0ff7f793          	zext.b	a5,a5
ffffffe000201038:	0307879b          	addiw	a5,a5,48
ffffffe00020103c:	0ff7f713          	zext.b	a4,a5
ffffffe000201040:	fb842783          	lw	a5,-72(s0)
ffffffe000201044:	ff078793          	addi	a5,a5,-16
ffffffe000201048:	008787b3          	add	a5,a5,s0
ffffffe00020104c:	f4e78823          	sb	a4,-176(a5)
                        tmp /= 10;
ffffffe000201050:	fb043703          	ld	a4,-80(s0)
ffffffe000201054:	00a00793          	li	a5,10
ffffffe000201058:	02f747b3          	div	a5,a4,a5
ffffffe00020105c:	faf43823          	sd	a5,-80(s0)
                    for (long tmp = num; tmp; bits++) {
ffffffe000201060:	fb842783          	lw	a5,-72(s0)
ffffffe000201064:	0017879b          	addiw	a5,a5,1
ffffffe000201068:	faf42c23          	sw	a5,-72(s0)
ffffffe00020106c:	fb043783          	ld	a5,-80(s0)
ffffffe000201070:	fa079ce3          	bnez	a5,ffffffe000201028 <vprintfmt+0x314>
                    }

                    for (int i = bits; i >= 0; i--) {
ffffffe000201074:	fb842783          	lw	a5,-72(s0)
ffffffe000201078:	faf42623          	sw	a5,-84(s0)
ffffffe00020107c:	02c0006f          	j	ffffffe0002010a8 <vprintfmt+0x394>
                        putch(decchar[i]);
ffffffe000201080:	fac42783          	lw	a5,-84(s0)
ffffffe000201084:	ff078793          	addi	a5,a5,-16
ffffffe000201088:	008787b3          	add	a5,a5,s0
ffffffe00020108c:	f507c703          	lbu	a4,-176(a5)
ffffffe000201090:	f3843783          	ld	a5,-200(s0)
ffffffe000201094:	00070513          	mv	a0,a4
ffffffe000201098:	000780e7          	jalr	a5
                    for (int i = bits; i >= 0; i--) {
ffffffe00020109c:	fac42783          	lw	a5,-84(s0)
ffffffe0002010a0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002010a4:	faf42623          	sw	a5,-84(s0)
ffffffe0002010a8:	fac42783          	lw	a5,-84(s0)
ffffffe0002010ac:	0007879b          	sext.w	a5,a5
ffffffe0002010b0:	fc07d8e3          	bgez	a5,ffffffe000201080 <vprintfmt+0x36c>
                    }
                    pos += bits + 1;
ffffffe0002010b4:	fb842783          	lw	a5,-72(s0)
ffffffe0002010b8:	0017879b          	addiw	a5,a5,1
ffffffe0002010bc:	0007879b          	sext.w	a5,a5
ffffffe0002010c0:	00078713          	mv	a4,a5
ffffffe0002010c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002010c8:	00e787b3          	add	a5,a5,a4
ffffffe0002010cc:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
ffffffe0002010d0:	fe042423          	sw	zero,-24(s0)
ffffffe0002010d4:	fe042623          	sw	zero,-20(s0)
                    break;
ffffffe0002010d8:	0e40006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }

                case 's': {
                    const char* str = va_arg(vl, const char*);
ffffffe0002010dc:	f2843783          	ld	a5,-216(s0)
ffffffe0002010e0:	00878713          	addi	a4,a5,8
ffffffe0002010e4:	f2e43423          	sd	a4,-216(s0)
ffffffe0002010e8:	0007b783          	ld	a5,0(a5)
ffffffe0002010ec:	faf43023          	sd	a5,-96(s0)
                    while (*str) {
ffffffe0002010f0:	0300006f          	j	ffffffe000201120 <vprintfmt+0x40c>
                        putch(*str);
ffffffe0002010f4:	fa043783          	ld	a5,-96(s0)
ffffffe0002010f8:	0007c703          	lbu	a4,0(a5)
ffffffe0002010fc:	f3843783          	ld	a5,-200(s0)
ffffffe000201100:	00070513          	mv	a0,a4
ffffffe000201104:	000780e7          	jalr	a5
                        pos++; 
ffffffe000201108:	fe043783          	ld	a5,-32(s0)
ffffffe00020110c:	00178793          	addi	a5,a5,1
ffffffe000201110:	fef43023          	sd	a5,-32(s0)
                        str++;
ffffffe000201114:	fa043783          	ld	a5,-96(s0)
ffffffe000201118:	00178793          	addi	a5,a5,1
ffffffe00020111c:	faf43023          	sd	a5,-96(s0)
                    while (*str) {
ffffffe000201120:	fa043783          	ld	a5,-96(s0)
ffffffe000201124:	0007c783          	lbu	a5,0(a5)
ffffffe000201128:	fc0796e3          	bnez	a5,ffffffe0002010f4 <vprintfmt+0x3e0>
                    }
                    longarg = 0; in_format = 0; 
ffffffe00020112c:	fe042423          	sw	zero,-24(s0)
ffffffe000201130:	fe042623          	sw	zero,-20(s0)
                    break;
ffffffe000201134:	0880006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }

                case 'c': {
                    char ch = (char)va_arg(vl,int);
ffffffe000201138:	f2843783          	ld	a5,-216(s0)
ffffffe00020113c:	00878713          	addi	a4,a5,8
ffffffe000201140:	f2e43423          	sd	a4,-216(s0)
ffffffe000201144:	0007a783          	lw	a5,0(a5)
ffffffe000201148:	f6f40fa3          	sb	a5,-129(s0)
                    putch(ch);
ffffffe00020114c:	f7f44703          	lbu	a4,-129(s0)
ffffffe000201150:	f3843783          	ld	a5,-200(s0)
ffffffe000201154:	00070513          	mv	a0,a4
ffffffe000201158:	000780e7          	jalr	a5
                    pos++;
ffffffe00020115c:	fe043783          	ld	a5,-32(s0)
ffffffe000201160:	00178793          	addi	a5,a5,1
ffffffe000201164:	fef43023          	sd	a5,-32(s0)
                    longarg = 0; in_format = 0; 
ffffffe000201168:	fe042423          	sw	zero,-24(s0)
ffffffe00020116c:	fe042623          	sw	zero,-20(s0)
                    break;
ffffffe000201170:	04c0006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                }
                default:
                    break;
            }
        }
        else if(*fmt == '%') {
ffffffe000201174:	f3043783          	ld	a5,-208(s0)
ffffffe000201178:	0007c783          	lbu	a5,0(a5)
ffffffe00020117c:	00078713          	mv	a4,a5
ffffffe000201180:	02500793          	li	a5,37
ffffffe000201184:	00f71863          	bne	a4,a5,ffffffe000201194 <vprintfmt+0x480>
          in_format = 1;
ffffffe000201188:	00100793          	li	a5,1
ffffffe00020118c:	fef42623          	sw	a5,-20(s0)
ffffffe000201190:	02c0006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
        }
        else {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
            putch(*fmt);
ffffffe000201194:	f3043783          	ld	a5,-208(s0)
ffffffe000201198:	0007c703          	lbu	a4,0(a5)
ffffffe00020119c:	f3843783          	ld	a5,-200(s0)
ffffffe0002011a0:	00070513          	mv	a0,a4
ffffffe0002011a4:	000780e7          	jalr	a5
            pos++;
ffffffe0002011a8:	fe043783          	ld	a5,-32(s0)
ffffffe0002011ac:	00178793          	addi	a5,a5,1
ffffffe0002011b0:	fef43023          	sd	a5,-32(s0)
ffffffe0002011b4:	0080006f          	j	ffffffe0002011bc <vprintfmt+0x4a8>
                    break;
ffffffe0002011b8:	00000013          	nop
    for( ; *fmt; fmt++) {
ffffffe0002011bc:	f3043783          	ld	a5,-208(s0)
ffffffe0002011c0:	00178793          	addi	a5,a5,1
ffffffe0002011c4:	f2f43823          	sd	a5,-208(s0)
ffffffe0002011c8:	f3043783          	ld	a5,-208(s0)
ffffffe0002011cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002011d0:	b60798e3          	bnez	a5,ffffffe000200d40 <vprintfmt+0x2c>
        }
    }
    return pos;
ffffffe0002011d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002011d8:	0007879b          	sext.w	a5,a5
}
ffffffe0002011dc:	00078513          	mv	a0,a5
ffffffe0002011e0:	0d813083          	ld	ra,216(sp)
ffffffe0002011e4:	0d013403          	ld	s0,208(sp)
ffffffe0002011e8:	0e010113          	addi	sp,sp,224
ffffffe0002011ec:	00008067          	ret

ffffffe0002011f0 <printk>:



int printk(const char* s, ...) {
ffffffe0002011f0:	f9010113          	addi	sp,sp,-112
ffffffe0002011f4:	02113423          	sd	ra,40(sp)
ffffffe0002011f8:	02813023          	sd	s0,32(sp)
ffffffe0002011fc:	03010413          	addi	s0,sp,48
ffffffe000201200:	fca43c23          	sd	a0,-40(s0)
ffffffe000201204:	00b43423          	sd	a1,8(s0)
ffffffe000201208:	00c43823          	sd	a2,16(s0)
ffffffe00020120c:	00d43c23          	sd	a3,24(s0)
ffffffe000201210:	02e43023          	sd	a4,32(s0)
ffffffe000201214:	02f43423          	sd	a5,40(s0)
ffffffe000201218:	03043823          	sd	a6,48(s0)
ffffffe00020121c:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000201220:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000201224:	04040793          	addi	a5,s0,64
ffffffe000201228:	fcf43823          	sd	a5,-48(s0)
ffffffe00020122c:	fd043783          	ld	a5,-48(s0)
ffffffe000201230:	fc878793          	addi	a5,a5,-56
ffffffe000201234:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000201238:	fe043783          	ld	a5,-32(s0)
ffffffe00020123c:	00078613          	mv	a2,a5
ffffffe000201240:	fd843583          	ld	a1,-40(s0)
ffffffe000201244:	00000517          	auipc	a0,0x0
ffffffe000201248:	a8050513          	addi	a0,a0,-1408 # ffffffe000200cc4 <putc>
ffffffe00020124c:	ac9ff0ef          	jal	ra,ffffffe000200d14 <vprintfmt>
ffffffe000201250:	00050793          	mv	a5,a0
ffffffe000201254:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000201258:	fec42783          	lw	a5,-20(s0)
}
ffffffe00020125c:	00078513          	mv	a0,a5
ffffffe000201260:	02813083          	ld	ra,40(sp)
ffffffe000201264:	02013403          	ld	s0,32(sp)
ffffffe000201268:	07010113          	addi	sp,sp,112
ffffffe00020126c:	00008067          	ret

ffffffe000201270 <rand>:

int initialize = 0;
int r[1000];
int t = 0;

uint64 rand() {
ffffffe000201270:	fe010113          	addi	sp,sp,-32
ffffffe000201274:	00813c23          	sd	s0,24(sp)
ffffffe000201278:	02010413          	addi	s0,sp,32
    int i;

    if (initialize == 0) {
ffffffe00020127c:	00006797          	auipc	a5,0x6
ffffffe000201280:	d8478793          	addi	a5,a5,-636 # ffffffe000207000 <initialize>
ffffffe000201284:	0007a783          	lw	a5,0(a5)
ffffffe000201288:	1e079463          	bnez	a5,ffffffe000201470 <rand+0x200>
        r[0] = SEED;
ffffffe00020128c:	00006797          	auipc	a5,0x6
ffffffe000201290:	d7c78793          	addi	a5,a5,-644 # ffffffe000207008 <r>
ffffffe000201294:	00d00713          	li	a4,13
ffffffe000201298:	00e7a023          	sw	a4,0(a5)
        for (i = 1; i < 31; i++) {
ffffffe00020129c:	00100793          	li	a5,1
ffffffe0002012a0:	fef42623          	sw	a5,-20(s0)
ffffffe0002012a4:	0c40006f          	j	ffffffe000201368 <rand+0xf8>
            r[i] = (16807LL * r[i - 1]) % 2147483647;
ffffffe0002012a8:	fec42783          	lw	a5,-20(s0)
ffffffe0002012ac:	fff7879b          	addiw	a5,a5,-1
ffffffe0002012b0:	0007879b          	sext.w	a5,a5
ffffffe0002012b4:	00006717          	auipc	a4,0x6
ffffffe0002012b8:	d5470713          	addi	a4,a4,-684 # ffffffe000207008 <r>
ffffffe0002012bc:	00279793          	slli	a5,a5,0x2
ffffffe0002012c0:	00f707b3          	add	a5,a4,a5
ffffffe0002012c4:	0007a783          	lw	a5,0(a5)
ffffffe0002012c8:	00078713          	mv	a4,a5
ffffffe0002012cc:	000047b7          	lui	a5,0x4
ffffffe0002012d0:	1a778793          	addi	a5,a5,423 # 41a7 <_start-0xffffffe0001fbe59>
ffffffe0002012d4:	02f70733          	mul	a4,a4,a5
ffffffe0002012d8:	800007b7          	lui	a5,0x80000
ffffffe0002012dc:	fff7c793          	not	a5,a5
ffffffe0002012e0:	02f767b3          	rem	a5,a4,a5
ffffffe0002012e4:	0007871b          	sext.w	a4,a5
ffffffe0002012e8:	00006697          	auipc	a3,0x6
ffffffe0002012ec:	d2068693          	addi	a3,a3,-736 # ffffffe000207008 <r>
ffffffe0002012f0:	fec42783          	lw	a5,-20(s0)
ffffffe0002012f4:	00279793          	slli	a5,a5,0x2
ffffffe0002012f8:	00f687b3          	add	a5,a3,a5
ffffffe0002012fc:	00e7a023          	sw	a4,0(a5) # ffffffff80000000 <_end+0x1f7fdf8000>
            if (r[i] < 0) {
ffffffe000201300:	00006717          	auipc	a4,0x6
ffffffe000201304:	d0870713          	addi	a4,a4,-760 # ffffffe000207008 <r>
ffffffe000201308:	fec42783          	lw	a5,-20(s0)
ffffffe00020130c:	00279793          	slli	a5,a5,0x2
ffffffe000201310:	00f707b3          	add	a5,a4,a5
ffffffe000201314:	0007a783          	lw	a5,0(a5)
ffffffe000201318:	0407d263          	bgez	a5,ffffffe00020135c <rand+0xec>
                r[i] += 2147483647;
ffffffe00020131c:	00006717          	auipc	a4,0x6
ffffffe000201320:	cec70713          	addi	a4,a4,-788 # ffffffe000207008 <r>
ffffffe000201324:	fec42783          	lw	a5,-20(s0)
ffffffe000201328:	00279793          	slli	a5,a5,0x2
ffffffe00020132c:	00f707b3          	add	a5,a4,a5
ffffffe000201330:	0007a703          	lw	a4,0(a5)
ffffffe000201334:	800007b7          	lui	a5,0x80000
ffffffe000201338:	fff7c793          	not	a5,a5
ffffffe00020133c:	00f707bb          	addw	a5,a4,a5
ffffffe000201340:	0007871b          	sext.w	a4,a5
ffffffe000201344:	00006697          	auipc	a3,0x6
ffffffe000201348:	cc468693          	addi	a3,a3,-828 # ffffffe000207008 <r>
ffffffe00020134c:	fec42783          	lw	a5,-20(s0)
ffffffe000201350:	00279793          	slli	a5,a5,0x2
ffffffe000201354:	00f687b3          	add	a5,a3,a5
ffffffe000201358:	00e7a023          	sw	a4,0(a5) # ffffffff80000000 <_end+0x1f7fdf8000>
        for (i = 1; i < 31; i++) {
ffffffe00020135c:	fec42783          	lw	a5,-20(s0)
ffffffe000201360:	0017879b          	addiw	a5,a5,1
ffffffe000201364:	fef42623          	sw	a5,-20(s0)
ffffffe000201368:	fec42783          	lw	a5,-20(s0)
ffffffe00020136c:	0007871b          	sext.w	a4,a5
ffffffe000201370:	01e00793          	li	a5,30
ffffffe000201374:	f2e7dae3          	bge	a5,a4,ffffffe0002012a8 <rand+0x38>
            }
        }
        for (i = 31; i < 34; i++) {
ffffffe000201378:	01f00793          	li	a5,31
ffffffe00020137c:	fef42623          	sw	a5,-20(s0)
ffffffe000201380:	0480006f          	j	ffffffe0002013c8 <rand+0x158>
            r[i] = r[i - 31];
ffffffe000201384:	fec42783          	lw	a5,-20(s0)
ffffffe000201388:	fe17879b          	addiw	a5,a5,-31
ffffffe00020138c:	0007879b          	sext.w	a5,a5
ffffffe000201390:	00006717          	auipc	a4,0x6
ffffffe000201394:	c7870713          	addi	a4,a4,-904 # ffffffe000207008 <r>
ffffffe000201398:	00279793          	slli	a5,a5,0x2
ffffffe00020139c:	00f707b3          	add	a5,a4,a5
ffffffe0002013a0:	0007a703          	lw	a4,0(a5)
ffffffe0002013a4:	00006697          	auipc	a3,0x6
ffffffe0002013a8:	c6468693          	addi	a3,a3,-924 # ffffffe000207008 <r>
ffffffe0002013ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002013b0:	00279793          	slli	a5,a5,0x2
ffffffe0002013b4:	00f687b3          	add	a5,a3,a5
ffffffe0002013b8:	00e7a023          	sw	a4,0(a5)
        for (i = 31; i < 34; i++) {
ffffffe0002013bc:	fec42783          	lw	a5,-20(s0)
ffffffe0002013c0:	0017879b          	addiw	a5,a5,1
ffffffe0002013c4:	fef42623          	sw	a5,-20(s0)
ffffffe0002013c8:	fec42783          	lw	a5,-20(s0)
ffffffe0002013cc:	0007871b          	sext.w	a4,a5
ffffffe0002013d0:	02100793          	li	a5,33
ffffffe0002013d4:	fae7d8e3          	bge	a5,a4,ffffffe000201384 <rand+0x114>
        }
        for (i = 34; i < 344; i++) {
ffffffe0002013d8:	02200793          	li	a5,34
ffffffe0002013dc:	fef42623          	sw	a5,-20(s0)
ffffffe0002013e0:	0700006f          	j	ffffffe000201450 <rand+0x1e0>
            r[i] = r[i - 31] + r[i - 3];
ffffffe0002013e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013e8:	fe17879b          	addiw	a5,a5,-31
ffffffe0002013ec:	0007879b          	sext.w	a5,a5
ffffffe0002013f0:	00006717          	auipc	a4,0x6
ffffffe0002013f4:	c1870713          	addi	a4,a4,-1000 # ffffffe000207008 <r>
ffffffe0002013f8:	00279793          	slli	a5,a5,0x2
ffffffe0002013fc:	00f707b3          	add	a5,a4,a5
ffffffe000201400:	0007a703          	lw	a4,0(a5)
ffffffe000201404:	fec42783          	lw	a5,-20(s0)
ffffffe000201408:	ffd7879b          	addiw	a5,a5,-3
ffffffe00020140c:	0007879b          	sext.w	a5,a5
ffffffe000201410:	00006697          	auipc	a3,0x6
ffffffe000201414:	bf868693          	addi	a3,a3,-1032 # ffffffe000207008 <r>
ffffffe000201418:	00279793          	slli	a5,a5,0x2
ffffffe00020141c:	00f687b3          	add	a5,a3,a5
ffffffe000201420:	0007a783          	lw	a5,0(a5)
ffffffe000201424:	00f707bb          	addw	a5,a4,a5
ffffffe000201428:	0007871b          	sext.w	a4,a5
ffffffe00020142c:	00006697          	auipc	a3,0x6
ffffffe000201430:	bdc68693          	addi	a3,a3,-1060 # ffffffe000207008 <r>
ffffffe000201434:	fec42783          	lw	a5,-20(s0)
ffffffe000201438:	00279793          	slli	a5,a5,0x2
ffffffe00020143c:	00f687b3          	add	a5,a3,a5
ffffffe000201440:	00e7a023          	sw	a4,0(a5)
        for (i = 34; i < 344; i++) {
ffffffe000201444:	fec42783          	lw	a5,-20(s0)
ffffffe000201448:	0017879b          	addiw	a5,a5,1
ffffffe00020144c:	fef42623          	sw	a5,-20(s0)
ffffffe000201450:	fec42783          	lw	a5,-20(s0)
ffffffe000201454:	0007871b          	sext.w	a4,a5
ffffffe000201458:	15700793          	li	a5,343
ffffffe00020145c:	f8e7d4e3          	bge	a5,a4,ffffffe0002013e4 <rand+0x174>
        }

		initialize = 1;
ffffffe000201460:	00006797          	auipc	a5,0x6
ffffffe000201464:	ba078793          	addi	a5,a5,-1120 # ffffffe000207000 <initialize>
ffffffe000201468:	00100713          	li	a4,1
ffffffe00020146c:	00e7a023          	sw	a4,0(a5)
    }

	t = t % 656;
ffffffe000201470:	00007797          	auipc	a5,0x7
ffffffe000201474:	b3878793          	addi	a5,a5,-1224 # ffffffe000207fa8 <t>
ffffffe000201478:	0007a783          	lw	a5,0(a5)
ffffffe00020147c:	00078713          	mv	a4,a5
ffffffe000201480:	29000793          	li	a5,656
ffffffe000201484:	02f767bb          	remw	a5,a4,a5
ffffffe000201488:	0007871b          	sext.w	a4,a5
ffffffe00020148c:	00007797          	auipc	a5,0x7
ffffffe000201490:	b1c78793          	addi	a5,a5,-1252 # ffffffe000207fa8 <t>
ffffffe000201494:	00e7a023          	sw	a4,0(a5)

    r[t + 344] = r[t + 344 - 31] + r[t + 344 - 3];
ffffffe000201498:	00007797          	auipc	a5,0x7
ffffffe00020149c:	b1078793          	addi	a5,a5,-1264 # ffffffe000207fa8 <t>
ffffffe0002014a0:	0007a783          	lw	a5,0(a5)
ffffffe0002014a4:	1397879b          	addiw	a5,a5,313
ffffffe0002014a8:	0007879b          	sext.w	a5,a5
ffffffe0002014ac:	00006717          	auipc	a4,0x6
ffffffe0002014b0:	b5c70713          	addi	a4,a4,-1188 # ffffffe000207008 <r>
ffffffe0002014b4:	00279793          	slli	a5,a5,0x2
ffffffe0002014b8:	00f707b3          	add	a5,a4,a5
ffffffe0002014bc:	0007a683          	lw	a3,0(a5)
ffffffe0002014c0:	00007797          	auipc	a5,0x7
ffffffe0002014c4:	ae878793          	addi	a5,a5,-1304 # ffffffe000207fa8 <t>
ffffffe0002014c8:	0007a783          	lw	a5,0(a5)
ffffffe0002014cc:	1557879b          	addiw	a5,a5,341
ffffffe0002014d0:	0007879b          	sext.w	a5,a5
ffffffe0002014d4:	00006717          	auipc	a4,0x6
ffffffe0002014d8:	b3470713          	addi	a4,a4,-1228 # ffffffe000207008 <r>
ffffffe0002014dc:	00279793          	slli	a5,a5,0x2
ffffffe0002014e0:	00f707b3          	add	a5,a4,a5
ffffffe0002014e4:	0007a703          	lw	a4,0(a5)
ffffffe0002014e8:	00007797          	auipc	a5,0x7
ffffffe0002014ec:	ac078793          	addi	a5,a5,-1344 # ffffffe000207fa8 <t>
ffffffe0002014f0:	0007a783          	lw	a5,0(a5)
ffffffe0002014f4:	1587879b          	addiw	a5,a5,344
ffffffe0002014f8:	0007879b          	sext.w	a5,a5
ffffffe0002014fc:	00e6873b          	addw	a4,a3,a4
ffffffe000201500:	0007071b          	sext.w	a4,a4
ffffffe000201504:	00006697          	auipc	a3,0x6
ffffffe000201508:	b0468693          	addi	a3,a3,-1276 # ffffffe000207008 <r>
ffffffe00020150c:	00279793          	slli	a5,a5,0x2
ffffffe000201510:	00f687b3          	add	a5,a3,a5
ffffffe000201514:	00e7a023          	sw	a4,0(a5)
    
	t++;
ffffffe000201518:	00007797          	auipc	a5,0x7
ffffffe00020151c:	a9078793          	addi	a5,a5,-1392 # ffffffe000207fa8 <t>
ffffffe000201520:	0007a783          	lw	a5,0(a5)
ffffffe000201524:	0017879b          	addiw	a5,a5,1
ffffffe000201528:	0007871b          	sext.w	a4,a5
ffffffe00020152c:	00007797          	auipc	a5,0x7
ffffffe000201530:	a7c78793          	addi	a5,a5,-1412 # ffffffe000207fa8 <t>
ffffffe000201534:	00e7a023          	sw	a4,0(a5)

    return (uint64)r[t - 1 + 344];
ffffffe000201538:	00007797          	auipc	a5,0x7
ffffffe00020153c:	a7078793          	addi	a5,a5,-1424 # ffffffe000207fa8 <t>
ffffffe000201540:	0007a783          	lw	a5,0(a5)
ffffffe000201544:	1577879b          	addiw	a5,a5,343
ffffffe000201548:	0007879b          	sext.w	a5,a5
ffffffe00020154c:	00006717          	auipc	a4,0x6
ffffffe000201550:	abc70713          	addi	a4,a4,-1348 # ffffffe000207008 <r>
ffffffe000201554:	00279793          	slli	a5,a5,0x2
ffffffe000201558:	00f707b3          	add	a5,a4,a5
ffffffe00020155c:	0007a783          	lw	a5,0(a5)
}
ffffffe000201560:	00078513          	mv	a0,a5
ffffffe000201564:	01813403          	ld	s0,24(sp)
ffffffe000201568:	02010113          	addi	sp,sp,32
ffffffe00020156c:	00008067          	ret

ffffffe000201570 <memset>:
#include "string.h"

void *memset(void *dst, int c, uint64 n) {
ffffffe000201570:	fc010113          	addi	sp,sp,-64
ffffffe000201574:	02813c23          	sd	s0,56(sp)
ffffffe000201578:	04010413          	addi	s0,sp,64
ffffffe00020157c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201580:	00058793          	mv	a5,a1
ffffffe000201584:	fcc43423          	sd	a2,-56(s0)
ffffffe000201588:	fcf42a23          	sw	a5,-44(s0)
    char *cdst = (char *)dst;
ffffffe00020158c:	fd843783          	ld	a5,-40(s0)
ffffffe000201590:	fef43023          	sd	a5,-32(s0)
    for (uint64 i = 0; i < n; ++i)
ffffffe000201594:	fe043423          	sd	zero,-24(s0)
ffffffe000201598:	0280006f          	j	ffffffe0002015c0 <memset+0x50>
        cdst[i] = c;
ffffffe00020159c:	fe043703          	ld	a4,-32(s0)
ffffffe0002015a0:	fe843783          	ld	a5,-24(s0)
ffffffe0002015a4:	00f707b3          	add	a5,a4,a5
ffffffe0002015a8:	fd442703          	lw	a4,-44(s0)
ffffffe0002015ac:	0ff77713          	zext.b	a4,a4
ffffffe0002015b0:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < n; ++i)
ffffffe0002015b4:	fe843783          	ld	a5,-24(s0)
ffffffe0002015b8:	00178793          	addi	a5,a5,1
ffffffe0002015bc:	fef43423          	sd	a5,-24(s0)
ffffffe0002015c0:	fe843703          	ld	a4,-24(s0)
ffffffe0002015c4:	fc843783          	ld	a5,-56(s0)
ffffffe0002015c8:	fcf76ae3          	bltu	a4,a5,ffffffe00020159c <memset+0x2c>

    return dst;
ffffffe0002015cc:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002015d0:	00078513          	mv	a0,a5
ffffffe0002015d4:	03813403          	ld	s0,56(sp)
ffffffe0002015d8:	04010113          	addi	sp,sp,64
ffffffe0002015dc:	00008067          	ret
