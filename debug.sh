#!/bin/bash
gdb-multiarch -ex 'target remote localhost:1234' -ex 'b *0x80200000' -ex 'c' -ex 'layout asm' vmlinux