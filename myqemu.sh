#!/bin/sh

NULL=

qemu-system-ppc \
	-M mpc8544ds -cpu MPC8567 \
	-m 1024 \
	-nographic -s \
	-kernel ../linux-2.6.31.6/vmlinux \
	-initrd initramfs.cpio.gz \
	\
	-net nic,netdev=eth0,model=e1000 -netdev tap,id=eth0,ifname=vm0,script=/bin/true,downscript=no \
	\
	-drive  if=none,file=/tmp/disk0.img,format=raw,id=drive-sata0-0-0 \
	-device ahci,id=ahci0 \
	-device ide-drive,bus=ahci0.0,drive=drive-sata0-0-0,id=sata0-0-0 \
	\
	${NULL}
