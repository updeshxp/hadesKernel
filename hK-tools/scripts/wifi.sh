#!/sbin/sh
if [ -f /system/lib/modules/pronto/pronto_wlan.ko.bkp ]; 
  then
	cp /tmp/hades/hades /system/lib/modules/pronto/pronto_wlan.ko
	chmod 644 /system/lib/modules/pronto/pronto_wlan.ko
  else
	mv /system/lib/modules/pronto/pronto_wlan.ko /system/lib/modules/pronto/pronto_wlan.ko.bkp
	cp /tmp/hades/hades /system/lib/modules/pronto/pronto_wlan.ko
	chmod 644 /system/lib/modules/pronto/pronto_wlan.ko
fi
exit 0
