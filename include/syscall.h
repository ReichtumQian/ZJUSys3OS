
#pragma once

#include "types.h"

#define SYS_WRITE   64
#define SYS_GETPID  172

uint64 sys_getpid();

void sys_write(uint64 fd, const char* buf, uint64 count);
