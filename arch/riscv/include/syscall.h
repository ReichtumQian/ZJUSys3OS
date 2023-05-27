
#pragma once

#include "types.h"
#include "proc.h"

#define SYS_WRITE 64
#define SYS_GETPID 172
#define SYS_CLONE 220

uint64 sys_getpid();

void sys_write(uint64 fd, const char *buf, uint64 count);

void forkret();

uint64 do_fork(struct pt_regs *regs);

uint64 clone(struct pt_regs *regs);
