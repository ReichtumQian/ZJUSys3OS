#pragma once

#include "types.h"

struct pt_regs {
  uint64 x[31];
  uint64 sepc;
  uint64 sstatus;
};

void do_page_fault(struct pt_regs *regs);
