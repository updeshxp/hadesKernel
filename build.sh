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
#boot.img packing
	./hK-tools/mkbootimg --kernel ./hK-out/pack/zImage --ramdisk ./hK-tools/ramdisk/SU-FGM_ramdisk.gz --cmdline "console=null androidboot.hardware=qcom user_debug=23 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci" --base 80000000 --pagesize 2048 --kernel_offset 00008000 --ramdisk_offset 02000000 --tags_offset 01e00000 --dt ./hK-out/pack/dts --output ./hK-out/zip/boot.img


echo "Done!"



