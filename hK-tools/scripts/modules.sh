#!/sbin/sh
if [ -f /system/lib/modules/pronto/pronto_wlan.ko.bkp ]; 
  then
	mv /system/lib/modules/pronto/pronto_wlan.ko.bkp /system/lib/modules/pronto/pronto_wlan.ko
	chmod 644 /system/lib/modules/pronto/pronto_wlan.ko
fi

if [ -f /system/lib/modules/radio-iris-transport.ko.bkp ]; 
  then
	mv /system/lib/modules/radio-iris-transport.ko.bkp /system/lib/modules/radio-iris-transport.ko
	chmod 644 /system/lib/modules/radio-iris-transport.ko
fi
exit 0
