#!/bin/bash

CROSS_ARCH="arm"
CROSS_CC="arm-linux-gnueabi-"
HEADER_DIR=$PWD/Linux-headers

if [ -d $HEADER_DIR ]; then
  echo -n "This script will delete existing headers in \"$HEADER_DIR\", do you want to continue? (y/n) "
  read doContinue
fi

if [ "$doContinue" == "n" ]; then
  echo "Okey, goodbye!"
  exit 0
fi

if [ ! -d $HEADER_DIR ]; then
  mkdir $HEADER_DIR
else
  rm -rf $HEADER_DIR
  mkdir $HEADER_DIR
fi

echo -n "Enter directory of a download (unpacked) Linux kernel (can be found at kernel.org): "
read KERNEL_TREE

make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} INSTALL_HDR_PATH=${HEADER_DIR} -C ${KERNEL_TREE} mrproper
make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} INSTALL_HDR_PATH=${HEADER_DIR} -C ${KERNEL_TREE} omap3_beagle_defconfig
make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} INSTALL_HDR_PATH=${HEADER_DIR} -C ${KERNEL_TREE} scripts
make ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} INSTALL_HDR_PATH=${HEADER_DIR} -C ${KERNEL_TREE} headers_install

