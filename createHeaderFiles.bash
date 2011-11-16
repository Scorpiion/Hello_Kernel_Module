#!/bin/bash

CROSS_ARCH="arm"
CROSS_CC="arm-linux-gnueabi-"
HEADER_DIR=$PWD/Linux-headers
JN=$(($(cat /proc/cpuinfo | grep processor | wc -l)*3))

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

if [ ! -d "$KERNEL_TREE" ]; then
  while [ ! -d "$KERNEL_TREE" ]; do 
    echo "Error: Directory \"$KERNEL_TREE\" does not exist."
    echo ""
    echo -n "Enter directory of a download (unpacked) Linux kernel (can be found at kernel.org): "
    read KERNEL_TREE
  done
fi

echo "Available defconfigs:"
ls $KERNEL_TREE/arch/arm/configs
echo ""
echo -n "Enter the name of the defconfig file you want to use: "
read DEFCONFIG

if [ ! -f "$KERNEL_TREE/arch/arm/configs/$DEFCONFIG" ]; then
  while [ ! -f "$KERNEL_TREE/arch/arm/configs/$DEFCONFIG" ]; do 
    echo "Error: Config file \"$KERNEL_TREE/arch/arm/configs/$DEFCONFIG\" does not exist."
    echo ""
    echo "Available defconfigs:"
    ls $KERNEL_TREE/arch/arm/configs
    echo ""
    echo -n "Enter the name of the defconfig file you want to use: "
    read DEFCONFIG
  done
fi

echo ""
echo "The file \"Module.symvers\" contains a list of all exported symbols from a kernel build."
echo "It can only be created by building all kernel modules, this does take some time depending on"
echo "the number of modules listed in the choosen defconfig file and the speed of you computer. "
echo ""
echo "For simpler kernel modules \"Module.symvers\" is not needed to compiled your modules."
echo -n "Do you want to build kernel modules first and thereby create the file \"Module.symvers\" or not? (y/n): "
read buildModules

make -C ${KERNEL_TREE} mrproper
make -j $JN ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} O=${HEADER_DIR} -C ${KERNEL_TREE} $DEFCONFIG
make -j $JN ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} O=${HEADER_DIR} -C ${KERNEL_TREE} prepare
make -j $JN ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} O=${HEADER_DIR} -C ${KERNEL_TREE} scripts
if [ "$buildModules" == "y" ]; then
  make -j $JN ARCH=${CROSS_ARCH} CROSS_COMPILE=${CROSS_CC} O=${HEADER_DIR} -C ${KERNEL_TREE} modules
fi

