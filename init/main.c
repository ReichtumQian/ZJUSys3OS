#include "printk.h"
#include "sbi.h"

extern void test();

int start_kernel() {
    // int x = 2022;
    printk("2022 ZJU Computer System II\n");

    test(); // DO NOT DELETE !!!

	return 0;
}
