obj-m += hello_kernel_module.o

LINUX_HEADERS="/lib/modules/$(shell uname -r)/build"
PWD=$(shell pwd)

all:
	make -C ${LINUX_HEADERS} M=${PWD} modules

clean:
	make -C ${LINUX_HEADERS} M=${PWD} clean

