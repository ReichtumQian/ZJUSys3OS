
#ifndef _VM_H
#define _VM_H

#include "defs.h"
#include "proc.h"



void setup_vm(void);

void setup_vm_final(void);

void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm);

uint64 *setupUserPage(uint64 *user_stack);

/*
 * @mm          : current thread's mm_struct
 * @address     : the va to look up
 *
 * @return      : the VMA if found or NULL if not found
 */
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64 addr);

/*
 * @mm     : current thread's mm_struct
 * @addr   : the suggested va to map
 * @length : memory size to map
 * @prot   : protection
 *
 * @return : start va
 */
uint64 do_mmap(struct mm_struct *mm, uint64 addr, uint64 length, int prot);

uint64 get_unmapped_area(struct mm_struct *mm, uint64 length);

#endif /* _VM_H */