obj-m += hello.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)
CLANG_FORMAT := clang-format
CLANG_FORMAT_CONFIG := .clang-format

all: make

make:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

load: make
	sudo insmod hello.ko

unload:
	sudo rmmod hello

format:
	$(CLANG_FORMAT) -i -style=file hello.c

check:
	dmesg | tail -n 20
