obj-m += hello_kernel_module.o

CROSS_ARCH="arm"
CROSS_CC="arm-linux-gnueabi-"
PWD=$(shell pwd)
LINUX_HEADERS="${PWD}/Linux-headers"

all:
	make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} -C ${LINUX_HEADERS} M=${PWD} modules

clean:
	make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} -C ${LINUX_HEADERS} M=${PWD} clean


