#!/bin/bash
gdb-multiarch -ex 'target remote localhost:1234'  -ex 'layout asm' vmlinux