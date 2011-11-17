obj-m += hello_kernel_module.o

PWD=$(shell pwd)
LINUX_HEADERS="/lib/modules/${PWD}/build"

all:
	make -C ${LINUX_HEADERS} M=${PWD} modules

clean:
	make -C ${LINUX_HEADERS} M=${PWD} clean

