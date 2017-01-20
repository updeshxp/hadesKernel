#!/bin/bash
#Cleanup before build
	rm -rf $(pwd)/output
	rm -rf $(pwd)/hK-out
	make clean

#The build 
	export ARCH=arm
	export CROSS_COMPILE=$(pwd)/hK-tools/arm-eabi-4.8/bin/arm-eabi-
	mkdir -p output hK-out/pack/rd hK-out/zip/hades

	make -C $(pwd) O=output common_defconfig VARIANT_DEFCONFIG=fgm_defconfig SELINUX_DEFCONFIG=selinux_defconfig
	make -j64 -C $(pwd) O=output

# zImage copying - assuming the zimage is built
	cp output/arch/arm/boot/zImage $(pwd)/hK-out/pack/zImage

# DTS packing
	./tools/dtbTool -v -s 2048 -o ./hK-out/pack/dts ./output/arch/arm/boot/dts/

echo "Done!"



