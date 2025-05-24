.PHONY: all clean format check

all:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

format:
	clang-format -i hello.c

check:
	./check.sh
