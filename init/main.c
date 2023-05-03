#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel() {
    // int x = 2022;
    printk("2023 ZJU Computer System III\n");
    printk("Author: Qian YiXiao\n");

    test(); // DO NOT DELETE !!!

	return 0;
}
