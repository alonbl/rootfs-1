
KERNEL_DIR = ../linux-2.6.31.6
BUSYBOX_DIR = ../busybox-1.14.4

all:	initramfs.cpio.gz

clean:
	rm -f *.cpio *.gz
	rm -fr root/bin/busybox root/lib/

base.cpio:
	$(KERNEL_DIR)/usr/gen_init_cpio initramfs.list > base.cpio

root/bin/busybox:	$(BUSYBOX_DIR)/busybox
	cp $(BUSYBOX_DIR)/busybox root/bin/busybox

.PHONY: modules
modules:
	ARCH=powerpc $(MAKE) -C $(KERNEL_DIR) modules_install INSTALL_MOD_PATH=`pwd`/root

extra.cpio:	root/bin/busybox modules
	( cd root && find . | cpio -o -H newc ) > extra.cpio

initramfs.cpio.gz:	base.cpio extra.cpio
	cat base.cpio extra.cpio | gzip > initramfs.cpio.gz
