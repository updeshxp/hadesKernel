#!/bin/bash
#A5F
#Cleanup before build
	rm -rf $(pwd)/output
	rm -rf $(pwd)/hK-out
	make clean

#The build 
	sed -i 's/model/A500F/g' $(pwd)/.scmversion
	export ARCH=arm
	export CROSS_COMPILE=$(pwd)/hK-tools/arm-eabi-4.8/bin/arm-eabi-
	mkdir -p output hK-out/pack/rd hK-out/zip/hades hK-zip

	make -C $(pwd) O=output msm8916_sec_defconfig VARIANT_DEFCONFIG=a5fgm_defconfig SELINUX_DEFCONFIG=selinux_defconfig
	make -j64 -C $(pwd) O=output

	sed -i 's/A500F/model/g' $(pwd)/.scmversion
# zImage copying - assuming the zimage is built
	cp output/arch/arm/boot/zImage $(pwd)/hK-out/pack/zImage

# DTS packing
	./tools/dtbTool -v -s 2048 -o ./hK-out/pack/dts ./output/arch/arm/boot/dts/

#Ramdisk packing
	echo "Building ramdisk structure..."
	cp -r hK-tools/ramdisk/common/* hK-out/pack/rd
	cp -r hK-tools/ramdisk/A5F/* hK-out/pack/rd
	cd $(pwd)/hK-out/pack/rd
	mkdir -p hmod data dev oem proc sys system
	cp -r ../../../output/drivers/staging/prima/wlan.ko hmod/wlan.ko
	cp -r ../../../output/drivers/media/radio/radio-iris-transport.ko hmod/radio.ko
	echo "Setting ramdisk file permissions..."
	# set all directories to 0755 by default
	find -type d -exec chmod 755 {} \;
	# set all files to 0644 by default
	find -type f -exec chmod 644 {} \;
	# scripts should be 0750
	find -name "*.rc" -exec chmod 750 {} \;
	find -name "*.sh" -exec chmod 750 {} \;
	# init and everything in /sbin should be 0750
	chmod -Rf 750 init sbin
	chmod 771 data
	find | fakeroot cpio -o -H newc | gzip -9 > ../hK-ramdisk.gz
	cd ../../../

echo "Generating boot.img..."
echo ""
./hK-tools/mkbootimg --kernel ./hK-out/pack/zImage \
				--ramdisk ./hK-out/pack/hK-ramdisk.gz \
				--cmdline "console=null androidboot.hardware=qcom user_debug=23 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci" \
				--base 80000000 \
				--pagesize 2048 \
				--kernel_offset 00008000 \
				--ramdisk_offset 02000000 \
				--tags_offset 01e00000 \
				--dt ./hK-out/pack/dts \
				--output $(pwd)/hK-out/zip/boot.img

echo -n "SEANDROIDENFORCE" >> $(pwd)/hK-out/zip/boot.img

#Zip packing
cp -r $(pwd)/hK-tools/META-INF $(pwd)/hK-out/zip/
sed -i 's/A500xx/A500F/g' $(pwd)/hK-out/zip/META-INF/com/google/android/aroma-config
cp -r $(pwd)/hK-tools/scripts/* $(pwd)/hK-out/zip/hades/
cp -r $(pwd)/hK-tools/*Magisk*.zip $(pwd)/hK-out/zip/hades/magisk.zip
cp -r $(pwd)/hK-tools/*SuperSU*.zip $(pwd)/hK-out/zip/hades/supersu.zip
cd hK-out/zip
zip -r -9 - * > ../../hK-zip/A500F-hadesKernel-v2.4.zip
cd ../../

